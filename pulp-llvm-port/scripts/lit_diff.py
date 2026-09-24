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
import sys
from collections import defaultdict
from pathlib import Path

BAD = {"FAIL", "UNRESOLVED", "TIMEOUT", "XPASS"}
SUITE_PREFIX = {"LLVM": "llvm/test/", "Clang": "clang/test/", "lld": "lld/test/"}


def load(path):
    with open(path) as f:
        data = json.load(f)
    return {t["name"]: t["code"] for t in data["tests"]}


def to_repo_path(name):
    suite, _, rel = name.partition(" :: ")
    return SUITE_PREFIX.get(suite, suite + "/") + rel


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--candidate", required=True)
    ap.add_argument("--baseline")
    ap.add_argument("--fork-tests", required=True)
    ap.add_argument("--known-failures", help="owner-approved list of repo-relative tests that fail at the 18 baseline")
    ap.add_argument("--out")
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

    problems = []
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
    text = json.dumps(report, indent=2)
    if args.out:
        Path(args.out).write_text(text)
    print(json.dumps({k: report[k] for k in ("green", "totals", "problems")}))
    return 0 if report["green"] else 1


if __name__ == "__main__":
    sys.exit(main())
