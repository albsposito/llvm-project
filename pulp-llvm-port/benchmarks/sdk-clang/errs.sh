#!/usr/bin/env bash
# Print the distinct error lines of a build.log (compiler, assembler, linker,
# generator), without the long command lines.  errs.sh <build.log> [N]
grep -vE '^(cd |/usr/bin/cmake|/usr/bin/gmake|gmake)' "$1" \
 | grep -E '(error:|Error:|undefined reference|No module named|Traceback|fatal|Segmentation|Assertion|PLEASE submit|\*\*\* \[)' \
 | sed -E 's|/tmp/[^ ]*/work/(sdkp?\|bld)/||g' | sort | uniq -c | sort -rn | head -${2:-15}
