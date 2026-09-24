#!/usr/bin/env python3
"""Cluster a build log's errors by root-cause signature.

  cluster_errors.py BUILD_LOG --worktree WT [--out clusters.json]

Recognises compiler / TableGen diagnostics (`file:line:col: error: msg`), lld undefined
symbols, CMake errors, and ninja FAILED lines with no diagnostic. The signature is the
message with paths, line numbers and numeric literals removed but identifiers kept, so
"no member named 'getDeclaration' in namespace 'llvm::Intrinsic'" in 40 files becomes one
cluster with 40 sites. Duplicate diagnostics (the same header error reported by many
translation units) are counted once per site. Each cluster lists the fork clusters that
own its sites, which tells the conductor which cluster commit the fix belongs to.
"""
import argparse
import json
import re
import sys
from pathlib import Path

from common import cluster_of, load_clusters

DIAG = re.compile(r"^(?P<file>[^\s:][^:]*):(?P<line>\d+):(?:(?P<col>\d+):)?\s+(?P<kind>error|fatal error):\s+(?P<msg>.*)$")
NOTE = re.compile(r"^[^\s:][^:]*:\d+:(?:\d+:)?\s+note:\s+")
LLD_UNDEF = re.compile(r"(?:ld\.lld|lld|ld): error: undefined symbol: (?P<sym>.*)$")
# lld prints the object as <build-subdir>/CMakeFiles/<target>.dir/<source>.o
OBJ_PATH = re.compile(r"(?:^|[\s(])(?P<dir>[\w./+-]*?)/?CMakeFiles/[^/\s]+\.dir/(?P<src>[^\s:]+?)\.o\b")
CMAKE_ERR = re.compile(r"^CMake Error at (?P<file>[^:]+):(?P<line>\d+)")
NINJA_FAILED = re.compile(r"^FAILED: (?P<target>.*)$")


def obj_to_source(m):
    """Map an object path in the LLVM build tree back to a repo-relative source path."""
    d = m.group("dir").lstrip("./")
    rel = f"{d}/{m.group('src')}" if d else m.group("src")
    for build_prefix, repo_prefix in (("tools/clang/", "clang/"), ("tools/lld/", "lld/")):
        if rel.startswith(build_prefix):
            return repo_prefix + rel[len(build_prefix):]
    return "llvm/" + rel


def normalise(msg):
    msg = re.sub(r"(/[\w.+-]+)+", "<path>", msg)
    msg = re.sub(r"\b\d+\b", "N", msg)
    msg = re.sub(r"\s+\[-W[\w-]+\]$", "", msg)
    return msg.strip()


def relpath(path, worktree):
    p = path.strip()
    if worktree:
        wt = str(Path(worktree).resolve()) + "/"
        if p.startswith(wt):
            return p[len(wt):]
    # Build logs often print paths relative to the build dir: strip leading ../ segments
    # and anything before a known top-level LLVM project directory.
    m = re.search(r"(?:^|/)((?:llvm|clang|lld|mlir|compiler-rt)/.*)$", p)
    return m.group(1) if m else p


def parse(lines, worktree):
    clusters = {}
    seen_sites = set()
    failed_targets = []
    diag_after_failed = False
    i = 0
    while i < len(lines):
        line = lines[i].rstrip("\n")
        m = DIAG.match(line)
        if m:
            diag_after_failed = True
            file_rel = relpath(m.group("file"), worktree)
            key = normalise(m.group("msg"))
            context = [line]
            j = i + 1
            while j < len(lines) and len(context) < 8 and (NOTE.match(lines[j]) or lines[j].startswith(" ")):
                context.append(lines[j].rstrip("\n"))
                j += 1
            site = (key, file_rel, m.group("line"))
            if site not in seen_sites:
                seen_sites.add(site)
                c = clusters.setdefault(key, {"key": key, "kind": "compile", "sites": [], "samples": []})
                c["sites"].append(f"{file_rel}:{m.group('line')}")
                if len(c["samples"]) < 3:
                    c["samples"].append("\n".join(context))
            i = j
            continue
        m = LLD_UNDEF.search(line)
        if m:
            diag_after_failed = True
            key = f"undefined symbol: {m.group('sym').strip()}"
            where = []
            j = i + 1
            while j < len(lines) and lines[j].lstrip().startswith(">>>"):
                obj = OBJ_PATH.search(lines[j])
                if obj:
                    where.append(obj_to_source(obj))
                j += 1
            c = clusters.setdefault(key, {"key": key, "kind": "link", "sites": [], "samples": []})
            for site in where or ["<unknown>"]:
                if site not in c["sites"]:
                    c["sites"].append(site)
            if len(c["samples"]) < 3:
                c["samples"].append("\n".join(l.rstrip("\n") for l in lines[i:j]))
            i = j
            continue
        m = CMAKE_ERR.match(line)
        if m:
            diag_after_failed = True
            key = f"cmake: {normalise(lines[i + 1]) if i + 1 < len(lines) else line}"
            c = clusters.setdefault(key, {"key": key, "kind": "cmake", "sites": [], "samples": []})
            c["sites"].append(f"{relpath(m.group('file'), worktree)}:{m.group('line')}")
            c["samples"].append("".join(lines[i:i + 6]))
            i += 1
            continue
        m = NINJA_FAILED.match(line)
        if m:
            if failed_targets and not diag_after_failed:
                # previous FAILED produced no recognised diagnostic
                clusters.setdefault("unrecognised failure", {"key": "unrecognised failure", "kind": "other",
                                                             "sites": [], "samples": []})["sites"].append(failed_targets[-1])
            failed_targets.append(m.group("target"))
            diag_after_failed = False
        i += 1
    if failed_targets and not diag_after_failed:
        clusters.setdefault("unrecognised failure", {"key": "unrecognised failure", "kind": "other",
                                                     "sites": [], "samples": []})["sites"].append(failed_targets[-1])
    return list(clusters.values()), failed_targets


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("log")
    ap.add_argument("--worktree")
    ap.add_argument("--out")
    args = ap.parse_args()
    with open(args.log, errors="replace") as f:
        lines = f.readlines()
    fork = load_clusters()
    clusters, failed = parse(lines, args.worktree)
    for c in clusters:
        owners = sorted({cluster_of(s.rsplit(":", 1)[0], fork) or "upstream" for s in c["sites"]})
        c["owners"] = owners
        c["count"] = len(c["sites"])
    clusters.sort(key=lambda c: (-c["count"], c["key"]))
    for n, c in enumerate(clusters, 1):
        c["id"] = f"E{n:03d}"
    report = {"log": args.log, "failed_targets": len(failed), "clusters": clusters}
    text = json.dumps(report, indent=2)
    if args.out:
        Path(args.out).write_text(text)
    print(json.dumps({"failed_targets": len(failed), "clusters": len(clusters),
                      "top": [(c["id"], c["count"], c["owners"], c["key"][:120]) for c in clusters[:15]]}, indent=1))
    return 0


if __name__ == "__main__":
    sys.exit(main())
