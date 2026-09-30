# Mobile Trainer <-> Pokemon Crystal cross-reference

> **Historical note.** Written when the source was one generated `src/bankNN.asm` per bank with generic `Label_BB_AAAA` labels.  In the current tree (`home/ engine/ data/ gfx/ audio/ lib/`) a `Label_BB_AAAA` that is only used inside its own function is a local label of that function (`.lAAAA`, `AAAA` = the address, or `.loop`/`.done`/`.skip`); one referenced from elsewhere keeps its global name; `Function_BB_AAAA`, `Data_BB_AAAA`, ... are unchanged, and where a semantic name was adopted the neutral name often remains as an alias label under it.  **Addresses (`bank:addr`) remain valid**: find the code with `grep -rn '; BB:AAAA' --include=*.asm .` or in `build/mobile_trainer.sym`.  Commands of the frozen bootstrap pipeline quoted here (`make regen`, `make verify`, `make tree*`, `tools/gen_asm.py ...`) no longer apply to the source (`gen_asm.py` only runs into a temp dir, `make legacy-check`); see `README.md`, "History", and `docs/README.md`.

Scope: find code and data in Mobile Trainer (`baserom.gbc`, SHA-256 `6d802e66...6570`) that is the same as
code/data in the Pokemon Crystal ROMs (the Crystal ROM contains the Mobile Adapter GB SDK), use the matches to
import names, and describe the shared library structure. Tool: `tools/crystal_match.py`. Outputs:
`analysis/crystal_*.tsv` (see section 7). Architecture notes on the Crystal side:
`docs/research/crystal_mobile_reference.md`.

Evidence vocabulary: CONFIRMED / PROBABLE / HYPOTHESIS as defined for the project. A byte-identical (masked)
routine is CONFIRMED to be *the same code*. **Every name imported from Crystal comes from the Crystal community
disassembly, not from Trainer**; where a Crystal name is recorded in a TSV the evidence column says so. Names
must be treated as PROBABLE for the *purpose* of the routine at best, and never override an honest
`Function_<bank>_<addr>` unless the importing agent checks the local evidence.

## 0. Summary (all statements are backed by section 3; numbers come from `analysis/crystal_stats.json`)

1. Trainer contains the Mobile Adapter SDK as **two self-contained library banks**: Trainer bank **0x75** = Crystal
   bank 0x44 (`Mobile Adapter SDK`, `lib/mobile/main.asm`) and Trainer bank **0x0F** = Crystal bank 0x45 first part
   (`Mobile Adapter SDK Mail`, `lib/mobile/mail.asm`). CONFIRMED (independently re-derived by the adversarial review, see
   section 8). 276 confident (HIGH/MEDIUM) records tie Crystal code units to Trainer: 190 in 44->75 (81 HIGH, 109 MEDIUM)
   and 86 in 45->0F (54 HIGH, 32 MEDIUM); 135 are HIGH in total (byte-identical after masking, >= 24 unmasked bytes, unique in
   both ROMs). Only the HIGH records carry the byte evidence on their own; MEDIUM records with < 24 unmasked bytes are
   PROBABLE only through context (adjacent to HIGH neighbours at the same offset, or >= 2 confident callers).
2. The libraries are the same code at a *different revision/build*: functions moved by +0..+56 bytes inside bank 0x75
   (+4/+21 in bank 0x0F), a handful differ (`jr` vs `jp`, an extra 8-byte prologue for API slot 31, `X-Game-title:
   MOBILE TRAINER` in the mail header table, MBC5 16-bit bank handling). CONFIRMED (bytes cited below).
3. The 34-entry Mobile API dispatch table is at **75:4070** (relocated copy of Crystal `_MobileAPI.dw`), 22 of the
   23 entries that can be pinned by matched functions agree with the byte matches; slot 31 differs (the tool's earlier
   text 21/22 was a miscount; re-derived: all 34 words follow the per-region offsets of the function bodies, slot 31
   is the only exception). CONFIRMED.
4. The SDK state block in WRAM is the Crystal block relocated: Crystal `$C800..` -> Trainer `$C6A0..` (delta -$160
   for wc805..wc820, then -$161/-$163 for later fields; WRAMX `$DC00..` -> `$D000..`). Exception: the flag byte `wc821`
   (Crystal `$C821`) sits at the *start* of the Trainer block, `$C69F` (delta -$182; re-derived from
   `Function110115`, `ld hl,$C821` -> `ld hl,$C69F`), so the Trainer layout is a re-ordering, not a pure shift. The
   init routine clears `$0450` bytes from `$C69F` (75:4247/424A) and the reset routine `Function11162d` clears `$0450`
   from `$C6A0` (75:564E/5651). 100 RAM addresses are mapped by >= 3 independent matched functions each
   (`analysis/crystal_ram_map.tsv`, PROBABLE; the review's HIGH-only recount found no conflicting vote for any of
   them, but 5 of the 100 rely on MEDIUM matches only).
5. Trainer's bank-0 glue for the SDK (`MobileAPI`, `ReturnMobileAPI`, serial handler, `MobileTimer`) is *not*
   byte-identical to Crystal's `home/mobile.asm` (rewritten for MBC5) but has the same shape, the same order and the
   same call targets: 00:0150, 00:018D, 00:01B7, 00:01ED (PROBABLE, hand analysis, section 3.4). The 52 call sites of
   the `MobileAPI` wrapper are in Trainer banks **0x67 and 0x68** (the application banks).
6. **Nothing else** in Trainer matches Crystal code at the tool's sensitivity: outside banks 0x75/0x0F there is no HIGH
   or MEDIUM code hit (CONFIRMED as a statement about the tool output; an independent sliding-window scan of every
   instruction offset of both ROMs - 20 instructions, >= 30 unmasked bytes, >= 10 distinct values - also found shared
   windows only in Trainer banks 0x75 and 0x0F). That Trainer's home code, text engine and menus are not pokecrystal
   code is PROBABLE (absence of evidence below that sensitivity, section 3.6).

## 1. Material inventory

Everything below was found on this machine; nothing was modified.

| id | file | what | used as |
|---|---|---|---|
| eng | `.../Pokemon Crystal English Project/pokecrystal.gbc` + `.sym` (58 387 symbols) + `.map` | build of `pokecrystal-mobile-eng` (`PM_CRYSTAL`, `BXTE`, MBC3+timer+RAM, 2 MiB), SHA-1 `fd05085758ec344cca6424b535e24686efd31594` (the same bytes are also `aaaaa/baseroms/us/baserom-us.gb` and `MAGB-TestSuit/emulador/pokecrystal.gbc`) | **primary reference** |
| eng-src | `.../Pokemon Crystal BR/comparativo/pokecrystal-mobile-eng/` (also `-eng-old -fra -ger -ita -spa`, no builds) | pokecrystal fork "to restore and localize Mobile Adapter functionality ... using disassembled code from the Japanese ROM" | source of label kinds (code vs data), MOBILEAPI constants, documentation |
| ptbr | `.../Pokemon Crystal BR/pokecrystal-mobile-ptbr/pokecrystal.{gbc,sym,map}` | same mobile code with pt-BR text, SHA-1 `bafd36195500790df3f63a6534e39d6a78e5b69d` | cross-check: **every one of its 420 live records is identical to eng** (same unit, same Trainer address, same class) - it adds no independent information |
| jp | `.../aaaaa/baseroms/jp/baserom-jp.gb` (`PM_CRYSTAL`, `BXTJ`, destination 0x00 = Japan), SHA-1 `95127b901bbce2407daf43cce9f45d4c27ef635d` | **Japanese Crystal ROM exists** on this machine; no symbols/source | second search target: for every confident Trainer hit the same Crystal unit is searched in the JP ROM: **226 of 226 are byte-identical (masked) in JP** (the other 52 records are guided/aligned ones, not tested) |
| us | `.../Pokemon Crystal BR/Pokemon - Crystal Version (USA).gbc` (SHA-1 `f4cd194bdee0d04ca4eac29e09b8e4e9d818c133`; a byte-identical copy `- Copia`; Rev 1 `f2f52230b536214ef7c9924f483392993e226cfb`) | retail builds (they contain the retail mobile code), no symbols | only as a positive control (below); NOTE it is a different file from the `eng` ROM (`fd0508...`) |
| - | `.../MobileAdapterGB/libmobile/` | open adapter-side protocol library | cross-check of the packet framing |
| - | `.../MobileAdapterGB/MAGB-TestSuit/emulador/Mobile Trainer(English).gbc` | a 2 MiB ROM with the *same header* as Trainer (`M-TRAINER`, `B9AJ`) that differs from `baserom.gbc` in 122 298 bytes in 55 banks (0x00 [header checksum only], 0x0E, 0x19-0x1A, 0x1D-0x1E, 0x22-0x2F, 0x3D-0x3F, 0x42-0x44, 0x47, 0x4A-0x4B, 0x4D, 0x50-0x51, 0x53-0x54, 0x56-0x58, 0x5B-0x61, 0x63, 0x65-0x66, 0x6A-0x6C, 0x70-0x73, 0x7F) - evidently a modified (translated) build. The non-empty banks that are byte-identical in it include the SDK banks **0x0F and 0x75** and the application banks 0x67/0x68 | **not analysed** (outside this task); useful later to tell text/graphics banks from code banks |

Not available: a Japanese Crystal symbol table, the SDK's original source, a rebuild of the Crystal tree (it needs
rgbds 0.6; the installed 1.0.3 was not tried). No emulator was used.

Which Crystal version is the closest relative? The SDK in the eng build is byte-identical (masked) to the SDK in the
JP ROM for every routine that matches Trainer, so eng = JP for this purpose. Trainer's SDK is a *third* revision
that differs from both by the deltas in 3.1. (HYPOTHESIS: Trainer's is older or newer; nothing here dates it.)

## 2. Method and validation

Details are in the docstring of `tools/crystal_match.py`. In short: cut the reference into code chunks and data
regions (labels from the `.sym`, code/data classification from the sources, 5 163 code units of >= 12 unmasked
bytes); decode with `tools/sm83.py`; mask the 16-bit operands of jp/call/ld r16,imm16/ld [a16]/ld a,[a16] and the
`ldh` operand; keep opcodes, `jr` offsets and imm8 literally (imm8 may differ as "soft" difference); seed with
literal byte runs (`bytes.find`), verify instruction by instruction; report uniqueness against both ROMs.

Validation performed (all reproducible):

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

Confidence classes (`crystal_matches.tsv`, column `confidence`): HIGH = full unit, no imm8 difference, >= 24 unmasked
bytes, exactly one Trainer hit and no exact duplicate inside the Crystal ROM; MEDIUM = the same with 12..23 bytes,
or imm8-only differences, or promoted by (a) the order-preserving layout of neighbouring HIGH anchors, (b) membership in
a contiguous block matched at constant offset, (c) >= 2 independent confident callers whose call operand points at
this address, or a skeleton-aligned run covering >= 85 % with >= 40 unmasked bytes. Review rule (`demote_weak_short`): a
full-unit hit with < 24 unmasked bytes keeps MEDIUM only via (b)/(c) as defined in section 8; 115 of the 141 MEDIUM
records have < 24 unmasked bytes of their own (72 have < 12; many are 1-10 byte stubs), so **MEDIUM means "same code by context", not
"same code by its own bytes"**. LOW = short/ambiguous/low
information; AMBIGUOUS = long but several Trainer hits or Crystal duplicates; REJECTED = alternative hit refuted by
layout. `status` maps HIGH->CONFIRMED, MEDIUM->PROBABLE, others->HYPOTHESIS (the *same-code* claim).

## 3. Results

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

`analysis/crystal_data_matches.tsv`, `crystal_ptr_tables.tsv`, `crystal_raw_runs.tsv`. Highlights (CONFIRMED/PROBABLE as
marked in the TSV):

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

`crystal_match.py` finds these only structurally (`structural_aligned`, HYPOTHESIS). Manual verification (bytes read
with `python3 tools/sm83.py baserom.gbc <off> <len>`) is recorded in `analysis/crystal_symbol_map_manual.tsv`:

| Trainer | Crystal (home/mobile.asm, 00:3E32..) | evidence |
|---|---|---|
| 00:0150 | `MobileAPI` | ends in `jp $4030` = `_MobileAPI` (75:4030, masked match); starts `cp $02; ld [$C825],a; ld a,l; ld [$C823],a; ld a,h; ld [$C824],a; jr nz` = Crystal's first 7 instructions with operands shifted by -$163; `set 6,[$C6C1]` = `set 6,[wc822]`; 52 callers |
| 00:018D | `ReturnMobileAPI` | follows `MobileAPI`; stores A/L/H, pops and restores the bank, `res 6,[$C6C1]`, reloads HL/A |
| 00:01B7 | `Serial::` mobile branch + `MobileReceive` | serial RAM vector `$CBFA` = `jp $01B7` (00:04C8-04D6); pushes AF-HL, switches to bank 0x75, `call $56D2` (= `_MobileReceive`), restores, `reti` |
| 00:01ED | `MobileTimer` | timer RAM vector `$CBF7` = `jp $01ED` (00:04B9-04C7); `xor a; ldh [rTAC],a; ldh a,[rIF]; and $1B; ldh [rIF],a; ld a,[$C709] (=wc86a); or a; jr z; ... call $58EA (= _Timer)`; ends `ldh a,[rTMA]; ldh [rTIMA],a; ld a,$06; ldh [rTAC],a; ... reti` |
| 00:0247 | `Function3ed7` | HYPOTHESIS: same shape, unreferenced in both ROMs, calls 0F:4247 (= Crystal 45:4243) |

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

* Trainer banks other than 0x75/0x0F: 0 HIGH and 0 MEDIUM code hits (also for the review's independent window scan, see summary point 6); only LOW/AMBIGUOUS noise (generic gfx/data byte runs,
  the 10-byte OAM DMA routine `OAMDMACode` at Trainer 00:05AC = Crystal 01:403F with one imm8 difference: HYPOTHESIS,
  standard idiom).
* Crystal's home routines (`CopyBytes`, `ByteFill`, text engine, joypad, ...) have no counterpart in Trainer bank 0:
  Trainer's bank 0 is not pokecrystal code (it uses `hROMBank`-like variables at different addresses, `$2100` as bank write
  in some places and `$2000/$3000` in others).
* The game-specific Crystal mobile code (`mobile_40.asm`, `mobile_46.asm`, ... 40 000 lines) has no Trainer counterpart except the
  *call pattern* into the SDK.

## 4. Do Trainer and Crystal share the SDK "layout"?

| aspect | shared? | evidence |
|---|---|---|
| library in its own bank(s) | yes (structure), no (bank numbers) | Trainer 0x75 / 0x0F (each alone in the bank) vs Crystal 0x44 / 0x45 (first 7 KB) |
| function order inside the library | yes | monotone offsets in 3.1/3.2 |
| WRAM state block and packet buffers | yes, relocated | `crystal_ram_map.tsv`; `wMobileSDK_PacketBuffer` CB47 -> C9E4, `wMobileSDK_ReceivePacketBuffer` CA3C -> C8D9, `wMobileAPIIndex` C988 -> C825; block $0450 vs $0452 bytes |
| command tables / packet templates | yes (byte-identical) | 3.3 |
| API dispatch table | yes, 34 slots, order kept, slot 31 differs | `crystal_ptr_tables.tsv` |
| serial byte engine (`_MobileReceive`) and timer (`_Timer`) | yes, same code | 3.1 |
| interrupt dispatch and bank switching (home) | no: MBC5, RAM vectors, no `hMobile` gate | 3.4 |
| build revision | different | jr/jp choices, extra prologue, header strings |

## 5. Importing names: rules used and caveats

* `crystal_symbol_map.tsv` rows with `status` CONFIRMED (same code, unique, >= 24 unmasked bytes) or PROBABLE are safe *as
  candidates*; rows named `Function1100b4`-style carry no information beyond the address, and `local_label_of:*` rows
  give instruction-verified addresses of Crystal local labels (`.loop`, `.asm_...`).
* Descriptive Crystal names that are worth importing first (PROBABLE unless CONFIRMED): 75:4000 `MobileSDK_CopyBytes`, 4007
  `MobileSDK_CopyString` (7-8 byte memcpy-style bodies, identity from 49 / 16 confident callers, not from their bytes),
  400F `MobileSDK_CopyStringLen` (CONFIRMED), 4030 `_MobileAPI`, 40DC
  `MobileAPI_SetTimer` (CONFIRMED), 448A `Mobile_DialTelephone` (CONFIRMED), 554A `MobileAPI_TelephoneStatus`, 56D2
  `_MobileReceive`, 58EA `_Timer` (CONFIRMED), 5D42 `ParseResponse_BeginSession` (CONFIRMED), 5E34 `GetErrorCode` (CONFIRMED),
  5F10 `PacketSendBytes` (CONFIRMED); data: 75:4070 API table, 5FFC.. packet templates, 4FDE/5025 upload/ranking URLs,
  7B50 `MD5_K_Table` (CONFIRMED); bank 0 (manual overlay): 00:0150 `MobileAPI`, 018D `ReturnMobileAPI`, 01ED `MobileTimer`.
  Removed by the review from this list: `ResetReceivePacketBuffer` (75:4029), `PacketSendEmptyBody` (75:5F08),
  `Mobile_EndSession` (75:6264): 3-8 byte stubs with 1-5 unmasked bytes, address correspondence PROBABLE by call
  edges but nothing supports the purpose-name; keep them as `Function_75_xxxx` until Trainer evidence exists.
* Crystal names are English guesses by the community ("Mobile_DialTelephone" is not a Nintendo symbol); Nintendo's own
  names are unknown. The purpose of unnamed functions is undocumented in Crystal too.
* The RAM names: Crystal's WRAM has overlapping unions, so the primary name in `crystal_ram_map.tsv` prefers
  `wMobile*`/`wcXXX`/`w5_` labels, offsets like `wc829+1` are byte offsets inside a field, and all aliases are listed.
  A `PROBABLE` RAM row means >= 3 independent matched functions use the same Crystal address at the same position in
  code that corresponds; it is **not** proof that the field has the Crystal meaning.
* `hSRAMBank` (`ldh [$FF8C]`) maps to itself (32 functions): Trainer writes `$FF8C` next to `ld [$4000],a`, the same SRAM-bank
  idiom (PROBABLE). (Retracted by the review: the earlier remark that Crystal `hInMenu` ($FFAA) 'maps to two different Trainer values (conflict, in
  the weak file)' - the weak file has no such row; the only `FFAA` operand pairs in `crystal_operands.tsv` come from LOW
  hits of generic code fragments (Trainer 65:4BB8..) and are noise, not a mapping and not a conflict.)

## 6. Limitations and next steps

* Code/data classification of Crystal labels comes from source scanning (6 942 code units) and a decoding heuristic
  (2 727 units); a mistaken cut only weakens a signature.
* The `.sym` (built 2025-09-10) and the source tree (last commit 2025-05-09, modified working tree) may differ; the source is
  used only for label kinds/constants. The selftest and the exact JP match show the sym matches the ROM bytes.
* 249 of 7 419 Crystal units (sig >= 6) matched anywhere; 1 179 units had no literal seed and were searched with a slower
  regex fallback (7 additional hits). Units of < 6 unmasked bytes are not searched at all.
* 'structural' and 'aligned' results (different code generation) are inherently weaker; they are labelled and capped.
* Not done: matching Trainer against the Nintendo Stadium/other SDK consumers; deriving Nintendo-level names; the
  English Trainer build; tracing what the Trainer stores in the SDK buffers (application layer, banks 0x67/0x68 etc.).
* Suggested consumers: `config/regions/bank75.tsv` (code 75:4000-7F45 as SDK, data spans from `crystal_coverage.tsv`), `bank0F.tsv`
  (0F:4000-5DAD), `config/ram` (SDK block C69F-CAEE, D000-D01F), `config/symbols/bank75.tsv`/`bank0F.tsv` (rows with
  status CONFIRMED/PROBABLE only), and the application analysts of banks 0x67/0x68 (API index table above).

## 7. Files, columns and re-running

`python3 tools/crystal_match.py` (about 45 s; inputs and paths are in its docstring; `--refs eng` skips ptbr; `--out DIR`
writes elsewhere; `--selftest`; `--diff UNIT [--at BB:AAAA]`). All TSVs skip lines starting with `#` (the header line is
one).

| file | content |
|---|---|
| `crystal_matches.tsv` | one row per (Crystal unit, Trainer location): `ref crystal_symbol crystal_bank crystal_addr crystal_len sig_bytes trainer_bank trainer_addr matched_bytes match_kind insns_matched imm8_diffs n_trainer_hits n_crystal_dups confidence status jp_crystal_match layout notes` (`match_kind`: exact_masked, masked_imm8diff, partial, aligned, guided_full/partial, structural_aligned) |
| `crystal_symbol_map.tsv` | `crystal_symbol trainer_bank trainer_addr length match_kind status evidence` (functions, instruction-verified local labels, call-edge-only callees, pointer-table entries) |
| `crystal_symbol_map_manual.tsv` | hand-verified overlay for bank-0 glue (**not** regenerated by the tool) |
| `crystal_ram_map.tsv` / `_weak.tsv` | `crystal_symbol crystal_addr trainer_addr region delta independent_functions status evidence crystal_aliases`; the weak file has < 3 supports or conflicts (do not import) |
| `crystal_operands.tsv` | every masked operand pair (`operand_kind`: jp/call/imm16/mem/ldh/imm8/imm8pair) with both values and the Crystal name at the value |
| `crystal_data_matches.tsv`, `crystal_ptr_tables.tsv` | data/strings/tables and relocated pointer tables (entry level) |
| `crystal_coverage.tsv` | merged Trainer byte ranges explained by confident matches (`kind` code/data) |
| `crystal_api_calls.tsv` | Trainer call sites of `MobileAPI` with the A byte, Crystal constant and table entry |
| `crystal_raw_runs.tsv` | label-independent shared runs >= 32 bytes (>= 8 distinct values) |
| `crystal_stats.json` | parameters, hashes, counts, ptbr cross-check |

## 8. Adversarial verification (independent re-derivation) - what survived, what was changed

Method: the reviewer re-derived the claims from the raw ROM bytes with its own masker and decoder wrapper (not the
tool's matcher) and re-ran the tool from scratch. Statuses below are the reviewer's.

Survived (independently reproduced):
* All 135 HIGH records: masked-identical, unique in Trainer and Crystal, >= 24 unmasked bytes; the same masked patterns
  exist once in the JP Crystal ROM (135/135). Side-by-side disassembly of `MobileSDK_CopyStringLen` (75:400F),
  `Mobile_DialTelephone` (75:448A), `Function111664` (75:5671, the weakest HIGH, 24 bytes), `_Timer` (75:58EA),
  `Function113281` (75:72B9), `_MobileAPI`/`Function110115`/`Function110236` (75:4030/4115/4235): masked operands really are
  absolute WRAM/ROM addresses or bank-relative jump/call targets (e.g. `ld a,[$C988]` -> `[$C825]`, `call $614E` -> `call $6149`).
  These are not common idioms: every pattern is unique in both ROMs.
* Bank 0x75 = Crystal 0x44 and bank 0x0F = Crystal 0x45 mail library (CONFIRMED). 0F:5DAE-7FFF and 75:7F46-7FFF are $00.
* API table at 75:4070: all 34 words read from the ROM; per-region offsets +0/-1/-3/+5/+9/+13 agree with the function
  bodies; slot 31 = 43A9 (8-byte prologue `ld de,$C6D5 / ld b,8 / call $4000`, then falls into 75:43B1) CONFIRMED.
* Interrupt vector trampolines 00:04A0-04D7 and the MBC5 bank switching in 00:0150-0247 CONFIRMED (bytes read).
  The bank-0 wrappers are PROBABLE analogues of `home/mobile.asm` (same shape, not byte-identical).
* 52 call sites of `call $0150` (banks 0x67 x27, 0x68 x25, none elsewhere; each preceded directly by `ld a,$xx`), API
  byte histogram, and `ld de,$C271 / ld hl,$0067|$0068` before every `ld a,$02` CONFIRMED.
* Protocol data present in 75:4FB9.., 75:5FFC.., 75:7A32/7B50 (MD5 K = `78a46ad7 56b7c7e8 ...`, a public constant table),
  0F:4062/40BC/4143 and the Trainer-specific `X-Game-title: MOBILE TRAINER` at 0F:4074: bytes CONFIRMED.
* 'No shared code outside 0x75/0x0F': reproduced with an independent window scan (see summary point 6).
* Pt-BR cross-check 420/420 identical; eng ROM = `aaaaa/baseroms/us/baserom-us.gb` = `MAGB-TestSuit/emulador/pokecrystal.gbc`
  (SHA-1 `fd0508...`); JP ROM SHA-1 `95127b90...`; `Mobile Trainer(English).gbc` differs from `baserom.gbc` in 122 298
  bytes in 55 banks, banks 0x0F/0x67/0x68/0x75 byte-identical (all reproduced).

Changed / downgraded / retracted:
* Retracted: "21 of the 22 pinned API-table entries agree" - the tool file has 23 pinned entries, 22 agree, 1 differs
  (slot 31). Corrected above.
* Downgraded to LOW/HYPOTHESIS by `demote_weak_short` (tool rule added, output regenerated): `Function1113f7` (Trainer
  75:5404, 1 unmasked byte) and `Function1113f8` (75:5405, 4 bytes): the two-unit run (5 unmasked bytes) occurs at 2 places in
  Trainer by its own bytes, one confident caller points at it, and its only neighbour is the other demoted unit. Consequences: MEDIUM 143 -> 141, 44->75 confident 192 ->
  190, confident total 278 -> 276, bank-0x75 covered bytes 13 971 -> 13 964.
* Pointer-table entries that were PROBABLE with 'callee bytes NOT verified' now have their callee body checked
  (`extend` from the table word). `Function1154d4` (0F:54D8; only 5 unmasked bytes of 108 instructions match from the entry)
  and `Function1113fe` (75:540B; 3 unmasked bytes of 78 instructions) are HYPOTHESIS; short whole-unit stubs that are
  adjacent to confident neighbours at the same offset stay PROBABLE.
* Claim 'Nothing else in Trainer matches Crystal code' was CONFIRMED only for the tool's output; the wider statement that
  Trainer's home code/text/menus are not pokecrystal code is PROBABLE (absence below the sensitivity).
* Data matches: 'CONFIRMED' for the protocol data applies to the HIGH rows (`Unknown_113a70`, `MD5_K_Table`, upload/ranking
  URL, `Unknown_1132dd`); the download/utility URLs (AMBIGUOUS), `URIPrefix`, `date:` (LOW) and the many 6-14 byte
  paired-bank strings/templates (MEDIUM) are position-based. The tool status in the TSV is authoritative.
* Not reproduced: the reported retail-US positive-control MEDIUM count (3 903) and JP count (3 628); HIGH counts 2 650 / 2 212
  are exact. Coverage percentages 95.8 % / 98.2 % / 98.8 % were not re-derived.
* Note on `crystal_matches.tsv`: for `partial` rows the `crystal_len`/`sig_bytes` columns describe the whole Crystal unit,
  while the Trainer run is `matched_bytes` long (e.g. `Function1154d4`: 79 of 219 bytes, 53 unmasked bytes in the run;
  `Function112271`: 134 bytes, 82 unmasked). Do not import partial rows as function starts.
* Note on `crystal_ram_map.tsv`: `wc821` is at Trainer `$C69F` (not `$C6A1`); a few entries (`wc835`, `wc97f`, `wMobileAPIIndex`,
  `$CBF9`, `$CBFF`) are supported only by MEDIUM matches; the Crystal alias names (e.g. `wLinkOTPartyMon2Type`,
  `w5_dc00+3`) come from Crystal's WRAM unions and mean nothing for Trainer.
