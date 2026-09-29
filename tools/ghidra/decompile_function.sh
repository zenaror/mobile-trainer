#!/usr/bin/env bash
# Print Ghidra's decompilation (C) of one function.   HYPOTHESIS output, see docs/research/ghidra.md
#
#   tools/ghidra/decompile_function.sh <bank:addr>      e.g.  00:06D1   6B:4C80   0x0278 (bank 00 implied)
#
# Needs: tools/ghidra/setup.sh and tools/ghidra/import.sh already run (the project is reused).
# The saved project is never modified: each call works on a private read-only copy (3 MB), so
# several agents can decompile at the same time. Takes ~5 s (JVM + project open + decompiler).
# If no function exists at the address, one is created for that run only (disassemble from there).
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"

[ $# -eq 1 ] || gh_die "usage: $0 <bank:addr>   (hex; bank 00 = ROM0)"
spec="${1#0x}"
if [[ "$spec" == *:* ]]; then bank="${spec%%:*}"; addr="${spec##*:}"; else bank="00"; addr="$spec"; fi
addr="${addr#0x}"; addr="${addr#\$}"
[[ "$bank" =~ ^[0-9A-Fa-f]{1,2}$ && "$addr" =~ ^[0-9A-Fa-f]{1,4}$ ]] || gh_die "bad address '$1' (want hex bank:addr)"
gh_require_setup
[ -f "$GHIDRA_PROJECT_DIR/$GHIDRA_PROJECT_NAME.gpr" ] || gh_die "no project; run tools/ghidra/import.sh first"

# The scratch copy must live under a path without dot-prefixed elements (Ghidra rejects them in
# project paths), so it goes inside the git-ignored tools/ghidra/project/ directory.
work="$(mktemp -d "$GHIDRA_PROJECT_DIR/run.XXXXXX")"
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/proj"
cp -r "$GHIDRA_PROJECT_DIR/$GHIDRA_PROJECT_NAME.gpr" "$GHIDRA_PROJECT_DIR/$GHIDRA_PROJECT_NAME.rep" "$work/proj/"
rm -f "$work/proj/$GHIDRA_PROJECT_NAME.rep"/*.lock* 2>/dev/null || true
out="$work/out.c"

ghidra_headless "$work/proj" "$GHIDRA_PROJECT_NAME" \
    -process baserom.gbc -noanalysis -readOnly \
    -scriptPath "$GHIDRA_TOOLS/scripts" \
    -postScript DecompileFunction.java "$bank" "$addr" "$out" \
    > "$work/log.txt" 2>&1 || true
if [ -s "$out" ]; then cat "$out"; else
    echo "decompilation failed; log tail:" >&2; tail -20 "$work/log.txt" >&2; exit 1
fi
