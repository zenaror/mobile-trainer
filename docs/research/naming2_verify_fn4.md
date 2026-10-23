# Naming pass 4: independent verification of the 31 function rows

> Status: **reference (current)** for the corrections it lists.  Verified manifest: [`analysis/naming2/fn4_renames.tsv`](../../analysis/naming2/fn4_renames.tsv)
> (it already carries these corrections); the verifier's own correction rows: [`analysis/naming2/verify_fn4_fixes.tsv`](../../analysis/naming2/verify_fn4_fixes.tsv);
> the pass itself: [`naming2_fn4.md`](naming2_fn4.md).

Verification of the first manifest of naming pass 4 (31 rows, the residual neutral `Function_*` labels) on 2026-10-05 by a reader with a fresh context that had not
seen the reasoning behind the rows.  Rules it was given: try to refute every row from the code, the callers and `analysis/coverage_union.tsv` / `coverage_forced.tsv`;
the repository stays read-only (builds only in a private copy); a name survives only when it is re-derived.  The reader could not write this report as a file (the
harness asks subagents to return findings as text), so the text of its final reply is reproduced below, lightly reformatted.  The numbers in it were re-checked against
the tables where the corrections were applied (section 7).

## 1. Result

Counts: **UPHELD 17, CORRECTED 12, DOWNGRADED 1, RETRACTED 1** (rows numbered as in the first manifest).

* UPHELD: 1, 2, 4, 6, 7, 9, 10, 11, 12, 13, 15, 16, 17, 19, 21, 23, 29.
* CORRECTED: 3, 5, 8, 14, 18, 22, 24, 25, 26, 27, 30, 31.  Two of them change the name (24 and 31), the others only the evidence text.
* DOWNGRADED: 20 (CONFIRMED to PROBABLE, name kept).
* RETRACTED: 28 (the neutral name is kept, HYPOTHESIS).

Names or statuses that changed:

| row | old label | before | after |
|---|---|---|---|
| 24 | `Function_2F_4496` | `AddrBook_ClearEditBuffers` PROBABLE | **`Abook_Clear16AtHlAndEditAddressBuf`** PROBABLE |
| 31 | `Function_7F_4E85` | `PageListProto_UploadCanvas` PROBABLE | **`Canvas_UploadToVramWrapper`** PROBABLE |
| 20 | `Function_75_673A` | `MobileSDK_ResetRxWindowAndResultPtr` CONFIRMED | same name, **PROBABLE** |
| 28 | `Function_24_42B0` | `PageList_CopyDefaultUrl` PROBABLE | **neutral name kept, HYPOTHESIS** (idea `PageList_CopyGooUrlAndTitle` recorded) |

Validation of the corrections: in a fresh private copy `tools/apply_renames.py --manifest merged.tsv` gave 30 applied, 1 HYPOTHESIS not applied, 0 refused,
`SHA-256 OK 6d802e66...6570`, `sym_check OK`, and `make` printed `RESULT: IDENTICAL`; the original manifest also dry-ran with 0 refusals.  The real repository was not
touched.

Findings that matter beyond the names:

* **Rows 3 and 8: the "`hJoyHeld` test" does not exist.**  `ldh a, [n]` sets no flags, and after a farcall the Z flag is always 1 for a ROM caller (`FarCall_Common` at
  `00:06EE` ends in `call BankSwitch_H`, whose last flag write is `or a, a` or `bit 7, h`, and both leave Z = 1).  So both `call nz` sites are dead by construction:
  `24:4D45` ran 38,854 times with 0 taken although A was pressed 151 times, and a replay of the real code with `hJoyHeld = $FF` gives Z = 1 and no call.  A tree-wide scan
  finds exactly these two sites that branch on farcall flags.
* Row 5: there are 13 farcall sites, not 14, and nothing shows what was patched at `48:48BB`.
* Rows 25-27: the contradictions that the earlier pass had recorded had been dropped from the evidence (the two flags are never written; the indexes 4-6 fall outside
  the two-entry ticker table; "item 1" is the page-list choice).
* Row 18: the pushed-return-address trick is sound (every `ret` reachable from the handlers is at stack depth 0).
* Row 30: the two `call $21A0` of the dead variant land in zero padding.

## 2. Method

`tools/sm83.py` disassembly of `baserom.gbc` with the coverage numbers; raw ROM scans of every reference form (`call`/`jp`/`jr`, conditional calls and jumps,
`ld r16, imm`, the `CD D1 06 lo hi bank` farcall pattern, bare words); `apply_renames --dry-run` reference counts; control-flow and stack-depth walks; and a small
CPU-only SM83 interpreter (ROM, SRAM and WRAM banking, no interrupts) that replays real ROM code for five checks (marked "replay").

## 3. Stub rows (1-9): is `Stub_Nop_<bank>_<addr>` honest?

Yes for all nine.  Every body is the single byte `$C9` (`ret`), touches no flag or register, and is a literal no-op, like the precedent `Stub_Nop_7F_61FC`
(`push af ; pop af ; ret`).

1. `Function_68_4282`: **UPHELD** (CONFIRMED).  `68:4282 = c9`; `68:4283` is the separate `Sram_WipeBanks2And3`.  The only reference in the ROM is the `farcall` at `67:58CD`
   (first instruction of `PasswordChange_Run`, `password_change.asm:11`).  175 hits / 13 scenarios, equal to the call site's count.
2. `Function_5C_5266`: **UPHELD** (CONFIRMED).  Only caller: `call nz` at `5C:5246` (`comm_error_screen.asm:109`), after `ldh a, [hJoyPressedRepeat] ; and a, $F0`, a real D-pad test.
   The call ran 105,306 times and was taken 103 times; callee 103 hits / 12 scenarios.
3. `Function_24_53FC`: **CORRECTED** (evidence; name and PROBABLE kept).  `24:53FC = c9`, never executed (union and forced).  Only caller: `call nz` at `24:4D45`
   (`page_list.asm:1797`).  Error in the evidence: "after the hJoyHeld test".  The code is `farcall Joypad_Update ; pop bc ; ldh a, [hJoyHeld] ; call nz, ...` and LDH sets no
   flags, so Z is the farcall's (see section 1).  `24:4D45` ran 38,854 times with 0 taken although hJoyPressed bit 0 was set 151 times (`24:4D4E`).  Replay of
   `FarCall`, its trampoline and `BankSwitch_H` from `24:4D3C` with `hJoyHeld = $FF` and initial F = `$00/$80/$10`: F = `$A0` each time and no jump to `53FC`.
4. `Function_24_53FD`: **UPHELD** (CONFIRMED).  `24:53FD = c9`; `53FE-53FF` are zero padding, tiles from `5400`.  Only caller: `call` at `24:4BD0` (`page_list.asm:1614`),
   directly after `call PageList_ActionMenuInit`.  61 hits / 8 scenarios, equal to the callee.
5. `Function_48_48BB`: **CORRECTED** (evidence; name and CONFIRMED kept).  `48:48BB = c9`.  Raw scan: 13 farcall sites (`19:400A`, `19:498A`, `1A:400A`, `1B:404A`, `1D:400D`, `1F:400D`,
   `48:498C`, `48:49DB`, `48:4A4E`, `50:406C`, `57:400C`, `5C:515C`, `6C:59BD`); `apply_renames` agrees (code = 13 in 12 files); the first manifest said 14.  Three are forced-only
   (`19:400A`, `19:498A`, `1B:404A`, the debug screens).  The other ten sum 36 + 784 + 780 + 125 + 358 + 426 + 4 + 480 + 145 + 289 = 3,427, equal to the callee's 3,427 hits / 58 scenarios.
   Ten of the 13 sites follow `FillBytes $C0D4, $FC`.  The `checksum3.asm` header says "patched-out 48BB hook", but "(its first byte was replaced by this ret)" contradicts the bytes:
   `48BC` starts with its own `cd e1 48`, the same as `Sram_VerifyChecksum3`, so the `ret` is an extra byte before it.  Nothing shows what was patched.
6. `Function_26_5343`: **UPHELD** (CONFIRMED).  `26:5343 = c9`.  Only caller: `call` at `26:58E0` (`mail_session_screen.asm:1153`), after four pushes at the top of
   `MailSession_UpdateTimerDisplay`.  171,411 hits / 22 scenarios, equal to the callee.  Correction dated 2026-10-15: the earlier description of the following 56 bytes (`5344-537B`) as a "separate, complete, unreferenced function" overstated the evidence. They are now a PROBABLE code fragment; an independent entry and its intended role remain HYPOTHESIS. See the dated storage analysis below.
7. `Function_2E_4EB1`: **UPHELD** (CONFIRMED).  `2E:4EB1 = c9`.  Raw callers: `2E:4E02` (29 runs), `4E39` (5), `4E74` (0), `4EAB` (0), each `di ; ldh a, [rLCDC] ; call $082C
   (Gfx_UploadBgMapBuffers) ; ei ; call $4EB1`.  34 hits / 7 scenarios, equal to the callee.
8. `Function_7F_61E6`: **CORRECTED** (evidence; name and PROBABLE kept).  `7F:61E6 = c9`.  Only caller: `call nz` at `7F:5ADB` (`page_list_prototype.asm:1852`), the same flag-less pattern
   as row 3.  Errors: "after the hJoyHeld test" (as row 3) and "only a forced run reaches that screen": the forced runs cover only the text-canvas demo (`7F:4BBC-4E88`);
   nothing from `7F:4E89` on ran, so nothing of the page-list prototype (`7F:5989-5B2D`) was executed by any run.
9. `Function_7F_61E7`: **UPHELD** (PROBABLE).  `7F:61E7 = c9`; sole caller `call` at `7F:598C` (prototype line 1707), right after `call PageListProto_ActionMenuInit`.  Never executed.
   `7F:61E8` starts a separate HYPOTHESIS function.

## 4. Text engine (10-14), dial, boot, string (15-17, 21)

Re-read at `00:1044-10E4`.  Counts: `1044` 185,151; `1059` 185,150; `1079` 185,149; `10A3` 185,147 (the 1-2 differences are traces cut mid-routine); `10B1` / `10C6` / `10DB` 40,698.
No clip jump of either path was ever taken: the jumps at `104A`, `105C`, `1062`, `1086`, `108B`, `1091`, `10B5` and `10BB` fall through every time.  So the clip conditions are code
reading and the main path is demonstrated.  Left/right: `Glyph_KuTenAddr` returns HL = `$C0A0` and BC = `$C0B8` (pop order AF, BC = old DE, HL = old BC);
`Glyph_UnpackWideHalvesDoubled` fills HL first and BC second; the blits go `$C0A0` at X, then `$C0B8` at X + 6, and X grows rightwards, so `$C0A0` is the left-placed half.

10. `Function_00_1059`: **UPHELD** (CONFIRMED).  After the inline bytes of `farcall Glyph_LoadWide`: `ldh a, [hTextX+1] ; or a ; jr nz, 1079 ; ldh a, [hTextX] ; cp $A0 ; jr nc, 1079`; then
    B, C = `FFBA/FFBB`, D = `hTextY`, E = `hTextX`, HL = `$C0A0`, `farcall Canvas_BlitGlyph`, falls into `1079`.  The Y test (`cp $90`) comes earlier, at `1048-104A`.  185,150 hits / 38 scenarios.
11. `Function_00_1079`: **UPHELD** (CONFIRMED).  `hTextX += 6` (16-bit), then the tests `jr nz`, `cp $A0`, `hTextY cp $90`, then D = Y, HL = `$C0B8`, `farcall Canvas_BlitGlyph`; falls into `10A3`.
    Jump sources: `00:104A`, `105C`, `1062` (the first manifest's "shortcuts at 00:1044 / 1059" named blocks, not instructions: imprecise, not wrong).  185,149 hits / 38 scenarios.
12. `Function_00_10A3`: **UPHELD** (CONFIRMED).  `hTextX += 6` (16-bit) and `ret`; jumps come from `1086`, `108B` and `1091`; `ld e, a` is a dead store.  185,147 hits / 38 scenarios.
13. `Function_00_10C6`: **UPHELD** (CONFIRMED).  After `farcall Glyph_LoadAscii` (DE = `$C0A0`): B, C = `FFBA/FFBB`, D = Y, E = X, HL = `$C0A0`, `farcall Canvas_BlitGlyph`; falls into `10DB`.
    There is no Y test on this path.  40,698 hits / 27 scenarios.
14. `Function_00_10DB`: **CORRECTED** (evidence).  Error: "clipped cases at 00:10B1 / 10C6 entry".  The clip jumps are `jr nz` (`10B5`) and `jr nc` (`10BB`) inside the `10B1` block; the `10C6`
    block has no jump.
15. `Function_00_158D`: **UPHELD** (CONFIRMED).  `00:1586 push de ; farcall Settings_GetHiddenModeFlag` (`dw $44FC`, `db $68`); then `158D: or a ; jr nz, .l15BD`.  The flag function returns
    `([sSettingsHiddenMode] xor $A5) != 0` as 0/1.  Flag 0: `wMobileAdapterType` indexes `Dial_DefaultNumberTable` (`68:67AE`), then `CopyString` to DE (69 runs, 10 scenarios).  Non-zero: SRAM bank 1
    and `sSettingsSelectedDialEntry` xor `$A5` through `Table_Dial_SramEntryPtrs` and `DecodeXorA5` (10 runs, 1 scenario).  `158D` itself: 79 hits / 11 scenarios, the sum of the three farcall
    sites (`4C:4395` 4, `67:5B2A` 15, `67:61A1` 60).  Nothing references `$158D` (the old comment "raw refs 11" is stale).
16. `Function_00_032E`: **UPHELD** (PROBABLE).  `jp $0328` right after the inline bytes of `farcall Main_Run` (`0328` ran 663 times); `032E` never ran.  `Main_Run` (`1C:4000`) is
    `farcall Startup_Run ; Main_TitleLoop: farcall Title_Run ; call JumpTableInline`, and all three targets end in `jp Main_TitleLoop`: it does not return.
17. `Function_00_14D1`: **UPHELD** (PROBABLE).  `14D1: ld a, c ; or b ; jr z, .l14DD ; ld a, [hli] ; ld [de], a ; inc de ; dec bc ; or a ; jr nz, CopyStringMax ; ret`;
    `.l14DD: xor a ; ld [hl], a ; ret`.  Answer to the question asked: yes, the BC = 0 path writes to the SOURCE (HL is still the source start, DE is untouched); the check exists only at entry,
    later iterations run in `CopyStringMax` (`ret z`, no write).  All four callers load `ld bc, $0010` immediately before the call (`68:4645`, `4651`, `465D`; farcall at `68:4725`), so the BC = 0
    branch cannot run from any known caller.  36 runs / 3 scenarios (11 + 11 + 11 + 3).  Wording note: "OnEmpty" can read as an empty string; the condition is the max count BC = 0
    (`..._ZeroSrcIfMaxZero` would be clearer; not required).
21. `Function_68_4495`: **UPHELD** (PROBABLE).  `ld a, [hli] ; or a ; jr nz, 4495` has no `ret`; `68:4499` is `Settings_SetSelectedDialEntry` (`ld a, b ; xor $A5 ; ld [$B013], a`).  The fall-through is
    in the ROM bytes, and `4499` has 4 other callers.  Four call sites in two pairs in `Dial_SelectEntryFromList` (`446E/4471` and `447E/4481`).  Replay of `Dial_SelectEntryFromList` on a 3-entry list:
    A = 1/2 with a non-empty entry string returns A = B, HL at that entry, and `$B013` decodes to B, although this path never calls the setter itself; an empty entry string stores 0 explicitly and
    returns 0 with HL at the list start; A >= 3 returns `$FF` and leaves 3 stored.  So the implicit store is what persists the selection, and the name states it.  `4469` ran 121 times / 31 scenarios,
    always returning at `ret z`.  ("Used twice in a row" is really four calls in two pairs; minor.)

## 5. SDK (18-20), address book (22-24), BrowserStart (25-27), rows 28-31

18. `Function_75_5E31`: **CORRECTED** (evidence, minor; name and CONFIRMED kept).  `ld hl, $5E31` is at `75:5B6D` and `push hl` at `5B70` (`5B6C` is the `ld b, a` under `.skip`).  `5E31 = jp $4029`
    (`Mobile_ResetReceivePacketBuffer`: zeroes the 16-bit count at `C8D7/8`).  Static walk from the default path (`5BAC`) and the 13 handlers (`5BC7`, `5BD3`, `5BD9`, `5BE9`, `5BF9`, `5C0F`, `5C20`,
    `5D2C`, `5D42`, `5D6E`, `5D79`, `5E34`, `5F01`), over `jp`/`jr`, with calls assumed balanced: every terminal is a `ret` at stack depth 0, no SP changes, no `jp hl`; seven of those `ret`s never ran.
    Dynamic: the push (`5B70`) ran 19,653 times, as did `5E31`, in 62 scenarios.
19. `Function_75_5F96`: **UPHELD** (CONFIRMED).  `dec de ; ld a, [de] ; add a, l ; ld l, a ; ld a, 0 ; adc a, h ; ld h, a ; dec b ; ret`.  Callers `75:5F75` (144,694) and `5F7C` (21,500) = 166,194 / 62 scenarios.
    The `jr nz` after each call tests the `dec b`; B is the bytes left (first loop B = data length, second loop B = 4, the header).  Replay of `Mobile_PacketBuildFooter` with DE = `$C010` and B = 3:
    the sum covers bytes `C009..C00F` (backwards, 4 header + 3 data), `hi lo $80 $00` is written at `C010`, and DE = B + 10.
20. `Function_75_673A`: **DOWNGRADED** (CONFIRMED to PROBABLE) plus an evidence fix.  `673A: ld a, $FF ; ld [$C70D], a`, then falls into `MobileSDK_ResetRxWindow` (`673F`: `[C6C8/9] = $C71F`,
    `[C6CA/B] = $00FF`).  11 callers (raw scan = `apply_renames` = manifest); counts 49 + 11 + 17 + 16 + 16 + 72 + 14 + 19 + 8 + 60 + 58 = 340, in 26 scenarios (the first manifest said "in 4 scenarios").
    The old note was already PROBABLE and no new fact was cited; `MobileSDK_ResetRxWindow` is PROBABLE in `config/symbols/bank75.tsv`, and `wMobileSDK_ResultPointer` is a PROBABLE role with documented dual use.
    At `75:4833` the caller stores D into `C70E` and then calls this routine, so "reset the result pointer" is not what that call does.  The stores are demonstrated; "ResultPtr" is not.
22. `Function_2C_60B3`: **CORRECTED** (evidence; name and PROBABLE kept).  Body `2C:60B3-60FF` (the generator's "102 insns" counts the sibling too): SRAM bank 1 on, then for 6 slots HL = `[Table_AddrPick_SlotAddrs + 2i]`,
    E = `$28`, D = 12*i, B = 3, C = 0, `call AddrBook_DrawSlotName`; SRAM off.  The first manifest omitted E = `$28` and cited a dead sibling (`5FB1`) as support.  The real support is the executed
    `SaveSenderAddr_DrawSlotNames` (`2A:422C`, 27 runs / 6 scenarios): same table values, E = `$28`, B = 3, C = 0; the live one adds `add a, $10` to Y.  The operation right after (`2C:6100-614C`, now labelled `AddrPick_DrawSixSlotNamesAtX30`)
    is the same with E = `$30`.  Nothing in the ROM references `60B3`.  PROBABLE follows the precedent accepted for `2C:5FB1` (a dead twin of live code); a dead routine with no live twin would be HYPOTHESIS (row 28).
    Optional: a `_X28` suffix, as in `AddrPick_MoveNameHighlight_X28_2C_5FB1`.
23. `Function_2C_5CD2`: **UPHELD** (PROBABLE).  `di ; VBK = 1 ; wait LY == $90`, then 13 bytes per row.  `$08` goes to `$9866` and `$9886`; `$04` goes to `$98C6`, `$98E6`, `$9906`, `$9926`, `$9946`, `$9966`, `$9986`, `$99A6`,
    `$99C6` (row `$98A6` is skipped).  `$08` is attribute bit 3 (tile bank 1) and `$04` is palette 4: correct.  Then `ei`, WRAM bank 7 and the same pattern into `$D466-$D5D2` (WRAM 7 stays selected).  It is the twin of
    `AddrPick_InitListAttrs` (rows 6-14 with `$00`).  Callers: `2C:6022` (inside the dead `5FB1`) and `2C:60A3` (live, only when new cursor - 1 = `$FF`; the `jr z` at `6078` was never taken in 104 runs).  Never executed.
    The evidence was incomplete, not wrong.
24. `Function_2F_4496`: **CORRECTED** (name, prefix, evidence).  PROBABLE.  `4496: push af ; push bc ; WRAM 1 ; ld b, $10 ; ld de, $D514 ; loop xor a ; ld [hli], a ; dec b ; jr nz ; ld b, $40 ; ld hl, $D4C0 ;
    same loop ; pop bc ; pop af ; ret`: the first loop stores through HL and DE is dead.  Only caller: `call` at `2F:4350` (`list.asm:525`), reached by `jr z` after `call Abook_ProbeSlot ; cp 0`.  `Abook_ProbeSlot`
    (`2F:44B5`) returns HL = slot record + `$10` and A = `[HL]`, with SRAM bank 1 enabled.  Replay, slots 0-5: HL = `A6AD`, `A6FD`, `A74D`, `A79D`, `A7ED`, `A83D`; `4496` then zeroes 16 SRAM bytes at HL and
    `D4C0-D4FF`, and leaves `wEditNameBuf` (`D514-D523`, pre-filled) untouched.  So "ClearEditBuffers" is false; the first manifest's own text said "DE = $D514 loaded but unused: the stores go through HL" and still
    concluded the opposite.  The earlier pass had already noted "HL left by the caller: slot field".  Prefix: in this file and bank the labels are `Abook_` / `AbookList_`; `AddrBook_` belongs to `address_picker.asm`
    and `save_confirm.asm`.  PROBABLE because `wEditAddressBuf` is a PROBABLE RAM name; the stores themselves are demonstrated (14 runs / 8 scenarios).
25-27. `BrowserStart_DescIndex_AdjustItem1/2/3`, all called from `BrowserStart_ShowDescription` (`73:62AA`): `ld a, [wRam_C0E5] ; ld b, $FF ; .loop inc b ; srl a ; jr nc` gives B = index of the lowest set bit of
    `C0E5` (`C0E5 = 1` gives B 0, `C0E5 = 2` gives B 1); then `cp 1 / cp 2 / cp 3` call the three helpers; then `farcall Ticker_Start`, which uses B*4 + `$4001`, so B is the 4-byte entry index (title pointer +
    text pointer) into `BrowserStart_StringTable`, which has 2 entries.  `C0E5` is only 1 (homepage) or 2 (page list): it is loaded from `sSram_A8B7` (or 1) and toggled with `dec a ; xor 1 ; inc a`.  So "item 1" is
    the page-list choice, and items 2 and 3 are never produced.  `C0F8` and `C0F9` are only read (`73:6143/62D2` and `6149/62DA`); no store exists in the ROM, they are zeroed by the screen-entry `FillBytes` of
    `$C0D4-$C1CF`.  B = 4, 5, 6 would index inside the strings (`$4011`, `$4015`, `$4019`).  The earlier pass had these facts ("role is unproven"); the first manifest dropped them.  All three: **CORRECTED** (evidence;
    PROBABLE and names kept: they say what the code does to B, "item" is the 0-based B).
    * 25 `Function_73_62D2`: `ld a, [$C0F8] ; or a ; ret z ; ld b, 5 ; ret`.  The `call z` at `62B7` ran 282 times / 14 scenarios and was taken 83 times / 8 ("the call executed 83 times" mixed the two).  The B = 5 branch never
      ran and cannot with this data.  "First string index" is wrong; it is an entry index.
    * 26 `Function_73_62DA`: `ld a, [$C0F9] ; or a ; ret z ; ld b, 6 ; ret`.  Never executed.  B = 6 is outside the table; `C0F9` is never written.
    * 27 `Function_73_62E2`: `ld a, 1 ; ld hl, $A9ED ; call ReadByteFar ; bit 7, a ; ret z ; inc b ; ret`.  Never executed.  B = 4 is outside the table.
28. `Function_24_42B0`: **RETRACTED** (neutral name, HYPOTHESIS).  After a stray `ret` at `42AF`: WRAM 6; `de = $D500, hl = $42D1` copy to NUL; `de = $D3C0, hl = $42E7` copy to NUL; `ret`.  `42D1` = "http://www.goo.ne.jp/";
    `42E7` = Shift-JIS "くーくー" (bytes `82 AD 81 5B` x2; the `.asm` comment says ぐーぐー).  Raw scan: nothing references `24:42B0`; never ran, not even forced.  New fact: `PageList_SaveCurrentPage` (`24:4F14`)
    starts `ld hl, $D500 ; ld a, [hl] ; cp 0 ; ret z` and copies `$D500` (256 bytes) and `$D3C0` (22 bytes, the URL when empty) into a slot, which makes the URL / title buffer roles PROBABLE.  "Default" is unsupported.
    Why retracted: the source already carries the earlier verifier ruling (HYPOTHESIS); the earlier pass kept it HYPOTHESIS ("the buffers are not proven to be the page URL/title"); the manifest header keeps dead
    code without entry proof neutral; unlike rows 22 and 30 there is no executed twin.  The idea `PageList_CopyGooUrlAndTitle` is recorded in `verify_fn4_fixes.tsv`.
29. `Function_55_6041`: **UPHELD** (PROBABLE).  `Kbd_IndexToColRow` (`55:615F`) returns B = index mod `$12` (column) and C = index / `$12` (row); `Kbd_ColRowToIndex` = C*`$12` + B.  Directions: A = 0 left (joypad bit 5),
    1 right (bit 4), 2 up (bit 6), 3 down (bit 7).  Type 1 + dir 0 + stickyRow = 3 gives `inc b`; type 3 + dir 2 + stickyCol = `$11` gives `inc c`; otherwise unchanged.  Replay of all cases matches.  Each branch adjusts the
    coordinate that survives in the caller: the horizontal handler overwrites C with the sticky row, the vertical handler overwrites B with the sticky column.  Callers `55:5FE5` (76) and `6011` (368), which are
    `keyboard.asm:664 / 685`.  444 hits / 13 scenarios; the type-1 `inc b` ran once (1 scenario), the type-3 branch never.
30. `Function_65_481A`: **CORRECTED** (evidence; PROBABLE kept).  Same callees in the same order as `Startup_VerifySaveData` (`65:416C`), headed by `Settings_VerifyAndRepair` (2: error screen and repair, 3: repair)
    instead of `SramCheck_Bank0Status`.  No reference to it in the ROM; never executed.  Both `call $21A0` (A = 4 with the result tested in B, and A = 3) land in zero padding `00:2183-3FFF` (7,776 bytes from `$21A0`),
    matching `dynamic_tracing.md` section 11.4 (7,776 NOPs): stale code of another build.  "SRAM writes through call $21A0" is unsupported (the callee does not exist in this ROM); only "called between SRAM enable and
    disable" can be said.  "Same checks" hid the different first check.
31. `Function_7F_4E85`: **CORRECTED** (name).  `call $4BBC (Canvas_UploadToVram) ; ret`.  The only caller is the `call` at `7F:4C81` in `Canvas_RunSampleDemo` (`page_list_prototype.asm:15`, right after `Canvas_InitScreen`),
    i.e. the text-canvas demo, not the page-list prototype (which calls `Canvas_UploadToVram` directly, `7F:5215`).  The earlier pass had already written "called once by Canvas_RunSampleDemo"; its neighbours are `Canvas_*`.
    New name `Canvas_UploadToVramWrapper`, PROBABLE.  The `forced_screens` run executed both instructions once; never naturally.

## 6. Every factual error found in the first evidence column

1. Rows 3 and 8: "`call nz` after the hJoyHeld test".  No flag-setting instruction exists; Z is the farcall's and always 1 for a ROM caller, so the call is dead by construction.
2. Row 5: "14 farcall sites" is 13 (10 natural + 3 forced-only).  "(HYPOTHESIS: its first byte was replaced by this ret)" contradicts the bytes.
3. Row 8: "only a forced run reaches that screen".  No forced run reaches the page-list prototype, only the canvas demo.
4. Row 14: "clipped cases at 00:10B1 / 10C6 entry".  The jumps are at `10B5` / `10BB`; `10C6` has none.
5. Row 18: `ld hl, $5E31 ; push hl` is at `75:5B6D` / `5B70`, not `5B6C`.
6. Row 20: "executed (14 instructions) in 4 scenarios" is really 340 executions in 26 scenarios; CONFIRMED is unsupported, PROBABLE.
7. Row 24: the conclusion contradicts the first manifest's own premise: HL = SRAM slot + `$10`, `wEditNameBuf` is not cleared, and the prefix is wrong (`Abook_`).
8. Rows 25-27: "B (first string index ...)" is the 4-byte entry index; "selected item is 1" is the 0-based lowest-set-bit index of the 1-based `wRam_C0E5`, i.e. the page-list choice; the facts that `C0F8` / `C0F9` are never
   written and that B = 4..6 index outside the 2-entry table were omitted; "the call executed 83 times": the instruction ran 282 times and was taken 83.
9. Row 22: the support cited is a dead sibling (`5FB1`), E = `$28` is omitted, and the real support is the live twin `2A:422C`.
10. Row 28: PROBABLE without a new fact over the earlier HYPOTHESIS; "Default" is unsupported.
11. Row 30: "SRAM writes through call $21A0" is unsupported (the callee is padding); "same checks" hides the different first check.
12. Row 31: wrong subsystem prefix; the prototype it names does not call the function.
13. Minor: row 11 "shortcuts at 00:1044 / 1059" are the blocks (instructions `104A`, `105C`, `1062`); row 21 "used twice in a row" is four calls in two pairs; row 1 "before the password-change page" is the first instruction of
    `PasswordChange_Run`.
14. Header: it cited `docs/research/naming2_fn4.md`, which did not exist yet (it does now).  The count "59 of them" is right (59 neutral `Function_*` labels, all 31 manifest labels among them).

## 7. Limits

* No mGBA, so no PPU or timing.  The five replays use a CPU-only interpreter written for this check (ROM, SRAM and WRAM banking, no interrupts) and cover only those routines.
* The coverage tables are the only whole-game dynamic evidence; absence from them proves nothing.
* RAM names used in the rows (`wEditAddressBuf`, `wEditNameBuf`, `wMobileSDK_ResultPointer`, `wKbdStickyRow`, `wMobileAdapterType`, ...) come from `ram/*.asm` (PROBABLE) and were not re-derived.
* The row 18 stack walk assumes called helpers return and follows `jp`/`jr` only; seven handler `ret`s never ran, so for those the evidence is static.
* The `Canvas_BlitGlyph` register contract (B, C = `FFBA/FFBB`, D = Y, E = X, HL = glyph) comes from its callers, not from reading the routine; left/right is placement (X then X + 6), and the font packing was not
  checked against a rendered glyph.
* The Ghidra project and the `traces/` files were not opened; forced-run facts are those of `analysis/coverage_forced.tsv` and `dynamic_tracing.md`.
* `make`, `make sym-check` and `apply_renames` ran only in the private copy.

## 8. Follow-up: the two layout rows (`Function_74_55BE`, `Function_74_57AD`)

Two more rows, proposed after the first report and checked by the same reader (same rules; replays of the real ROM code on synthetic records with the CPU-only interpreter, which support the reading and are not natural evidence).
**Both CORRECTED**: row 1 keeps its name and PROBABLE with corrected evidence; row 2 is renamed, PROBABLE kept.  Validation in a fresh private copy: `apply_renames` applied both, `SHA-256 OK`, `sym_check OK`, `RESULT: IDENTICAL`;
the names collide with nothing.  The corrected rows are in [`analysis/naming2/fn4b_renames.tsv`](../../analysis/naming2/fn4b_renames.tsv).

**Row 1, `Function_74_55BE` -> `Html_Layout_AddRecordToLine`.**
* Calls (raw scan and coverage): `call` at `74:54F1` (3,681 runs, 16 scenarios), `74:5505` (2,156, 15) and `74:55BA` (5,857, 16), `jp` at `74:5660` (never ran): 3,681 + 2,156 + 5,857 = 11,694 in 16 scenarios, as stated.  Text runs are appended with
  width 0 (`ld bc, $0C00` at `74:5447`) and accounted twice (at append and after `CloseRunRecord` with the final width): 5,837 text runs x 2 + 20 image records = 11,694.
* Contract: input HL = the record in the WRAM bank `hRam_FFBA`, already mapped by the caller (`AppendRecord` at `74:557B`, `CloseRunRecord` at `74:5538`); HL is preserved on every `ret` (callers rely on it: `AppendRecord` returns HL = record);
  A, BC, DE and the flags are clobbered.
* Steps: (1) if `hRam_FFC6 + FFC7 = 0` call `57AD` (4,461 times); (2) return if bit 7 of `[HL+9]` is clear (never was in the traces); (3) free = `FFC2:FFC3 - FFC4:FFC5 - [+4:+5]` (the `jp c, .l565C` was never taken);
  (4) if it fits, cursor += width and the height `[+6]` is merged into `FFC6` / `FFC7` by `and $30`.
* FFC6 / FFC7: `Html_Layout_PlaceLine` saves the pair, calls `GetLimitsAtY` (which zeroes it) and restores it, then baseline = Y + FFC6 (`74:56B7-56BD`) and next line Y = baseline + FFC7 (`74:5795-57A1`): FFC6 is the extent above the baseline,
  FFC7 below it.  In every traced run FFC6 was 0 and the whole height sat in FFC7 (the `ret nz` at `74:5625` never returned; FFC7 was raised 4,461 times).
* Branches (replay): `and $30` = `$00` / `$10`: only while FFC6 = 0, FFC7 = max(FFC7, h); `$20`: C = h/2 rounded to the nearest multiple of 12 (`Divide32by15`, remainder >= 6 rounds up), if FFC6 < C then FFC6 = C and FFC7 = h - C (FFC7 is overwritten,
  not max-ed; h = 30 gives 12 / 18, h = 36 gives 24 / 12); `$30`: if FFC6 < h then FFC6 = h and FFC7 = 0 (cleared only when FFC6 rises).
* Flag meanings are confirmed by data: the keyword table `Html_AlignValueNames` (`74:40C4`): right = `$04`, top = `$10`, centre = `$08`, middle = `$20`, left = `$0C`, bottom = `$30`.  Bit 7 is "pending", set by `AppendRecord`, cleared when placed; `GetLimitsAtY` ignores records with bit 7 set.
* Name: keep `AddRecordToLine`.  The demonstrated effect is accounting (cursor += width, height merged); "Wrap" or "Fit" would over-claim, because by replay the no-fit path does not move the record to a new line: `PlaceLine` places every pending record up to
  the one that overflows, including this one, and clears its bit 7, so the retry returns at once and the record overflows the old line; with `wHtmlAlign = $08` (centre) `PlaceLine` then shifts the line by about `$7FF8` because the `BC` it is passed
  (free - width) is negative (this path never ran).
* Status PROBABLE is right: the no-fit path, the `cp $10` test and the `$20` / `$30` branches never ran naturally.

**Row 2, `Function_74_57AD` -> `Html_Layout_BeginLineAndPlaceFloats` (renamed from the proposed `Html_Layout_PlacePendingFloats`).**
* Calls: `74:55C7` (4,461 runs, 16 scenarios, from `AddRecordToLine` when the line is empty) and `74:52E3` (20 runs, 2 scenarios, `Html_Layout_PlaceImage`, `layout.asm:111`): 4,481 in 16 scenarios, as stated.
* `$0C` = left float and `$04` = right float, confirmed three ways: `GetLimitsAtY` (`74:58C0-58F4`), the keyword table, and replay.  Left float: x = cursor, y = line Y, `+4:+5` = x + width, `+6:+7` = y + height, cursor = right edge.  Right float:
  x = limit - width, `+4:+5` = old limit, limit = x.  "Pending" = bit 7 (set by `or $80` at `74:5593`, cleared by `57AD` for floats and by `PlaceLine` for inline records, skipped by `GetLimitsAtY`).
* What creates float records: only `<img align=left>` (`$0C`) and `<img align=right>` (`$04`): `Html_Tag_Img` `74:4EB1-4ECB` parses `align` and stores it in `hRam_FFD5` (centre `$08` is deliberately skipped at `74:4EC5`); two places merge FFD5 into `hRam_FFB2`: `74:4E5A` (image
  record) and `74:4EFA` (the placeholder text run of a failed image, which would make a kind-1 float).  Both merges never ran, and the `align` branch is never taken (`74:4E21` falls through 34 of 34 times).  All 5,857 `AppendRecord` calls had
  `FFB2 & $0C = 0`; the stored flags in the traces are `$80-$82`.  Floats are real in the design: `Html_Layout_ClearAllFloats` and `<br clear>` exist for them.
* What `57AD` actually does: (1) `GetLimitsAtY(DE = line Y)` resets the cursor `FFC4` to the left limit (view + indent, moved past placed left floats), sets the right limit `FFC2` (narrowed by placed right floats) and zeroes `FFC6/FFC7`: it ran
  4,481 times and is the only effect seen in any trace; without it the next line would start where `PlaceLine` left `FFC4`, at the end of the old line, so this is the real line-start reset.  (2) A walk over the page's record list (the whole list,
  placed records included, about 33 records per walk, not "the line's list"): the fit test comes first and applies to every pending record whatever its kind; a pending record that does not fit is skipped and stays pending; the Y bump at `74:584A`
  adds `FFC6 + FFC7`, which `GetLimitsAtY` has just zeroed, so Y never moves (replay with FFC6/7 preset to 5/7 and Y = 40: Y stays 40); only then is `and $0C` tested: a float is placed with bit 7 cleared, other kinds are left for `PlaceLine`.
* Coverage: 148,662 loop passes, and 4,461 of them saw a pending record: exactly one per `55BE` call, the inline record just appended, which went through the fit test and the kind test and was skipped at `74:5801`.  The float code
  (`74:5803-5848`) and `74:584A` never ran, naturally or forced.
* Name: "pending" is right and "Floats" matches `ClearAllFloats`, but `PlacePendingFloats` leaves out the only effect that ever ran (a reader would not expect the cursor reset when no float exists), and it is the only code that resets `FFC4` between
  lines; hence `Html_Layout_BeginLineAndPlaceFloats`, which pairs with `Html_Layout_EndLine` (the shorter `Html_Layout_BeginLine` would also be defensible).  PROBABLE because the float half is static only.

**Errors in the proposed evidence text:** (1) "called at 74:55B8": the call is at `74:55BA` (`55B8` is `jr z, .done`); (2) "74:5513": the second `WrapRun` call is at `74:5505`; (3) the never-ran list was incomplete (also the `cp $10` test and the `$30`
branch `74:560F-5621`: `and $30` was 0 in all 11,694 calls and FFC6 was 0 in all of them); (4) "`$30` -> FFC7 = 0" holds only when FFC6 is raised, and `$20` overwrites FFC7 with h - C (not a max); (5) "retries": the retry returns at once and BC is negative at
that call; (6) "called at 74:55C0": the call is at `74:55C7`; (7) "the line's record list": it is the page's list, placed records included; (8) the no-fit handling of `57AD` was described wrongly (the fit test applies to every pending record and precedes
the kind test; the Y bump adds 0); (9) "only the no pending float path": 4,461 passes saw a pending inline record, and the name and evidence omitted the `GetLimitsAtY` effect that runs every time.  Minor: "pending/active" should read "pending" (not yet
placed); the layout "`+4:+5` width, `+6` height" holds only while the record is pending, because placement overwrites `+0..+7`.

RAM role hints from the same reading (not applied here): `hRam_FFC4:FFC5` line cursor X, `FFC2:FFC3` right limit, `FFC6` extent above the baseline, `FFC7` extent below it, `FFC8:FFC9` line Y, `FFCA:FFCB` next free record, `FFCC:FFCD` first record,
`FFCE:FFCF` record count, `FFBA` WRAM bank of the record list, `FFB0` record kind (1 text run, 4 image, 5 loaded image), `FFB2` style / alignment flags of the next record (bit 0 link, bit 1 bold, bits 2-5 as above).
Limits: replays use synthetic records and an own interpreter (no PPU, no timing); the layout was not compared with rendered output; the never-executed paths (wrap, vertical alignment `$10/$20/$30`, float placing) are static plus replay only; the RAM names
quoted come from `ram/hram.asm` as PROBABLE or HYPOTHESIS and were not re-derived.

## Finite fragment-comment corrections and conditional stack contracts (2026-10-15)

The current comments distinguish sequential bypass from a proof of universal unreachability. In each stack formula, S denotes SP at that specific fragment entry. In lib/mobile/mail.asm the old claim that47A5 must be a missing branch/jump-table target did not follow from JR47A3->47CF bypassing it. In parser/link_tables, POP HL74:43C3 and POP BC74:5B3E are bypassed by JP43C0->4307 and JR5B3C->5B3F; hypothetical entry changes SP by2 before the existing tail. Prior finite target/word searches are historical evidence, not proof excluding every computed/other entry. The retained confidence for entry/purpose is HYPOTHESIS; no new function, caller or label is introduced.

The same qualification applies to the two delete_flows branches23:4AA4->4B1A and4BE5->4C5D, and the three delete_hidden branches22:4BB5->4C2B,4D00->4D76,4E41->4EB9. The earlier JP bypasses each fragment sequentially. These statements replace the overbroad unreachable wording without inventing a reaching path. The23 branch bytes are1874 and1876, so the old twin wording must not imply byte identity. The three22 fragments have1874/1874/1876; displacement and destination are explicit. These22 corrections originate in ROOT's finite49..72 inventory, the23 corrections in the independently read25..48 lot; they are not new natural coverage.

At2E:[488A,48F8),110 original bytes contain four initial saves AF/BC/DE/HL. Under ordinary balanced callees, POP HL/DE/BC/AF48E9..48EC followed byRET48ED restores those four saves and returns through word[S] with SP=S+2. The branch at48BB can instead reach48EE: seven POPs at48EE..48F4 restore the four local saves, then consume three external words. RET48F7 takes PC=word[S+6] and leaves SP=S+8. In that alternate path finalA80 replaces the A popped from word[S]; F is the writable high nibble from that word's flag byte, HL=word[S+2],BC=word[S+4],DE is the restored entry DE. The old statement that matching POPs were not proven is superseded by this conditional walk, without supplying the external frame, intended unwind or a caller. Buffers/shadows/mapper/IRQ and stack nonaliasing must respect the existing helper contracts.

Two further positive stack contracts from the bounded review are recorded without creating entry labels.2D:[4B2D,4CA5),376 bytes, has PUSH BC4B2D, the balanced AF pair4BD9/4BF4, POP BC4C10 and another POP BC4CA3 beforeRET4CA4. With balanced callees and safe saved words, the first POP restores entryBC, the second consumes word[S], and RET takes word[S+2] with SP=S+4. Thus the sequence does not have a general conventional preservedBC return.2D:[5A60,5A6F) instead has one PUSH/POP BC pair around its keyboard-hide/scroll-clear sequence, and is balanced under ordinary callee completion. No valid outer frame or natural entry is inferred for either.

At0F:4D35, LD B82 falls into POP HL4D37, LD A1 and JP4260. The selected-bank tail writes selectorD002=1, POP AF4263 and its two FF8C stores plus4000 restore the saved SRAM-bank byte, thenRET426B. With S=entrySP and nonaliasing safe stack, HL=word[S], AF comes from word[S+2],PC=word[S+4],SP=S+6; finalA is the saved bank byte, not necessarily1. B remains82 through this literal tail. This explains the byteflow while leaving the external frame/entry/purpose HYPOTHESIS.

At75:[5118,5149),49 bytes/22 CPU starts, the literal code writes the received length through the pointer atC6C6, incrementsC82C, setsC709=0F/C70A=1/C70D=C70C/C826=0, then tail-jumps5F0B with A=A3,DE0010,HLC832. The tail stores the command and enters5F10. Its status helper may wait or return carry; the sender can reject an occupied serial phase, pollSC.bit7 without a deadline, or install resend/transmit state and enable interrupts before returning. Pointer alias/wrap, memory/banks, stack, IRQ and callee progress remain conditions. A descriptive conditional operation does not establish a completed send, full protocol purpose or natural entry.

Two ROOT-supplied literal corrections are also integrated. In2A:[56CB,56EC),33 bytes contain CALL6257, eight CALL577F sites56CE/56D1/56D4/56D7/56DA/56DD/56E0/56E3, JP54FD at56E6, and a separate CALL62C5 at56E9. The old count nine was wrong; the CALL after the unconditional JP is not its sequential continuation. In7C the JP7D88->7D57 bypasses the A0 prefix7D8B sequentially; independent entry remains HYPOTHESIS. The111B choreography at7D8D and its separate trailer keep their existing qualifications.

CONFIRMED here are literal bytes, counts and the stated instruction/stack transformations under the explicit balanced/no-alias assumptions. Conditional contracts are PROBABLE; entry/caller/purpose/domain and external unwind intent remain HYPOTHESIS. All owner physical rows, instructions/operands, locators, neutral/semantic labels and local scopes are preserved. This note is an append to the historical verification, not a rewriting of its prior methods/results. No new trace, replay, hardware observation, image/frame/asset work or whole-ROM/function-completion claim follows. Static correspondence is not a new reconstruction equivalence result.

## Contratos condicionais dos72 blocos anotados sem global — 2026-10-15

Os72 itens são os registros1-based do catálogo `unlabelled_hypothesis_comment_blocks`, não72 funções nem todas as entradas da ROM. Os três lotes fechados descrevem987 bytes/497 inícios CPU condicionais nos cores selecionados, com42 bytes inline FarCall separados. Caudas compartilhadas adicionais se sobrepõem ao código e não entram novamente nesses totais. O item20 reúne dois stores independentes de6B, e itens33/35/65 incluem terminações alternativas sem fallthrough. Nenhum rótulo/função foi criado nem storage cru convertido a código por este inventário.

CONFIRMED qualifica bytes, localizadores e partições dos lotes; PROBABLE qualifica a mecânica como execução condicional do decode mantido; entrada/caller/finalidade/domínio/frame sem demonstração continuam HYPOTHESIS. Um mecanismo local pode estar explicado sem um caller estabelecido. O nome de um parent/callee não prova ABI. O fechamento desses contratos não é ALL semântico, censo completo de funções, prova universal de reachability, execução natural ou hardware.

Na tabela, S é SP na entrada específica do fragmento. `word[endereço]` é a memória no instante em que a instrução a lê, não necessariamente o conteúdo inicial: PUSHs posteriores podem reescrever slots. `SP+N` é relativo aS. Todo retorno supõe palavras legíveis, mapping/fetch esperado e stack sem alias com buffers/seletores. Os callees precisam retornar balanceados para atingir os sufixos descritos; IRQ/reentrada/shadows, memória e domínio de argumentos devem respeitar os contratos completos dos lotes. Esperas, loops, mapper writes ou retornos via palavras externas podem impedir a continuação esperada.

### Owners

Os identificadores servem apenas para compactar a tabela; caminhos são os owners mantidos, não funções.

|Owner|Caminho|
|---|---|
|O01|`audio/engine.asm`|
|O02|`engine/account/registration_verify.asm`|
|O03|`engine/account/result_page.asm`|
|O04|`engine/account/settings_page.asm`|
|O05|`engine/address_book/address_editor.asm`|
|O06|`engine/address_book/name_editor.asm`|
|O07|`engine/browser/page_list.asm`|
|O08|`engine/comm/comm_scene.asm`|
|O09|`engine/comm/time_hooks.asm`|
|O10|`engine/html/link_tables.asm`|
|O11|`engine/html/parser.asm`|
|O12|`engine/keyboard/keyboard.asm`|
|O13|`engine/mail/address_editor.asm`|
|O14|`engine/mail/body_editor.asm`|
|O15|`engine/mail/mail_title_entry.asm`|
|O16|`engine/mail/received_mail_grid.asm`|
|O17|`engine/mail_server/delete_flows.asm`|
|O18|`engine/mail_server/delete_hidden.asm`|
|O19|`engine/mail_server/delete_messages.asm`|
|O20|`engine/mail_server/tidy.asm`|
|O21|`engine/main/navigation.asm`|
|O22|`engine/profile/profile_editor.asm`|
|O23|`engine/settings/continue_prompt.asm`|
|O24|`engine/sram/integrity_check.asm`|
|O25|`engine/text/charset_convert.asm`|
|O26|`engine/unreferenced/page_list_prototype.asm`|
|O27|`lib/mobile/mail.asm`|

### 72 cores selecionados

|ID|Owner:linha|Banco:[início,fim)|B/starts|Efeito e frame|Limites específicos|
|---:|---|---|---:|---|---|
|1|O01:2442|`04:[4D53,4D54)`|1/1|DEC HL; cai no driver|sem stack local; cauda/pointers/IO condicionados|
|2|O02:398|`68:[7312,7313)`|1/1|RET;PC=word[S],SP+2|AFBCDEHL/seletores locais intactos|
|3|O03:103|`68:[7740,7741)`|1/1|RET;PC=word[S],SP+2|separado dos JR vizinhos|
|4|O04:188|`68:[48C6,48C8)`|2/2|XOR A/RET;A0,F80,SP+2|não herda ação do vizinho|
|5|O05:342|`2F:[6F44,6F4D)`|9/6|B7/C0B→RET;senão cauda|goal41/C40 difere de21; buffers/helper|
|6|O05:1034|`2F:[73A6,73AA)`|4/3|INC/DEC C;tailsPOPBC/RET|BC=word[S],PC=word[S+2],SP+4|
|7|O06:44|`2F:[582D,5832)`|5/3|POPAF/CP1/JR5854 ou5832|SP+2;CP substitui F; loop pode não retornar|
|8|O06:169|`2F:[590B,5914)`|9/6|Guard B7/C0B;cauda goal08/C08|mesmo core de5; consumidor diferente|
|9|O06:605|`2F:[5C30,5C34)`|4/3|INC/DEC C;tailsPOPBC/RET|SP+4;BC externo, não argumento preservado|
|10|O06:732|`2F:[5CC5,5CD2)`|13/7|WRAM1;CP0 substituiCP0D|caudas consomem2words;PC=word[S+4],SP+6|
|11|O06:1134|`2F:[5F28,5F30)`|8/5|RAMG/FFF5=0;POPBC/RET|A0/F80;frame externoBC;SP+4|
|12|O06:1256|`2F:[6007,600F)`|8/5|RAMG/FFF5=0;POPBC/RET|idêntico11;stack legível sem SRAM|
|13|O06:1382|`2F:[60B8,60C0)`|8/5|RAMG/FFF5=0;POPBC/RET|idêntico11;sem restaurar enable anterior|
|14|O07:340|`24:[42AF,42B0)`|1/1|RET;SP+2|não executa cópias de42B0|
|15|O08:971|`70:[4740,477F)`|63/32|SRAM1:A9ED.bit7→B/A0/1|2AF salvos/restaurados;Fentrada;FFF2 amostra|
|16|O09:26|`7F:[620C,6218)`|12/7|C26B<1E→A0;senãoAFF|F80 ouCP1E;SP+2;sem unidade temporal|
|17|O10:176|`74:[5B3E,5B3F)`|1/1|POPBC,POPDE,scan com folding|SP+6−2k;word noRET pode ter sido reescrita|
|18|O11:367|`74:[43C3,43C4)`|1/1|POPHL;cauda escreve header/scroll|SP+4;mapper porH e progressos condicionados|
|19|O12:296|`55:[5DF5,5E02)`|13/5|LookupC2AB;OR;JP5E5A/5F29|sem RET;índice não limitado;tails próprias|
|20|O12:908|`55:[6184,6190)`|12/6|Dois storesFF emC2BD/C2BE|6B cada;RETs separados;F intacto,SP+2|
|21|O13:354|`2D:[681E,6827)`|9/6|Guard B7/C0B;cauda goal40/C40|core igual5/8;não copiar goal41 de5|
|22|O13:1072|`2D:[6CCD,6CD1)`|4/3|INC/DEC C;tailsPOPBC/RET|SP+4;carry original,DEC regeZNH|
|23|O13:1517|`2D:[6F7A,6F7B)`|1/1|RET;SP+2|JP anterior contorna;entrada não inferida|
|24|O14:575|`2D:[4B2D,4CA5)`|376/141|Setup+13far+8drawrows|POPextra;PC=word[S+2],SP+4;helpers/IRQ|
|25|O14:955|`2D:[4E04,4E06)`|2/2|POPBC/RET|PC=word[S+2],SP+4;AFDEHL intactos|
|26|O14:1094|`2D:[4EAE,4EB2)`|4/3|INC/DEC C;tailsPOPBC/RET|C original controla;retorno substituiBC|
|27|O14:2180|`2D:[54D2,54DA)`|8/5|RAMG/FFF5=0;POPBC/RET|A0/F80,SP+4;JR só prova bypass|
|28|O14:2292|`2D:[55A1,55A9)`|8/5|Mesmo epílogo8B de27|SP+4;qualificar “nenhum caminho”|
|29|O14:2413|`2D:[5642,564A)`|8/5|Mesmo epílogo8B de27|SP+4;qualificar “nenhum caminho”|
|30|O14:2573|`2D:[574E,574F)`|1/1|RET;SP+2|separado doJP precedente|
|31|O14:2614|`2D:[5799,579A)`|1/1|RET;SP+2|não entra na cauda seguinte|
|32|O14:2802|`2D:[58D6,58D9)`|3/1|JP5691|sem mudança local de regs/F/SP;estado do loop|
|33|O14:2927|`2D:[59AD,59B1)`|4/2|JP56C6;RET59B0 alternativo|JP não cai noRET;destino pode não retornar|
|34|O14:3048|`2D:[5A60,5A6F)`|15/7|PUSHBC/farHide;SCY=C0D3=0|POPBC/RET balanceado secallees retornam|
|35|O14:3068|`2D:[5A78,5A7B)`|3/2|RET5A78;JR5A79 autorreferente|entradas alternativas;loop sem deadline|
|36|O14:3098|`2D:[5A97,5A98)`|1/1|RET;SP+2|separado doRET precedente|
|37|O15:629|`2C:[4463,4467)`|4/3|INC/DEC C;mesmo core26|tails SP+4;dead não provado universalmente|
|38|O15:732|`2C:[44DB,44DC)`|1/1|RETNZ;Z1 cai44DC|Z0 SP+2;predecessorRET44DA,nãoJP/JR|
|39|O15:810|`2C:[456D,457A)`|13/7|WRAM1;CP0 substituiCP0D|NUL→459C;senão457A;sem stack no core|
|40|O15:1177|`2C:[4760,4768)`|8/5|RAMG/FFF5=0;POPBC/RET|mesmos8B;PC=word[S+2],SP+4|
|41|O15:1309|`2C:[483F,4847)`|8/5|Mesmo epílogo8B|entryHYP;busca histórica não écaller|
|42|O15:1437|`2C:[48F0,48F8)`|8/5|Mesmo epílogo8B|entryHYP;stack legível apósRAMG0|
|43|O16:640|`2B:[5806,5807)`|1/1|RET5806;SP+2|separado doRET5805|
|44|O17:96|`23:[4AA4,4AA6)`|2/1|JR4B1A (1874)|JP anterior contorna;entrada/frame abertos|
|45|O17:276|`23:[4BE5,4BE7)`|2/1|JR4C5D (1876)|template44,displacement diferente|
|46|O17:956|`23:[5028,503F)`|23/18|WRAM1;incwordD629;fall503F|HL/SP/F preservados;BC D62A;tail decrementa|
|47|O17:1515|`23:[540D,5424)`|23/18|Twin23B de46;fall5424|tail36B igual;sem copiar caller/purpose|
|48|O18:744|`22:[47DD,47DE)`|1/1|RET47DD;SP+2|bypass sequencialJP47DA;sem função nova|
|49|O18:1286|`22:[4BB5,4BB7)`|2/1|JR4C2B (1874)|JP anterior contorna;não prova inacessível|
|50|O18:1475|`22:[4D00,4D02)`|2/1|JR4D76 (1874)|mesmos2B49,destino distinto|
|51|O18:1656|`22:[4E41,4E43)`|2/1|JR4EB9 (1876)|displacement diferente;tail/frame separados|
|52|O19:210|`23:[6F22,6F3C)`|26/15|PUSH4;WRAM7/1;renderizador tempo|POPs compartilhados;SP+2 normal;IRQ/bancos|
|53|O19:256|`23:[6F60,6F6F)`|15/7|Minute+3C;CP64;tail render|sem saves;consome8B;PC=word[S+8],SP+10|
|54|O20:1211|`2E:[488A,488E)`|4/4|PUSH4→cauda tidy|normalSP+2;alternativa POP7→SP+8,PCword[S+6]|
|55|O21:299|`7C:[7D8B,7D8D)`|2/1|LD A0→7D8D|F/BCDEHL/SP intactos;JP7D88 contorna|
|56|O21:354|`7C:[7DFC,7DFF)`|3/1|JP7D57|sem efeito local de stack;loop não garanteRET|
|57|O22:330|`2A:[56CB,56EC)`|33/11|CALL6257+8CALL577F;JP54FD|CALL62C5 posterior éalternativo;callees|
|58|O22:434|`2A:[5781,578A)`|9/6|Guard B7/C9→RET;senão578A|A9/FC0 noRET;core difereC9 dosguardsC0B|
|59|O22:1161|`2A:[5C7D,5C81)`|4/3|INC/DEC C;tailsPOPBC/RET|mesmos4B;BC externo,PCword[S+2],SP+4|
|60|O22:1329|`2A:[5D7E,5D8B)`|13/7|WRAM1;CP0 substituiCP0D|NUL→5DAD;tails precisam2words externas|
|61|O22:1680|`2A:[5F69,5F71)`|8/5|RAMG/FFF5=0;POPBC/RET|mesmos8B;SP+4;semrestaurar enable|
|62|O22:1797|`2A:[6048,6050)`|8/5|Mesmo epílogo8B|SP+4;stack fora deSRAM desabilitada|
|63|O22:1915|`2A:[60F9,6101)`|8/5|Mesmo epílogo8B|bancoSRAM vigente permanece|
|64|O22:2079|`2A:[6222,6223)`|1/1|RET;SP+2|JP anterior contorna;sem entry nova|
|65|O22:2108|`2A:[6253,6257)`|4/2|JP617B;RET6256 alternativo|sem aresta sequencialJP→RET|
|66|O23:106|`67:[580C,5821)`|21/11|SFX002E solicitado;C27C=0|A0/F80;SVBK←shadow amostrado;IRQ/gate|
|67|O24:358|`22:[50CF,50FC)`|45/29|Duas wrapperschecksum/clear|primeiraAFBCDEHL;segundaAFF/A1;SRAM1 off|
|68|O25:536|`7E:[7DDF,7DE5)`|6/3|A2;FFB1=2;JR7D75|estado persiste;semRET local|
|69|O26:2780|`7F:[61E8,61FC)`|20/9|WRAM7;zeraC2D4..C2D7|A0/F80;SP+2;WRAM7 não restaurada|
|70|O27:1264|`0F:[47A5,47BB)`|22/10|Banco←D003;scan4A7E;tails47BB/CF|DE/union/mapping/progresso condicionados|
|71|O27:2202|`0F:[4C59,4C62)`|9/5|SaveBC;NextSramPage;restore/RET|D!=BF:INCD regeZNH,CdoCP;fronteiraBF troca banco|
|72|O27:2369|`0F:[4D35,4D37)`|2/1|B82→POPHL/A1/JP4260|AF externo;PCword[S+4],SP+6;Afinal≠1 geral|

### Irmãos e deltas com proveniência raw

Igualdade abaixo é dos campos raw dos três lotes pinados, não de finalidade/caller nem de toda a função envolvente. Operandos relativos iguais podem alcançar destinos diferentes por posição. RET(C9) idêntico não identifica funções. Os hashes permitem conferir a igualdade sem nova varredura da ROM.

|IDs|Raw core exato|SHA-256|
|---|---|---|
|2,3,14,23,30,31,36,43,48,64|`C9`|`4fb733bedb74fec8d65bedf056b935189a289e928b3302bec38a281814de523a`|
|5,8,21|`78FE07200479FE0BC8`|`a234a5cf15e67e65be29ff65b93acba89c8d4f16413566d8de9ba25d6cd4e53a`|
|6,9,22,26,37,59|`0C0D2002`|`56b9155725f250169cac2ba91d26a7e2b377a87b57a91565a38117894af069ce`|
|10,39,60|`3E01E08DE0707EFE0DFE002822`|`b07837699484031ee1b6384cad8faba517602119e70c4eb5562cb8bfd230db70`|
|11,12,13,27,28,29,40,41,42,61,62,63|`AFE0F5EA0000C1C9`|`62ee475f08a0addd61fd770dd25419cc58a6de13984bd41d4f8645b87919d8d2`|
|44,49,50|`1874`|`58321b5cb4f79ed0eba0b0be440fc1f52058f2722b5e14f632a2f928ab937e81`|
|45,51|`1876`|`1ebe1e4a0e2fee315b372d45e73e9729558deb204aa3a9eff6c201e69cabb81e`|
|46,47|`E53E01E08DE0700129D60A5F030A570B137B02037A02E1`|`70442e25404fc212c9bae1aed732c58febe207ad63513cb3e146889cdd4090bd`|

Os guards5/8/21 são idênticos, mas suas caudas diferem:5 deixa goal41/C40,21 goal40/C40 e8 goal08/C08.58 troca CP0B porCP09, sem herdar o consumidor dos outros. Os cores10/39/60 têm dois CP consecutivos: CP00 substitui as flags deCP0D, portanto somente NUL controla o branch seguinte. O item20 difere apenas no operandoC2BD/C2BE entre seus dois stores6B; o primeiro RET impede fallthrough.46/47 têm prefixes23B iguais e tails seguintes36B iguais, mas a continuação posterior é própria de cada fluxo.

As caudas POPBC/RET consomem um word externo: PC=word[S+2],SP=S+4. Os12 epílogos de8B também desabilitam FFF5/RAMG e deixamA0/F80; SRAM bank não é restaurado por isso, e a stack deve permanecer legível sem SRAM. INC C/DEC C restaura o C testado e deixaZ iffC0,N1,H iffbaixo nibble originalF,carry original; o POP posterior substituiBC pelo word do frame. A identidade de core não remove essas precondições.

Os casos de stack irregular permanecem explícitos.17 deixa baselineS+4 após POPBC/POPDE; cada wrapINC B5B14→5B3F pulaPOPBC e muda a recorrência em−2 bytes. Se vier umRET após k wraps, PC=word[S+4−2k] lida naquele instante eSP=S+6−2k; PUSHs podem ter reescrito esses slots, e oDE resultante altera o controle.10 pode consumir dois words externos antes dos RETs5CF3/5DDB.18 acrescentaPOPHL e um BankSwitch_H condicionado ao endereço do header: seguir os bytes físicos74 não prova continuidade após qualquer mudança deROMX.24 tem POPBC4C10 que consome o save inicial e POPBC4CA3 que consome word[S]; RET4CA4 usa word[S+2].53 entra sem os quatro saves esperados pelo epílogo compartilhado.54 normalmente restaura quatro saves, mas a alternativa48EE..48F7 consome mais três words externos e terminaSP=S+8.72 consomeHL eAF externos antes deRET; A final é o banco salvo, não necessariamente1. Nenhum desses fatos define por si um caller, bug, reparo ou intenção de unwind.

No66, a macroSFX amostra o shadowWRAM de entrada, salva esse byte emAF, seleciona SVBK1 e depois recupera o byte peloPOP AF para escrever SVBK; não restaura um shadow corrente queIRQ possa ter alterado, nem garante som audível. No71, D!=BF passa porINC D: Z iffDoriginalFF,N0,H iffbaixo nibble originalF,carry doCPBF; no wrapBF oINC do byte de banco regeZNH. Essas precisões substituem versões anteriores dos lotes, preservadas como história.

### Storage e alcance deste fechamento

Os32 headers UNCLASSIFIED/storage pertencem a um escopo separado desses72 comentários. A auditoria finita dos32 emissores db conferiu122 bytes originais. O header54:4CAD foi corrigido para texto CONFIRMED:81 63 00 é elipse Shift-JIS maisNUL, consumida por Text_TruncateSjis/CopyString ou CopyBytes. O header24:4BCC agora descreve1B em vez de10. Os outros31 intervalos continuam storage UNCLASSIFIED; não foi demonstrada uma função viva com mecanismo local ausente nesses bytes. Decode legal e contrato hipotético não bastam para converterdb a código; ver classify_g6.md, seção7. As listas145/72/32 se sobrepõem e não se somam como funções. Outros intervalos sem comentário/callers computados/limites de entrada não foram cobertos universalmente.

As correções de comentários qualificam bypass sequencial, contagens e frames; não inventam novos caminhos. Os nomes e níveis existentes não são prova suficiente sozinhos. Não foram feitos novos negativos de cenários, wordscans/callers, gates/build, replay/emulação, Git, OMM, tradução ou auditoria de assets/frames/PNGs. Nenhuma equivalência de reconstrução nova decorre deste fechamento estático.

### Identidades dos lotes usados

|Lote fechado|REPORT SHA-256|contracts SHA-256|Hashset SHA-256|
|---|---|---|---|
|01–24 V2|`f2de4e2d5cc8940b13aae89e6210d61c88ed3878a8f29aeb22ec02c72a13b08b`|`0676abad1fd94994fed56cc428fa9fc3687529bb65a71a502187a89f9c98c43e`|`4c3f6ca2e547355116e1e38fa72299dab4487d368c3b129aa4ffa691faaff4b4`|
|25–48|`a1fc7b9db1d89b42b9e5733ca39883acfc522c668f36a4fe32a8bf8dc36b74e5`|`c671cd8f184a1ec977515778e67ea10faa8bb21d03918bc562df7dc40e159772`|`4f09aa737047bb5882df1d91afdcfebbeab648da3e9e44b27cdf73ed2848040c`|
|49–72 V3|`05f54a6114bd558fceb07e37613ee9bd95c53ff78da83be49e7fad388014fb0f`|`670cf6a3b11253cab869daa6f6fa7b4fff912a444fa347509ea3950fc1eb19a9`|`a043c98fc70808bab1d8062f49e788ec20a1cd47c125741ace90568caeb39a74`|


### 2026-10-15: positive classification of the 26:5344 fragment

This dated correction updates the earlier storage snapshot above: **31 intervals / 119 bytes** became
**30 intervals / 63 bytes** of remaining UNCLASSIFIED storage after classifying only `26:5344-537C`
(56 bytes) as **PROBABLE code fragment**. The other 30 spans and their confidence levels are unchanged.
No new independent function entry, callable function name or execution result was established.
At this 2026-10-15 snapshot, `Data_26_5344` kept its historical global address label. The
inactive `Function_26_5343` alias had no
active assembly reference and was removed; `Stub_Nop_26_5343` remains the known single-RET no-op.
The call at `26:58E0` targets that RET at `5343`, so it returns before this fragment.

The positive classification evidence is a concrete buffer relationship, in addition to the internally
consistent 37-instruction body. Under ordinary CGB mappings, the fragment selects WRAM bank 7 at `26:535D-5363`; the
loop at `26:5363-536E` addresses `$D160-$D19F`, writing `$00..$3F`. This is `wScreenTileMap+$160`: two complete
32-byte rows, 11 and 12. The live `MailSession_InitScreen` sequence at `26:52D8-52E6` selects VRAM
bank 0 and fills `$9960-$999F` with the same 64-byte sequence. The screen-map buffer starts at
WRAM7 `$D000`, corresponding to VRAM `$9800`; both ranges therefore have offset `$160`.
This matching address/data relationship supports **PROBABLE code content**, not an independent entry
or author intent. A disabled helper, test routine or other original role remains **HYPOTHESIS**.

The fragment's static, conditional contracts are:

- Entry `5344` pushes AF/BC/DE/HL, samples the value read from `rSVBK` into E and sets D to `$32`
  (50 iterations). `.repeatFills` is at `534D`, `.fillTileFF` at `5357` and `.fillScreenRows` at `5369`.
- Each iteration issues 16 `$FF` stores to VRAM bank 1 `$9010-$901F`, then selects WRAM bank 7 and
  issues 64 ascending stores `$00..$3F` to `$D160-$D19F`. The loop count is 50 iterations, not frames:
  there is no VBlank wait, DI or LCD disable. Totals are 800 VRAM store attempts and 3,200 WRAM stores
  if entered and completed with stable mapping and no interfering execution. VRAM acceptance is
  conditional on writable VRAM; this static analysis is not evidence of hardware-accepted fills.
- The outer save of DE is paired on every pass. A valid, non-overlapping stack requires at most
  10 additional bytes: eight for AF/BC/DE/HL and two for the per-iteration DE save. These four register
  pairs are restored before RET only if that stack remains physically bank-invariant as SVBK
  changes (for example, WRAM0/HRAM). Non-overlap alone is insufficient: saves at WRAM1
  D7F6..D7FF would be read back from WRAM7 after selection7, corrupting the frame.
- The sampled `rSVBK` read is written to both `hWRAMBank` and `rSVBK` at exit. The original shadow
  is preserved only if it agreed with that sampled read; this is not an independent shadow save.
  `rVBK` remains 1 and `hVRAMBank` is not updated, so an earlier different VRAM shadow stays stale. These effects assume ordinary IO, stable ROM bank 26 and no IRQ or other execution
  that changes the relevant mapping/stack during the fragment.
- The three relative branches are `535B -> 5357` (`FA`), `536C -> 5369` (`FB`) and
  `5370 -> 534D` (`DB`). They stay inside the 56-byte fragment, ending in RET at `537B`.

The original 56 bytes are:

```text
F5C5D5E5F0705F1632D53E01E04F21109006103EFF220520FA3E07E08DE0702160D10640AF223C0520FBD11520DB7BE08DE070E1D1C1F1C9
```

Input identity: accepted private source snapshot corresponding to root revision
`245961f64363a27e57c99b3fbad906bf8d400ca2`; original ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The bounded readset is pinned by
`READSET.json` SHA-256 `4130c3f5da57d8e2a026b397d4f8cd3903ae2028b39828a8702b6799a933602e` and
`MEASUREMENTS.json` SHA-256 `b917ed674218be088b39b46769050c265101986b81dc56781f4f146ac770c520` from the `mt-jp-raw31-remaining-20261015/DATA`
analysis. The new proposal's DATA readset also records the two edited-file baselines and the hardware,
HRAM and banked-RAM definitions used to resolve operands. Exact bytes, labels and source changes are
available in that proposal's DATA reports. No build, gates, emulator, hardware, Git mutation, OMM
write or English work was performed by this private proposal; reconstruction comparison remains a
separate required integration check.


### 2026-10-17: scope of the30-interval storage counter

The30 intervals/63 bytes quoted above do not enumerate the six maintained source roots. A current literal-header census finds32 HYPOTHESIS intervals/92 bytes; the additional owners are28 bytes at28:4BA6-4BC2 in `gfx/mail/body_view.asm` and one byte at75:6D62-6D63 in `lib/mobile/main.asm`. The separate already-CONFIRMED ellipsis bytes at54:511B-511D had a stale UNCLASSIFIED header, now corrected as text. See [the full scope correction](classify_g6.md#8-six-root-unclassified-header-scope-correction-2026-10-17). The earlier positive classification of26:5344-537C and its conditional contract remain unchanged. These counts describe annotation coverage and do not close function discovery or all unknown ROM data.

### 2026-10-20: descriptive label for the 26:5344 code fragment

The maintained source label is now `MailSession_WriteVram1TileAndWram7ScreenRows`. This mechanical
name describes the two observed store sequences: the fragment attempts `$FF` writes to VRAM1
`$9010-$901F`, then writes `$00-$3F` to the two screen-map rows at WRAM7 `$D160-$D19F`. “Write”
does not claim the PPU accepted the VRAM writes. The source name replaces the generic `Data_26_5344`;
the instruction bytes, addresses, local-label addresses and emitted bytes are unchanged.

An independent read-only review accepted this name as a content description and rejected broader
purpose words such as “Init”, “ClearScreen” or “Upload”. It independently confirmed the 56-byte
extent, the WRAM7 map offset, and that the local labels remain at `534D`, `5357` and `5369`.
No entry, caller, intended role, natural execution or hardware-accepted VRAM operation is established:
the code-fragment classification remains **PROBABLE**, while entry and intended role remain
**HYPOTHESIS**. The 69 existing natural trace scenarios and bounded source/ROM reference scans contain
no entry into `[26:5344,26:537C)`; this finite absence does not prove unreachability. Frozen
`config/regions/` and `analysis/mapper/` rows retain their historical `Data_26_5344` spelling.
