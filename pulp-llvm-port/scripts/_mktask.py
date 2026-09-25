#!/usr/bin/env python3
# Conductor helper: write tasks/<step>/<id>.md from templates/worker-task.md fields.
# usage: _mktask.py <step> <id> <role> <owner_cluster> <build_targets> <prev_tag> <step_base_tag> <problem-file> [previous-attempts]
import sys, subprocess, pathlib
root = pathlib.Path(__file__).resolve().parent.parent
step, tid, role, owner, targets, prev, base, probf = sys.argv[1:9]
prevatt = sys.argv[9] if len(sys.argv) > 9 else "none"
wt = root / "wt" / f"int-{step}"
import os
head = os.environ.get("INT_HEAD") or subprocess.check_output(["git", "-C", wt, "rev-parse", "HEAD"], text=True).strip()
subj = [s for s in subprocess.check_output(["git", "-C", wt, "log", "--format=%s", f"{base}..HEAD"], text=True).splitlines()
        if s.startswith(f"[pulp] {owner}:")]
subj = subj[0] if subj else f"<find the [pulp] {owner}: subject>"
problem = pathlib.Path(probf).read_text()
out = root / "tasks" / step / f"{tid}.md"
out.parent.mkdir(parents=True, exist_ok=True)
out.write_text(f"""# Task {step}/{tid}

Written by the conductor. One task is one root cause.

- step: {step}
- task_id: {tid}
- role: {role}
- step_base_tag: {base}
- prev_tag: {prev}
- integration_head: {head}
- worktree: {root}/wt/{step}-{tid}
- build_dir: {root}/build/{step}-{tid}
- branch: work/{step}/{tid}
- owner_cluster: {owner}; fixup subject: `fixup! {subj}`
- build_targets: {targets}
- verified leads: {root}/steps/{step}/leads.md
- change note path: {root}/notes/{step}/{tid}.md
- result path: {root}/tasks/{step}/{tid}.result.json
- previous attempts: {prevatt}

## The problem

{problem}

## Procedure

Follow {root}/agent-sops/worker.sop.md with the parameters above.
Path mapping: documents that say /local/home/albsposi/pulp-llvm-port mean {root}. Builds run natively (no container).
""")
print(out)
