#!/usr/bin/env bash
# Create a fresh Ghidra project from baserom.gbc, run headless auto-analysis and export results.
#
#   tools/ghidra/import.sh              # raw analysis: entry 0100 + vectors + seeds.tsv
#   tools/ghidra/import.sh --regions    # additionally seed 'code' regions / clear non-code regions
#                                       #   from config/regions/bankNN.tsv (if present)
#   tools/ghidra/import.sh --no-analysis  # import + seeding only (no auto-analysis), still exports
#
# Requires: tools/ghidra/setup.sh done, baserom.gbc in the repo root (read-only, never modified).
# Produces: tools/ghidra/project/MobileTrainer.{gpr,rep}   (git-ignored, recreated on every run)
#           analysis/ghidra_functions.json, analysis/ghidra_disasm_bank00.txt,
#           analysis/ghidra_coverage.tsv, analysis/ghidra_bank_refs.tsv
#           tools/ghidra/project/{import.log,last_run.txt}  (headless logs, git-ignored)
set -euo pipefail
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/env.sh"

REGIONS=""; ANALYSIS=1
for a in "$@"; do
    case "$a" in
        --regions) REGIONS="regions" ;;
        --no-analysis) ANALYSIS=0 ;;
        *) gh_die "unknown option $a" ;;
    esac
done
[ -f "$ROM" ] || gh_die "$ROM not found"
gh_require_setup

EXPECT_SHA="$(awk 'NF{print $1; exit}' "$REPO_ROOT/roms.sha256" 2>/dev/null || true)"
ACTUAL_SHA="$(sha256sum "$ROM" | cut -d' ' -f1)"
[ -z "$EXPECT_SHA" ] || [ "$EXPECT_SHA" = "$ACTUAL_SHA" ] || gh_die "baserom.gbc sha256 differs from roms.sha256"

rm -rf "$GHIDRA_PROJECT_DIR"; mkdir -p "$GHIDRA_PROJECT_DIR" "$REPO_ROOT/analysis"
# Remove stale exports first so that a failed run cannot leave old results that look fresh.
EXPORTS=(ghidra_functions.json ghidra_disasm_bank00.txt ghidra_coverage.tsv ghidra_bank_refs.tsv)
for f in "${EXPORTS[@]}"; do rm -f "$REPO_ROOT/analysis/$f"; done
# Compiled scripts live in the isolated settings dir; stale bundles from older script versions are harmless.
NOAN=(); [ "$ANALYSIS" = 1 ] || NOAN=(-noanalysis)

# Do not swallow failures (verifier fix): keep the full log, show the interesting lines, then check the exports.
set +e
ghidra_headless "$GHIDRA_PROJECT_DIR" "$GHIDRA_PROJECT_NAME" \
    -import "$ROM" -loader GameBoyLoader -processor "$GHIDRA_LANG_ID" \
    -scriptPath "$GHIDRA_TOOLS/scripts" \
    -preScript GbSeed.java "$REPO_ROOT" $REGIONS \
    -postScript GbExport.java "$REPO_ROOT" \
    "${NOAN[@]}" \
    -log "$GHIDRA_PROJECT_DIR/import.log" \
    > "$GHIDRA_PROJECT_DIR/last_run_raw.txt" 2>&1
RC=$?
set -e
grep -v "cds\]" "$GHIDRA_PROJECT_DIR/last_run_raw.txt" > "$GHIDRA_PROJECT_DIR/last_run.txt" || true
grep -E "GbSeed|GbExport|ERROR|Exception|Analysis|IMPORTING|REPORT|WARN.*(Loader|Language)" "$GHIDRA_PROJECT_DIR/last_run.txt" || true
for f in "${EXPORTS[@]}"; do
    [ -s "$REPO_ROOT/analysis/$f" ] || { tail -20 "$GHIDRA_PROJECT_DIR/last_run.txt" >&2; gh_die "headless import failed (rc=$RC): analysis/$f was not written"; }
done
[ "$RC" = 0 ] || echo "WARNING: analyzeHeadless exited with rc=$RC (exports were written; check $GHIDRA_PROJECT_DIR/last_run.txt)" >&2
echo "project: $GHIDRA_PROJECT_DIR/$GHIDRA_PROJECT_NAME.gpr"
