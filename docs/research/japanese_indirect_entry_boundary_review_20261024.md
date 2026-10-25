# Japanese indirect-entry and boundary review (2026-10-24)

## Scope and provenance

This review reconciles three independent static reviews of the remaining Japanese operation-entry candidates and adjacent code/data spans. Their snapshots were based on `dd004b924ac116573c36f9e9a13c567ccd03042c`; the relevant source files were compared against that revision. The original ROM is 2,097,152 bytes with SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The coordinator independently recomputed the ROM and key slice hashes below against the canonical checkout after commit `6e2a5437ea3b8876dd8df3c91265878e2092015b`. These are static/source and original-byte findings, not runtime or hardware evidence.

No candidate received a natural-entry or application-purpose promotion. The review specifically looked beyond prior direct-literal/CALL scans for stack trampolines, saved/copied stubs, indexed dispatch, and bounded computed targets. Absence from these examined mechanisms is not a global-unreachability claim.

## Stack-based sprite hook

`home/sprites.asm` has an executable hook trampoline at `00:0B36–0B53`. It reads callback address/bank bytes from a WRAM7 sprite slot, selects the callback bank through `BankSwitch_D`, pushes return `00:0B54` and the destination, then uses `RET` to transfer control. A callback returning conventionally reaches `00:0B54`. This is a real computed route that ordinary direct-CALL and `JP HL` scans do not cover.

The examined 15 textual `call Sprite_SetHook` sites in `home/`, `engine/` and `lib/` write only these target pairs: `00:0A1A`, `57:52D8`, `57:531E`, `69:4034`, or `00:0000`. The ordinary slot initializer clears the record; the object loader does not populate the hook. However, slot backup/restore copies 256 bytes, including hook cells, and there are direct clear writers. Those mechanisms transport or clear existing bytes; this bounded producer census does not establish every writer or alias. Consequently it supplies no positive producer for `29:511E`, `2B:6CF5` or `2D:4E42/4E54`, and does not establish their global absence.

Relevant original-ROM slices, end-exclusive: `00:0B36–0B54`, SHA-256 `0a02ef21cea69742bcc71e51dfe14b6145e61574e6dc10eb1e0635efeab5aee8`; `00:0A45–0A65`, SHA-256 `c73c6fd1df0223e49fafea26217b8700eaf69af698eba103ec59040b1a216df3`.

## Candidate dispatch and alternate routes

- `70:408F–40AC` indexes the dispatcher tables at `70:40AD` using the examined kind/state domains. Immediate destinations for kinds 0–2 are respectively `40E3,411B,4121,4135,41BF,41E8,4202,4215,4235,425C`; `428D,42C7,42CD,4357,4380,439A,43AD,43D0,43FF`; and `4418,4452,4458,4484,449D`. None lies in `[70:4740,70:477F)`. Examined ordinary producers and loop exits do not establish a path to `70:4740`. Out-of-domain/corrupted states, arbitrary aliases and transitive behavior outside the examined routes remain open; keep `SaveCheck_GetStateBlockBit7` as a bounded operation with entry and field purpose HYPOTHESIS. ROM slice `70:408F–40E3`: SHA-256 `cecefb90690489cff7768f96d717996c89fef2420607c9ef4ce6def7e3e66660`.
- `29:50CE` internally calls `29:511E`, but its natural root remains unproved. Relocating the wrapper preserves the absolute `CALL $511E`; relocating only the leaf still requires its `CALL $7BB7`, correct mapper state and balanced return. Writes in the same candidate area can alter the fetched ROM bank, so source-bank continuation cannot be presumed. No examined stack, far-call, jump-table or copied-stub mechanism produced the required candidate target. This does not rule out arbitrary computed state or unexamined aliases. ROM slices: `29:50CE–50D5`, SHA-256 `28564ec3053cac35322d8095a13f69395c211c7c587697a90873f94a066bb51e`; `29:511E–5145`, SHA-256 `8c5f248d750ef17ad8abb95d859f1239bb258ca8bd2b2d7b78aadbab8e2abe95`.
- For `2B:6CF5` and `2D:4E42/4E54`, the reviewed WRAM interrupt stubs, ticker save/restore, HRAM far-call/jump-table trampolines, stack-return transfers and explicit `00:05AC → FF80` DMA copy yielded no new producer. The known internal edge `2D:4E49 → 4E54` and `29:50CE → 511E` still do not establish natural roots. Entry remains UNKNOWN/HYPOTHESIS; computed writes, arbitrary aliases and unobserved traces remain outside the review. ROM candidate slices: `2B:6CF5–6DB0`, SHA-256 `e6c91d7430f7d9297da49ec0027b3c366100382b87692f72efd7e61490da534d`; `2D:4E42–4E8C`, SHA-256 `36f3b7d11ef1c2be1e5df127efb8260753cf8b968224733e490d24839b0eaa29`.

## Keyboard fragment and adjacent spans

- `55:5DF5–5E01`: the predecessor at `55:5DF2` is an unconditional `JP $5E5A`; Select dispatches directly to `55:5E02`. The examined in-file `JP HL` tables do not target the fragment within their declared domains. Its conditional local behavior is CONFIRMED; natural entry remains HYPOTHESIS. Out-of-domain indices and gateways beyond the examined source are not excluded.
- `26:5344–537B`: adjacent RETs do not enter this span; the fragment conditionally performs repeated writes to VRAM1 and WRAM7, but no natural caller or purpose was established. The interaction with stack in switched WRAM makes execution conditional on stack placement/bank discipline.
- `28:4BA6–4BC1`: the preceding sprite script at `28:4BA3` declares one frame, and the examined sprite loader/stepper contract reads only the script bytes through `4BA5`. This review left code/data identity unresolved; later instruction classification supports PROBABLE code, named `ClearWram0AndFillWram7WithFF`. Entry and use remain unknown. The sprite-hook route is not filled by this script under the examined initializer. See the current [Japanese residual matrix](japanese_remaining_semantics_batch_20261024.md).

### Structural comparison for `28:4BA6` (2026-10-24)

A separate byte-level comparison found that `28:4BA8–4BAF` is byte-identical to the active OAM-clear loop body at `00:0A0E–0A15` (`21 00 C0 AF 22 05 20 FC`). The candidate sets `B=$90` before that body, clearing `$C000–$C08F`; `Sprite_ClearShadowOAM` sets `B=$A0` and clears `$C000–$C09F` (`home/sprites.asm:129–138`). The candidate then selects WRAM bank 7 and fills `$DA00–$DAFF` with `$FF`, while `Sprite_ResetAll` clears the 14 live slots `$DA00–$DADF` and restores the WRAM selector (`home/sprites.asm:72–99`; slot extent `ram/wram.asm:791`).

This corroborates only a **HYPOTHESIS** that the span is reset-like code or a related fragment. Different OAM lengths, WRAM extents, register preservation, and bank-restoration behavior prevent identifying it as `Sprite_ResetAll`, an older implementation, or dead code. No entry, consumer, or purpose is established; retain the current neutral candidate label and bytes.

The three spans were absent from the retained 70-scenario instruction/call/read corpus; that finite result remains bounded and does not imply global unreachability. Keep their current candidate/neutral classification unless new positive evidence appears.

## Bank 4B zero record

`4B:76CC–76CF` is four zero bytes following three four-byte records. The table at `67:53D6` contains exactly three words (`76C0,76C4,76C8`); the loader computes `53D6+2*slot` and reads the selected word. Its ordinary valid slots consume only those three records. Index 3 would read the following bytes `CD 02` as pointer `$02CD`, not select `76CC`; subsequent mapper behavior does not establish a read from bank 4B at that pointer. The bounded loader therefore does not select the zero record. This says nothing about other readers, writes, copies or aliases: global use and purpose remain unknown, and the record is not classified globally unused.

Original bytes: `67:53D6–53DE`, SHA-256 `ec8ad03ae0a31d9feed83b1f808053da4a4025ffa5fe9201677af759978d53b8`; `4B:76C0–76D0`, SHA-256 `f40dfea8a32358cc4ce504942126e52290f7bdda123c80d8d23173462d575c47`.

## Whole-source bank-42 consumer census (2026-10-24)

A read-only census at canonical revision `ad728afea3e7c30861da34c15d64081e86e4f182` covered the 336 object-source files listed by the Makefile (166,597 lines), plus `consts.asm` and `zero_labels.asm`. With comments excluded, 1,504 explicit `BANK(...)` operands resolved against maintained source symbols; none selected bank 42. No references from another source file to labels owned by `metal_flame_and_creature_borders_42.asm` were found. The existing `gfx/previews/screen_ops.tsv` inventory has 917 rows, no bank-42 row, and 99 `UNRESOLVED` rows (file SHA-256 `888f78456d6d82544727d405487f9e5744902ced904e4d3823497dc3c80000aa`).

Additional bounded indirect tables were checked: result-page banners use bank 4B (`engine/account/result_page.asm:186–261`); startup notice headers use banks 58/4B/71 (`engine/startup/notice_pages.asm:196–250`); declared help-picture records use banks 60/61/5B (`engine/help/help_script.asm:644–766`); valid glyph rows use banks 76–7E or FF (`engine/text/glyph.asm:27–68,169–226`); examined canvas/scroll GDMA inputs come from WRAM (`engine/text/canvas.asm:2029–2063`, `engine/gfx/scroll_split.asm:62–84`). These paths yield no positive bank-42 consumer for the six residual spans.

This is a finite source/declared-table negative, not a proof of global non-use. `BankSwitch_H/D/B`, `ReadByteFar`, and `Gfx_StartHDMA*` accept dynamic bank inputs (`home/bank_switch.asm:7–66`, `home/far_read.asm:7–69`, `home/gfx_upload.asm:7–92`); sprite hooks restore a bank from a WRAM slot (`home/sprites.asm:32–43`); and `PalLibCandidate_WriteRomBankLowAAndZeroHigh` writes a caller-provided A (`engine/gfx/palette_library_candidate.asm:146–151`). The producers/domains for those inputs and the 99 unresolved operation rows remain open. Preserve the six tails without new assets or global `unused` labels until a consumer or a source-complete selector census resolves them.

## Five candidate spans rechecked against the current 72-scenario corpus (2026-10-24)

A grouped, read-only recheck matched the current `analysis/coverage_union.tsv`, all 72 scenario `callgraph.tsv` files, and all 72 `dataaccess.tsv` files against the five still-unresolved operation ranges:

| Candidate span | Executed instruction starts | Recorded callgraph destinations | ROM data-read overlaps |
|---|---:|---:|---:|
| `2B:6CF5–6DB0` (`MailReply_ComposeFromRecord`) | 0 | 0 | 0 |
| `2D:4E42–4E8C` (both body-locator entries) | 0 | 0 | 0 |
| `29:50CE–5145` (palette-library wrapper and leaf) | 0 | 0 | 0 |
| `70:4740–477F` (`SaveCheck_GetStateBlockBit7`) | 0 | 0 | 0 |
| `55:5DF5–5E02` (keyboard fragment) | 0 | 0 | 0 |

This is a current-corpus negative only; in particular the internal static edge `2D:4E49 → 2D:4E54` does not supply an outer root. It does not establish global unreachability, non-use, or purpose, and it does not replace the existing per-candidate static/ABI reviews. The current 72 scenarios include the two later replay scenarios `zz_jp_inbox_explore_replay` and `zzzz_mailbox_cursor_count`; neither adds an observed start/edge/read in these ranges. Reproduce with `.tmp/jp-candidate-entry-corpus-recheck-20261024/audit.py` (SHA-256 `39d2744a85e8fc92d3396cd3d82c78b093d95a055e434bd738691e8d6002288c`), pinned input manifest `INPUTS.json` (SHA-256 `114c09ea3321925bc87906c4b99427cf5ea8e95a9bb1d477bbd48611b3be7bd6`), and `RESULT.json` (SHA-256 `e34381346c87154e6253b02835af06db83b72b06cb9fbb010ec6146aa8355e3d`). The script verifies the immutable ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` and coverage-union SHA-256 `0c1986ea507df1172474f07f4a8959b6a872b2fd49912c31bafd551c1dfa37ae`.

## Effect on closure status

This review adds a confirmed static callback mechanism and narrows several specific candidate routes, but promotes no unresolved natural entry, global unused classification, or semantic purpose. The current source census still has no generic address-only function/data/font names or bare `gfx/bankNN` paths; this is a separate lexical gate and does not mean every code/data span is semantically identified. Japanese closure is not yet 100%: the documented candidate roots, auxiliary spans, Bank 53 name/frame associations, Porygon assignments, and global frame-use status retain their stated evidence limits. English/ZIP remains paused pending Japanese closure and explicit Operator approval.
