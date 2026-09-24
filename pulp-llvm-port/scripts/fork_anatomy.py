#!/usr/bin/env python3
"""Fork anatomy: map fork files to clusters, and restack the fork into one commit per cluster.

  fork_anatomy.py map --tsv data/fork-files-18.tsv
  fork_anatomy.py map --repo R --base B --head H
  fork_anatomy.py owner PATH
  fork_anatomy.py restack --repo R --base B --head H --branch NAME

`map` exits 1 if any file is unmapped (every fork file must have exactly one owner).
`restack` builds NAME from B with one commit per cluster (clusters.json order), then
verifies the final tree is byte-identical to H; it deletes NAME and exits 1 otherwise.
"""
import argparse
import json
import os
import sys

from common import changed_files, cluster_of, git, is_test_path, load_clusters


def files_from_tsv(path):
    rows = []
    with open(path) as f:
        next(f)
        for line in f:
            status, add, dele, p = line.rstrip("\n").split("\t")
            rows.append((status[0].upper(), p, int(add), int(dele)))
    return rows


def build_map(rows, clusters):
    result = {c["name"]: [] for c in clusters}
    unmapped = []
    for status, path, *_ in rows:
        owner = cluster_of(path, clusters)
        (result[owner] if owner else unmapped).append(path)
    return result, unmapped


def cmd_map(args, clusters):
    if args.tsv:
        rows = files_from_tsv(args.tsv)
    else:
        rows = [(s, p) for s, p in changed_files(args.repo, args.base, args.head)]
    result, unmapped = build_map(rows, clusters)
    out = {"clusters": result, "unmapped": unmapped,
           "fork_tests": sorted(p for s, p, *_ in rows if is_test_path(p) and s != "D")}
    print(json.dumps(out, indent=2))
    return 1 if unmapped else 0


def cmd_restack(args, clusters):
    repo, base, head, branch = args.repo, args.base, args.head, args.branch
    rows = changed_files(repo, base, head)
    result, unmapped = build_map(rows, clusters)
    if unmapped:
        print(json.dumps({"error": "unmapped files", "unmapped": unmapped}), file=sys.stderr)
        return 1
    deleted = {p for s, p in rows if s == "D"}
    # Build the stack with plumbing on a private index, so no worktree or HEAD is touched.
    parent = git(repo, "rev-parse", base).strip()
    index_path = git(repo, "rev-parse", "--git-path", "restack-index").strip()
    index_env = {"GIT_INDEX_FILE": os.path.join(os.path.abspath(repo), index_path)}
    git(repo, "read-tree", parent, env=index_env)
    for c in clusters:
        paths = result[c["name"]]
        if not paths:
            continue
        for p in paths:
            if p in deleted:
                git(repo, "rm", "--cached", "--quiet", "--", p, env=index_env)
            else:
                blob = git(repo, "rev-parse", f"{head}:{p}").strip()
                mode = git(repo, "ls-tree", head, "--", p).split()[0]
                git(repo, "update-index", "--add", "--cacheinfo", f"{mode},{blob},{p}", env=index_env)
        tree = git(repo, "write-tree", env=index_env).strip()
        msg = f"{c['subject']}\n\nRestacked from {head[:12]} (one commit per cluster).\nCluster: {c['name']}\n"
        parent = git(repo, "commit-tree", tree, "-p", parent, "-m", msg).strip()
    ok = git(repo, "rev-parse", f"{parent}^{{tree}}").strip() == git(repo, "rev-parse", f"{head}^{{tree}}").strip()
    os.remove(index_env["GIT_INDEX_FILE"])
    if not ok:
        print(json.dumps({"error": "restacked tree differs from head"}), file=sys.stderr)
        return 1
    git(repo, "branch", "-f", branch, parent)
    print(json.dumps({"branch": branch, "tip": parent, "tree_identical_to_head": True,
                      "commits": [c["name"] for c in clusters if result[c["name"]]]}, indent=2))
    return 0


def main():
    ap = argparse.ArgumentParser()
    sub = ap.add_subparsers(dest="cmd", required=True)
    m = sub.add_parser("map")
    m.add_argument("--tsv")
    m.add_argument("--repo")
    m.add_argument("--base")
    m.add_argument("--head")
    o = sub.add_parser("owner")
    o.add_argument("path")
    r = sub.add_parser("restack")
    for a in ("--repo", "--base", "--head", "--branch"):
        r.add_argument(a, required=True)
    args = ap.parse_args()
    clusters = load_clusters()
    if args.cmd == "map":
        return cmd_map(args, clusters)
    if args.cmd == "owner":
        print(cluster_of(args.path, clusters) or "UNMAPPED")
        return 0
    return cmd_restack(args, clusters)


if __name__ == "__main__":
    sys.exit(main())
