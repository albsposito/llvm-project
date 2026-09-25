"""Tests for the harness scripts on throwaway git repos and synthetic logs.

Run: python3 -m unittest discover -s tests -v   (from the harness root)
"""
import json
import os
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
SCRIPTS = ROOT / "scripts"
sys.path.insert(0, str(SCRIPTS))


def sh(cwd, *args, check=True, input=None):
    r = subprocess.run(list(args), cwd=cwd, capture_output=True, text=True, input=input)
    if check and r.returncode != 0:
        raise AssertionError(f"{args} failed: {r.stdout}\n{r.stderr}")
    return r


def py(script, *args, cwd=None):
    return subprocess.run([sys.executable, str(SCRIPTS / script), *args], capture_output=True, text=True, cwd=cwd)


def write(repo, path, text):
    p = Path(repo) / path
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(text)


def commit(repo, msg):
    sh(repo, "git", "add", "-A")
    sh(repo, "git", "commit", "-q", "-m", msg)
    return sh(repo, "git", "rev-parse", "HEAD").stdout.strip()


def make_repo(tmp):
    repo = Path(tmp) / "repo"
    repo.mkdir()
    sh(repo, "git", "init", "-q", "-b", "main")
    sh(repo, "git", "config", "user.email", "t@example.com")
    sh(repo, "git", "config", "user.name", "t")
    write(repo, "llvm/lib/Target/RISCV/RISCVISelLowering.cpp", "upstream lowering\n")
    write(repo, "llvm/lib/Target/RISCV/RISCVFeatures.td", "upstream features\n")
    write(repo, "llvm/lib/IR/Core.cpp", "upstream core\n")
    write(repo, "llvm/test/CodeGen/RISCV/add.ll", "; RUN: llc < %s\n; CHECK: add\n")
    base = commit(repo, "upstream base")
    return repo, base


def make_fork(repo):
    """Three fork commits touching four clusters, in an order unrelated to cluster order."""
    write(repo, "llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp", "hwloop pass\n")
    write(repo, "llvm/lib/Target/RISCV/RISCVISelLowering.cpp", "upstream lowering\npulp lowering\n")
    commit(repo, "fix")
    write(repo, "llvm/lib/Target/RISCV/RISCVFeatures.td", "upstream features\nxpulpv2\n")
    write(repo, "llvm/test/CodeGen/RISCV/xpulp-hwloop.ll", "; RUN: llc < %s\n; CHECK: lp.setup\n")
    commit(repo, "more")
    write(repo, "llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp", "hwloop pass v2\n")
    return commit(repo, "fix again")


class ForkAnatomyTest(unittest.TestCase):
    def test_real_fork_file_list_fully_mapped(self):
        r = py("fork_anatomy.py", "map", "--tsv", str(ROOT / "data" / "fork-files-18.tsv"))
        self.assertEqual(r.returncode, 0, r.stdout)
        d = json.loads(r.stdout)
        self.assertEqual(d["unmapped"], [])
        self.assertEqual(sum(len(v) for v in d["clusters"].values()), 124)

    def test_restack_is_tree_identical_and_one_commit_per_cluster(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo, base = make_repo(tmp)
            head = make_fork(repo)
            r = py("fork_anatomy.py", "restack", "--repo", str(repo), "--base", base, "--head", head, "--branch", "stack")
            self.assertEqual(r.returncode, 0, r.stderr)
            out = json.loads(r.stdout)
            self.assertEqual(out["commits"], ["registration", "codegen-core", "passes", "tests"])
            self.assertEqual(sh(repo, "git", "diff", head, "stack").stdout, "")
            subjects = sh(repo, "git", "log", "--format=%s", f"{base}..stack").stdout.split("\n")
            self.assertTrue(all(s.startswith("[pulp] ") for s in subjects if s))
            self.assertEqual(sh(repo, "git", "status", "--porcelain").stdout, "")

    def test_restack_refuses_unmapped_file(self):
        with tempfile.TemporaryDirectory() as tmp:
            repo, base = make_repo(tmp)
            write(repo, "llvm/lib/IR/Core.cpp", "upstream core\nfork hack\n")
            head = commit(repo, "hack")
            r = py("fork_anatomy.py", "restack", "--repo", str(repo), "--base", base, "--head", head, "--branch", "s")
            self.assertEqual(r.returncode, 1)
            self.assertIn("llvm/lib/IR/Core.cpp", r.stderr)


BUILD_LOG = """\
[1/20] Building CXX object lib/Target/RISCV/CMakeFiles/LLVMRISCVCodeGen.dir/PULP/PULPHardwareLoops.cpp.o
FAILED: lib/Target/RISCV/CMakeFiles/LLVMRISCVCodeGen.dir/PULP/PULPHardwareLoops.cpp.o
/p/wt/s19/llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp:120:18: error: no member named 'getDeclaration' in namespace 'llvm::Intrinsic'
  120 |   Intrinsic::getDeclaration(M, ID);
/p/wt/s19/llvm/include/llvm/IR/Intrinsics.h:88:3: note: 'getOrInsertDeclaration' declared here
FAILED: lib/Target/RISCV/CMakeFiles/LLVMRISCVCodeGen.dir/RISCVISelLowering.cpp.o
/p/wt/s19/llvm/lib/Target/RISCV/RISCVISelLowering.cpp:9001:7: error: no member named 'getDeclaration' in namespace 'llvm::Intrinsic'
/p/wt/s19/llvm/lib/Target/RISCV/RISCVISelLowering.h:40:5: error: unknown type name 'PULPThing'
FAILED: lib/Target/RISCV/CMakeFiles/LLVMRISCVCodeGen.dir/RISCVInstrInfo.cpp.o
/p/wt/s19/llvm/lib/Target/RISCV/RISCVISelLowering.h:40:5: error: unknown type name 'PULPThing'
FAILED: bin/llc
ld.lld: error: undefined symbol: llvm::createPULPFixupHwLoops()
>>> referenced by RISCVTargetMachine.cpp
>>>               lib/Target/RISCV/CMakeFiles/LLVMRISCVCodeGen.dir/RISCVTargetMachine.cpp.o:(foo)
FAILED: tools/clang/lib/Sema/CMakeFiles/obj.clangSema.dir/SemaRISCV.cpp.o
ninja: build stopped: cannot make progress due to previously failed targets.
"""


class ClusterErrorsTest(unittest.TestCase):
    def run_log(self, text):
        with tempfile.TemporaryDirectory() as tmp:
            log = Path(tmp) / "b.log"
            log.write_text(text)
            out = Path(tmp) / "c.json"
            r = py("cluster_errors.py", str(log), "--worktree", "/p/wt/s19", "--out", str(out))
            self.assertEqual(r.returncode, 0, r.stderr)
            return {c["key"]: c for c in json.loads(out.read_text())["clusters"]}

    def test_clusters_by_signature_and_dedupes_header_errors(self):
        c = self.run_log(BUILD_LOG)
        rename = c["no member named 'getDeclaration' in namespace 'llvm::Intrinsic'"]
        self.assertEqual(rename["count"], 2)
        self.assertEqual(rename["owners"], ["codegen-core", "passes"])
        self.assertIn("note: 'getOrInsertDeclaration' declared here", rename["samples"][0])
        self.assertEqual(c["unknown type name 'PULPThing'"]["count"], 1)  # same header site, two TUs
        link = c["undefined symbol: llvm::createPULPFixupHwLoops()"]
        self.assertEqual(link["sites"], ["llvm/lib/Target/RISCV/RISCVTargetMachine.cpp"])
        self.assertEqual(link["owners"], ["passes"])
        self.assertEqual(c["unrecognised failure"]["sites"],
                         ["tools/clang/lib/Sema/CMakeFiles/obj.clangSema.dir/SemaRISCV.cpp.o"])


NOTE = """# E001
## What upstream changed
x
## Why this is equivalent
y
## What breaks if this is wrong
z
## Upstream reference
abc123
"""


class PolicyAndIntegrateTest(unittest.TestCase):
    def setUp(self):
        self.tmp = tempfile.TemporaryDirectory()
        self.repo, self.base = make_repo(self.tmp.name)
        head = make_fork(self.repo)
        py("fork_anatomy.py", "restack", "--repo", str(self.repo), "--base", self.base, "--head", head, "--branch", "int")
        sh(self.repo, "git", "checkout", "-q", "int")
        self.notes = Path(self.tmp.name) / "notes"
        (self.notes / "19").mkdir(parents=True)
        (self.notes / "19" / "E001.md").write_text(NOTE)
        self.passes_subject = sh(self.repo, "git", "log", "--format=%s", "--grep=^\\[pulp\\] passes", "int").stdout.strip()

    def tearDown(self):
        self.tmp.cleanup()

    def worker(self, edits, msg):
        sh(self.repo, "git", "checkout", "-q", "-B", "work", "int")
        for path, text in edits.items():
            write(self.repo, path, text)
        commit(self.repo, msg)
        sh(self.repo, "git", "checkout", "-q", "int")

    def policy(self):
        r = py("policy_check.py", "--repo", str(self.repo), "--range", "int..work", "--notes-root", str(self.notes),
               "--stack-base", self.base)
        return r.returncode, {f["rule"] for f in json.loads(r.stdout)["findings"] if f["level"] == "FAIL"}

    def test_good_fixup_passes(self):
        self.worker({"llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp": "hwloop pass v3\n"},
                    f"fixup! {self.passes_subject}\n\nChange-Note: 19/E001.md\n")
        self.assertEqual(self.policy(), (0, set()))

    def test_missing_note_and_bad_subject_fail(self):
        self.worker({"llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp": "x\n"}, "fix stuff")
        rc, rules = self.policy()
        self.assertEqual(rc, 1)
        self.assertEqual(rules, {"fixup-subject", "change-note"})

    def test_test_weakening_if0_and_upstream_edit_fail(self):
        self.worker({"llvm/test/CodeGen/RISCV/xpulp-hwloop.ll": "; XFAIL: *\n; CHECK: lp.setup\n",
                     "llvm/lib/Target/RISCV/RISCVISelLowering.cpp": "upstream lowering\n#if 0\npulp lowering\n",
                     "llvm/lib/IR/Core.cpp": "upstream core\nhack\n"},
                    f"fixup! {self.passes_subject}\n\nChange-Note: 19/E001.md\n")
        rc, rules = self.policy()
        self.assertEqual(rc, 1)
        self.assertEqual(rules, {"test-edit", "test-weakened", "if0", "upstream-file-edit"})

    def integrate(self, build_script, *extra_args):
        (Path(self.tmp.name) / "build.sh").write_text(build_script)
        before = Path(self.tmp.name) / "before.json"
        before.write_text(json.dumps({"clusters": [{"key": "use of undeclared identifier 'foo'"}]}))
        out = Path(self.tmp.name) / "logs" / "r.json"
        args = ["--int-wt", str(self.repo), "--branch", "work", "--stack-base", self.base,
                "--notes-root", str(self.notes), "--build-cmd", f"bash {self.tmp.name}/build.sh {self.repo}",
                "--errors-before", str(before), "--out", str(out), *extra_args]
        r = py("integrate.py", *args)
        return r.returncode, json.loads(out.read_text())

    FAILING = ("grep -q v3 $1/llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp && exit 0\n"
               "echo \"$1/llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp:1:1: error: use of undeclared identifier 'foo'\"\n"
               "exit 1\n")

    def test_landing_a_fix(self):
        self.worker({"llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp": "hwloop pass v3\n"},
                    f"fixup! {self.passes_subject}\n\nChange-Note: 19/E001.md\n")
        head0 = sh(self.repo, "git", "rev-parse", "int").stdout.strip()
        rc, res = self.integrate(self.FAILING)
        self.assertEqual((rc, res["verdict"]), (0, "LANDED"), res)
        self.assertEqual(res["errors_fixed"], ["use of undeclared identifier 'foo'"])
        self.assertNotEqual(sh(self.repo, "git", "rev-parse", "int").stdout.strip(), head0)

    def test_change_that_fixes_nothing_is_rejected_and_rolled_back(self):
        self.worker({"llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp": "hwloop pass v2 tweak\n"},
                    f"fixup! {self.passes_subject}\n\nChange-Note: 19/E001.md\n")
        head0 = sh(self.repo, "git", "rev-parse", "int").stdout.strip()
        rc, res = self.integrate(self.FAILING)
        self.assertEqual(rc, 1)
        self.assertIn("did not shrink", res["reason"])
        self.assertEqual(sh(self.repo, "git", "rev-parse", "int").stdout.strip(), head0)

    def test_new_error_is_rejected(self):
        self.worker({"llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp": "hwloop pass v3\n"},
                    f"fixup! {self.passes_subject}\n\nChange-Note: 19/E001.md\n")
        script = ("echo \"$1/llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp:2:1: error: expected ';'\"\nexit 1\n")
        rc, res = self.integrate(script)
        self.assertEqual(rc, 1)
        self.assertEqual(res["errors_new"], ["expected ';'"])

    # The fix lets the build get further and reach an error that was already there (a masked error).
    UNMASKING = ("grep -q v3 $1/llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp || "
                 "{ echo \"$1/llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp:1:1: error: use of undeclared identifier 'foo'\"; exit 1; }\n"
                 "echo \"$1/llvm/lib/Target/RISCV/RISCVISelLowering.cpp:1:1: error: no member named 'bar'\"\n"
                 "exit 1\n")

    def test_unmasked_error_needs_opt_in_and_is_reported(self):
        self.worker({"llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp": "hwloop pass v3\n"},
                    f"fixup! {self.passes_subject}\n\nChange-Note: 19/E001.md\n")
        rc, res = self.integrate(self.UNMASKING)
        self.assertEqual(rc, 1)
        self.assertEqual(res["errors_new"], ["no member named 'bar'"])
        rc, res = self.integrate(self.UNMASKING, "--allow-unmasked")
        self.assertEqual((rc, res["verdict"]), (0, "LANDED"), res)
        self.assertEqual(res["errors_unmasked"], ["no member named 'bar'"])

    def test_new_error_on_changed_line_is_rejected_even_with_opt_in(self):
        self.worker({"llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp": "hwloop pass v3\n"},
                    f"fixup! {self.passes_subject}\n\nChange-Note: 19/E001.md\n")
        script = ("echo \"$1/llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp:1:1: error: expected ';'\"\nexit 1\n")
        rc, res = self.integrate(script, "--allow-unmasked")
        self.assertEqual(rc, 1)
        self.assertEqual(res["errors_on_changed_lines"], ["expected ';'"])

    def test_policy_failure_blocks_integration(self):
        self.worker({"llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp": "hwloop pass v3\n"}, "no fixup subject")
        rc, res = self.integrate(self.FAILING)
        self.assertEqual((rc, res["reason"]), (1, "policy_check failed"))

    def test_autosquash_keeps_one_commit_per_cluster(self):
        self.worker({"llvm/lib/Target/RISCV/PULP/PULPHardwareLoops.cpp": "hwloop pass v3\n"},
                    f"fixup! {self.passes_subject}\n\nChange-Note: 19/E001.md\n")
        self.integrate(self.FAILING)
        tree = sh(self.repo, "git", "rev-parse", "int^{tree}").stdout.strip()
        env = {**os.environ, "GIT_SEQUENCE_EDITOR": ":"}
        subprocess.run(["git", "rebase", "-q", "-i", "--autosquash", self.base], cwd=self.repo, env=env, check=True,
                       capture_output=True)
        self.assertEqual(sh(self.repo, "git", "rev-parse", "HEAD^{tree}").stdout.strip(), tree)
        subjects = sh(self.repo, "git", "log", "--format=%s", f"{self.base}..HEAD").stdout.split()
        self.assertFalse(any(s.startswith("fixup!") for s in subjects))


class LitDiffTest(unittest.TestCase):
    def run_diff(self, cand, base=None, renames=None):
        with tempfile.TemporaryDirectory() as tmp:
            c = Path(tmp) / "c.json"
            c.write_text(json.dumps({"tests": [{"name": n, "code": k} for n, k in cand.items()]}))
            ft = Path(tmp) / "ft.txt"
            ft.write_text("# comment\nllvm/test/CodeGen/RISCV/xpulp-hwloop.ll\nllvm/test/MC/RISCV/rv32xssr-valid.s\n")
            args = ["--candidate", str(c), "--fork-tests", str(ft), "--out", str(Path(tmp) / "o.json")]
            if base:
                b = Path(tmp) / "b.json"
                b.write_text(json.dumps({"tests": [{"name": n, "code": k} for n, k in base.items()]}))
                args += ["--baseline", str(b)]
            if renames is not None:
                m = Path(tmp) / "renames.json"
                m.write_text(json.dumps(renames))
                args += ["--baseline-renames", str(m)]
            r = py("lit_diff.py", *args)
            return r.returncode, json.loads((Path(tmp) / "o.json").read_text())

    def test_green(self):
        rc, rep = self.run_diff({"LLVM :: CodeGen/RISCV/xpulp-hwloop.ll": "PASS", "LLVM :: MC/RISCV/rv32xssr-valid.s": "PASS",
                                 "LLVM :: CodeGen/RISCV/rvv.ll": "UNSUPPORTED"})
        self.assertEqual((rc, rep["green"]), (0, True))

    def test_silently_skipped_fork_test_and_regression_are_red(self):
        rc, rep = self.run_diff({"LLVM :: CodeGen/RISCV/xpulp-hwloop.ll": "UNSUPPORTED",
                                 "LLVM :: CodeGen/RISCV/add.ll": "XFAIL"},
                                base={"LLVM :: CodeGen/RISCV/add.ll": "PASS"})
        self.assertEqual(rc, 1)
        problems = {p["test"]: p["problem"] for g in rep["groups"] for p in g["tests"]}
        self.assertEqual(problems["llvm/test/CodeGen/RISCV/xpulp-hwloop.ll"], "fork test is UNSUPPORTED, not PASS")
        self.assertEqual(problems["llvm/test/MC/RISCV/rv32xssr-valid.s"], "fork test did not run")
        self.assertEqual(problems["llvm/test/CodeGen/RISCV/add.ll"], "regressed from PASS to XFAIL")

    def test_evidence_backed_rename_and_rejection_cases(self):
        source = "llvm/test/CodeGen/RISCV/old.ll"
        dest = "llvm/test/CodeGen/RISCV/new.ll"
        base = {"LLVM :: CodeGen/RISCV/old.ll": "PASS"}
        cand = {"LLVM :: CodeGen/RISCV/xpulp-hwloop.ll": "PASS",
                "LLVM :: MC/RISCV/rv32xssr-valid.s": "PASS",
                "LLVM :: CodeGen/RISCV/new.ll": "PASS"}
        entry = {"source": source, "destination": dest, "upstream_commit": "a" * 40}
        rc, report = self.run_diff(cand, base, [entry])
        self.assertEqual(rc, 0, report)
        self.assertEqual(report["baseline_renames"], [entry])
        self.assertEqual(self.run_diff(cand, base)[0], 1)
        for code in (None, "FAIL", "UNRESOLVED", "TIMEOUT", "XPASS", "XFAIL", "UNSUPPORTED"):
            with self.subTest(destination=code):
                changed = dict(cand)
                if code is None:
                    del changed["LLVM :: CodeGen/RISCV/new.ll"]
                else:
                    changed["LLVM :: CodeGen/RISCV/new.ll"] = code
                rc, report = self.run_diff(changed, base, [entry])
                self.assertEqual(rc, 1)
                self.assertTrue(report["mapping_errors"])
                if code == "FAIL":
                    self.assertTrue(any(t["problem"] == "FAIL" for g in report["groups"] for t in g["tests"]))
        for entries in ([entry, entry], [entry, {**entry, "source": source + "2"}],
                        [{**entry, "upstream_commit": "missing"}],
                        [{**entry, "source": dest}], ["invalid"]):
            with self.subTest(entries=entries):
                self.assertTrue(self.run_diff(cand, base, entries)[1]["mapping_errors"])
        present = {**cand, "LLVM :: CodeGen/RISCV/old.ll": "FAIL"}
        self.assertEqual(self.run_diff(present, base, [entry])[0], 1)
        unrelated = {**cand, "LLVM :: CodeGen/RISCV/other.ll": "FAIL"}
        self.assertEqual(self.run_diff(unrelated, base, [entry])[0], 1)
        # Baseline identity mapping never waives the fork inventory requirement.
        fork_entry = {**entry, "source": "llvm/test/CodeGen/RISCV/xpulp-hwloop.ll"}
        missing_fork = dict(cand)
        del missing_fork["LLVM :: CodeGen/RISCV/xpulp-hwloop.ll"]
        rc, report = self.run_diff(missing_fork, {"LLVM :: CodeGen/RISCV/xpulp-hwloop.ll": "PASS"}, [fork_entry])
        self.assertEqual(rc, 1)
        self.assertTrue(any(t["problem"] == "fork test did not run" for g in report["groups"] for t in g["tests"]))


DIS_REF = """
00000000 <gemm>:
       0: 0b 00 00 00   lp.setup  x0, a0, 16
       4: 57 00 00 00   pv.add.b  a1, a2, a3
       8: 57 00 00 00   pv.add.b  a1, a2, a3
       c: 0b 00 00 00   p.lw      a4, 4(a5!)
"""
DIS_SCALARISED = """
00000000 <gemm>:
       0: 33 00 00 00   add  a1, a2, a3
       4: 33 00 00 00   add  a1, a2, a3
       8: 57 00 00 00   pv.add.b  a1, a2, a3
       c: 0b 00 00 00   p.lw      a4, 4(a5!)
"""


class MixDiffTest(unittest.TestCase):
    def test_dead_family_fails_and_moved_family_flags(self):
        with tempfile.TemporaryDirectory() as tmp:
            (Path(tmp) / "r").write_text(DIS_REF)
            (Path(tmp) / "c").write_text(DIS_SCALARISED)
            r = py("mix_diff.py", str(Path(tmp) / "r"), str(Path(tmp) / "c"))
            self.assertEqual(r.returncode, 1)
            v = {f["family"]: f["verdict"] for f in json.loads(r.stdout)["families"]}
            self.assertEqual(v, {"hwloop": "FAIL", "packed-simd": "FLAG", "post-increment": "OK"})


if __name__ == "__main__":
    unittest.main()
