# Banked WRAM pointer operands (ramop7): independent reference of the first version

### 0. Verdict counts

| item | UPHELD | CORRECTED | DROPPED |
|---|---|---|---|
| Rule rows (8) | 7 | 1 (`ConnIcon_UpdateState` proof text) | 0 |
| Operands (1,516 = 1,506 tool + 10 hand) | 1,516 | 0 | 0 |
| `wSpriteSlots + N` rewritten (525) | 523 | 0 | 2 (`engine/mail/mail_viewer_sender.asm:84,85`) |
| `wSpriteSlots + N` left as is (4 "other bank") | 4 correct to leave | | |
| `wSpriteSlots + N` left as is (133 "bank not shown") | 89 are provable bank 7, 1 is PROBABLE, 20 expected bank 1, 23 have no known entry | | |

### 1. Rule file

| row | verdict |
| --- | --- |
| Sprite_InitSlot 00:0A82 | UPHELD |
| Sprite_SetPosition 00:0A65 | UPHELD |
| Sprite_ClearSlot 00:09E6 | UPHELD |
| Sprite_SetHook 00:0A45 | UPHELD |
| Palette_LoadToBuffer 4F:4000 | UPHELD |
| Palette_UploadBuffer 4F:404B | UPHELD |
| Palette_ReadHardwareToBuffer 4F:400E | UPHELD |
| ConnIcon_UpdateState 69:4034 | CORRECTED |

### 3. Sites left numeric in `$DA00-$DAFF` and `$D800-$D87F`

| site | what it is |
|---|---|
| `save_sender_address.asm:1313`, `page_list.asm:1503`, `mailbox_screen.asm:1300` | `bc=$DA00` to TextTiles_RenderLine; `hTextTiles_DestBank` = $02 is set a few lines above each, so bank 2 |
| `mobile_dictionary_view.asm:21` | bank 6 idiom, FillBytes of $600 |

### 4. `wSpriteSlots + N`

| file | n |
| --- | --- |
| `address_picker.asm` | 22 |
| `save_sender_address.asm` | 14 |
| `frame_style_chooser.asm` | 2 |
| `page_list.asm` | 20 |
| `start_choice.asm` | 1 |
| `scroll_split.asm` | 2 |
| `body_editor.asm` | 16 |
| `send_receive.asm` | 1 |
| `page_list_prototype.asm` | 59 |

### 6. Tool and tests

| id | minimal input | tool result | note |
|---|---|---|---|
| R1 | `ld a,$07 / ldh [hWRAMBank],a / ldh [rSVBK],a / call SwitchToBank3 / ld hl,$D800 / farcall Palette_UploadBuffer`, with `SwitchToBank3:: ld a,$03 / ldh [hWRAMBank],a / ldh [rSVBK],a / ret` | `ld hl, wPaletteBufBg` | Calls between idiom and site are never checked.  Elements variant: `ld [wSpriteSlots + 17],a` after the call becomes `wSpriteSlot1 + $01`.  Real case: `mail_viewer_sender.asm:84-85`. |
| R2 | same idiom, `.loop / ld hl,$D800 / farcall Palette_UploadBuffer / call SwitchToBank3 / jr nz,.loop` | rewritten | `loop_head_keeps_bank` only looks for direct `rSVBK` writes. |
| R3 | idiom, `ret`, blank, `push bc / ld hl,$D800 / farcall Palette_UploadBuffer` | rewritten | The scan crosses an unconditional `ret`/`jp X`/`jr X` into a fragment with its own entry.  The tree has such fragments (`MailBody_PlaceCursorSprites`, `Gfx_GdmaAtVBlankNoDi`), though none hit. |
| R4 | `ld hl,$DA10 / farcall_raw $4123,$20 / call Sprite_SetPosition` | `wSpriteSlot1` | `farcall_raw` is not a transfer.  Unused today (0 sites). |
| R5 | `ld hl,$D800 / call Sprite_InitSlot` | `wPaletteBufBg` | A rule knows consumer and bank, not the family of object.  Real data: only `$DA00-$DAD0` reach the Sprite_* consumers. |
| R12 | idiom, then `ld a,$03 / ldh [$FF70],a` | rewritten | Numeric spelling of rSVBK is not seen.  Only in comments today. |
| R13 | `ld hl,$DA10 / ld a,[HL] / call Sprite_InitSlot` | rewritten | Upper-case operand is not seen.  Lower-case everywhere today. |
| E16 | `ld a,[wSpriteSlots + 16 * 3]` | `wSpriteSlot1 * 3` | The value changes.  The ROM compare would catch it.  Also `wSpriteSlots - 1` becomes `wSpriteSlot0 - 1` (same value, wrong object). |

Safe cases (no false accept): `call nz, Sprite_InitSlot`, `jp hl`, `call .local`, comments holding the idiom, idiom for another bank, `ld a,$07 / inc a / ldh ...`, two loads of the same register, a label in between, CRLF, same local label in two routines.

* (1) In `bank_switch_before`, after finding the idiom, re-scan the segment before the site and refuse on: an unconditional `ret/jp/jr`; `call`/`farcall` to a routine not on a bank-neutral allow-list (or with a computed summary); `call BankSwitch_*`; `[$FF70]`/`[$FF8D]`.

Apply the same to the loop body in `loop_head_keeps_bank`.

* (2) Treat `farcall_raw` as an unknown consumer.

The reader's patched variant of (1) with an allow-list, on the real tree, drops exactly 7 idiom-only elements and 0 operands: `mail_viewer_sender.asm:84,85` (correct) and 5 `mail_session.asm` ones (197, 447, 531, 1471, 1550) that are fine once `MailSession_UpdateTimerDisplay` is allow-listed.  The executed ones among them stay via the observation.

Missing tests: none of R1-R13/E16 is covered by `test_ram_operands.py`.

### 7. Equivalence

* `make`: RESULT: IDENTICAL.
* The reader's own diff script over `git diff -U0` (1,857 hunks, 2,041 line pairs): 1,516 pointer operands and 525 element expressions, all the same value after normalising names (DEF values from `ram/*.asm`), comments unchanged, 0 problems.
* Audits, tests and checks as in section 6.

### 8. Documentation claims

* `--elements`: "`N + 128` becomes `<element> + $00`-style" is inexact.  Offset 0 gives the bare name `wSpriteSlot8`.
* "first `call`/`farcall`": omits the tail `jp Label` that the code accepts.
* "(no label in between)": loop heads are passed.
* "the idiom earlier in the same straight line": the scan is limited to 60 lines, and calls, `ret` and `jp` in between are not checked (R1, R3).
* The module docstring never says that `--elements` needs bank proof (idiom or `--observed`), and its usage line lacks `--observed`.
* "memory operand or pointer with an offset" overstates the filter.  Any tab-indented line without a quote is matched.

* "of that bank must stand earlier in the same routine" has the same 60-line and no-call-check gaps.
* The loop-head sentence is accurate.
* Everything else that was checked is true, including the bank-6 and bank-2 meanings of `$DA00`.
* `line_addresses.py` prints two columns (bank, address), not "bank:address" (trivial).

* "`Palette_LoadToBuffer` writes single palettes" is false (132 of 173 sites copy 64 bytes).
