# tools/trace

Dynamic-analysis harness (headless mGBA + Mobile Adapter emulation). Documentation, scenario format, output formats and
limitations: [`docs/research/dynamic_tracing.md`](../../docs/research/dynamic_tracing.md) (sections 4, 9 and 11).

* `run_trace.py`      build (out of tree, `.cache/trace/`) + run all scenarios of `traces/scenarios.tsv` + write `traces/`, `analysis/`
                      (`--only NAME` reruns one scenario and, unless `--reuse-state`, its parents; scenarios flagged `forced` go to `traces/forced/`)
* `mgba_trace.c`      the tracer (links libmgba; single-steps the SM83 core; fake Internet; macro interpreter; runtime directives
                      `unplug plug reset wipe net sram sramfill cfg cfgfill force ramset`; `--serve` fork-server mode; `--boot-a`, `--model`)
* `merge_coverage.py` union of `traces/coverage_*.tsv` -> `analysis/coverage_union.tsv` + decoder-consistency validation; forced runs
                      (`traces/forced/`) -> `analysis/coverage_forced.tsv` (kept apart, never in the union)
* `growth.py`         cumulative coverage per scenario -> `traces/growth.md`
* `frontier.py`       executed branches/calls ("gates") ranked by the unexecuted code they would open (static CFG over `config/regions`)
* `explore.py`        coverage-guided input search on top of the fork server (AFL-style: random button suffixes forked from a replayed prefix)
* `fuzzpack.py`       turns a finished `explore.py` search into an ordinary scenario macro (greedy set cover over exact replay coverage)
* `kbdnav.py`         shortest D-pad route between two keys of the on-screen keyboards, from the ROM's own neighbour tables
* `make_round2.py`    macro text of the round-2 scenarios that need computed keyboard routes (`kbd_abook`, `kbd_compose`)
* `make_fixtures.py`  synthetic mails (`traces/net/*.eml`) and 1 bpp BMP images (`traces/web/img_*.bmp`)
* `make_campaigns.py` macro text of the monkey campaigns (`traces/inputs/monkey_camp_*.macro`)
* `mkinput.py`        offline macro -> frame-script compiler (the harness has its own run-time macro mode; this is for inspection)
* `contact_sheet.py`  montage of screenshots (Pillow)

`tools/apply_coverage.py` (one level up) compares the union with the region tables, promotes fully executed code regions and (`--split`)
cuts partly executed regions at the boundaries of the executed runs so that every executed instruction is CONFIRMED.
