# tools/trace

Dynamic-analysis harness (headless mGBA + Mobile Adapter emulation). Documentation, scenario format, output formats and
limitations: [`docs/research/dynamic_tracing.md`](../../docs/research/dynamic_tracing.md).

* `run_trace.py`      build (out of tree, `.cache/trace/`) + run all scenarios of `traces/scenarios.tsv` + write `traces/`, `analysis/`
* `mgba_trace.c`      the tracer (links libmgba; single-steps the SM83 core; fake Internet; macro interpreter)
* `merge_coverage.py` union of `traces/coverage_*.tsv` -> `analysis/coverage_union.tsv` + decoder-consistency validation
* `mkinput.py`        offline macro -> frame-script compiler (the harness has its own run-time macro mode; this is for inspection)
* `contact_sheet.py`  montage of screenshots (Pillow)
