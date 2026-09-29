#!/usr/bin/env bash
# Cross-check the installed SM83 sleigh language against tools/sm83.py (proven byte-exact by
# tools/test_sm83.py) for all 500 opcodes: instruction length, mnemonic, flow type.
#   tools/ghidra/check_language.sh      -> analysis/ghidra_language_check.tsv + summary on stdout
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"
gh_require_setup
mkdir -p "$GHIDRA_PROJECT_DIR"
work="$(mktemp -d "$GHIDRA_PROJECT_DIR/lang.XXXXXX")"
trap 'rm -rf "$work"' EXIT
mkdir -p "$work/proj"
ghidra_headless "$work/proj" langcheck -import "$ROM" -loader GameBoyLoader -processor "$GHIDRA_LANG_ID" \
    -scriptPath "$GHIDRA_TOOLS/scripts" -postScript GbOpcodeDump.java "$work/ghidra_ops.tsv" \
    -noanalysis -readOnly > "$work/log.txt" 2>&1 || { tail -20 "$work/log.txt"; exit 1; }
[ -s "$work/ghidra_ops.tsv" ] || { tail -20 "$work/log.txt"; gh_die "opcode dump failed"; }
python3 "$GHIDRA_TOOLS/check_language.py" "$work/ghidra_ops.tsv" "$REPO_ROOT/analysis/ghidra_language_check.tsv" || true
