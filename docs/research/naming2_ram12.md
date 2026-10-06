# Neutral RAM uses with proven roles (ram12) (ROM unchanged)

> Status: **reference (current)**. Ram12 is complete: all 152 bases / 1,059 explicit use sites were accounted for (560 named, 499 kept neutral). The first area covered 34 SRAM bases / 107 sites. One proposer read every site and indirect reader; a fresh-context skeptic independently checked every proposal, bank proof and natural coverage entry. HRAM and WRAM are complete in sections 5 and 6.

## 1. SRAM result

* Seven new bank-1 names: six CONFIRMED, one PROBABLE (table below).
* 26 bases reuse existing bank-qualified containers or fields with exact offsets; this does not invent a semantic role for each byte.
* `analysis/naming2/ram12_sram_manual.tsv`: 106 rows applied, no skipped rows; a second dry run reports 106 already written, no skipped rows. `ram12_sram_names.tsv` records the seven definitions.
* `sSram_AFFF` remains neutral: the zero store in bank 3 has no demonstrated reader or role. The neutral definitions stay available for other banks and future evidence.
* SHA-256 and symbol validation passed after adding the definitions and after applying the sites. No instruction or data byte changes; no new natural scenario, PPU capture or hardware validation.

| new name | S1 address | status | demonstrated role |
|---|---|---|---|
| `sMobileError12Or26Count` | `$A9E3` | PROBABLE | Byte counter incremented only when wMobileErrorCode equals $12 or $26 in Sram_CountMobileError12Or26 (4E:487F inc/store 4883), reset at each boot (4E:468B), copied to an unreferenced report (4E:483A). The increment branch never ran naturally: only reset is natural, hence PROBABLE, no claim about which protocol faults $12/$26 represent. |
| `sSaveCheckValidFlag` | `$A9EC` | CONFIRMED | Non-zero marker required for SaveCheck_Verify to accept the bank-1 state: 4E:4722 load (920 hits/57 scenarios), or/jr z rejects zero; SaveCheck_ResetBlock writes 1 at 4E:4771 (72/11). The dead report copies it at 4E:483E; no broader validity semantics claimed. |
| `sBrowserFrameStyle` | `$A9EF` | CONFIRMED | Persisted browser frame-style byte: Browser_BeginSession loads it, normalizes low seven bits zero to 1, stores it and copies it to wBrowserFrameStyle (4E:46B1,46BA;249 hits/25 scenarios), whose renderer indexes Table_Browser_FrameDescriptors with low seven bits. SaveCheck_Verify bounds low seven bits to 1..$1A (4E:4716;920/57); boot/reset seed 1. Preview accept (4E:4191) and cancel (4E:41AF) store/copy same byte; both never ran naturally, so the meaning of the high bit is not promoted. |
| `sPageCacheWriteSlot` | `$A9FC` | CONFIRMED | Three-slot page-cache ring next-write index, 0..2: reset 4C:4C63 (215/25), PageCache_Push indexes three-byte descriptors at Table_PageCache_Slots with 4C:4CAD (79/14), increments and wraps at 3 (4C:4CCC..4CD5,79/14); PageCache_Pop decrements/wraps to 2 and uses the resulting slot (4C:4D14..4D1E,70/8). Browser_HistoryUndoPush has the same decrement at 4C:4D87,4D91, never natural. Fourth descriptor exists but ring bound is three; its last descriptor is not a fourth ring slot. |
| `sPageCacheCount` | `$A9FD` | CONFIRMED | Number of cached pages held, 0..3: reset 4C:4C60 (215/25), PageCache_Push tests <3 then increments/stores (4C:4CD8,4CE0,79/14), PageCache_Pop tests zero then decrements before copying a page (4C:4D0A,70/8;4D11,70/8); Browser_HistoryUndoPush has matching count decrement (4C:4D7D,4D84), never natural. Saturation branch is static even though count role is natural. |
| `sBrowserHistoryWriteSlot` | `$A9FE` | CONFIRMED | Six-slot browser back-stack ring next-write index, 0..5: Browser_HistoryReset zeroes it (4C:4B6C,215/25); Browser_HistoryPushFrom forms destination high byte $AA+index and copies $100 bytes, then increments/wraps at6 (4C:4B92,4BA0,4BA9;79/14). Browser_HistoryPop decrements/wraps to5 and reads that entry (4C:4BDF,4BE9;70/8). Browser_HistoryUndoPush decrements identically (4C:4D9E,4DA8), never natural. Boundary wrap to0/to5 is static; no claim that all six slots were exercised. |
| `sBrowserHistoryCount` | `$A9FF` | CONFIRMED | Browser back-stack depth, 0..6: Browser_HistoryReset zeroes it (4C:4B69,215/25); HistoryPushFrom saturates at6 otherwise increments (4C:4BAC,4BB4;79/14), HistoryPop tests for0 (4C:4BD5,86/12) and decrements before entry copy (4C:4BDC,70/8); UndoPush performs matching decrement (4C:4D94,4D9B), never natural. Saturation at6 is statically clear, not a newly observed six-entry run. |

## 2. Scope and indirect readers

The row's bank is the SRAM bank (S1 or S2), distinct from the ROM bank in the instruction address of its proof. The configuration magic/registration bytes use the S2 `sConfigImage` container or the existing PROBABLE `sConfigRegState`; the caller of `Config_BuildImageFromAccount` selects S2 before the preserve/copy/restore sequence. The save checks, browser rings and time mirror use S1, selected by the enclosing routine, with explicit reselection after long bank-changing copies.

The direct census's zero-read counts for A9E4/A9E5/A9E8/A9E9 did **not** make them write-only: `SaveCheck_Sum16` reads their complements indirectly in 68 natural scenarios. They use the existing check-block containers. A9ED/A9EE remain offsets of `sSaveCheckStateBlock`, without a guessed meaning; A9F0-A9F7 keep offsets without invented units. `sCommTimeTotal` remains the existing PROBABLE mirror name; naming its stores does not promote its interpretation. New ring names state the demonstrated index/count roles; unexecuted saturation/wrap paths remain static evidence.

## 3. Manual writer safeguards

`tools/apply_manual_sites.py` now reads neutral definitions from `ram/sram.asm`, normalizes SRAM memory operands in context checks, and compares SRAM banks as well as WRAM banks. Previously it could accept a name in the wrong SRAM bank at the same address, which byte comparison cannot detect. The writer also revalidates value, bank and context before reporting a row as already written; that path previously bypassed the checks.

Two regression tests exercise new SRAM rows, same-address wrong-bank rejection, offsets, neighbouring rewritten operands, idempotence, and already-written rows with invalid bank/value/context. Nine tests pass. Four independent mutation checks caught removal of each new safeguard. The fresh skeptic found 20 stale context fields at five existing table sites: ramop9 (12 rows) and ramop10 (8 rows). Only those `ctx` fields were refreshed after independently checking their values, banks and consumers; line numbers, operands, names and proofs are unchanged. Existing nonmatching rows remain explicit: ramop9 six, ramop10 fifteen; ramop11 has 138 already written and no skips. The obsolete ramop7 format remains the known rc=2 exception.

## 4. Reproduce

```sh
python3 tools/apply_banked_names.py --names analysis/naming2/ram12_sram_names.tsv --sites /dev/null --tag ram12s --dry-run --strict
python3 tools/apply_manual_sites.py --sites analysis/naming2/ram12_sram_manual.tsv --dry-run
python3 tools/test_manual_sites.py
python3 tools/apply_banked_names.py --check
make && make sym-check && make palette-check
```

The neutral SRAM definitions are intentionally retained. No assembly line was inserted or removed outside the appended equates in `ram/banked.asm`; existing instruction-site records need no line remap.

Validation on both the private integration tree and main: `make` and `make compare` report `RESULT: IDENTICAL`; `sym-check` passes; banked audit reports 221 names / 150 overlaps / zero errors. The full 37-entry suite has 36 rc=0 and only the pre-existing ramop7 format exception (rc=2). Palette audit remains 162 loads / 116 arrays / two documented overreads / zero errors.

## 5. HRAM area

All 21 HRAM bases / 403 explicit sites were proposed and independently reviewed against original ROM operands, enclosing routines, indirect readers, natural coverage and existing alias scopes. The result is 176 named sites and 227 kept neutral. `ram12_hram_renames.tsv` records one global rename; `ram12_hram_overlays.tsv` records 49 new aliases (37 CONFIRMED, 12 PROBABLE). The existing `hTextBox_LineStartXHi` alias gains exactly two browser ranges in `overlay_aliases.tsv`.

`hJoyDispatchExtraMask` replaces FFA7 globally: JoypadDispatch ORs it with hJoyPressed and clears it before dispatch. The eight uses share that consumer role; the name does not assert a physical button event. The new aliases describe routine-local arithmetic, palette components, tilemap widths, banks, text bounds, browser state, timer fields and parser accumulator bytes. Unexecuted preview/parser paths retain PROBABLE status; manifests contain per-site code citations and the existing natural demonstrators.

The reviewer rejected the proposed FFC3 browser extension. Browser setup writes LineAdvance=$FF; TextEngine_LineWrap reads FFC2, then returns on that value before reading MaxLineY/FFC3. The two FFC3 stores therefore remain neutral. FFC2 is read and can use its established line-start-X-high alias. Its DEF has a separate group header; the old FFC3 DEF and scope, and all other existing scopes, remain identical. No broad browser-file scope or new instruction label was introduced.

Two evidence corrections are explicit: preview reveal termination tests H=0, not HL=0; the parser's alphabetic A-F/a-f branch subtracts its base without adding ten, yielding 0-5. Naming its accumulator bytes does not imply correct hexadecimal conversion. Audio immediates $FFD2/$FFD1 are negative offsets, not HRAM pointers, and stay numeric.

The coordinator applied the strict tools and the two guarded FFC2 replacements, then audited all 176 exact operand changes against the published SRAM checkpoint. Instruction line counts, the 227 keep sites and prior SRAM changes are preserved. The combined source passes make (SHA-256 OK, RESULT: IDENTICAL), sym-check and palette-check. Combined totals: 221 banked names (125 CONFIRMED/96 PROBABLE), 307 aliases (241/66). No new natural scenario, PPU capture or hardware validation was added.

The full main suite has 36 rc=0 entries and the known ramop7 obsolete-format exception (37 total). Three context records in ramop9/ramop10 were independently rechecked after adjacent HRAM operands were renamed; only their `ctx` fields changed. Their operands, W7 banks and proofs remain intact. Focused dry-runs restore the previous totals (150/6, 285/15); the SRAM record remains 106 already written / zero skips. A historical mail proof line number is stale (1914 versus current 1872), but its ROM address 27:4F6F and bank selection remain correct.

## 6. WRAM areas and complete census

Communication covers all 55 bases / 376 sites: 13 global names and 33 local aliases name 179 sites; 197 remain neutral. The fresh reviewer upheld 69 of 75 proposal rows and rejected six parser aliases. Residual browser/help/keyboard/account/mail areas cover 42 bases / 173 sites: six global names and 24 local aliases name 99 sites; 74 remain neutral. All 57 residual rows were upheld with evidence corrections. The four manifests are `ram12_comm_renames.tsv`, `ram12_comm_overlays.tsv`, `ram12_residual_renames.tsv` and `ram12_residual_overlays.tsv`.

The 19 global WRAM names (16 CONFIRMED/3 PROBABLE) are true across every direct and derived use checked: HTTP path length, credentials pointer, saved POST body pointer/length, receive sync miss count, response timeout count, config-read state argument, POST result pointer, cached OpenTCP packet, browser login POST flag, BMP row-aligned height/top-down flag, keyboard slide target Y and high target palette color byte. Global DEF comments now contain the reviewed status and evidence rather than obsolete HYPOTHESIS descriptions. The 57 WRAM aliases are 45 CONFIRMED/12 PROBABLE; SMTP C241/C242 use the consistent HeaderWritePtr/Hi family, distinct from the browser BodyLengthLo phase at C242.

The six numeric-parser aliases of C711/C712/C713 would falsely name initial saves and final restoration of the caller's HTTP capacity/pointer state. Their 20 sites stay neutral; existing global-function ranges cannot isolate that mixed phase, and no labels were invented to force aliases. C591/C592 date-offset copies are write-only and remain neutral. HTML C331/C332 are not a consistent pointer pair: a tags path writes both E and D to C331. That contradiction is preserved. Keyboard fragment C2B0/C2B1 has incomplete evidence, and D525 remains neutral in WRAM1's store-only phase (other bank phases have other scratch uses).

Evidence corrections: ticker offset $16 means 22 decimal; IRQ subtraction $28 means 40 decimal. The BMP validation-failure clear at 51:715C has zero natural hits. Bmp_Validate first restricts height to 1..96, so ceil(height/12)*12 cannot overflow in this phase. Naturally demonstrated roles are CONFIRMED; cache resend, first/later timeout recovery, parser/dead debug phases and other unexecuted interpretations retain PROBABLE or neutral status.

The coordinator applied both strict tools, performed 19 exact guarded DEF-evidence updates, and audited all 549 WRAM sites against the independent maps. Exactly 278 reviewed operand changes were made, 271 keep sites remain neutral, and all 307 pre-existing alias DEF/scope pairs remain identical. Previous SRAM/HRAM edits are retained. There are no instruction-line insertions/deletions or ROM-byte changes. No new natural run, PPU or hardware evidence.

| area | bases | sites | named | neutral |
|---|---:|---:|---:|---:|
| SRAM | 34 | 107 | 106 | 1 |
| HRAM | 21 | 403 | 176 | 227 |
| WRAM communication | 55 | 376 | 179 | 197 |
| WRAM residual | 42 | 173 | 99 | 74 |
| total | 152 | 1,059 | 560 | 499 |

Complete-pass totals: seven new SRAM banked fields, 20 global renames, 106 new local aliases and one prior FFC2 alias scope extension. Banked names total 221 (125 CONFIRMED/96 PROBABLE); aliases total 364 on 104 bytes (62 WRAM0/42 HRAM), 286 CONFIRMED/78 PROBABLE. Neutral names remain available wherever a role was not proved; completion means the worklist was reviewed, not that every byte acquired a role name.

Final main validation: 37 suite entries, 36 rc=0 and only the inherited ramop7 obsolete-format rc=2. make/compare report SHA-256 OK and RESULT: IDENTICAL; sym-check, PNG/palette/graphics and invariants pass. Manual SRAM is 106 already written / zero skips; ramop11 remains 138 / zero, and ramop9/10 retain the documented 150/6 and 285/15 totals.
