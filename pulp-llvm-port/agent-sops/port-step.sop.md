# Port Step Conductor

## Overview

Move the PULP LLVM fork from one upstream LLVM release to the next (one "step", e.g. 18 to 19) and stop at a green, tagged checkpoint for the owner to review. The main Kiro session runs this as the conductor: it owns the integration worktree, delegates every code change to worker, reviewer and conflict-resolver subagents, and lands changes one at a time through `scripts/integrate.py`. One run of this SOP is one step; the owner's review between steps is the human gate.

## Parameters

- **step** (required): target LLVM major version, one of `19`, `20`, `21`, `22`, `23`.
- **prev_branch** (optional, default: "port/<step-1>"): green stack to move, e.g. `port/18` for step 19.
- **prev_base** (optional, default: the upstream base `prev_branch` sits on): for step 19 this is `PULP_18_MERGE_BASE` from `config.env`; later, the previous step's `step_base_tag`.

**Constraints for parameter acquisition:**
- If all required parameters are already provided, You MUST proceed to the Steps
- If any required parameters are missing, You MUST ask for them before proceeding
- When asking for parameters, You MUST request all parameters in a single prompt
- When asking for parameters, You MUST use the exact parameter names as defined
- You MUST refuse to start if `PROGRESS.md` does not show the previous step as green and owner-approved, because every step builds on the previous checkpoint

## Steps

### 1. Resume and verify leads

Re-establish state, resolve the step base, and turn the unverified leads into a verified list.

**Constraints:**
- You MUST read `AGENT_RULES.md`, `PORTING.md` and `PROGRESS.md`, and call `session_ledger_read`; if the ledger shows this step in progress You MUST resume from its `next` field instead of restarting, because steps 2 to 5 are not idempotent
- You MUST resolve `step_base_tag` with `scripts/wt.sh latest-tag <step>` (for step 22 You MUST use `llvmorg-22.1.7`, PORTING.md section 2) and record it in `PROGRESS.md` and the ledger
- If `steps/<step>/leads.md` does not exist, You MUST dispatch one subagent with `spawn_run` to verify every PORTING.md section 4 lead for this step against the release notes at `step_base_tag` and the upstream commit, add any RISC-V backend, MC, TableGen or Clang Sema/Parse change the notes list that the table missed, and write `steps/<step>/leads.md` with one row per lead: `verified | false | not found`, commit hash, one-line effect on the fork; You MUST end your turn after dispatching, because the release notes are too large for your context
- You MUST record `phase: leads` with `session_ledger_record` at the start of this step

### 2. Apply the stack

Create the integration worktree on the new base and cherry-pick the cluster stack onto it, resolving conflicts one at a time.

**Constraints:**
- You MUST run `scripts/wt.sh new int-<step> port/<step> <step_base_tag>` and then `git -C wt/int-<step> cherry-pick <prev_base>..<prev_branch>`
- On each pause for a conflict You MUST dispatch exactly one subagent with `spawn_run` running `agent-sops/conflict-resolver.sop.md`, end your turn, and on completion check `git -C wt/int-<step> status` shows the pick continued before handling the next pause, because two resolvers in one worktree corrupt it
- You MUST NOT resolve conflicts yourself, because your context must stay free for orchestration across the whole step
- When the cherry-pick completes, You MUST verify `git log --format=%s <step_base_tag>..port/<step>` lists every cluster subject from `data/clusters.json` that has files, exactly once, and record the tip as `stack_tip` in the ledger and `PROGRESS.md`; every commit after `stack_tip` will be a fixup
- You MUST copy any `ESCALATE:` lines from `notes/<step>/conflict-*.md` into the escalations table of `PROGRESS.md`

### 3. Build and cluster errors

**Constraints:**
- You MUST start the integration build detached: `scripts/wt.sh detach build-int-<step>-r<k> scripts/build.sh wt/int-<step> build/int-<step> $JOBS_INTEGRATION` (k = round number, starting at 1), then poll with `scripts/wt.sh status` using `wait` between polls, because a first build can take an hour
- You MUST run `scripts/cluster_errors.py logs/build-int-<step>-r<k>.log --worktree wt/int-<step> --out steps/<step>/errors-r<k>.json`
- You MUST NOT summarise the error list into your own table, because the JSON file is the source of truth for the task files
- If there are zero clusters, You MUST go to step 5

### 4. Build-fix rounds

Turn each error cluster into a task, fan out workers, review, land, rebuild, repeat.

**Constraints:**
- You MUST write one task file per error cluster from `templates/worker-task.md` into `tasks/<step>/E<nnn>.md` (id from the JSON), with `integration_head` = current `port/<step>` HEAD, `owner_cluster` = the cluster owning most of its sites, and `build_targets` = the smallest ninja targets that contain those sites
- You MUST dispatch at most `MAX_WORKERS` workers per round with one `spawn_run` call (tasks array), each told only: "Follow /local/home/albsposi/pulp-llvm-port/agent-sops/worker.sop.md with task_file=<path>", largest clusters first, because a single rename often dissolves many smaller clusters; then You MUST end your turn
- For each worker result with `status: done` You MUST dispatch a reviewer (`agent-sops/reviewer.sop.md`) in a separate subagent, and You MUST NOT land anything without `verdict: APPROVE`, because the reviewer is the only check against a worker gaming the build
- You MUST land approved branches one at a time, in `data/clusters.json` order, with `scripts/integrate.py --int-wt wt/int-<step> --branch work/<step>/<id> --stack-base <step_base_tag> --notes-root notes --build-cmd "scripts/build.sh wt/int-<step> build/int-<step> $JOBS_INTEGRATION" --errors-before <latest errors json> --out tasks/<step>/<id>.integrate.json`, and after each LANDED result use its build log's clusters file as the next `--errors-before`
- On REJECTED (review or integration) You MUST re-dispatch the task with the reasons in `previous attempts`, at most twice; the third rejection becomes an escalation
- Workers with `status: escalated` or `blocked` MUST be copied into the `PROGRESS.md` escalations table; You MUST continue with the other tasks, because one open question must not stall the step
- After each round You MUST rebuild (step 3 with k+1); You MUST stop the step and report to the owner if the number of error clusters has not decreased for two consecutive rounds or after 8 rounds, because a loop that does not converge is burning compute on guesses
- You MUST remove each landed or abandoned worker worktree with `scripts/wt.sh rm`, keeping its branch

### 5. Test-fix rounds

Run the green-defining suite, group failures, fan out, land, repeat until green.

**Constraints:**
- You MUST run `scripts/wt.sh detach lit-int-<step>-r<k> scripts/lit.sh wt/int-<step> build/int-<step> $JOBS_INTEGRATION steps/<step>/lit-r<k> <baseline>` where `<baseline>` is the previous step's final `lit.json` (for step 19, `steps/18/lit-final/lit.json`)
- You MUST create one task per group in `lit_diff.json` (`tasks/<step>/T<nnn>.md`), with role `test-regen` when every failure in the group is a FileCheck mismatch on a test whose RUN lines still execute, and role `worker` for crashes, assertion failures, verifier errors, missing builtins or anything else, because only the latter are code defects
- You MUST dispatch, review and land exactly as in step 4, adding `--lit-cmd "scripts/lit.sh wt/int-<step> build/int-<step> $JOBS_INTEGRATION steps/<step>/lit-land <baseline> && cp steps/<step>/lit-land/lit_diff.json {diff_out}" --lit-before <latest lit_diff.json>` to `integrate.py`
- A regen report with any `semantic` row MUST be escalated and not landed, even if the reviewer approved it
- You MUST repeat until `lit_diff.json` reports `green: true`, with the same convergence stop rule as step 4
- If a fork test was relocated by upstream (path in `data/fork-tests.txt` no longer exists at the step base), You MUST update `data/fork-tests.txt` with the new path and record the rename in the step report, and You MUST NOT drop it from the list, because a dropped fork test is lost coverage that nothing reports

### 6. Gate and checkpoint

Check the definition of done, collapse fixups into their cluster commits, and tag.

**Constraints:**
- You MUST run `scripts/policy_check.py --repo wt/int-<step> --range <stack_tip>..port/<step> --notes-root notes --stack-base <step_base_tag> --out steps/<step>/policy.json` and it MUST exit 0
- You MUST record `git rev-parse port/<step>^{tree}`, run `GIT_SEQUENCE_EDITOR=: git -C wt/int-<step> rebase -i --autosquash <step_base_tag>`, and confirm the tree hash is unchanged and `git log --oneline <step_base_tag>..port/<step>` has exactly the cluster commits, because the next step's cherry-pick depends on that shape
- You MUST run step 5's lit command once more into `steps/<step>/lit-final` and it MUST be green
- If `ORACLE.md` reports a lane as built, You MUST run it and it MUST be green; otherwise You MUST state in the report that the downstream oracle did not run
- You MUST tag `port-<step>-green` on `port/<step>` (local only) and write `steps/<step>/report.md` containing: base tag, cluster commits, number of tasks per round, landed, rejected, escalated (with links to notes), fork-test renames, and every change note path, generated from the files under `tasks/<step>/` and `notes/<step>/`, not from memory
- You MUST update `PROGRESS.md` (step row, escalations) and record `phase: awaiting-owner` in the ledger

### 7. Hand off to the owner

⚠️ MANDATORY OUTPUT STEP

**Constraints:**
- You MUST stop and tell the owner: the tag, the report path, the number of open escalations, and the one-line decision each escalation needs
- You MUST NOT start the next step, push, or delete anything until the owner approves, because the owner's review of the change notes is the only human check in the loop
- On approval You MUST push `port/<step>` and the tag to `origin` by explicit name (`git push origin port/<step> port-<step>-green`) and mark the step approved in `PROGRESS.md`
- At the 22 checkpoint You MUST remind the owner that decision D1 (route 1 or route 2) is due before step 23

## Examples

### Example: step 19
**Input:** step `19`, prev_branch `port/18`, prev_base `e6c32898...` (PULP_18_MERGE_BASE).

**Expected behaviour:** leads verified into `steps/19/leads.md`; `port/19` created at the final 19.1 tag; conflicts expected in `registration` (ISAInfo relocation), `clang-builtins` (`.def` to `.td`, Sema split), `codegen-core` and `tests` (pipeline files); build-fix rounds dominated by the debug-record and removed-API clusters; test-fix rounds mostly `test-regen` on pipeline and FileCheck drift; stop at `port-19-green` with a report.

## Troubleshooting

### A worker branch keeps conflicting at integration
Two tasks touch the same lines. Land the one earlier in cluster order, then re-dispatch the other with the new `integration_head`.

### The host runs out of memory or disk
Call `resource_status`; lower `MAX_WORKERS` or `JOBS_PER_BUILD` in `config.env`; remove finished worker build dirs under `build/` (they are only a cache).

### A subagent reports success but the result file is missing
Treat it as `blocked`. The file is the contract; a chat message is not.
