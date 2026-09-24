import json
from pathlib import Path
import sys
import tempfile
import unittest
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'scripts'))
from unit_report import unit_report, combined_gate


def report(failed=(), lit=()):
    return dict(green=not failed and not lit, problems=len(lit), groups=[dict(tests=[dict(test=t, problem='FAIL') for t in lit])],
                unit=dict(valid=True, tests=['A.x', 'A.y'], failures=[dict(test=t, details=['assertion']) for t in failed]))


class UnitGateTest(unittest.TestCase):
    def test_monotonic_gate(self):
        self.assertIsNone(combined_gate(report(['A.x']), report(), 0))
        self.assertIsNone(combined_gate(report(['A.x'], ['a']), report(['A.x']), 1))
        self.assertIsNone(combined_gate(report(), report(), 0))
        self.assertIsNotNone(combined_gate(report(['A.x']), report(['A.x']), 1))
        self.assertIsNotNone(combined_gate(report(['A.x']), report(['A.y']), 1))
        self.assertIsNotNone(combined_gate(report(['A.x'], ['a']), report(['A.x'], ['b']), 1))
        self.assertIsNotNone(combined_gate(report(), report(), 5))
        after = report(); after['unit']['tests'] = ['A.x']
        self.assertIsNotNone(combined_gate(report(), after, 0))
        before = report(); del before['unit']
        self.assertIsNotNone(combined_gate(before, report(), 0))

    def test_unit_failure_and_missing_and_zero(self):
        with tempfile.TemporaryDirectory() as d:
            p = Path(d)/'unit.json'
            self.assertFalse(unit_report(p, 1)['valid'])
            p.write_text(json.dumps(dict(tests=0, failures=0, testsuites=[])))
            self.assertFalse(unit_report(p, 0)['valid'])
            t = dict(classname='A', name='x', status='RUN', result='COMPLETED', failures=[{'failure':'expected value'}])
            p.write_text(json.dumps(dict(tests=1, failures=1, testsuites=[dict(testsuite=[t])])))
            r = unit_report(p, 1)
            self.assertTrue(r['valid'])
            self.assertEqual(r['failures'][0]['details'], t['failures'])
            self.assertFalse(unit_report(p, 0)['valid'])

    def test_failed_unit_still_emits_lit_report(self):
        from test_harness import py
        with tempfile.TemporaryDirectory() as d:
            d = Path(d)
            (d/'lit.json').write_text(json.dumps({'tests': [{'name': 'LLVM :: x.ll', 'code': 'PASS'}]}))
            (d/'fork.txt').write_text('')
            t = dict(classname='A', name='x', status='RUN', result='COMPLETED', failures=[{'failure': 'diagnostic'}])
            (d/'unit.json').write_text(json.dumps(dict(tests=1, failures=1, testsuites=[dict(testsuite=[t])])))
            r = py('lit_diff.py', '--candidate', str(d/'lit.json'), '--fork-tests', str(d/'fork.txt'),
                   '--unit', str(d/'unit.json'), '--unit-exit', '1', '--out', str(d/'report.json'))
            self.assertEqual(r.returncode, 1, r.stderr)
            result = json.loads((d/'report.json').read_text())
            self.assertFalse(result['green'])
            self.assertEqual(result['problems'], 0)
            self.assertEqual(result['unit']['failures'][0]['details'], t['failures'])

    def test_stale_output_removed_before_command(self):
        # Execute integrate on a synthetic repo using existing harness fixture helpers.
        from test_harness import make_repo, write, commit, py, sh
        with tempfile.TemporaryDirectory() as d:
            repo, base = make_repo(d)
            write(repo, 'llvm/lib/Target/RISCV/RISCVFeatures.td', 'fork\n')
            commit(repo, '[pulp] registration: test')
            sh(repo, 'git', 'checkout', '-b', 'work')
            write(repo, 'llvm/lib/Target/RISCV/RISCVFeatures.td', 'changed\n')
            commit(repo, 'fixup! [pulp] registration: test\n\nChange-Note: 19/X.md\nTask: 19/X')
            sh(repo, 'git', 'checkout', 'main')
            notes = Path(d)/'notes'; (notes/'19').mkdir(parents=True); (notes/'19/X.md').write_text('\n'.join(__import__('policy_check').NOTE_SECTIONS))
            errors = Path(d)/'errors.json'; errors.write_text('{"clusters": []}')
            stale = Path(d)/'work.lit_diff.json'; stale.write_text(json.dumps(report()))
            r = py('integrate.py', '--int-wt', str(repo), '--branch', 'work', '--stack-base', base,
                   '--notes-root', str(notes), '--build-cmd', 'true', '--errors-before', str(errors),
                   '--lit-cmd', 'false', '--out', str(Path(d)/'result.json'))
            self.assertEqual(r.returncode, 1, r.stdout+r.stderr)
            result = json.loads((Path(d)/'result.json').read_text())
            self.assertEqual(result['reason'], 'missing or invalid test report', result)
            self.assertFalse(stale.exists())
            r = py('integrate.py', '--int-wt', str(repo), '--branch', 'work', '--stack-base', base,
                   '--notes-root', str(notes), '--build-cmd', 'false', '--errors-before', str(errors),
                   '--out', str(Path(d)/'result.json'))
            self.assertEqual(r.returncode, 1, r.stdout+r.stderr)
            self.assertEqual(json.loads((Path(d)/'result.json').read_text())['reason'],
                             'build failed without recognized error signatures')
