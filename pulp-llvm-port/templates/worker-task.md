# Task <step>/<task-id>

Written by the conductor (port-step step 4 or 5). One task is one root cause.

- step: <N>                     (e.g. 19)
- task_id: <E007 or T003>       (E = build error cluster, T = test group)
- role: worker | test-regen
- step_base_tag: <llvmorg-19.1.7>
- prev_tag: <llvmorg-18.1.x merge base or previous step tag>
- integration_head: <sha the worker branch starts from>
- worktree: /local/home/albsposi/pulp-llvm-port/wt/<N>-<task-id>
- build_dir: /local/home/albsposi/pulp-llvm-port/build/<N>-<task-id>
- branch: work/<N>/<task-id>
- owner_cluster: <cluster name>; fixup subject: `fixup! <cluster commit subject>`
- build_targets: <ninja targets that reproduce the error, e.g. LLVMRISCVCodeGen>
- verified leads: /local/home/albsposi/pulp-llvm-port/steps/<N>/leads.md
- change note path: /local/home/albsposi/pulp-llvm-port/notes/<N>/<task-id>.md
- result path: /local/home/albsposi/pulp-llvm-port/tasks/<N>/<task-id>.result.json
- previous attempts: <none, or the review/integration rejection reasons to address>

## The problem

<error cluster: signature, count, sites, first samples; or test group: failing tests and lit output excerpt>

## Procedure

Follow /local/home/albsposi/pulp-llvm-port/agent-sops/worker.sop.md with the parameters above.
