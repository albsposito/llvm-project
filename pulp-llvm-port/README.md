# PULP LLVM port harness

Agent-led port of `pulp-platform/llvm-project` `integer_SIMD_fix` (LLVM 18) to LLVM 23. Agents do the porting; the owner judges by output (tests, instruction mix, downstream programs) and approves one step at a time.

## Read in this order

| File | For | What |
|---|---|---|
| `PROGRESS.md` | everyone | current state, decisions, escalations, owner actions |
| `AGENT_RULES.md` | every agent | the rules a change must follow to land |
| `PORTING.md` | every agent | route, fork anatomy, what breaks per version, how to research, roles, names |
| `agent-sops/phase0-setup.sop.md` | conductor | once: clone, restack, 18 baseline |
| `agent-sops/port-step.sop.md` | conductor | one version step, ending at a tagged checkpoint |
| `agent-sops/worker.sop.md`, `reviewer.sop.md`, `conflict-resolver.sop.md` | subagents | one task each |
| `ORACLE.md` | owner, conductor | downstream A/B oracle design and status |

## How a step flows

1. Cherry-pick the one-commit-per-cluster stack onto the next upstream release; a resolver subagent fixes each conflict in turn.
2. Build, cluster the errors by signature (`scripts/cluster_errors.py`), one worker per cluster in its own worktree.
3. An independent reviewer approves or rejects each fix; approved fixes land one at a time through `scripts/integrate.py`, which rejects anything that fails `scripts/policy_check.py`, adds a build error, or fixes nothing.
4. Same loop for the lit suite (`scripts/lit.sh`, `scripts/lit_diff.py`) until green.
5. Fixups fold back into their cluster commits, the step is tagged `port-<N>-green`, and the conductor stops for the owner.

## Starting it

In a Kiro session with this directory as the project:

- Phase 0: "Run /local/home/albsposi/pulp-llvm-port/agent-sops/phase0-setup.sop.md with fork_url=<your fork URL>"
- Each step, after approving the previous one: "Run /local/home/albsposi/pulp-llvm-port/agent-sops/port-step.sop.md with step=19"

## Layout

- `scripts/`: harness scripts (Python 3 stdlib only, plus bash); `tests/test_harness.py` covers them (`python3 -m unittest discover -s tests`)
- `data/`: `clusters.json` (file to cluster rules), `fork-files-18.tsv` (the fork's 124 files from the GitHub compare API), `fork-tests.txt` (sacred tests), `known-failures.txt` (created in Phase 0 if needed)
- `docker/Dockerfile.builder`: the build container
- `templates/`: task, change note, regen report
- created at run time, not versioned: `llvm-project/`, `wt/`, `build/`, `ccache/`, `logs/`, `toolchains/`; versioned run records: `steps/`, `tasks/`, `notes/`
