# Overnight handover — 2026-09-25

## Resume prompt

Resume as CONDUCTOR of the PULP LLVM 18→19→20→21→22→23 port. Read PROGRESS.md, AGENT_RULES.md, PORTING.md, agent-sops/port-step.sop.md, then worker/reviewer/conflict-resolver SOPs. Current state is below. Continue to23 without release-gate pauses, but preserve independent worker/reviewer/integrator discipline. The conductor never writes LLVM fixes. Do not push again or delete branches/tags without fresh authorization. This checkpoint push was explicitly requested by the owner.

## Workspace and checkpoints

- Main clone: /home/ubuntu/llvm-project; harness: pulp-llvm-port/; native builds.
- Harness/checkpoint branch: llvm-23-porting. Its checkpoint commit contains this handover, task/review evidence, benchmark artifacts and harness changes.
- Baseline: port/18 at1c33bd3dba2bd1f3942842135daba498af1b3eb5.
- LLVM19: port/19 and port-19-green at9b2edaf923ad46816535d7361e9daef79be0529c. GREEN: clean build,4531/4531 lit,56/56 fork lit,83/83 selected unit tests. Exactly11 cluster commits. See steps/19/report.md.
- LLVM20: port/20 at94bbab7f1554874b4f17e51bbdadef698136489f, based llvmorg-20.1.8. All11 clusters merged. First build FAILED; no running build/session to reconnect.
- Integration worktrees: pulp-llvm-port/wt/int-{18,19,20}; builds: build/int-{19,20}. Reference18 binaries: toolchains/ref-18/bin. Build trees, binaries and full logs remain local and are intentionally not committed.
- Workers are preserved on work/19/* and work/20/* branches. No branch/tag deletion or force-push is part of this checkpoint.

## Exact next work

1. E001 is done but NOT independently reviewed or landed. Read tasks/20/E001.md, E001.result.json, E001.policy.json, E001.registration-equivalence.json and notes/20/E001.md. Worker branch work/20/E001 at963f162ed2856968a7b864771385228ef70ab88c; worktree pulp-llvm-port/wt/20-E001. Assign a separate reviewer. This updates21 smallfloat RISCVExtension constructors following upstream d280a9c5e226. Initial errors E001–E003 are three manifestations of one root cause; E002/E003 task files explicitly coalesce into E001.
2. After APPROVE, land E001 via integrate.py using steps/20/errors-r1.json. Worker build removes all constructor signatures but exposes an untouched scheduling failure: RISCVSchedMempool.td:3 missing WriteFCvtF32ToF16 resource. Use --allow-unmasked only with the documented untouched-line checks; then create the next worker task from actual integration output. Duplicate RISCVTTIImpl::getPreferredAddressingMode remains a known masked lead; do not fix speculatively as conductor.
3. H003 harness change is independently APPROVED, NOT applied. Read tasks/20/H003.review.json and notes/20/H003-review.md. Branch work/20/H003 implementation2458055619510c5abb8f41b21db9d3e265be36f1; isolated worktree /home/ubuntu/llvm-project/wt/20-H003. Apply ONLY tasks/20/H003.patch after checking it applies. Do NOT cherry-pick prerequisite snapshots1fe389ea16b9 or3f7396a03e8f: they snapshot prior dirty harness state. Re-run relevant harness tests. Copy/use steps/20/baseline-renames.candidate.json as the reviewed mapping for20. It requires all16 successors of the upstream CPU test split to PASS.
4. Global config.env and data/fork-tests.txt already point to20 CPU successor paths; LIT_PATHS covers the whole split directory. See steps/20/fork-test-renames.md. LLVM19 settings archived in steps/19/checkpoint-config.env and checkpoint-fork-tests.txt.
5. Repeat build fixes, independent reviews, integration gates; then lit against19 baseline with20 rename/split mapping, fix/review/land actual failures. Finish policy/autosquash (11cluster commits, unchanged tree)/final lit/report/tag, then21→22→23. Update PROGRESS at each phase change.

## Gate and environment gotchas

- On this tool host detached nohup jobs disappeared. Use managed exec_command sessions, redirect logs, poll write_stdin. Old session2840 is finished; build exit is1. Keep updates frequent. Native integration jobs24, worker jobs8; no Docker.
- integrate.py reads errors-before after applying/building: verify the JSON exists FIRST. A successful build does not automatically create the next cluster JSON; run cluster_errors.py explicitly.
- Lit command must copy lit_diff.json even when lit returns1: use `scripts/lit.sh ...; rc=$?; cp <out>/lit_diff.json {diff_out} || exit 2; exit "$rc"`. Do not use `&& cp` for a shrinking-failure gate.
- Current main harness includes reviewed H001/H002 changes (baseline renames, unit inventory/failure gates); H003 remains separate. Harness-only changes are not LLVM cluster fixups.
- Tests remain sacred. Owner exceptions in notes/19/owner-test-exceptions.md apply only to the specified19 changes, not blanket future test edits. Open codegen/pipeline questions are in PROGRESS; do not silently guess.
- No automatic overnight continuation requested. Resume after owner returns. Prior YOLO tooling permissions do not override explicit workflow review gates.

## Benchmark

Complete: benchmarks/19-vs-18/report.md, README.md, raw results.json, commands.json, supplement.json, hwloop-mix.json, sources and reproduction scripts. Ten straight-line kernels have byte-identical machine code atO2/O3. Five C loop kernels crash in BOTH versions in PULPHardwareLoops. Supplemental7-function IR corpus446→438bytes; hardware-loop8 and postincrement4 counts preserved; strcmp drops two p.extbz and strict bitmanip mix check remains FAIL. No compatible runtime runner; no execution speed/correctness claim. Compile-time samples are contended. Independent benchmark audit was requested by its author but is not yet done. Record/fix shared loop crashes as a separate task, not a hidden port-gate waiver.

## Preservation

All harness notes/tasks/step reports and raw benchmark evidence are committed. Selected20 failure logs are gzip snapshots in steps/20/checkpoint-logs/. All current port and worker branches plus port-19-green are to be pushed to owner origin, https://github.com/albsposito/llvm-project.git. No builds/toolchains/ccache or nested worktrees are included. Upstream release refs can be fetched from upstream when reconstructing on another host.
