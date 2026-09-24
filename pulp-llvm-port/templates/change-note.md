# <step>/<task-id>: <one-line summary>

Written for a reader who does not know LLVM. Four sections, all required (policy_check.py checks the headings).

## What upstream changed

Which upstream commit (hash + subject) broke the fork here, and what it changed, in two or three plain sentences.

## Why this is equivalent

What the fork code did before, what it does now, and why the behaviour is the same. If you followed an upstream reference (for example how CORE-V `XCV*` does the same thing), name the file and line at the step's tag.

## What breaks if this is wrong

The observable symptom if this change is wrong: which test or which downstream program would show it, and how (an instruction family disappears, a builtin is rejected, a crash in pass X). "Nothing" is not an answer; if nothing would show it, say which test is missing.

## Upstream reference

- Commit: `<hash>` <subject>
- Reference code: `<path>:<line>` at `<tag>`
- Release notes: `<file>` section `<name>` (or "not mentioned")
