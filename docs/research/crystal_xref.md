# Mobile Trainer <-> Pokemon Crystal cross-reference

In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.

**Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.

Evidence vocabulary: CONFIRMED / PROBABLE / HYPOTHESIS as defined for the project. A byte-identical (masked)
routine is CONFIRMED to be *the same code*. **Every name imported from Crystal comes from the Crystal community
disassembly, not from Trainer**; where a Crystal name is recorded in a TSV the evidence column says so. Names
must be treated as PROBABLE for the *purpose* of the routine at best, and never override an honest
`Function_<bank>_<addr>` unless the importing agent checks the local evidence.

## 0. Summary (all statements are backed by section 3; numbers come from `analysis/crystal_stats.json`)

Trainer contains the Mobile Adapter SDK as **two self-contained library banks**: Trainer bank **0x75** = Crystal    bank 0x44 (`Mobile Adapter SDK`, `lib/mobile/main.asm`) and Trainer bank **0x0F** = Crystal bank 0x45 first part    (`Mobile Adapter SDK Mail`, `lib/mobile/mail.asm`).

The libraries are the same code at a *different revision/build*: functions moved by +0..+56 bytes inside bank 0x75    (+4/+21 in bank 0x0F), a handful differ (`jr` vs `jp`, an extra 8-byte prologue for API slot 31, `X-Game-title:    MOBILE TRAINER` in the mail header table, MBC5 16-bit bank handling).

The 34-entry Mobile API dispatch table is at **75:4070** (relocated copy of Crystal `_MobileAPI.dw`), 22 of the    23 entries that can be pinned by matched functions agree with the byte matches; slot 31 differs (the tool's earlier    text 21/22 was a miscount; re-derived: all 34 words follow the per-region offsets of the function bodies, slot 31    is the only exception).

Exception: the flag byte `wc821`    (Crystal `$C821`) sits at the *start* of the Trainer block, `$C69F` (delta -$182; re-derived from    `Function110115`, `ld hl,$C821` -> `ld hl,$C69F`), so the Trainer layout is a re-ordering, not a pure shift.

Trainer's bank-0 glue for the SDK (`MobileAPI`, `ReturnMobileAPI`, serial handler, `MobileTimer`) is *not*    byte-identical to Crystal's `home/mobile.asm` (rewritten for MBC5) but has the same shape, the same order and the    same call targets: 00:0150, 00:018D, 00:01B7, 00:01ED (PROBABLE, hand analysis, section 3.4).

## 1. Material inventory

Not available: a Japanese Crystal symbol table, the SDK's original source, a rebuild of the Crystal tree (it needs
rgbds 0.6; the installed 1.0.3 was not tried). No emulator was used.

Which Crystal version is the closest relative? The SDK in the eng build is byte-identical (masked) to the SDK in the
JP ROM for every routine that matches Trainer, so eng = JP for this purpose. Trainer's SDK is a *third* revision
that differs from both by the deltas in 3.1. (HYPOTHESIS: Trainer's is older or newer; nothing here dates it.)

Details are in the docstring of `tools/crystal_match.py`. In short: cut the reference into code chunks and data
regions (labels from the `.sym`, code/data classification from the sources, 5 163 code units of >= 12 unmasked
bytes); decode with `tools/sm83.py`; mask the 16-bit operands of jp/call/ld r16,imm16/ld [a16]/ld a,[a16] and the
`ldh` operand; keep opcodes, `jr` offsets and imm8 literally (imm8 may differ as "soft" difference); seed with
literal byte runs (`bytes.find`), verify instruction by instruction; report uniqueness against both ROMs.

* `python3 tools/crystal_match.py --selftest`: 5 163 of 5 163 Crystal units are found at their own address when searched
  inside the Crystal ROM (a search-engine sanity check only: it cannot measure false positives or missed relocated copies).
* Re-check of the results: every accepted `exact_masked` HIGH/MEDIUM record (201) was re-decoded with
  `sm83.decode` on both ROMs and compared instruction by instruction with operands replaced: 0 mismatches. The
  adversarial review repeated this with its own masker (`jp/call/ld r16,imm16/ld [a16]/ldh [a8]` operands wildcarded):
  all 135 HIGH records are byte-identical after masking, unique in Trainer and in Crystal, >= 24 unmasked bytes
  (minimum 24: `Function111664`, `Function112534`), and present exactly once in the JP Crystal ROM; the 18 imm8-diff
  records differ only in imm8 operand bytes (the LOW()/HIGH() halves of relocated addresses).
* Negative control: matching the Crystal symbols against an unrelated ROM (`mbc6test/build/mbc6-test.gbc`) gives 2
  LOW hits and 0 HIGH/MEDIUM.
* Positive controls (related Crystal builds, run with `--refs eng --jp none --trainer <rom>`): retail US Crystal v1.0 gives
  2 650 HIGH (reproduced) + 3 505 MEDIUM records, the Japanese Crystal ROM 2 212 HIGH (reproduced) + 3 132 MEDIUM after the
  demotion rule of section 8 (the pre-review tool gave 3 887 MEDIUM for retail US; the originally reported 3 903 / 3 628 were
  not reproduced) - the engine is not specific to the SDK, and Trainer's 135 HIGH + 141 MEDIUM (all in the two library
  banks) is what a shared *library*, not a shared game, looks like. The negative control (unrelated ROM
  `mbc6test/build/mbc6-test.gbc`) was reproduced: 2 LOW, 0 HIGH/MEDIUM.
* Cross-references: the ptbr build gives identical records; the JP ROM matches every confident SDK unit exactly.

Review rule (`demote_weak_short`): a full-unit hit with < 24 unmasked bytes keeps MEDIUM only via (b)/(c) as defined in section 8; 115 of the 141 MEDIUM records have < 24 unmasked bytes of their own (72 have < 12; many are 1-10 byte stubs), so **MEDIUM means "same code by context", not "same code by its own bytes"**.

### 3.1 Trainer bank 0x75 = Crystal bank 0x44 (Mobile Adapter SDK): CONFIRMED

* 190 confident records map Crystal bank 0x44 units to bank 0x75 (81 HIGH, 109 MEDIUM), covering about 95.8 % of the
  bytes of the 222 code units of Crystal bank 0x44 at PROBABLE or better and 98.2 % at any level (percentages from the
  tool run, not re-derived by the review; the review's demotion of two 5-7 byte stubs changes them by < 0.1 %); 13 964
  bytes of Trainer bank 0x75 are explained by confident code/data matches (`crystal_coverage.tsv`; re-derived: 13 973 code
  bytes by interval union of the confident records before the demotion). Bank 0x75 holds code
  and data up to 75:7F45; 75:7F46..7FFF is $00 padding.
* Layout: the order of functions is preserved, only absolute positions shift. Constant offsets (Trainer addr -
  Crystal addr) per contiguous run of units:

| Crystal range | offset | | Crystal range | offset |
  |---|---|---|---|---|
  | 44:4000-4290 | +0 | | 44:5C17-614D | +9 |
  | 44:4291-43AB | -3 | | 44:614E-6372 | -5 |
  | 44:43AC-5334 | +5 | | 44:6373-66E5 | +6 |
  | 44:5335-548B | +13 | | 44:66E6-6FD4 | +22 |
  | 44:548C-562C | +9 | | 44:6FD5-7481 | +56 |
  | 44:562D-586D | +13 | | 44:7482-end | -62 |
  | 44:586E-5A46 | +12 | | (mail) 45:4000-4242 / 4243-55AE / 55AF-end | +0 / +4 / +21 |
  | 44:5A47-5C16 | +10 | | | |

(Steps come from inserted/removed bytes in between; e.g. data matches after 44:6001 sit at -5 while the code before them is at +9
  because Crystal has a `ds 14` pad in front of `MobilePacket_Idle` that the Trainer lacks. Gaps: `crystal_coverage.tsv`.)
* Byte-level differences in matched functions (CONFIRMED; `python3 tools/crystal_match.py --diff <Crystal unit> --at
  BB:AAAA` prints them):
  * 18 confident units differ only in one to four imm8 operands. Most are the two halves of a relocated address
    (`ld a,LOW(x)` / `ld a,HIGH(x)`), e.g. `Function110291 +041:72>11, +044:C8>C7` = `wc872` -> `$C711`, `Function1103ac
    +03D:80>1F,+040:C8>C7` = `wc880` -> `$C71F`, `_MobileReceive +027:08>A8` (`ld a,$08; cp l` -> `$A8`, i.e. `wc808` ->
    `$C6A8`), `Function111892 +012:11>B1,+015:C8>C6` (`wc811` -> `$C6B1`). These feed the RAM map. Single-byte cases are
    the LOW() of a relocated *function* address: `_MobileAPI +02E:36>35` = `ld a,LOW(Function110236)` (Crystal 44:4236 ->
    Trainer 75:4235) and `MobileAPI_TelephoneStatus +031:40>49` = `cp LOW(Function111540)` (44:5540 -> 75:5549), which are
    the relocation of API slots 1 and 33.
  * `Function110115` (MOBILEAPI_00): 128 of 135 aligned instructions identical; the only real encoding difference is the
    `jp nz,$4158` at 44:41D4 that is `jr nz,$4158` at 75:41D4 in the Trainer (a shorter jump: same source, different
    assembler output); the other 'differences' (7 by the tool's count, 8 removed/added lines in `--diff`) are `jr` operands whose displacement
    changed as a consequence (Crystal `jr $41D7` = Trainer `jr $41D6`, etc.; re-derived with `--diff`). The
    Trainer copy is followed at 75:4225-422F by the tail `ld a,$21 / ld [$C6AF],a / ld hl,$C69F / set 1,[hl] / ret`
    (Crystal's `Function110226`+`Function110228` in one piece).
  * `Function110236` (MOBILEAPI_01, init): Trainer clears `$0450` bytes at `$C69F` (75:4247-424A) instead of
    `$0452` at `$C800`, and stores the HL argument in the bank-variable pair `FF8A/FF8B` (75:425E, 4261) instead of `wc981/wc982`
    (Crystal 44:425F, 4263): in Trainer that pair is the 16-bit current-ROM-bank record. Rest identical.
  * API slot 31: Trainer 75:43A9 = `ld de,$C6D5 / ld b,$08 / call $4000` then falls into the body that is Crystal's
    `Function1103ac` (Trainer 75:43B1). Crystal's slots 3 and 31 both point at `Function1103ac`.
  * `MobileTimer`/serial wrappers see 3.4.
* Not found byte-for-byte (structural or table matches only): `Function110115` (aligned), `Function110236`,
  `Function1105dd`, `Function1111fe`, `Function1113fe`, `Function111b3c`, `Function112271`, `Function1117e7`, a few
  small ones; the remaining Crystal units with no counterpart: 13 units / 270 bytes (mostly 1-10 byte stubs) plus the
  two 68-byte twins `Function11392f`/`Function113973` (one Trainer region at 75:78F1 fits both; assignment
  ambiguous). Trainer 75:4227-4233 are Crystal `Function110228`/`Function110231` (4-9 byte stubs, too short to be searched; layout offset -1) and
  4234 is `Function110235` (`nop`, API slot 32, pinned through the table); only the 8 bytes at 75:43A9-43B0 have no Crystal counterpart.

### 3.2 Trainer bank 0x0F = Crystal 0x45 (Mobile Adapter SDK Mail): CONFIRMED

* 86 confident records map 45->0F (54 HIGH, 32 MEDIUM); 6 817 bytes of Trainer bank 0x0F are covered; Crystal 45:4000-5D98 (the library) is 98.8 %
  covered at PROBABLE or better. Bank 0x0F contains *only* this library: 0F:4000-5DAD used, 0F:5DAE-7FFF zero-filled.
  Crystal bank 0x45 continues with game code after the library's last unit (45:5D99 on: sprite engine, stadium): none of it exists in Trainer.
* Offsets: data/strings +0 up to 45:4062 and +4 from 45:4074/408D (the longer `X-Game-title`), code +4 from 45:4243, +21 from 45:55AF.
* Trainer-specific data in the library (CONFIRMED by bytes): the header-name table `Unknown_114011` (45:4011, 17 word
  pointers) is relocated to 0F:4011 (pointers shift by +4 after the changed string), and Crystal's `String_114074 =
  "X-Game-title: XXXXXXXXXX"` (a template) is `"X-Game-title: MOBILE TRAINER"` at 0F:4074 in Trainer (4 bytes longer, which
  explains the +4 offset). `String_114004 = "CGB-AAAA-00"` is identical at 0F:4004.

### 3.3 Data, tables, strings

| Trainer | Crystal | content |
|---|---|---|
| 75:4070 (68 B) | `_MobileAPI.dw` 44:4070 | 34-word API dispatch table, relocated (words 4115 4235 428E 43B1 443D 44CB 457D 4587 ...); found through matched functions, 22/23 pinned entries agree, slot 31 = 43A9 differs |
| 75:61A7 (74 B) | `Jumptable_1121ac` | 37-entry state table, 35 entries pinned by matched functions, all 35 agree |
| 0F:4169 (26 B) | `Jumptable_114165` | 13 entries, 11 pinned by matched functions, all 11 agree |
| 75:4FB2.. | `URIPrefix`, `HTTPDownloadURL/UploadURL/UtilityURL/RankingURL` | `http://` and `gameboy.datacenter.ne.jp/cgb/{download,upload,utility,ranking}` (Trainer 75:4FB9, 4FDE, 5001, 5025). ASCII bytes verified by the review. Tool status: Upload (75:4FDE) and Ranking (75:5025) HIGH/CONFIRMED; Download and Utility are AMBIGUOUS/HYPOTHESIS in `crystal_data_matches.tsv` (the text occurs several times; here identity rests on the position, the same +5 offset as neighbouring code: PROBABLE); `URIPrefix` `http://` LOW/HYPOTHESIS (7 bytes). Trainer bank 0x67 additionally holds a copy of the `.../cgb/utility` body at 67:6334 (unexplained, application side) |
| 75:5FFC.. | `MobilePacket_*` templates (44:6001..; BeginSession 18 bytes MEDIUM/PROBABLE, the others 6-12 byte paired-bank matches MEDIUM/PROBABLE: identity rests on bank pairing and the constant -5 offset, not on their own bytes) | packet templates `99 66 cmd ...` (BeginSession with `NINTENDO`, EndSession, DialTelephone, HangUp, TelephoneStatus, ISPLogout, ReadConfigurationDataPart1/2, WaitForTelephoneCall, TransferData, Open/CloseTCPConnection) at 75:5FFC-6083; ISPLogin/WriteConfigurationData/DNSQuery templates are shorter than 6 bytes and not searched |
| 75:6084.. | `Unknown_112089`.. | timer table and the ASCII protocol strings: `HELO`, `MAIL FROM:<`, `RCPT TO:<`, `DATA`, `QUIT`, `USER`, `PASS`, `STAT`, `LIST/RETR/DELE 00000`, `TOP 00000 0`, `GET `, ` HTTP/1.0`, `User-Agent: CGB-`, `POST `, `Content-Length: ` |
| 75:7039.. | `Unknown_113001..` | HTTP response header names: `date:`, `Gb-Status:`, `Gb-Auth-ID:`, `WWW-Authenticate: GB00 name="`, `Content-Type: application/x-cgb`, `URI-header:`, `Location:`, `Content-Length: 0` |
| 75:7A17, 7A32 (256 B), 7B40, 7B50 (256 B) | `Unknown_113a55` (`Authorization: GB00 name="`), `Unknown_113a70`, `Unknown_113b7e` (MD5 init 01 23 45 67 89 AB CD EF FE DC BA 98 76 54 32 10), `MD5_K_Table` | authentication/MD5 material; 75:7A32 and 7B50 are exact 256-byte copies |
| 0F:4004-4232 | `String_114004..String_114232` | mail header strings (`From:`, `Sender:`, `Reply-To:`, `Subject:`, `MIME-Version: 1.0`, `X-Game-code: CGB-`, `X-GBmail-type: exclusive`, `Content-Type: text/plain; charset=iso-2022-jp` / `multipart/mixed; boundary="` / `Application/Octet-Stream; name="`, `Content-Transfer-Encoding:Base64`, upper-case variants, `=?ISO-2022-JP?B?`) |

Ambiguous data rows (`EnvironmentColorsPointers.DungeonColors`, `Zipcode_CharPool_Ato9_Blank`, `Pokered_MonIndices`) are
generic byte ramps and are **not** evidence. `crystal_raw_runs.tsv` also lists the shared runs that are not
label-aligned (e.g. 41:68DB overworld-font tile bytes vs Trainer 62:5B6C/66:59EC: 8 distinct bytes, generic
1bpp font rows - not evidence of shared graphics).

### 3.4 Bank-0 glue: the Trainer's version of `home/mobile.asm` (hand analysis, PROBABLE)

`crystal_match.py` finds these only structurally (`structural_aligned`, HYPOTHESIS).

| Trainer | Crystal (home/mobile.asm, 00:3E32..) |
| --- | --- |
| 00:0150 | `MobileAPI` |
| 00:018D | `ReturnMobileAPI` |
| 00:01B7 | `Serial::` mobile branch + `MobileReceive` |
| 00:01ED | `MobileTimer` |
| 00:0247 | `Function3ed7` |

Differences from Crystal (CONFIRMED): bank switching writes `$2000`/`$3000` (MBC5) with a 16-bit current bank in HRAM
`FF8A/FF8B` (Crystal: `rst Bankswitch`, one byte in `hROMBank`); no `hMobile`/`hMobileReceive` gating; the
interrupt vectors `$0040..$0060` in Trainer are `jp $CBF1/$CBF4/$CBF7/$CBFA/$CBFD`, i.e. RAM trampolines filled in by
00:04A0-04D7: `$CBF1` -> `jp $03BA`, `$CBF4` -> `reti`, `$CBF7` -> `jp $01ED`, `$CBFA` -> `jp $01B7`, `$CBFD` -> `reti`
(CONFIRMED bytes). Crystal's vectors are ROM `jp`s. The Trainer's design therefore answers "same serial/timer
interrupt logic as Crystal?": the *SDK-side* logic (`_MobileReceive`, `_Timer`) is the same code, the *dispatch* to it is
Trainer-specific.

### 3.5 Application call sites and the API index (`crystal_api_calls.tsv`)

Trainer bank 0x67 and 0x68 contain 52 `call $0150` (MobileAPI) sites (27 in bank 0x67 at 67:547A..652E, 25 in bank 0x68 at
68:4DD7..7D0C); each loads an API byte into A (`ld a,$xx` within the preceding 6 instructions). Crystal idiom preserved:
MOBILEAPI_01 (`ld a,$02`) is called in all 9 cases as `ld de,$C271 / ld hl,$0067` (bank 0x67 sites) or `ld hl,$0068` (bank 0x68
sites): the caller's own bank, like Crystal's `ld hl,$40`/`$46` calls (PROBABLE meaning of HL; the bytes are CONFIRMED).
Usage by A byte (Crystal constant): 36 = MOBILEAPI_1B x18, 02 = _01 x9, 04 = _02 x5, 0A = _05 x4, 34 = _1A x3, 0E = _07 x2,
38 = _1C x2, and one call each of 00 (_00), 06 (_03), 0C (_06), 10 (_08), 1C (_0E), 1E (_0F), 2A (_15), 2C (_16), 3E (_1F)
(table with Trainer entry addresses in `crystal_mobile_reference.md`, section 3). PROBABLE for the
identification of the wrapper (3.4), CONFIRMED for the byte values and their Crystal constant names.

### 3.6 What does not match

* Crystal's home routines (`CopyBytes`, `ByteFill`, text engine, joypad, ...) have no counterpart in Trainer bank 0:   Trainer's bank 0 is not pokecrystal code (it uses `hROMBank`-like variables at different addresses, `$2100` as bank write   in some places and `$2000/$3000` in others).

## 4. Do Trainer and Crystal share the SDK "layout"?

| aspect | shared? |
| --- | --- |
| library in its own bank(s) | yes (structure), no (bank numbers) |
| function order inside the library | yes |
| WRAM state block and packet buffers | yes, relocated |
| command tables / packet templates | yes (byte-identical) |
| API dispatch table | yes, 34 slots, order kept, slot 31 differs |
| serial byte engine (`_MobileReceive`) and timer (`_Timer`) | yes, same code |
| interrupt dispatch and bank switching (home) | no: MBC5, RAM vectors, no `hMobile` gate |
| build revision | different |

## 5. Importing names: rules used and caveats

* `crystal_symbol_map.tsv` rows with `status` CONFIRMED (same code, unique, >= 24 unmasked bytes) or PROBABLE are safe *as   candidates*; rows named `Function1100b4`-style carry no information beyond the address, and `local_label_of:*` rows   give instruction-verified addresses of Crystal local labels (`.loop`, `.asm_...`).

* Descriptive Crystal names that are worth importing first (PROBABLE unless CONFIRMED): 75:4000 `MobileSDK_CopyBytes`, 4007   `MobileSDK_CopyString` (7-8 byte memcpy-style bodies, identity from 49 / 16 confident callers, not from their bytes),   400F `MobileSDK_CopyStringLen` (CONFIRMED), 4030 `_MobileAPI`, 40DC   `MobileAPI_SetTimer` (CONFIRMED), 448A `Mobile_DialTelephone` (CONFIRMED), 554A `MobileAPI_TelephoneStatus`, 56D2   `_MobileReceive`, 58EA `_Timer` (CONFIRMED), 5D42 `ParseResponse_BeginSession` (CONFIRMED), 5E34 `GetErrorCode` (CONFIRMED),   5F10 `PacketSendBytes` (CONFIRMED); data: 75:4070 API table, 5FFC.. packet templates, 4FDE/5025 upload/ranking URLs,   7B50 `MD5_K_Table` (CONFIRMED); bank 0 (manual overlay): 00:0150 `MobileAPI`, 018D `ReturnMobileAPI`, 01ED `MobileTimer`.

Removed by the review from this list: `ResetReceivePacketBuffer` (75:4029), `PacketSendEmptyBody` (75:5F08),   `Mobile_EndSession` (75:6264): 3-8 byte stubs with 1-5 unmasked bytes, address correspondence PROBABLE by call   edges but nothing supports the purpose-name; keep them as `Function_75_xxxx` until Trainer evidence exists.

* Crystal names are English guesses by the community ("Mobile_DialTelephone" is not a Nintendo symbol); Nintendo's own   names are unknown.

* The RAM names: Crystal's WRAM has overlapping unions, so the primary name in `crystal_ram_map.tsv` prefers   `wMobile*`/`wcXXX`/`w5_` labels, offsets like `wc829+1` are byte offsets inside a field, and all aliases are listed.

## 6. Limitations and next steps

* Suggested consumers: `config/regions/bank75.tsv` (code 75:4000-7F45 as SDK, data spans from `crystal_coverage.tsv`), `bank0F.tsv`   (0F:4000-5DAD), `config/ram` (SDK block C69F-CAEE, D000-D01F), `config/symbols/bank75.tsv`/`bank0F.tsv` (rows with   status CONFIRMED/PROBABLE only), and the application analysts of banks 0x67/0x68 (API index table above).

## 7. Files, columns and re-running

`python3 tools/crystal_match.py` (about 45 s; inputs and paths are in its docstring; `--refs eng` skips ptbr; `--out DIR`
writes elsewhere; `--selftest`; `--diff UNIT [--at BB:AAAA]`). All TSVs skip lines starting with `#` (the header line is
one).

Side-by-side disassembly of `MobileSDK_CopyStringLen` (75:400F),   `Mobile_DialTelephone` (75:448A), `Function111664` (75:5671, the weakest HIGH, 24 bytes), `_Timer` (75:58EA),   `Function113281` (75:72B9), `_MobileAPI`/`Function110115`/`Function110236` (75:4030/4115/4235): masked operands really are   absolute WRAM/ROM addresses or bank-relative jump/call targets (e.g.

* Bank 0x75 = Crystal 0x44 and bank 0x0F = Crystal 0x45 mail library (CONFIRMED). 0F:5DAE-7FFF and 75:7F46-7FFF are $00.

* API table at 75:4070: all 34 words read from the ROM; per-region offsets +0/-1/-3/+5/+9/+13 agree with the function   bodies; slot 31 = 43A9 (8-byte prologue `ld de,$C6D5 / ld b,8 / call $4000`, then falls into 75:43B1) CONFIRMED.

* Interrupt vector trampolines 00:04A0-04D7 and the MBC5 bank switching in 00:0150-0247 CONFIRMED (bytes read).

The bank-0 wrappers are PROBABLE analogues of `home/mobile.asm` (same shape, not byte-identical).

* 52 call sites of `call $0150` (banks 0x67 x27, 0x68 x25, none elsewhere; each preceded directly by `ld a,$xx`), API   byte histogram, and `ld de,$C271 / ld hl,$0067|$0068` before every `ld a,$02` CONFIRMED.

* Protocol data present in 75:4FB9.., 75:5FFC.., 75:7A32/7B50 (MD5 K = `78a46ad7 56b7c7e8 ...`, a public constant table),   0F:4062/40BC/4143 and the Trainer-specific `X-Game-title: MOBILE TRAINER` at 0F:4074: bytes CONFIRMED.

* Downgraded to LOW/HYPOTHESIS by `demote_weak_short` (tool rule added, output regenerated): `Function1113f7` (Trainer   75:5404, 1 unmasked byte) and `Function1113f8` (75:5405, 4 bytes): the two-unit run (5 unmasked bytes) occurs at 2 places in   Trainer by its own bytes, one confident caller points at it, and its only neighbour is the other demoted unit.

`Function1154d4` (0F:54D8; only 5 unmasked bytes of 108 instructions match from the entry)   and `Function1113fe` (75:540B; 3 unmasked bytes of 78 instructions) are HYPOTHESIS; short whole-unit stubs that are   adjacent to confident neighbours at the same offset stay PROBABLE.

* Data matches: 'CONFIRMED' for the protocol data applies to the HIGH rows (`Unknown_113a70`, `MD5_K_Table`, upload/ranking   URL, `Unknown_1132dd`); the download/utility URLs (AMBIGUOUS), `URIPrefix`, `date:` (LOW) and the many 6-14 byte   paired-bank strings/templates (MEDIUM) are position-based.
