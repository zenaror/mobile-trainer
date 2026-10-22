# Bank 4D semantic resource path verification

Independent read-only review of the Japanese Bank 4D graphics path patch at base revision `49c73afb38676d4033e5c7378137740b158e0dc5`.

The reviewer confirmed all 43 current files match both their prior Git blob contents and the hashes in `RENAME_MANIFEST.json`; the 25 ROM-backed binaries match the corresponding original-ROM slices. The catalog and generated PNG metadata changes normalize to the original values aside from the intended path renames. The five clipped upload destinations were checked against the static callers and HDMA/VBK decoding. No path collisions were found. Review caught and corrected temporary absolute paths in the migration table and a stale screen-composition identifier before integration.

Validation after those corrections: `make` reports `SHA-256 OK` and `RESULT: IDENTICAL`; `make test`, `make sym-check`, `make palette-check`, `make png-check`, `python3 tools/gfx_export.py check`, `python3 tools/png_rules.py mk-check`, and `git diff --check` pass. Symbol output: 335 source files, 12,177 labels, 51 constants. Palette checker: 162 loads, 116 arrays, two documented overreads, zero errors. PNG checker: 408 tile sheets, four raw byte views, 37 font sheets, and 95 screen PNGs. This verifies static naming, metadata, and byte identity; it does not establish natural display of every tile block.
