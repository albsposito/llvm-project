#!/usr/bin/env python3
"""Mechanical policy checks on a worker's commits, run before review and again at integration.

  policy_check.py --repo WT --range BASE..HEAD [--notes-root DIR] [--out report.json]

Exit 0 when there are no FAIL findings (WARN findings go to the reviewer), 1 otherwise.
The rules are the mechanical half of AGENT_RULES.md; the reviewer agent covers the rest.
"""
import argparse
import json
import re
import sys
from pathlib import Path

from common import cluster_of, commit_trailers, git, is_test_path, load_clusters

MAX_CHANGED_LINES_WARN = 400
NOTE_SECTIONS = ("## What upstream changed", "## Why this is equivalent", "## What breaks if this is wrong",
                 "## Upstream reference")
LIT_DIRECTIVE_WEAKEN = re.compile(r"^\+.*\b(XFAIL|UNSUPPORTED|REQUIRES)\s*:")
LIT_RUN = re.compile(r"^-.*\bRUN\s*:")
IF0 = re.compile(r"^\+\s*#\s*if\s+0\b")
COMMENTED_CODE = re.compile(r"^\+\s*//(?!/).*[;{}]\s*$")
FIXUP_SUBJECT = re.compile(r"^fixup! (?P<target>.+)$")


def file_diffs(repo, sha):
    """{path: [diff lines]} for one commit (against its first parent)."""
    out = git(repo, "show", "--format=", "-M", "--unified=0", sha)
    diffs, current = {}, None
    for line in out.splitlines():
        if line.startswith("diff --git "):
            current = line.split(" b/", 1)[1]
            diffs[current] = []
        elif current is not None:
            diffs[current].append(line)
    return diffs


def check_commit(repo, sha, stack_subjects, fork_files, clusters, notes_root):
    findings = []

    def add(level, rule, msg):
        findings.append({"commit": sha[:12], "level": level, "rule": rule, "msg": msg})

    subject = git(repo, "log", "-1", "--format=%s", sha).strip()
    trailers = commit_trailers(repo, sha)
    m = FIXUP_SUBJECT.match(subject)
    if not m:
        add("FAIL", "fixup-subject", f"subject must be 'fixup! <cluster commit subject>', got: {subject!r}")
    elif stack_subjects is not None and m.group("target") not in stack_subjects:
        add("FAIL", "fixup-target", f"fixup target is not a cluster commit in the stack: {m.group('target')!r}")

    note = (trailers.get("Change-Note") or [None])[0]
    if not note:
        add("FAIL", "change-note", "missing 'Change-Note: <path>' trailer")
    elif notes_root:
        p = Path(notes_root) / note
        if not p.is_file():
            add("FAIL", "change-note", f"change note not found: {p}")
        else:
            text = p.read_text()
            missing = [s for s in NOTE_SECTIONS if s not in text]
            if missing:
                add("FAIL", "change-note", f"change note {note} lacks sections: {missing}")

    test_regen = trailers.get("Test-Regen")
    upstream_edit = trailers.get("Upstream-File-Edit")
    changed = 0
    status = {}
    for l in git(repo, "show", "--format=", "--name-status", "-M", sha).splitlines():
        if l:
            parts = l.split("\t")
            status[parts[-1]] = parts[0][0]
    for path, lines in file_diffs(repo, sha).items():
        added = sum(1 for l in lines if l.startswith("+") and not l.startswith("+++"))
        removed = sum(1 for l in lines if l.startswith("-") and not l.startswith("---"))
        changed += added + removed
        if is_test_path(path):
            if status.get(path) == "D":
                add("FAIL", "test-deleted", f"test file deleted: {path}")
            if status.get(path) == "R":
                add("FAIL", "test-renamed", f"test file renamed: {path}")
            if not test_regen:
                add("FAIL", "test-edit", f"test file edited without a 'Test-Regen:' trailer: {path}")
            else:
                add("WARN", "test-edit", f"test file regenerated, reviewer must check the regen report: {path}")
            for l in lines:
                if LIT_DIRECTIVE_WEAKEN.match(l):
                    add("FAIL", "test-weakened", f"adds XFAIL/UNSUPPORTED/REQUIRES in {path}: {l[1:].strip()}")
                if LIT_RUN.match(l):
                    add("FAIL", "test-weakened", f"removes a RUN line in {path}: {l[1:].strip()}")
            continue
        for l in lines:
            if IF0.match(l):
                add("FAIL", "if0", f"adds '#if 0' in {path}")
            elif COMMENTED_CODE.match(l):
                add("WARN", "commented-code", f"adds what looks like commented-out code in {path}: {l[1:].strip()[:100]}")
        if path not in fork_files and cluster_of(path, clusters) is None:
            level = "WARN" if upstream_edit else "FAIL"
            add(level, "upstream-file-edit",
                f"edits upstream file the fork does not own: {path}"
                + ("" if upstream_edit else " (needs an 'Upstream-File-Edit: <reason>' trailer)"))
        if removed > 50 and removed > 2 * added:
            add("FAIL", "large-deletion", f"{path}: -{removed}/+{added}; large deletions of fork code need an escalation")
    if changed > MAX_CHANGED_LINES_WARN:
        add("WARN", "diff-size", f"{changed} changed lines; reviewer must confirm this is one root cause")
    return findings


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--repo", required=True)
    ap.add_argument("--range", required=True, help="BASE..HEAD of the worker's commits")
    ap.add_argument("--notes-root")
    ap.add_argument("--stack-base", help="upstream base of the stack; enables fixup-target checking")
    ap.add_argument("--out")
    args = ap.parse_args()
    clusters = load_clusters()
    base, head = args.range.split("..")
    stack_subjects = None
    fork_files = set()
    if args.stack_base:
        stack_subjects = set(git(args.repo, "log", "--format=%s", f"{args.stack_base}..{base}").splitlines())
        fork_files = set(git(args.repo, "diff", "--name-only", f"{args.stack_base}..{base}").splitlines())
    shas = git(args.repo, "rev-list", "--reverse", f"{base}..{head}").split()
    findings = []
    for sha in shas:
        findings += check_commit(args.repo, sha, stack_subjects, fork_files, clusters, args.notes_root)
    fails = [f for f in findings if f["level"] == "FAIL"]
    report = {"range": args.range, "commits": len(shas), "fail": len(fails),
              "warn": len(findings) - len(fails), "findings": findings}
    text = json.dumps(report, indent=2)
    if args.out:
        Path(args.out).write_text(text)
    print(text)
    return 1 if fails or not shas else 0


if __name__ == "__main__":
    sys.exit(main())
