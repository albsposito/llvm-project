#!/usr/bin/env python3
"""Integration queue: land one reviewed worker branch onto the step's integration branch.

  integrate.py --int-wt WT --branch work/19/E004 --stack-base TAG --notes-root DIR
               --build-cmd "scripts/build.sh WT BUILD" --errors-before before.json
               [--lit-cmd "... {diff_out}"] [--lit-before lit_diff.json] --out result.json

--lit-cmd must write a lit_diff.py report to the path substituted for {diff_out}.

Order of checks (first failure wins, and the integration branch is restored to where it was):
  1. policy_check on the worker's commits (merge-base..branch)
  2. cherry-pick onto the integration HEAD (a conflict means the worker must rebase)
  3. build: the set of error signatures must not grow, and must shrink
     (a change that fixes nothing is rejected as noise)
  4. optional lit: the number of lit problems must not grow
Only the harness-owned integration worktree is ever reset; worker branches are untouched.
"""
import argparse
import json
import subprocess
import sys
from pathlib import Path

from common import git

HERE = Path(__file__).resolve().parent


def run(cmd, log):
    with open(log, "w") as f:
        return subprocess.run(cmd, shell=True, stdout=f, stderr=subprocess.STDOUT).returncode


def error_keys(log, wt):
    out = Path(log).with_suffix(".clusters.json")
    subprocess.run([sys.executable, str(HERE / "cluster_errors.py"), str(log), "--worktree", wt, "--out", str(out)],
                   capture_output=True, check=True)
    return {c["key"] for c in json.loads(out.read_text())["clusters"]}


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--int-wt", required=True)
    ap.add_argument("--branch", required=True)
    ap.add_argument("--stack-base", required=True)
    ap.add_argument("--notes-root", required=True)
    ap.add_argument("--build-cmd", required=True)
    ap.add_argument("--errors-before", required=True, help="cluster_errors JSON of the integration HEAD")
    ap.add_argument("--lit-cmd")
    ap.add_argument("--lit-before", help="lit_diff JSON of the integration HEAD")
    ap.add_argument("--out", required=True)
    args = ap.parse_args()
    wt = args.int_wt
    head0 = git(wt, "rev-parse", "HEAD").strip()
    result = {"branch": args.branch, "int_head_before": head0}
    logdir = Path(args.out).parent
    logdir.mkdir(parents=True, exist_ok=True)
    tag = args.branch.replace("/", "_")

    def finish(verdict, **kw):
        if verdict != "LANDED":
            git(wt, "cherry-pick", "--abort", check=False)
            git(wt, "reset", "--hard", head0)
        result.update(verdict=verdict, int_head_after=git(wt, "rev-parse", "HEAD").strip(), **kw)
        Path(args.out).write_text(json.dumps(result, indent=2))
        print(json.dumps(result))
        return 0 if verdict == "LANDED" else 1

    if git(wt, "status", "--porcelain").strip():
        return finish("REJECTED", reason="integration worktree is dirty; conductor must clean it first")

    mb = git(wt, "merge-base", head0, args.branch).strip()
    policy_out = logdir / f"{tag}.policy.json"
    pol = subprocess.run([sys.executable, str(HERE / "policy_check.py"), "--repo", wt, "--range", f"{mb}..{args.branch}",
                          "--notes-root", args.notes_root, "--stack-base", args.stack_base, "--out", str(policy_out)],
                         capture_output=True, text=True)
    if pol.returncode != 0:
        return finish("REJECTED", reason="policy_check failed", policy=str(policy_out))

    commits = git(wt, "rev-list", "--reverse", f"{mb}..{args.branch}").split()
    res = git(wt, "cherry-pick", *commits, check=False)
    if res.returncode != 0:
        return finish("REJECTED", reason="cherry-pick conflict; worker must rebase onto the current integration HEAD",
                      detail=res.stderr.strip()[-2000:])

    build_log = logdir / f"{tag}.build.log"
    rc = run(args.build_cmd, build_log)
    before = {c["key"] for c in json.loads(Path(args.errors_before).read_text())["clusters"]}
    after = error_keys(build_log, wt) if rc != 0 else set()
    new = sorted(after - before)
    fixed = sorted(before - after)
    result.update(build_rc=rc, errors_fixed=fixed, errors_new=new, build_log=str(build_log))
    if new:
        return finish("REJECTED", reason="build introduced new error signatures")
    if before and not fixed:
        return finish("REJECTED", reason="build error set did not shrink; change fixes nothing it claims to")

    if args.lit_cmd:
        lit_log = logdir / f"{tag}.lit.log"
        lit_json = logdir / f"{tag}.lit_diff.json"
        run(args.lit_cmd.format(diff_out=lit_json), lit_log)
        if not lit_json.exists():
            return finish("REJECTED", reason="lit command produced no lit_diff report", lit_log=str(lit_log))
        a = json.loads(lit_json.read_text())["problems"]
        b = json.loads(Path(args.lit_before).read_text())["problems"] if args.lit_before else None
        result.update(lit_problems_before=b, lit_problems_after=a, lit_diff=str(lit_json))
        if b is not None and a > b:
            return finish("REJECTED", reason="lit problems increased")
        if b and a == b:
            return finish("REJECTED", reason="lit problems did not shrink; change fixes nothing it claims to")
    return finish("LANDED", commits=commits)


if __name__ == "__main__":
    sys.exit(main())
