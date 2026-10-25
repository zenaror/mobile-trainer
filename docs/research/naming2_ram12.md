# Neutral RAM uses with proven roles (ram12) (ROM unchanged)

## 1. SRAM result

| new name | S1 address | status | demonstrated role |
|---|---|---|---|
| `sMobileError12Or26Count` | `$A9E3` | PROBABLE | Byte counter incremented only when wMobileErrorCode equals $12 or $26 in Sram_CountMobileError12Or26 (4E:487F inc/store 4883), reset at each boot (4E:468B), copied to an unreferenced report (4E:483A). The increment branch never ran naturally: only reset is natural, hence PROBABLE, no claim about which protocol faults $12/$26 represent. |
| `sSaveCheckValidFlag` | `$A9EC` | CONFIRMED | Non-zero marker required for SaveCheck_Verify to accept the bank-1 state: 4E:4722 load (920 hits/57 scenarios), or/jr z rejects zero; SaveCheck_ResetBlock writes 1 at 4E:4771 (72/11). The dead report copies it at 4E:483E; no broader validity semantics claimed. |
| `sBrowserFrameStyle` | `$A9EF` | CONFIRMED | Persisted browser frame-style byte: Browser_BeginSession loads it, normalizes low seven bits zero to 1, stores it and copies it to wBrowserFrameStyle (4E:46B1,46BA;249 hits/25 scenarios), whose renderer indexes Table_Browser_FrameDescriptors with low seven bits. SaveCheck_Verify bounds low seven bits to 1..$1A (4E:4716;920/57); boot/reset seed 1. Preview accept (4E:4191) and cancel (4E:41AF) store/copy same byte; both never ran naturally, so the meaning of the high bit is not promoted. |
| `sPageCacheWriteSlot` | `$A9FC` | CONFIRMED | Three-slot page-cache ring next-write index, 0..2: reset 4C:4C63 (215/25), PageCache_Push indexes three-byte descriptors at Table_PageCache_Slots with 4C:4CAD (79/14), increments and wraps at 3 (4C:4CCC..4CD5,79/14); PageCache_Pop decrements/wraps to 2 and uses the resulting slot (4C:4D14..4D1E,70/8). Browser_HistoryUndoPush has the same decrement at 4C:4D87,4D91, never natural. Fourth descriptor exists but ring bound is three; its last descriptor is not a fourth ring slot. |
| `sPageCacheCount` | `$A9FD` | CONFIRMED | Number of cached pages held, 0..3: reset 4C:4C60 (215/25), PageCache_Push tests <3 then increments/stores (4C:4CD8,4CE0,79/14), PageCache_Pop tests zero then decrements before copying a page (4C:4D0A,70/8;4D11,70/8); Browser_HistoryUndoPush has matching count decrement (4C:4D7D,4D84), never natural. Saturation branch is static even though count role is natural. |
| `sBrowserHistoryWriteSlot` | `$A9FE` | CONFIRMED | Six-slot browser back-stack ring next-write index, 0..5: Browser_HistoryReset zeroes it (4C:4B6C,215/25); Browser_HistoryPushFrom forms destination high byte $AA+index and copies $100 bytes, then increments/wraps at6 (4C:4B92,4BA0,4BA9;79/14). Browser_HistoryPop decrements/wraps to5 and reads that entry (4C:4BDF,4BE9;70/8). Browser_HistoryUndoPush decrements identically (4C:4D9E,4DA8), never natural. Boundary wrap to0/to5 is static; no claim that all six slots were exercised. |
| `sBrowserHistoryCount` | `$A9FF` | CONFIRMED | Browser back-stack depth, 0..6: Browser_HistoryReset zeroes it (4C:4B69,215/25); HistoryPushFrom saturates at6 otherwise increments (4C:4BAC,4BB4;79/14), HistoryPop tests for0 (4C:4BD5,86/12) and decrements before entry copy (4C:4BDC,70/8); UndoPush performs matching decrement (4C:4D94,4D9B), never natural. Saturation at6 is statically clear, not a newly observed six-entry run. |

## 5. HRAM area

`hJoyDispatchExtraMask` replaces FFA7 globally: JoypadDispatch ORs it with hJoyPressed and clears it before dispatch. The eight uses share that consumer role; the name does not assert a physical button event. The new aliases describe routine-local arithmetic, palette components, tilemap widths, banks, text bounds, browser state, timer fields and parser accumulator bytes. Unexecuted preview/parser paths retain PROBABLE status; manifests contain per-site code citations and the existing natural demonstrators.

The reviewer rejected the proposed FFC3 browser extension. Browser setup writes LineAdvance=$FF; TextEngine_LineWrap reads FFC2, then returns on that value before reading MaxLineY/FFC3. The two FFC3 stores therefore remain neutral. FFC2 is read and can use its established line-start-X-high alias. Its DEF has a separate group header; the old FFC3 DEF and scope, and all other existing scopes, remain identical. No broad browser-file scope or new instruction label was introduced.

Two evidence corrections are explicit: preview reveal termination tests H=0, not HL=0; the parser's alphabetic A-F/a-f branch subtracts its base without adding ten, yielding 0-5. Naming its accumulator bytes does not imply correct hexadecimal conversion. Audio immediates $FFD2/$FFD1 are negative offsets, not HRAM pointers, and stay numeric.

Focused dry-runs restore the previous totals (150/6, 285/15); the SRAM record remains 106 already written / zero skips.

## 6. WRAM areas and complete census

The 19 global WRAM names (16 CONFIRMED/3 PROBABLE) are true across every direct and derived use checked: HTTP path length, credentials pointer, saved POST body pointer/length, receive sync miss count, response timeout count, config-read state argument, POST result pointer, cached OpenTCP packet, browser login POST flag, BMP row-aligned height/top-down flag, keyboard slide target Y and high target palette color byte. Global DEF comments now contain the reviewed status and evidence rather than obsolete HYPOTHESIS descriptions. The 57 WRAM aliases are 45 CONFIRMED/12 PROBABLE; SMTP C241/C242 use the consistent HeaderWritePtr/Hi family, distinct from the browser BodyLengthLo phase at C242.

The six numeric-parser aliases of C711/C712/C713 would falsely name initial saves and final restoration of the caller's HTTP capacity/pointer state. Their 20 sites stay neutral; existing global-function ranges cannot isolate that mixed phase, and no labels were invented to force aliases. C591/C592 date-offset copies are write-only and remain neutral. HTML C331/C332 are not a consistent pointer pair: a tags path writes both E and D to C331. That contradiction is preserved. Keyboard fragment C2B0/C2B1 has incomplete evidence, and D525 remains neutral in WRAM1's store-only phase (other bank phases have other scratch uses).

Evidence corrections: ticker offset $16 means 22 decimal; IRQ subtraction $28 means 40 decimal.

| area | bases | sites | named | neutral |
|---|---:|---:|---:|---:|
| SRAM | 34 | 107 | 106 | 1 |
| HRAM | 21 | 403 | 176 | 227 |
| WRAM communication | 55 | 376 | 179 | 197 |
| WRAM residual | 42 | 173 | 99 | 74 |
| total | 152 | 1,059 | 560 | 499 |

Complete-pass totals: seven new SRAM banked fields, 20 global renames, 106 new local aliases and one prior FFC2 alias scope extension. Banked names total 221 (125 CONFIRMED/96 PROBABLE); aliases total 364 on 104 bytes (62 WRAM0/42 HRAM), 286 CONFIRMED/78 PROBABLE. Neutral names remain available wherever a role was not proved; completion means the worklist was reviewed, not that every byte acquired a role name.
