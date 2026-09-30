## Precision audit (60 random inferred rows)

Sample: `python3 tools/xref_infer.py --audit 60 --audit-out analysis/xrefs/audit_sample.txt` (fixed seed 20240607, drawn from the final 1127 rows; the listing with
6 instructions of context before and 8 after each site is `analysis/xrefs/audit_sample.txt`).  Every row was checked by reading the surrounding code: (1) the immediate
is really loaded as a pointer that is then read (not a count/offset), (2) the bank the pointer refers to is the bank of the named label, (3) the label is the start of the
data the code walks.  Result: **60 of 60 correct (100 %; 95 % Wilson lower bound about 94 %)**.  An earlier 60-row sample taken from a previous, slightly smaller
revision of the tool (1099 rows) was also 60/60 correct, and it exposed two wording defects in the evidence text (a far-callee bank was described as "far callee bank"
although the bank came from `ld a,<bank>`, and "hl was offset" was printed for DE) which are fixed in the final rows.

Verdict mix of the sample: pointer read directly in the routine (pattern c), pointer consumed by a callee (pattern b), pointer + `ld a,BANK` for a bank-taking loader
(pattern d: 00:0787/0749 HDMA tile loaders, 00:08EA/16A2 rectangle copies, 00:0A82 sprite-slot initialiser, 4F:4000 far CopyBytes, ReadByteFar), table base + index
(`add hl,bc`, `add a,l`/`adc a,h` idiom; these are PROBABLE by construction).  No false positive was found.  Known residual risks (not seen in the sample):

* a routine that receives the pointer but uses it only as a comparison key or passes it on through a path the walker does not follow (then no row is emitted, so the risk is recall, not precision);
* a numeric offset that equals a label address, loaded with `ld hl,imm ; add hl,de` where the OTHER register is the base (would be reported as a base pointer); none of the 128 `add hl,rr` rows is of that kind (first pass: 25 read in detail; independent verification: all 128 read, see the section at the end: in every one the other register is an index built with `ld b|d,$00` or an index derived in the same routine);
* CONFIRMED means: the pointer load, the dereferencing instruction and a data read covering the target's first byte were all seen in the SAME trace scenario (per-scenario coverage_<sc>.tsv + detail/<sc>/dataaccess.tsv; enforced by the tool since the verification pass, all 638 rows satisfied it); it does not prove that THIS load caused that particular read.

| # | site | target | status | verdict |
|---|---|---|---|---|
| 1 | 0F:4395 `ld hl, $4004` | 0F:4004 String_0F_4004 | CONFIRMED | correct |
| 2 | 19:4CD0 `ld hl, $4D5E` | 19:4D5E Data_19_4D5E | PROBABLE | correct |
| 3 | 1D:4337 `ld hl, $4383` | 1D:4383 Table_1D_4383 | PROBABLE | correct |
| 4 | 1F:40E3 `ld hl, $40D7` | 1E:40D7 Data_1E_40D7 | CONFIRMED | correct |
| 5 | 1F:412B `ld de, $656F` | 1E:656F Table_1E_656F | PROBABLE | correct |
| 6 | 24:462B `ld de, $6530` | 24:6530 Table_24_6530 | PROBABLE | correct |
| 7 | 24:4675 `ld de, $6530` | 24:6530 Table_24_6530 | PROBABLE | correct |
| 8 | 26:5227 `ld hl, $62E0` | 26:62E0 Data_26_62E0 | CONFIRMED | correct |
| 9 | 26:544F `ld hl, $5575` | 26:5575 String_26_5575 | CONFIRMED | correct |
| 10 | 27:4BD2 `ld hl, $5060` | 27:5060 Data_27_5060 | CONFIRMED | correct |
| 11 | 27:4DD8 `ld hl, $5800` | 29:5800 Data_29_5800 | PROBABLE | correct |
| 12 | 29:478C `ld hl, $47B2` | 29:47B2 String_29_47B2 | CONFIRMED | correct |
| 13 | 2B:425C `ld hl, $4880` | 2B:4880 Data_2B_4880 | CONFIRMED | correct |
| 14 | 2B:54BE `ld hl, $5FF0` | 2B:5FF0 Data_2B_5FF0 | PROBABLE | correct |
| 15 | 2B:54F7 `ld de, $6430` | 2B:6430 Table_2B_6430 | PROBABLE | correct |
| 16 | 2B:7C76 `ld hl, $7D7A` | 2B:7D7A Table_2B_7D7A | PROBABLE | correct |
| 17 | 2D:41A3 `ld hl, $42B2` | 2D:42B2 Data_2D_42B2 | PROBABLE | correct |
| 18 | 2D:46F4 `ld hl, $470A` | 2D:470A Table_2D_470A | PROBABLE | correct |
| 19 | 2D:49B6 `ld hl, $5AC0` | 2D:5AC0 Data_2D_5AC0 | CONFIRMED | correct |
| 20 | 2E:4692 `ld hl, $6C30` | 2E:6C30 Data_2E_6C30 | CONFIRMED | correct |
| 21 | 2E:4CC7 `ld hl, $5EE0` | 2E:5EE0 Data_2E_5EE0 | PROBABLE | correct |
| 22 | 2F:44BA `ld hl, $44E6` | 2F:44E6 Table_2F_44E6 | PROBABLE | correct |
| 23 | 2F:45BE `ld hl, $4BD0` | 28:4BD0 Data_28_4BD0 | CONFIRMED | correct |
| 24 | 2F:51FF `ld hl, $5E50` | 29:5E50 Data_29_5E50 | CONFIRMED | correct |
| 25 | 2F:596F `ld hl, $65F0` | 2F:65F0 Tiles_2F_65F0 | CONFIRMED | correct |
| 26 | 2F:701B `ld hl, $7AC0` | 2F:7AC0 Data_2F_7AC0 | CONFIRMED | correct |
| 27 | 4E:64EC `ld hl, $654B` | 4E:654B Table_4E_654B | PROBABLE | correct |
| 28 | 54:4644 `ld hl, $4770` | 54:4770 String_54_4770 | CONFIRMED | correct |
| 29 | 55:5C27 `ld hl, $4CD0` | 5F:4CD0 Palette_5F_4CD0 | CONFIRMED | correct |
| 30 | 55:5C79 `ld de, $4CF8` | 5F:4CF8 Table_5F_4CF8 | PROBABLE | correct |
| 31 | 55:61C3 `ld de, $4CF8` | 5F:4CF8 Table_5F_4CF8 | PROBABLE | correct |
| 32 | 55:68E6 `ld hl, $5480` | 66:5480 Data_66_5480 | CONFIRMED | correct |
| 33 | 57:4569 `ld de, $79B8` | 56:79B8 Table_56_79B8 | PROBABLE | correct |
| 34 | 57:481A `ld de, $79B8` | 56:79B8 Table_56_79B8 | PROBABLE | correct |
| 35 | 57:4906 `ld hl, $526A` | 56:526A Data_56_526A | CONFIRMED | correct |
| 36 | 67:4739 `ld hl, $5010` | 4D:5010 Data_4D_5010 | CONFIRMED | correct |
| 37 | 67:4859 `ld hl, $486D` | 67:486D Data_67_486D | PROBABLE | correct |
| 38 | 67:4E09 `ld de, $7960` | 4D:7960 Table_4D_7960 | PROBABLE | correct |
| 39 | 68:57FB `ld hl, $4000` | 5E:4000 Data_5E_4000 | CONFIRMED | correct |
| 40 | 68:64B8 `ld hl, $5C70` | 4A:5C70 Data_4A_5C70 | PROBABLE | correct |
| 41 | 68:7434 `ld hl, $7442` | 68:7442 Table_68_7442 | PROBABLE | correct |
| 42 | 68:7628 `ld hl, $765E` | 68:765E Table_68_765E | PROBABLE | correct |
| 43 | 68:790E `ld hl, $793D` | 68:793D Table_68_793D | PROBABLE | correct |
| 44 | 68:7A42 `ld hl, $49D0` | 5F:49D0 Data_5F_49D0 | CONFIRMED | correct |
| 45 | 68:7C25 `ld hl, $6C68` | 71:6C68 Data_71_6C68 | CONFIRMED | correct |
| 46 | 6C:40EC `ld hl, $42D0` | 6A:42D0 Data_6A_42D0 | CONFIRMED | correct |
| 47 | 6C:5A1A `ld hl, $6A20` | 6A:6A20 Data_6A_6A20 | CONFIRMED | correct |
| 48 | 70:450F `ld hl, $6090` | 70:6090 Data_70_6090 | CONFIRMED | correct |
| 49 | 70:47F5 `ld de, $53EB` | 70:53EB Table_70_53EB | PROBABLE | correct |
| 50 | 72:650C `ld hl, $6556` | 72:6556 Data_72_6556 | CONFIRMED | correct |
| 51 | 72:673C `ld hl, $7010` | 72:7010 Data_72_7010 | CONFIRMED | correct |
| 52 | 72:6751 `ld hl, $7200` | 72:7200 Data_72_7200 | CONFIRMED | correct |
| 53 | 73:5FB2 `ld hl, $5DE0` | 73:5DE0 Data_73_5DE0 | CONFIRMED | correct |
| 54 | 73:5FC3 `ld hl, $4097` | 73:4097 Data_73_4097 | CONFIRMED | correct |
| 55 | 74:4398 `ld bc, $400E` | 74:400E Table_74_400E | PROBABLE | correct |
| 56 | 75:404A `ld hl, $4070` | 75:4070 Table_75_4070 | PROBABLE | correct |
| 57 | 75:48C2 `ld hl, $606D` | 75:606D Data_75_606D | CONFIRMED | correct |
| 58 | 75:7040 `ld de, $72DE` | 75:72DE String_75_72DE | CONFIRMED | correct |
| 59 | 7F:40CA `ld hl, $4150` | 7F:4150 Data_7F_4150 | PROBABLE | correct |
| 60 | 7F:4B03 `ld hl, $499C` | 7F:499C Table_7F_499C | PROBABLE | correct |

## Independent adversarial verification (second reviewer)

Done by a separate pass that re-derived the claims from the code instead of trusting the prose above.

* **Fresh random sample**: 50 `imm` rows of the merged `config/xrefs.tsv` (Python `random.seed(777)`, independent of the author's seed), each read in a fresh disassembly
  with 2-9 instructions of context, plus a read of the consumer routines (00:0787/0749 HDMA loaders, 00:08EA->0904, 00:0A82->0AB8, 00:06D1 FarCall, 4F:4000, 48:403E/ReadByteFar,
  00:14BF CopyString, 00:10E9).  Result: **50 of 50 correct** (immediate is a pointer that is dereferenced for reading, the bank shown is the bank the routine reads it from,
  the label is the start of the walked data).  Combined with the author's 60/60 the pooled 110/110 gives a 95 % Wilson lower bound of about 96.6 %.
* **All 128 `add hl,rr` table-base rows read** (the mirror-image risk: `ld hl,K ; add hl,de` where K is an offset and DE the base): 0 wrong.  In 124 the other register is set by
  `ld b|d,$00` right before; the remaining 4 (24:5192, 2B:5600, 75:40E1, 7F:5F8F) index a table already used with the same base elsewhere in the routine.  The 231 `add a,l ... adc a,h`
  idiom rows are structural (pair += A).
* **CONFIRMED strictness**: re-checked all 638 CONFIRMED rows against per-scenario data (`traces/coverage_<sc>.tsv` + `traces/detail/<sc>/dataaccess.tsv`): every one has a
  scenario in which the load was executed AND the target's first byte was read.  The tool used a union over 41 scenarios before; it now requires the same scenario
  (rows unchanged: 638 CONFIRMED / 489 PROBABLE, `rows.tsv` identical).
* **Rejected candidates (20 read)**: 2 write dereferences (72:443C, 72:4446: `ld hl,$0400/$0420 ; add hl,de ; ld [hli],a`, tilemap offsets) correctly rejected; 1A:4192 (bank unknown,
  index in A only) correctly rejected; 00:059F (`ld hl,$05AC` copied into HRAM, a ramcode region) correctly rejected; 14 "no dereference proof" candidates that DO have an exact label
  and 5 "end of region" ones examined.  No rejected candidate was a false rejection of a wrong-looking case, but the sample shows the recall loss is real: at least 4-6 of the 14
  are genuine pointers the walker cannot follow (04:4EBB `ld bc,$547D ; add hl,bc ; ld a,[hli]` = BC is the base and HL the index; 63:4014 `ld de,$407A ; ld a,e ; add a,l ; ... ; ld a,[hl]`;
  6C:5E96 `add a,l` idiom followed by `push hl`; `ld hl,String ; ld de,dst ; call $14F3` string copy at 68:41C8/67:5E8F; 0F:5019 `ld hl,$4000 ; call $521B`).  The others (74:4ADB, 74:4761 via 00:1119,
  75:59BF via 75:5F0B, 7F:4D58, 1D:4357) are unproven either way.  The tool deliberately does not accept them: for `add hl,rr` with the loaded pair as the *other* operand it cannot tell which
  register is the base, and accepting both would trade precision for recall.  Only 42 of the 1450 "no proof" candidates have an exact data label, so the possible gain is at most 42 rows.
* **Pipeline checks**: `gen_asm.py verify` IDENTICAL; `check --strict` OK; a temp regen (`verify --keep`) contains exactly 1127 `ld r16, <Label>` lines that the current `src/` still has as `$xxxx`
  (spot checks: `ld hl, Data_2E_6960`, `ld hl, Tiles_52_4080`, `ld hl, Data_71_4C90` in bank68); two runs of the tool give byte-identical `rows.tsv` and `unlabelled.tsv`; the rerun is a no-op on `config/xrefs.tsv`.
* **Claim C6 (0392 preserves registers and bank)**: PROBABLE stands.  Body read: push af/bc/de/hl, `call 20A6` (bank-4 gateway 2129/2116/20EE ... 2141/210B restore FF8A/FF8B), pop.  It carries the 12 rows
  consumed by 00:10E9 (all in bank 74; 6 of them are CONFIRMED by same-scenario reads of the target).
* **Retracted**: nothing.  No row was removed or downgraded; the only edits are the wording corrections above and the same-scenario condition in `tools/xref_infer.py`.
