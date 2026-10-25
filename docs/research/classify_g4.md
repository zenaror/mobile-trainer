# Classifier 4/6 - banks 05, 0E, 19, 26, 28, 45, 4D, 4F, 52, 56, 5B, 63, 6A

## Bytes moved out of UNCLASSIFIED (by region kind, counted on the original span bytes)

| bank | spans | bytes | resolved as | remaining |
|---|---|---|---|---|
| 05 | 84 | 2046 | 1844 data (song/track stream), 202 words (channel-pointer tables) | 0 |
| 0E | 1 | 15 | 15 zero | 0 |
| 19 | 7 | 88 | 20 code, 3 text, 13 zero, 4 words, 48 data | 0 |
| 26 | 10 | 503 | 77 code, 16 text, 349 data (object database records) | 61 (2 spans) |
| 28 | 35 | 2812 | 1000 words, 1761 data, 23 zero | 28 (1 span) |
| 45 | 25 | 7432 | 5590 gfx, 1842 data (tilemaps and palettes) | 0 |
| 4D | 4 | 875 | 859 data, 16 words | 0 |
| 4F | 6 | 161 | 161 code | 0 |
| 52 | 1 | 14 | 14 gfx | 0 |
| 56 | 2 | 267 | 247 data, 20 words | 0 |
| 5B | 4 | 4422 | 4422 gfx | 0 |
| 63 | 1 | 4 | 4 words | 0 |
| 6A | 15 | 1073 | 383 gfx, 640 data, 8 zero, 24 words, 18 text | 0 |
| total | 195 | 19712 | gfx 10409, data 7590, words 1270, code 258, zero 59, text 37 | 89 |

### 1. Bank 05 is a song/track byte stream with pointer tables (PROBABLE)

The sweep tiles these spans exactly to the byte and every table pointer lands on a frame-table or script start:
`28:6E80-7A5D` (244 entries), `28:5210-54B0` (28), `28:4B70-4BA6` (4), `26:7B00-7D41` (56), `56:7880-79B8` + table `79B8-79D0` (6),
`4D:5D10-5D50` and `4D:7960-7983`, `63:7310-732F`, `19:481D-482B`, `6A:72A0-72BF`.  Each region has a note with the layout.
Unread table entries (12 of every 16 bytes) were the "UNCLASSIFIED" bytes between the 4-byte reads recorded in the traces for banks 28 and 05-like tables.
The exact size/type of `attr` bits is inferred from the OAM layout (PROBABLE); the routine 00:0AE8 that consumes it is documented in `boot_and_home.md`.

### 4. Palettes are 16 x 4 words (0x80) right after each tilemap

`28:4AF0`, `28:5EA0`, `28:6E00`, `45:x`, `6A:7220` and `26:7AC0` (8 palettes) follow the same layout as bank 45.  Several mapper "palette"
regions swallowed pointer words (`0x7Cxx`, `0x6Exx` have bit 15 clear like RGB555) and were cut back (`26:7ABC-7BE4`, `28:6E08-6EA0`,
`56:7836-7896`).  `56:77C0-7880` is one 24-palette block.

### 5. Code gaps (prologues before site-validated far calls)

`4F` (6 gaps: 428E, 434A, 4400, 4471, 44DF, 452A), `19:4000`, `19:4980`, and `26:443B/52AB/571F/5763/593F` are function heads whose decode chain
ends exactly at an already accepted region that starts with an inline far call (`call $06D1`), the previous byte is a `ret`/`jp`, and the
head matches executed functions (the `ldh [$FFF2],a / ldh a,[$FF8D] / push af ... ldh [$FF70],a` prologue of `4F:42B4`) or loads the address of
the string that follows (`26:571F`, `26:5763`).  Marked `code` PROBABLE with "entry unproven": no call, jp, far pointer or table word to
these heads was found (searched by raw bytes over the whole ROM).  Isolated complete routines with no fall-through into accepted code were
not accepted: `26:5062` (`ld a,$FF / ld a,$7F / ret`), `26:5344-537C` (push/pop-balanced routine ending in `ret`), `28:4BA6-4BC2`
(clears `$C000`/`$DA00` areas).  They stay UNCLASSIFIED with a note.

### 6. Other findings

* `4D:5AE0-5D10`: four 14x5 tilemaps (`0x8C` each) referenced by the word table at `67:491C` (`e0 5a 6c 5b f8 5b 84 5c`; `ld hl,$491C` at `67:4906`, `ld bc,$050E`); the mapper's two   `ptrtable` guesses at `5B0A/5B18` were tile indices.

`6A:6652-6672` are three menu tables of `(string, string)` pointer   pairs (first entry `0000 0000`) to Shift-JIS strings at `6672..66F5`, now `text`.

* `6A:6E20-7220`: 64 tiles (button glyphs "A すすむ B もどる") continuing the HDMA block `6A20-6E20`; the mapper cut it at an odd offset.

* `52:4080-4C00`: 184 text-image tiles (rows are `(ff, xx)` pairs, so tiles are 16-aligned at 4080, not 4071 as the mapper guessed).

* `5B:4000-5680`: 360 tiles of art; no loader call sites and no tilemap in the bank.

* `19:4D5E`: 16 full-width characters `０-９Ａ-Ｆ` (hex-digit table indexed by six code sites); `19:490E` 6-byte table indexed by twelve sites;   text strings at `19:452F`, `26:5575`, `26:5677`; zero padding runs (`0E:43B1`, `19:4933`, `28:42B7`, `28:4BC2`, `28:4E88`...).

## What remains UNCLASSIFIED

| span | bytes | why |
|---|---|---|
| 26:5062-5067 | 5 | `ld a,$FF / ld a,$7F / ret`; complete but no reference found |
| 26:5344-537C | 56 | balanced push/pop routine ending in `ret`; no caller, table word or far pointer found |
| 28:4BA6-4BC2 | 28 | clean routine (`ld b,$90 / ld hl,$C000 ...`), no reference; follows the last object script of `4B70` |

## Per-bank notes

* **05**: see section 1.  0 bytes remain.  84 spans; 45 tables; the rest is the track stream.  CONFIRMED reads inside are unchanged.
* **0E**: `43B1-43C0` zero padding.  (The `5F30-60A0` mapper palette block may hide object tables like bank 28; not re-analysed.)
* **19**: 7 spans - 2 code heads, 1 string, 1 object table + record, 1 6-byte table, 1 zero run, 1 hex-digit table.
* **26**: code gaps (443B, 52AB, 571F, 5763, 593F), strings (5575, 5677), the 7ABC-7D41 block (zero, palette, object database).  Two routines left.
* **28**: 244+28+4 table entries verified; palettes; zero paddings.  One routine left.
* **45**: section 2.
* **4D**: four 14x5 tilemaps, three 8x5 tilemaps, two object tables (`Table_4D_5D10`, `Table_4D_7960`).
* **4F**: six function heads.
* **52**: tile block re-aligned.
* **56**: palette block re-cut, object database `7880-79D0`.
* **5B**: whole tile sheet.
* **63**: object-table head.
* **6A**: section 6.

Guesses that failed: a 2D0 tilemap at `5B:5535` (scan false positive; the bytes are tile data).

* Object animation database: my own sweeper (frame table = words up to the first frame; frame = `count` + count x 4; script = `count` + count x 2) re-walks   `28:6E80-7A5D`, `28:5210-54B0`, `28:4B70-4BA6`, `26:7B00-7D41`, `56:7880-79D0`, `4D:5D10-5D50`, `4D:7960-7983`, `63:7310-732F`, `19:481D-482B` and `6A:72A0-72BF`   to the last byte, every table pointer hits a frame-table/script start, and every frame table / script that follows is referenced.

The routine 00:0AB8 was re-read: word 1 goes to slot+2/3, word 2 to slot+6/7 and script bytes 1,2 go to slot+4/5, and 00:0AE8 /   00:0B9D use the frame bytes as (Y, X, tile, attr & mask | mask), so the layout is consistent with the code.

The executed reads listed in `traces/detail/*/dataaccess.tsv`   (for instance 28:5214-5218, 5224-5228, 5234-5238, 5244-5248: one 4-byte entry each, always entry index 1 of a 16-byte row) agree with 4-byte entries.

* Bank 05: my scan found 45 `b1 NN KK` + words tables whose words all lie in 05:4000-68C3 and that are followed by `bf 7f bd` (45/45), plus a 46th table at 05:68BC (`b1 02 00`, words   `68A1`, `68B0`, both track starts) that is at the end of the stream.

All 46 header addresses (the NN byte, the byte before is `b1`) occur as words in the 8-byte song-table entries of   bank 04 (`00 c8 ff NN 00 <hdr> <bank 05>` at `04:5580`, stride 8, first word at 04:5585).

The executed reads of bank 05 are long sequential runs (`05:4000-401C`, `4047-4074`, ...) and the   first 8 bytes of each table, which fits a channel-start reader.

* Bank 6A: tilemaps (`6C:43DC/446D` re-disassembled: `ld hl,$4870` / `$4A14`, `ld bc,$00D2` or `ld a,$5A` = 21 x 10 or 9 x 10, `ld c,$0A` = 10 columns), the three pointer-pair tables at 6A:6652-6672 (all 8 non-null   pointers land on NUL-terminated Shift-JIS strings), the tile block 6A:6E20-7220 (renders "A すすむ B もどる").

Bank 4D 14x5 tilemaps confirmed by `ld bc,$050E` at 67:4903.

* Text: 19:452F (`81 A3` + NUL), 26:5575 (five full-width zeros), 26:5677 (`つう`), 19:4D5E (hex digit table: `and $0F ; add a,a ; ld hl,$4D5E ; ... ld a,[hli] ; ld [de],a` twice = one 2-byte character, at all six sites).

* Code heads: each decodes cleanly, the previous instruction is a `ret`/`jp` (or, for `19:4980`, data) and the decode chain ends exactly at an accepted far-call region; `26:571F` / `26:5763` repeat the executed   `26:57A7` pattern (string, then a function that loads the address of the string after the far call).

* Region hygiene: no holes or overlaps in the 13 files, no code region of the previous map became data, no executed instruction start in a data region, all labels follow `Kind_BB_AAAA` with BB/AAAA equal to the bank/start   and are unique, `gen_asm.py verify` IDENTICAL and `conventions_check.py` 0 ERROR (real config, after the corrections below).

* `19:490E`: the 6-byte extent and field layout are not established (entries are 4 bytes, so with a=1 the words would overlap `String_19_4914`); note downgraded to "layout HYPOTHESIS".

* `05:68BF-68C3`: documented as the 46th channel table (still data, CONFIRMED read).

* Open question of the earlier survey (`bank_survey.md` finding 9, "05:63B0 mixes commands with Shift-JIS pairs"): the `81 47 81 4F 81 57 81 5F 81 67` runs at 05:63BD-63FE are step-8 sequences repeated inside a stream that also contains `b1 NN KK` tables   referenced by the song table; that reading as Shift-JIS text is more likely a coincidence, but both readings are HYPOTHESIS.
