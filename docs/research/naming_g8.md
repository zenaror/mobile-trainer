# reference 8/8: banks 74, 7C, 7D, 7E, 7F

## 1. Numbers

| bank | rows | CONFIRMED | PROBABLE | HYPOTHESIS | of which generic-name rows |
|---|---:|---:|---:|---:|---:|
| 74 | 88 | 25 | 56 | 7 | 7 |
| 7C | 28 | 27 | 0 | 1 | 1 |
| 7D | 7 | 7 | 0 | 0 | 0 |
| 7E | 11 | 7 | 4 | 0 | 0 |
| 7F | 75 | 22 | 38 | 15 | 15 |
| total | 209 | 88 | 98 | 23 | 23 |

## 2. Subsystem map

| bank | content | entry points (from other banks) | main data |
|---|---|---|---|
| 74 | HTML-subset parser + line layout + URL resolver of the home-page browser | `Html_ParsePage` 4207 / `Html_ScanPage` 4254 (4C, 4E), `HtmlUrl_GetSchemeId` 5969, `HtmlUrl_Resolve` 5981, `Html_NextResourceRecord` 5B4F, `HtmlUrl_NormalizePath` 5BA0 | keyword tables 4000-4165, jump tables 44A0/511A/4BEC, URL scheme table 5905 |
| 7C | main-loop state handlers: title menu "Start" (7B7C) and "Mobile settings" (7D1F), top menu, mail menu, settings menu; one 15 KB block of 12x12 kanji glyphs | `Nav_TitleStart`, `Nav_TitleMobileSettings` (far-called by 1C:4000) | font rows 25-33 (4000-7B7B) |
| 7D | joypad poll (`Joypad_Update` 139 callers), auto-repeat timing | 7BB7, 7BA4, 7BC1, 7BF0, 7C00 | font rows 16-24 |
| 7E | Shift-JIS <-> ISO-2022-JP / EUC-JP conversion for mail and web pages | 7C34 (encode, bank 54), 7D62 (decode, bank 54), 7D19 (page normaliser, 4C/67) | font rows 1-8 and 13 |
| 7F | glyph fetch + 6x12 glyph blit into a WRAM tile canvas (used by the whole UI), split-screen STAT scroll enable/disable, GDMA helper, keyboard slide helpers (bank 55), clock reset, sprite-slot save/restore, and ~6 KB of unreferenced prototype code | 4007, 405F, 42C3, 42CA, 41A7, 4C42, 7271, 72B0, 72C2, 61FF, 624F, 627C, 70FD-7224 | tables 40F9/4150, masks 499C/49A5, scroll-step tables 7385/747F/75CB/771E, unused tile/tilemap/palette/object blocks |

## 3. Bank 7C: navigation states

```
title screen 0E:4000  (スタート / モバイルせってい)
 |-- 1 -> Nav_TitleStart 7C:7B7C   (48:4A4E must return B=0)      executed after the first title entry in mail_*, homepage, help
 |         top menu loop  (1F:4000)                                -> Nav_TopMenuJumpTable 7B8E
 |            0 back | 1 Nav_TopMenu_Mail -> Nav_MailMenu 7BB7 | 2 Nav_TopMenu_Homepage -> 4F:4668 | 3 Nav_TopMenu_Help -> 6C:5987
 |         Nav_MailMenu 7BB7 (48:49DB), loop 1D:4000              -> Nav_MailMenuJumpTable 7BC9
 |            1 SendReceive (27:41BC, 27:4000)   mail_send/receive/timeout, tutorial_profile
 |            2 WriteMail   ([A000] bank 0 == 0 ? 2D:4000 : 2B:4000)   mail_compose
 |            3 Mailbox     (25:4000)             mail_mailbox, mail_inbox
 |            4 AddressBook (2F:7EBF)             mail_addressbook, addressbook_full
 |            5 Profile     (2A:5495)             mail_profile
 |            6 MailServer  (23:4000, or 22:4000 with exactly SELECT+LEFT held: xor $24 at 7C:7D06)   mail_server*, hidden variant
 `-- 2 -> Nav_TitleMobileSettings 7C:7D1F                          executed in title_settings, settings_cgi, settings_phone (menu screen 68:4F9E)
           settings loop (68:4F9E, 4 entries, 5 with B+SELECT+RIGHT)  -> Nav_MobileSettingsJumpTable 7D60
              1 ChangePassword 67:58CD  (frame 1809 in title_settings = macro step 1, POST daa_gb_pwdchg.cgi)
              2 UsageTime      67:60BA  (frame 8507 = step 2, daa_gb_jikan.cgi)
              3 UsageFee       67:626F  (frame 14403 = step 3, /cgb/utility?request=summary)
              4 DeleteRegistration 68:7951 (frame 20305 = step 4)
              5 PhoneNumber    67:4000  (hidden; settings_phone)
```

## 5. Bank 7E: charset conversion

| addr | name | type | status |
| --- | --- | --- | --- |
| 7E:4000 | `GlyphFont_Jis12x12_7E` | data | CONFIRMED |
| 7E:7B7C | `Charset_JisToSjis` | function | CONFIRMED |
| 7E:7BA3 | `Charset_SjisToJis` | function | CONFIRMED |
| 7E:7BD6 | `Charset_EucJpToSjis` | function | PROBABLE |
| 7E:7BDE | `Charset_DetectEncoding` | function | CONFIRMED |
| 7E:7C2A | `Charset_ReadByteCounted` | function | PROBABLE |
| 7E:7C34 | `Charset_SjisToIso2022Jp` | function | CONFIRMED |
| 7E:7D19 | `Charset_ConvertPage` | function | PROBABLE |
| 7E:7D62 | `Charset_Iso2022JpToSjis` | function | CONFIRMED |
| 7E:7D8F | `Charset_Iso2022JpStates` | table | CONFIRMED |
| 7E:7E68 | `Charset_EucJpToSjisStream` | function | PROBABLE |

### 6.1 Font access and the glyph pipeline

```
text engine 00:1028 / 10B1 (draw char)                     other UI code (banks 24 25 28 2A 2C 2D 2F ...)
   ASCII:  B=char, DE=buffer   -> Glyph_LoadAscii 7F:4007  -> Glyph_AsciiAddr 400E  (ROM 76:67A8 + 12*(c-$20)) + 00:0DB9 (12 rows doubled -> 24 bytes)
   SJIS :  HL=code, BC/DE=bufs -> Glyph_LoadWide  7F:405F  -> 63:4000 (SJIS validity bitmap: an unsupported code becomes $81A1)
                                                            -> Glyph_SjisToJis 4072 -> Glyph_JisToKuTen 40B0 -> Glyph_KuTenAddr 40B9 (bank+address of the 18-byte glyph)
                                                            -> 00:0DE2 (unpack 12x12 into a left and a right 6-px half, 24 bytes each)
   draw:   Canvas_BlitGlyph 7F:42C3 (colour remap by B/C) -> Canvas_BlitGlyphNoRemap 42CA (bit-shifts the 6-px half into the WRAM tile canvas)
   upload: Canvas_UploadToVram 4BBC or the caller's own GDMA (Gfx_GdmaAtVBlank / Gfx_GdmaAtVBlankNoDi)
```

| ku (JIS row) | bank | first ku of the bank |
  |---|---|---|
  | 1-8, 13 | 7E | 1 (row 13 is the 9th slot, first=5) |
  | 9-12, 14, 15 | none ($FF) | - |
  | 16-24 | 7D | 16 |
  | 25-33 | 7C | 25 |
  | 34-42, 43-51, 52-60, 61-69, 70-78 | 7B, 7A, 79, 78, 77 | 34, 43, 52, 61, 70 |
  | 79-87 | 76 | 79 (rows 85-87 hold no JIS characters; the 6x12 **ASCII font** lives in that space at `76:67A8`, 96 glyphs x 12 bytes = `$67A8-$6C27`) |

| addr | name | type | status |
| --- | --- | --- | --- |
| 7F:4000 | `Function_7F_4000` | function | HYPOTHESIS |
| 7F:4007 | `Glyph_LoadAscii` | function | CONFIRMED |
| 7F:400E | `Glyph_AsciiAddr` | function | CONFIRMED |
| 7F:4042 | `Function_7F_4042` | function | HYPOTHESIS |
| 7F:405F | `Glyph_LoadWide` | function | CONFIRMED |
| 7F:4072 | `Glyph_SjisToJis` | function | CONFIRMED |
| 7F:40B0 | `Glyph_JisToKuTen` | function | CONFIRMED |
| 7F:40B9 | `Glyph_KuTenAddr` | function | CONFIRMED |
| 7F:40F9 | `GlyphFont_RowBankTable` | data | CONFIRMED |
| 7F:4150 | `GlyphFont_RowFirstTable` | data | CONFIRMED |
| 7F:41A7 | `Glyph_IsSjisLeadByte` | function | CONFIRMED |
| 7F:41D0 | `Glyph_Mul16` | function | CONFIRMED |
| 7F:41EA | `Canvas_RemapGlyphColors` | function | PROBABLE |
| 7F:42A3 | `Canvas_RemapTable` | table | PROBABLE |
| 7F:42C3 | `Canvas_BlitGlyph` | function | CONFIRMED |
| 7F:42CA | `Canvas_BlitGlyphNoRemap` | function | CONFIRMED |
| 7F:499C | `Canvas_BlitMaskCur` | data | PROBABLE |
| 7F:49A5 | `Canvas_BlitMaskNext` | data | PROBABLE |
| 7F:49AE | `Function_7F_49AE` | function | HYPOTHESIS |
| 7F:4AAF | `Function_7F_4AAF` | function | HYPOTHESIS |
| 7F:4BBC | `Canvas_UploadToVram` | function | PROBABLE |
| 7F:4C20 | `Gfx_GdmaAtVBlank` | function | PROBABLE |
| 7F:4C42 | `Glyph_LoadDottedLine` | function | CONFIRMED |
| 7F:4C57 | `Glyph_DottedLineData` | data | CONFIRMED |
| 7F:4C78 | `Function_7F_4C78` | function | HYPOTHESIS |

### 6.2 Unreferenced prototype (`7F:4C78-61E8`, about 6 KB)

| addr | name | type | status |
| --- | --- | --- | --- |
| 7F:4CA9 | `Canvas_InitScreen` | function | PROBABLE |
| 7F:4D95 | `Function_7F_4D95` | function | HYPOTHESIS |
| 7F:4E0D | `Function_7F_4E0D` | function | HYPOTHESIS |
| 7F:4E89 | `Sample_PageNamePtrs` | table | PROBABLE |
| 7F:4EF0 | `Sample_PageUrlPtrs` | table | PROBABLE |
| 7F:4FC3 | `PageListProto_UrlSlotTable` | table | PROBABLE |
| 7F:4FCF | `PageListProto_TitleSlotTable` | table | PROBABLE |
| 7F:4FDB | `Function_7F_4FDB` | function | HYPOTHESIS |
| 7F:5011 | `Function_7F_5011` | function | HYPOTHESIS |
| 7F:5805 | `Function_7F_5805` | function | HYPOTHESIS |
| 7F:61E6 | `Function_7F_61E6` | function | HYPOTHESIS |
| 7F:61E7 | `Function_7F_61E7` | function | HYPOTHESIS |
| 7F:61FC | `Stub_Nop_7F_61FC` | function | CONFIRMED |
| 7F:61FF | `Timer_ResetClockB` | function | PROBABLE |

### 6.3 Clocks, sprite slots, dialogs

| addr | name | type | status |
| --- | --- | --- | --- |
| 7F:6218 | `Function_7F_6218` | function | HYPOTHESIS |
| 7F:6235 | `Function_7F_6235` | function | HYPOTHESIS |
| 7F:624F | `Sprites_SaveSlotsToBank3` | function | PROBABLE |
| 7F:627C | `Sprites_RestoreSlotsFromBank3` | function | PROBABLE |

### 6.4 Split-screen scrolling and keyboard slide helpers

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 7F:70FD | `KbdSlide_InPrepMode6` | function | PROBABLE | called by 55:6342 when [C2AB]==6: D = (wSpriteSlots[16] - $0D)/$0C (row index of the cursor object), E=0 = start state of the slide-in steps; executed in 7 scenarios |
| 7F:7116 | `KbdSlide_InStepMode6` | function | PROBABLE | 55:6392 per-frame step while WY falls by 8: ScrollSplit_StepUp3(D,E) then far call 00:0956 (sprite/OAM update), keeps DE |
| 7F:7125 | `KbdSlide_OutPrepMode6` | function | PROBABLE | called by 55:6472 (slide-out, [C2AB]==6): D = [C0D3]/$0C + 1 (0 when [C0D3]==0) = row index into the StepDown3 table, E=0 |
| 7F:713A | `KbdSlide_OutStepMode6` | function | PROBABLE | 55:64C2 per-frame step while WY rises by 8: ScrollSplit_StepDown3(D,E) then 00:0956 |
| 7F:7149 | `KbdSlide_InPrepMode8` | function | PROBABLE | 55:634C: D = [D725] (WRAM bank 1) or 4 when zero, E=0 |
| 7F:7165 | `KbdSlide_InStepMode8` | function | PROBABLE | 55:63A3 slide-in step: ScrollSplit_StepUp4(D,E) then 00:0956 |
| 7F:7178 | `KbdSlide_OutPrepMode8` | function | PROBABLE | 55:647C slide-out: same D/E as KbdSlide_InPrepMode8 |
| 7F:7194 | `KbdSlide_OutStepMode8` | function | PROBABLE | 55:64D3 slide-out step: ScrollSplit_StepDown4(D,E) then 00:0956 |
| 7F:71A7 | `KbdSlide_InPrepMode9` | function | PROBABLE | 55:6356: D = [D725] or 5, E=0 |
| 7F:71C3 | `KbdSlide_InStepMode9` | function | PROBABLE | 55:63B4 slide-in step: ScrollSplit_StepUp4 then 00:0956 |
| 7F:71D6 | `KbdSlide_OutPrepMode9` | function | PROBABLE | 55:6486 slide-out: same D/E as KbdSlide_InPrepMode9 |
| 7F:71F2 | `KbdSlide_OutStepMode9` | function | PROBABLE | 55:64E4 slide-out step: ScrollSplit_StepDown4 then 00:0956 |
| 7F:7205 | `KbdSlide_InPrepMode7` | function | PROBABLE | 55:6360: D=8, E=0 (constant start state) |
| 7F:720C | `KbdSlide_InStepMode7` | function | PROBABLE | 55:63C5 slide-in step: ScrollSplit_StepUp4 then 00:0956 (registers preserved except DE) |
| 7F:721D | `KbdSlide_OutPrepMode7` | function | PROBABLE | 55:6490 slide-out: D=8, E=0 |
| 7F:7224 | `KbdSlide_OutStepMode7` | function | PROBABLE | 55:64F5 slide-out step: ScrollSplit_StepDown4 then 00:0956 |
| 7F:7271 | `Stat_EnableScrollSplit` | function | CONFIRMED | installs the RAM STAT vector wLcdStatVector = jp $0E93 (alternative STAT handler), waits LY=$64, rSTAT=$44, rLYC=0, [C0D3]=0, IF=0, IE|=3; the handler switches SCY to [C0D3] at line [D724]; 74 external callers, 21 scenarios |
| 7F:72B0 | `Stat_DisableScrollSplit` | function | CONFIRMED | writes $D9 (reti) to wLcdStatVector (CBF4), IF=0, IE &= $FD (STAT off); inverse of Stat_EnableScrollSplit; 139 external callers, executed in 21 scenarios |
| 7F:72C2 | `Gfx_GdmaAtVBlankNoDi` | function | CONFIRMED | same as Gfx_GdmaAtVBlank without di/ei: HL=src DE=dst C=(blocks-1), waits LY=$8F/$91, writes rHDMA5; 14 external callers (22:4B0B, 23:49FA ...), executed in 12 scenarios |
| 7F:733A | `ScrollSplit_StepUp3` | function | CONFIRMED | D=table row (0-7), E=step (0-19): b = Table[D][E]; [C0D3] += b (SCY below the split line, 00:0EB2) and sprite slots +16/+32/+64 (Y) -= b; E++; executed 7 scenarios |
| 7F:7375 | `ScrollSplit_StepUp3Ptrs` | table | PROBABLE | 8 row pointers (7385, 7399, ... stride $14) read by ScrollSplit_StepUp3 (ld hl,$7375 at 7F:733B ; c=2*d) |
| 7F:7385 | `ScrollSplit_StepUp3Deltas` | data | PROBABLE | 8 rows x 20 bytes of per-step pixel deltas indexed [D][E] by ScrollSplit_StepUp3 |
| 7F:7425 | `ScrollSplit_StepUp4` | function | CONFIRMED | D=row (0-11), E=step: b = Table[D][E]; [C0D3] += b, sprite slots +16/+32/+48/+64 Y -= b; E++ (four-object variant of StepUp3); executed 12 scenarios |
| 7F:7467 | `ScrollSplit_StepUp4Ptrs` | table | PROBABLE | 12 row pointers of ScrollSplit_StepUp4 (ld hl,$7467 at 7F:7426) |
| 7F:747F | `ScrollSplit_StepUp4Deltas` | data | PROBABLE | 12 rows x 20 bytes of per-step deltas indexed [D][E] |
| 7F:7578 | `ScrollSplit_StepDown3` | function | CONFIRMED | like StepUp3 with the opposite sign: [C0D3] -= b, sprite slots +16/+32/+64 Y += b; executed 7 scenarios |
| 7F:75B3 | `ScrollSplit_StepDown3Ptrs` | table | PROBABLE | 12 row pointers of ScrollSplit_StepDown3 (ld hl,$75B3 at 7F:7579) |
| 7F:75CB | `ScrollSplit_StepDown3Deltas` | data | PROBABLE | 12 rows x 20 bytes of per-step deltas indexed [D][E] |
| 7F:76C4 | `ScrollSplit_StepDown4` | function | CONFIRMED | like StepUp4 with the opposite sign ([C0D3] -= b, four sprite slots Y += b); executed 11 scenarios |
| 7F:7706 | `ScrollSplit_StepDown4Ptrs` | table | PROBABLE | 12 row pointers of ScrollSplit_StepDown4 (ld hl,$7706 at 7F:76C5) |
| 7F:771E | `ScrollSplit_StepDown4Deltas` | data | PROBABLE | 12 rows x 20 bytes of per-step deltas indexed [D][E] |
| 7F:7817 | `Function_7F_7817` | function | HYPOTHESIS | WRAM bank 7: sprite slots +16 and +32 Y = $20 - [C0D3]; only called from the unreferenced chains 7F:723D and 7F:725B |

### 7.2 Tag dispatch (`Html_TagHandlerTable` 74:44A0, indexed by the tag id of `Html_TagNames`)

| id | tag | handler | in the served test pages |
| --- | --- | --- | --- |
| 0 | (unknown tag) | `Label_74_4439` skips the attributes with `00:1119` and an empty keyword list (`Html_NoKeywords`) | - |
| 1 | html | `Html_Tag_Html` | every page |
| 2 | title | `Html_Tag_Title` (+ `Html_StoreTitle`) | every page |
| 3 | head | `Html_Tag_Head` | every page |
| 4 | body | `Html_Tag_Body` | every page (see below) |
| 5 | center | `Html_Tag_Center` | b, big, a, d, index |
| 6 | div | `Html_Tag_Div` | a, d |
| 7 | br | `Html_Tag_Br` | 99 tags |
| 8 | hr | `Html_Tag_Hr` | 12 tags |
| 9 | img | `Html_Tag_Img` | a, b, c, big (`web=all` only) |
| $0A | a | `Html_Tag_A` | 33 tags |
| $0B | b | `Html_Tag_B` | 92 tags |
| $0C | ul | `Html_Tag_Ul` | a, c, index |
| $0D | ol | `Html_Tag_Ol` | a only |
| $0E | li | `Html_Tag_Li` | 22 tags |
| $0F | ! | `Html_Tag_Comment` | a only |
| $10 | meta | `Html_Tag_Meta` | a only |
| $11 | pre | `Html_Tag_Pre` | a only |

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 74:4481 | `Html_DispatchTag` | label | CONFIRMED | tag id -> handler: add a,a; add a,$A0; ... push bc; ret through Html_TagHandlerTable; id $0F ('!') dispatches at once, other tags need '>' or whitespace after the name (74:448F) |
| 74:44A0 | `Html_TagHandlerTable` | table | CONFIRMED | 18-word jump table indexed by the tag id of Html_TagNames (0 = unknown tag, 1 html ... $11 pre); dispatcher 74:4490-449F executed in homepage/browser scenarios |
| 74:44C4 | `Html_Tag_Title` | function | CONFIRMED | handler of tag id 2 'title': on open records the output pointer DE in hRam_FFB6/FFB7 (start of the title text); on '</' does nothing (Html_StoreTitle is called from 74:44E5) |
| 74:45D9 | `Html_Tag_Comment` | function | CONFIRMED | handler of tag id $0F '!': skips '' (looks for '--' then '>' with the frame service called in the loop 74:4609); other '!' tags end at '>' |
| 74:4623 | `Html_Tag_Html` | function | CONFIRMED | handler of tag id 1 'html': sets bit0 of [C2C1] (tested by 4C:456A/5187 to accept the page) |
| 74:462E | `Html_Tag_Head` | function | CONFIRMED | handler of tag id 3 'head': open sets bit1 of [C2C1], '</head>' clears it (Html_Tag_Meta only acts while bit1 is set) |
| 74:464A | `Html_Tag_Body` | function | PROBABLE | handler of tag id 4 'body' (open sets bit2 of [C2C1]) but unreachable: Html_TagPtrs lists 'b' before 'body', 00:10E9 returns the first prefix match and 74:448B rejects it; never executed although all 7 served pages contain <body> |
| 74:4666 | `Html_Tag_Pre` | function | CONFIRMED | handler of tag id $11 'pre': after Html_Layout_WrapRun/Html_Layout_EndLine sets or clears bit3 of [C2C1] (bit3 keeps CR/LF/TAB in the text loop, 74:4359-4372) |
| 74:4698 | `Html_Tag_Meta` | function | CONFIRMED | handler of tag id $10 'meta': only inside <head> (C2C1 bit1); entered in 3 scenarios (a.html <meta name= content=>) but the ppp_id/r_code/d_code copies to $D300/$D340/$D380 (WRAM bank 6) never ran |
| 74:4718 | `Html_Tag_Center` | function | CONFIRMED | handler of tag id 5 'center': open pushes alignment $08 on the align stack (WRAM bank 6 $D000+[C33D], current value [C33C]); close pops it |
| 74:472E | `Html_Tag_Div` | function | CONFIRMED | handler of tag id 6 'div': open with an align= attribute (Html_AlignValueNames) pushes that alignment like Html_Tag_Center; close pops |
| 74:47AA | `Html_Tag_Ul` | function | CONFIRMED | handler of tag id $0C 'ul': open pushes the item counter ([C33A]/[C33B], stack at WRAM6 $D100 indexed by [C33E]) and sets bullet mode ($3F00); indent +12 px (hRam_FFD8/FFD9); close pops |
| 74:4867 | `Html_Tag_Ol` | function | CONFIRMED | handler of tag id $0D 'ol': like ul but counter=1 and indent 12 or 18 px depending on Html_CountListItems (>=10 items -> two digits, 74:48A3-48BC) |
| 74:493F | `Html_Tag_Li` | function | CONFIRMED | handler of tag id $0E 'li': writes the bullet (Html_ListBullet) when the counter is 0 or $3Fxx (ul), else the counter (<=99) as decimal digits + '.' ($2E), then increments it (74:4959-4A27) |
| 74:4A32 | `Html_Tag_B` | function | CONFIRMED | handler of tag id $0B 'b': [C338/C339] counts open tags (+1 / -1 on '/'); style bits hRam_FFB2&3 become 2 (bold style; 1 = link style has priority) |
| 74:4A91 | `Html_Tag_A` | function | CONFIRMED | handler of tag id $0A 'a': href -> HtmlUrl_GetSchemeId + Html_StringTable_Add ('/'-tagged link string), name -> '#'-tagged anchor; style bit0 in hRam_FFB2 while the link is open; links with scheme value $FF are dropped (74:4B49-4B4B) |
| 74:4B98 | `Html_Tag_Br` | function | CONFIRMED | handler of tag id 7 'br': optional clear=left|right|all -> [C330]; ends the line (Html_Layout_WrapRun + Html_Layout_EndLine); for clear repeats until the margins are free (Html_BrClearJumpTable) |
| 74:4BEC | `Html_BrClearJumpTable` | table | PROBABLE | inline table of the call $0545 at 74:4BE9, index [C330]: 0 plain <br>, 1 clear left (4BF4), 2 clear right (4C12), 3 clear both (4C33); each loops with hRam_FFC7=$0C until Html_Layout_GetLimitsAtY reports free margins |
| 74:4CA6 | `Html_Tag_Hr` | function | CONFIRMED | handler of tag id 8 'hr': optional width= (Html_ParseDecimal, '%' -> Multiply16), emits repeated SJIS $83E6 + remainder code $83DB-$83E6 (74:4D5C-4D8C); font glyph ku6/ten72 = 12-px horizontal line, ten61-71 shorter |
| 74:4DF9 | `Html_Tag_Img` | function | CONFIRMED | handler of tag id 9 'img': with C335=0 finds src in the SRAM-bank-3 resource list (74:4E6B), checks it with 51:70E0 and places it (Html_Layout_PlaceImage); with C335!=0 only queues the URL (74:4F09) |
| 74:511A | `Html_CountPassTagTable` | table | PROBABLE | 18-word tag table of Html_CountListItems (same idiom as Html_TagHandlerTable; only title/ul/ol/li/comment/pre entries differ, the rest = 50B3 pass-through); dispatcher 74:510A-5119 |

### 7.4 Functions

| addr | name | type | status |
| --- | --- | --- | --- |
| 74:4165 | `Html_MetaResultToError` | function | PROBABLE |
| 74:4207 | `Html_ParsePage` | function | CONFIRMED |
| 74:4254 | `Html_ScanPage` | function | PROBABLE |
| 74:4296 | `Html_ParseSource` | function | CONFIRMED |
| 74:4530 | `Html_StoreTitle` | function | PROBABLE |
| 74:4F4F | `Html_InitParser` | function | CONFIRMED |
| 74:4FF2 | `Html_CountListItems` | function | PROBABLE |
| 74:537D | `Html_LoadPageImages` | function | PROBABLE |

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 74:4F97 | `Function_74_4F97` | function | HYPOTHESIS | called first by the ul/ol/li handlers: if DE differs from the pointer kept in C331 (list marker end; Html_Tag_Li writes C331 twice, C332 never set) runs Html_Layout_WrapRun + Html_Layout_EndLine; then clears C331/C332 |
| 74:4FBE | `Function_74_4FBE` | function | HYPOTHESIS | called by ul/ol before pushing a list: Html_Layout_WrapRun, and unless still at a line start with nothing pending (hRam_FFC6/FFC7 zero) Html_Layout_EndLine with hRam_FFC7=$0C (one blank text line) |
| 74:5252 | `Html_Layout_ClearAllFloats` | function | PROBABLE | end-of-page helper: repeats Html_Layout_GetLimitsAtY with hRam_FFC7=$0C until the line limits equal the viewport edges (FFE1/FFE5), same test as <br clear=all> (74:4C33) |
| 74:529F | `Html_Layout_PlaceImage` | function | PROBABLE | after Html_Tag_Img accepted an image: rounds the BMP width/height in hRam_FFD6/FFD7 (stored by 51:70F4) up to multiples of 12 px (Divide32by15, x12 at 74:52B5-52D5) and reserves the space; skipped when C335!=0 |
| 74:532A | `Function_74_532A` | function | HYPOTHESIS | places the image record of Html_Layout_PlaceImage into the line list (loads FFCA/FFCB list pointer, size FFD6/FFD7, source FFD2-FFD4 and calls 5548); entry only from 74:5320/5326 |
| 74:5348 | `Function_74_5348` | function | HYPOTHESIS | loop that advances hRam_FFC8/FFC9 by 12 px and calls Html_Layout_GetLimitsAtY until both line limits are back at the viewport edges (same test as Html_Layout_ClearAllFloats); never executed |
| 74:53E3 | `Html_Layout_Init` | function | PROBABLE | resets the layout registers: FFC6-FFC9=0, FFB2=0, record list pointer FFCA/FFCC = header+$20, record count FFCE/FFCF=0, limits FFC2-FFC5 copied from the viewport FFE5/FFE1 |
| 74:5417 | `Html_Layout_EndLine` | function | PROBABLE | if C335==0: BC = free width (hRam_FFC2:C3 - FFC4:C5) is passed as slack to Html_Layout_PlaceLine with the text bank mapped; called around almost every block tag (br, hr, ul, ol, div, center, pre) |
| 74:5440 | `Html_Layout_WrapRun` | function | PROBABLE | word-wrap of the pending text run (from [FFBB/FFBC] to NUL): sums glyph widths (6 px ASCII, 12 px SJIS, TAB $30) against the free width, cuts the line and emits records via 5528/5548 (74:5486-5525) |
| 74:5528 | `Function_74_5528` | function | HYPOTHESIS | stores the run start into hRam_FFBB/FFBC and writes the finished width (FFC0/C1 minus BC) into the record at [FFB0/FFB1]+4 |
| 74:5548 | `Html_Layout_AppendRecord` | function | PROBABLE | appends a 16-byte record at hRam_FFCA/FFCB (record: 4 zero bytes, width=C, height=B, type=FFB0, flags=FFB2|$80, link ids, text ptr DE, bank=FFB1); stops at page $E0; count in FFCE/FFCF |
| 74:55BE | `Function_74_55BE` | function | HYPOTHESIS | after a record is appended: moves pending margins (FFC4) and alignment offsets of the flagged records ($09 bit7) - part of Html_Layout_WrapRun/AppendRecord; details unknown |
| 74:5663 | `Html_Layout_PlaceLine` | function | PROBABLE | BC = unused width of the finished line: shifts hRam_FFC4 by the slack for centre/right ([C33C] bits 2-3 = 08/04), then walks all records ([FFCC], count FFCE) and places those with flag bit7 set, clearing it (74:5755-5786) |
| 74:57AD | `Function_74_57AD` | function | HYPOTHESIS | re-flows the records that overlap the current y after a margin change (compares record extents with FFC2-FFC5, rewrites x/width fields); details unknown |
| 74:586E | `Html_Layout_GetLimitsAtY` | function | PROBABLE | DE=y: sets FFC2:C3 (right limit) from FFE5:E6 and FFC4:C5 (left limit) from FFE1:E2 + indent FFD8, then narrows them by the left/right aligned records overlapping y (flag bits $0C/$04) |

URL, string-table and resource helpers:

| addr | name | type | status |
| --- | --- | --- | --- |
| 74:5905 | `HtmlUrl_SchemeTable` | table | PROBABLE |
| 74:591D | `HtmlUrl_SchemeNames` | data | PROBABLE |
| 74:5969 | `HtmlUrl_GetSchemeId` | function | CONFIRMED |
| 74:5981 | `HtmlUrl_Resolve` | function | CONFIRMED |
| 74:59D8 | `HtmlUrl_HttpPrefix` | string | PROBABLE |
| 74:5A76 | `HtmlUrl_FindLastSegmentDelimiter` | function | PROBABLE |
| 74:5A96 | `Html_LinkTable_Init` | function | PROBABLE |
| 74:5AAE | `Html_StringTable_Add` | function | PROBABLE |
| 74:5AF8 | `Html_StringTable_Find` | function | CONFIRMED |
| 74:5B4F | `Html_NextResourceRecord` | function | PROBABLE |
| 74:5B5C | `Html_ParseDecimal` | function | PROBABLE |
| 74:5BA0 | `HtmlUrl_NormalizePath` | function | CONFIRMED |

| addr | name | type | status |
| --- | --- | --- | --- |
| 74:4190 | `Html_MetaResultToError_HexLoop` | label | PROBABLE |
| 74:4307 | `Html_ParseSource_Loop` | label | PROBABLE |
| 74:4392 | `Html_ParseSource_Entity` | label | PROBABLE |
| 74:43C4 | `Html_ParseSource_End` | label | PROBABLE |
| 74:4406 | `Html_ParseSource_Tag` | label | PROBABLE |
| 74:4481 | `Html_DispatchTag` | label | CONFIRMED |
| 74:44D4 | `Html_ParseSource_TitleTag` | label | PROBABLE |
| 74:4C6B | `Html_ParseSource_PreCR` | label | PROBABLE |

### 7.5 Keyword and attribute tables (item format `[ASCII name][NUL][value byte]`, walked by `00:10E9` and the attribute scanner `00:1119`)

| addr | name | type | status |
| --- | --- | --- | --- |
| 74:4000 | `Html_ResultCodePtrs` | table | PROBABLE |
| 74:4006 | `Html_ResultCodeNames` | data | PROBABLE |
| 74:400E | `Html_EntityPtrs` | table | PROBABLE |
| 74:401A | `Html_EntityNames` | data | PROBABLE |
| 74:4033 | `Html_MetaAttrPtrs` | table | PROBABLE |
| 74:403B | `Html_MetaAttrNames` | data | PROBABLE |
| 74:4053 | `Html_TitleTagPtrs` | table | PROBABLE |
| 74:4057 | `Html_BrAttrPtrs` | table | PROBABLE |
| 74:405B | `Html_BrAttrNames` | data | PROBABLE |
| 74:4062 | `Html_HrAttrPtrs` | table | PROBABLE |
| 74:4066 | `Html_HrAttrNames` | data | PROBABLE |
| 74:406D | `Html_AlignAttrPtrs` | table | PROBABLE |
| 74:4071 | `Html_AlignAttrNames` | data | PROBABLE |
| 74:4078 | `Html_AnchorAttrPtrs` | table | PROBABLE |
| 74:407E | `Html_AnchorAttrNames` | data | PROBABLE |
| 74:408A | `Html_ImgAttrPtrs` | table | PROBABLE |
| 74:4090 | `Html_ImgAttrNames` | data | PROBABLE |
| 74:409C | `Html_ClearValuePtrs` | table | PROBABLE |
| 74:40A4 | `Html_ClearValueNames` | data | PROBABLE |
| 74:40B6 | `Html_AlignValuePtrs` | table | PROBABLE |
| 74:40C4 | `Html_AlignValueNames` | data | PROBABLE |
| 74:40EE | `Html_TagPtrs` | table | PROBABLE |
| 74:4110 | `Html_NoKeywords` | table | PROBABLE |
| 74:4112 | `Html_TagNames` | data | PROBABLE |
| 74:4995 | `Html_ListBullet` | data | PROBABLE |

29 rows: glyph work area (`wGlyphBufLeft/Right`, `wGlyphMaskCur/Next`), joypad repeat state (`wJoyRepeat*`), the HTML parser state (`wHtml*`, valid only while bank 74 runs; `C330-C33F` are scratch of the BMP loader too, `D300-D3BF` `D600-DFFD` are WRAM bank 6 only and given size 1 because of the bank ambiguity),
the text buffer `wAttrUrlBuf` (`$C380`, 256 bytes: attribute values and URLs) and the page-view state in HRAM (`hViewX/Y/Right/Bottom`, `hViewScrollMax`, `hPageHeaderPtr`).  Bytes named by other passes (`C0D3`, `D724`, `D824`, `C267/C268`, `C2D5/C2D6`) are referenced in the header of the file instead of being repeated.

## 9. Hypotheses, open questions, findings for others

* Which layout/keyboard the four modes `[C2AB]` = 6-9 of bank 55 are; what the D/E start states (`[D725]` = 0/4/5, `$08`, cursor-sprite row) mean.
* The exact roles of `Function_74_55BE` (floating image placement), `57AD`, `5528`, `5348`, `532A` and `Function_74_4F97/4FBE` (rules only followed, not proven).
* Colour semantics of the 16 `Canvas_RemapTable` handlers (which selector is foreground).
* `D725` (WRAM bank 1): 0 or the row index of the keyboard scroll tables (`KbdSlide_*Mode8/9`).
* Which real feature `7C:7D8D` (three waves of `70:4000/4023`) belongs to; whether `70:4000` is a tutorial/animation player.

* Font banks 77-7B (JIS rows 34-78) and 76 (rows 79-84 + ASCII font at `76:67A8`): rule in section 6.1; bank 76 `67A8-6C28` is **ASCII font data** (12 bytes per glyph, `$20-$7F`) and should not be typed as unused kanji slots.

* `Table_74_40EE` contains the terminator word `$0000` at `74:4110` used as an empty keyword list (`ld bc,$4110`); a label `Html_NoKeywords` was added inside the region.

* `hRam_FFB0-FFDF` are shared scratch between the text engine of ROM0, the HTML parser (bank 74), the URL/resource code of 4C/4E and the BMP loader (bank 51): a single name per address is misleading, the meaning depends on the running subsystem.

* Bank 67 has its own URL code (`Url_Resolve` 67:5F66, `Url_JoinRelative` 67:5FB5, `Url_NormalizePath` 67:5FF9, named by another pass, used for the CGI redirect handling): same job as `HtmlUrl_Resolve`/`HtmlUrl_NormalizePath` of bank 74 but separate code, hence the `HtmlUrl_` prefix here.

* `Nav_MailMenu_SendReceive`: 27:4000 is *not* skipped when 27:41BC returns $FF; it is skipped only when 27:41BC returns $FF **and** `25:4A90` (`Mailbox_CountRecords`) returns D=$0C (mailbox full), which takes the never-executed dialog path `7C:7BFA-7C6A`.

* `Html_Tag_Meta`: the handler *is* executed (3 scenarios, a.html `<meta name= content=>`); what never ran is the ppp_id/r_code/d_code copy.

* `Html_ParsePage` also has a caller in bank 67; `HtmlUrl_GetSchemeId` is called from `4C:4000` only (no bank 4E caller).

## Source classification of7C:57C3..57CD

The earlier region defect in section3 is now represented as font data in the maintained source: data/fonts/jis12x12_rows_25_33.asm uses ten one-byte `db` rows for7C:57C3..57CD instead of ten mnemonic rows.

CONFIRMED static structure/bytes: the complete[7C:4000,7B7C) body is9 rows x94 columns x18 bytes =15228 bytes (0x3B7C), with no ten-byte code hole. At7F:40B9 Glyph_KuTenAddr reads row-1 from GlyphFont_RowBankTable7F:40F9 and GlyphFont_RowFirstTable7F:4150. For rows25..33 those tables give bank7C and first-row25 (0x19). Its multiplication/address chain computes DE=4000+18*((row-25)*94+(column-1)) for valid rows/columns. ROM0 Glyph_UnpackWideHalves/Doubled at0E32/0DE2 selects the supplied low bank then reads18 packed bytes in the shown two-pass layout; high mapper state and interrupt interference must satisfy the existing reader conditions.12x12 one-bit packed glyphs occupy18 bytes. This structural consumer evidence supports PROBABLE font-data classification of the ten restored rows; it does not claim every glyph was naturally read, displayed or visually checked here. Byte6083 (57C3-4000) is the last byte of glyph index337; the remaining nine bytes belong to the next glyph, rather than delimiting an instruction routine.

CONFIRMED table bytes: Nav_MobileSettingsJumpTable[7C:7D60,7D6C) has six words7D6F/7D70/7D79/7D82/7DFF/7E08.
