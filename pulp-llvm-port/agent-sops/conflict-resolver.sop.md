# Port Conflict Resolver

## Overview

Resolve one paused cherry-pick conflict while a port step's cluster stack is being applied onto a new upstream base. Runs in the conductor's integration worktree, one conflict at a time, because cherry-picks are sequential and each cluster commit depends on the ones before it.

## Parameters

- **step** (required): the target LLVM major version, e.g. `19`.
- **cluster** (required): the cluster whose commit is paused (read from the commit subject `[pulp] <cluster>: ...`).
- **int_worktree** (required): absolute path of the integration worktree, e.g. `/local/home/albsposi/pulp-llvm-port/wt/int-19`.
- **prev_tag** (required): upstream base the stack came from.
- **step_base_tag** (required): upstream base the stack is being applied onto.

**Constraints for parameter acquisition:**
- If all required parameters are already provided, You MUST proceed to the Steps
- If any required parameters are missing, You MUST ask for them before proceeding
- When asking for parameters, You MUST request all parameters in a single prompt
- When asking for parameters, You MUST use the exact parameter names as defined

## Steps

### 1. Inventory the conflict

**Constraints:**
- You MUST read `AGENT_RULES.md`, then run `git -C <int_worktree> status` and list every conflicted path and its conflict type (both modified, deleted by them, added by us)
- You MUST NOT run `git cherry-pick --abort`, `--skip`, `git reset` or `git checkout -- <path>`, because they discard the fork's change or the whole step's progress

### 2. Resolve each path

Keep upstream's new code and re-apply the fork's intent on top of it.

**Constraints:**
- For a both-modified conflict You MUST keep all of upstream's side and re-insert the fork's hunk adapted to it; You MUST NOT drop either side, because dropping upstream breaks the new base and dropping the fork loses a feature silently
- For "deleted by them" (upstream moved or removed the file) You MUST locate the new home with `git -C $LLVM_SRC log --follow --name-status <prev_tag>..<step_base_tag> -- <path>` and move the fork's hunk there, then `git rm` the old path
- If the new home is a different format (for example `.def` became `.td`, or a hand-written table became TableGen), You MUST convert the fork's entries into the new format following the closest upstream entries (CORE-V `XCV*`), and You MUST write that as a relocation in the note
- You MUST NOT try to make the tree build here, because build errors are clustered and fanned out in the next phase; `git diff --check` clean of conflict markers is the bar
- You MUST confirm no conflict markers remain with `git -C <int_worktree> diff --check` and `grep -rn '^<<<<<<< ' <paths>`

### 3. Continue and record

**Constraints:**
- You MUST write `notes/<step>/conflict-<cluster>.md` listing each path, the conflict type, what upstream changed (commit hash), and what you did
- You MUST continue with `git -C <int_worktree> -c core.editor=true cherry-pick --continue`
- If a resolution requires a design decision (no upstream equivalent, or the fork's hunk contradicts upstream's new design), You MUST still finish the pick with the fork's code preserved as closely as possible, and add an `ESCALATE:` line to the note, because stopping mid-pick blocks every later cluster
- You MUST end with one line: the cluster, the number of paths resolved, and the note path
