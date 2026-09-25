# Owner authorization — 2026-09-24

Owner answered **Approve these specific exceptions** to the reviewed proposal in notes/19/test-policy-proposal-review.md.

Scope only: T002 18 MC encoding-display fields; T004 91 exact builtin expected-error strings; T005 26 ASCII padding spaces; T001 six dead CSR destination changes and csrsi/csrci aliases, using LLVM update_llc_test_checks.py and explicitly reporting semantic blocks covered by this exception. Preserve inputs, RUN lines, assertions and coverage. Workers implement independently; reviewers inspect actual diffs before integration. This supersedes AGENT_RULES rules 2–4 only for these specified updates. No general future exception.

E004 production registration fix remains separately approved and is a dependency of T005 verification; both may be validated and integrated as an approved dependency chain because neither alone resolves the complete unit failure.

## Implementation refinements within approved scope

- T005 actual rebuilt output proves the longest extension name already fills column width 21, so it needs no added padding. Apply only the other 25 proposed spaces; retain that correct original row. This narrows the approved formatting-only edit and avoids an incorrect space.
- T001 six emitted CSR destination changes affect five existing CSR CHECK annotations. Preserve check count and other text. Run the LLVM updater on a temporary copy, mechanically extract the corresponding generated CSR checks into those existing locations, and record extraction because the updater does not replace old pre-function checks itself. No manually invented CHECK output.
