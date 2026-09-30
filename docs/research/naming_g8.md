# Naming pass 8/8: banks 74, 7C, 7D, 7E, 7F

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`. RAM names quoted here (`wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX`) are the neutral names of `ram/*.asm`; where a semantic name was adopted, its `DEF` line there says `replaces wRam_XXXX`.

Scope: what the evidence supports for **bank 74** (HTML page parser / layout / URL helpers), **7C** (menu navigation states + JIS font rows 25-33),
**7D** (joypad polling + JIS font rows 16-24), **7E** (charset conversion + JIS font rows 1-8/13) and **7F** (glyph fetch and text canvas, STAT split
scrolling helpers, keyboard slide helpers, timers, an unreferenced prototype).  Evidence vocabulary as everywhere: `CONFIRMED` (bytes/trace),
`PROBABLE` (strong, not conclusive), `HYPOTHESIS` (idea only; the row keeps the generic name).  Addresses are `bank:addr` CPU addresses.

Files of this pass: `config/symbols/bank{74,7C,7D,7E,7F}.tsv`, `analysis/naming/ram_g8.tsv` (RAM proposals, *not* merged into `config/ram`),
this document.  `python3 tools/gen_asm.py verify --config <copy of config with these files>` rebuilds the ROM **IDENTICAL**
(sha256 `6d802e66...`); names only change labels, never bytes.

## 1. Numbers

| bank | rows | CONFIRMED | PROBABLE | HYPOTHESIS | of which generic-name rows |
|---|---:|---:|---:|---:|---:|
| 74 | 88 | 25 | 56 | 7 | 7 |
| 7C | 28 | 27 | 0 | 1 | 1 |
| 7D | 7 | 7 | 0 | 0 | 0 |
| 7E | 11 | 7 | 4 | 0 | 0 |
| 7F | 75 | 22 | 38 | 15 | 15 |
| total | 209 | 88 | 98 | 23 | 23 |

Names use the prefixes `Html_` (parser, layout), `HtmlUrl_`, `Glyph_`/`GlyphFont_` (font access), `Canvas_` (text canvas), `Gfx_`, `Stat_`, `ScrollSplit_`,
`KbdSlide_`, `Timer_`, `Sprites_`, `Sample_`, `Nav_` (state navigation, bank 7C), `Joypad_`, `Charset_`.  Prefixes were chosen so that they cannot collide with
the other passes (checked against `config/symbols`, `config/regions` labels, `config/ram` and `analysis/naming/ram_g*.tsv` at the time of writing).
ROM0 routines are cited by address only (`00:10E9` ...) because the ROM0 names of `config/symbols/bank00.tsv` are still generic for them.

## 2. Subsystem map

| bank | content | entry points (from other banks) | main data |
|---|---|---|---|
| 74 | HTML-subset parser + line layout + URL resolver of the home-page browser | `Html_ParsePage` 4207 / `Html_ScanPage` 4254 (4C, 4E), `HtmlUrl_GetSchemeId` 5969, `HtmlUrl_Resolve` 5981, `Html_NextResourceRecord` 5B4F, `HtmlUrl_NormalizePath` 5BA0 | keyword tables 4000-4165, jump tables 44A0/511A/4BEC, URL scheme table 5905 |
| 7C | main-loop state handlers: title menu "Start" (7B7C) and "Mobile settings" (7D1F), top menu, mail menu, settings menu; one 15 KB block of 12x12 kanji glyphs | `Nav_TitleStart`, `Nav_TitleMobileSettings` (far-called by 1C:4000) | font rows 25-33 (4000-7B7B) |
| 7D | joypad poll (`Joypad_Update` 139 callers), auto-repeat timing | 7BB7, 7BA4, 7BC1, 7BF0, 7C00 | font rows 16-24 |
| 7E | Shift-JIS <-> ISO-2022-JP / EUC-JP conversion for mail and web pages | 7C34 (encode, bank 54), 7D62 (decode, bank 54), 7D19 (page normaliser, 4C/67) | font rows 1-8 and 13 |
| 7F | glyph fetch + 6x12 glyph blit into a WRAM tile canvas (used by the whole UI), split-screen STAT scroll enable/disable, GDMA helper, keyboard slide helpers (bank 55), clock reset, sprite-slot save/restore, and ~6 KB of unreferenced prototype code | 4007, 405F, 42C3, 42CA, 41A7, 4C42, 7271, 72B0, 72C2, 61FF, 624F, 627C, 70FD-7224 | tables 40F9/4150, masks 499C/49A5, scroll-step tables 7385/747F/75CB/771E, unused tile/tilemap/palette/object blocks |

## 3. Bank 7C: navigation states

`00:0328` calls `1C:4000` forever; `1C:4000` far-calls the title screen `0E:4000` and dispatches its result (boot_and_home.md 3.12): 1 -> `7C:7B7C`, 2 -> `7C:7D1F`.
Both bank-7C handlers are small loops of the shape `farcall <menu screen>; call $0545 (JumpTableInline)` with the jump table stored inline after the call,
every entry ending with `jp <loop head>`.  Which handler is which was fixed by the scenario macros (`traces/inputs/*.macro`, `traces/scenarios.tsv`) and the
first-execution frames in `traces/coverage_*.tsv`:

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

The frame numbers of the four settings entries are strictly increasing in the same order as the four steps of `title_settings.macro` (change password, usage time, usage fee,
delete registration), which is what fixes entries 1-4.  Unreferenced: `7C:7D8D-7DFC` (far calls to `70:4000/4023` in three waves waiting for A, ending in `jr Nav_MobileSettings_UsageFee`; no caller, never executed),
`7C:7BFA-7C6A` (never executed; reached when `27:41BC` returns $FF and `25:4A90` returns D=$0C).

**Region defect found in bank 7C (for the region owner).**  `config/regions/bank7C.tsv` has a 10-byte `code` region `57C3-57CD` in the middle of the font
(`4000-57C3 gfx`, `57C3-57CD code`, `57CD-7B7C gfx`).  The 12x12 font of a bank is one contiguous block of 9 rows x 94 glyphs x 18 bytes = `$3B7C` bytes, i.e. exactly
`4000-7B7B` (checked for 7C, 7D, 7E), so `57C3-57CD` is font data.  The "entry by table from 7C:7D5D" came from the mapper reading the operand bytes `C3 57 7D` of
the `jp $7D57` at `7C:7D6C` as the word `$57C3` (already noted in the region note of `Table_7C_7D60`).  I only changed symbol names (no region edits are in my scope);
the two gfx regions and the code region should be merged into one `gfx` region of `4000-7B7C`.

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 7C:4000 | `GlyphFont_Jis12x12_7C` | data | CONFIRMED | 12x12 kanji font, JIS rows 25-33 (9 x 94 glyphs x 18 bytes = $3B7C bytes, whole 4000-7B7B); row->bank via GlyphFont_RowBankTable (rows 25-33 -> 7C, first ku 25); glyph layout checked by rendering bank 7E ku4/ten2 = hiragana A |
| 7C:7B7C | `Nav_TitleStart` | function | CONFIRMED | main-loop state 1 (1C:401D far-calls it when the title screen 0E:4000 returns 1 = スタート): far call 48:4A4E (B!=0 aborts), then the top-menu loop; executed after the title's first entry in the mail/browser/help scenarios |
| 7C:7B85 | `Nav_TopMenuLoop` | label | CONFIRMED | loop head: far call 1F:4000 (top menu screen) then call $0545 dispatch on its result through Nav_TopMenuJumpTable |
| 7C:7B8E | `Nav_TopMenuJumpTable` | table | CONFIRMED | inline table of the call $0545 at 7C:7B8B: 0 back (ret), 1 mail, 2 homepage, 3 help; every entry tail jumps back to Nav_TopMenuLoop |
| 7C:7B99 | `Nav_TopMenu_Back` | label | CONFIRMED | entry 0: ret (returns to the 1C:4000 main loop = title screen) |
| 7C:7B9A | `Nav_TopMenu_Mail` | label | CONFIRMED | entry 1: far call Nav_MailMenu (7C:7BB7); executed in every mail_* scenario |
| 7C:7BA3 | `Nav_TopMenu_Homepage` | label | CONFIRMED | entry 2: far call 4F:4668 (browser); executed in homepage and browser_* scenarios only (plus monkeys) |
| 7C:7BAC | `Nav_TopMenu_Help` | label | CONFIRMED | entry 3: B=0 ; far call 6C:5987 (help); executed in the help scenario |
| 7C:7BB7 | `Nav_MailMenu` | function | CONFIRMED | far call 48:49DB (B!=0 aborts) then the mail-menu loop: 1D:4000 (menu screen) + dispatch through Nav_MailMenuJumpTable; called from Nav_TopMenu_Mail, executed in 23 scenarios |
| 7C:7BC0 | `Nav_MailMenuLoop` | label | CONFIRMED | loop head: far call 1D:4000 then call $0545; all handlers end with jp here |
| 7C:7BC9 | `Nav_MailMenuJumpTable` | table | CONFIRMED | inline table of the call $0545 at 7C:7BC6: 0 back, 1 send/receive, 2 write mail, 3 mailbox, 4 address book, 5 profile, 6 mail server |
| 7C:7BDA | `Nav_MailMenu_SendReceive` | label | CONFIRMED | entry 1 (おくる/うけとる): B=$15 C=$03 repeat timing; 27:41BC (outbox-empty test) != $FF, or 25:4A90 D != $0C -> far call 27:4000 (send/receive flow); mailbox-full dialog path (7C:7BFA) never run; run in mail_send/receive/timeout |
| 7C:7C7C | `Nav_MailMenu_WriteMail` | label | CONFIRMED | entry 2 (メールをかく): reads [$A000] in SRAM bank 0: 0 -> far call 2D:4000 (write-mail flow), else 2B:4000 with C=0 (saved-draft menu); executed in mail_compose |
| 7C:7CB0 | `Nav_MailMenu_Mailbox` | label | CONFIRMED | entry 3 (メールボックス): far call 25:4000 with [C264]=0; executed in mail_mailbox and mail_inbox |
| 7C:7CCD | `Nav_MailMenu_AddressBook` | label | CONFIRMED | entry 4 (アドレスちょう): far call 2F:7EBF; executed in mail_addressbook/addressbook_full |
| 7C:7CE2 | `Nav_MailMenu_Profile` | label | CONFIRMED | entry 5 (プロフィール): far call 2A:5495; executed in mail_profile |
| 7C:7CF6 | `Nav_MailMenu_MailServer` | label | CONFIRMED | entry 6 (メールサーバ): far call 23:4000, or 22:4000 when exactly SELECT+LEFT is held (xor $24 at 7C:7D06: hidden third button, scenarios mail_server_hidden / mail_server*) |
| 7C:7D1E | `Nav_MailMenu_Back` | label | CONFIRMED | entry 0 of Nav_MailMenuJumpTable: ret |
| 7C:7D1F | `Nav_TitleMobileSettings` | function | CONFIRMED | main-loop state 2 (1C:4028 far-calls it when the title screen returns 2 = モバイルせってい): clears [BF01] in SRAM bank 1 and [C28C], then the settings loop; executed in title_settings and settings_* |
| 7C:7D57 | `Nav_MobileSettingsLoop` | label | CONFIRMED | loop head: far call 68:4F9E (settings menu, 4 or 5 entries) then call $0545 through Nav_MobileSettingsJumpTable |
| 7C:7D60 | `Nav_MobileSettingsJumpTable` | table | CONFIRMED | inline table of the call $0545 at 7C:7D5D: 0 back, 1 password change, 2 usage time, 3 usage fee, 4 delete registration, 5 phone number (hidden entry) |
| 7C:7D6F | `Nav_MobileSettings_Back` | label | CONFIRMED | entry 0: ret (back to the title screen) |
| 7C:7D70 | `Nav_MobileSettings_ChangePassword` | label | CONFIRMED | entry 1: far call 67:58CD; first executed at frame 1809 of title_settings = macro step 1 パスワードのへんこう (change password, POST daa_gb_pwdchg.cgi) |
| 7C:7D79 | `Nav_MobileSettings_UsageTime` | label | CONFIRMED | entry 2: far call 67:60BA; first executed at frame 8507 of title_settings = step 2 ごりようじかんのかくにん (usage time, daa_gb_jikan.cgi) |
| 7C:7D82 | `Nav_MobileSettings_UsageFee` | label | CONFIRMED | entry 3: far call 67:626F; frame 14403 of title_settings = step 3 ごりようがくのかくにん (usage fee, /cgb/utility?request=summary) |
| 7C:7D8D | `Function_7C_7D8D` | function | HYPOTHESIS | unreferenced chain: far call 70:4000 then loops on 70:4023 with A pressed (three times, args 0/1/2) and jr Nav_MobileSettings_UsageFee; no caller, never executed |
| 7C:7DFF | `Nav_MobileSettings_DeleteRegistration` | label | CONFIRMED | entry 4: far call 68:7951; frame 20305 of title_settings = step 4 とうろくじょうほうのさくじょ (delete registration) |
| 7C:7E08 | `Nav_MobileSettings_PhoneNumber` | label | CONFIRMED | entry 5: far call 67:4000; reached only with B+SELECT+RIGHT held (hidden fifth menu entry), executed in settings_phone and monkey_camp_reg2 |

## 4. Bank 7D: joypad

`7D:7B7C` selects the direction keys (`rP1=$20`), reads the low nibble (2 reads) into bits 7-4, selects the buttons (`$10`, 6 reads), inverts, and deselects (`$30`).  Result B = pressed mask:
A=$01 B=$02 SELECT=$04 START=$08 RIGHT=$10 LEFT=$20 UP=$40 DOWN=$80 (the layout used by the hidden-input tests in dynamic_tracing.md 9.3).  `Joypad_UpdateUnsaved`
derives `hJoyPressed = (hJoyHeld xor new) and new`, stores `hJoyHeld`, and steps eight auto-repeat counters (`$C2E5+bit`): a released button reloads its counter with the
initial delay `[C2E1]`, a held one counts down and at 0 reloads `[C2E2]` and raises its bit in the repeat mask, giving `hJoyPressedRepeat = pressed | repeat`.  Every screen
picks its own timing with `Joypad_SetRepeatTiming` (B = delay, C = interval; e.g. `B=$15 C=$03` in all `Nav_*` handlers of bank 7C; `B=$14 C=$02` from `Joypad_Init`).
`hRam_FFA7` (button bits injected for `JoypadDispatch 00:056A`) is only cleared here (`Joypad_Init`).  RAM proposals: `wJoyRepeatDelay` C2E1, `wJoyRepeatInterval` C2E2, `wJoyRepeatCounters` C2E5 (8 bytes).

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 7D:4000 | `GlyphFont_Jis12x12_7D` | data | CONFIRMED | 12x12 kanji font, JIS rows 16-24 (9 x 94 glyphs x 18 bytes = $3B7C bytes, whole 4000-7B7B); GlyphFont_RowBankTable rows 16-24 -> 7D, first ku 16 |
| 7D:7B7C | `Joypad_ReadRaw` | function | CONFIRMED | reads rP1: select directions ($20) -> bits 7-4, select buttons ($10, 6 reads) -> bits 3-0, inverted, so B = pressed mask (A=$01 B=$02 SELECT=$04 START=$08 RIGHT=$10 LEFT=$20 UP=$40 DOWN=$80); deselects with $30 |
| 7D:7BA4 | `Joypad_UpdateIdleFrames` | function | CONFIRMED | resets wJoyIdleFrames when hJoyHeld != 0, else increments it saturating at $FF; 24 external callers (19:41A2 ...) |
| 7D:7BB7 | `Joypad_Update` | function | CONFIRMED | push bc/de/hl around Joypad_UpdateUnsaved; THE per-frame joypad poll, 139 external callers, executed in every scenario |
| 7D:7BC1 | `Joypad_UpdateUnsaved` | function | CONFIRMED | Joypad_ReadRaw, then hJoyPressed = (hJoyHeld xor new) and new; hJoyHeld = new; 8 auto-repeat counters at $C2E5 (released: reload wJoyRepeatDelay; at 0: reload wJoyRepeatInterval, flag) -> hJoyPressedRepeat |
| 7D:7BF0 | `Joypad_Init` | function | CONFIRMED | clears hJoyHeld, hJoyPressed, hRam_FFA7, hJoyPressedRepeat and wJoyIdleFrames, then B=$14 C=$02 falls into Joypad_SetRepeatTiming; called from 4F:478D/47F6 (second-stage init) |
| 7D:7C00 | `Joypad_SetRepeatTiming` | function | CONFIRMED | B = initial auto-repeat delay -> [C2E1] and all 8 counters $C2E5-$C2EC, C = repeat interval -> [C2E2]; 52 callers set it per screen (e.g. B=$15 C=$03 in Nav_MailMenu_*) |

## 5. Bank 7E: charset conversion

The mail code (bank 54) and the browser (banks 4C, 67) hold text in Shift-JIS; the mail protocol and many web pages use other encodings.  Bank 7E converts:

* **Encode** `Charset_SjisToIso2022Jp` (7C34, executed in mail_send): `ESC $ B` before a run of double-byte characters, `ESC ( B` before ASCII, pairs converted by `Charset_SjisToJis`.
* **Decode** `Charset_Iso2022JpToSjis` (7D62, executed in mail_receive): a five-state machine (table `Charset_Iso2022JpStates` 7D8F indexed by `[FFB1]`: ASCII, kanji pair, after ESC, after `ESC (`, after `ESC $`).
* **Web pages** `Charset_ConvertPage` (7D19): in-place normaliser of a `[len16][text]` buffer (`4C:455E` passes `$B000` of SRAM bank 3, `BC=$1000`; also `67:5C67`, the CGI-answer path,
  executed in settings_cgi): with `[C2C3]==1` (`wCommSessionKind` = settings CGI page session, named by another pass; only this case was ever observed running the detector) it asks `Charset_DetectEncoding` (first byte `$80-$A0` = Shift-JIS, an ISO-2022-JP escape = JIS, otherwise EUC-JP fallback), otherwise
  it assumes ISO-2022-JP; JIS pages are decoded (the new length is stored back into the `[len16]` header at `sSram_B000/B001`), EUC-JP goes through `Charset_EucJpToSjisStream` (bytes >= `$A1`
  in pairs, high bits cleared then `Charset_JisToSjis`).  Never observed executing for a real EUC-JP pair (PROBABLE).
* The JIS/Shift-JIS arithmetic of `Charset_JisToSjis`/`Charset_SjisToJis` is the textbook one (`$2422 <-> $82A0`, checked by hand on both routines).

The decoder accepts `ESC $ B` and `ESC $ J`/`ESC ( B`/`ESC ( J` in its states 3/4 whereas the detector also accepts `ESC $ @`; not needed for the traced mails.

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 7E:4000 | `GlyphFont_Jis12x12_7E` | data | CONFIRMED | 12x12 font, JIS rows 1-8 and 13 (9 x 94 glyphs x 18 bytes = $3B7C bytes, whole 4000-7B7B); GlyphFont_RowBankTable rows 1-8 -> 7E (first ku 1), row 13 -> 7E slot 9 (first 5); 7E ku4/ten2 renders hiragana A |
| 7E:7B7C | `Charset_JisToSjis` | function | CONFIRMED | B,C = JIS X 0208 row/column bytes ($21-$7E) -> B,C = Shift-JIS lead/trail ($2422 -> $82A0); standard JIS->SJIS arithmetic; executed in mail_receive/mail_errors (ISO-2022-JP decoding) via 7E:7DBE |
| 7E:7BA3 | `Charset_SjisToJis` | function | CONFIRMED | HL = Shift-JIS lead/trail -> HL = JIS X 0208 bytes ($82A0 -> $2422), A=0; used by the encoder Charset_SjisToIso2022Jp (7E:7CCB); executed in mail_send |
| 7E:7BD6 | `Charset_EucJpToSjis` | function | PROBABLE | clears bit7 of B and C (EUC-JP -> JIS) then Charset_JisToSjis; only caller is Charset_EucJpToSjisStream (7E:7E89), never executed with a double-byte |
| 7E:7BDE | `Charset_DetectEncoding` | function | CONFIRMED | HL=text, BC=length: scans for the first byte $80-$A0 (Shift-JIS lead: A=1), an ISO-2022-JP escape ESC $ B/@ or ESC ( B/J (A=2), else end/NUL (A=3); bytes >= $A1 are skipped; executed in settings_cgi |
| 7E:7C2A | `Charset_ReadByteCounted` | function | PROBABLE | A = [HL+] with BC decremented; returns A=0 without reading when BC==0; helper of Charset_DetectEncoding (3 call sites) |
| 7E:7C34 | `Charset_SjisToIso2022Jp` | function | CONFIRMED | HL=Shift-JIS text (NUL end), DE=dest, BC=dest capacity: emits ESC $ B before double-byte runs, ESC ( B before ASCII (pairs via Charset_SjisToJis); returns BC = bytes written; callers 54:45E4 ..., executed in mail_send |
| 7E:7D19 | `Charset_ConvertPage` | function | PROBABLE | in-place normaliser of a [len16][text] buffer ($B000, SRAM bank 3; 4C:455E, 67): [C2C3]==1 (settings CGI session) -> Charset_DetectEncoding: SJIS kept, ISO-2022-JP decoded, else EUC-JP; else ISO-2022-JP decode; browser, settings_cgi |
| 7E:7D62 | `Charset_Iso2022JpToSjis` | function | CONFIRMED | HL=ISO-2022-JP text (NUL end), DE=dest, BC=dest capacity: state machine (Charset_Iso2022JpStates), pairs via Charset_JisToSjis; returns BC = bytes written; callers 54:4A73 ..., executed in mail_receive |
| 7E:7D8F | `Charset_Iso2022JpStates` | table | CONFIRMED | 5-word jump table of the state machine (dispatcher 7E:7D7B-7D8E, index [FFB1]): 0 ASCII (7D99), 1 kanji pair (7DB0), 2 after ESC (7DE5), 3 after ESC ( (7E05), 4 after ESC $ (7E1E); executed |
| 7E:7E68 | `Charset_EucJpToSjisStream` | function | PROBABLE | HL=source, DE=dest, BC=dest capacity: copies bytes < $A1 (and $FF), converts bytes >= $A1 in pairs with Charset_EucJpToSjis; returns BC from [sSram_B000]; only reached for plain bytes in settings_cgi |

## 6. Bank 7F

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

* **Font ROM.**  The 12x12 glyphs are 1bpp, 18 bytes per glyph (two 12-bit rows per 3 bytes), 94 glyphs per JIS row (ku), nine rows per bank, `$3B7C` bytes per bank.
  `GlyphFont_RowBankTable` (7F:40F9, 87 bytes) and `GlyphFont_RowFirstTable` (7F:4150) map a ku to its bank:

  | ku (JIS row) | bank | first ku of the bank |
  |---|---|---|
  | 1-8, 13 | 7E | 1 (row 13 is the 9th slot, first=5) |
  | 9-12, 14, 15 | none ($FF) | - |
  | 16-24 | 7D | 16 |
  | 25-33 | 7C | 25 |
  | 34-42, 43-51, 52-60, 61-69, 70-78 | 7B, 7A, 79, 78, 77 | 34, 43, 52, 61, 70 |
  | 79-87 | 76 | 79 (rows 85-87 hold no JIS characters; the 6x12 **ASCII font** lives in that space at `76:67A8`, 96 glyphs x 12 bytes = `$67A8-$6C27`) |

  Glyph address = `$4000 + ((ku - first)*94 + ten - 1) * 18`.  Verified by rendering: ku 4/ten 2 in 7E is hiragana A, ku 13/ten 1 in 7E is the circled digit one (NEC row 13), ku 25/ten 1 (7C) and ku 79/ten 1 (76) are kanji, and 76:67A8+$21*12 is the letter A.
  The bytes of the other font banks (77-7B) belong to other passes; the rule is the same.
* **Buffers.**  `$C0A0` (24 bytes) and `$C0B8` (24 bytes) hold the left and right 6-pixel halves (12 rows x 2 plane bytes, both planes equal at this stage); a wide character is drawn as two 6-px blits, the engine advances `hTextX` by 6 per half
  (00:1079-10A3).  ASCII uses only `$C0A0`.
* **Canvas.**  `Canvas_BlitGlyphNoRemap` writes into a linear 2bpp tile image in WRAM bank 2 (`$D000`, 20 tiles = `$140` bytes per tile row, 16 bytes per tile, 2 bytes per pixel row); after tile row 12 (`H >= $DF`) the address wraps into WRAM bank 3 at `$D000`.  With `c = x & 7` the AND masks
  `Canvas_BlitMaskCur[c]` / `Canvas_BlitMaskNext[c]` (`03 81 C0 E0 F0 F8 FC FE FF` / `FF FF FF 7F 3F 1F 0F 07 03`) keep the pixels around the 6-px window in the tile the glyph starts in and in its right neighbour; the shifted glyph byte is OR-ed in.
  The result is a 20x18-tile (160x144) picture that callers upload with HDMA (`Canvas_UploadToVram`: bank 2 `$D000/$D400/$D800` -> VRAM bank 0 `$9000/$9400/$8800`, 64/64/112 tiles; bank 3 `$D000` -> VRAM bank 1 `$9000`, 120 tiles).
* **Colours.**  `Canvas_RemapGlyphColors` takes two 2-bit selectors in B and C (text engine: `hRam_FFBA`, `hRam_FFBB`; note the parser of bank 74 reuses those HRAM bytes for other things) and jumps through `Canvas_RemapTable[B + 4*C]`; the 16 handlers rewrite the 12 plane-byte pairs in place
  (index 0 and 3: unchanged, 1: only plane 0, 2: only plane 1, 4-15: additionally fill the 6-px cell with the background colour).  Only four handlers were checked one by one; the full colour meaning (which of B/C is foreground) is PROBABLE.
* **Other users of the pipeline.**  `Glyph_LoadDottedLine` (4C42) copies the 32-byte pattern `Glyph_DottedLineData` (one dotted pixel row at the bottom of a single 6-px cell; the 32-byte copy also spills 8 zero bytes into the start of `$C0B8`) to `$C0A0`; six callers in banks 2A/2C/2D/2F blit it repeatedly with a 6-px step (e.g. 2A:5A0F/5A23; purpose - empty character slots of input fields - is PROBABLE).

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 7F:4000 | `Function_7F_4000` | function | HYPOTHESIS | twin of Glyph_LoadAscii ending in 00:0DCE (12 bytes written once, no plane duplication) instead of 00:0DB9; no caller found |
| 7F:4007 | `Glyph_LoadAscii` | function | CONFIRMED | B=char, DE=dest buffer: Glyph_AsciiAddr then 00:0DB9 copies the 12 font rows doubled to 24 bytes (2 planes) into DE; 88 external callers (00:10C0 ...), executed in 28 scenarios |
| 7F:400E | `Glyph_AsciiAddr` | function | CONFIRMED | B=char ($20-$7F, else '?'): DE = $67A8 + 12*(char-$20) in ROM bank $76 (A=$76, C=$7F = bank to restore), HL = caller's DE; the 6x12 ASCII font sits in bank 76 after JIS rows 79-84 ('A' rendered from 76:67A8+$21*12) |
| 7F:4042 | `Function_7F_4042` | function | HYPOTHESIS | variant of Glyph_LoadWide that unpacks through 00:0E32 (single planes, dest DE and DE+12); no caller or table entry found |
| 7F:405F | `Glyph_LoadWide` | function | CONFIRMED | HL=Shift-JIS code, BC/DE=two 24-byte buffers ($C0A0/$C0B8 from 00:1044): far call 63:4000 (SJIS validity bitmap, invalid -> $81A1), Glyph_SjisToJis, Glyph_JisToKuTen, Glyph_KuTenAddr, 00:0DE2 unpacks the glyph into 6-px halves; 34 callers |
| 7F:4072 | `Glyph_SjisToJis` | function | CONFIRMED | HL=Shift-JIS (H lead, L trail) -> HL=JIS X 0208 code (e.g. $82A0 -> $2422); standard Shift-JIS to JIS row/column arithmetic, executed in 32 scenarios |
| 7F:40B0 | `Glyph_JisToKuTen` | function | CONFIRMED | HL: subtracts $20 from both bytes: JIS code -> (ku,ten) row/column numbers (e.g. $2422 -> ku 4, ten 2 = hiragana A) |
| 7F:40B9 | `Glyph_KuTenAddr` | function | CONFIRMED | H=ku (1-based), L=ten: A = ROM bank from GlyphFont_RowBankTable[ku-1], DE = $4000 + ((ku - first row of that bank)*94 + ten-1)*18 via Glyph_Mul16; BC/HL come back swapped (BC=old DE, HL=old BC) |
| 7F:40F9 | `GlyphFont_RowBankTable` | data | CONFIRMED | 87 bytes: ROM bank holding JIS row ku (index ku-1): rows 1-8,13 -> 7E; 16-24 -> 7D; 25-33 -> 7C; 34-42 -> 7B; 43-51 -> 7A; 52-60 -> 79; 61-69 -> 78; 70-78 -> 77; 79-87 -> 76; $FF = none; decoded and read at 7F:40BD (ld hl,$40F9) |
| 7F:4150 | `GlyphFont_RowFirstTable` | data | CONFIRMED | 87 bytes: first ku stored in the bank of row ku (1 for 7E rows 1-8 and 5 for row 13 = 9th slot, 16, 25, ..., 79); glyph slot = ku - this value, read at 7F:40CA (ld hl,$4150) |
| 7F:41A7 | `Glyph_IsSjisLeadByte` | function | CONFIRMED | A=byte: A=1/carry set for Shift-JIS lead bytes $81-$9F, $E0-$EF, $F8-$F9 else A=0/carry clear (same ranges as the text engine tests at 00:0F30/1028); executed in 13 scenarios |
| 7F:41D0 | `Glyph_Mul16` | function | CONFIRMED | HL = BC * DE (16-bit shift-add), AF/BC/DE preserved; only used by Glyph_KuTenAddr (7F:40DF, 40EC) |
| 7F:41EA | `Canvas_RemapGlyphColors` | function | PROBABLE | B,C in 0-3 (hRam_FFBA/FFBB in the text engine): jumps through Canvas_RemapTable[B+4*C]; the 16 handlers rewrite the 12 plane-byte pairs at HL in place (identity, clear plane 0 or 1, fill the 6-px cell) |
| 7F:42A3 | `Canvas_RemapTable` | table | PROBABLE | 16 code pointers indexed B+4*C by Canvas_RemapGlyphColors (sla c x3 ; sla b ; add ; targets 4202..42A1, each starts with pop hl); read at 7F:41F8 |
| 7F:42C3 | `Canvas_BlitGlyph` | function | CONFIRMED | HL=24-byte 6x12 glyph (2 planes), D=y, E=x in pixels, B/C colours: Canvas_RemapGlyphColors then Canvas_BlitGlyphNoRemap; 90 external callers (00:1073/109D/10D5 ...), 33 scenarios |
| 7F:42CA | `Canvas_BlitGlyphNoRemap` | function | CONFIRMED | draws the 24 glyph bytes at pixel (E,D) into the 2bpp tile canvas in WRAM bank 2 (bank 3 after tile row 12): tile row=y>>3 x $140, col=(x>>3)*16; Canvas_BlitMaskCur/Next merge the shifted bits; also called directly by 2A:5A2D, 2C:43F6 ... |
| 7F:499C | `Canvas_BlitMaskCur` | data | PROBABLE | 9 bytes 03 81 C0 E0 F0 F8 FC FE FF indexed by x&7: bits of the current tile byte KEPT around the 6-px glyph, copied to [C0D0] at 7F:4311-4316 (ld hl,$499C) |
| 7F:49A5 | `Canvas_BlitMaskNext` | data | PROBABLE | 9 bytes FF FF FF 7F 3F 1F 0F 07 03 indexed by x&7: bits kept in the next tile (glyph spill over the 8-px tile edge), copied to [C0D1] at 7F:4319-431E |
| 7F:49AE | `Function_7F_49AE` | function | HYPOTHESIS | clone of Canvas_BlitGlyph (push hl ; push de ; call 41EA ...) 49AE-4AAE; unreferenced |
| 7F:4AAF | `Function_7F_4AAF` | function | HYPOTHESIS | second clone of Canvas_BlitGlyph that also clips glyphs whose y >= $F0 (negative y, first rows skipped); unreferenced |
| 7F:4BBC | `Canvas_UploadToVram` | function | PROBABLE | general-DMA copy of the WRAM canvas to VRAM: bank 2 $D000/$D400 -> $9000/$9400 (64 tiles each), $D800 -> $8800 (112), then bank 3 $D000 -> VRAM bank 1 $9000 (120); callers only in the unreferenced 7F:4C78 demo |
| 7F:4C20 | `Gfx_GdmaAtVBlank` | function | PROBABLE | HL=src, DE=dst, C=(blocks-1): programs rHDMA1-4, waits LY=$8F then $91 with interrupts off, writes rHDMA5 (bit7=0, general DMA), ei; twin of Gfx_GdmaAtVBlankNoDi |
| 7F:4C42 | `Glyph_LoadDottedLine` | function | CONFIRMED | copies the 32 bytes at Glyph_DottedLineData to $C0A0 (glyph buffer); 6 external callers in banks 2A/2C/2D/2F blit it as a 6-px cell (Canvas_BlitGlyph/NoRemap, x += 6); executed in 12 scenarios |
| 7F:4C57 | `Glyph_DottedLineData` | data | CONFIRMED | 32 bytes, all 00 except row 11 (bytes 22-23) = 33 CC (dotted line in one 6-px cell, plane pairs); read as data by the 7F:4C4D copy loop (executed) |
| 7F:4C78 | `Function_7F_4C78` | function | HYPOTHESIS | unreferenced text-canvas demo: 00:09B6, 4CA9 (init), 4E85, 4D95 (12 lines of the sample string), wait A, 4E0D (inverted colours), B returns; strings 'Sample DATA.' and the sample-data sentence |

### 6.2 Unreferenced prototype (`7F:4C78-61E8`, about 6 KB)

No instruction of this range is executed in any of the 41 scenarios (`analysis/coverage_union.tsv`), no far call, `call`, `jp` or pointer word anywhere in the ROM names an entry inside it (the far-call census of
`analysis/farcall_targets.tsv` and a scan for far pointers `lo hi 7F` gave no hit on a function entry), and the ROM0 library never reaches it.  What it contains (all HYPOTHESIS as a whole):

* `4C78`: a **text-canvas demo**: `Canvas_InitScreen` (4CA9: LCD off, tile RAM `$8800-$97FF` cleared in both VRAM banks, identity BG map of 20x18 tiles, canvas banks 2/3 zeroed, BG palette from `7F:4D50`), 12 lines of the sentence `サンプルデータですからね～` ("it is only sample data"; 4D95 with colours B=3,C=0, then 4E0D with B=0,C=3), waiting for A / returning on B; and the string `Sample DATA.` printed glyph by glyph (4D58).
* `4E89`/`4EF0`: two pointer tables with **six sample page names and six URLs** (Nintendo homepage / nintendo.com, ポケットモンスター / pokemon.co.jp, GAMEFREAK HOME / gamefreek.net, MissingLink_HOME / missinglink.co.jp, sample / sample.to, sample2 / sample2.to) plus leftovers `テストページ`, `htpp://work.dammy.co.jp/` (sic) and `鋼ポケモンに進化`.
  The names mention Game Freak and a company `MissingLink` (missinglink.co.jp); the tables are not loaded by any code.
* `4FC3` / `4FCF` (`PageListProto_UrlSlotTable`, `PageListProto_TitleSlotTable`): SRAM address tables `A084 + n*$100` and `A000 + n*$16` (n = 0-5) read at 14 sites: the record layout of the six-entry page list in SRAM bank 1 (`A000-A683`, sram_layout.md), so this code is a **prototype of the page list (bookmark) screen**; the released screen is `PageList_*` in bank 24 (`24:4000/400C` are the same two tables; a title slot of `$16` bytes matches the 19+3-byte title limit of `Html_StoreTitle`).
  The prototype draws with `Glyph_*`/`Canvas_*`, uses `Stat_EnableScrollSplit`, sprites from `7F:6DB0/7B40`, tiles from `62B0-66B0/6AE0-6D70`, a 20x18 tilemap `67D0` and palettes `6AA0/6D70/7B00`, calls dialog helpers `72:402A/461A/444F/4015` and `51:4000`; its
  clock code (`59BA-5A11`) compares `[C2D6]`/`[C2D5]` against `[C26E]`/`$1E`, the same online-time warning logic as the released connection code.
* Timer A reset `61E8`, `Function_7F_61E6/61E7` (single `ret`), `6218`/`6235` (wrappers around the confirmation dialog `50:4000`, called from 23/26/2E but never executed).

None of this was named beyond `Canvas_*`, `Sample_*` and generic HYPOTHESIS rows.

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 7F:4CA9 | `Canvas_InitScreen` | function | PROBABLE | LCD off if on, clears VRAM $8800-$97FF in both banks, writes an identity BG map ($9800, 20x18 tile ids 0-$EF), attribute map (bank-1 tiles from row 12), zeroes canvas banks 2/3, loads BG palette 0 from 7F:4D50; only caller is 7F:4C7E |
| 7F:4D95 | `Function_7F_4D95` | function | HYPOTHESIS | draws the sample sentence (7F:4DF2, 'sample data, you know~') on 12 rows, glyph pairs via Glyph_LoadWide + Canvas_BlitGlyph with colours B=3,C=0, then Canvas_UploadToVram; unreferenced |
| 7F:4E0D | `Function_7F_4E0D` | function | HYPOTHESIS | same as 4D95 with colours B=0,C=3 (inverted); unreferenced |
| 7F:4E89 | `Sample_PageNamePtrs` | table | PROBABLE | 6 pointers to sample page titles 7F:4E95.. (Nintendo homepage, Pokemon..., GAMEFREAK HOME, MissingLink_HOME, sample, sample2); paired 1:1 with Sample_PageUrlPtrs; six = slots of the page list (bank 24 PageList_*); no code loads it |
| 7F:4EF0 | `Sample_PageUrlPtrs` | table | PROBABLE | 6 pointers to sample URLs (nintendo.com, pokemon.co.jp, gamefreek.net, missinglink.co.jp, sample.to, sample2.to) matching Sample_PageNamePtrs; no code loads it |
| 7F:4FC3 | `PageListProto_UrlSlotTable` | table | PROBABLE | 6 words = SRAM bank 1 $A084+n*$100 (URL slots), the table of 24:4000 PageList_UrlSlotTable; read only by the unreferenced prototype (ld hl,$4FC3 at 7F:5386 5485 565D 5D3C 5F8F 5FD1 61C7) |
| 7F:4FCF | `PageListProto_TitleSlotTable` | table | PROBABLE | 6 words = SRAM bank 1 $A000+n*$16 (title slots, 22 bytes), the table of 24:400C PageList_TitleSlotTable; read only by the unreferenced prototype (ld hl,$4FCF at 7F:5709 5731 579A 57C2 5F2E 5F87 61B5) |
| 7F:4FDB | `Function_7F_4FDB` | function | HYPOTHESIS | head of the unreferenced page-list prototype: stores D724=$0B, D725=0 in WRAM bank 1, then far-calls Stat_EnableScrollSplit; the code up to 7F:61E8 (SRAM slot tables 4FC3/4FCF) is never executed |
| 7F:5011 | `Function_7F_5011` | function | HYPOTHESIS | prototype screen loop: far calls 72:402A/461A/444F, 4F:4370, 51:4000 and 7271/72B0; reached only from 7F:5112/51EA inside the unreferenced region |
| 7F:5805 | `Function_7F_5805` | function | HYPOTHESIS | draws a string of up to $14 characters: Glyph_IsSjisLeadByte, Glyph_LoadWide or Glyph_LoadAscii, Canvas_BlitGlyph per glyph (7F:5816-5896); only callers are inside the unreferenced region |
| 7F:61E6 | `Function_7F_61E6` | function | HYPOTHESIS | single ret; called as `call nz` at 7F:5ADB in the unreferenced region |
| 7F:61E7 | `Function_7F_61E7` | function | HYPOTHESIS | single ret; called at 7F:598C in the unreferenced region; followed by the dead routine 61E8 that zeroes timer A (C2D4-C2D7) |
| 7F:61FC | `Stub_Nop_7F_61FC` | function | CONFIRMED | push af ; pop af ; ret (does nothing); farcalled once from 27:42DB and called by Function_7F_6235; executed in 15 scenarios, so callers treat it as a placeholder hook |
| 7F:61FF | `Timer_ResetClockB` | function | PROBABLE | zeroes wTimerBFrames ($C266), $C267 and $C268 = the frame/second/minute clock Int_VBlank advances when [wTimerEnable] bit0 is set (00:03D0-0404); 29 external callers in banks 23/26/..., executed in 15 scenarios |

### 6.3 Clocks, sprite slots, dialogs

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 7F:6218 | `Function_7F_6218` | function | HYPOTHESIS | res 0,[C26F] ; C1D0=1 ; C1D1=0 ; far call 50:4000 (dialog routine that reads C1D0/C1D1) ; returns A=0 if it returned 0 else $FF; 10 callers in banks 23/26 but never executed |
| 7F:6235 | `Function_7F_6235` | function | HYPOTHESIS | like 6218 with C1D0=0 ; always returns $FF (after the no-op Stub_Nop_7F_61FC); callers 23:51AF, 23:5525, 2E:4970; never executed |
| 7F:624F | `Sprites_SaveSlotsToBank3` | function | PROBABLE | copies 256 bytes from WRAM bank 7 $DA00 (wSpriteSlots, 14 x 16 bytes + 32) to WRAM bank 3 $D900, restores rSVBK; pair of Sprites_RestoreSlotsFromBank3; executed in 7 scenarios (mail_compose/inbox ...) |
| 7F:627C | `Sprites_RestoreSlotsFromBank3` | function | PROBABLE | inverse of Sprites_SaveSlotsToBank3: 256 bytes WRAM bank 3 $D900 -> bank 7 $DA00 (wSpriteSlots); 16 external callers, executed in 7 scenarios |

### 6.4 Split-screen scrolling and keyboard slide helpers

`Stat_EnableScrollSplit` (7271) writes `jp $0E93` into the RAM STAT vector (`wLcdStatVector`, CBF4), waits for LY = $64, programs `rSTAT=$44`, `rLYC=0`, zeroes `[C0D3]` and enables STAT with VBlank in `IE`.
The handler `00:0E93` then, at LY 0, loads LYC from `[D724]` and sets SCY 0 (fixed top part of the screen, D724 lines high: screens use $0B, $10 or $15), and at that line sets SCY = `[C0D3]` for the rest (optionally calling the frame service when `[D824]` is set).
The two other passes that touched these bytes agree (ram_g4: `wSplitScrollY` C0D3, `wStatSplitLine` D724, `wStatIrqServiceFlag` D824).  `Stat_DisableScrollSplit` (72B0) restores `reti` in CBF4 and clears the STAT enable; it has 139 external callers, `Stat_EnableScrollSplit` 74.

The four `ScrollSplit_Step*` functions are table-driven per-frame steps: `b = Table[D][E]`, `[C0D3] += b` (up) or `-= b` (down), and the Y bytes of sprite slots 1, 2, 4 (`Step*3`) or 1-4 (`Step*4`) at `wSpriteSlots+16/32/48/64` are moved the opposite way, `E++`.  In bank 55 (on-screen keyboard, classify_g2.md) they are driven by two loops that move the
window (`rWY`) 8 px per frame: `55:6318` slide-in (`WY` falls until it equals `[641C+[C2AB]]` = $28 or $38) and `55:6427` slide-out (`WY` rises to $90).  Keyboard modes `[C2AB]` = 6, 7, 8, 9 each have a prepare hook (returns the table row D and start step E) and a step hook per direction;
those 16 wrappers are the `KbdSlide_*` rows (`In`/`Out` = slide-in/out loop, `Mode6-9` = value of `[C2AB]`).  What the four modes are (which keyboard/edit layout) was not determined (HYPOTHESIS).

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

## 7. Bank 74: the HTML page pipeline

### 7.1 Pipeline

1. The browser (banks 4C/4E) downloads a page into SRAM bank 3 `$B000` as a resource record `[size16][data]`; images appended later are records `[size16][name NUL][BMP data]` (`Html_NextResourceRecord` walks them: `DE = HL + 2 + size`).
2. `Charset_ConvertPage` (bank 7E) turns the page into Shift-JIS in place (`4C:455E`).
3. `Html_ScanPage` (74:4254; 4C:4564 and 4C:5181): pass 1 with `[C335]=$FF` (the layout helpers return at once).  What the caller uses is `<html>` (bit0 of `[C2C1]`, tested at `4C:456A/5187`) and the `<img src=>` URLs, which are queued in a list in WRAM bank 4 (`$DE00`), which `4C:4840` fetches, resolving each with `HtmlUrl_Resolve` (base URL at bank 4 `$DD00`) and `HtmlUrl_NormalizePath` and appending the BMP as a new resource record.
4. `Html_ParsePage` (74:4207; 10 scenarios, also the CGI answers of settings_cgi): `[C335]=0`; output text buffer WRAM bank 5 `$D000`, page header + record table in WRAM bank 4 `$D000` (`hRam_FFB8-BA`, mirrored to `hRam_FFED-EF` for the viewer), source SRAM bank 3 `$B000`, viewport 144 x 96 px
   (`4E:5423/5435` with (0,0) and ($90,$60)).  `Html_ParseSource` builds the text stream and the line records, `Html_LoadPageImages` decodes every image record through the BMP loader `51:7177`, `Html_MetaResultToError` turns a `<meta r_code="ng" d_code="....">` into the error screen inputs.
5. The viewer (`4E:544A` and friends) scrolls through the records (`hViewScrollMax` = page height - 96) and draws them.

### 7.2 Tag dispatch (`Html_TagHandlerTable` 74:44A0, indexed by the tag id of `Html_TagNames`)

`Html_ParseSource_Tag` skips `'<'` and an optional `'/'` (kept in `hRam_FFB4`), writes a NUL into the output to end the pending text run, and looks the name up with `00:10E9` over `Html_TagPtrs`.  `00:10E9` compares case-insensitively and
returns the value byte of the **first entry whose name is a prefix** of the text; `Html_DispatchTag` then requires the next source byte to be `>` or below `$21`.

| id | tag | handler | traced in | in the served test pages |
|---|---|---|---|---|
| 0 | (unknown tag) | `Label_74_4439` skips the attributes with `00:1119` and an empty keyword list (`Html_NoKeywords`) | all | - |
| 1 | html | `Html_Tag_Html` | 9 scenarios | every page |
| 2 | title | `Html_Tag_Title` (+ `Html_StoreTitle`) | 9 | every page |
| 3 | head | `Html_Tag_Head` | 5 | every page |
| 4 | body | `Html_Tag_Body` | **never** | every page (see below) |
| 5 | center | `Html_Tag_Center` | 5 | b, big, a, d, index |
| 6 | div | `Html_Tag_Div` | browser_pages, monkey rich | a, d |
| 7 | br | `Html_Tag_Br` | 9 | 99 tags |
| 8 | hr | `Html_Tag_Hr` | 9 | 12 tags |
| 9 | img | `Html_Tag_Img` | browser_pages only | a, b, c, big (`web=all` only) |
| $0A | a | `Html_Tag_A` | 9 | 33 tags |
| $0B | b | `Html_Tag_B` | 9 | 92 tags |
| $0C | ul | `Html_Tag_Ul` | 5 (homepage: index has ul) | a, c, index |
| $0D | ol | `Html_Tag_Ol` | browser_pages, monkey rich | a only |
| $0E | li | `Html_Tag_Li` | 5 | 22 tags |
| $0F | ! | `Html_Tag_Comment` | 3 | a only |
| $10 | meta | `Html_Tag_Meta` | 3 | a only |
| $11 | pre | `Html_Tag_Pre` | browser_pages only | a only |

The correlation of "handler executed" with "tag present in the pages served by scenario" (`traces/web/*.html`, `traces/web/README.txt`) is one-to-one for every tag, which is what turns the tag names into CONFIRMED names.
The single exception is **`<body>`**: `Html_TagPtrs` lists `b` before `body` (and `br` before `b`); since `00:10E9` returns the first prefix match and `Html_DispatchTag` then sees `o` after `b` and rejects the tag, `<body>` (and
`<blink>`, `<big>`, ... would be as well) is treated like an unknown tag; `Html_Tag_Body` is dead, bit2 of `[C2C1]` never set.  (PROBABLE: static reasoning plus 0 executions with 7 pages containing `<body>`.)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 74:4481 | `Html_DispatchTag` | label | CONFIRMED | tag id -> handler: add a,a; add a,$A0; ... push bc; ret through Html_TagHandlerTable; id $0F ('!') dispatches at once, other tags need '>' or whitespace after the name (74:448F) |
| 74:44A0 | `Html_TagHandlerTable` | table | CONFIRMED | 18-word jump table indexed by the tag id of Html_TagNames (0 = unknown tag, 1 html ... $11 pre); dispatcher 74:4490-449F executed in homepage/browser scenarios |
| 74:44C4 | `Html_Tag_Title` | function | CONFIRMED | handler of tag id 2 'title': on open records the output pointer DE in hRam_FFB6/FFB7 (start of the title text); on '</' does nothing (Html_StoreTitle is called from 74:44E5) |
| 74:45D9 | `Html_Tag_Comment` | function | CONFIRMED | handler of tag id $0F '!': skips '<!-- ... -->' (looks for '--' then '>' with the frame service called in the loop 74:4609); other '!' tags end at '>' |
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

### 7.3 Data structures (all layouts derived from the code, PROBABLE unless stated)

* **Output text stream** (WRAM bank 5 `$D000-$DFFF`, filled through `DE`, guarded by `cp $E0` on the high byte): the visible text with NUL separators written when a tag ends a run; SJIS pairs copied as two bytes; runs of white space collapsed to one `$20` unless inside `<pre>`;
  entities replaced through `Html_EntityNames`; `<hr>` emits SJIS codes `$83DB-$83E6` (repeated `$83E6` plus one code of that range for the remainder; rendered from the font: ku 6/ten 72 (`$83E6`) is a full 12-px horizontal line at pixel row 6 and ten 61-71 (`$83DB-$83E5`) are lines of 1-11 px, so they are private rule glyphs), list bullets `$8145` (`Html_ListBullet`) or decimal digits + `.`.
* **Page header** (WRAM bank 4 `$D000`): `+$00..$14` page title (max 19 bytes + `$8163` '...' + NUL, `Html_StoreTitle`), `+$15/$16` number of records, `+$20...` 16-byte records up to page `$E0`.
* **Layout record** (16 bytes, written by `Html_Layout_AppendRecord`, placed by `Html_Layout_PlaceLine`): `+0` x (word), `+2` y (word), `+4` width, `+6` height (initially 12), `+8` kind (`hRam_FFB0`: 1 text run, 4 image, 5 image already decoded by `Html_LoadPageImages`),
  `+9` flags (bit7 = not yet placed, bits0-1 style 1 link / 2 bold, bits2-3 alignment, bits4-5 vertical alignment), `+$A` link number, `+$B/$C` data pointer (text run in the text buffer, or the image resource record), `+$D` bank (5 text, 3 SRAM images), `+$E` link heap position.  Field meaning inferred from
  `74:5548`, `537D`, `5663`, `55BE` and the viewer `4E:547D-54F0`; HYPOTHESIS for +A/+E.
* **Link table** (WRAM bank 6): `wHtmlLinkPtrList` `$D600` (zero-terminated list of pointers), strings on the heap `$D800-$DFFD` through `[C336/C337]`; each entry is a tag byte (`/` = href, `#` = name anchor) followed by the text; `Html_StringTable_Find/Add` keep them unique
  (max 256 entries, heap end `$DFFE`); hrefs whose scheme has value `$FF` in `HtmlUrl_SchemeNames` (everything but http) are dropped, relative ones (value 0) and http ones are kept.
* **Stacks in WRAM bank 6**: alignment stack `$D000 + [C33D]` (saved `[C33C]`), list stack `$D100 + 2*[C33E]` (saved `[C33A/C33B]` plus a flag byte: bit7 = ul, bit6 = two-digit ol).
* **Meta values** (`Html_Tag_Meta`, only inside `<head>`, bit1 of `[C2C1]`): `$D300` ppp_id, `$D340` r_code, `$D380` d_code (64 bytes each).  Only `r_code="ng"` matters: `Html_MetaResultToError` parses `d_code` as hex and sets `C2CA=4`, `C1DD=$40`, `C1DE/C1DF` = low 16 bits; `4C:401D/404D` copy them to `C272-C274` (the number fields of the online-error screen; PROBABLE that this is the `40-????` error of dynamic_tracing.md 9.3 item 5).
* **State bytes.**  `[C2C1]` bit0 html seen, bit1 in head, bit2 in body (dead), bit3 in pre; `[C330]` br clear mode; `[C331/C332]` list marker pointer (`Html_Tag_Li` stores `C331` **twice**, the high byte at `C332` is never written: an original bug that makes the optimisation in `Function_74_4F97` a no-op);
  `[C335]` scan-only; `[C336/C337]` link heap pointer; `[C338/C339]` open `<b>` count; `[C33A/C33B]` list counter ($3F00 = bullet, capped at 99); `[C33C]` alignment; `[C33D]` align stack pointer; `[C33E]` list depth.  Bank 51 (BMP loader) reuses `C330-C33F` as scratch.
* **HRAM.**  `FFB0/FFB1` retry pointer of `00:10E9`; `FFB2` style bits; `FFB3` last output char; `FFB4` first char after `<`; `FFB5` source bank; `FFB6/B7` title start; `FFB8-BA` page header pointer + bank; `FFBB/BC` start of the pending text run; `FFBD` WRAM bank of the text buffer;
  `FFBE/BF` record count; `FFC2/C3` right limit, `FFC4/C5` left limit/cursor, `FFC6/C7` pending gaps, `FFC8/C9` current y, `FFCA/CB` record write pointer, `FFCC/CD` record base, `FFCE/CF` record count; `FFD2-D5` image record pointer, bank, align; `FFD6/D7` BMP width/height
  (set by `51:70F4`; `FFD6` is also the `<li>` counter of `Html_CountListItems`); `FFD8/D9` indent; `FFDA/DB` alignment remainder; `FFDC/DD` start of the open link text; `FFDF/E0` link number / heap position; `FFE1-E8` viewport (`hViewX/Y/Right/Bottom`);
  `FFEB/EC` max scroll; `FFED-EF` header pointer.  These HRAM bytes are shared with the text engine of ROM0 (`hTextX`/`hTextY` = `FFBC-FFBE` in `config/ram`), so no global HRAM names were proposed except the view state (`analysis/naming/ram_g8.tsv`).

### 7.4 Functions

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 74:4165 | `Html_MetaResultToError` | function | PROBABLE | after a parse: if meta r_code (text at $D340) == 'ng' converts meta d_code (hex text at $D380) to a 32-bit number and sets C2CA=4, C1DD=$40, C1DE/DF=low 16 bits (error-screen inputs read by 4C:404D); 'ok' or none -> A=0 |
| 74:4207 | `Html_ParsePage` | function | CONFIRMED | full page pass (callers in 4C, 4E and 67 (CGI answers), 10 scenarios): C335=0, header+line table in WRAM bank 4 $D000, text WRAM bank 5 $D000, source SRAM bank 3 $B000 -> Html_ParseSource, Html_LoadPageImages, Html_MetaResultToError |
| 74:4254 | `Html_ScanPage` | function | PROBABLE | quick first pass: C335=$FF (no layout), same buffers, only Html_ParseSource; <img src> URLs go to a list in WRAM bank 4 ($DE00) that 4C:4840 fetches; C2C1 bit0 (<html> seen) is tested by 4C:456A and 4C:5187 |
| 74:4296 | `Html_ParseSource` | function | CONFIRMED | HTML-subset parser: A=source bank, HL=source, DE=output text buffer (WRAM bank in FFBD); handles text, '&' entities (Html_EntityNames) and '<' tags dispatched by tag id through Html_TagHandlerTable; also runs on CGI answers |
| 74:4530 | `Html_StoreTitle` | function | PROBABLE | finishes <title>: copies the collected title (<=19 bytes; longer ones cut and ended with SJIS '...' $8163) via $C340 into the page header at [FFB8/FFB9] (bank FFBA) unless the header title is already set |
| 74:4F4F | `Html_InitParser` | function | CONFIRMED | clears the parser state before a pass: [C2C1], C331/C332, C338-C33E, hRam_FFB6/B7, FFBE/BF and FFD0-FFE0 (not FFDE, not C330/C335/C336); executed at every Html_ParseSource call |
| 74:4FF2 | `Html_CountListItems` | function | PROBABLE | silent look-ahead over the source (dispatch Html_CountPassTagTable): counts <li> at nesting depth 0 into hRam_FFD6 up to 10, ul/ol tracked in FFD7; called by Html_Tag_Ol (74:4879) to pick the number width |
| 74:537D | `Html_LoadPageImages` | function | PROBABLE | walks the line records (count hRam_FFCE/FFCF, 16 bytes each): type 4 -> 5, follows the resource pointer (SRAM bank 3) and calls the BMP loader 51:7177, storing the decoded image pointer back (74:53A0-53CD) |

Layout (line breaking, alignment, floats; the internals were followed but only the entry-level roles are claimed):

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

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 74:5905 | `HtmlUrl_SchemeTable` | table | PROBABLE | 11 pointers + 0000: URL scheme names http https file mailto ftp gopher news nntp telnet wais prospero; walked by 00:10E9 in HtmlUrl_GetSchemeId and HtmlUrl_Resolve |
| 74:591D | `HtmlUrl_SchemeNames` | data | PROBABLE | items [name][NUL][value]: 'http'->1, all others $FF (recognised but unsupported); Html_Tag_A drops links whose value is $FF (74:4B49-4B4B) |
| 74:5969 | `HtmlUrl_GetSchemeId` | function | CONFIRMED | HL=URL/href text: if it contains ':' looks the scheme up in HtmlUrl_SchemeTable and returns the value in A (1 http, $FF other); no ':' -> A=0; callers Html_Tag_A and 4C:4000 (14 scenarios) |
| 74:5981 | `HtmlUrl_Resolve` | function | CONFIRMED | HL=link text, DE=base URL (bank 4 $DD00): builds the absolute URL in $C380 (scheme from base or 'http://', host-relative '/', ';' '?' '#' suffixes, or base path + link); callers 4C:48FD/5055/523F, 4E:4B48 |
| 74:59D8 | `HtmlUrl_HttpPrefix` | string | PROBABLE | 'http://' + NUL, copied by HtmlUrl_Resolve (ld hl,$59D8 at 74:59E7) when the base URL has no scheme |
| 74:5A76 | `HtmlUrl_FindLastSegmentDelimiter` | function | PROBABLE | HL=string, B=delimiter: HL = just after the last '/' (end of string if none); unless B=='/' then scans that last segment for B; HtmlUrl_Resolve uses it to cut the base at ';' '?' '#' (74:5A15) |
| 74:5A96 | `Html_LinkTable_Init` | function | PROBABLE | WRAM bank 6: link string heap pointer [C336/C337]=$D800, link pointer list $D600 emptied; called once per parse by Html_ParseSource |
| 74:5AAE | `Html_StringTable_Add` | function | PROBABLE | HL=heap end, BC=pointer list, string at $C380: if Html_StringTable_Find misses, appends the pointer and copies the string (limit BC); A=0 ok, $FF/DE=$FFFF when full |
| 74:5AF8 | `Html_StringTable_Find` | function | CONFIRMED | case-insensitive search of the string at HL in the zero-terminated pointer list BC (first byte of each entry skipped): A=1 found with DE=index, A=0 with DE=count; max 256 entries |
| 74:5B4F | `Html_NextResourceRecord` | function | PROBABLE | A=bank, HL=address of a 16-bit size: switches bank, returns DE=HL+2+size (next record), HL past the size; walks the [size][name NUL][data] list at SRAM bank 3 $B000 (74:4E72, 53B3, 4C:488A) |
| 74:5B5C | `Html_ParseDecimal` | function | PROBABLE | HL=digits: 24-bit result in C:DE (x10 as x8+x2), stops at the first non-digit, A=that character; used for hr width= and its '%' test (74:4CD5-4CE2) |
| 74:5BA0 | `HtmlUrl_NormalizePath` | function | CONFIRMED | HL=URL text edited in place: '\' -> '/', removes '/./' and '/x/../' segments, stops at '?' or '#'; called after HtmlUrl_Resolve (4C:4901) |

Labels:

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 74:4190 | `Html_MetaResultToError_HexLoop` | label | PROBABLE | loop turning ASCII hex digits of the d_code text ($D380) into hRam_FFB0-FFB3 (4 bits shifted through 4 bytes per digit) |
| 74:4307 | `Html_ParseSource_Loop` | label | PROBABLE | main character loop: NUL ends, '<' ($3C at 74:4313) -> tag, '&' -> entity, whitespace runs collapsed to one space unless <pre> (C2C1 bit3), SJIS lead bytes copied as pairs, output stops at page $E0 |
| 74:4392 | `Html_ParseSource_Entity` | label | PROBABLE | '&' branch: 00:10E9 over Html_EntityPtrs, stores the replacement char, swallows an optional ';' ($3B); not exercised in the 41 traces |
| 74:43C4 | `Html_ParseSource_End` | label | PROBABLE | end of input: Html_Layout_WrapRun then Html_Layout_ClearAllFloats, stores the record count at header+$15/16 and max scroll = max(0, page height - 96) in hRam_FFEB/FFEC (74:43C7-4403) |
| 74:4406 | `Html_ParseSource_Tag` | label | PROBABLE | '<' branch: writes a NUL at DE to end the pending text run, keeps the char after '<' in hRam_FFB4 ('/' = closing tag), then looks the name up in Html_TagPtrs (74:442E-4437) |
| 74:4481 | `Html_DispatchTag` | label | CONFIRMED | tag id -> handler: add a,a; add a,$A0; ... push bc; ret through Html_TagHandlerTable; id $0F ('!') dispatches at once, other tags need '>' or whitespace after the name (74:448F) |
| 74:44D4 | `Html_ParseSource_TitleTag` | label | PROBABLE | tag seen while a title is open: a '</title>' (Html_TitleTagPtrs, hRam_FFB4=$2F) calls Html_StoreTitle, any other tag is copied verbatim including '<' (74:44EB-4527) |
| 74:4C6B | `Html_ParseSource_PreCR` | label | PROBABLE | CR/LF inside <pre> (C2C1 bit3): ends the line (0D 0A pair swallowed) then continues the text loop; only the LF path was executed |

### 7.5 Keyword and attribute tables (item format `[ASCII name][NUL][value byte]`, walked by `00:10E9` and the attribute scanner `00:1119`)

| addr | name | type | status | evidence |
|---|---|---|---|---|
| 74:4000 | `Html_ResultCodePtrs` | table | PROBABLE | ptr list {4006,400A}: meta r_code values; used by 74:4165 (ld bc,$4000; 00:10E9 keyword lookup on the text copied to $D340 by the meta handler 74:46DE) |
| 74:4006 | `Html_ResultCodeNames` | data | PROBABLE | items 'ng'->1, 'ok'->2 (value byte follows the NUL; 00:10E9 returns it in A); 74:4165 acts only on 'ng' |
| 74:400E | `Html_EntityPtrs` | table | PROBABLE | ptr list of the 5 character entities; walked by 00:10E9 after '&' at 74:4392 and 74:5067 (ld bc,$400E) |
| 74:401A | `Html_EntityNames` | data | PROBABLE | items lt->$3C '<', gt->$3E '>', amp->$26 '&', quot->$22 '"', nbsp->$20; the value byte is stored to the output at 74:43AC-43AE (ldh a,[hRam_FFB3] ; ld [de],a) |
| 74:4033 | `Html_MetaAttrPtrs` | table | PROBABLE | ptr list of the <meta> attribute names; used by Html_Tag_Meta (ld bc,$4033; call 00:1119 attribute scanner at 74:46AC) |
| 74:403B | `Html_MetaAttrNames` | data | PROBABLE | items ppp_id->1, r_code->2, d_code->3; the value selects the 64-byte WRAM bank-6 copy target $D300/$D340/$D380 (74:46C1/46DE/46FB) |
| 74:4053 | `Html_TitleTagPtrs` | table | PROBABLE | 1-entry list {$4118} = the 'title' item of Html_TagNames; 74:44D4 (ld bc,$4053; 00:10E9) recognises </title> while the title text is being collected |
| 74:4057 | `Html_BrAttrPtrs` | table | PROBABLE | 1-entry list {405B}; Html_Tag_Br attribute lookup (ld bc,$4057; call 00:1119 at 74:4B98) |
| 74:405B | `Html_BrAttrNames` | data | PROBABLE | item 'clear'->1 (<br clear=...>); values of the attribute come from Html_ClearValueNames |
| 74:4062 | `Html_HrAttrPtrs` | table | PROBABLE | 1-entry list {4066}; Html_Tag_Hr attribute lookup (ld bc,$4062 at 74:4CC5) |
| 74:4066 | `Html_HrAttrNames` | data | PROBABLE | item 'width'->1 (<hr width=..>); value parsed by Html_ParseDecimal, '%' ($25) scales it with Multiply16 (74:4CE2-4CEE) |
| 74:406D | `Html_AlignAttrPtrs` | table | PROBABLE | 1-entry list {4071}; Html_Tag_Div attribute lookup (ld bc,$406D at 74:4761) |
| 74:4071 | `Html_AlignAttrNames` | data | PROBABLE | item 'align'->1; its value is looked up in Html_AlignValueNames (74:4778-4783) |
| 74:4078 | `Html_AnchorAttrPtrs` | table | PROBABLE | 2-entry list {407E,4084}; Html_Tag_A attribute lookup (ld bc,$4078 at 74:4ADB) |
| 74:407E | `Html_AnchorAttrNames` | data | PROBABLE | items href->1, name->2 (<a href=..> / <a name=..>); Html_Tag_A stores a '/' or '#' tagged string in the link table for 1 / 2 (74:4B21 / 4AE0) |
| 74:408A | `Html_ImgAttrPtrs` | table | PROBABLE | 2-entry list {4090,4095}; Html_Tag_Img attribute lookups (ld bc,$408A at 74:4E14 and 74:4F10) |
| 74:4090 | `Html_ImgAttrNames` | data | PROBABLE | items src->1, align->2 (<img src=.. align=..>); src is matched against the resource records in SRAM bank 3 (74:4E6B), align via Html_AlignValueNames |
| 74:409C | `Html_ClearValuePtrs` | table | PROBABLE | 3-entry list; value table of <br clear=..>: ld bc,$409C at 74:4BA6 (00:10E9) |
| 74:40A4 | `Html_ClearValueNames` | data | PROBABLE | items left->1, right->2, all->3; result stored in [C330] and used as index of Html_BrClearJumpTable (74:4BB9, 4BE9) |
| 74:40B6 | `Html_AlignValuePtrs` | table | PROBABLE | 6-entry list (not sorted); alignment keyword table (ld bc,$40B6 at 74:4770 and 74:4EB6) |
| 74:40C4 | `Html_AlignValueNames` | data | PROBABLE | items right->$04, top->$10, center->$08, middle->$20, left->$0C, bottom->$30; horizontal part is bits 2-3 ($0C), vertical part bits 4-5 ($30); div masks with $0C (74:4780) |
| 74:40EE | `Html_TagPtrs` | table | PROBABLE | 17-entry tag-name list (unsorted) walked by 00:10E9 at 74:442E (ld bc,$40EE) to turn the text after '<' into a tag id |
| 74:4110 | `Html_NoKeywords` | table | PROBABLE | the $0000 terminator word of Html_TagPtrs used as an empty keyword list: ld bc,$4110 ; call 00:1119 at 74:4478, 74:4DDF, 74:50F2 skips the attributes of a tag up to '>' without matching any |
| 74:4112 | `Html_TagNames` | data | PROBABLE | items html=1 title=2 head=3 body=4 center=5 div=6 br=7 hr=8 img=9 a=$0A b=$0B ul=$0C ol=$0D li=$0E '!'=$0F meta=$10 pre=$11; the value is the index into Html_TagHandlerTable |
| 74:4995 | `Html_ListBullet` | data | PROBABLE | 2 bytes $81 $45 = SJIS bullet '.' copied for unordered list items (read via ld a,$95 ; add a,c at 74:4961; executed) |

## 8. RAM proposals (`analysis/naming/ram_g8.tsv`)

29 rows: glyph work area (`wGlyphBufLeft/Right`, `wGlyphMaskCur/Next`), joypad repeat state (`wJoyRepeat*`), the HTML parser state (`wHtml*`, valid only while bank 74 runs; `C330-C33F` are scratch of the BMP loader too, `D300-D3BF` `D600-DFFD` are WRAM bank 6 only and given size 1 because of the bank ambiguity),
the text buffer `wAttrUrlBuf` (`$C380`, 256 bytes: attribute values and URLs) and the page-view state in HRAM (`hViewX/Y/Right/Bottom`, `hViewScrollMax`, `hPageHeaderPtr`).  Bytes named by other passes (`C0D3`, `D724`, `D824`, `C267/C268`, `C2D5/C2D6`) are referenced in the header of the file instead of being repeated.

## 9. Hypotheses, open questions, findings for others

**Open questions**

* Which layout/keyboard the four modes `[C2AB]` = 6-9 of bank 55 are; what the D/E start states (`[D725]` = 0/4/5, `$08`, cursor-sprite row) mean.
* The exact roles of `Function_74_55BE` (floating image placement), `57AD`, `5528`, `5348`, `532A` and `Function_74_4F97/4FBE` (rules only followed, not proven).
* Colour semantics of the 16 `Canvas_RemapTable` handlers (which selector is foreground).
* `D725` (WRAM bank 1): 0 or the row index of the keyboard scroll tables (`KbdSlide_*Mode8/9`).
* Which real feature `7C:7D8D` (three waves of `70:4000/4023`) belongs to; whether `70:4000` is a tutorial/animation player.

**Findings for other owners**

* **Region 7C:57C3-57CD** is font data, not code (section 3): merge into one `gfx` region `7C:4000-7B7C`.  Regions of 7D/7E were already correct (`4000-7B7C`).
* Font banks 77-7B (JIS rows 34-78) and 76 (rows 79-84 + ASCII font at `76:67A8`): rule in section 6.1; bank 76 `67A8-6C28` is **ASCII font data** (12 bytes per glyph, `$20-$7F`) and should not be typed as unused kanji slots.
* `Table_74_40EE` contains the terminator word `$0000` at `74:4110` used as an empty keyword list (`ld bc,$4110`); a label `Html_NoKeywords` was added inside the region.
* `hRam_FFB0-FFDF` are shared scratch between the text engine of ROM0, the HTML parser (bank 74), the URL/resource code of 4C/4E and the BMP loader (bank 51): a single name per address is misleading, the meaning depends on the running subsystem.
* Bank 67 has its own URL code (`Url_Resolve` 67:5F66, `Url_JoinRelative` 67:5FB5, `Url_NormalizePath` 67:5FF9, named by another pass, used for the CGI redirect handling): same job as `HtmlUrl_Resolve`/`HtmlUrl_NormalizePath` of bank 74 but separate code, hence the `HtmlUrl_` prefix here.
* `wRam_C2C3` (read by `Charset_ConvertPage`, `4C:460D`, ...) is `wCommSessionKind` in `config/ram` (1 = settings CGI page session, 0 = homepage/default session): value 1 selects charset auto-detection, otherwise the page is decoded as ISO-2022-JP.  (An earlier draft of this note called it a generic "page charset auto-detect mode"; the verifier replaced that.)
* Besides the ROM0 HDMA loaders (`00:0749/0787`) there are three more GDMA-at-VBlank helpers with the same shape: `Gfx_GdmaAtVBlank` (7F:4C20), `Gfx_GdmaAtVBlankNoDi` (7F:72C2) and `PageList_StartHDMAAtVBlank` (24:4A54, waits LY=$5D instead of $8F).

## 9b. Verifier corrections (adversarial pass)

Re-derived from the ROM/traces and fixed in the symbol rows and in this note:

* `Nav_MailMenu_SendReceive`: 27:4000 is *not* skipped when 27:41BC returns $FF; it is skipped only when 27:41BC returns $FF **and** `25:4A90` (`Mailbox_CountRecords`) returns D=$0C (mailbox full), which takes the never-executed dialog path `7C:7BFA-7C6A`.
* `Charset_ConvertPage`: `[C2C3]` is `wCommSessionKind` (1 = settings CGI session), not an invented "auto-detect mode"; consistent with the detector running only in settings_cgi.
* `Html_Tag_Meta`: the handler *is* executed (3 scenarios, a.html `<meta name= content=>`); what never ran is the ppp_id/r_code/d_code copy.  `Html_Tag_Hr`: the rule glyphs `$83DB-$83E6` were rendered and are horizontal lines (new evidence).
* `Glyph_SjisToJis` ran in 32 scenarios (13 was the mapper's count out of 18); `Glyph_LoadWide` 63:4000 role resolved (SJIS validity bitmap, invalid -> $81A1); `Glyph_DottedLineData` is a 6-px cell, not 12 px; `Stub_Nop_7F_61FC` is reached through 27:42DB (7F:6235 never runs).
* `Html_ParsePage` also has a caller in bank 67; `HtmlUrl_GetSchemeId` is called from `4C:4000` only (no bank 4E caller).
* Checked and upheld: font row->bank tables and glyph rendering (C1/C2), the `Html_Tag_Body` prefix-order bug (C5; `Html_TagPtrs` order dumped from the ROM: `b` precedes `body`, `br` precedes `b`), `Html_Tag_Li` writing `C331` twice (C13), the STAT split handler `00:0E93`, all four `ScrollSplit_Step*` sign/slot claims, `Canvas_BlitGlyphNoRemap` addressing and bank-3 wrap, the settings menu order vs `title_settings.macro`, the SELECT+LEFT ($24) and B+SELECT+RIGHT ($16) hidden inputs, and the coverage claims of every CONFIRMED function/label row (none has zero executions).

## 10. Reproducing

```
python3 tools/gen_asm.py verify --config <copy of config with the five bank files>     # IDENTICAL
python3 tools/gen_asm.py regen  --config <same copy> --out <dir> --fast               # names visible in <dir>/bank74.asm ...
```
Call graph, coverage and callers were derived with small throw-away scripts (decode of every `code` region with `tools/sm83.py`, inline far-call bytes skipped; scenario counts from `traces/coverage_*.tsv`;
the font layout from `Glyph_KuTenAddr` and a bit-exact rendering of glyphs).  Facts stated in section 6.1 that can be checked with one line: `python3 -c "..."` on `baserom.gbc` offset `bank*0x4000 + idx*18` with two 12-bit rows per 3 bytes.
