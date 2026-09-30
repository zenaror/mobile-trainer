# Naming pass 2, group g1_home: adversarial verification

Scope: the 111 applied rows of `analysis/naming2/g1_home_renames.tsv` (bank 00, `home/**`; the 10 HYPOTHESIS rows are not applied and were not checked).
Fixes: [`analysis/naming2/verify_g1_home_fixes.tsv`](../../analysis/naming2/verify_g1_home_fixes.tsv) (applies cleanly with `tools/apply_renames.py --strict`; the build stays SHA-256 identical, `sym_check` OK).
Verifier stance: try to refute every name; a name survives only if the code at the label, the callers/callees and the dynamic evidence agree independently.

## Method

* Code: every routine of `home/*.asm` was re-read at the label (not the evidence column) and the evidence column was checked against it.
* Callers: `grep -rnw NewName` over the tree (excluding definitions and comments); caller contexts were read for the families (`Gfx_Upload*`, `Tilemap_ApplyMaskRect`, `Sprite_SetHook`, `StringAppend`, `Html_*`, `HtmlStore_*`, `Sound_*`).
* Dynamic: `analysis/coverage_union.tsv` (count and scenario column) for the entry address of every row (a script flagged every CONFIRMED row whose entry has no coverage); `traces/detail/*/callgraph.tsv` for the `ret_unmatched 00:0B53 -> 00:0A1A` hook call; `ram/*.asm` for every RAM name quoted.
* Data: ROM bytes (`Mobile Trainer (Japan).gbc`) for `Palette_AllWhite` (64 bytes of `FF 7F`), `Table_Random_XorBytes` (166 distinct values) and the bank 3F record store (`file://di/`, `contents.htm`, NUL, length word, `<HTML>`).
* Mechanical: a script compared `build/mobile_trainer.sym` for every applied row: old alias and new name are at the same address and that address is the one in the neutral name (0 mismatches over 111 rows). Private build of the unmodified tree: `RESULT: IDENTICAL`.
* Status rule applied: CONFIRMED needs demonstrated evidence (executed and the role visible); code that never ran in the 64 scenarios is capped at PROBABLE.

## Result

| verdict | rows |
|---|---|
| upheld (name and status) | 97 (68 CONFIRMED, 29 PROBABLE; some with evidence-text errors, listed below) |
| renamed (prefix) | 2 (`SoundDrv_ReadStreamByte`, `SoundDrv_ReadStreamWord`) |
| status lowered CONFIRMED -> PROBABLE (name kept) | 12 (11 text-engine control handlers, `Table_Random_XorBytes`) |
| name refuted outright | 0 |

97 + 2 + 12 = 111 applied rows (82 CONFIRMED: 68 upheld + 2 renamed + 12 lowered; 29 PROBABLE: all upheld, none raised). Rows with an evidence-text error that does not change name or status are listed in the next-but-one section.

## Changes to apply

### Renamed (in `verify_g1_home_fixes.tsv`)

| old | new | reason |
|---|---|---|
| `SoundDrv_ReadStreamByte` (00:215E) | `Bank4_ReadStreamByte` | The manifest's own convention is `Sound_*` = ROM0 entry, `SoundDrv_*` = body in bank 04. These two live in ROM0, end with `jp Bank4_Restore` (they re-select bank 4, so they can only be called from bank 04) and sit in the `Bank4_*` helper family (`Bank4_SetHi/SetLo`, which they call). Behaviour and status unchanged. |
| `SoundDrv_ReadStreamWord` (00:216F) | `Bank4_ReadStreamWord` | same |

### Status corrections (source does not carry per-name status; manifest rows left untouched)

| name | manifest | corrected | reason |
|---|---|---|---|
| `TextEngine_Cmd01_CallString` (0F83) | CONFIRMED | PROBABLE | never executed in 64 scenarios; behaviour read from code only (push of pointer+bank, depth++; consistent with `Cmd00_End` popping them, which is executed, but the push side never ran) |
| `TextEngine_Cmd02_SetY`, `Cmd03_SetX` | CONFIRMED | PROBABLE | never executed |
| `TextEngine_Cmd04_SetPos`, `Cmd05_SetPos`, `Cmd06_SetPos`, `Cmd07_SetPos` | CONFIRMED | PROBABLE | never executed; the constants (Y,X) = (3,0) (1,0) (2,0) (0,2) and their unit are unexplained (the narrative already says so) |
| `TextEngine_Cmd1C_SetX16`, `Cmd1D_SetY`, `Cmd1E_AddX16`, `Cmd1F_AddY` | CONFIRMED | PROBABLE | never executed |
| `Table_Random_XorBytes` | CONFIRMED | PROBABLE | `Random` (00:0C18) and `Random16` never execute in any scenario, so the table was never read. The evidence "Random has 26 callers" is false: `Random` is called only from `Random16` (2 sites); `Random16` has 3 call sites, all in `engine/comm/comm_scene.asm` (bank 70, `Random16` then `Divide16` by 3 or 6, remainder added to a constant), none executed. The role (xor operand of a `5*s+2` generator, used modulo 3/6) is well supported by code, hence PROBABLE and the name stays. |

Rows kept at CONFIRMED although the evidence is thin on execution: `TextEngine_Cmd09_Tab` (executed once in one scenario, plus `Text_MeasureFit` counts `$09` as `$30`, two independent pieces), `TextEngine_Cmd00_End`/`Cmd0D_NewLine` (executed 17k/12k times).

## Evidence-text errors found (name and status unaffected; do not repeat them elsewhere)

| row | claim in the manifest/narrative | what the tree shows |
|---|---|---|
| `Sound_FrameTick` | "the only caller is Sound_FrameService" | also 11 direct `call Sound_FrameTick` in `engine/mail/send_receive.asm` and 1 in `engine/debug/sound_test.asm` (the mail send/receive loops tick the driver themselves) |
| `Bank4_GateEnter` (and narrative) | "guard used by 12 of the 13 sound stubs" | 11 of 13: `Sound_Init` uses `Bank4_SaveAndSelect`, `Sound_FrameTick` uses `Bank4_GateEnterTick` |
| `Gfx_UploadBgMapBuffersDi`, `Gfx_UploadBgMapBuffers`, `...NoService`, `Gfx_UploadWinMapBuffers` (+ the uncalled `...WinMapBuffersDi`) | "1 KiB each" | each HDMA is `C=$24` blocks = 576 bytes (18 rows x 32), not 1 KiB; the buffers are 1 KiB (D000-D3FF / D400-D7FF), only the visible rows are uploaded |
| `Sprite_LoadObjectEntry` | "sets frame index $FF and copies the first script word" | `$FF` is written to slot+`$0A` (the AND attribute mask in `Sprite_StepAndDrawSlot`'s layout; slot+`$09` OR mask = 0, slot+`$08` script index = 0). Slot+4/+5 (frame index, delay) receive bytes 1-2 of the script. `A` (object index with flags) is stored in slot+`$0F`. |
| `Mail_DispatchFar` | "A=selector 4/5/6/8" | the selector values loaded at the 12 farcall sites are 1, 2, 4, 6, 8 (the `$05` loads seen nearby are unrelated registers) |
| `Tilemap_CopyRectAndAttr` | 176 callers | 164 references by name |
| `Tilemap_CopyRectAndAttrPtr` | 26 callers "(MailMenu plates/icon frames etc.)" | 25; 14 of them are in `engine/help/help_menu.asm`, only 4 in `mail_menu.asm` |
| `Tilemap_ApplyMaskRect` | 9 callers | 8 |
| `Glyph_CopyAsciiRowsDoubled` | "13 scenarios" | the coverage union gives 48 scenarios (source of the 13 not found) |
| `StringAppend` | "A=0 is strcat" | true, but `register_config.asm` and `usage_time.asm` call it with `A=$03` (insert at the first `$03` marker); "Append" names the A=0 case only. Kept: the evidence column states the A contract. |
| narrative `naming2_g1_home.md` | "`SoundDrv_*` = body in bank 04" | contradicted by the two ROM0 stream readers (fixed by the rename above) |

Advice (not applied, outside this manifest): the existing name `Bank4_Restore` (00:20F8, PROBABLE) re-selects bank 4 (`hi=0, lo=4`); next to the new `Bank4_RestoreCallerBank` (restores the caller's bank) it reads as the opposite of what it does. A later pass could call it `Bank4_Reselect`/`Bank4_Select`; it is called by `Bank4_SaveAndSelect` (fall-through) and by the two stream readers.

## What was checked

Verdicts: U = upheld, R = renamed, L = status lowered (name kept).

| name | verdict | reason |
|---|---|---|
| `Mail_DispatchFar` | U | stores A in `wMail_Selector`, selects bank 0F, calls `Mail_Dispatch` (0F:4247 indexes `Mail_SelectorTable` with that byte), restores bank, returns the library's A; 12 farcall sites in smtp/pop3; 940 executions, 18 scenarios. Selector list in the evidence is wrong (see above). |
| `Palette_SetAllWhite`, `Palette_AllWhite` | U | ROM bytes are 32 x `FF 7F`; two `rBCPS/rOCPS=$80` auto-increment writes of 64 bytes; both callers are the boot stages in `boot_stage2.asm`; 1326 executions |
| `Sound_FrameService` | U | once-per-frame guard (`wFrameServiceRan`, cleared in `Int_VBlank`), only body is `Sound_FrameTick` with rSVBK=1; 18.4M executions; 187 name references (14 in home, 173 elsewhere) |
| `VBlank_WaitAndService` / `VBlank_Wait` | U | `ei; halt` until `wVBlankFlag`, clear; the first calls `Sound_FrameService`; caller counts 134 / 401 match; 1.9M / 724k executions |
| `VBlank_WaitStartDI` | U | `ei; halt; di`, LY>=$90 test, late wake runs the service and loops; the 65 callers are followed by `Palette_UploadBuffer` (29), `ldh [rLCDC]` (24), `ei` (54), service calls: the claim holds |
| `Int_InstallRamVectors` | U | byte-wise stores of `jp $03BA / reti / jp $01ED / jp $01B7 / reti` into the RAM vectors; callers are `Boot_ClearAndInit` and `Boot_ReinitRuntime` only; 1326 executions |
| `OAMDMA_CopyToHram`, `Bank_InitState`, `Boot_ReinitRuntimeFar` | U | code and callers verified (`ld bc,$0A80`; trampoline `ld a,0 / ld hl,0 / jp $06B7`, bank mirrors, SRAM disable; single caller `Startup_Run`) |
| `Boot_MainLoop` (label) | U | `farcall Main_Run` then `jp` back; 663 executions, 1 per boot |
| `FarCall_Inline16` | U | inline 16-bit target, bank from `hFarBank`, joins `FarCall_Common`; single caller `Palette_LoadToBuffer` (`dw $050C` = `CopyBytes`); 25k executions |
| `Gfx_StartHDMA`, `Gfx_StartHDMAWithService` | U | registers, `LY>=$91`/`LY<B` wait, `rHDMA5=C-1`; the second calls the service; caller counts 65 outside home + 10 in home, 461 |
| `Gfx_UploadBgMapBuffers`, `...Di`, `...NoService` | U | differences exactly as named (no `di`; `di` before the wait; no frame service); `A=ldh [rLCDC]` precedes every one of the 123 / 16 / 6 callers; "1 KiB" wrong (576 bytes) |
| `Gfx_UploadWinMapBuffers` | U | bit6 test; callers in `send_receive.asm` set `A=$40` (8) or pass `rLCDC`; the same file writes `rWY/rWX`, so the window layer is really in use there |
| `Tilemap_CopyRectAndAttr`, `Tilemap_CopyRect` | U | second pass continues with the same `HL` into `DE+$400`; stride-32 loop; `bc=$1214` at full-screen callers; 25k / 12.8M executions |
| `Tilemap_CopyRectAndAttrPtr` | U | second source read from `wRam_C10E/C10F`; 10k executions |
| `Tilemap_ApplyMaskRect` | U | `(HL & D) | E`, callers with `HL=$D4xx`, `DE=$F800/$F801/$F008` (attribute buffer) or `DE=$0008/$0009` (D=0, plain fill); 7k executions |
| `Sprite_UpdateAll`, `Sprite_ResetAll`, `Sprite_ClearSlot`, `Sprite_ClearShadowOAM` | U | 14 slots x 16 bytes at `$DA00` (`wSpriteSlots`), `$FF` in slot+`$0F` = skipped/free (`Sprite_UpdateAll` and `Sprite_StepAndDrawSlot` both test it); counts 341/126/44; 2.6M/14k/37k/2.6M executions |
| `Sprite_SetHook` | U | all 15 callers pass `HL=$DA0B+16n` (`$DA2B`, `$DA8B`, `$DACB`) and the callee reads slot+`$0B..$0D` as address+bank |
| `Sprite_SetPosition` | U | `D`->byte 0, `E`->byte 1; `Sprite_StepAndDrawSlot` adds `$10`/`$08` to bytes 0/1 for OAM Y/X |
| `Sprite_InitSlot` | U | zeroes 16 bytes, stores the bank in slot+`$0E` (which `Sprite_UpdateAll` reads as the bank), loads the entry; 712 callers with object tables |
| `Glyph_CopyAsciiRowsDoubled`, `Glyph_UnpackWideHalvesDoubled` | U | 12 bytes doubled = 12 rows x 2 plane bytes; 18 source bytes = 12x12 1 bpp, unpacked into 6-px halves (bit shuffle re-derived by hand); only users are `Glyph_LoadAscii` / `Glyph_LoadWide` in bank 7F |
| `Stat_ScrollSplitHandler` | U | LY=0: `LYC=wStatSplitLine`, `SCY=0`; else `SCY=wSplitScrollY`, `LYC=0`, service if `wStatIrqServiceFlag`; installed by `Stat_EnableScrollSplit` (`wLcdStatVector` comment: `jp $0E93` from 7F:727F); 1.2M executions |
| `Ticker_StatHandler`, `Ticker_VBlankHandler` | U | installed by `Ticker_InstallRasterIrq` (`rSTAT=$08`, `rLYC=$80`, vectors `$16C4/$16D4`, saved originals in `wSavedLcdStatVector/wSavedVBlankVector`, restored by `Ticker_Stop`); `jp $C133` = `wSavedVBlankVector`; 43.7M / 305k executions |
| `ConnectDialog_StatHandler` | U | single installer `ConnectDialog_Enter_Keyboard` (57:4517: `rSTAT=$44`, `LYC=$1A`, `jp $16DC`); "lower window" is interpretation of the `rWY`/`rSCY` arithmetic, not needed for the name; 85k executions, 4 scenarios |
| `TextEngine_Run`, `TextEngine_PutChar`, `TextEngine_ReloadBank`, `TextEngine_NextByte`, `TextEngine_AfterChar`, `TextEngine_LineWrap` | U | control/character split at `$20`, table dispatch (`add a,a; add a,$F0; h=$0E`), lead-byte ranges `$81-$9F,$E0-$EF,$F8-$F9`, service + limit check at `AfterChar`; the 35 callers include the ones named; 17k-256k executions |
| `Table_TextEngine_CmdHandlers` | U | 32 words, every entry a label of `home/text.asm`; indexed at `0EE3-0EEF` |
| `TextEngine_Cmd00_End`, `Cmd0D_NewLine`, `Cmd09_Tab` | U | 19 table slots use `Cmd00_End` (0,8,10-12,14-27); `$0D` (not `$0A`) is the newline slot; `$09` adds `$30`, matching `Text_MeasureFit` |
| `TextEngine_Cmd01..07`, `Cmd1C..1F` (11 rows) | L | never executed, see above |
| `TextEngine_DrawWideGlyph`, `TextEngine_DrawNarrowGlyph` | U | `Glyph_LoadWide` / `Glyph_LoadAscii` into `C0B8/C0A0`, two / one `Canvas_BlitGlyph`, `hTextX += 12 / 6`, limits `y<$90`, `x<$A0`; 185k / 41k executions. The other pieces (`Function_00_1059` ...) correctly stay neutral. |
| `Html_MatchKeyword`, `Html_ScanAttributes` | U | all callers are in `engine/html/*` with `Html_*` tables (`Html_TagPtrs`, `Html_EntityPtrs`, `Html_AlignValuePtrs`, `Html_ResultCodePtrs`, `HtmlUrl_SchemeTable`; attribute tables `74:4033/4078/408A/4110` = `Html_MetaAttrPtrs/AnchorAttrPtrs/ImgAttrPtrs/NoKeywords`); case folding only on the text side (table strings must be lower case); value copy limited to 255 bytes |
| `HtmlStore_LoadPage` | U | executed 200 times by `MobileDictView_Show`, output buffer `wBrowserRxPtr`, length word written first; record format checked in the ROM |
| `Text_MeasureFit` | U | 6/12/`$30` px, stops at `$00/$0A/$0D` or limit, returns byte count in BC; 3 call sites in `page_render.asm`; 4.5k executions |
| `StringAppend` | U | see the `A=$03` remark |
| `PromptText_Load` | U | `PromptText_Table` of bank 65 (20 named strings), copy to `$D000` of WRAM 5; 14 callers in account/settings screens |
| `Sound_Init`, `Sound_PlaySfx`, `Sound_PlayMusic`, `Sound_PauseMusic`, `Sound_PlayMusicOrResume` | U | stub = guard + `jp SoundDrv_*`; caller counts 1/368/4/3/61 match; each executed |
| `Sound_FrameTick` | U | stub with `Bank4_GateEnterTick`; "only caller" is wrong (12 more callers) |
| `Bank4_SaveAndSelect`, `Bank4_SetHi`, `Bank4_RestoreCallerBank` | U | save/select, hi byte setter, restore of the saved pair; 3.5M / 15.7M / 3.5M executions |
| `Bank4_GateEnter`, `Bank4_GateEnterTick`, `Bank4_GateLeave`, `Bank4_GateSetBusy`, `Bank4_GateReturnBusy` | U | bit7 = busy, bit6 = deferred tick; the deferral path (`set 6`, store return address, `GateLeave` re-queues it) executed once in one scenario; `GateLeave` has 15 call sites in `audio/engine.asm` |
| `SoundDrv_ReadStreamByte/Word` | R | prefix, see above |
| `Table_Random_XorBytes` | L | see above |
| `Palette_WritePort64` | U (PROBABLE) | `ldh [c],a` x64, `C=$69/$6B`; status could be CONFIRMED but PROBABLE is safe |
| `FarCall_IdleLoop` | U (PROBABLE) | `call VBlank_WaitAndService; jr`, default trampoline target written by `Bank_InitState`, never executed |
| `FarJump_Inline16` | U (PROBABLE) | `FarCall_Inline16` pattern without the return; no caller |
| `Gfx_WaitForFrameTop` | U (PROBABLE) | returns as soon as `LY<$87`, otherwise waits out the tail of the frame (incl. VBlank) so the following HDMA (`LY>=$91`, limit `$95`) starts at the beginning of a VBlank; "FrameTop" means "early part of the frame", not line 0; imprecise but not wrong, kept |
| `Sprite_HookAddSlideOffset` | U (PROBABLE) | adds `hRam_FFF1`/`FFF0` to slot Y/X; hook installed for dialog and browser-menu cursors; `Dialog_SlideIn` subtracts and `Dialog_SlideOut` adds to `FFF1` while it moves `rWY` and calls `Sprite_UpdateAll`; the hook call is seen as `ret_unmatched 0B53 -> 0A1A` in the traces; `Sprite_UpdateAll` zeroes `FFF0/FFF1` after each pass, so every step is added to the slot once, in step with the window. Independent sources (dialog code, installers, trace), kept |
| `Sprite_LoadObjectEntry` | U (PROBABLE) | see the `$FF` correction |
| `Sprite_StepAndDrawSlot` | U (PROBABLE) | single caller; 36M executions; slot layout stays a HYPOTHESIS in the evidence, correctly |
| `HtmlStore_BuildPageUrl` | U (PROBABLE) | ROM bank 3F: word list (2 equal pointers), prefix `file://di/`, NUL, scheme byte, then 3-byte entries (addr,bank) whose targets are `contents.htm\0` + length word + `<HTML>`; single caller `MobileDictView_Show` |
| `Dial_CopySelectedNumber` | U (PROBABLE) | both branches executed (69 default `#9477`-style strings from `Dial_DefaultNumberTable[wMobileAdapterType]`, 10 SRAM-decoded) |
| `Table_Dial_SramEntryPtrs` | U (PROBABLE) | `$B014/$B025/$B036` (17 bytes apart), indexed by `sSettingsSelectedDialEntry xor $A5`, decoded by `DecodeXorA5` |
| `Tilemap_OffsetToPixelXY` | U (PROBABLE) | arithmetic re-derived (C = (L&31)*8, B = ((HL>>5)&31)*8); no caller |
| `Tilemap_CopyRectAndAttrSplitSrc`, `Tilemap_ClearBuffers`, `Gfx_UploadWinMapBuffersDi` | U (PROBABLE) | twin bodies re-read; no callers; "SplitSrc" is a clumsy but accurate name (attribute source = tile source + `$400`) |
| `Multiply8x8`, `Multiply16Preserve`, `Glyph_CopyAsciiRowsSingle`, `Glyph_UnpackWideHalves`, `Glyph_CopyToLeftBuf`, `TextEngine_DrawChar`, `ReadBytesFar`, `CopyBytesFarToFar` | U (PROBABLE) | names state what the code does; none has a caller (name search), none executed; `ReadBytesFar` restores only the ROM bank (not a region-generic companion of `ReadByteFar`) |
| `Sound_PlayMusicIfNotPlaying`, `Sound_StopSfxById`, `Sound_ResumeMusic`, `Sound_GetActiveMasks`, `Sound_SetTrackParam`, `Sound_StartFadeOut`, `Sound_GetPlayingId` | U (PROBABLE) | stub bodies identical to the named ones; the only evidence is the jump target name; `Sound_StopSfxById` has two sound-test callers (forced runs only) |

## Unverified by me

* The correctness of the target names (`SoundDrv_*`, `Canvas_BlitGlyph`, `Settings_GetHiddenModeFlag`, ...) that the stubs and wrappers mirror belongs to other passes; the `Sound_*` stub names are exactly as reliable as those.
* Units of the fixed text positions of control bytes `$04-$07`.
