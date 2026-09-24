# Port Worker

## Overview

Fix one root cause (one build error cluster or one failing test group) of one PULP LLVM port step, in an isolated worktree, and leave a reviewable, explained commit on a work branch. Used by subagents the conductor dispatches from `port-step.sop.md`. The worker never lands its own change; the conductor does that after an independent review.

## Parameters

- **task_file** (required): absolute path of the task file under `/local/home/albsposi/pulp-llvm-port/tasks/<N>/<task-id>.md`, filled from `templates/worker-task.md`. It carries every other value (step, tags, worktree, branch, owner cluster, build targets, result path).

**Constraints for parameter acquisition:**
- If all required parameters are already provided, You MUST proceed to the Steps
- If any required parameters are missing, You MUST ask for them before proceeding
- When asking for parameters, You MUST request all parameters in a single prompt
- When asking for parameters, You MUST use the exact parameter names as defined

## Steps

### 1. Load rules and task

Read the rules, the task, and the verified leads for the step.

**Constraints:**
- You MUST read `/local/home/albsposi/pulp-llvm-port/AGENT_RULES.md` in full before anything else, because the rules decide whether your work lands
- You MUST read the task file and `steps/<N>/leads.md`, and `PORTING.md` sections 3, 5 and 8
- You MUST NOT read `PORTING.md` section 4 as fact, because it holds unverified leads; use `steps/<N>/leads.md`
- You MUST source `/local/home/albsposi/pulp-llvm-port/config.env` in every shell you use

### 2. Create the worktree and reproduce

Create your worktree from the integration head and reproduce the problem with the task's build targets.

**Constraints:**
- You MUST run `scripts/wt.sh new <N>-<task-id> work/<N>/<task-id> <integration_head>` unless the worktree already exists (a retried task), in which case you MUST reuse it and rebase it onto the task's `integration_head`
- You MUST reproduce with `scripts/build.sh <worktree> <build_dir> $JOBS_PER_BUILD <build_targets>` (or `scripts/lit.sh` limited to the failing tests for a test task) and save the output under `logs/<N>-<task-id>.repro.log`
- If the problem does not reproduce, You MUST write `status: not-reproduced` with the log path to the result file and stop, because the integration head may already contain the fix
- You MUST run builds longer than a few minutes with `scripts/wt.sh detach` and poll `scripts/wt.sh status`, because a blocking call can time out your session

### 3. Find the upstream cause

Identify the upstream commit that caused the break and how upstream handles the equivalent case now.

**Constraints:**
- You MUST find the causing upstream commit with `git log -S`, `-G` or `--follow` limited to `<prev_tag>..<step_base_tag>` in `$LLVM_SRC` (PORTING.md section 5)
- You MUST NOT search history without a range, because LLVM history is too large to scan
- You MUST look for an upstream reference implementation (CORE-V `XCV*`, other vendor extensions) when the fix is more than a rename
- If you cannot identify the causing commit, You MUST escalate (step 6) instead of guessing

### 4. Fix and verify

Make the smallest change that removes the problem, then rebuild the task's targets.

**Constraints:**
- You MUST change only files owned by the task's `owner_cluster`, unless the root cause spans clusters, in which case You MUST make one commit per owning cluster, each with its own fixup subject
- You MUST follow every rule in AGENT_RULES.md; in particular You MUST NOT touch test files unless your role is `test-regen`, because tests are the oracle that judges your change
- You MUST rebuild the task's targets and run `scripts/cluster_errors.py <log> --worktree <worktree>` on the new log; the task's signature MUST be gone and no new signature MUST appear in the files you touched
- For a test task You MUST rerun the failing tests with `<build_dir>/bin/llvm-lit -v <tests>` and they MUST pass
- If two attempts leave the signature unchanged, You MUST escalate (step 6), because a third guess is how wrong fixes land

### 5. Commit, note, self-check

Commit with the required subject and trailers, write the change note, and run the policy check yourself.

**Constraints:**
- You MUST write the change note at the task's change note path from `templates/change-note.md` (and a regen report from `templates/regen-report.md` for `test-regen`)
- You MUST commit with subject `fixup! <exact cluster commit subject>` and trailers `Change-Note: <N>/<task-id>.md`, `Task: <N>/<task-id>`, plus `Test-Regen:` or `Upstream-File-Edit:` when they apply
- You MUST run `scripts/policy_check.py --repo <worktree> --range <integration_head>..work/<N>/<task-id> --notes-root notes --stack-base <step_base_tag>` and fix every FAIL before finishing
- You MUST NOT push, because only the conductor publishes branches

### 6. Write the result file

Record the outcome for the conductor. This is the only output the conductor reads.

**Constraints:**
- You MUST write JSON to the task's result path with keys: `status` (`done`, `escalated`, `not-reproduced`, `blocked`), `branch`, `commits` (list of sha), `note` (change note path), `signature_gone` (bool), `other_errors_seen` (list of signatures you noticed and did not fix), `question` and `evidence` (only when escalated)
- You MUST keep your final chat message to one line naming the status and the result path, because the conductor reads the file, not the message

## Examples

### Example 1: rename

**Input:** task_file `tasks/20/E003.md`, signature `no member named 'getDeclaration' in namespace 'llvm::Intrinsic'`, 7 sites in `passes`.

**Expected behaviour:** `git log -S'getOrInsertDeclaration' <prev_tag>..<step_base_tag> -- llvm/include/llvm/IR` finds the rename commit; the worker renames 7 call sites, rebuilds `LLVMRISCVCodeGen`, commits `fixup! [pulp] passes: ...` with a short note citing the commit, result `done`.

### Example 2: relocation

**Input:** task_file `tasks/19/E001.md`, the fork's extension entries in `lib/Support/RISCVISAInfo.cpp` have nowhere to go.

**Expected behaviour:** `git log --follow` shows the file moved to `lib/TargetParser` and the table became generated from `RISCVFeatures.td`; the worker ports the entries as `RISCVExtension` records following how `XCV*` is declared, in a `fixup! [pulp] registration: ...` commit, and names `RISCVFeatures.td:<line>` for XCV as the reference.

## Troubleshooting

### Build fails for reasons unrelated to the task
Another cluster's errors can stop your targets from linking. Build a narrower target (the object library, for example `LLVMRISCVCodeGen`), and list the other signatures in `other_errors_seen`; do not fix them.

### Rebase onto a new integration head conflicts
Resolve only within your own change; if the conflict is with a different cluster's landed fix, set `status: blocked` with the conflicting commit, because the conductor must decide the order.
