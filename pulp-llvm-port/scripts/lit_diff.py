#!/usr/bin/env python3
"""Compare a candidate lit run against the previous green baseline.

  lit_diff.py --candidate cand.json [--baseline base.json] --fork-tests data/fork-tests.txt [--out r.json]

Inputs are lit's `-o/--output` JSON ({"tests": [{"name": "LLVM :: CodeGen/RISCV/x.ll", "code": "PASS"}]}).
Green means all of:
  - no test in FAIL/UNRESOLVED/TIMEOUT/XPASS, except tests in --known-failures (tests that
    already fail at the LLVM 18 baseline, listed once in Phase 0 and approved by the owner)
  - every fork test is present and PASS (a fork test that is missing, UNSUPPORTED or XFAIL is
    not running, which is how a port silently loses coverage)
  - no test that PASSed in the baseline is now anything other than PASS
Exit 0 when green, 1 otherwise. Failures are grouped by test directory for task clustering.
"""
import argparse
import json
import re
import sys
from collections import defaultdict
from pathlib import Path

from unit_report import unit_report

BAD = {"FAIL", "UNRESOLVED", "TIMEOUT", "XPASS"}
SUITE_PREFIX = {"LLVM": "llvm/test/", "Clang": "clang/test/", "lld": "lld/test/"}


def load(path):
    with open(path) as f:
        data = json.load(f)
    return {t["name"]: t["code"] for t in data["tests"]}


def to_repo_path(name):
    suite, _, rel = name.partition(" :: ")
    return SUITE_PREFIX.get(suite, suite + "/") + rel


def load_renames(path, base, candidate):
    """Explicit upstream identity changes, only for absent baseline PASS tests.

    JSON is a list of {source, destination, upstream_commit} objects using repo
    paths and full upstream SHA-1s. Evidence is reviewed separately; the hash is
    retained in the report so a passing comparison remains auditable.
    """
    entries = json.loads(Path(path).read_text())
    if not isinstance(entries, list):
        raise ValueError("baseline renames must be a list")
    sources, destinations = set(), set()
    baseline = {to_repo_path(n): c for n, c in base.items()}
    for entry in entries:
        if not isinstance(entry, dict):
            raise ValueError("baseline rename must be an object")
        src, dst, sha = (entry.get(k) for k in ("source", "destination", "upstream_commit"))
        if not all(isinstance(v, str) and v for v in (src, dst, sha)):
            raise ValueError("rename requires source, destination and upstream_commit")
        if not re.fullmatch(r"[0-9a-f]{40}", sha):
            raise ValueError(f"rename {src}: upstream_commit must be a full SHA-1")
        if src in sources or dst in destinations or src == dst:
            raise ValueError(f"duplicate or self rename: {src} -> {dst}")
        sources.add(src)
        destinations.add(dst)
        if baseline.get(src) != "PASS":
            raise ValueError(f"rename source is not a baseline PASS: {src}")
        if src in candidate:
            raise ValueError(f"rename source still exists in candidate: {src}")
        if candidate.get(dst) != "PASS":
            raise ValueError(f"rename destination must PASS: {dst} ({candidate.get(dst, 'MISSING')})")
    if sources & destinations:
        raise ValueError("chained baseline renames are ambiguous")
    return entries


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--candidate", required=True)
    ap.add_argument("--baseline")
    ap.add_argument("--fork-tests", required=True)
    ap.add_argument("--known-failures", help="owner-approved list of repo-relative tests that fail at the 18 baseline")
    ap.add_argument("--baseline-renames", help="reviewed JSON upstream test identities with provenance SHA-1s")
    ap.add_argument("--out")
    ap.add_argument("--unit", help="gtest JSON; required for integration gate")
    ap.add_argument("--unit-exit", type=int)
    args = ap.parse_args()
    cand = load(args.candidate)
    base = load(args.baseline) if args.baseline else {}
    known = set()
    if args.known_failures and Path(args.known_failures).exists():
        known = {l.split()[0] for l in Path(args.known_failures).read_text().splitlines()
                 if l.strip() and not l.startswith("#")}
    by_path = {to_repo_path(n): code for n, code in cand.items()}
    fork_tests = [l.strip() for l in Path(args.fork_tests).read_text().splitlines()
                  if l.strip() and "/test/" in l and not l.startswith("#") and l.strip() not in known]

    renames = []
    mapping_errors = []
    if args.baseline_renames:
        try:
            renames = load_renames(args.baseline_renames, base, by_path)
        except (OSError, ValueError, TypeError) as exc:
            mapping_errors.append(str(exc))
    renamed = {entry["source"]: entry["destination"] for entry in renames}
    problems = []
    for error in mapping_errors:
        problems.append({"test": "harness/baseline-renames", "problem": error})
    for name, code in cand.items():
        if code in BAD and to_repo_path(name) not in known:
            problems.append({"test": to_repo_path(name), "problem": code})
    for t in fork_tests:
        code = by_path.get(t)
        if code is None:
            problems.append({"test": t, "problem": "fork test did not run"})
        elif code != "PASS" and code not in BAD:
            problems.append({"test": t, "problem": f"fork test is {code}, not PASS"})
    for name, code in base.items():
        new = cand.get(name, "MISSING")
        if new == "MISSING" and to_repo_path(name) in renamed:
            new = by_path[renamed[to_repo_path(name)]]
        if code == "PASS" and new != "PASS" and new not in BAD:
            problems.append({"test": to_repo_path(name), "problem": f"regressed from PASS to {new}"})

    groups = defaultdict(list)
    for p in problems:
        groups[str(Path(p["test"]).parent)].append(p)
    counts = defaultdict(int)
    for code in cand.values():
        counts[code] += 1
    report = {"green": not problems, "totals": dict(counts), "problems": len(problems),
              "groups": [{"dir": d, "count": len(ps), "tests": ps} for d, ps in
                         sorted(groups.items(), key=lambda kv: -len(kv[1]))]}
    if args.baseline_renames:
        report["baseline_renames"] = renames
        report["mapping_errors"] = mapping_errors
    if args.unit:
        report["unit"] = unit_report(args.unit, args.unit_exit)
        report["green"] = report["green"] and report["unit"]["valid"] and not report["unit"]["failures"]
    text = json.dumps(report, indent=2)
    if args.out:
        Path(args.out).write_text(text)
    print(json.dumps({k: report[k] for k in ("green", "totals", "problems")}))
    return 0 if report["green"] else 1


if __name__ == "__main__":
    sys.exit(main())
