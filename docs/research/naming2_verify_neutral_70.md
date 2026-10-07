# Verification: three shared CommScene VRAM source units

CONFIRMED role names: `Gfx_CommScene_SharedVramSource0/1/2`, physical source-unit order6490/6690/6890. Eight instruction operands in four calls. All existing neutral aliases preserved, without moving512-byte bounds or changing existing types/statuses/assets.

Original sequences at70:451E/4530/4542/4554 independently reconstruct source bank70, destinations9000VB0/8000VB1/8400VB1/9000VB1 and C20/40/20/40. Calls452A/453C/454E/4560 all 160 hits/eighteen natural scenarios. Larger windows cross only the two adjacent512-byte units; the per-unit destinations and exact bounds are documented in `naming2_neutral_70.md`. No sole-destination or visual identity is inferred.

Headers now describe direct and cross-window contributions, including $6890's direct $4545/$454E consumer omitted by the prior clipped header. Existing gfx 512-byte/CONFIRMED classification is retained. Frozen mapper/config and historical research are unchanged. Three active asset labels, four active preview operation labels and three neutral-worklist rows agree with the source. Engine line locators remain fixed; no active locator into the changed graphics definition file was present.

Independent original-ROM review upheld all three names, all eight operands, all four transfer vectors, all header corrections and all three asset hashes before integration. The source ordinals denote existing physical units, not a runtime index or visual identity.

Private integration on account checkpoint a4e33ad passed `make` (SHA-256 OK; RESULT: IDENTICAL), `make sym-check` (15,516 source labels equal the symbol file, 51 exported constants), `make palette-check` (162 loads in 116 arrays, two documented overreads, zero errors), and `tools/sprite_chain_check.py` (291 frame tables, zero script index violations and zero hard mismatches). Full canonical source, asset hashes, header geometry and outside-scope files match the preceding checkpoint.

Fresh strict instruction census: 34 neutral names/55 operands, 24 pending groups, nine keeps and one partial alias. One separate structured-data macro reference remains outside this instruction cohort. No replay, forced entry or hardware validation is claimed.

Final main-tree validation runs all 37 checks: 36 return zero; only the historical ramop7 dry-run returns 2 for its obsolete schema. Build reports SHA-256 OK and RESULT: IDENTICAL; symbols (334 files, 15516 labels, 51 constants), palette, sprites, graphics and invariants pass. ramop9/10/11 report 156/300/138 already written with zero skips. The active-locator remapper reports zero moved/lost rows. Independent final integration review accepts exactly ten files, all previous symbol addresses, three new aliases, unchanged header geometry and seven metadata label cells.
