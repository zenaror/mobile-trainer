# Connection-icon Request1: two redundant tile-source aliases

2026-10-18 — private original-ROM source proposal, not adopted or self-accepted.

## Existing names and bounded contract

This unit retires only `Data_69_4160` and `Data_69_4560` in `gfx/comm/connection_icon.asm`. The existing proper co-labels `ConnIcon_Tiles0` and `ConnIcon_Tiles1` stay at the same addresses, in the same order. The two existing **CONFIRMED** resource headers and all evidence text remain byte-for-byte unchanged. This is redundant alias retirement for readability, not new semantic identification, a confidence upgrade, or evidence that all neutral data/functions are understood.

The positive literal reader is `ConnIcon_LoadGraphics_Request1` in `engine/comm/connection_icon.asm`. The first block at 69:4118 calls `Gfx_StartHDMAWithService` at 69:4124 with A=$69, HL=$4160, DE=$8200, B=$92 and C=$40; it reads exactly 1024 bytes through 69:4560 exclusive, into VRAM0:$8200–8600. The next call at 69:4136 uses A=$69, HL=$4560, DE=$8600, B=$95 and C=$20; it reads 512 bytes through 69:4760 exclusive, into VRAM0:$8600–8800. Both 18-byte argument/FarCall blocks match the original ROM. These legal C values count 16-byte transfers under the existing helper contract; the two B values qualify its LCD-on wait and do not establish a universal timing guarantee.

The two binary assets `conn_icon_tiles0.2bpp` and `conn_icon_tiles1.2bpp` match those exact original ROM slices. Their complete extents, not a guessed visual or glyph classification, support this selection. The owner is pinned by `layout.link` at bank $69, org $4152; its fourteen-byte zero prefix precedes $4160. Neither transfer includes the prefix, palette at $4760, or following pointer/animation records. No new natural trace, all-callers proof, or exhaustive computed-reader inventory is claimed.

## Scope, references and KEEP

A finite scan of 341 current maintained/root/include/RAM/macro ASM files finds exactly the two generic definitions, zero operational references to either old name, and no local declarations anywhere in this owner. The proper names have four literal source references: HL and BANK setup for each block in the Request1 reader. Their order/co-location introduces no emission between the proper and generic labels.

The current catalogue already names the two proper labels. The active catalogue, PNG rules/make fragment, editing-screen table and preview operation/screen tables contain zero references to the two old aliases. No metadata, path, asset, PNG, editing model, helper or operand needs changing. Frozen config and dated analysis remain history. The source proposal blanks only definition rows 15 and 21, preserving all 562 physical source lines and everything else, including every remaining generic alias.

All 41 other generic aliases in this owner stay **KEEP** with their inherited **PROBABLE** headers: the 14-byte prefix, palette, seven pointer-table groups, and frame/animation data. Their pointer/ABI contracts and content classifications are outside this narrow confirmed-resource unit. The Request2 resource set is also outside this selection; no owner in queued graphics/settings work, Notice4B, Shared5E, Error10, Label8 or Settings17 is edited. KEEP is not a finding that these bytes are unused or have no meaning.

## Prediction and validation boundary

The isolated symbol-set prediction removes exactly two global names and adds none; both proper names and all locals remain held. No fixed future parent or absolute symbol total is assumed. The package includes exact BEFORE/READSET pins and a two-line blanking diff for independent review. Current source pins, not the lexical census, are the authority; the census was used only to route the investigation.

Only private static file/hash/ROM analysis ran. No maintained source was changed; no repository helper/import, tests, compiler/make, renderer, emulator, Git, OMM, English or R4 operation ran. Original asset slice equality and a two-row source diff do not establish an assembled byte-identical ROM. ROOT must rebase on the actual parent, review independently and perform authorized original build/symbol/ROM checks before adoption. Existing support packages remain immutable and retained.

## Contextual rebase before final seal

The initial final-seal check detected concurrent input drift in layout.link, the asset catalogue and PNG rules, plus removal of the old Notice4B owner path. That failed attempt and its readset/OWN are retained literally. ROOT reported an authorized concurrent Notice4B adoption and stable source inputs, with actual gates still running; this unit did not read those gates, outputs or build artifacts and did not verify the full checkout state or any commit.

The separate REBASE readset recaptures the finite current source/metadata corpus with the new Notice4B owner name. ConnIcon owner, consumers, raw assets and relevant catalogue rows remain unchanged, and the two old operational reference counts and owner local count remain zero. The source proposal still blanks only rows15/21; no Notice4B file or path, metadata, qualifier or scope is changed by this proposal. All stated counts describe this finite recapture, not an asserted future parent or global semantic total.
