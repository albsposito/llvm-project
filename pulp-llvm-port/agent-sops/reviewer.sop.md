# Port Reviewer

## Overview

Independently review one worker branch of the PULP LLVM port against the agent rules and the worker's own change note, and approve or reject it. The reviewer is a different subagent from the worker, because the review exists to catch a worker that made the oracle pass instead of making the code right.

## Parameters

- **task_file** (required): absolute path of the task file the worker executed (`tasks/<N>/<task-id>.md`).
- **result_file** (required): absolute path of the worker's result JSON (`tasks/<N>/<task-id>.result.json`).

**Constraints for parameter acquisition:**
- If all required parameters are already provided, You MUST proceed to the Steps
- If any required parameters are missing, You MUST ask for them before proceeding
- When asking for parameters, You MUST request all parameters in a single prompt
- When asking for parameters, You MUST use the exact parameter names as defined

## Steps

### 1. Load

Read the rules, the task, the result, the change note and the diff.

**Constraints:**
- You MUST read `/local/home/albsposi/pulp-llvm-port/AGENT_RULES.md` in full
- You MUST read the diff with `git -C <worktree> show <each commit>`; You MUST NOT rely on the worker's description of it, because the description is what you are checking
- You MUST run `scripts/policy_check.py` over the worker's range yourself and read every WARN

### 2. Check the claim against upstream

Verify the cited upstream commit exists, is in range, and says what the note claims.

**Constraints:**
- You MUST run `git -C $LLVM_SRC show --stat <cited commit>` and confirm it is in `<prev_tag>..<step_base_tag>`
- You MUST confirm the fix matches what upstream did in that commit or in the cited reference code; a fix that "works" but differs from upstream's own pattern MUST be rejected unless the note explains why the fork needs to differ
- You MUST reject when the note's "What breaks if this is wrong" names no observable symptom

### 3. Hunt for oracle-cheating

Look specifically for changes that make the error disappear without preserving behaviour.

**Constraints:**
- You MUST check for: removed or bypassed fork logic, new early returns, functions stubbed to constants, conditions forced true or false, features dropped from a pass pipeline, deleted pattern definitions, weakened test expectations, and any `semantic` row in a regen report marked as `cosmetic`
- You MUST check that every changed line is needed for the task's root cause; unrelated edits MUST be rejected

### 4. Write the verdict

**Constraints:**
- You MUST write JSON to `tasks/<N>/<task-id>.review.json` with keys `verdict` (`APPROVE` or `REJECT`), `reasons` (list, required for REJECT, each pointing at a file and line), `warnings_checked` (the policy WARNs you examined and why each is acceptable)
- You MUST NOT edit the worker's branch or fix the problem yourself, because a reviewer who writes code is no longer independent
- You MUST keep the final chat message to one line: verdict and review path

## Troubleshooting

### The change is right but the note is weak
REJECT with the reason "note", listing which section is missing information. The conductor re-dispatches the worker to fix the note only.
