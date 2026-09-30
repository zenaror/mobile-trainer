# Naming pass 2, group g1_home: bank 00 (`home/**`, ROM0)

Scope: every neutral label of bank 00 (`Function_00_*`, `Data_00_*`, `Table_00_*`, `Label_00_*`; 121 labels, none of them an alias of a semantic name).
Deliverable: [`analysis/naming2/g1_home_renames.tsv`](../../analysis/naming2/g1_home_renames.tsv) (`old_name new_name kind status evidence`; applied by `tools/apply_renames.py`, the build proves the ROM is unchanged).
This note only adds reasoning; the per-symbol evidence is in the TSV.

Result: **82 CONFIRMED, 29 PROBABLE, 10 HYPOTHESIS** (HYPOTHESIS rows keep `new_name == old_name`, they are ideas and are not applied).

## Method

* Code read from `home/*.asm` (source of truth), with the earlier ROM0 analysis (`boot_and_home.md`) as the record of what was executed or verified on the interpreter/mGBA.
* Callers: `grep` of every label over the whole tree (farcall sites, `call`, jump-table and `dw` users); the caller contexts were read for the big families (the 461 `Function_00_0787` tile loads, 527 `Function_00_0A65` position sets, the 65 `Function_00_047A` callers, the 13 `Function_00_0247` callers ...).
* RAM: only names that already exist in `ram/*.asm` are used as evidence (`wSpriteSlots`, `wFrameServiceRan`, `wBank4*`, `hTextX/Y`, `wGlyphBufLeft`, `wTickerScrollX`, `wStatSplitLine` ...).
* Dynamic evidence: `analysis/coverage_union.tsv` (64 scenarios) for the execution counts quoted in the TSV; `traces/detail/*/callgraph.tsv` for the sprite hook (`ret_unmatched 00:0B53 -> 00:0A1A`, i.e. the push-return call in `Sprite_StepAndDrawSlot`).
* Independent cross-checks that fixed a name: the sound-test screen (stubs `20A6/20AC/20B2/20BE/20C4`, from `naming_g1.md` section 7), `A=[rLCDC]` at every caller of the map-buffer uploads (bit3 = BG map area, bit6 = window map area), the ROM bytes of bank 3F (`name.htm`, NUL, length word, HTML) for the built-in page store, and the tab width ($30) and double-byte lead-byte ranges shared by the text engine and `Text_MeasureFit`.
* Naming rules: `Subsystem_Verb...` like the neighbours (`Bank4_*`, `Int_*`, `Stat_*`, `Palette_*`, `Dial_*`, `PromptText_*`, `Html_*`, `Glyph_*`, `Sprite_*`, `Tilemap_*`, `Gfx_*`, `Ticker_*`, `ConnectDialog_*`, `Mail_*`).  Every new name was checked against all labels, `DEF`s and the other manifests (`g2_libs`): no collisions.  A sed-style application of all 111 renames in a private copy of the tree followed by `make` gives `RESULT: IDENTICAL`.
* Pieces that are only a fall-through, a jump target inside a larger routine, a tiny uncalled store helper, or whose contract would require deciding on an original quirk stay neutral (list at the end).

## What the newly named routines do

### Frame service, waits, interrupts (vblank.asm, lcd.asm, interrupt_handlers.asm, stat_handler.asm)

| name | role |
|---|---|
| `Sound_FrameService` (0392) | at most one `SoundDrv_FrameTick` per frame (`wFrameServiceRan`, cleared by `Int_VBlank`); called from every wait loop, `LCDOff`, the HDMA waits, the text engine and the STAT handler when `wStatIrqServiceFlag` is set |
| `VBlank_WaitAndService` / `VBlank_Wait` / `VBlank_WaitStartDI` | halt until `wVBlankFlag`; first one also runs the service, the last one returns with IME=0 at the start of VBlank and is always followed by palette/LCDC writes and `ei` |
| `Int_InstallRamVectors` | writes the five RAM stubs `CBF1-CBFD`; `Boot_ClearAndInit` and `Boot_ReinitRuntime` call it |
| `Stat_ScrollSplitHandler` | target of `Stat_EnableScrollSplit` (7F): LYC split with `wStatSplitLine` / `wSplitScrollY` |
| `Ticker_StatHandler`, `Ticker_VBlankHandler` | installed by `Ticker_InstallRasterIrq` (bank 48): SCX = `wTickerScrollX` at LY=$80, SCX=0 and chain to `wSavedVBlankVector` |
| `ConnectDialog_StatHandler` | installed by `ConnectDialog_Enter_Keyboard` (57:4517): raster split with WY / LYC $8E/$1A |
| `OAMDMA_CopyToHram`, `Bank_InitState`, `Boot_MainLoop`, `Palette_SetAllWhite` (+ `Palette_WritePort64`, `Palette_AllWhite`) | boot helpers: HRAM DMA routine copy, HRAM bank/trampoline state, main loop label, all-white palettes |

### Bank 04 gateway (audio.asm)

The 13 stubs are `Sound_*` and mirror the targets already named by `naming_g1.md` (`SoundDrv_Init`, `SoundDrv_FrameTick`, `SoundDrv_PlaySfx` ...): `Sound_*` = ROM0 entry an application calls, `SoundDrv_*` = body in bank 04.  Independent evidence for the five used by the sound test screen is in `naming_g1.md` section 7; the six stubs without callers (`20B8 20CA 20D0 20D6 20DC 20E2`) are PROBABLE because the name only repeats the jump target.
The guard/bank helpers get `Bank4_*` names (same family as the existing `Bank4_Restore` / `Bank4_SetLo`): `Bank4_SaveAndSelect`, `Bank4_SetHi`, `Bank4_RestoreCallerBank` (pay attention: `Bank4_Restore` at 20F8 re-selects bank 4, it does not restore the caller bank), `Bank4_GateEnter` (guard of 12 stubs), `Bank4_GateEnterTick` (guard of the frame tick with the deferred-call slot), `Bank4_GateLeave` (end of every bank-04 entry; 15 call sites), plus the two shared tail labels.  `SoundDrv_ReadStreamByte/Word` (215E/216F) are the ROM-bank-aware stream readers of `SoundDrv_ReadNextCommand`, `SoundDrv_CmdJump`, `SoundDrv_CmdExtended`.

### Far call family (farcall.asm, bank_switch.asm, far_helpers.asm, far_read.asm, mobile.asm)

`FarCall_Inline16` (06BC, one caller in 4F), `FarJump_Inline16` (0716) and `FarCall_IdleLoop` (06B7, default trampoline target, never executed) complete the existing `FarCall/FarCall_Reg/FarJump` names; `Boot_ReinitRuntimeFar` is the bank-4F wrapper used by `Startup_Run`; `ReadBytesFar` and `CopyBytesFarToFar` are uncalled multi-byte companions of `ReadByteFar` (PROBABLE, contract read from the code only); `Mail_DispatchFar` (0247) is the wrapper that stores the selector in `wMail_Selector` and calls `Mail_Dispatch` (0F:4247), 12 farcall sites in the SMTP/POP3 code.

### Graphics upload and tilemap buffers (gfx_upload.asm, tilemap_copy.asm)

* `Gfx_StartHDMA` (0749) and `Gfx_StartHDMAWithService` (0787, the 461-caller tile loader that keeps the frame service running).
* The five near-identical routines 07CB/07FB/082C/085B/0887 upload the WRAM-7 map buffer D000 (VRAM bank 0) and attribute buffer D400 (VRAM bank 1) to `$9800` or `$9C00`; the variants differ only in the LCDC bit tested (`BgMap` = bit 3, `WinMap` = bit 6), `di` before the wait (`Di`) and whether the frame service runs afterwards (`NoService`).  `Gfx_UploadBgMapBuffers` (082C, 123 callers) is the base one.
* `Tilemap_CopyRectAndAttr` (08EA, the loader of all full screens), `..SplitSrc` (08CA, source attribute rows `$400` later, uncalled), `..Ptr` (16A2, second source from `wRam_C10E/C10F`), `Tilemap_CopyRect` (0904), `Tilemap_ApplyMaskRect` (091C, AND/OR on the attribute buffer), `Tilemap_ClearBuffers`, `Gfx_WaitForFrameTop`, `Tilemap_OffsetToPixelXY`.

### Sprite engine (sprites.asm)

`Sprite_UpdateAll` (per-frame, 341 callers), `Sprite_ResetAll`, `Sprite_ClearSlot`, `Sprite_ClearShadowOAM`, `Sprite_InitSlot` (712 callers, object tables such as `Objects_Title`), `Sprite_LoadObjectEntry`, `Sprite_SetPosition` (DE = Y,X), `Sprite_SetHook` (slot+`$0B..$0D` = callback address and bank, called with the push-return trick), `Sprite_StepAndDrawSlot`, and the hook `Sprite_HookAddSlideOffset` (adds `hRam_FFF1`/`hRam_FFF0` to slot Y/X; installed for the dialog and browser-menu cursors, `hRam_FFF1` is stepped by `Dialog_SlideIn`).  Slot field layout beyond Y/X/hook is still a HYPOTHESIS (see `Sprite_StepAndDrawSlot` evidence).

### Text engine (text.asm, text_measure.asm, glyph_data.asm)

`TextEngine_Run` (0ED3; 35 callers print prompts, notices, error messages and page text) interprets a byte stream: control bytes `<$20` go through `Table_TextEngine_CmdHandlers` (32 words), everything else is drawn by `TextEngine_PutChar` (double-byte lead bytes `$81-$9F,$E0-$EF,$F8-$F9`).  Handlers are named by control byte (`TextEngine_Cmd00_End` for the 19 end slots, `Cmd01_CallString`, `Cmd02_SetY`, `Cmd03_SetX`, `Cmd04..07_SetPos`, `Cmd09_Tab` (+$30, same tab width as `Text_MeasureFit`), `Cmd0D_NewLine`, `Cmd1C_SetX16`, `Cmd1D_SetY`, `Cmd1E_AddX16`, `Cmd1F_AddY`); the labels `TextEngine_ReloadBank`, `NextByte`, `AfterChar`, `LineWrap` are the four shared entry points.  `TextEngine_DrawWideGlyph` / `DrawNarrowGlyph` call `Glyph_LoadWide` / `Glyph_LoadAscii` (7F) and `Canvas_BlitGlyph`.  `TextEngine_DrawChar` (1028) is an uncalled twin without the next-byte/wrap part (PROBABLE).
`Glyph_CopyAsciiRowsDoubled`, `Glyph_UnpackWideHalvesDoubled` are the ROM0 halves of the bank-7F glyph loaders (12 rows x 2 plane bytes; 18 source bytes = 12x12 px, 1 bpp, unpacked to two 6-px halves); their single-write twins and `Glyph_CopyToLeftBuf` are uncalled (PROBABLE).  `Text_MeasureFit` (1408) measures how many bytes of a string fit into a pixel width (3 call sites in the browser page layout).

### Strings, dial numbers, built-in HTML (string.asm, far_string.asm, html_store.asm, keyword_scan.asm)

`StringAppend` (14F3, strcat with a search byte), `PromptText_Load` (153D, copies `PromptText_Table[A]` of bank 65 to `$D000` of WRAM 5; 14 callers), `Dial_CopySelectedNumber` (1586) with `Table_Dial_SramEntryPtrs` (161A), `HtmlStore_BuildPageUrl` (131A, builds `file://di/<name>.htm` from the bank-3F index) and `HtmlStore_LoadPage` (1354, copies the matching record's HTML and its length word into the receive buffer; executed only by the mobile dictionary pages), `Html_MatchKeyword` (10E9, case-insensitive prefix match over a pointer list) and `Html_ScanAttributes` (1119), the two scanners that `naming_g8.md` had cited by address.  `Table_Random_XorBytes` names the 256-byte table of `Random`; `Multiply8x8` and `Multiply16Preserve` are uncalled wrappers of the existing multipliers.

## Left neutral (HYPOTHESIS rows of the TSV)

| label | why |
|---|---|
| `Function_00_032E` | `jp Boot_MainLoop` after the inline FarCall data; fall-through piece |
| `Function_00_0A2A` | uncalled 2-store helper (E,D at [HL..]) |
| `Function_00_0D34` | odd routine (writes bank $F0, then reads WRAM `$C200+E`, sign-extends into DE), no caller |
| `Function_00_14D1` | `CopyStringMax` variant that writes the terminator at the **source** pointer when BC hits 0; 4 callers copy 16-byte phone/comment fields; the contract needs a decision on that quirk (probably an original bug) |
| `Function_00_158D`, `Function_00_1059`, `Function_00_1079`, `Function_00_10A3`, `Function_00_10C6`, `Function_00_10DB` | fall-through pieces after inline FarCall data of the routine above them |

## Open questions and hints for other passes

* Text-engine registers (names not proposed here because `ram/hram.asm` belongs to the RAM pass): from `TextEngine_AfterChar`/`LineWrap` the code supports `hRam_FFC4` = right x limit (auto-wrap when `hTextX` exceeds it), `hRam_FFC1/FFC2` = x the line restarts at, `hRam_FFC6` = y step per line (`$FF` = single-line text, newline ends the text), `hRam_FFC3` = y limit, `hRam_FFB9` = bank of the current string, `hRam_FFBF` = sub-string depth; `hRam_FFBA/FFBB` are passed as B/C to `Canvas_BlitGlyph` (style/colour bytes, meaning unknown).  The fixed positions of control bytes `$04-$07` ((Y,X) = (3,0), (1,0), (2,0), (0,2)) look too small to be pixels and were never executed: units unknown.
* `hRam_FFF0/FFF1` = X/Y offset added by `Sprite_HookAddSlideOffset`; the Y part is stepped by `Dialog_SlideIn`, the X part has no writer found.
* Sprite slot layout (frame table, delay, script index, attribute masks, flags in byte `$0F`) is inferred from `Sprite_StepAndDrawSlot` only; `Sprite_LoadObjectEntry` fills the entry fields from a 4-byte object row.
* `Function_00_06B7` (`FarCall_IdleLoop`) was never executed in 64 scenarios; `Tilemap_CopyRectAndAttrSplitSrc`, `Tilemap_ClearBuffers`, `Gfx_UploadWinMapBuffersDi`, `FarJump_Inline16`, `ReadBytesFar`, `CopyBytesFarToFar` and the six uncalled `Sound_*` stubs have no caller in the tree (their names only state what the code does).
* `HtmlStore_LoadPage` is executed by the monkey scenarios that open the mobile dictionary only; the output contract (length word first, then HTML) is read from the code plus the record format in the ROM, the second call in `MobileDictView_Show` (append after the first page?) is not understood.
* `wRam_C10E..C11D` is both a 16-byte staging buffer (`CopyBytesFarToFar`) and a pointer pair read by `Tilemap_CopyRectAndAttrPtr`; the pointer users and the staging routine never run together in the traces.
