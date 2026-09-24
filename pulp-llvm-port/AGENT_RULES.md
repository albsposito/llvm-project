# Agent rules

Every agent on this port (conductor, conflict resolver, worker, reviewer, test regenerator) reads this file before doing anything. `scripts/policy_check.py` enforces the mechanical rules; the reviewer enforces the rest. A change that breaks a rule is rejected, however green it makes the build.

## Why these rules exist

The owner of this port judges it by its output (tests, downstream programs, instruction mix), not by reading LLVM code. So the only thing that can let a wrong change through is a weakened oracle. Every rule below protects the oracle or makes a change explainable to someone who does not know LLVM.

## Tests are sacred

1. You MUST NOT delete, rename, XFAIL, mark UNSUPPORTED, add a REQUIRES to, or remove a RUN line from any test, because a skipped test reports green while checking nothing.
2. You MUST NOT edit a test file unless your task role is `test-regen`. Other roles report the failing test in their result file and stop.
3. A `test-regen` agent MAY rewrite CHECK lines only with LLVM's own update scripts (`llvm/utils/update_llc_test_checks.py`, `update_mc_test_checks.py`, `update_cc_test_checks.py`, `update_mir_test_checks.py`), never by hand, and MUST write a regen report (template `templates/regen-report.md`) that classifies every changed CHECK block as `cosmetic` (register names, label numbers, scheduling order with identical instruction multiset) or `semantic` (any instruction added, removed or replaced). Any `semantic` block is escalated, not landed.
4. The commit carries `Test-Regen: <path of the regen report under notes/>`.

## Changes stay small and explained

5. One task fixes one root cause (one error signature or one test group). You MUST NOT fix unrelated errors you notice; list them in your result file instead, because mixed changes cannot be reviewed or reverted independently.
6. Every commit subject is `fixup! <exact subject of the cluster commit that owns the file>` (find it with `git log --format=%s <step-base>..HEAD`). This is what lets the stack collapse back to one commit per cluster at the end of the step.
7. Every commit carries `Change-Note: <step>/<task-id>.md` and that file exists under `notes/` with the four sections of `templates/change-note.md`. The note is written for a reader who does not know LLVM.
8. You MUST cite the upstream commit (hash and subject) that caused the break, found with `git log -S`, `git log -G` or `git log --follow` in the main clone. "Probably renamed" without a hash is not an explanation.

## No cheating the oracle

9. You MUST NOT add `#if 0`, comment out code, delete fork code, stub a function to return a constant, or add an early return to make an error go away, because each of these compiles and silently removes a feature. If the right fix is deleting fork code (upstream now does it natively), escalate with the upstream evidence.
10. You MUST NOT weaken an assertion, remove an `llvm_unreachable`, or catch-and-ignore an error.
11. You MUST NOT edit an upstream file that the fork does not already touch, because it grows the fork surface every future port pays for. If there is no other way, add an `Upstream-File-Edit: <reason>` trailer and the reviewer decides.
12. When upstream moved or redesigned the code a fork hunk lived in, you MUST follow how upstream now does the equivalent for its own RISC-V vendor extensions (the CORE-V `XCV*` extensions in `llvm/lib/Target/RISCV/RISCVInstrInfoXCV.td` and their ISel and Sema code are the closest reference, they are PULP-derived). Name the reference file and line in your change note.

## Scope and safety

13. Work only in your assigned worktree under `wt/`. You MUST NOT touch another worktree, the main clone's checked-out files, or any branch other than your own `work/...` branch.
14. You MUST NOT push, force-push, or delete branches or tags, because the integration branch and tags are the conductor's checkpoints.
15. You MUST NOT run a full `ninja` of the tree in a worker worktree; build the targets named in your task (`scripts/build.sh <wt> <build> $JOBS_PER_BUILD <targets>`), because thirty full builds on one host starve everyone.
16. Everything you decide goes into files (result file, change note), not only into your final message, because the conductor reads files.

## When to stop and escalate

Write `status: escalated` in your result file, with the question and the evidence, and stop, when any of these is true:

- the fix needs deleting or disabling fork functionality;
- upstream removed the facility the fork relied on and the replacement changes behaviour, not just spelling;
- a test's expected instructions change (not just register names);
- two plausible fixes exist and you cannot show from upstream code which one upstream would choose;
- you have tried two approaches and the error signature is unchanged.

Escalating is a correct outcome. A guessed fix that lands is the worst outcome, because nobody downstream can tell it was a guess.
