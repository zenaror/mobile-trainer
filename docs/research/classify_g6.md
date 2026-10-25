# Classifier 6/6: banks 1C 25 27 2C 2F 44 54 57 60 73 75

## 1. Result in numbers

| bank | before | after | main result |
|---|---:|---:|---|
| 1C | 4 | 4 | nothing provable (table stub bytes) |
| 25 | 1498 | 11 | 8 SRAM address tables, 2 x tile loads (1280 B), string-pointer table, attribute rows |
| 27 | 418 | 9 | 14 object tables + frame data, 5 code chains, one tilemap row |
| 2C | 1506 | 26 | 5 palettes, object tables, frame data, 512 B tiles, 3 SRAM-code routines |
| 2F | 2670 | 45 | tile blocks 61F0-69F0 (1975 B), tables, palettes, strings, code chains |
| 44 | 5706 | 0 | whole bank re-laid out as 4 scenes (tiles + tilemap + attributes + palettes) |
| 54 | 233 | 5 | month/BCD tables, strings, game ID, code chain |
| 57 | 77 | 0 | 2 functions, padding |
| 60 | 6590 | 0 | tile sheet |
| 73 | 156 | 0 | tilemap rectangles, string-pointer table, tiny functions |
| 75 | 853 | 1 | MD5 constants, URL/command/header strings, Mobile Adapter packets, 2 routines |

## 4. What stays UNCLASSIFIED and why (101 bytes, 32 spans)

The analysis scripts lived in the session scratchpad (`.../scratchpad/g6/`: `gen_edits.py` builds `edits.tsv` from the ROM with asserts for every byte-level claim, `apply.py` applies it to a copy of `config/`); they are not part of the repository.  The claims can be re-checked with
`python3 tools/gen_asm.py verify --config config`, `python3 tools/conventions_check.py --strict`, and by rendering tile spans with `tools/extract_gfx.py` / any 2bpp viewer.

Re-derived from ROM bytes / traces (not from the notes) and found correct: the 25:5A10/5E10 HDMA loads (`ld hl,$5A10 ; c=$40`, sites 25:4B5C/4B71 executed, dec-c block count `$40` x 16 = `$400`); the MD5 sine table (Python `int(abs(sin(i+1))*2**32)` equals the 256 bytes at 75:7B50 exactly), the IV bytes, the RFC 1321 shift column and message-word offsets of 75:7A32 (`i*4`, `(1+5i)%16*4`, ...), and the `ld hl` readers 75:76EE/78E5/77D0; bank 44 rendered as four scenes (tilemap indices index the 160 tiles, all four images are coherent screens with "START MENU / B BACK" labels), bank 60 rendered in full (real glyph and frame art up to 7A80, padding after), 25:5A10-6410, 2F:61F0-69F0 and 2C:6FD0 rendered; the SRAM address tables (progressions and `sla c ; ld hl,TABLE ; add hl,bc` readers, e.g. 25:4687 and 50CA, 2F:7F63); the object tables (all words inside the frame data, groups of four identical entries, `ld de,TABLE ; ld a,BANK ; ld b,$81 ; FarCall 00:0A82` callers, many executed); the attribute-row readers 25:5891 and 2F:4CAF (executed); the palette load sites; the text regions decoded with cp932; the month/BCD tables and their readers in bank 54; the 41 CONFIRMED code upgrades (all instruction starts are in `coverage_union.tsv`, convention-aware sweep).  Structural checks over the real config: no gap or overlap in the eleven banks, no executed instruction start in a non-code region, no illegal opcode, no direct branch/call/far-call target of any code region in these banks lands in a non-code region or mid-instruction, `gen_asm verify` IDENTICAL and `conventions_check --strict` 0 ERROR.

* **Downgraded to HYPOTHESIS (code kept as code, no entry evidence):** 2C:4760, 483F, 48F0 and 2F:5F28, 6007, 60B8 (5-instruction SRAM-disable epilogues), 2F:590B and 6F44 (6-instruction tails that an unconditional `jr` jumps over), 73:6143 (two tiny getters).

The other entry-less chains stay PROBABLE because each is either a function head / call-argument setup that falls into code seeded by far-call sites (27:4D06 4EC0 4EF5, 2C:5A12, 2F:50D3, 54:41C5), a sibling of executed functions and a caller of proven ones (2C:5FB1, 60B3 call 2C:614D/5E51/5CD2/665F), or reached by branches from another chain (2C:7450 group, 27:4D4E/4D81).  57:52D8 and 57:531E have a real entry: `ld de,$52D8/$531E ; ld a,$57 ; call $0A45` (00:0A45 stores a far pointer, here into object slot `$DA2B`) at 57:42C3, 5304 (and 43A9/4554 for 531E), so their "no entry" notes are stale (status stays PROBABLE, the sites are not executed).

* **Upgraded with evidence:** 2F:61F0/65F0/66F0 gfx to CONFIRMED (the three loads and their register setup at 2F:595A-598A are executed); palettes 2C:7F50, 2C:7F90, 2F:6CC0 to CONFIRMED (load sites 2F:51DA-51F6 and 2F:59B3-59BE are executed); 73:43AD and 73:4461 from HYPOTHESIS to PROBABLE (their addresses are stored to `$C10E/$C10F`, the attribute source read by `00:16A2`, at 73:6220/623B; static-reached).

* Not re-verified: the loader of bank 44/60 (searched for `ld a,$44/$60` sites, `00 40 44` byte patterns and far-call sites of `00:0749/0787/08EA` with those banks: none, consistent with the "no loader" claim; the four scenes stay PROBABLE on structure); the 5 short bank-60 HYPOTHESIS gfx pieces; frame-record field semantics; the 32 leftover stubs (checked: no reference to any of them, unchanged).

One header, 54:4CAD–4CB0, was stale: `Text_TruncateSjis` loads `String_Text_Ellipsis`, then passes it to `CopyString` or `CopyBytes` with BC=$0002.

The bytes `$81 $63 $00` are the Shift-JIS ellipsis and terminator already documented as CONFIRMED in `naming_g5.md`.

The 24:4BCC–4BCD header was also corrected from an internal “10 bytes” phrase to its actual one byte.

Two additional owners accounted for the 29-byte difference: `gfx/mail/body_view.asm` at `28:4BA6–4BC2` (28 bytes), and `lib/mobile/main.asm` at `75:6D62–6D63` (one byte).

A separate CONFIRMED two-byte interval at54:511B-511D had an internally contradictory UNCLASSIFIED comment.

`Data_Text_Ellipsis2` contains `$81,$63`; `Mail_CopyClampedEllipsis` loads that address and copies exactly two bytes through `CopyBytes`.

The main hypothesis-header cohort, frame editing contexts, name/image associations and Data_48_69AB reader investigation remain separate open questions.

- `26:5344–537C` is now the PROBABLE code fragment `MailSession_WriteVram1TileAndWram7ScreenRows`.

See [`japanese_generic_name_sweep_20261023.md`](japanese_generic_name_sweep_20261023.md) and [`REVERSE_ENGINEERING.md`](../../REVERSE_ENGINEERING.md). - `26:5062–5067` is `ByteMatch_MailSessionCancelTail_26_5062`; only byte equality with the preceding routine's tail is established.

A bounded static reader relationship is documented; content identity, intent, natural selection, and rendered output remain unknown. - `75:6D62–6D63` is `MaskedMatch_CrystalSDK_Local112D4C_75_6D62`.
