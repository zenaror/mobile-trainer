# Japanese indirect-entry and boundary reference

## Stack-based sprite hook

The examined 15 textual `call Sprite_SetHook` sites in `home/`, `engine/` and `lib/` write only these target pairs: `00:0A1A`, `57:52D8`, `57:531E`, `69:4034`, or `00:0000`.

## Candidate dispatch and alternate routes

Examined ordinary producers and loop exits do not establish a path to `70:4740`.

Out-of-domain/corrupted states, arbitrary aliases and transitive behavior outside the examined routes remain open; keep `SaveCheck_GetStateBlockBit7` as a bounded operation with entry and field purpose HYPOTHESIS.

Relocating the wrapper preserves the absolute `CALL $511E`; relocating only the leaf still requires its `CALL $7BB7`, correct mapper state and balanced return.

## Keyboard fragment and adjacent spans

- `55:5DF5–5E01`: the predecessor at `55:5DF2` is an unconditional `JP $5E5A`; Select dispatches directly to `55:5E02`.

Out-of-domain indices and gateways beyond the examined source are not excluded. - `26:5344–537B`: adjacent RETs do not enter this span; the fragment conditionally performs repeated writes to VRAM1 and WRAM7, but no natural caller or purpose was established.

The interaction with stack in switched WRAM makes execution conditional on stack placement/bank discipline. - `28:4BA6–4BC1`: the preceding sprite script at `28:4BA3` declares one frame, and the examined sprite loader/stepper contract reads only the script bytes through `4BA5`.

### Structural comparison for `28:4BA6`

A separate byte-level comparison found that `28:4BA8–4BAF` is byte-identical to the active OAM-clear loop body at `00:0A0E–0A15` (`21 00 C0 AF 22 05 20 FC`). The candidate sets `B=$90` before that body, clearing `$C000–$C08F`; `Sprite_ClearShadowOAM` sets `B=$A0` and clears `$C000–$C09F` (`home/sprites.asm:129–138`). The candidate then selects WRAM bank 7 and fills `$DA00–$DAFF` with `$FF`, while `Sprite_ResetAll` clears the 14 live slots `$DA00–$DADF` and restores the WRAM selector (`home/sprites.asm:72–99`; slot extent `ram/wram.asm:791`).

This corroborates only a **HYPOTHESIS** that the span is reset-like code or a related fragment. Different OAM lengths, WRAM extents, register preservation, and bank-restoration behavior prevent identifying it as `Sprite_ResetAll`, an older implementation, or dead code. No entry, consumer, or purpose is established; retain the current neutral candidate label and bytes.

## Bank 4B zero record

`4B:76CC–76CF` is four zero bytes following three four-byte records. The table at `67:53D6` contains exactly three words (`76C0,76C4,76C8`); the loader computes `53D6+2*slot` and reads the selected word. Its ordinary valid slots consume only those three records. Index 3 would read the following bytes `CD 02` as pointer `$02CD`, not select `76CC`; subsequent mapper behavior does not establish a read from bank 4B at that pointer. The bounded loader therefore does not select the zero record. This says nothing about other readers, writes, copies or aliases: global use and purpose remain unknown, and the record is not classified globally unused.

## Whole-source bank-42 consumer census

Additional bounded indirect tables were checked: result-page banners use bank 4B (`engine/account/result_page.asm:186–261`); startup notice headers use banks 58/4B/71 (`engine/startup/notice_pages.asm:196–250`); declared help-picture records use banks 60/61/5B (`engine/help/help_script.asm:644–766`); valid glyph rows use banks 76–7E or FF (`engine/text/glyph.asm:27–68,169–226`); examined canvas/scroll GDMA inputs come from WRAM (`engine/text/canvas.asm:2029–2063`, `engine/gfx/scroll_split.asm:62–84`). These paths yield no positive bank-42 consumer for the six residual spans.

`BankSwitch_H/D/B`, `ReadByteFar`, and `Gfx_StartHDMA*` accept dynamic bank inputs (`home/bank_switch.asm:7–66`, `home/far_read.asm:7–69`, `home/gfx_upload.asm:7–92`); sprite hooks restore a bank from a WRAM slot (`home/sprites.asm:32–43`); and `PalLibCandidate_WriteRomBankLowAAndZeroHigh` writes a caller-provided A (`engine/gfx/palette_library_candidate.asm:146–151`).

## Five candidate spans rechecked against the current 72-scenario corpus

| Candidate span | Executed instruction starts | Recorded callgraph destinations | ROM data-read overlaps |
|---|---:|---:|---:|
| `2B:6CF5–6DB0` (`MailReply_ComposeFromRecord`) | 0 | 0 | 0 |
| `2D:4E42–4E8C` (both body-locator entries) | 0 | 0 | 0 |
| `29:50CE–5145` (palette-library wrapper and leaf) | 0 | 0 | 0 |
| `70:4740–477F` (`SaveCheck_GetStateBlockBit7`) | 0 | 0 | 0 |
| `55:5DF5–5E02` (keyboard fragment) | 0 | 0 | 0 |
