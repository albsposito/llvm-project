"""Shared helpers for the port harness scripts: config, cluster map, git."""
import json
import os
import re
import subprocess
from pathlib import Path

HARNESS_ROOT = Path(__file__).resolve().parent.parent
CLUSTERS_FILE = HARNESS_ROOT / "data" / "clusters.json"

TEST_PREFIXES = ("llvm/test/", "clang/test/", "lld/test/")
UNITTEST_PREFIXES = ("llvm/unittests/", "clang/unittests/")


def load_clusters(path=CLUSTERS_FILE):
    with open(path) as f:
        data = json.load(f)
    clusters = []
    for c in data["clusters"]:
        clusters.append({**c, "_re": [re.compile(p) for p in c["patterns"]]})
    return clusters


def cluster_of(path, clusters):
    """Return the cluster name owning a repo-relative path, or None."""
    for c in clusters:
        if any(r.search(path) for r in c["_re"]):
            return c["name"]
    return None


def is_test_path(path):
    return path.startswith(TEST_PREFIXES) or path.startswith(UNITTEST_PREFIXES)


def git(repo, *args, check=True, env=None):
    """Run git in repo and return stdout (str). Raises on failure when check."""
    full_env = None
    if env:
        full_env = {**os.environ, **env}
    res = subprocess.run(["git", "-C", str(repo), *args], capture_output=True, text=True, env=full_env)
    if check and res.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} failed ({res.returncode}): {res.stderr.strip()}")
    return res.stdout if check else res


def changed_files(repo, base, head):
    """[(status, path)] for base..head, rename-aware (status R keeps new path)."""
    out = git(repo, "diff", "--name-status", "-M", f"{base}..{head}")
    rows = []
    for line in out.splitlines():
        parts = line.split("\t")
        status = parts[0][0]
        rows.append((status, parts[-1]))
    return rows


def commit_trailers(repo, sha):
    """Parse 'Key: value' trailers of a commit into a dict of lists."""
    msg = git(repo, "log", "-1", "--format=%B", sha)
    res = subprocess.run(["git", "-C", str(repo), "interpret-trailers", "--parse"],
                         input=msg, capture_output=True, text=True)
    trailers = {}
    for line in res.stdout.splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            trailers.setdefault(k.strip(), []).append(v.strip())
    return trailers
