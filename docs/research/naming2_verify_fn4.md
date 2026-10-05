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
   `MailSession_UpdateTimerDisplay`.  171,411 hits / 22 scenarios, equal to the callee.  The 56 bytes after it (`5344-537B`) are a separate, complete, unreferenced function.
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
    `SaveSenderAddr_DrawSlotNames` (`2A:422C`, 27 runs / 6 scenarios): same table values, E = `$28`, B = 3, C = 0; the live one adds `add a, $10` to Y.  The unlabeled routine right after (`2C:6100-614C`)
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
