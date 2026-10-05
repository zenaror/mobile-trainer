#!/bin/sh
# Re-run every check of docs/research/audio2_verify_static.md from the repository root (after `make`, which creates build/mobile_trainer.sym and .map).
# Usage: sh analysis/audio2_verify/run_all.sh [TRACES_DETAIL_DIR]     (the optional argument enables the two read-only checks against the existing mGBA data-access traces)
set -e
cd "$(dirname "$0")/../.."
H() { printf '\n######## %s\n' "$1"; }
H "V2.1 coverage per driver label / per applied driver row (analysis/coverage_union.tsv)";  python3 analysis/audio2_verify/driver_rows_table.py
H "V2.1 generated rows SoundSongNN_* vs the independent derivation";                       A2V_QUIET=1 python3 analysis/audio2_verify/names_check.py
H "V2.1 who passes which ids to Sound_Play*";                                              python3 analysis/audio2_verify/callers_ids.py
H "V2.3 independent decoder: tiling, headers, extra pointer sets";                         python3 analysis/audio2_verify/coverage_check.py
H "V2.3 usage counts of section 4.4";                                                      A2V_QUIET=1 python3 analysis/audio2_verify/usage_counts.py
H "V2.3 macro files vs ROM bytes vs decoder";                                              A2V_QUIET=1 python3 analysis/audio2_verify/macro_files_check.py
H "V2.3 flow-sensitive note state / instrument usage";                                     A2V_QUIET=1 python3 analysis/audio2_verify/note_state_checks.py | tail -3
H "V2.4 tables";                                                                           python3 analysis/audio2_verify/tables_check.py
H "V2.4 instrument records selected by the data";                                          A2V_QUIET=1 python3 analysis/audio2_verify/instrument_usage.py | sed -n '/instrument records selected/,$p'
H "V2.2 pitch bend arithmetic";                                                            python3 analysis/audio2_verify/bend_formula.py
H "V2.5 mechanical comments, file headers";                                                python3 analysis/audio2_verify/table_comments_check.py; python3 analysis/audio2_verify/file_headers_check.py | tail -2
H "V2.5 macro operand checks (assembles one-line sources in build/macrotest)";             mkdir -p build/macrotest; sh analysis/audio2_verify/macro_asserts_test.sh
if [ -n "$1" ]; then
  H "traces: reads of the stream ranges";                                                  A2V_QUIET=1 python3 analysis/audio2_verify/trace_reads_check.py "$1"
  H "traces: reads of the tables";                                                         A2V_QUIET=1 python3 analysis/audio2_verify/trace_table_reads.py "$1"
fi
