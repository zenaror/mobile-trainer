# Mail library, sound driver, mail screens, browser and HTML buffers (ramop10): 31 names, 494 pointer operands

## 1. Result

| item | count |
|---|---|
| banked WRAM pointer operands (`ld hl\|de\|bc, $Dxxx`) written as names | **494** in 57 files: 202 by the tool (a consumer rule or the pseudo consumer `(direct)` proves the bank), 292 by hand with a recorded proof |
| by name (all 693 operand lines of the pass) | `wMail_Work` 149 (offsets), `wMailTextScratch` 55, `wScreenTileMap` 52, `wMailSessionBlock` 48, `wBrowserPageUrl` 36, `wMail_TextBuf1` 27, `wEditAddressBuf` 25, `wEditNameBuf` 22, `wMail_OutputBank` 21, `wMail_InputBank` 19, `wScreenAttrMap` 17, `wMail_TextBuf2` 17, `wSoundDrv_TrackPtr` 16, `wEditBodyBuf` 14, ... (58 names in all) |
| uses of old or neutral names written as the right name | 197 in 7 files: 47 uses of `wRam_Dxxx` by the tool (the replays as proof), 150 respelled by a recorded list (97 in the mail library, 53 in the sound driver) |
| words of address tables | 12 `dw` words in 2 tables (`Table_CommNotice_DigitCells`, `Table_SoundDrv_SfxTrackPtrs`) |
| new names in `ram/banked.asm` | 31 (211 in all, `apply_banked_names --check`: 0 errors, 146 overlapping pairs; 17 CONFIRMED, 14 PROBABLE): 7 `wSoundDrv_*`, `wMailInfo`, `wMailTextScratch`, `wAbookListState`, `wMail_Work`, `wMail_InputPos`, `wMail_OutputStream`, `wMail_ComposeItem`, `wMail_TextBuf1`, `wMail_TextBuf2`, `wPromptTextBuf`, `wHtmlAlignStack`, `wHtmlListStack`, `wHtmlMetaPppId`, `wHtmlMetaRCode`, `wHtmlMetaDCode`, `wBrowserPageTitle`, `wBrowserUrlSave`, `wBrowserPageUrl`, `wHtmlLinkHeap`, `wDictHistory`, `wHtmlPage`, `wHtmlImageBaseUrl`, `wHtmlImageUrlList`, `wHtmlTextStream`; 10 older `DEF` lines corrected (`wMailSessionBlock` 10 -> 21 bytes, `wHtmlLinkPtrList` 1 -> 512), 12 `CAVEAT`s added (15 in all: 7 on older names, 5 on new ones) |
| rules | `wramx_consumers.tsv` 130 rows (25 new, 1 of them dropped by the readers: 24 net; 13 with the new `needs fixed`; the families of `CopyBytes` and `CopyString` widened), `wramx_calls.tsv` 162 rows (81 new, 79 of them every call target of the mail library), the record of by-hand rows `ramop10_manual.tsv` 329 rows (300 written, 29 that stay numeric with the reason) |
| left numeric | **55** of the 549 banked WRAM pointer operands that were numeric before: 41 marked `; raw` with the reason and 14 values (the number -10000); every other banked pointer operand now has a name.  Neutral uses: 123 with the bank not shown (115 in the library's dead selectors, 8 in the sound driver), 2 without a name in the bank, 14 refused by a `CAVEAT` |
| ROM | byte-identical (`make compare`: `RESULT: IDENTICAL`; `sym-check`, all audits and the 84 + 7 tool tests pass; `tools/invariants_check.py`: ALL PASS; every changed line is an operand replaced by an expression of the same value, or a comment) |

### 2.2 The sound driver (bank 04, WRAM bank 1 `$D000-$D27F`)

The sound driver is entered only through the 13 stubs of `home/audio.asm` (452 `call`s, every one after `ld a, $01 / ldh [rSVBK], a`), writes no WRAM bank register, and all 1,836 instruction starts of bank 04 that the replays executed ran under bank 1: the **invariant S1**, also checked by `tools/invariants_check.py`.
New names (the driver's own state, all W1): `wSoundDrv_SfxTempoAccum` (`$D008`) and `wSoundDrv_MusicTempoAccum` (`$D00D`), the 16-bit tempo accumulators (CONFIRMED: the accumulator model matches 53,592 frames), `wSoundDrv_ChannelCount` (`$D012`, 38,399,056 decrements at 04:41AC), `wSoundDrv_FadeCounter` and
`wSoundDrv_FadeLevel` (`$D021/$D022`, PROBABLE: the fade step never ran), **`wSoundDrv_Tracks`** (`$D040`, 480 bytes: 8 track records of `$3C`, tracks 0-3 the sound effects, 4-7 the music) and **`wSoundDrv_Channels`** (`$D220`, 96 bytes: 4 channel records of `$18`; CONFIRMED, the init and frame loops with the strides `$3C` and `$18` run 663 and 3.4 million times).  The four `Table_SoundDrv_SfxTrackPtrs` words are `wSoundDrv_Tracks + $00/$3C/$78/$B4`.
`$D03C` is the header track counter only in the two song start routines (04:430A, 04:4374); everywhere else the driver uses it as the dirty-flag mask of a track update (`wSoundDrv_HeaderTrackCount` carries a `CAVEAT`, the eight other sites keep `wRam_D03C`).

### 2.3 The mail screens (WRAM bank 1: `$D400-$D52F`, `$D624-$D638`, `$D726`)

* **`wMailInfo`** (W1 `$D400`, 256 bytes, PROBABLE): the mail information record of the mail server screens, the summary that `Pop3_TopPoll` (bank 54) stages for each mail: date (6 BCD bytes), source label at `+$06`, subject at `+$1B`, sender name or address at `+$C0`; `MailServerMgr_DrawMailFields` (2E:4EBD) and `MailServerMgr_DrawMailDate` (2E:5005) draw it.

It is an overlay of `wEditBodyBuf` and `wEditAddressBuf`, the mail body and   address staging buffers of the compose, viewer, address book and profile flows (`$D400-$D4FF` is used by both, never together): the mail info flows spell the bytes `wMailInfo + offset`, the others spell them as their buffers, and both `wEditBodyBuf` and `wEditAddressBuf` carry a `CAVEAT`, so those flows are written by hand with their proofs.

* **`wMailTextScratch`** (W1 `$D524`, 29 bytes, PROBABLE, `CAVEAT`): short NUL-terminated texts built or shown by the mail screens: (1) the number strings (a template of full-width zeros whose second byte of each cell is incremented), (2) the result messages (the longest are `MailResult_Txt_SendFailed`, `_ReceiveFailed` and `_CannotReceive`, 29 bytes with the NUL), (3) the 12 date digits, (4) the name and subject texts of the received mail grid,   (5) **the result text of the connect dialog** (the connection password, PROBABLE): the six 7-byte argument templates that the session flows copy to `wMailSessionBlock` carry the far pointer 01:D524, `ConnectDialog_Run_Accept` (57:4096) writes the typed or stored text (at most 8 characters) and a NUL there, and `MailConnect_Screen` copies the 9 bytes to `$C0A0`, the password source of `Mobile_BeginConnect`.

The same address is also the compose mode (`wMailComposeMode`) and   the reply record number (`$D525/$D526`): those stay numeric or neutral.

* **`wAbookListState`** (W1 `$D726`, 3 bytes, PROBABLE): the address book list state: cursor row or slot, re-entry flag, button row (`Abook_Run_List` 2F:7ECC, `AbookList_Run`, `view.asm`, `save_confirm.asm`; ranges observed 0-5, 0-1, 0-2).

### 2.4 The browser and the HTML engine (WRAM banks 6, 4 and 5)

Bank 6 is the browser's work area, selected by `ld a, $06 / ldh [hWRAMBank], a / ldh [rSVBK], a`: `wHtmlAlignStack` (`$D000`, 256: the alignment values of `<center>` and `<div align>`, the push refuses at `$FF`), `wHtmlListStack` (`$D100`, 512: two-byte entries of `<ul>`/`<ol>`), the three `<meta>` value buffers
`wHtmlMetaPppId`, `wHtmlMetaRCode`, `wHtmlMetaDCode` (`$D300/$D340/$D380`, 64 each, PROBABLE: the copy never ran, the readers did; the `d_code` is the error detail only when `r_code` is `ng`), `wBrowserPageTitle` (`$D3C0`, 22: the title record, at most 21 bytes), `wBrowserUrlSave` (`$D400`, 256) and `wBrowserPageUrl` (`$D500`, 256: the URL being navigated to and the URL on display),
`wHtmlLinkPtrList` (`$D600`, now 512 bytes: at most 255 word pointers and the terminator), `wHtmlLinkHeap` (`$D800`, 2,048: the strings of the link table, each a tag byte and a NUL-terminated text, written at `wHtmlLinkHeapPtr` with the limit `$DFFE`; the two Y bytes of a `#` anchor can fill `$DFFE-$DFFF`) and `wDictHistory` (`$DA00`, 768: the mobile dictionary viewer's back stack, six entries of `$80` bytes, over
the link heap).  Bank 4 is the page store (`hHtml_PageBank = 4`): `wHtmlPage` (`$D000`, 4,096: the title, the record count word at `+$15`, 16-byte layout records from `+$20`; the scan pass keeps the image URL heap behind them), `wHtmlImageBaseUrl` (`$DD00`, 256: a copy of the page URL) and `wHtmlImageUrlList` (`$DE00`, 512 word pointers).  Bank 5 holds the parser's output stream (`wHtmlTextStream`, 66,748 stores of 74:4345 in 15 scenarios).
Three of these names have no `ld r16, $Dxxx` operand of their own (the code builds the address from a high-byte immediate): they document the layout.

## 3. How the tool proves the bank (what is new in this pass)

The mechanism is that of `naming2_ramop7.md` to `naming2_ramop9.md`; the pass adds (details in the docstring of `tools/apply_ram_operands.py`, the headers of the two rule files and `STYLE.md`):

Two sites (`inline_images.asm:23`, `mobile_dictionary_view.asm:278`) load `$DD00` under bank 6 and use it under bank 4: they are named for bank 4.

The new outcome **`overrun`** keeps a pointer numeric when an immediate count next to the load exceeds the bytes from the pointer to the end of the object (a wipe or copy over the neighbours: `mailbox_screen.asm:1354`);   it is a heuristic (it does not see a count in `DE` or `A`, set further up, or an end-address compare), and the 67 looped sites of the tree were read one by one.

* **A local label is crossed when every way into it shows the same bank** (`label_join_bank`): the fall-through, each `jr`/`jp` that names it from above, and the back edges of a loop whose body writes no bank register, calls only routines that keep it and has **no label that is entered from outside the body** (`interior_entries_ok`: a jump into the middle of a loop brings another bank to the back edge; this hole was found by the reader of the tool, reaches no real row, and is closed and tested).

* **A routine that loads the address of a bank register anywhere** (`ld de, rSVBK`, `ld hl, $FF70`) is refused whole: a later `ld [de], a` would be a bank write that no backward scan can see (the source has none; found by the same reader).

* **`a` rows with A = 0**: "the bank in force" holds only for a consumer that `wramx_calls.tsv` lists as `keeps if A=0`; `TextTiles_RenderGrid` hands A to `ReadByteFar`, which has no test for 0 (it would write 0 to both bank registers, which selects hardware bank 1).

* **By-hand rows of a repeated word**: `$D0A3 x2` in the `operand` column of a record names every occurrence of the number on a `dw` line when it occurs exactly that many times.

* **Effects**: 81 new rows in `wramx_calls.tsv`, every call target of the mail library (76) and a few helpers (`Divide16`, `CommTime_*`, `Glyph_IsSjisLeadByte`, `Bmp_Validate`); the 20 `Mail_*_NextPage` rows document the library and are never read (they are called with `call nz|c`, which is no proof).

## 4. What the independent readers changed

(The reports are in [`naming2_verify_ramop10.md`](naming2_verify_ramop10.md).)  **Tool and rules**: no false accept in the tree; three latent false accepts on synthetic code (the loop with a second entry, the address of a bank register above the idiom, A = 0 for a consumer that hands A to `ReadByteFar`) were closed, with 15 tests; rules 22 of 25 upheld, 3 corrected (`BankSwitch_H` narrowed to `wBrowserPageUrl`, the proof of `HtmlUrl_Resolve`, `TextTiles_RenderGrid hl` dropped), effects 79 of 79 true, all 230 written operands and 47 neutral uses upheld, `needs fixed` for the invariant rows.

**Mail screens**: 213 of 215 operands upheld; the two pointers of `Pop3_TopPoll` that were named `wEditAddressBuf` are the sender field of the POP3 summary (`wMailInfo + $C0`), one stale `; raw` mark, one raw reason that was wrong (`send_receive.asm:329` is the connect dialog's result text and is named), the `wMailInfo`, `wMailTextScratch` and `wMailSessionBlock` texts, a `CAVEAT` on `wEditAddressBuf`.

**Scope B**: 130 of 138 lines upheld, the five `wTileStage2` pointers of the debug screens, which the new `TextTiles_RenderGrid` rule had wrongly named (the data is the debug screens' Shift-JIS string scratch, not tile staging), went back to `; raw`, `wHtmlLinkHeap` is 2,048 bytes, a title is at most 21 bytes, six raw reasons and several counts were corrected, and the eight words of `Table_CommNotice_DigitCells` were missed.

## 5. Findings and open points

If either had a hole those sites would lose their proof, so `tools/invariants_check.py` makes it a command: 452 stub calls, 12 `Mail_DispatchFar` sites, the ROM bytes of every far call and the observed masks.

* **An address with two meanings stays numeric or hand-written where the site needs it**: `$D524` of bank 1 (compose mode, the number and text scratch, the reply record number `$D525/$D526`, the connect dialog's result text), `$D400-$D4FF` (mail body and address buffers / the POP3 summary), `$D624` of bank 1 (session block, address book mode flag, the dialog argument block, the seconds cache) and of bank 5 (`wMail_TextBuf2`),   `$D00D/$D00E` and `$D00F/$D010` of bank 5, bank 6 `$D000` (align stack / the never executed developer image of `dev_test_config.asm`), bank 6 `$DA00` (dictionary history over the link heap), `$D03C` of bank 1, bank 2 `$D000` (tile staging / the debug string scratch).

* **The library's union** was read selector by selector: 1, 2, 4, 6 and 8 are backed by code and replays, 3, 5, 7 and 9-12 only by reading (their formats are internally consistent: 11 and 12 take a 10-byte caller block and `BC` at `+2..+$0F`, 9 keeps a second output at `+$15..+$19`, 10 a part descriptor at `+$17..+$1B`).

* **A pointer list holds 255 entries**: `wHtmlLinkPtrList` and `wHtmlImageUrlList` are 512 bytes of zero-terminated word pointers; a 256th entry would put the terminator on `$D800` (the first byte of the link heap) or `$E000` (outside the bank).

* **`keeps` is still a statement about the shadow**: `Stat_ScrollSplitHandler` (00:0E93) restores the shadow from the real `rSVBK` it read at entry, so a preempted sound bracket would leave `hWRAMBank = 1`; S1 and L5 speak of the real register and are not affected.

* **Still open**: the 123 neutral uses (R2 proposed names for the 121 of the library, all bank 5 by L5, and two immediates that are the high and low byte of `wMail_TextBuf1/2`: they need a second look and a new kind of operand), a name for the reply record number `$D526`, the six `ConnectDialog_Run` template words (`dw wMailTextScratch`), `Html_Layout_ClearAllFloats` (a possible endless retry in a list), the macros for the bank-switch idiom and the sound requests.

`python3 tools/apply_ram_operands.py --areas wramx --observed --dry-run [--report FILE]` lists what the rules prove (the report has the consumer and the proven bank of every operand); `--neutral --observed` does the same for the neutral names; `--check` audits what is still numeric although a rule proves it.
