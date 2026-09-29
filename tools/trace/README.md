# tools/trace

Dynamic-analysis harness (headless mGBA + Mobile Adapter emulation). Documentation, scenario format, output formats and
limitations: [`docs/research/dynamic_tracing.md`](../../docs/research/dynamic_tracing.md) (sections 4 and 9).

* `run_trace.py`      build (out of tree, `.cache/trace/`) + run all scenarios of `traces/scenarios.tsv` + write `traces/`, `analysis/`
* `mgba_trace.c`      the tracer (links libmgba; single-steps the SM83 core; fake Internet; macro interpreter; runtime directives
                      `unplug plug reset wipe net sram sramfill cfg cfgfill`)
* `merge_coverage.py` union of `traces/coverage_*.tsv` -> `analysis/coverage_union.tsv` + decoder-consistency validation
* `growth.py`         cumulative coverage per scenario -> `traces/growth.md`
* `frontier.py`       executed branches/calls ("gates") ranked by the unexecuted code they would open (static CFG over `config/regions`)
* `make_fixtures.py`  synthetic mails (`traces/net/*.eml`) and 1 bpp BMP images (`traces/web/img_*.bmp`)
* `make_campaigns.py` macro text of the monkey campaigns (`traces/inputs/monkey_camp_*.macro`)
* `mkinput.py`        offline macro -> frame-script compiler (the harness has its own run-time macro mode; this is for inspection)
* `contact_sheet.py`  montage of screenshots (Pillow)

`tools/apply_coverage.py` (one level up) compares the union with the region tables and can promote fully executed code regions.
