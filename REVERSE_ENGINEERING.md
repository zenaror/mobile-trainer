**Inline BMP zero-width mainline loop confirmed in synthetic mGBA (2026-10-25).** A directed scenario received a 318-byte BMP with width 0 through the ordinary HTML image request and entered `Bmp_ConvertToTiles`. An instrumented run observed `51:729C` with `F=$C0`, `DE=$D000`, and stride `$00`; each executed `JR NC` returned to `51:7251` without changing `DE`. It repeated through frame 9,599. The 9,600-frame budget and final SDK dispatcher PC do not mean conversion returned. The caller still discards the declared payload end, so malformed-record safety is unproven. This is synthetic mGBA evidence, not hardware or external-server behavior. See [bounded run and hashes](docs/research/japanese_bmp_record_bounds_20261025.md#reproduction-points) and `.tmp/jp-bmp-malformed-http-20261025/PROBE.json` (SHA-256 `2edc3173eb1dfb90534861cf910867afc1a5e71944f284cbe1187bba2379635e`).

**Indirect bad-index route to the frame preview bounded (2026-10-25).** The retained inline-dispatch matrix has 18 out-of-table cases across nine browser tables that decode to `4E:4000`. Their ordinary inputs come from bounded fetch results (0–6), monitored dialogs (0–5) or browser menus (0–6), so none is produced on the maintained normal path. If malformed input forces a hit, `JumpTableInline` sets A to the target low byte `$00`; the preview selects style 0, not the overflowing index or a Pokémon ordinal. This finds a conditional corrupted-state edge but no natural Bank53 name-to-frame link. Evidence and limits: [indirect preview dispatch audit](docs/research/japanese_semantic_roots_and_destinations_20261025.md#indirect-malformed-index-path-to-the-frame-preview-2026-10-25) and `.tmp/jp-preview-indirect-overflow-20261025/`.

**Mutable frame-descriptor overflow resolved for the maintained Japanese selector (2026-10-24).** The 16 previously noted pointers into VRAM/SRAM/WRAM arise only from selector indices 27–127 reading past the 27-entry table; all declared indices 0–26 resolve to ROM descriptors. The normal saved-style path is validated to 1–26 and app entry resets invalid save state; fixed application styles are 0, 1, and 2. Preview input A remains external and the preview has no located maintained direct caller. This closes no natural mutable-descriptor edge, but does not resolve Pokémon-name/frame associations or global asset use. Evidence and limits: [semantic roots and destinations](docs/research/japanese_semantic_roots_and_destinations_20261025.md#mutable-descriptor-pointers-are-out-of-table-selector-artifacts-2026-10-24) and `.tmp/jp-bank53-selector-natural-domain-20261024/`.

**Bank 53 visual crosswalk clarification (2026-10-24).** The decoded name list and existing window-local artwork review support 21 probable species-to-window visual matches. A reinspection confirms two animal-like faces in the exact `43:4D50` tile sheet; the generated Bank-43 screen is a hypothesis model with no emulator capture, and the two faces do not resolve Pikachu/Pichu. Porygon/Porygon2 and two panel windows remain unassigned. No executable ordinal-to-window link, natural selection, or global use status is established. See the [direct visual crosswalk and limits](docs/research/japanese_frame_bank53_revalidation_20261024.md#direct-visual-species-to-window-crosswalk-2026-10-24).

**Trace DMA coverage correction (2026-10-24).** `dataaccess.tsv` records ROM source reads performed by HDMA because the pinned mGBA `_GBMemoryHDMAService` calls the wrapped `cpu->memory.load8`; OAM DMA instead calls `GBLoad8` directly and bypasses the hook. In 52 retained hardware-register reports, all 1,561,837 OAM DMA writes select source page `$C0` from `HRAM:FF82`. Thus the 72-scenario frame/name census includes CPU and HDMA ROM reads, plus the separately bounded observed OAM source-page route. Global use, natural inputs outside the corpus, and the unresolved Pokémon/frame pairings remain open. See [trace implementation limits](docs/research/dynamic_tracing.md#7-limitations-and-things-that-can-mislead) and the [frame/name census](docs/research/japanese_frame_bank53_revalidation_20261024.md#retained-scenario-reads-of-the-name-and-frame-extents-2026-10-24).

**Retained frame/name read census (2026-10-24).** A grouped pass intersected all 83,242 recorded ROM data-read intervals in the 72 retained scenarios with all 25 physical frame extents and Bank 53's name/string block; it found zero overlaps. This is corpus-specific absence, not global non-use or proof that the names and frames are unrelated. See the [census and limitations](docs/research/japanese_frame_bank53_revalidation_20261024.md#retained-scenario-reads-of-the-name-and-frame-extents-2026-10-24).

**Five candidate roots rechecked in the 72-scenario corpus (2026-10-24).** None of the current retained traces recorded an instruction start, callgraph destination, or ROM data-read overlap in `2B:6CF5–6DB0`, `2D:4E42–4E8C`, `29:50CE–5145`, `70:4740–477F`, or `55:5DF5–5E02`. This extends the finite check to the two latest replay scenarios; it does not prove global unreachability or settle purpose. See the [per-span matrix and limits](docs/research/japanese_indirect_entry_boundary_review_20261024.md#five-candidate-spans-rechecked-against-the-current-72-scenario-corpus-2026-10-24).

**Japanese delivery integrated on main (`b49d725c`, 2026-10-24).** The eleven delivery checks passed; the reconciled inventory has no outstanding concrete correction. See the [delivery scope and retained limits](docs/research/japanese_closure_audit_20261023.md#delivery-on-main-2026-10-24). The [reuse contract](docs/TRANSLATION.md#japanese-baseline-and-reuse-contract-2026-10-24) routes future authorized ZIP parity to the existing Japanese maps and codecs. English remains paused.

**Japanese static-contract follow-up (2026-10-24; audit baseline `305333c4`).** A separate review covers the five direct callers of `CopyBytesBackward`, which were outside the earlier forward-copy census. Their declared sources are WRAM bank 7 screen maps or SRAM bank 3 browser-page data; under those ordinary caller contracts they read RAM, not ROM Bank 53 or the candidate frame windows. Bounded entry checks of `ReadBytesFar`, `Glyph_CopyToLeftBuf` and `CopyFar16ByteBlocks` found no maintained direct caller, checked literal near/far transfer, recognized dispatch-table entry, or retained ROM0 instruction/data-read observation at their ranges. The same pass corrected the width/row-advance comments for the ROM0 rectangle copy and bounded the 20-byte output/stack/bank preconditions for unrooted `4E:47EB`; no natural caller was established. Computed transfers, arbitrary corrupt descriptors, damaged stack/selector state, and execution outside retained scenarios remain open. See the [reader-family and helper contracts](docs/research/japanese_remaining_semantics_batch_20261024.md#backward-copy-reader-family-2026-10-24), [`ReadBytesFar` entry check](docs/research/japanese_remaining_semantics_batch_20261024.md#readbytesfar-direct-entry-follow-up-2026-10-24), and [orphaned copy-helper audit](docs/research/japanese_remaining_semantics_batch_20261024.md#orphaned-rom0-copy-helpers-direct-entry-follow-up-2026-10-24).

**Reading this status page.** The dated entries below are historical evidence,
not a cumulative backlog. Start with the [reconciled Japanese status matrix](docs/research/japanese_closure_audit_20261023.md#reading-the-status-correctly-review-of-2026-10-24-baseline-979fc0a5).
Completed audits with UNKNOWN results must not be reopened merely because the
uncertainty is mentioned again. The 21 operation rows are already named;
Bank 53/frame extraction and the eight KEEP-view reviews are completed within
their documented scope. This does not claim complete semantic knowledge.
English/ZIP remains paused pending fresh explicit authorization.

**Japanese finite-scope closure audit (2026-10-24; docs HEAD `e65b07ba`).** The final current-checkout gates pass: `make` is byte-identical to the protected ROM (2 MiB, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); `make sym-check` passes 335 sources / 12,223 labels / 51 constants; `make palette-check` passes 162 loads / 116 arrays / two documented over-reads / zero errors; `make png-check` passes 424 tile sheets / four raw views / 37 font sheets / 95 screens; GFX export accepts 994 assets; PNG rules accept 993. The live census matches 16/16 families, all 2,764 local anchors, 106 suffix rows, 545 broad dispositions and 786 RAM rows; the mapper check reports 78,114 starts, zero missing, sweep failures, boundary crossings or tiling problems. The declared name/path/local/RAM, operation-boundary, frame-window, asset and PNG inventories are closed for their documented scopes. This does not establish semantic 100% closure: five candidate roots still lack proven natural entry, some graphics spans lack proven natural consumption/phase, all 25 Bank 53 name-to-frame associations remain unresolved, and no frame is globally classified used or unused. English/ZIP remains paused. Full requirement-by-requirement status and limits: [Japanese closure audit](docs/research/japanese_closure_audit_20261023.md#current-consolidated-status-at-e65b07ba-2026-10-24).

**Semantic-root reconciliation update (2026-10-25).** The 120 generic-copy sites whose nearest local scan did not find `DE` are not 120 new questions: 115 destination contracts are reconciled under maintained natural roots, two partial BMP-related rows are now traced through the nested response-length record, and the three `MobileAPI_PeerReceive` sinks have no maintained app root (none of the 100 immediate-index API calls selects `$3A`). For BMP conversion, the caller computes the declared end in `DE`, but the converter discards it. The zero-width bottom-up loop is confirmed by an instrumented synthetic mGBA run. A separate accepted 64-byte 1x32 BMP fixture proves statically that 31 of its 32 row-source addresses exceed the declared record end; mGBA coverage confirms 32 row-copy calls, but its aggregate SRAM report does not trace each byte address. These synthetic results establish a missing bound check and conditional out-of-record reads, not natural external-network delivery, physical SRAM values or an exploit. A source-level stack-return screen checked 333 maintained Japanese ASM/INC files and reconciled seven unmatched PUSH-to-RET sites to existing HTML/SDK table dispatches, the sprite trampoline, and the Bank 4 deferred return; it found no additional route into the open candidate spans. The known Bank53 frame-style selector resolves only the maintained Bank47 descriptors and supplies no name-ordinal-to-candidate mapping; the 25 associations and global used/unused status remain open. Eight candidate spans still lack a demonstrated natural producer under the reviewed graph. Documentation corrections now distinguish fixed WRAM0 `$C000-$CFFF` from switchable WRAM banks at `$D000-$DFFF`. Detailed findings: [semantic roots and destinations audit](docs/research/japanese_semantic_roots_and_destinations_20261025.md) and [inline BMP record bounds](docs/research/japanese_bmp_record_bounds_20261025.md). No ASM changed; probe and stack-return evidence plus hashes are preserved under `.tmp/` and referenced in the research notes.

**Bank 53 literal far-pointer shapes (2026-10-24).** A whole-ROM scan checked both adjacent address/bank byte layouts and three common explicit instruction forms against `53:4000–4170`. Thirty raw byte shapes were found and individually reconciled to pointer-table adjacency, instructions, or GFX/font/text payloads; zero is an identified far descriptor. The three explicit `LD rr,addr`/`LD A,bank` or inline-farcall forms produced no target. This closes only those literal encodings; computed, separated, copied, RAM/SRAM, and mapper-dependent readers remain outside the scan, so global non-use and Pokémon-name/frame association remain unresolved. See the [classified Bank 53 scan](docs/research/japanese_frame_bank53_revalidation_20261024.md#whole-rom-bank-53-far-pointer-shaped-byte-scan-2026-10-24).

**A9ED writer follow-up (2026-10-24).** A targeted replay of the existing `title_settings` emulator scenario watched ten CPU stores to `$A9ED`; all wrote `$00` at `00:04E6`. The watchpoint does not log the SRAM bank, but the scenario's executed `Sram_WipeAllBanks` loop selects all four banks and calls `FillBytes` with zero. In the 72 retained data-access reports, all twelve SRAM1 merged write ranges overlapping A9ED are accounted for within scope: eleven `$A9E3-$A9FC` ranges occur in scenarios that execute `SaveCheck_ResetBlock` at `4E:4749`, and one `$A000-$C000` range is in `title_settings`. Of the 71 retained final `.sav` snapshots, 69 contain `$00` at SRAM1:A9ED and two (`noadapter`, `noncgb_boot`) contain `$FF`; snapshots do not record write history. A grouped static review also bounded all 27 maintained `WriteByteFar` sites and the explicit save-check/browser copy ranges. A targeted generic-copy follow-up traced the SRAM destinations in the configuration, settings, browser-history, page-cache, HTML-page and page-wrapper flows; those normal routes do not overlap SRAM1:A9ED/A9EE. The additional caller-rooted review covers the two direct `MobileAPI_ReadConfig` callers (SRAM2 `$A000-$A0BF`) and the app-dispatched mail outputs (SRAM3 `$B000`, fixed WRAM0 `$C480`, and SRAM3 `$A100`); none targets SRAM1 `$A9ED-$A9EE`. This is not yet a source-complete interprocedural proof for every pointer-taking API or computed destination, and corrupt/external SRAM and arbitrary indirect entry remain outside scope. The complete field domain remains UNKNOWN. Bank 70 candidate entry/purpose and Pokémon-name/frame associations remain open; English/ZIP remains paused. Evidence and limits: [A9ED writer follow-up](docs/research/naming_70_46a6_sram_boundaries.md#additional-sram1a9ed-writer-evidence-2026-10-24), with the replay receipt under `.tmp/jp-a9ed-natural-writer-20261024/`.

**Exact direct A9ED/A9EE operand census (2026-10-24).** A current scan of all 350 tracked Japanese ASM/INC files finds 50 non-comment code lines mentioning the block or field aliases: six declarations, 29 read/address operands and 15 direct stores. Those executable operands are confined to `engine/browser/canvas.asm`, `engine/browser/start_choice.asm`, `engine/comm/comm_scene.asm` and `engine/sram/save_block_check.asm`. Reset zeroes the complete A9E8–A9F7 block; checksum updates touch only A9E8–A9EB; there is no direct nonzero store to A9ED. The only direct A9EE stores are the two conditional Random16-derived writes inside the still-unrooted Bank 70 candidate. This closes exact source operands, not register-indirect copies, dynamic API destinations, corrupt SRAM or computed control flow; A9ED's global value domain and A9EE's natural producer remain unresolved. Details: [exact direct-operand census](docs/research/naming_70_46a6_sram_boundaries.md#exact-direct-operand-census-for-sram1a9eda9ee-2026-10-24).

**FillBytes SRAM routes (2026-10-24).** The 105 maintained direct `call FillBytes` sites were grouped by destination; all 24 SRAM-writing sites now have bank/range/value contracts. The only SRAM1 fill reaching A9ED/A9EE is the zero-valued reset of A9E8–A9F7 and the all-bank wipe. Cache, page-list, history, settings, variable-page, config-image, network-page, browser-page and page-cache destinations are range- or bank-separated. Five callers whose HL is passed/calculated indirectly were also bounded to WRAM banks 2/4/5/7; `PageCache_Pop`'s sixth such route uses its six callers' fixed SRAM3 `$B000` destination. This closes the maintained FillBytes call family for the stated natural descriptors, not other generic writers, corrupt state or dynamic control flow. See [the caller census](docs/research/naming_70_46a6_sram_boundaries.md#fillbytes-caller-census-and-sram-destination-matrix-2026-10-24).

**String/XOR writer routes (2026-10-24).** A complete Japanese tracked-source census includes 117 `call`/`jp`/`farcall` sites across `CopyString`, `CopyStringMax`, `EncodeXorA5`, `DecodeXorA5` and `StringAppend`; derived pointers were traced through all maintained helper callers. Their SRAM destinations are SRAM1 fields at `$B014+`, SRAM2 configuration/registration ranges, SRAM3 buffers, or bank-0 `$AF50`; the remaining outputs are WRAM. Within those caller contracts, these five helper families add no nonzero writer to SRAM1 `$A9ED` and no writer to `$A9ED/$A9EE`. Generic Mobile SDK/API descriptors, malformed state, arbitrary helper entry, and the unresolved natural roots of the Bank 70 candidate remain open. See the [destination matrix](docs/research/japanese_text_copy_destination_matrix_20261024.md).

**MobileSDK caller-output routes (2026-10-24).** The API table and maintained callsites were followed for configuration export, dial/login/mail-address reads, POP3 RETR/TOP bodies, HTTP bodies, and PeerReceive. Every caller-rooted output buffer found for these APIs resolves to WRAM, SRAM2 configuration/registration scratch, or SRAM3 mail/browser-page storage. HTTP reserves its two-byte length prefix and bounds its payload to the caller's page-buffer capacity. The SDK's internal receive windows are WRAM. No reviewed natural application route writes SRAM1 `$A9ED/$A9EE`; this closes a distinct group of generic SDK/API writers beyond the earlier two `MobileAPI_ReadConfig` and application mail-selector routes. It does not bound arbitrary external API callers, corrupt descriptors/banks, the full A9ED value domain, or the natural entry of the Bank 70 candidate. See the [MobileSDK output-destination census](docs/research/japanese_mobile_sdk_output_destinations_20261024.md).

**Bank 53 literal name-pointer cross-check (2026-10-24).** The original ROM contains zero exact three-byte far-pointer patterns to the Bank 53 name table or any of its 25 string starts, in either bank/address field order, and zero text command `$01` records naming those targets. The checked ROM hash is unchanged. This narrows literal cross-bank text/reference paths only; computed addresses, split fields, runtime bank selection, and generic pointer APIs remain outside the scan. No Pokémon-name/frame association or global unused claim follows. See the [Bank 53/frame revalidation](docs/research/japanese_frame_bank53_revalidation_20261024.md#exact-bank-53-far-pointer-byte-patterns-2026-10-24).

**Browser frame-style WRAM alias follow-up (2026-10-24).** A targeted 349-source Japanese scan found the eight named stores to `wBrowserFrameStyle` and no additional literal `$C2C2` operand. In the retained 311 generic-copy sites, the only nearby direct WRAM0 destination is the 25-byte account-address copy at `$C27F-$C297`; the 13 nearby direct `FillBytes` setups in WRAM0 clear `$C0D4-$C1CF`. These do not overlap `$C2C2`. Register/stack-derived destinations remain outside this bounded check, and the frame-preview input still has no proven natural caller; out-of-range RAM descriptors are not promoted to natural use. See the [selector writer and copy-alias check](docs/research/japanese_frame_bank53_revalidation_20261024.md#out-of-range-selector-writer-and-copy-alias-check-2026-10-24).

**Out-of-range frame-selector check extended to Bank 47 candidate (2026-10-24).** The retained selector decode was pinned again to the current ROM/source hashes and extended from the 24 Bank 41–46 windows to the omitted 25th candidate, `47:68F0–7640`. None of 425 far fields selected by the 85 out-of-range indices whose descriptor bytes reside in ROM points into this window. The 16 other out-of-range descriptors point outside ROM into mutable WRAM/VRAM/SRAM and remain conditional; the known maintained producers still do not supply those selectors, and the frame preview has no natural caller. This closes only the ROM-resident selector-field route to all 25 windows, not other readers or global non-use. Reproduction and receipt hashes are in [the current semantic-root reconciliation](docs/research/japanese_semantic_roots_and_destinations_20261025.md#out-of-range-frame-selector-check-for-the-25th-candidate-window).

**Candidate-window visual reinspection (2026-10-24).** Existing screen previews/component PNGs support 21 distinctive Pokémon-like visual identities among the 25 frame windows; two yellow-rodent windows remain ambiguous between Pikachu and Pichu, and the two geometric interface panels provide no supported Porygon/Porygon2 silhouette. This is visual identification only: no Bank 53 ordinal-to-window, executable selector, natural selection, or global-use claim follows. The exact window/file observations and four key PNG hashes are in the [visual evidence table](docs/research/japanese_frame_bank53_revalidation_20261024.md#window-local-visual-identifications-2026-10-24).

**External HTML to generic text-reader route (2026-10-24).** A focused source trace closed the natural browser-title injection path: HTML title parsing filters source controls below `$21`; quoted link attributes drop bytes below `$20`, and unquoted values stop before them; ordinary home/usage URLs are ROM constants, while bookmarks/history copy already loaded URLs. `Browser_DrawTitleBar` can pass the resulting title/URL text to generic `TextEngine_Run`, but these natural producer paths cannot carry command `$01` into that buffer. This is **CONFIRMED** for the reviewed maintained browser path only; arbitrary API callers, corrupted SRAM, other generic reader inputs, computed/split Bank 53 reads, and Pokémon-name/frame association remain open. Details: [external text-engine input route](docs/research/japanese_textengine_external_input_route_20261024.md).

**Natural ASCII-mail reply delta (2026-10-24).** A distinct `mail_reply_ascii` scenario follows the normal reply flow for mailbox row 2 from the retained five-message receive state. It reads the second `Mailbox_RecordAddrs_5569` entry at `25:556B–556C` (`$A251`) and executes the address/name copy loops plus address/title/body editors. The only new ROM data-read range is those two table bytes; no new instruction starts or callgraph edges were added, and `2B:6CF5` remains unexecuted. The retained union is now indexed over 72 scenarios but remains 78,128 unique starts (78,114 ROM, 14 RAM); regenerated union/summary/validation files reuse existing traces. This is evidence for this natural row-2 record selection in the emulator fixture only, not a global use/reachability claim. The inspected sender/body viewer controls do not expose a reply action, so a separate reply-via-viewer macro would not be a distinct natural route. Details and limits: [ASCII reply trace](docs/research/japanese_ascii_mail_reply_trace_20261024.md).

**Bank 26 candidate-entry update (2026-10-24).** A current in-memory run of `tools/mapper.py` found zero resolved control-flow xrefs into physical `26:5344–537B`, no unresolved indirect-transfer source in Bank 26, and no recognized code-pointer or inline gateway table there. The retained 49-site / 7,022-value dispatch matrix also has no numeric destination in `[5344,537C)` and no physical Bank 26 alias; a separate filter found no enumerated dispatch to the unresolved `00:0A2A` helper. A whole-ROM literal-pointer-shaped scan found no direct near `CALL`/`JP` target or indexed operand for `00:0A2A`; all 219 raw word matches fall in graphic sections or one Mobile Dictionary page-index list. A new whole-ROM raw-word census for the candidate span classifies all 531 matches: 21 near-transfer operands are aliases from other physical banks; seven non-control immediates resolve to Bank 70's `CommScene_ObjTable` or Bank 54's date tables; the 503 unindexed coincidences are in mapped GFX/font/text sections; and the sole explicit bank-26-shaped triple is a font-byte coincidence. This adds no known physical Bank 26 entry route. The 15 declared sprite-hook setters install only four non-null callbacks in banks `00`, `57`, and `69`; none targets the candidate interval, though the unresolved generic WRAM writer at `00:0A2A` can accept caller-supplied values. A separate raw/indexed check found no known literal or enumerated route through `FarCall_Reg`. These results cover the mapper's discovered graph, retained dispatch cases, recognized tables and explicit sprite-hook setters only; computed/runtime paths and global reachability remain unresolved. The fragment is still PROBABLE code with entry and role HYPOTHESIS. Reproduction and receipt hashes are in the [residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#whole-rom-literal-word-shapes-for-265344537c).

**Bank 28 hook, dispatch and literal-pointer routes (2026-10-24).** The existing 339-file sprite-slot writer census found no explicit hook selecting `28:4BA6–4BC1`; the 49-site / 7,022-value dispatch matrix has nine numeric aliases into the same CPU interval, all in physical Bank `4E`, and zero destinations in physical Bank `28`. A whole-ROM literal scan found zero explicit `$28` far-pointer triples and 20 near `CALL`/`JP` operands in other linked physical banks. Of the other nine indexed matches, eight are inline far calls explicitly selecting banks `4C` or `7F`; one is the `0E:4BC0` graphics source `Gfx_Title_Tiles8200And8800Vb1`, loaded with bank `$0E`. The remaining 32 unindexed raw word matches resolve to 13 graphics payloads, nine audio payloads, seven font payloads, and three same-bank dispatch-table entries in physical Banks `4E` and `0F`; none is a Bank 28 route. The current mapper projection over the 71-scenario corpus finds no resolved xref or recognized code/gateway table overlapping the physical span and no unresolved indirect source inside the span; 34 indirect sites remain unresolved elsewhere, so possible external computed targets remain open. These literal/source forms establish no direct Bank 28 reader; arbitrary computed addresses, runtime bank changes and copied code remain outside the checks. The unresolved `StoreDEAtHL_SelectWramBank7` alias and other indirect readers still prevent a global exclusion; the 28-byte span is now classified PROBABLE code and named `ClearWram0AndFillWram7WithFF`; no caller or physical Bank 28 entry is known, and intended purpose/use remain unresolved. A whole-source census of 344 maintained Japanese ASM/INC files found 21 `LD A,$28` immediates; all are used as timer, sprite/text/coordinate, MobileAPI argument, output-byte, bitmask, or SDK-state values, never as a direct Bank 28 selector. The three MobileAPI cases pass A as an argument to the ROM0 `MobileAPI` shim; the far-call macro selects the target bank from `BANK(MobileAPI)`, which is 0. This closes only the literal immediate form; computed/register-derived banks remain outside the census. See the [selector census](docs/research/japanese_remaining_semantics_batch_20261024.md#literal-28-load-versus-bank-28-selector) and [residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#current-mapper-projection-for-28-4ba6-4bc2) and [writer census](docs/research/japanese_sprite_hook_root_audit_20261024.md#computed-pointer-and-helper-call-census-2026-10-24).

**Bank 28 generic reader-argument census (2026-10-24).** A new source-only pass over 349 maintained Japanese ASM/INC files, using the current build SYM and protected ROM hash, resolved 201 `BANK(symbol)` uses to physical Bank 28 across 80 symbols. None names an address in `[4BA6,4BC2)`; the source inventory contains 90 `ReadByteFar` and 546 `Gfx_StartHDMA`-family calls, and no explicit symbol load in the scanned sources targets that interval. The exact routine name occurs only at its definition. This closes those explicit symbolic source forms, not register arithmetic, table/stack/WRAM pointers, runtime remapping or computed readers. The routine remains PROBABLE code with entry, caller and use UNKNOWN. Details and receipt hashes are in the [generic-reader census](docs/research/japanese_remaining_semantics_batch_20261024.md#bank-28-generic-reader-argument-census).

**Bank 4B zero-run refinement (2026-10-24).** The three selected slot-cell records end at `4B:76CC`; four zero bytes then reach the next 16-byte-aligned tile source at `4B:76D0`. This makes alignment padding **PROBABLE** and a reserved fourth record **HYPOTHESIS**. The source label now reflects the bounded interpretation; emitted bytes and the three-pointer table are unchanged. The selector check still excludes this interval only for its documented table. See the [residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#four-zero-bytes-before-aligned-tiles-at-4b76d0).

**Bounded Japanese retained-access census (2026-10-24; docs follow-up to `03531dd5`).** Across 71 already-retained scenarios, 599,963 ROM bytes had an instruction or data-read record; 1,497,189 had no record in that corpus. The independent bytearray recount matched the primary per-bank ledger. This does not prove global unused status or justify omitting bytes; English/ZIP remains paused. Full bank counts and input/output hashes are in the [residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#bounded-global-retained-access-census-2026-10-24-japanese-head-03531dd5).

**Coverage snapshot refresh (2026-10-24; earlier docs commit `db14a095`, current 72-scenario trace delta).** The tracked union is indexed over 72 retained scenario reports: 78,114 ROM instruction starts plus 14 RAM starts (78,128 total). It records 3,866 code regions, 2,414 fully executed, zero executed starts outside code and zero promotion candidates. The union, validation report and trace summary were regenerated from saved outputs without rerunning the corpus; the new scenario contributes no new instruction starts. These counts do not prove semantic completeness or global unused status. See [dynamic tracing](docs/research/dynamic_tracing.md#123-numbers) and the [ASCII reply trace](docs/research/japanese_ascii_mail_reply_trace_20261024.md).

**Japanese residual update (2026-10-24; prior checkpoint `2e88b334`, symbol-only source naming pass).** Fresh canonical-checkout gates pass: `make` is `RESULT: IDENTICAL` to ROM SHA-256 `6d802e66…c76570`; `make sym-check` passes 335 sources / 12,221 labels / 51 constants; `make palette-check` passes 162 loads / 116 arrays / two documented over-reads / zero errors. The bounded numeric trampoline matrix covers 7,022 cases and identifies one conditional `4E:4B7B → 4E:4BA6 → ROM0:0706` route, but no natural producer or entry to the five candidates. Concrete Bank 28 loader chains select index 1 rather than the `4BA6–4BC2` span; the known Bank 26 caller returns from `5343` before `5344`, and a direct-control-target census found no same-bank or fixed-ROM0 CALL/JP, nor inline far-transfer, into `26:5344–537C` (only the fragment's three internal relative loops). Bounded Bank 53 consumer passes found no name-ordinal/frame-address link, while the ticker's six declared ingresses use their header bank and WRAM graphics buffers. A focused keyboard writer audit found no second direct alias; its indirect-overflow candidates require malformed SRAM/strings outside documented limits and a byte decoding to `$51/$D1`, without evidence of a natural input. A new producer audit found 11 declared `Account_ResultPage` calls with kinds only 0–4; their descriptors select bank `$4B`, not the conditional Bank 42 source route. The dictionary transfer is precisely tilemap `[47B5,491D)` plus attributes `[491D,4A85)`; it reads no part of the following eleven zero bytes, now PROBABLE alignment padding: the next tile HDMA source is 16-byte aligned, as are all 289 maintained Gfx labels with explicit physical locators in gfx/. This bounded pattern does not exclude other readers. These close only the stated routes, not global reachability or semantic closure. The finite Bank 41–47 catalog now has 143 exact ROM-matching assets / 93,360 bytes and 77 referenced PNGs, with all 25 candidate windows represented; their name associations and natural selection remain HYPOTHESIS. Japanese review remains open; English/ZIP remains paused. Details and retained evidence are in the [consolidated residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md) and [frame/PNG revalidation](docs/research/japanese_frame_bank53_revalidation_20261024.md).

**Result-page indirect-selector correction (2026-10-24).** The six retained Bank 68 `JP HL` tables have no selector targeting the exact `68:766E` entry, but five out-of-domain byte selectors land inside the surrounding `[766E,7951)` region, including two interior bytes/instructions in `Account_ResultPage_LoadBanner`. Named direct producers constrain their corresponding values to other domains; natural creation of the invalid selectors and their effects remain unresolved. See the [bounded destination and byte-context audit](docs/research/japanese_remaining_semantics_batch_20261024.md#bank-68-indirect-dispatch-destinations-around-the-result-page).

**Result-page caller-domain refinement (2026-10-25).** A complete current tracked Japanese-source scan found 11 direct `Account_ResultPage` far-calls in four files; all set A to kinds 0–4 (1/2/3 each three sites, 0 and 4 once each). Together with the retained direct and recognized indirect transfer projections, this closes invalid-kind generation through those maintained routes. Runtime-created or unrecognized entry and arbitrary RAM corruption remain outside that bounded proof. The audit receipt and per-call source lines are in the [result-page selector section](docs/research/japanese_remaining_semantics_batch_20261024.md#bank-68-indirect-dispatch-destinations-around-the-result-page).

**Bank 42 tail tile candidates (2026-10-24; current pass).** Six bounded 16-byte fragments that complete preceding tile runs are catalogued as PROBABLE candidates with independent exact PNG sources. All six PNGs round-trip byte-exactly; no loader or consumer is claimed, and the original ROM bytes are unchanged. See [the grouped residual review](docs/research/japanese_remaining_semantics_batch_20261024.md#candidate-16-byte-windows-at-bank-42-residuals).

**Independent Ghidra candidate-reference query (2026-10-24).** The pinned headless query over complete candidate byte ranges found the known `2D:4E49 → 2D:4E54` call and internal branches, but failed to represent the independently byte-verified `29:50CE → 29:511E` call. `config/regions/bank29.tsv` seeds only `29:5090` for its broad code span, so the missing edge demonstrates incomplete Ghidra coverage and its zero-reference results there must not be used as negative evidence. Ghidra external Entry Point references are not ROM callers; other analyzed range references are internal control-flow edges. All results remain HYPOTHESIS-only and prove neither non-use nor unreachability. See the [full-range query and seed-granularity limit](docs/research/japanese_remaining_semantics_batch_20261024.md#full-candidate-range-ghidra-reference-query-and-seed-granularity-limit); the project-local extension lookup also handles this checkout's in-home location.

**Keyboard page-byte literal-operand cross-check (2026-10-24).** A new byte-level scan of the original ROM's absolute load/store and 16-bit address-materialization encodings for `wKbdPage=$C2AC` finds only the known `Kbd_Open` direct store, four known reads, and the Select handler's known `HL` pointer; no additional direct-store encoding appears. Computed writes and generic copies remain outside this scan, and natural entry to the conditional `$51/$D1` dispatch remains unproved. Reproduction and exact hashes are in the [residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#literal-absolute-operand-cross-check-2026-10-24).

**Keyboard page generic-copy route checked (2026-10-24).** A bounded review traced the browser guest-login copy from `Dial_CopySelectedNumber` through `$C240` to the `$C248` destination used by `Mobile_ConnectPoll`. Valid XOR-$A5 SRAM dial fields cap at 16 characters plus NUL and cannot reach `wKbdPage=$C2AC`; malformed strings would need at least 101 characters and a decoded `$51/$D1` byte to overwrite it. This is a conditional corruption path during browser connection, not a natural keyboard-page producer or entry; later `Kbd_Open` resets the page. Exact limits and receipt hashes are recorded in the [residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#keyboard-page-fragment). A second direct caller, `UsageTime_Request`, passes `$C28F` to the same decoder before the browser URL request; the keyboard byte is index 29 there, so a nonzero overwrite requires at least 30 malformed non-NUL characters plus `$51/$D1` at that position. Valid records still cap at 16 characters, and this path has no keyboard dispatch. Its receipt and limits are included in the same matrix section.

**Current Bank 41–47 finite asset reconciliation (2026-10-24).** Relative to the previously audited `25501d4b` snapshot, the current catalog adds exactly six Bank 42 16-byte tile candidates and six PNGs, with no removed or modified rows in scope. The current bounded inventory is 143 assets / 93,360 bytes across eight owner directories (55 tiles, 28 palettes, 28 tilemaps, 28 attribute maps, four raw views) and 77 PNGs (59 asset sources plus 18 screen compositions). The six new binary spans match the original ROM exactly; `gfx_export.py check` and `png_rules.py mk-check` pass for the current full manifest. This reconciles file inventory only and does not claim natural loading, frame selection or global used/unused status. Full delta and arithmetic are in [the Japanese Bank 53/frame revalidation](docs/research/japanese_frame_bank53_revalidation_20261024.md#current-bank-41-47-delta-2026-10-24).

**Current Japanese build, symbol, palette and asset gates (2026-10-24; docs HEAD `7c19214d`, source baseline `b9a591ce`).** `make` reports `SHA-256 OK` and `RESULT: IDENTICAL` to the protected 2 MiB Japanese ROM (`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); `make sym-check` passes 335 source files / 12,221 labels / 51 constants; `make palette-check` passes 162 loads / 116 arrays / two documented over-reads / zero errors; `make png-check` passes 424 tile sheets / four raw views / 37 font sheets / 95 screens; `gfx_export.py check` passes 994 assets; and `png_rules.py mk-check` passes 993 rules. The six Bank 42 candidate tile PNGs explain the change from the earlier 418/988/987 snapshots. The current finite Bank 41–47 subset is 143 assets / 93,360 bytes and 77 PNGs; its six-file delta and no-orphan result are recorded above. These file and manifest checks do not prove natural display, Pokémon-name/frame association, or global frame use. Japanese source/assets are unchanged from `b9a591ce`; English/ZIP remains paused.

**Japanese residuals consolidated (2026-10-24; tested source `7cebacb8`, documentation `e8c4fcaf`).** The current checkout passes `make` (`SHA-256 OK`, `RESULT: IDENTICAL` to protected ROM `6d802e66…c76570`), `make sym-check` (335 sources, 12,221 labels, 51 constants) and `make palette-check` (162 loads, 116 arrays, two documented over-reads, zero errors). A grouped audit classified all 99 previously unresolved `screen_ops.tsv` rows by source, bank, selector domain, or WRAM producer; it found no natural ROM42 consumer, but did find a conditional invalid-kind result-banner path whose calculated HDMA window overlaps `42:6132–6140`. No natural producer/trace establishes that invalid state, so it does not justify an asset or semantic promotion and does not establish global non-use. The audit also corrected the dictionary boundary: zero bytes `1A:4A85–4A90` begin after the paired tilemap-and-attribute transfer ending at `4A85` and end at the first tile-HDMA source; the prior broad heuristic crosses that boundary, but this 11-byte run is not part of the transfer or a confirmed tile. No residual GFX span gained a confirmed natural consumer. Six Bank 42 spans now have separate PROBABLE 16-byte tile-candidate assets and exact PNG sources; this does not establish original loader phase or consumption. The pre-addition scan found that `42:6340` duplicates an existing tile at `42:6440` and found no other exact match at tile boundaries in the 418-row catalogued tile payload set. That negative result is scoped to the pre-addition catalog. The full windows and limits are recorded in the [consolidated matrix](docs/research/japanese_remaining_semantics_batch_20261024.md). A complete explicit source graph found eight `wBrowserFrameStyle` writers and four persisted-style writers; identified fixed-style paths set 0, 1, or 2, while `Browser_BeginSession` loads a persisted value validated to 1–26 and the preview's initial A value has no proven natural caller. All 128 descriptor indices were decoded: no ROM-resident far field names bank 53, 16 indices point into state-dependent RAM/VRAM/SRAM, and no name-ordinal-to-frame chain was found. The 25 Bank 53 links therefore share one unresolved producer/selector question; Pikachu/Pichu proposals conflict and both Porygon windows remain unassigned. A complete 256-index keyboard dispatch decode found a conditional jump into `55:5E00`, inside the operands of the Select path, only for out-of-domain `wKbdPage=$51/$D1`; explicit normal writers preserve 0–3 after initialization, so natural entry remains unproved. A later bounded audit found plausible corrupted-SRAM/string overflow routes to the page byte, but no natural malformed input or byte value producing `$51/$D1` was found. A complete index decode of the confirm-screen selector excludes a four-byte read window over `4B:76CC–76D0`, but other readers remain unknown. A bounded stack/gateway census found no new natural root for the five candidate operations and does not constitute a complete indirect-dispatch census. Japanese review remains open: five natural-entry candidates, keyboard-fragment entry, three auxiliary spans, Bank 53 selector/link chain, residual GFX interpretation, and global used/unused status remain bounded by evidence. Generic-name and finite asset inventories remain closed. English/ZIP remains paused pending Japanese closure and explicit Rafael approval.

**Retained Japanese access projection (2026-10-24).** A reviewed projection of 78,128 existing coverage rows and 82,446 recorded ROM-read rows across 71 retained scenarios found no overlap with 33 bounded intervals covering the Bank 53 name block, 25 candidate frame windows, and seven documented GFX residual spans. This only describes those saved reports; it proves neither global non-use nor unreachability. Per-interval results and reproduction inputs are in the [residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#projection-of-retained-coverage-and-reads-2026-10-24-source-7cebacb8-docs-e8c4fcaf).

**Japanese Bank 53/frame revalidation snapshot (2026-10-24; HEAD `8dd8d59d`).** The original Bank 53 block re-emits 25 pointers plus 25 strings (369 bytes; zero-filled remainder); the original finite snapshot covered 137 catalogued bank `41–47` assets (93,264 bytes), 53 source PNGs and 18 screen compositions. The later six-asset Bank 42 delta and current totals are reconciled above. The 25 name-to-window links, two Porygon assignments, natural selection and global used/unused status remain unknown; eight editable compositions remain KEEP for incomplete VRAM placement. See [the bounded revalidation](docs/research/japanese_frame_bank53_revalidation_20261024.md). English/ZIP remain paused.

**Japanese sprite callback pointer-path follow-up (2026-10-24).** A source-level HL-provenance census over 339 maintained ASM/INC files classified all 1,295 calls to `Sprite_SetHook`, `Sprite_SetPosition`, `Sprite_InitSlot`, and `Sprite_ClearSlot`; none passed an unknown or computed HL pointer. The known exceptions remain `StoreDEAtHL_SelectWramBank7` at `00:0A2A` (caller-supplied two-byte write, no observed caller/entry) and unreferenced `DebugFlags_LoadHelpText`, whose WRAM3 fill overlaps the slot backup and could clear it before a later restore. This does not prove global absence or natural reachability. See the [bounded writer audit](docs/research/japanese_sprite_hook_root_audit_20261024.md#computed-pointer-and-helper-call-census-2026-10-24).

**Japanese SRAM structure-offset follow-up (2026-10-24).** The banked SRAM review correlated structured `sStruct+$offset` operands with the neutral shared-window ledger. Ten newly identified exact bank-1 fields have scoped aliases in `ram/banked.asm`; two existing check-field aliases gained byte-level names. A9F0–A9F3 are named as the source of the boot snapshot at A9F4–A9F7; the startup copy is directly established. A separate candidate span emits each source word and its arithmetic difference from the corresponding snapshot, but its boundary/caller is unproven and the values' units/domain remain unknown. New alias `sSaveCheckStateBlockRandomizedByte` names A9EE only in SRAM bank 1: candidate code tests it for zero at 70:46CE and conditionally writes values derived from `Random16` (2–4 at 46EA or $0A–$0F at 4710); entry, caller and application purpose remain unknown, while the global `sSram_A9EE` anchor stays neutral. Bank-1 aliases `sCommTimeTotalFrames`, `sCommTimeTotalSeconds` and `sCommTimeTotalMinutes` name A9F8-A9FA from their direct copies and timer arithmetic; their confidence remains PROBABLE because the SRAM mirror's only reader is an unreferenced report builder. `sSram_A8C1` is only PROBABLE as an auto-select marker because the known conditional store has no confirmed reader or natural execution. Other uncertain bytes remain neutral. The 786-row RAM ledger reconciles completely, now with 104 exact bank overlays and 56 container interiors. The Japanese census matches all 15 families with zero open rows; `make` confirms `RESULT: IDENTICAL`, `make sym-check` passes (335 source files, 12,214 labels, 51 constants), and `make palette-check` passes (162 loads, 116 arrays, two documented over-reads, zero errors). This pass does not establish runtime behavior. English and ZIP-derived work remain paused.

**Japanese SRAM field-name follow-up (2026-10-23).** Added the bank-1 alias `sSaveCheckStateBlockFlags` for offset +$05 in `sSaveCheckStateBlock`; static readers test bits 6/7 and mask `$30`, while the complete value domain and application purpose remain unknown. The shared-window anchor `sSram_A9ED` remains neutral because its usage census spans three SRAM banks. The numeric-RAM disposition ledger remains 786/786, with 89 exact bank-overlay aliases and 71 container-interior anchors. `make` returned `SHA-256 OK` and `RESULT: IDENTICAL` against the original; `make sym-check` passed with 335 source files, 12,214 labels and 51 constants. The full Japanese name census remains 15 families with no open families. This does not claim natural entry or runtime behavior.

**Bank 29:50CE natural-entry literal-target scan (2026-10-24).** A full original-ROM scan found four `CE 50` pairs; three are immediate operands to `ADC A,$50`, and the fourth lies inside the existing `4B:6A90–6E90` graphics asset. The 70-scenario corpus has no exact instruction start or recorded callgraph destination at `29:50CE`. This closes the bounded literal-target scan only; computed dispatch and natural entry remain unresolved. See the [open-question follow-up](docs/research/japanese_open_questions_followup_20261023.md#bank-2950ce-exact-target-scan-at-9f077cd0-2026-10-24).

**Bank 70:4740 literal-target audit (2026-10-24).** A full-ROM scan found three same-bank word matches into `[4740,477F)` and two apparent far-pointer triples to `70:475B`; every match is a table-byte overlap or lies inside confirmed CommScene tiles, and none targets an instruction boundary as an aligned pointer. This adds no caller evidence; natural entry/role remain HYPOTHESIS and computed or stack-derived entry remains open. See the [bounded audit](docs/research/japanese_open_questions_followup_20261023.md#bank-704740-literal-target-audit-at-19edad18-2026-10-24).

**Bank 4B slot-cell record pass (2026-10-23; bounded selector follow-up 2026-10-24).** The phone confirmation screen's three-entry selector at `67:53D6` points to named four-byte records at `4B:76C0`, `76C4`, and `76C8`; the adjacent four-zero record at `76CC` also has a structural name. An out-of-range index 3 reads the following bytes `CD 02` and computes `$02CD`, not `$76CC`; the valid caller domain remains 0–2. This excludes selection of the zero record through this lookup for index 3 only, without establishing global non-use or purpose. The rebuilt ROM remains byte-identical, and `make sym-check` passes with 12,215 labels. See the [record-boundary evidence](docs/research/japanese_confirm_screen_slot_records_20261023.md). This resolves one local data-label gap, not the broader open code/root or Bank 53 questions.

**Japanese closure checkpoint (2026-10-23; documentation HEAD `3a63c71c`, tested source `c39c1ddc`).** Work is confined to `/home/rafael/_PROJETOS/Mobile Trainer`; the English overlay and Operator ZIP remain paused. At `c39c1ddc`, `make` rebuilt the protected 2 MiB original exactly (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`), `make sym-check` passed (335 files, 12,212 labels, 51 constants), and `make palette-check` passed (162 loads, 116 arrays, two documented over-reads, zero errors). The retained Ghidra crosswalk maps all 28 ROM function starts to current global symbols; its 29th entry is the zero-instruction HRAM stub `hFarCallTrampoline`, not an unnamed ROM routine. The current finite generic-name families and asset/PNG inventories are reconciled, but this is not a complete semantic code census: natural roots, some exact code/data spans, computed Bank 53 readers, name-to-frame links, and global used/unused status remain unresolved. See the [Japanese closure audit](docs/research/japanese_closure_audit_20261023.md) for exact scope, evidence and limits.

**Japanese full gate rerun (2026-10-23; checkout HEAD `949fa2e7`).** On the canonical checkout, the immutable original remains SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; `make` reports `SHA-256 OK` and `RESULT: IDENTICAL`. `make sym-check` passes (335 files, 12,212 labels, 51 constants); `make palette-check` passes (162 loads, 116 arrays, two documented over-reads, zero errors); `make png-check` passes (418 tile sheets, four raw byte views, 37 font sheets, 95 screen PNGs); GFX catalog and PNG-rule checks pass (988 assets, 987 rules). `make test` passes all suites; `test_cfg.py:398` emits its known non-fatal unclosed-reader `ResourceWarning`. The live Japanese naming census reconciles all 15 families, with zero open families, zero strict address-only/generic-function definitions, all 2,764 local anchors and 786 RAM equates matched. These checks verify reconstruction and finite ledgers, not natural reachability or unresolved Bank 53 name-to-window associations; English/ZIP remain paused.

**Japanese current census and asset-gate revalidation (2026-10-23; `8051e779`).** The 3d971282 static-DMA asset alignment renamed two Page List resources and absorbed three former Mailbox fragment labels into complete transfer-window assets. A fresh census found the current ledgers stale; their line/address mappings and coverage counts are now reconciled to source. Current counts: zero strict address-only or generic-function-prefix definitions; 108 strict bank/address-suffix rows; 436 broad address-suffix names and 269 Candidate names (542 union rows); 2,764 local anchors; 786 RAM equates; all 15 coverage families match. `make` remains `RESULT: IDENTICAL` to original SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; current symbol/palette/PNG/catalog/rule gates pass at 335/12,212/51, 162/116/2/0, 418/4/37/95, 988 assets and 987 rules. `make test` passes with its known non-fatal open-reader warning. Eight short GFX-plan spans remain without complete-tile PNG candidates. Bank 53 name-to-window association and natural selection, and five bounded entry/role questions, remain evidence-limited. English/ZIP stay paused. See the [latest census reconciliation](docs/research/japanese_generic_name_sweep_20261023.md#live-ledger-reconciliation-after-dma-asset-alignment-2026-10-23-source-snapshot-8051e779) and [closure audit](docs/research/japanese_closure_audit_20261023.md#current-revalidation-and-ledger-correction-at-8051e779-2026-10-23).

# Reverse engineering status

**Sprite-data contract and checker correction (2026-10-23).** The CommNotice scripts at `50:6CE6` and `50:6D11` are `[CONFIRMED]` two-pair records, and their first frame-record labels now match the single-record extents. The five-pair script at `2C:7354-735F` is also represented as a complete `[CONFIRMED]` script; its former mid-script `ObjAnimData` label is removed. `sprite_chain_check.py` now counts reached frame records in `ObjAnimData` blocks; its full current run covers 49 roots and 291 frame tables with zero index violations and zero hard mismatches. These are static structure checks only; natural selection of CommNotice entry 1 and measured frame timing remain unproved. The stale slot-layout annotation is corrected. Details and limits are in [`sprite_format.md`](docs/research/sprite_format.md#8-corrections-to-earlier-text).

**Japanese census reconciliation after sprite-script classification (2026-10-23).** The misleading `AddrSlotIcon_ObjAnimData_2C_7357` alias is removed; its bytes now belong to the full five-pair script at `2C:7354-735F`. `BrowserShared_ObjAnimData_72_786E` is renamed to the confirmed `BrowserShared_Anim12Frame0`. Row ledgers and the coverage matrix now match 106 strict bank/address-suffix labels and 434 broad suffix labels (540 suffix/Candidate union rows). The remaining source, local-anchor, RAM and path families are unchanged. See the [live census ledger](docs/research/japanese_generic_name_sweep_20261023.md#current-sprite-script-reconciliation-2026-10-23-source-head-before-this-checkpoint).

**Japanese body-keyboard reset branch trace (2026-10-23).** A scripted-input mGBA replay from the saved Japanese `kbd_abook` fixture reached `2D:5A6F–5A77`, the `MailBody_KeyboardLoop` `$08` result branch that clears `rSCY` and `wSplitScrollY`, once at frame 14927. This confirms execution of that local branch in this scenario only. The trace reports `ret_unmatched` at `2D:5A77 -> 2D:477A`, so it does not establish a conventional return ABI; it is not hardware evidence or proof of all keyboard routes. The operation-root and Bank 53 questions remain as documented. See the [trace note](docs/research/japanese_body_keyboard_reset_trace_20261023.md).

**Bank 29 MBC5 gate sequence (2026-10-23).** New ROM-byte and mapper-map evidence identifies the commands at `29:50DA`: ROM0 bytes `CD 18` form `$18CD`; `5*$18CD+$3711=$B312`, so the first write sends `$12` to MBC5 RAMG and the second sends `$B3+LY`. Under the MBC5 decode, the latter enables RAM only when `LY & $0F == 7`. The operation is now `PalLibCandidate_DisableMbc5RamThenWriteLyDerivedGateValue`; its natural entry, runtime LY, physical-hardware result and broader purpose remain unproved. See [the Bank 29 evidence update](docs/research/typing_29_palette_library_evidence_limits.md#mbc5-ram-enable-commands-at-2950da) and [Pan Docs MBC5 register definition](https://github.com/gbdev/pandocs/blob/master/src/MBC5.md#registers).

**Japanese finite-gate revalidation (2026-10-23; `826dbdec`, historical baseline).** At the canonical checkout `/home/rafael/_PROJETOS/Mobile Trainer`, `make` verified ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` and `RESULT: IDENTICAL`; `make sym-check` passed (335 source files, 12,212 labels, 51 constants), and `make palette-check` passed (162 loads, 116 arrays, two documented over-reads, zero errors). At that dated baseline, the Japanese name census matched all 15 coverage families and ledgers (2,764 local anchors, 109 suffix rows, 545 broad dispositions, 786 RAM equates), with 986 GFX catalog rows and 985 PNG rules. The 2026-10-23 DMA-window follow-up below raises those asset/rule counts; its validation results and remaining short spans supersede the baseline GFX counts, while the bounded entry/role questions, Bank 53 name/window mapping, and unknown frame selection remain open as recorded below. The English overlay and ZIP remain paused and untouched.

**Bank 2D reply-leave prompt block (2026-10-23).** The local block at `2D:6726` is now `.ShowReplyLeavePrompt`: the mode dispatch sends the reply flow to dialog `$020F`, whose cataloged Japanese text asks whether to discard an unfinished reply; the reply setup writes mode 3 before entering `MailAddr_Edit`. A no-force/ramset replay records `2D:66D3` and its target `2D:6726` three times, with no fall-through instruction at `2D:66D5`; this confirms the conditional edge for those three events. The `farcall Dialog_Show` site at `2D:6740` also executes three times, all first seen at frame 21103. Screenshots at frames 21103/21104 are identical and show no modal prompt, so visible persistence remains unproved. See [`japanese_natural_mail_reply_trace_20261023.md`](docs/research/japanese_natural_mail_reply_trace_20261023.md#replay-follow-up-dialog-call-site-observed-2026-10-23).

**Keyboard indexed-data follow-up (2026-10-23; prior evidence at `ba385306`; earlier census snapshot).** The code at `55:6F46` uses one modulo-four index to read four two-byte values at `55:6F95` for OCPD / `wPaletteBufObj+$32` and four bytes at `55:6F9D` to reload `wRam_C2B1`. The data label is now `Kbd_Candidate_PaletteWordsAndReloadCounts` [PROBABLE layout]; natural entry, caller and visible effect remain HYPOTHESIS. At that earlier census snapshot, the ledgers contained 269 `Candidate` labels and 545 combined suffix/Candidate rows; the current source-aligned ledger has 542 rows after the DMA-source reconciliation at `8051e779`. No ROM bytes or language overlay changed.

**Historical Japanese generic-name census snapshot (`d88444c2`; current counts superseded by `8051e779`).** The reproducible `python3 tools/japanese_name_census.py` covers 349 tracked Japanese ASM/INC files (excluding the protected `engine/mail/sample_data.asm` before reading and excluding language overlays) plus the tracked GFX paths. It reports zero strict address-shaped global definitions; an independent full-tree scan also found zero active `Function_`, `Func_`, `Sub_`, `Routine_`, `Unknown_`, `Unk_`, `Code_`, or `Label_`-prefixed definitions. This closes those lexical families, not semantic identification of unlabelled code or operation purpose. It reports three reviewed names with marker tokens (`BrowserMenu_PlaceholderText`, `CommErr_Msg_GenericCommError`, and `Mail_SelectorNop`) and zero unreviewed marker labels, zero generic bare `gfx/bankNN/` components, and zero strict address-only GFX basenames. The former `SoundDrv_CmdUnassigned` label is now `SoundDrv_CmdJumpToEnd`, which states its exact `JP SoundDrv_CmdEnd` behavior; the interpretation that these table slots are unassigned remains PROBABLE. The census fails on unreviewed marker labels, strict address-only definitions, short local placeholders, generic GFX path forms, and missing, stale, duplicate, incomplete, family-flag, or source-address mismatches in the broad name-disposition ledger; it checks both directions of the local-anchor ledger and the 786-row numeric RAM ledger (including duplicate and incomplete dispositions). The broader scan finds 109 global labels with bank/address suffixes and 786 numeric RAM equates; `--generic-list` prints both candidate families. All 109 suffix-bearing labels now have individual rows in the linked ledger, matched to current source by path/line/label and independently reviewed. The broader scan inventories 439 global labels ending in `_AAAA` or `_BB_AAAA`; all 439 now have row-level dispositions in [`japanese_name_candidate_dispositions_20261023.tsv`](docs/research/japanese_name_candidate_dispositions_20261023.tsv), reusing the existing 109-row ledger and dispositioning the other 330. The same union ledger now dispositioned all 269 labels containing `Candidate` (163 overlap the suffix family); the new keyboard data name remains qualified because its natural entry and visible effect are unproved. The local-anchor ledger is checked in both directions, with no unrecorded numeric `.lAAAA` definitions. These inventories do not certify natural entry, product purpose, or every resource identity. All 786 RAM equates now have a complete region-by-region evidence disposition. Four evidence-supported operand aliases were applied, while reused/bank-dependent global anchors remain neutral. Neither batch certifies natural entry, product purpose, or every resource identity. The complete RAM batch and its verification are in the linked report. The user's earlier examples now resolve in maintained source: `75:4000` is `MobileSDK_CopyBytes` [CONFIRMED], `68:6960` is `Config_DefaultImage2` [PROBABLE record identity; fields undecoded], and `48:4ADB` is `Font_GlyphRun_824F` [PROBABLE glyph run]. The former unresolved 7F tile span is now `Gfx_MailAddr_ObjHDMABytesCopy_7F_7830`: its 720-byte identity with the MailAddr OBJ HDMA source is CONFIRMED, while a loader/use of the 7F copy remains unknown; the prior `Settings_ReadData_UnknownContent_7271` label was retired after its two exact 640-byte HDMA assets were identified and documented. A broadened comment scan reconciles 19 complete-function/operation-boundary clues; four previously unlabelled bounded operations now have behavior names (`SaveCheck_GetStateBlockBit7`, `SramCheck_VerifyBank1_ClearOnMismatch`, `SramCheck_VerifyBank1_ReturnStatus`, `TimerB_IsAtLeast30Minutes`). Three called RET-only sprite-counter labels and one SDK state/TCP label were also clarified. The local-anchor ledger matches 2,764/2,764 rows (412 RENAME, 2,352 KEEP). These are inventory and naming results, not proof that every function is naturally reachable or that all semantics are closed; entry/reachability for the four new operations remains HYPOTHESIS. Frozen `config/` and historical research records may still display retired address labels; they are not active maintained source. `make` reports `RESULT: IDENTICAL` to protected ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; `make sym-check` passes (335 source files, 12,212 labels, 51 constants); `make palette-check` passes (162 loads, 116 arrays, two documented over-reads, zero errors); `make png-check` passes (416 tile, 4 raw-view, 37 font, 95 screen PNGs); GFX catalog check passes (986 assets) and PNG rules check passes (985 rules). The English overlay and Operator ZIP remain paused and untouched. See the [consolidated generic-name sweep](docs/research/japanese_generic_name_sweep_20261023.md). The live census and row-level ledgers were rerun for the 7F path reconciliation: 349 Japanese ASM/INC inputs, 109 descriptive bank/address-suffixed labels, 2,764/2,764 local-anchor rows, 786/786 RAM equates and 32/32 RET-only bodies. The current path scan has zero generic bare `gfx/bankNN/` components, 28 owner-qualified bank-suffix GFX directories, 30 owner-qualified `*_bankNN.asm` files (including `pokemon_names_bank53.asm`), and zero address-only GFX basenames. Historical rows in dated reports are retained as provenance, not current counts. The 7F resource-path reconciliation preserves payload bytes. The follow-up renamed the one-RET helper `Stub_Nop_48_48BB` to `ReturnImmediately`; its wider hook purpose remains unknown and its exact mechanical return is CONFIRMED.

**Japanese operation-boundary batch (2026-10-23).** A consolidated follow-up named three previously unlabelled spans already bounded in research: `2C:6100` (`AddrPick_DrawSixSlotNamesAtX30`), `55:6F46` (`Kbd_Candidate_DecrementC2B1OrAdvanceC2B0AndWriteOcpd`) and `73:6149` (`ReadC0F9_Xor1`). Their mechanics are byte-supported; entry, caller and application purpose remain qualified in [the follow-up report](docs/research/japanese_unlabelled_operation_followup_20261023.md). The [single operation-boundary worklist](docs/research/japanese_operation_boundary_worklist_20261023.tsv) joins those with the twelve bank-29 operations and the five entry/role questions still open. The operation labels do not change emitted bytes. The current combined Candidate inventory is 269 (70 in engine, one in data, 198 in gfx); these tokens indicate ownership or uncertainty, not generic-name defects.

**Bank 70:4740 trace-corpus recheck (2026-10-23).** The current retained corpus contains 70 tracked coverage reports and 70 paired callgraphs. None records an instruction start or control-flow destination inside physical bank `70:[4740,477F)`. This corrects the earlier note that coverage had not been inspected for `SaveCheck_GetStateBlockBit7`, but remains a bounded negative result: its local bit-reader mechanics are PROBABLE, while entry and field purpose remain HYPOTHESIS. See the [corpus recheck](docs/research/japanese_open_questions_followup_20261023.md#bank-704740-against-the-retained-70-scenario-corpus-at-abb8e757).

**Sprite animation script contracts (2026-10-23).** Static reader behavior confirms the count/pair layout for ten table-referenced scripts in banks 2A and 29: each pair supplies a frame-pointer-list index and a slot-update countdown reload. Their table callers and natural display remain unproved. The GFX `Still db` summary no longer describes its entire HYPOTHESIS-data category as padding; the remaining orphan scripts and unclassified spans retain their current confidence. See [the graphics completeness follow-up](docs/research/japanese_graphics_asset_completeness_followup_20261023.md#sprite-animation-script-contracts).

**Natural Mail HelpScript route (2026-10-23).** The natural Help page 2 cursor 1 route renders all 31 Mail topic screens and returns to the menu. The terminal script store at `6C:51A4` and dynamic bank-1 write span confirm the `$A686` topic association; the seed already had that byte set, so no 0-to-1 transition was observed. The bounded recheck reproduced 32/32 screenshots exactly. The natural `$89` first-use variant is confirmed in the following entry; hardware behavior remains unproved. See [`mail_help_script_natural_route_20261023.md`](docs/research/mail_help_script_natural_route_20261023.md).

**Natural first-use Mail gate ID `$89` (2026-10-23).** The natural `register` → `tutorial_profile` route renders the 31 common Mail pages plus the first-use-only nickname prompt at `6C:5177`, then opens `Profile_Edit`. The branch at `6C:516F` skips that prompt only for normal menu ID `$09`. SRAM bank-1 `$A686` transitions from 0 to 1, and counter `$A89A` from 0 to 1. The captured page sequence matched 29/31 normal-route pages exactly and the remaining two were manually compared; dynamic callgraph/data-access outputs and existing scenario screenshots reproduce exactly. `$81/$8A/$91/$92` first-use routes are now confirmed in separate natural-route reports; conditional branches and hardware behavior remain unproved. See [`mail_first_use_id89_natural_route_20261023.md`](docs/research/mail_first_use_id89_natural_route_20261023.md), [`help_script_id81_natural_route_20261023.md`](docs/research/help_script_id81_natural_route_20261023.md), [`mail_first_use_id8a_natural_route_20261023.md`](docs/research/mail_first_use_id8a_natural_route_20261023.md), and [`help_script_homepage_first_use_ids91_92_natural_routes_20261023.md`](docs/research/help_script_homepage_first_use_ids91_92_natural_routes_20261023.md). See [`mail_first_use_id89_natural_route_20261023.md`](docs/research/mail_first_use_id89_natural_route_20261023.md).

**Natural HelpScript dispatch matrix (2026-10-23).** The ten selector IDs in the static dispatch at `6C:4809`—`$01`, `$09`, `$0A`, `$11`, `$12`, `$81`, `$89`, `$8A`, `$91`, and `$92`—now each have at least one observed natural mGBA route. The ordinary Help-menu entries render/return 18/31/13/14/7 pages for IDs `$01/$09/$0A/$11/$12`; the first-use routes cover `$81` (26 tutorial states and top-menu return), `$89` (31 common Mail pages plus nickname prompt, then Profile_Edit), `$8A` (13 AddressBook pages and Mail-menu return), `$91` (11 HomePage pages and browser start-menu return), and `$92` (five PageList pages and browser start-menu return). ID `$01` has two identical 20-capture runs; IDs `$81/$8A/$91/$92` also have paired repeated-capture runs as linked in their reports. This closes natural entry coverage for those ten dispatch selectors only; it does not close all conditional `$06/$18` branches, all variable values, every glyph interpretation, or hardware behavior. See [`help_script_id01_natural_route_20261023.md`](docs/research/help_script_id01_natural_route_20261023.md), [`help_script_id81_natural_route_20261023.md`](docs/research/help_script_id81_natural_route_20261023.md), [`mail_first_use_id89_natural_route_20261023.md`](docs/research/mail_first_use_id89_natural_route_20261023.md), [`mail_first_use_id8a_natural_route_20261023.md`](docs/research/mail_first_use_id8a_natural_route_20261023.md), and [`help_script_homepage_first_use_ids91_92_natural_routes_20261023.md`](docs/research/help_script_homepage_first_use_ids91_92_natural_routes_20261023.md).

**Name-audit coverage correction at source snapshot `3ca7c25c` (historical counts superseded by `8051e779`).** The prior lexical summary did not distinguish completely reviewed candidate families from families merely printed by the scanner. The new [coverage matrix](docs/research/japanese_name_audit_coverage_20261023.tsv) makes that gap explicit and `tools/japanese_name_census.py` now fails if any recorded family's live count drifts. The matrix now shows all 15 census families dispositioned. The broad name ledger covers all 439 address-suffix labels and all 269 labels containing `Candidate`, with 163 rows shared by both families (545 union rows); those counts are naming-review inventory sizes, not confirmed generic defects. A separate [path-name ledger](docs/research/japanese_bank_path_name_dispositions_20261023.tsv) reviews all 58 owner-qualified bank-number paths (28 directories and 30 ASM filenames); each has a content/owner stem and bank provenance, with repeated `entry_screen` and `panels` names requiring the suffix to distinguish sets. There are zero bare `bankNN/` directories. `pokemon_names_bank53.asm` is content-named. Its finite Bank 53 table/window/PNG inventory is already audited and found no missing or orphan assets in scope; only the name-to-window mapping and natural selection remain unresolved, as findings rather than pending audit work. The 19 function-boundary clues, 32 RET-only bodies, 2,352 numeric local anchors, 786 RAM equates, 109 bank/address-suffix rows, and strict generic families remain matched to their current ledgers/reports as stated in the matrix.

**Bank 29 bounded operations (2026-10-23).** A direct byte review of the candidate section `29:5090–5376` named twelve previously unlabelled operation boundaries, including the LCDC bit setters, bounded WRAM/OAM operations, palette I/O routines, and a byte-arithmetic sequence whose writes have unproved hardware effect. The labels state decoded local mechanics only; natural entry, external callers and library purpose remain unproved. The operation intervals and original-ROM slice hashes are in [the bounded operation audit](docs/research/typing_29_unlabelled_operations_20261023.md). All added symbols pass `sym-check`, and `make` remains byte-identical. The Bank 29 pass raised its snapshot inventory from 255 to 267; the later keyboard candidate labels bring the current aggregate inventory to 269. These are inventory flags, not generic-name defects.

This is the authoritative current status summary. Later dated census and pass notes in this file are historical snapshots unless explicitly linked from this summary; their counts and queues must not be treated as current when they conflict with the versioned census and current research notes.

**Japanese GFX asset completeness follow-up (2026-10-23; Bank 51 tail split 2026-10-24).** Static transfer-window review added exact editable PNG/2bpp coverage for the Page List windows `24:5EE0..62E0` and `24:62E0..64E0`, mail-title `2C:5410..5670`, and mailbox windows `25:69F0..6CF0` and `25:6CF0..6EF0`, including tiles crossing former source boundaries. These are source-byte and static-transfer findings, not natural display or higher-level image identity. The former `51:70D1` 15-byte residual is now a **PROBABLE** zero-filled alignment gap before confirmed code at `51:70E0`, not a PNG candidate; seven short spans remain in the bounded plan (six Bank 42 spans and `1A:4A85`). Ownership/use questions for those spans remain open, and the bounded review makes no global completeness claim. A separate current recheck confirms 173 BG-attribute bytes at `73:4530..45DD` appear in saved data-read reports while the three bytes at `73:45DD..45E0` do not; this is finite-corpus evidence only, not global unused status ([report](docs/research/browser_start_orphan_gfx_assets_20261021.md#data-read-report-recheck-at-japanese-head-3d971282)). The adjacent Bank 4B mixed-copy windows remain represented by typed assets; the four-zero tail at `$76CC` remains purpose-unknown. See [the graphics completeness review](docs/research/japanese_graphics_asset_completeness_followup_20261023.md).

**Bank 4B notice-header assets (2026-10-23).** The former `4B:6590..6A90` DB span is now two exact 640-byte 2bpp sheets for descriptors `$14` and `$15`. Their 10×4 decoded tiles form Japanese notice-header artwork, and `rgbgfx` round-trips both PNGs to the exact binaries. The loader requests 40 blocks at VRAM1:`$9300`; natural selection and screen composition remain unknown. See [the bounded source note](docs/research/notice_header_gfx_sources_4b_6590_6810.md).

**Bank 29 palette candidate sequences (2026-10-23).** Four RET-delimited blocks at 29:5159, 517D, 51B3, and 51D7 now have PROBABLE operation names for blackward/whiteward fades. Two block variants re-copy and rewrite their original source after the fade. Natural entry and buffer-bank contract remain unknown; the names do not establish reachability or purpose. See [the bounded sequence note](docs/research/typing_29_palette_sequences_20261023.md).

Use the [current generic-name sweep](docs/research/japanese_generic_name_sweep_20261023.md) as the cross-category inventory and source of links to row-level ledgers, including the complete 2,764-row local-anchor disposition and the consolidated batch closure of ten address-only data names. The 69-scenario check found no executed instruction starts or overlapping ROM reads across those spans; it does not prove universal non-use or establish the new candidate labels as code. The Japanese build is `RESULT: IDENTICAL`; symbol and palette checks pass for the current source.

The current cross-category result is reconciled in the [Japanese generic-name sweep](docs/research/japanese_generic_name_sweep_20261023.md): exact source-definition and asset-path counts, the batch disposition of all ten former address-only data labels, and a complete row-level review of address-only local labels. New candidates must be reconciled against these ledgers before a rename is proposed; do not restart the same lexical or semantic queues without new evidence.

**Japanese open-question follow-up (2026-10-23).** A consolidated visual review found recognizable artwork for 23 of the 25 Bank 53 Japanese names; those visual identities are PROBABLE, while every name-to-window/table/selector association remains HYPOTHESIS. Porygon and Porygon2 remain unresolved, and the finite asset census found no missing referenced or orphan files. Eight incomplete editable compositions remain KEEP. A separate successor-address census checked 34 byte-verified numeric predecessor slices for four candidate natural-entry roots; all four roots remain UNKNOWN, and ordinary same-bank/far-call returns do not establish their entry. A later focused, scripted mGBA reply trace executes `25:54A7` but not `2B:6CF5`; this narrows one exercised route only and does not prove unreachability. See [the consolidated follow-up](docs/research/japanese_open_questions_followup_20261023.md).

**Consolidated generic-name/path follow-up (2026-10-23).** A fresh census at `28386b9d` covered 333 maintained Japanese ASM/INC files (6,649 global and 5,473 local definitions), including 3,872 address-only `.lAAAA` control-flow labels omitted by earlier `::`-only scans. All local labels have an in-owner reference; one directly evidenced copy block is now `.copy_title_bytes_to_buffer`. The ten former `Data_BB_AAAA` spans now use structurally qualified, uncertainty-preserving names after original-ROM and independent reference review; the wider Candidate/Unknown/Unresolved tokens were classified rather than treated as defects. Two generic GFX owners and their folders were renamed to `help_menu_bank6a` and `help_script_bank6a`, with current manifests updated. Build identity, symbol, palette, PNG and diff checks pass. This does not close semantic identification of every local label or the original ROM: the interpretation/reachability of ten candidate data/opcode spans, four natural-entry roots, and Bank 53/frame usage remain open. Details: [consolidated census follow-up](docs/research/japanese_generic_name_census_followup_20261023.md).

**Four candidate natural-entry roots rechecked (2026-10-23).** A byte-validated 104,200-instruction index was additionally searched for exact immediate references and adjacent `LD L,low`/`LD H,high` pointer construction. The only bank-correct edges remain the known internal calls `2D:4E49 -> 4E54` and `29:50CE -> 511E`; the apparent `4C:4E42` JR belongs to bank 4C. Both byte orders were checked in the finite ROM owner allowlist. No new natural root was found, and all four entry questions remain UNKNOWN. This does not establish unreachability; stack/bank producers or a natural trace are still needed. See [the expanded byte-construction audit](docs/research/japanese_entry_byte_construction_followup_20261023.md).

**Root-scope audit consolidated (2026-10-23; base `60204c03`).** Independent read-only reviews examined the complete `2B:6CF5`, `2D:4E42/4E54`, and `29:511E` candidate spans and their exact incoming-target patterns. No new caller or natural producer was found; only the two already-known internal CALL edges remain, and all four candidate roots stay UNKNOWN. The source operations already have bounded, evidence-qualified names, so this result supports no further rename. Reopen these searches only on new positive evidence. The forced-only `2B:6CF5` fixture's “unreachable twin” comment is not proof of unreachability and is documented as an unverified historical description. See the [consolidated root and frame follow-up](docs/research/japanese_open_questions_followup_20261023.md#consolidated-candidate-root-audit-at-60204c03e8637ee62577a90d68c58affea11761c-2026-10-23).

### Consolidated Japanese generic-name census (2026-10-22; base `7973e199`)

**Follow-up at `9933491256940424192ffff7d3c105c910a47431`:** the 13 original
data spans were adversarially rechecked across source, access, coverage,
far-call and xref records. Three now carry names describing confirmed byte or
masked-code correspondences; their Trainer type, use and origin remain
unproven. Ten exact `Data_BB_AAAA` labels remain neutral for lack of stronger
evidence. The same checkpoint rechecked
the Bank 53 names and frame assets; files and declared conversions are
complete, but name-to-frame and natural-use questions remain open. The
follow-up reports are
[`generic_data_name_followup_20261023.md`](docs/research/generic_data_name_followup_20261023.md)
and
[`bank53_names_frames_assets_audit_20261023.md`](docs/research/bank53_names_frames_assets_audit_20261023.md).

The full Japanese source/name/path sweep is recorded in [`japanese_name_census_closure_20261022.md`](docs/research/japanese_name_census_closure_20261022.md). At that census base it reviewed all 350 tracked ASM/INC inputs (3,872 numeric local branch labels excluding protected sample data), all 786 neutral RAM equates, all 13 exact `Data_BB_AAAA` labels, the frozen config name fields, and the complete 1,950-file GFX/font path inventory. Six mail-status `_Unknown` labels were replaced with content-based `QuestionMarks` names, and three source labels/asset paths now document statically covered HDMA slices. Pure `bankNN` paths and exact type/address-only function or asset names were not found. This is a completed search inventory, not semantic closure: four natural-entry questions and the final Japanese Pokémon/frame review remain open. The English overlay and ZIP remain paused.


Evidence levels: **CONFIRMED** (demonstrated), **PROBABLE** (strong evidence, not conclusive), **HYPOTHESIS** (unverified).  Names without evidence stay neutral
(`Function_<bank>_<addr>`, `Data_...`, `wRam_XXXX`; `STYLE.md` section 4).  Detailed, per-topic notes live in `docs/research/` (index: `docs/README.md`).
Numbers marked "frozen" describe `config/` at the freeze and are not updated any more; numbers marked "source" were counted in the `.asm` tree when this file was written
(the tree is edited by hand, so recount with the command given).

## Current original reconstruction and asset-audit limits
### Sample-data generic aliases (2026-10-22)

Five former `Data_2D_AAAA` and eleven `String_2D_AAAA` labels in `engine/mail/sample_data.asm` were exact-address aliases of existing `MailSample*`, `AbookSample*` and `SampleData_Name` labels. The sixteen redundant definitions have been removed without changing record/string bytes or layout. The rebuilt Japanese MAP/SYM contains 14 exact `Data_BB_AAAA` names and none of the retired aliases. See [`japanese_sample_data_aliases_20261022.md`](docs/research/japanese_sample_data_aliases_20261022.md). This naming cleanup does not establish sample field meanings beyond those existing labels.

### Bank 72 dialog line labels (2026-10-22)

Nine `String_Dialog_Candidate*` labels now name their statically mapped message index and line position, including one first-line suffix whose `$F9,"D"` bytes remain uninterpreted. The changes preserve every ROM byte and make no natural-selection or display claim. See [`japanese_dialog_line_labels_20261022.md`](docs/research/japanese_dialog_line_labels_20261022.md).

### Historical partial Japanese name/GFX census (2026-10-23; source snapshot `0fa24aa1`; superseded)

At source snapshot `0fa24aa1`, a partial census of 337 Japanese ASM/INC files outside the separately reviewed bank 41–47 graphic owners found 13 exact `Data_BB_AAAA` definitions. This result predates the consolidated rename batch and is not a current count. The GFX scan also recorded 15 stale screen IDs, which were regenerated from descriptive tilemap asset paths without changing row data. Its finite Bank 53 inventory found no missing files, while name-to-window assignment and runtime-unused status remained unproved. For current counts, use the [versioned Japanese generic-name sweep](docs/research/japanese_generic_name_sweep_20261023.md); for current Bank 53 limits, use the [consolidated follow-up](docs/research/japanese_open_questions_followup_20261023.md).

### Profile initial-screen graphics slice (2026-10-22)

The 624-byte interval at `26:7840` is now identified as the interior 39-unit slice of a static 42-unit HDMA request from `26:7820` to VRAM bank 0 `$8000`. Its derived destination is `$8020-$8290`; the final 16-byte unit at `26:7AB0-$7AC0` is the separately owned zero tail. The source label and asset path now describe this transfer slice, and the asset remains byte-identical. Static inclusion/destination are CONFIRMED. Tilemap selection, natural execution in this pass and displayed meaning remain unproved. This corrects the historical “no located transfer” conclusion, which searched for a transfer starting at `26:7840` and missed containment in the larger request. See [the independent transfer audit](docs/research/japanese_profile_init_screen_tile_slice_20261022.md).

### Japanese graphics path/name census (2026-10-22; source `c3484478`)

The full tracked GFX tree has no literal `bankNN` directories or `bankNN.*` basenames. The expanded type/address scan found only two GFX `Data_BB_AAAA` labels, both retained HYPOTHESIS because their readers are not established. Frame-design and browser-frame names are descriptive and preserve candidate status where warranted. The 978 asset, 95 screen and 133 preview rows passed their scoped path/owner checks. This does not prove visual selection, natural use or semantic closure. See [the full GFX naming review](docs/research/japanese_gfx_name_review_20261022.md).

**Local branch-label cleanup (2026-10-22).** Two bounded passes replaced 97 address-only `.lAAAA` labels with operation names, covering arithmetic/HDMA, mail, audio, image conversion, sprite counters, and Mobile SDK helpers; the first pass also named the local block at `55:5DF5`. A source scan counted 4,942 `.lAAAA` labels at the `cbedacbd` base; 4,845 remain. These are internal labels, not a count of unidentified functions, and still need evidence-based review. The five residual natural-entry cases remain UNKNOWN; no natural caller was established. Static local names do not establish product purpose or natural execution. See [`local_branch_label_pass_20261022.md`](docs/research/local_branch_label_pass_20261022.md).

**Local operation labels (2026-10-23).** A further independently reviewed pass renamed 72 local labels across the Mobile SDK main/mail libraries and keyboard engine. The tracked six-root scan (excluding protected sample data) now counts 4,773 numeric `.lAAAA` definitions, down from 4,845 at the pass base. These are local labels, not unidentified functions. All 72 token-only renames preserve comments, instructions, operands and bytes; the Japanese build remains identical. Twelve remaining neutral `Data_BB_AAAA` candidates were separately reviewed and kept neutral because their entry or content type is not established. See [`local_branch_label_pass_20261023.md`](docs/research/local_branch_label_pass_20261023.md).

**Page-list prototype local-label pass (2026-10-23).** The static audit of `engine/unreferenced/page_list_prototype.asm` renamed 116 of its 117 numeric local labels across 22 lexical owners; one immediate fall-through target remains `.l5F6C`. The 162 references to renamed labels were updated, while the KEEP reference remains unchanged. The tracked six-root census, excluding `engine/mail/sample_data.asm`, now finds 4,375 numeric `.lAAAA` definitions, down from 4,491. The token-only transformation reconstructs its source exactly in reverse and does not establish reachability, natural execution, resource identity or product purpose. See the [research and independent verification](docs/research/local_branch_label_pass_20261023_page_list.md) and [exact mapping](docs/research/local_label_mapping_20261023_page_list.tsv).
**Mail editor and SDK residual local-label pass (2026-10-23).** Independently reviewed static-flow mappings renamed 127 labels/195 references in the mail body editor and 376 labels/482 references in the Mobile SDK main file; two and 37 labels, respectively, remain neutral where evidence did not support a unique role. The token-only changes reverse exactly by lexical owner. Across the tracked six-root census, excluding protected engine/mail/sample_data.asm, 3,872 numeric .lAAAA definitions remain, down from 4,375. These are local labels, not unidentified functions. The names do not establish natural reachability, product purpose, or complete callee/protocol contracts. See the body-editor and SDK residual research/verification reports and exact mapping files.


**Neutral data-label follow-up (2026-10-23; historical checkpoint).** At that follow-up base, the tracked six-root census contained 13 exact `Data_BB_AAAA` definitions outside the protected sample-data source; three later gained correspondence-qualified labels. The subsequent consolidated source census has ten exact neutral `Data_BB_AAAA` definitions, listed with per-span dispositions in [`japanese_generic_name_census_followup_20261023.md`](docs/research/japanese_generic_name_census_followup_20261023.md). Computed or unmodeled access remains possible; these counts do not establish global non-use. The earlier 13-span review remains in [`generic_data_name_followup_20261023.md`](docs/research/generic_data_name_followup_20261023.md).

The current instruction census also replaced four `$FFA8` CALL/JP operands with the confirmed HRAM symbol `hFarCallTrampoline`. Six other numeric CALL targets remain explicit because their bank/entry is ambiguous or their target is junk, padding, or a mid-instruction address. They are not functions to be renamed. See the current target disposition in [`original_closure_followup_20261021.md`](docs/research/original_closure_followup_20261021.md#current-numeric-call-target-review-2026-10-22).

### Japanese sprite labels and bounded byte audit (2026-10-22)

A bounded audit replaced 503 type/address sprite labels across 12 Japanese graphics owners with structural names based on owner, object-table entry and frame order. Independent macro reconstruction matched 7,719 audited source bytes to the original ROM with no mismatches, and the full ROM build remains the identity gate. This establishes naming and byte correspondence only: it does not prove visual identity, natural runtime use, or that unrooted tails are unused. The audit records raw tails, unresolved candidate scripts, and confidence limits in [`japanese_sprite_owner_audit_20261022.md`](docs/research/japanese_sprite_owner_audit_20261022.md). The English overlay remains paused.

### Keyboard panel tile asset paths (2026-10-22)

Nine T4/T5/T9 and shared keyboard tile pairs in Banks 5D/5F now use names based on existing labels and confirmed VRAM destinations. Their hashes and ROM bytes are unchanged; see [`keyboard_panel_tile_paths_20261022.md`](docs/research/keyboard_panel_tile_paths_20261022.md). The English tree remains untouched.

### Bank 58 registration notice asset paths (2026-10-22)

The address-only paths for the Bank 58 registration notice tiles, palette and 20×18 tilemap pair now follow the existing notice-family labels and static Bank 65 readers. Twenty-seven files were moved without byte changes; tile groups that remain PROBABLE are named as candidates, with no claim of natural display. The path map and evidence are in [`registration_notice_bank58_resource_paths_20261022.md`](docs/research/registration_notice_bank58_resource_paths_20261022.md). The English tree was not accessed.

### ConnectDialog Bank 56 tile paths (2026-10-22)

Eleven address-only tile paths and their PNG sources now describe the existing dialog family and confirmed static VRAM destinations. The stored-password graphics remain split across the shared `$64C0` source and `$68C0` continuation at VRAM `$9200`; transfer overlap and bytes are unchanged. See [`connect_dialog_bank56_tile_paths_20261022.md`](docs/research/connect_dialog_bank56_tile_paths_20261022.md). The English tree remains paused and untouched.

### Bank 70 communication-scene graphics paths (2026-10-22)

Twenty-eight Japanese ROM-backed asset paths and nine associated PNG paths now use the audited static transfer destination, shared-source, palette-owner, background and pointer-table roles. File hashes and ROM payload extents are preserved; the 512-byte `$6A90` slice remains explicitly a prefix of a longer DMA read. This is static naming evidence only, and whether the paused language overlay references these names remains UNKNOWN. The generated graphics catalog was refreshed, including stale derived screen rows from earlier Japanese renames. Details and limits are in [`comm_scene_graphics_path_audit_20261022.md`](docs/research/comm_scene_graphics_path_audit_20261022.md).

### Bank 53 and frame/PNG inventory revalidated (2026-10-22)

A fresh independent static pass at `bb2218e0` confirms the 25-name table re-emits 369 original bytes, all 25 candidate windows re-emit 85,200 original bytes, 137 Bank 41–47 catalogued assets match the ROM, 53 tile/raw PNG sources invert to exact payloads, and the 17 editable compositions match their declared pixel-index models. All 24 legacy previews pass file/CRC/dimension/decode checks; their composites were not regenerated. Across the eight resource directories, 71 PNG files exactly match 53 rules and 18 screen rows; no missing or orphan PNG was found in this finite scope. The eight KEEP views each have a legacy preview but no editable row. The 25 Japanese names still have no proved image association, and the audited selector descriptors do not read the Bank 53 table or select the 25 candidate windows. Details and limits are in [`assets_pokemon_frames_and_name_limits.md`](docs/research/assets_pokemon_frames_and_name_limits.md#independent-revalidation-at-japanese-checkpoint-bb2218e0-2026-10-22).

### Graphics destination naming pass (2026-10-22)

Two independent static reviews supported 16 graphics-stem renames (20 payloads, 33 files) using original-ROM extents and call-site transfer arguments. All file hashes were preserved. The pass also corrected the Bank 4A `$4E40` overread comment and a stale asset locator. This finite pass is not a semantic audit of all graphics paths. See [`gfx_destination_name_audit_20261022.md`](docs/research/gfx_destination_name_audit_20261022.md).

### Japanese indirect-dispatch handler names (2026-10-22)

Six `JP HL` tables in keyboard movement/sticky state, registration deletion, ISO-2022-JP conversion and settings progress now use symbolic `dw` entries and 23 local labels for 24 table words. All six ROM table slices and the named instruction starts were checked against the original ROM and linked symbols; the build remains `RESULT: IDENTICAL`. These labels identify static internal handlers and do not establish independent function entries or natural selection of every branch. The address/hash matrix and verification limits are in [`japanese_indirect_dispatch_handlers_20261022.md`](docs/research/japanese_indirect_dispatch_handlers_20261022.md). The Japanese semantic audit remains open.


The [definition of done](docs/REVERSE_ENGINEERING_RULES.md#23-definition-of-done) requires an explainable reconstruction as well as a reproducible ROM. `make`, symbol checks and a complete byte comparison establish reconstruction identity for the source actually checked; they do not establish complete semantics, natural execution or hardware behavior. Frozen `config/` and `docs/PROGRESS.md` counters, and dated counters below, are historical rather than a current completion census.

**Current Japanese semantic residuals (2026-10-24).** A cross-family source-to-sink reconciliation brings the existing candidate-entry, generic-reader, text/HTML/font, graphics-loader, sprite-table, DMA and 72-scenario evidence into one index. Within those enumerated domains, it identifies no natural Bank 53 name-ordinal→frame-source route and no external direct/recognized indirect control-flow edge to the retained entry candidates. These are bounded negatives. Computed readers, unrecognized transfers, arbitrary RAM/SRAM state and execution outside the retained scenarios remain open; do not call any candidate globally unused or the Japanese ROM semantically complete. The [cross-family matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#cross-family-source-to-sink-reconciliation-2026-10-24) lists the evidence already covered and the remaining positive-flow requirements. English/ZIP stays paused until explicit approval.

**Prior Japanese naming checkpoint (2026-10-22; before the bank-48 reader-source rename).** The maintained-source scan finds zero exact address-form `Function_BB_AAAA`, `Label_BB_AAAA` or `Font_BB_AAAA` definitions. The initial safe census found 15 exact `Data_BB_AAAA` definitions in 349 ASM/INC files; after the supported rename of `Data_4B_5400`, 14 remained at that historical checkpoint (13 HYPOTHESIS and `Data_48_69AB`, CONFIRMED as read data but with identity unknown). `Data_48_69AB` was subsequently renamed `FontReader_OutOfRunSource_48_69AB` [PROBABLE structural reader-source relationship]; its content identity and intent remain unknown. Protected `engine/mail/sample_data.asm` is excluded; no `gfx/bankNN` directories remain. The three earlier examples `Function_75_4000`, `Data_68_6960` and `Font_48_4ADB` are absent as definitions. The same maintained-source scan now also finds zero exact address-form `Tiles`, `Tilemap`, `Palette` or `Attrmap` definitions after the bank41-46 frame-name and computed-consumer reviews. Fourteen exact `Data_BB_AAAA` definitions remained in that dated source scan (13 HYPOTHESIS and one confirmed read-data span whose identity is unknown); the rebuilt MAP contains 20 address-form data symbols, including five aliases in the protected sample-data section (`Data_2D_42B2`, `Data_2D_42F8`, `Data_2D_436A`, `Data_2D_441B`, `Data_2D_44D3`), counted from MAP output without reading the protected source. Each safe-scan name has a separate bounded review and stays neutral where no stronger meaning is supported. After rebuilding the Japanese symbol file, `tools/data_consumers.py --stats` at the prior checkpoint reported 15 neutral data groups; the 2026-10-22 review supports one additional static-transfer rename, leaving 14 neutral data labels at that checkpoint. The per-group snapshot and rejected `Data_5F_6980` immediate are documented in `docs/research/generic_data_name_audit_20261020.md#fresh-neutral-data-inventory-at-japanese-main-7c596ead-2026-10-22`; this bounded scan does not prove absence of computed or unmodeled access. The 28 bounded operation addresses still match descriptive SYM names 28/28, while their natural roots remain unproved. This is not a completion count. The 6A:6330 help-menu object has now been structurally represented as a nine-frame table, nine OAM records and its animation script; the prior false palette asset classification is retired. Since the bank-6A checkpoint, `Data_4A_51B0` became the hypothesis-qualified `Palette_SettingsMenu_ObjRampCandidates`, the eight-zero bank-26 gap before the confirmed `26:59E0` tile source became `Padding_MailSession_Tiles59E0Alignment` [PROBABLE], the probable tile-content label at `51:5EE1` became `CandidateTiles_51_5EE1`, and the probable palette-content label at `29:5376` became `CandidatePalette_29_5376`; the unconsumed map-like span at `23:7C03` became `CandidateMapData_23_7C03`. Neither candidate name asserts an established consumer or screen. The Japanese ROM remains byte-identical after the pass. The following name-editor path pass names three tile payloads and one BG palette from their static transfer destinations; hashes and the byte-identical build remain unchanged. See [`address_book_name_editor_graphics_paths.md`](docs/research/address_book_name_editor_graphics_paths.md). The 2026-10-22 address-book resource-path pass replaces seven address-only filenames across Banks 28/29 with owner and VRAM-transfer names; the shared Bank 28 tiles retain their three confirmed static consumers, while the list BG palette name remains scoped to its one loader. Asset bytes, source labels and extents are unchanged; see [`address_book_graphics_resource_paths.md`](docs/research/address_book_graphics_resource_paths.md). The later 2026-10-22 path checkpoint renamed the Bank 62/66 keyboard graphics owners and assets by type, page and transfer destination without changing payload or ROM bytes; four Bank 62 tail roles remain PROBABLE and the static T10 preview remains HYPOTHESIS. See the dated entries in `docs/research/original_closure_followup_20261021.md` and the historical census in `docs/research/generic_data_name_audit_20261020.md`.

**Japanese naming census correction (2026-10-22; after the bank-48 boundary review).** The earlier latest-naming paragraph records the pre-rename count: 14 exact address-form Data labels after the Bank 4B transfer name. The independent review of the declared glyph-run `INCBIN` boundary now supports the structural name `FontReader_OutOfRunSource_48_69AB`, leaving 13 exact `Data_BB_AAAA` labels in 349 tracked Japanese ASM/INC files. All 13 remain HYPOTHESIS because no better content identity or entry is established. There are zero exact address-form function/font/resource labels in the reviewed pattern and no tracked `gfx/bankNN` or strict type/address paths. This is a naming-pattern census, not proof of semantic completion. See the [current reconciliation](docs/research/japanese_generic_name_reconciliation_20261022.md).

**Final Japanese address-only GFX path census (2026-10-22).** The last 44 strict `tiles_XXXX`, `tilemap_XXXX`, `attrmap_XXXX` and `palette_XXXX` stems are now resolved across Bank 71 account/registration graphics, Bank 50 CommNotice, Bank 5F keyboard panels and the retained Bank 4A sprite/script byte-view. Zero exact stems remain in the maintained `gfx/` tree. Names reflect static owner/transfer evidence; unresolved natural use and screen completeness remain explicitly limited. All 84 moved files matched pre-move SHA-256; the byte-identical Japanese build and sym/palette/png/gfx checks pass. See [the audit and per-path evidence](docs/research/japanese_residual_gfx_path_audit_20261022.md).

**Bank 6B non-CGB map split (2026-10-21).** `Data_6B_4060` was a mixed-kind span: the first 480 bytes are copied as a continuation of the BG tilemap at `$9800`, while the last 576 bytes remain an unconsumed tile-like candidate. The source and asset inventory now separate these ranges; the tail remains HYPOTHESIS. `make` reports `RESULT: IDENTICAL`; `sym-check`, `palette-check`, `png-check`, `gfx_export.py check` and `png_rules.py mk-check` pass. Details and original-slice hashes are in `docs/research/original_closure_followup_20261021.md`.

**Requested frame/name/PNG audit (2026-10-21).** The bounded audit covers 25 physical windows, the 25-entry bank-53 name table, 17 editing views and 24 legacy previews. Current checkpoint `4ed33389` preserves all 137 active manifest rows for banks 41–47 apart from symbol-name changes; all 41 image paths in the authenticated receipt exist with matching hashes, and current `make png-check` passes. No missing PNG was found in this bounded scope. A name-to-frame mapping, global unused status for banks 41–46, and a natural loader for `47:68F0` remain unproved. Details and limits are in [`assets_pokemon_frames_and_name_limits.md`](docs/research/assets_pokemon_frames_and_name_limits.md).

**Mailbox bank 25 transfer-source fragments (2026-10-22).** `Mailbox_ReadData_UnknownContent_6AC8` and `_6E71` are now `Mailbox_HDMASourceFragment_6AC8` and `Mailbox_HDMASourceFragment_6E71`. Their exact ROM slices and source windows are verified; names identify only their confirmed HDMA transfer-source role, not tile/image content. The first 56 bytes of the 265-byte `6AC8` span are also read by the overlapping `$6A00->$8700` request; the 127-byte `6E71` span maps to `$8E81-$8EFF`. Both remain unclassified as independent visual assets. Evidence and transfer bounds: [`boot_and_home.md`](docs/research/boot_and_home.md#bank25-mailbox-hdma-windows-and-unclassified-fragments).

**Natural entry roots rechecked (2026-10-22).** A fresh static audit examined `2B:6CF5`, `2D:4E42/4E54`, `29:511E` and the unlabelled fragment `55:5DF5–5E02`. It confirmed only two internal CALL edges (`2D:4E49 -> 4E54` and `29:50CE -> 511E`); neither caller has a proven natural root. No natural entry is proved for any of the five candidate addresses. The bounded byte-pattern census and bank/alignment limits are recorded in `docs/research/original_closure_followup_20261021.md`; this is not a global-unused claim.

**Bank 56 connect-dialog alignment gap (2026-10-21).** `Data_56_52BA` is now `Padding_ConnectDialog_Tiles52C0Alignment` (**PROBABLE**): six zero bytes separate the confirmed 80-byte connect-confirm tilemap/attribute pair from the next tile HDMA source at aligned address `56:52C0`; no direct reader was found in the bounded maintained-source search. This does not establish universal non-use. The ROM slice is unchanged and its SHA-256 is recorded in `docs/research/original_closure_followup_20261021.md`.

**Bank 2D zero-fill label (2026-10-21).** `Data_2D_5E80` is replaced by `Gfx_MailBody_HDMALoadZeroFill`: the 64 bytes at `2D:5E80–5EC0` are all zero and are included in confirmed MailBody graphics HDMA source extents. Their tile semantics and display/reference remain unproven; the label names only the bounded transfer role. See [`mail_gfx_resource_aliases.md`](docs/research/mail_gfx_resource_aliases.md#follow-up-bank-2d-body-editor-zero-fill-label-2026-10-21).

**Three generic data labels retired (2026-10-21).** `Data_2C_5150` is now `Gfx_MailTitle_Tiles8000Continuation`, bounded to the 704-byte continuation of the HDMA load beginning at 2C:5140. `Data_2C_7355` is now `AddrSlotIcon_AnimScript_FirstStep`; the sprite interpreter reads its `$00,$05` bytes as frame index 0 and delay 5 from the script at 2C:7354. `Data_2D_7940` is now `Gfx_MailAddr_ObjHDMALoadTail`, naming its confirmed position in the OBJ-tile HDMA transfer only; 240 of its 528 bytes correlate with frames initialized by the audited setup and the remaining 288 bytes are only transfer-confirmed in this call chain. No broader visual-use claim is made. `make` is `RESULT: IDENTICAL`, `make sym-check` passes (335 files, 12,176 labels, 51 constants), and `make palette-check` passes (162 loads, 116 arrays, two documented over-reads, zero errors); `make png-check` passes (410 tile, 4 raw-view, 37 font, 95 screen PNGs); GFX catalog check passes (980 assets) and PNG rules check passes (979 rules). The fresh neutral-data census is 124 groups. Details and ROM slice hashes are in [`original_closure_followup_20261021.md`](docs/research/original_closure_followup_20261021.md#three-generic-data-labels-retired-2026-10-21).

**Bank 56 stored-password load continuation (2026-10-21).** `Data_56_68C0` is now `Gfx_ConnectDialog_StoredPassword_Tiles9100Vb1_LoadContinuation`. The 512-byte slice is loaded as the final part of the HDMA sequence `56:67C0–6AC0` into VRAM bank 1 `$9100–$93FF`; this slice supplies `56:68C0–6AC0` and `$9200–$93FF`. The block remains a confirmed graphics asset, and its exact original-ROM SHA-256 is `ee9967c1d4805c4674707bf4d7bf4f923a4337acc39994c836dd219ea2a34d18`. `data_consumers --stats` now reports 123 neutral groups. See [`connect_dialog_bank56_aliases_20261021.md`](docs/research/connect_dialog_bank56_aliases_20261021.md#follow-up-stored-password-hdma-continuation-2026-10-21).

**Bank 5F keyboard gap (2026-10-21).** `Data_5F_58F3` is now `Padding_Kbd_T3ToT5_TileAlignment` at **PROBABLE** confidence: the 13-byte zero interval follows the exact end of `Tilemap_Kbd_T3` at `5F:58F3`, precedes the T5 graphics HDMA source at aligned `5F:5900`, and has no named direct reader. The label records a likely alignment gap, not a consumed resource. At this checkpoint the data census was 122 neutral groups. Details and the original slice hash are in [`original_closure_followup_20261021.md`](docs/research/original_closure_followup_20261021.md#bank-5f-keyboard-map-to-graphics-gap-2026-10-21).

**Bank 2F code/data candidate (2026-10-21; name updated 2026-10-23).** `2F:4094–4097` is now `Data_AbookList_CandidateJpRun_4094` (formerly `Data_2F_4094`): bytes `$C3,$00,$40` decode as `JP AbookList_Run`, but `AbookList_Run` jumps away at `2F:4091` and no direct entry to `4094` is known. The valid opcode alone does not prove a function or natural entry. See [`original_closure_followup_20261021.md`](docs/research/original_closure_followup_20261021.md#bank-2f-4094-code-data-candidate-2026-10-21).

**Bank 29 mail-screen gap (2026-10-21).** `Data_29_53F6` is now `Padding_CommTimeHMS_TileHDMAAlignment` at **PROBABLE** confidence: ten zero bytes separate the palette extent ending at `53F6` from the tile HDMA source at aligned `5400`; no named direct reader was found. This records a likely alignment gap, not a consumed asset. The latest census is 121 neutral groups. See [`original_closure_followup_20261021.md`](docs/research/original_closure_followup_20261021.md#bank-29-mail-screen-alignment-gap-2026-10-21).

**Original-ROM work remains open (2026-10-20).** The Operator requires all real functions to be
mapped and properly named before any English work can resume. The previous zero *neutral-only address
groups* census counted descriptive aliases; it was not a census of identified functions. A direct
maintained-source scan at245961f6 still found693 literal `Function_*` definitions in143 owners,
four active instruction references to those names, and1618 local labels scoped under them. These
are naming-migration counts, not693 unknown routines. Each retirement requires a defensible contract,
reference/local-scope review and address-preserving reconstruction. The c6236d06 pass retired seven
aliases (686 remained before the follow-up cohort below): four already named audio helpers gain complete contracts, the two mail-body
locators gain PROBABLE domain names, and the actual no-op at26:5343 retains its descriptive label.
The original56-byte26:5344 fragment is named `MailSession_WriteVram1TileAndWram7ScreenRows` from its
observed stores; the code classification is PROBABLE, while independent entry and intended role remain
HYPOTHESIS. This does not establish natural execution or accepted VRAM writes; see the dated review in
[`naming2_verify_fn4.md`](docs/research/naming2_verify_fn4.md);
the VRAM1 `$9010-$901F` fill matches tile index 1 already present in the 64-tile
`MailSession_Tiles_62E0` load. This supports only a bounded data relationship and does not prove entry.
The earlier `Data_BB_AAAA::` count of 1,003 definitions was reconciled against the source and
subsequent reviewed retirements. At `41c92b60`, a controlled scan of the six maintained roots,
excluding the protected `engine/mail/sample_data.asm` without reading it, finds 898
`Data_BB_AAAA::` definitions (engine 126, data 54, gfx 547, audio 170, lib 1, home 0; all in
`.asm`, none in `.inc`) plus one in `zero_labels.asm` (899 total). On that same restricted file
set the baseline at `5a1171cd` is 954 plus one; the 56-definition change reconciles 17 Song03
aliases, the 18-definition Song07/keyboard-name checkpoint, 15 Song02 aliases, and six bank2C
aliases. Because the older 959 count used a different inclusion set, it is retained as historical
rather than treated as a directly comparable baseline. These are lexical counts, not completion
measures. The
[generic data-label audit](docs/research/generic_data_name_audit_20261020.md) records the
checkpoints.

A path-safe lexical scan at `25ede6ec` over 336 maintained ASM/INC files,
including RAM owners, reconfirms 898 `Data_BB_AAAA::` definitions and finds no
`Function_BB_AAAA::`, `Font_BB_AAAA::`, `Label_BB_AAAA::` or `wRam_AAAA::`
definitions, no generic function-like prefixes, and no `gfx/bankNN`
directories. This closes only that lexical census. A fresh private run of
`data_consumers.py` counts 522 neutral groups and 122 immediate candidates but
rejects all candidates and produces no rename rows; this is not a consumer map
or proof of non-use. Semantic function/entrypoint identification and remaining
data contracts are still open; the linked audit records method, hashes and
exclusions.

A fresh scope-controlled census at `301fb1f3` reads 334 tracked ASM/INC files
from the maintained roots plus `zero_labels.asm`, excluding
`engine/mail/sample_data.asm` before reads and omitting `languages/`,
`analysis/`, and `build/`. It finds zero exact `Function_BB_AAAA`, `Font_BB_AAAA`,
and `Label_BB_AAAA` definitions, 73 `Data_BB_AAAA` definitions across 44
owners, and no `gfx/bankNN` directories. The data-consumer screen rejected all
93 candidate immediates, so no names were inferred from those candidates.
These lexical counts do not close semantic identification; method, manifest
hashes, and retained evidence are in the dated generic-data audit.

The follow-up at the current source snapshot replaces `Data_1C_4016` with the
probable operation label `Main_TitleChoices_JumpToLoop`; a fresh scan of the
same path-safe scope now counts 72 exact `Data_BB_AAAA` definitions across 44
owners. It keeps the adjacent unreferenced `$C9` at `1C:401C` neutral. The
snapshot digest and receipt are recorded in
[`generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md).

A current path-scoped review retired two redundant generic aliases. In
`gfx/browser/start_choice.asm`, `Data_73_5E60` duplicated
`SpriteFrameTable_73_5E60` and had no other tracked non-language consumer. In
`engine/mobile/text_truncate.asm`, `Data_54_4CAD` duplicated the CONFIRMED
`String_Text_Ellipsis` at the same address; only historical docs and frozen
`config/`/`analysis/` tables retain the generic spelling. Each source line is
preserved blank. The frames, ellipsis bytes and ROM output are unchanged. That
earlier lexical scan recorded 896 `Data_BB_AAAA::` definitions in tracked
non-language ASM files, excluding `engine/mail/sample_data.asm`. These two
alias retirements do not close the remaining semantic data audit.

The 2026-10-21 CommScene follow-up retired four more same-address aliases
(`Data_70_5490`, `Data_70_5890`, `Data_70_5C90`, `Data_70_6090`) in favor of
their existing tile-resource labels. In the same tracked non-language ASM
scan scope above, the census pinned to `1485975350e230be41906fce14af44c1ef7b262a` found 889
generic data definitions including `zero_labels.asm`, of which 888 were in the
six maintained roots. The refreshed safe census after subsequent retirements
finds 888 total, with 887 in the six roots. See the dated audit section in
`generic_data_name_audit_20261020.md`; the reproducible scan and receipt are
retained under `.tmp/generic-data-current-safe-census-20261021/`.
The other 68
CommScene data labels and 27 SaveSender candidate labels remain neutral because
their evidence does not support safer names. CommScene comments describing
effective object-index and script-slot behavior were corrected against the
maintained readers. The next accepted data name replaces `Data_1E_4357` with
`TopMenu_AnimTilemapFrames` for the two-plus-five 9×11 tile/attribute frames;
the 396 bytes without recorded reads remain qualified. Build identity and
asset checks passed; no ROM bytes changed. This checkpoint does not close the
Japanese naming work.

The following TopMenu palette cleanup removes duplicate address-only exports
`Palette_1E_62A0` and `Palette_1E_62E0`, retaining `Palette_TopMenu_Bg` and
`Palette_TopMenu_Obj` and updating the asset manifest. The original ROM
remains byte-identical; symbol, palette and PNG checks pass. Palette role
confidence remains PROBABLE, and historical `config/`/`analysis/` spellings
are preserved as snapshot evidence. Japanese naming work remains open.

The top-menu graphics owner also retired nine `Data_1E_*` aliases and seven
`Table_1E_*` aliases under existing tilemap, VRAM-resource, frame-table and
object-table names. The 11 affected asset-catalog label cells now use the
retained labels. The owner is 531 lines after removing the 16 declarations;
the Japanese ROM remains byte-identical, with 12,845 source labels and the
symbol, palette and PNG checks passing. See
[`top_menu_aliases_20261021.md`](docs/research/top_menu_aliases_20261021.md).

The nine redundant `String_72_AAAA` labels in the bank-72 dialog-message file
have also been removed in favor of their existing `String_Dialog_Msg*` names.
The historical source line positions, message bytes and table entries are
preserved; the ROM remains byte-identical and all symbol, palette and PNG
checks pass. See the dated generic-label audit for the nine-address mapping.

The browser-start ticker checkpoint retired its field, pointer-table and
string aliases at
`73:4000`, `73:4001` and `73:4009`; source line positions, field byte,
pointers and strings remain intact. The latest safe census finds 888 generic
`Data_BB_AAAA::` exports across the six maintained roots and `zero_labels.asm`
(887 in the six roots), excluding the protected sample and language branch.
The Japanese ROM remains byte-identical and all required checks pass.

The 2026-10-21 Mobile SDK main-file pass retired 21 redundant generic string
and table exports in `lib/mobile/main.asm`, preserving the existing SDK labels
and every byte and assembled address. The census and independent owner-local
review found no other uses; this removes duplicate symbol names only and does
not add new routine or execution claims. See
[`mobile_sdk_main_aliases_20261021.md`](docs/research/mobile_sdk_main_aliases_20261021.md).

The 2026-10-21 bank-56 connect-dialog pass retires 20 generic aliases under
existing tilemap, graphics, palette, and object-table labels. Nineteen have no
external source/tool references; the twentieth was removed from the output of
the historical retyping helper as well. The owner keeps all 268 physical lines
and the same resource bytes. See
[`connect_dialog_bank56_aliases_20261021.md`](docs/research/connect_dialog_bank56_aliases_20261021.md).

The adjacent bank-1D mail-menu pass retires 19 generic table, data, and string
aliases under existing `MailMenu_*` labels. The independent owner/census review
found no other token uses or dependent local labels, and all 540 source lines
remain in place. See
[`mail_menu_bank1d_aliases_20261021.md`](docs/research/mail_menu_bank1d_aliases_20261021.md).

The bank-24 mail-result graphics pass also removes 18 same-address palette and
frame-table aliases. The descriptive resource labels remain, and the owner’s
data, confidence and physical line positions are unchanged. See
[`mail_comm_result_bank24_aliases_20261021.md`](docs/research/mail_comm_result_bank24_aliases_20261021.md).

At `50:4244`, the redundant `Table_50_4244` export has been retired in favor
of `Table_CommNotice_Screens`, already used by the active reader. Eight
CommNotice comments now use that retained name; the pointer list and its
targets are unchanged. The original ROM remains byte-identical, with 13,372
source labels and the palette and PNG checks passing.

The bank-55 keyboard page file also had 23 same-address generic aliases with
no active consumers beyond their declarations. They now resolve through the
existing page, pointer-table and neighbour-record names; bytes, block extents
and source-line positions are unchanged. This is a bounded alias retirement,
not evidence that the remaining bank-55 records or every Japanese-ROM data
block are semantically understood; see the dated mapping in
[`generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md).

In `gfx/comm/notice_dialog.asm`, 32 generic resource aliases have also been
retired in favor of existing tilemap, attrmap, graphics, palette and animation
labels. Eight paired-map comments and two object-table comments now use the
retained names. The 32 alias declarations and their source-line positions are
preserved as blank lines; resources and existing confidence levels are
unchanged. The Japanese naming audit remains open.

The mobile dictionary in `engine/help/mobile_dictionary.asm` had 72 more
unreferenced same-address aliases over its named category positions, counts
and entries. Those generic exports are retired; line positions, table data and
existing confidence are unchanged. The protected sample file is excluded from
the current generic-data count: 846 in the six maintained roots plus one in
`zero_labels.asm` (847 total). The dictionary mapping and source-set hash are
in the dated generic-data audit.

Three redundant address-only labels were also retired from the connect-dialog
strings. Their semantic labels remain the names used by the active reader;
string data and the six-message block are unchanged. The full build and
symbol, palette and PNG checks pass. The historical `tools/data_consumers.py`
mapping safely recognizes the surviving semantic label and skips the absent
alias.

The 2026-10-20 bank6C HelpScript pass maps the static command stream from `6C:4809` through the
terminal at `6C:58C6` (exclusive end `58C7`), corrects mixed command/text classifications and
replaces address-only labels at command boundaries with structural names. An independent walk
confirmed 4,286 bytes, 203 primary commands, 85 page commands, and branch targets on command
boundaries. The original ROM builds byte-identically, and the symbol and palette checks pass.
This does not prove natural topic reachability, rendered output, or complete Japanese-ROM closure;
see [the stream map](docs/research/help_script_stream_map_20261020.md).
The follow-up reader review of `48:69AB–69CA` found a concrete conditional static path from
keyboard values `$FF82/$FF83` through the glyph preview to two 16-byte zero ranges. Source
arithmetic confirms these selected addresses lie outside the declared 80-byte run at
`48:5D7B`; names that call the bytes a glyph or fallback remain unsupported. The structural label
is now `FontReader_OutOfRunSource_48_69AB`; object purpose remains unknown. The test-image span at `68:4F17` is now split into probable
POP padding, server-IP, and first BCD dial-slot fields. A stale `Function_2B_687C` token was also
replaced by its existing operation name in the sprite preview index. These changes do not establish
natural preview execution or close the remaining generic-data inventory; see the dated audit and
[reader bounds note](docs/research/font_reader_69ab_bounds_20261020.md).
The earlier30-span/63-byte count matches the current home/engine/data subset only. A six-root census now finds32 HYPOTHESIS spans/92 bytes under leading UNCLASSIFIED data headers, including28 bytes in gfx/mail/body_view.asm and one byte in lib/mobile/main.asm; see the [scope correction](docs/research/classify_g6.md#8-six-root-unclassified-header-scope-correction-2026-10-17). This is an annotation census, not the total amount of unexplained ROM data. Natural entry at `2B:6CF5`, `2D:4E42/4E54`, `29:511E` and `55:5DF5`, and stack transfer at `2B:6CF5`, remain unproved; a finite 69-scenario trace census found no natural instruction starts, callgraph endpoints or ROM-read overlaps for their intervals. The only observed entry to `2B:6CF5` is forced by the harness. The full limits and evidence are in [the 2026-10-22 natural-entry census](docs/research/original_closure_followup_20261021.md#natural-entry-trace-interval-census-2026-10-22). Locator caller domains, eight frame contexts and 25 name-to-image associations also remain unresolved.
The finite checks below remain valid within their limits; they do not establish100% completion.
The English implementation is paused on its separate branch until Japanese function/resource
identification and requested asset checks are complete and the Operator explicitly confirms a resume.
Do not sync, build, commit or push English changes before that confirmation. The branch is not
integrated into Japanese `main`. ZIP-derived graphic parity remains limited to catalogued records,
not the whole ROM.

The bounded bank53/frame/PNG follow-up is now recorded in
[`pokemon_names_bank53_asset_followup_20261020.md`](docs/research/pokemon_names_bank53_asset_followup_20261020.md).
Its private Japanese snapshot was authenticated against 4,356 Git blobs; the current PNG check also
passes. All 25 bank53 name-to-frame associations and eight composition `KEEP` windows remain open,
and no frame is proved globally unused. The 59-group historical matrix is reconciled to its exact
4c5143ec cohort; the separate 49-span receipt is still unlocated. Neither result closes the current
523-group data census or the five open entry/limit investigations.

The bounded audit of82 `Data_<bank>_<address>` labels without adjacent semantic aliases found
three supported names and no basis to remove data. `String_HelpMenu_MailTitle` identifies the
confirmed seven-byte ticker title at6A:65A1; `String_Dialog_Msg0113_Line2` marks the confirmed
second line within a blank dialog record at72:5645; and the probable mechanical table
`Table_Kbd_CursorSpriteCharOffsets` describes the pairs selected and applied by
`Kbd_UpdateCursorSprite` at55:62C8. The two notice text-pointer fields at65:4BE2/4C6C and the two
BCD dial-slot fields at68:4F35/4F4D now have descriptive labels, with the latter two kept PROBABLE.
Seven old `Data_*` source labels are retired after reference checks; frozen region/mapper snapshots
retain their historical spellings. The other75 labels retain their evidence limits, including interiors,
positive entry proof. The [audit note](docs/research/generic_data_name_audit_20261020.md) records
the exact scope and retained matrix; this is not an all-data or whole-ROM completion claim.

The HelpScript picture pass recovers26 complete table-backed12×6 pictures from banks60/61 and their26 palettes. The positive `HelpScript_PictureTable` reader supersedes the old “no loader found” clip descriptions. The new whole-object catalogue adds14848 bytes already present inline, while retaining the original30160-byte owner spans and PROBABLE role qualifications. Structural IDs replace arbitrary clipped resources; source and table labels, path/range maps and PNG rules follow the actual objects. [The picture contracts](docs/research/help_script_picture_assets.md) separate finite static evidence from unproved natural display and leave bank5B outside this asset unit.

The follow-up naming cohort retires93 more historical Function aliases (593 remained at that stage), with proper
names and conditional roles documented in [audio helpers](docs/research/audio_function_names.md),
[bank68 contracts](docs/research/bank68_function_names.md), [SDK75 contracts](docs/research/sdk_function_names.md)
and the [received-record reply role](docs/research/naming2_neutral_mail.md#reply-composition-from-a-received-record-proper-domain-role-2026-10-15).
This includes the Operator's Function_75_4000 example: MobileSDK_CopyBytes is the maintained
six-instruction/seven-byte forward-copy routine (B0 means256), with the old generic alias retired.
Settings_IsDecodedProgressNonzero and MobileSDK_ResetRxWindowAndSetResultLowFF replace broader
claims: one accepts any nonzero XOR-A5 decoded marker without validation; the other writes only
the result field's low byte. Original crossed SRAM unwind, nonlocal return paths and confidence
limits are documented rather than repaired. These93 removals are migration counts, not93 newly
identified functions or whole-ROM completion. All ROM bytes remain subject to the native identity gate.

The naming requirement also covers original graphics paths. The graphics naming pass moves235
paths (ten owners and225 asset/PNG files) to demonstrated border motifs and narrow UI fragments;
see [resource names and limits](docs/research/gfx_resource_names.md) and the
[historical/current path map](docs/research/gfx_resource_path_map.tsv). Banks and addresses remain
provenance suffixes. All225 asset/PNG byte strings and source extents are retained. The142 catalogued
asset classifications remain124 PROBABLE and18 HYPOTHESIS; visual motif names remain PROBABLE
locators. This does not establish species,
natural frame selection, bank53 name/image associations or the purpose of opaque raw fragments.
The native original identity gate applies to this source migration; path naming is not semantic closure.

The HelpMenu item-map path pass renames twelve binary files for the six existing normal/selected
page-map objects. The names follow the existing semantic aliases and retain all 1,560 original bytes,
packed dimensions, addresses and reader limits. Page1-selected remains PROBABLE; the other five pairs
retain their existing CONFIRMED source/catalogue status. Ten stale inventory cells in gfx/README are
aligned to that already adopted status. The [path note](docs/research/help_menu_item_map_paths.md)
and path map record the moves. No new PNG, screen composition or natural-render proof is introduced.

A follow-on broad-census cleanup removed two unused neutral data aliases, `Data_65_4BC6` and
`Data_68_4EA7`, while retaining the existing `Notice_PageSoundTable` and `Dev_TestConfigImage` names.
No bytes, ranges or confidence levels changed; details are in the
[generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The current original-source follow-up also retired eight redundant `Data_75_*` aliases from
`lib/mobile/main.asm`; each had an exact same-address descriptive label and no generic-name
consumer or local scope. Existing confidence annotations and bytes are unchanged. The mapping and
current-head census receipt are recorded in the same audit note; this is one bounded alias cleanup,
not closure of the remaining neutral data inventory.
One additional same-address alias, `Data_68_7B19`, was retired from
`engine/account/delete_registration.asm` after the same reference/scope checks; its current name is
`Registration_DeleteCursorPositions`.
The account cleanup also retired `Data_68_6E03`, whose surviving label is `Config_HostPrefixStrings`.
In the browser graphics owner, 46 `Data_24_*` aliases were also removed where same-address
page-list frame, script and map names already existed; the byte identity and previous confidence
annotations are preserved in the naming audit ledger.
The top-menu graphics owner had another 36 `Data_1E_*` aliases under existing tilemap, animation
frame and script names; those redundant labels were removed with the same byte and confidence
preservation.
The communication-result graphics owner also lost 33 redundant `Data_24_*` aliases under the
existing `MailResult_*` labels; the mapping and scope are in the generic-data audit.
The keyboard-panel graphics owner had 32 more `Data_5F_*` aliases under existing panel/frame/script
labels; those were retired after the same checks.
The mail-compose object owner had 30 `Data_29_*` aliases under existing `MailBody_*` frame/script
names; they were retired with the same byte and confidence preservation.
The draft-menu graphic owner had 26 `Data_2B_*` aliases under existing descriptive graphic and
animation labels; those were retired after the same address/reference checks.
The mail-viewer owner also had 24 `Data_2B_*` aliases under existing `MailView_*` frames/scripts;
those have been retired with the same byte and evidence preservation.
In `audio/music/music_16.asm`, 16 `Data_05_*` aliases at existing `SoundSong16_*`
addresses were retired after source-reference, tool-reference, and local-scope checks;
the 566-line owner and decoded stream declarations remain unchanged.
The same bounded checks retired 14 `Data_05_*` aliases from `audio/music/music_19.asm`
under its existing `SoundSong19_*` labels; the 455-line owner is unchanged.
In the page-list prototype, 15 string/table aliases were retired under existing
names; the palette alias anchoring the `.loop` local scope remains. See the
[prototype alias audit](docs/research/page_list_prototype_aliases_20261021.md).
The browser page-list graphics owner also lost 14 exact-address tile, palette
and frame-table aliases under existing `PageList_*` names; source lines and
assets remain in place.
The account-screen bank 5E owner lost 16 declaration-only `Data_5E_*` aliases
under existing graphics, palette, and tilemap labels; its source lines remain
in place and its emission is unchanged.
The mail-server tidy-screen owner also lost 16 address-only `Data_2E_*` and
`Table_2E_*` aliases under existing graphics, tilemap, palette and object-data
labels; only declarations changed.

The same audit renamed the positioned `$0020` word at `5C:5144` to
`CommErr_MessageSlot32RawWord`. The slot is confirmed structurally; the value's purpose remains
unknown and the name does not assert that the slot is unused.

The HOME naming pass retired110 historical Function aliases (483 remained at that stage across the
maintained original sources), preserved123 local-label addresses under descriptive scopes and narrowed
two copy-operation names. The [HOME contracts](docs/research/home_function_names.md) document entry
registers, full counter domains, crossed frames, HTML header arithmetic and dated evidence errata;
operational RAM scopes and consumer keys follow the retained names. Entry, purpose, mapper,
stack and unobserved-input qualifications remain explicit. These are naming-migration counts,
not110 new semantic discoveries or whole-ROM completion. After these reviewed integrations,
the Operator requires a wider audit of analogous generic names in the other original ASM files,
paths, resources and name consumers.
English payloads, override targets and builds remain suspended pending fresh human confirmation.
The original-path fallback inventory follows this migration; English override targets still using old
graphics paths require a later authorized rebase. No English parity or build is claimed here.

The wider naming pass retires the remaining 483 literal `Function_*` definitions and 33 original
font/configuration aliases. It retains existing descriptive names and requalifies 1,391 local labels
at their original addresses. [The function contracts](docs/research/function_alias_retirement.md)
retain entry, stack, mapper and purpose limits: `Glyph_LoadContiguous12Bytes` narrows the conditional
copy operation, and `Stack_PushPopAFAndReturn` explicitly describes its two stack writes. The
[font/configuration contracts](docs/research/font_config_resource_names.md) identify 27 bank48 glyph
runs by their table keys and four bank68 default images by their selected indices. The 54 existing
PNG/1bpp files move to `data/fonts/glyph_runs_8x16/sjis_<key>` with their bytes preserved, as recorded
in the [path map](docs/research/font_glyph_run_path_map.tsv). This retires the maintained aliases in
the Operator's `Data_68_6960` and `Font_48_4ADB` examples. Historical records keep their old names as
provenance. Native reconstruction checks apply to this migration; zero remaining literal Function
definitions does not establish all possible entries, callers or semantic interpretations.

Original source scanners now exclude the repository-local `.tmp/` support directory. The invariant,
data-consumer and audio-mention walkers preserve their existing selection rules for other paths; a
synthetic regression fixture distinguishes active source from archived copies. This is an original-tool
correction. English method fingerprints remain historical pending separately authorized parity work.

The next finite data/resource migration retires31 redundant aliases:11 HOME data/control
aliases, nine audio-table aliases, four title-logo resource aliases and seven address-book
save-screen resource aliases. Existing descriptive identities, physical ASM rows, instruction
and data emission, asset paths/bytes and inherited evidence levels are preserved. The
[HOME contracts](docs/research/home_data_names.md),
[audio contracts](docs/research/audio_table_names.md),
[title contracts](docs/research/title_logo_resource_names.md) and
[address-book contracts](docs/research/address_book_save_resource_names.md) retain input,
bank, stack, IRQ, destination and timing qualifications. These source-level retirements add
no natural caller, independent entry, original display/sound observation or hardware evidence.
The note-local symbol predictions describe isolated cohorts; the combined migration removes
31 globals from the14921-name parent map, with all51 constants and surviving addresses held.
English remains suspended pending fresh human confirmation.

The finite Mail SDK follow-on retires20 redundant string/table aliases while retaining
existing descriptive identities, all physical ASM rows, emitted data/instructions and
inherited PROBABLE statuses. The [Mail contracts](docs/research/mail_sdk_data_names.md)
separate the17-entry emission-string table from the two independent13-entry tables,
retain finite index/bank/WRAM/stack/IRQ conditions and the selector0 saved-AF/bare-RET
caveat. Correcting the inherited word "parallel" changes a comment only. This follow-on
predicts14870 symbols from the published14890-name parent, with all surviving values
and51 exported constants held; linked/native verification remains a separate gate.

The frame/catalogue document follow-ups repair16 stale PNG links through the maintained
path map and record the already resolved bank7C font gap. They change no image, palette,
source interval or frame/name association. The finite952-asset inventory and25-window
checks distinguish present editable backing from historical previews; eight KEEP contexts,
Pokémon-name associations and runtime/display qualifications remain unresolved.
English remains suspended pending fresh human confirmation.

The Mail graphics follow-on retires20 redundant resource aliases in four original owners,
retaining the existing descriptive names, six CONFIRMED and14 PROBABLE classifications,
all physical ASM rows and asset bytes. The [resource contracts](docs/research/mail_gfx_resource_aliases.md)
preserve the neutral64/528-byte spans,692 bytes of animation tails and37 animation aliases.
The reload at5CC0 uses C=$30:48 blocks/768 bytes, comprising448 bytes of the main backing,
64 adjacent neutral bytes and256 bytes of Tiles2. No source instruction or load extent changes.
The isolated symbol prediction is14850 names including51 exported constants from the14870-name
parent; the previous Mail SDK20 is already part of that parent. This does not identify the eight
KEEP frame contexts or associate25 Pokemon names with25 windows and27 descriptor words.
English remains suspended pending fresh human confirmation.

The phone-choice resource follow-on retires seven redundant numeric aliases in one original
settings owner, preserving the existing descriptive names, seven inherited CONFIRMED headers,
all physical rows, operands and asset bytes. The [resource contracts](docs/research/settings_choice_resource_names.md)
describe the six HDMA source slices and the18x20 tilemap/attribute pair. Mixed palette/map
reads at4D:5510 and the interior-source crossings at4110/4C10 retain their explicit limits;
no global palette substitution or new destination exclusivity is inferred. The symbol prediction
is14843 names including51 constants from the GFX20 parent14850, with surviving values held.
These seven retirements add no new natural rendering or hardware evidence. English remains suspended.

The palette metadata check rejects unresolved symbolic source names in its resolved-load
records instead of silently dropping a consumer. The [metadata integrity contract](docs/research/palette_load_metadata_integrity.md)
distinguishes 162 resolved palette records from 11 explicitly UNRESOLVED records outside this
check. Existing offset/numeric resolution and documented over-read allowances remain unchanged.
The regression models retiring an alias while leaving a stale palette record: that input must
fail, while the correctly named consumer retains its load. No palette record, original source
instruction, alias or asset is changed by this tool correction. This is validation of the recorded
metadata, not proof that every possible ROM palette reader or bank state has been resolved.

The phone-choice mixed source now has a structural view named
`Data_SettingsPhone_ChoiceMenu_ResourceWindow768`, classified PROBABLE under its
[consumer contract](docs/research/settings_choice_menu_resource_window.md).
The original HDMA source covers 768 bytes: BG40, OBJ8, map360 and attributes360.
The separate BG64 load retains `Palette_SettingsPhone_ChoiceMenu_Bg` and its
reviewed 24-byte over-read; this does not reclassify the whole window as a palette.
Two operational metadata cells now name the upload window and BG palette respectively,
preserving all 162 ordered palette-load tuples. One generic symbol is replaced by
one descriptive view, with no net symbol-count change; instructions, emitted bytes,
assets and the existing confidence levels remain unchanged. English remains suspended.

The settings and text-entry resource follow-on retires 17 redundant generic aliases
in five original graphics owners, preserving 16 CONFIRMED and one PROBABLE classification.
The [resource contracts](docs/research/settings_text_entry_and_confirm_resource_names.md)
cover 11 tile sources, five map/attribute pairs and one palette, with 25 literal consumers.
Nineteen catalog label cells are reconciled by their unique asset keys; all other fields,
assets, physical rows and instruction operands remain unchanged. Shared bank5E tiles retain
their four text-entry domains; the mixed 4A/4B windows and interior crossings remain qualified.
The isolated symbol delta is -17, preserving all surviving values and 51 constants.
This introduces no new natural rendering, hardware evidence or English work.

The Japanese bank4B follow-on replaces four neutral/legacy names with bounded
header-source, tile-slice and slot-record names, retires two redundant aliases, and
moves 21 GFX paths. The 65:4A81 header table is 24 address+bank triples (72 bytes);
the seven 16-bit footer addresses at 65:4AC9 are separate (14 bytes). The reader
gives a static 640-byte VRAM1 load contract, while natural selection/rendering
remains unclaimed. The 4B:6590 DB remains unclassified, the final four bytes of
4B:76C0 remain unknown, and uploads crossing 4B:7090 and 4B:7AD0 remain mixed
windows. The 54+3 metadata-cell composition passed independent candidate and staged
reviews; ACTUAL `make` is `RESULT: IDENTICAL`, `sym-check` reports 14,717 labels and
51 constants, and `palette-check` reports zero errors with two documented over-reads.
The package is staged and awaits commit/push and FRESH verification; this adds no
claim of natural rendering or hardware evidence.

The error-screen resource follow-on retires ten redundant aliases in two graphics
owners, preserving the ten inherited CONFIRMED classifications, physical source rows,
assets and operands. The [resource contracts](docs/research/error_screen_basic_resource_names.md)
cover six tile sources, two palettes and two map/attribute pairs with eleven literal
consumers. Seven mixed, neutral or ABI-dependent views remain explicitly deferred.
Catalog and operational metadata already use descriptive labels and remain unchanged.
The isolated symbol delta is -10 with surviving values and 51 constants held.
No new natural rendering, hardware evidence or English work is introduced.

The SJIS bit-test follow-on retires eight redundant coordinate aliases, retaining
`Font_ValidateSjisCode_TestBit0` through `TestBit7` and their existing classifications.
The [handler contracts](docs/research/sjis_bit_test_coalias_names.md) preserve the
48 handler bytes, 16 table bytes, eight descriptive DW references and the qualified
stack/flags behavior. This does not establish a universal direct-entry ABI or the
meaning of the PROBABLE bitmap. Source rows and all operands remain unchanged.
The isolated symbol delta is -8 with surviving values and 51 constants held.
No natural-execution, hardware or English claim is added.

The notice type4 map now uses descriptive owner and component paths under
`gfx/registration/notice_tilemap_bank4b`. Its [path contract](docs/research/notice_type4_tilemap_paths.md)
retains the same 360 tile indices and 360 attributes, selected when the first byte
of the notice record equals $04. This does not mean page argument4 or establish
natural display coverage. Labels, classifications, bank/address placement and
all 720 original bytes remain unchanged; this unit changes paths only.
The live catalog, output paths in the PNG rules, linker section identity and graphics index
are reconciled together. Three historical/current path-map entries preserve
navigation from frozen layouts and notes, which are retained without regeneration.
No PNG, model, helper, original instruction or English payload is changed.

The shared text-entry sources at 5E:4000 and 5E:4400 now use paths under
`gfx/settings/shared_text_entry_tiles_bank5e`. Their [path contract](docs/research/shared_text_entry_5e_resource_paths.md)
preserves both 1024-byte original blocks and their existing editable PNG bytes.
Four demonstrated setup contexts share these sources; the collection name remains
PROBABLE and both source headers remain CONFIRMED. Five editing models retain
their HYPOTHESIS qualifiers. Current path fields and build references move together;
five appended historical/current mappings preserve prior entries, including Notice4B.
No symbol, original instruction, image content or English payload changes.

The connection-icon Request1 tile sources retain their existing names
`ConnIcon_Tiles8200Vb0` and `ConnIcon_Tiles8600Vb0`; two redundant coordinate aliases are
retired under their [bounded source contract](docs/research/connection_icon_request1_alias_retirement.md).
The two original blocks remain 1024 and 512 bytes, read into VRAM0 at $8200
and $8600 by the demonstrated bank69 setups. Their B parameters differ ($92
and $95); both CONFIRMED headers, every emitted byte and all operands remain
unchanged. The other 41 PROBABLE aliases in the owner remain outside this unit.
No Request2, palette, animation ABI, natural display or complete-purpose claim
is added. Asset paths, PNGs, metadata, helpers and English payloads stay held.

The password-save confirmation resources at 5D:7360..7E70 use
`gfx/settings/password_save_confirmation_bank5d` and qualified VRAM1 source names.
Their [path contract](docs/research/password_save_confirmation_5d_resource_paths.md) preserves all 2832 original bytes
and the three existing PNG byte streams. The map and its editing selector use
`password_save_confirm_variant0`, reflecting the literal zero-variant branch;
the old selector is not a CLI alias. Four CONFIRMED resource headers and both
HYPOTHESIS editing models remain held, including the alternate bank71 model's
empty palette cell and its unchanged identity. Collection naming stays PROBABLE.
Nine historical/current mappings are appended. Shared5F tiles, bank4A objects,
the alternate map, all symbols and English payloads remain outside this change.

The connection-icon palette, object table, frame lists, frames and scripts
retain their existing proper names under a [bounded structural contract](docs/research/connection_icon_probable_alias_retirement.md).
Forty redundant coordinate aliases are retired; all 41 PROBABLE headers and both
CONFIRMED tile headers keep their status. Two separate factual corrections in
the object-table comment match the consumer: the script pointer goes to slot
+6/+7, and byte arithmetic selects DE+4*(B&$3F), without a table bounds check.
The fourteen-byte neutral prefix, five frames not selected by their associated
scripts and the one/three-byte unknown tails remain held; these finite findings
do not prove that any resource is unused. All emitted bytes, operands, proper
labels, assets and metadata remain unchanged. No new natural-display, hardware,
whole-purpose or English result is claimed.

The [AdapterCheck object-data representation](docs/research/adapter_check_object_data_80b.md)
describes 80 original bytes: 69 bytes form an object table, frame list, four
frames and an animation script; eleven final zero bytes at `4A:6915..6920` have unknown
purpose. A recheck of the 70 saved data-read reports found the selected 65-byte
entry-1 body in 69 reports and no reads of the null entry or final eleven bytes;
this finite corpus does not establish padding or global non-use. The structure
retains PROBABLE status. Its former tile binary and PNG remain unchanged as legacy
references, outside the active catalogue; the maintained source is now ASM/macros.
The root name is refined to AdapterCheck_ObjTable, six internal records gain proper
global names, and the redundant coordinate alias is retired. The four screen models,
historical captures and name/image association limits remain unchanged. This is no
new natural-display, hardware or English result.

The initial wider lexical census at e958ff4f found 5,284 generic global definitions, including aliases
and 786 neutral RAM coordinates; these are not counts of unknown functions. It also found 4,961
address-based local labels, all present in the parent SYM, by recognizing colonless RGBDS declarations.
An earlier parser requiring a colon omitted these locals. The 516 alias retirements form one finite
part of the wider task: other data, graphics, local labels and paths still need evidence-based review.

A later exact-name census of the maintained ASM/INC source set at 51b2b438 covered 347 files and
found 287 global definitions with a type/bank/address name: 77 `Data_`, 107 `String_`, 9 `Table_`,
41 `Tiles_`, 24 `Tilemap_`, 25 `Palette_` and 4 `Attrmap_`; it found no exact `Function_`, `Font_`
or `Label_` definitions. Commit b249783b replaced three of those generic names with statically
supported semantic names. The current lexical remainder is therefore 284 definitions: 75 `Data_`,
107 `String_`, 8 `Table_`, 41 `Tiles_`, 24 `Tilemap_`, 25 `Palette_` and 4 `Attrmap_`. This is a
name-pattern census, not a count of unresolved code or proof that every data label is understood.
The remaining neutral names retain the confidence and uncertainty recorded at each source header.
Shared RAM coordinates require screen/bank-specific roles. The conditional editing-model domain has
18 HYPOTHESIS rows: 16 non-RAW models (15 single-sheet and one fragmented) plus two explicitly RAW
models. The earlier count of 16 referred to the non-RAW subset. English remains suspended until fresh
human confirmation.

The [frame audit](docs/research/assets_pokemon_frames_and_name_limits.md#remaining-eight-editing-views-bounded-placement-comparison) retains **eight KEEP editing views**: physical ROM bytes exist, but a justified selector and reaching LCDC/VBK/VRAM state are missing. Two other bank42 views have complete reversible backing only under their declared conditional model. The [bank53 name table](docs/research/assets_pokemon_frames_and_name_limits.md#name-table-order-no-image-assignment) contains 25 ordinal names without a proved name-to-image association; 25 names, 25 physical windows and 27 descriptor words remain distinct. The [help-frame audit and preview](docs/research/naming2_neutral_help.md#64ae-split-object-entry-and-classification-conflict) cover the selected nine-frame root under a conditional LCDC model, not every asset or an observed display.

The [current neutral ledger](docs/research/naming2_neutral_code.md#remaining-labelled-local-operations-and-fragment-boundaries-2026-10-15) has **zero global neutral-only Function/Label ROM address groups under its exact naming census** after the ten [remaining labelled operation aliases](docs/research/naming2_neutral_code.md#remaining-labelled-local-operations-and-fragment-boundaries-2026-10-15). The 2026-10-15 phrase “Original neutral labels and instruction locators remain” describes preserved source anchors from that alias pass, not a current global name count; the current exact-name census is above. Local `.lAAAA` instruction locators remain, and the operation aliases are PROBABLE under their documented conditions. Entry/caller, application purpose, several field domains and the unusual stack-transfer ABI retain their HYPOTHESIS limits. This zero count means only that the previously counted global groups now have descriptive aliases; it excludes unlabelled fragments and proves neither all code entries nor whole-ROM semantic completion. The finite labelled/unlabelled reconciliation now covers334 ASM owners,47 hypothesis headers and72 unlabelled hypothesis blocks: their conditional local mechanics are documented in [the fragment contracts](docs/research/naming2_verify_fn4.md#contratos-condicionais-dos72-blocos-anotados-sem-global--2026-10-15). The32 UNCLASSIFIED headers were checked separately: one consumed text header was corrected and31 remain raw storage without positive code-entry evidence. Ten bytes wrongly written as instructions inside the bank7C font are now data with identical bytes. No local mechanism remains unexplained in these enumerated cohorts; uncertain entries, callers, purpose, mapper continuity and external frames remain explicitly HYPOTHESIS, so this is not universal semantic closure. The strict neutral instruction-reference cohort remains15 names/18 operands, including its explicit data/consumer limitations. The existing69-scenario coverage union and corresponding callgraphs/DATA-read records provide no new entry for these candidates, no bank53 name-table read and no read of the eight complete frame windows. These finite negatives do not prove unreachable code, missing computed callers or unused assets. The requested finite frames/names53/PNG/resource inventory has now been checked, as described below; the eight KEEP editing contexts and the25 name-to-image associations remain unresolved. No new natural execution, screenshot, hardware evidence or English work is supplied. The [FarCall_Reg contract](docs/research/boot_and_home.md#73-far-calls-all-use-the-hram-trampoline) and each operation note preserve mapping, trampoline, stack, IRQ and conditional-return requirements; an alias does not make an abnormal transfer a conventional function return.

The two additional spans formerly unlabelled on the reconciliation shortlist,55:[6F46,6F95) and2C:[6100,614D), now have byte-supported operation labels `Kbd_Candidate_DecrementC2B1OrAdvanceC2B0AndWriteOcpd` and `AddrPick_DrawSixSlotNamesAtX30`. Their156 bytes/98 CPU starts include OBJ palette-port writes and a six-iteration drawing wrapper; the earlier BCPD-to-OCPD comment correction remains. Entry and caller evidence remain HYPOTHESIS. The final original-ROM asset inventory below closes the requested finite existence/byte/PNG verification; uncertain callers, purpose, storage boundaries and eight editing contexts remain qualified, with no universal semantic or natural-execution claim. English remains suspended.

### Final finite original asset verification (2026-10-15)

The requested [frames/name-table audit](docs/research/assets_pokemon_frames_and_name_limits.md) checks all25 physical windows selected for this audit (85,200 bytes), the25 bank53 pointers and319 bytes of NUL-terminated Shift-JIS strings, and the separate27-word descriptor selector. Every selected window has an existing PNG representation:17 have editing views and the eight retained KEEP views have legacy previews. The24 legacy preview files use their documented models and are not proof of an original loader, complete reaching VRAM or a name/species association. No selected frame bytes or PNG files were found missing. In bank42, the2,416 bytes outside the active asset catalogue are present in maintained raw/zero source;38 conditional map cells use416 bytes of rephased backing, comprising368 already-catalogued bytes and48 of those outside-catalogue bytes. Counts of names, windows and descriptors do not establish a bijection.

The [global catalogue audit](docs/research/assets_original_catalogue_and_layout_audit.md) verified the baseline951 entries/607,656 bytes, all original-byte references and143 RGB555 palette files. The95 screen rows retain20 PROBABLE/75 HYPOTHESIS classifications;41 resolve completely and54 partially under their declared models. This is finite catalogue and codec coverage, not a claim that every ROM byte is a graphics asset or every image was displayed. Retired resources are retained explicitly rather than counted as unexplained omissions.

A positive omission was found in the editable bank7C font: ten original bytes at7C:[57C3,57CD) had been left outside its two extracted binary spans, leaving80 pink glyph pixels. The [font correction](docs/research/naming_g8.md) supplies the missing10-byte span and restores exactly those80 pixels from the original bits, preserving all other pixels and the existing PNG path. Three contiguous chunks now represent the15228-byte/846-glyph body; independent inverse extraction recovers the original bits. The active catalogue becomes952 entries/607,666 bytes with951 PNG rules, while the number of unique editable PNG paths stays446. Classification remains PROBABLE and no new runtime, visual, hardware or name/frame relationship is asserted. Reconstruction checks accompany this source change; English work remains suspended until the original pass is closed.

Remaining evidence needed for semantic closure is specific: a valid entry/caller for an unresolved function, a reader/index linking names to selected resources, or a justified complete VRAM state and reversible backing for a retained view. No missing association is supplied from counts, visual resemblance, sibling execution or hypothetical PNGs; no 100% semantic or universal-caller claim follows from passing reconstruction checks.

## Source state: hand-maintained tree, frozen bootstrap pipeline

The source tree (`home/ engine/ data/ gfx/ audio/ lib/`, `ram.asm`, `ram/`, `consts.asm`, `zero_labels.asm`, `includes.asm`, `layout.link`, `constants/`) was produced once by the
bootstrap generator (`tools/gen_asm.py`, tables `config/`, layout `analysis/layout/layout.tsv`, all kept unchanged as history) and is now the **maintained source of truth**: future
work edits the `.asm` files directly.  `make` needs only RGBDS 1.0.3 and GNU make (no reference ROM, no generation step; `rgbgfx` and Python are optional); `make regen` refuses to run.
The generated tree was then refined in place, keeping the ROM identical: a `[STATUS]` note under every function label, local labels for jump targets, Shift-JIS text as readable strings through
a charmap, and extracted graphics assets that the `.asm` files `INCBIN`/`INCLUDE` (the current catalogue has952 entries; `gfx/README.md`).  How to work on it: `README.md`, `STYLE.md`, `INSTALL.md`.

Where evidence lives now:

* **In the source**: the `[CONFIRMED]`/`[PROBABLE]`/`[HYPOTHESIS]` note under each code label; the `; ---- <kind> $a-$b (n bytes) [STATUS] note` header of each data/words/ptrtable/text/gfx/zero block; the status word and note
  after the value of RAM names (`ram/*.asm`) and constants (`consts.asm`).  Source counts (`grep -rhE '^\s+; \[CONFIRMED\]' --include=*.asm home engine data gfx audio lib | wc -l`, likewise `PROBABLE`, `HYPOTHESIS`; headers
  with `grep -rhE '^; ---- .*\[STATUS\]'`): code notes 2,465 CONFIRMED / 1,297 PROBABLE / 124 HYPOTHESIS; block headers 718 / 1,810 / 146 (on 2026-10-05, 120 graphics block headers went from PROBABLE to CONFIRMED because their load call site executed in the 64 natural scenarios).
* **Frozen tables** (full evidence text, not updated): `config/symbols/bankNN.tsv` (per-symbol status and evidence), `config/regions/bankNN.tsv` (per-region status and note), `config/ram/*.tsv`, `config/xrefs.tsv`; `docs/PROGRESS.md` is generated from them.
* **Research notes**: `docs/research/*.md` (reasoning, method, retractions), dynamic evidence in `traces/` and `analysis/`.
* **New findings** go into `docs/research/*.md` and into the comment at the code; `config/` and `docs/PROGRESS.md` are not updated.

## Build / comparison state

* `make` assembles the tree (334 objects, one per `.asm` file, `rgbasm -P includes.asm -I .`), links with `layout.link` (`rgblink -p 0x00`) and the result has SHA-256 `6d802e66...6570`, identical to the reference; with the reference ROM present it also
  compares byte-for-byte: **IDENTICAL**.  CONFIRMED (`make`, `make compare`, `make sym-check`; the only `INCBIN` lines read the extracted asset files under `gfx/` and `data/fonts/`, never the ROM).
* `build/mobile_trainer.sym` has 15,538 banked labels (recounted from the published88b4bca source: 10,073 global labels including aliases and 5,465 local labels), plus 51 exported constants; `tools/sym_check.py` cross-checks them against the source
  (every label defined exactly once, comments give the linker's address).
* Far calls are `farcall <Label>` macros (5,274 sites, `constants/macros.inc`); the cartridge header (logo, checksums) is part of the source bytes, `rgbfix` is not used.
* Frozen classification (`config/regions`, `docs/PROGRESS.md`): 100% of the ROM is classified into regions: code 221,784 B (**162,635 CONFIRMED** = 73.3%, executed in the 64 natural mGBA scenarios of `analysis/coverage_union.tsv`
  (77,979 executed instruction starts; 67 scenarios with 3 forced-execution runs, `dynamic_tracing.md` section 11) or otherwise proven; 55,704 PROBABLE = statically reached; 3,445 HYPOTHESIS), gfx 491 KB (149,600 B CONFIRMED),
  data 196 KB, text 45 KB (Shift-JIS), words/ptrtable 9 KB, zero 1.13 MB.  Bytes still HYPOTHESIS: data 1,959, gfx 2,235, text 37, words 14, zero 4,694 (the region status is per region).
* Frozen symbol tables: 3,020 symbol rows (1,405 CONFIRMED, 1,395 PROBABLE, 220 generic-name HYPOTHESIS notes), 1,155 xrefs.  RAM names (source, `ram/{wram,sram,hram}.asm`): 1,084 (44 CONFIRMED, 213 PROBABLE, 827 neutral/HYPOTHESIS), plus
  221 bank-qualified WRAM/SRAM names in `ram/banked.asm` (125 CONFIRMED, 96 PROBABLE; ram12 adds seven S1 names; naming pass ram3 added five: `wKbdSlideDeltaRow` and the SRAM variable page `sVarPage` ... `sKbdInputMode`, pass sram4 85 SRAM names, the operand passes ramop7-ramop11 added 73 WRAM names of banks 1, 2, 3, 4, 5, 6 and 7); other banked addresses stay neutral.  The counts use the status word that follows the size and type in each `DEF` line; the figure "146 CONFIRMED, 65 PROBABLE" given for the 211 names of the ramop10 commit counted every `DEF` line that mentions CONFIRMED anywhere and was wrong: by the status word those 211 were 118 CONFIRMED and 93 PROBABLE.
* Naming pass 2 (`analysis/naming2/*_renames.tsv`, notes in `docs/research/naming2_*.md`): 700 rows, 595 applied (174 CONFIRMED, 421 PROBABLE; 105 stayed HYPOTHESIS ideas) and then adversarially re-checked by four verifiers (`analysis/naming2/verify_*_fixes.tsv`, `docs/research/naming2_verify_*.md`): none refuted, 19 renamed to more honest names, about 25 statuses lowered (recorded in the verifier docs; the source carries no per-name status).  Names are applied with `tools/apply_renames.py` (hash-verified, neutral names kept as aliases).
* Audio (`docs/research/audio_format.md`): all sound data is written as macros (`constants/audio_macros.inc`): 59 stream headers (11,916 commands), the 112 instrument records, the 120-entry note table, the durations and the 10 wave patterns; 0 audio bytes stay `db`.  The format was checked twice: by re-executing the driver code on all 152 tracks plus synthetic effect tests in a small SM83 interpreter (`tools/audio_driver_check.py`), and on 2026-10-05 independently by two verifiers (`docs/research/audio2_verify_static.md`, code and data only; `audio2_verify_dynamic.md`, the ROM's own driver on mGBA: 35,351 executed commands, 0 divergences from an independent decode; `analysis/audio2_verify_dyn/reproduce.sh`), whose corrections to the prose are applied in `docs/research/audio_format.md` section 12.  Commands are named by demonstrated effect; the commands no song uses (`$C0` pan, `$C6`, `$C9` detune, `$CD`, `$B5`) are PROBABLE, demonstrated with synthetic streams only (a synthetic run does not raise a status), and `$CA` and `$CD` keep neutral names (`sound_cmd_CA/CD`; `$CA` stores a byte nothing reads).  Songs are named by id only (`SoundSongNN_*` for ids `$01`-`$1D`, `SoundSfxNN_*` for the effects `$29`-`$46`); which tune is which is unknown.
* Naming pass 3 (`analysis/naming2/ram2_renames.tsv`, `data2_renames.tsv`; notes `docs/research/naming2_ram2.md`, `naming2_data2.md`): 49 RAM variables (14 CONFIRMED, 35 PROBABLE; bank-independent addresses only) and 780 data/table/graphics/sprite labels (203 CONFIRMED, 577 PROBABLE) applied, then re-checked by three verifiers (`docs/research/naming2_verify_ram2.md`, `_data2a.md`, `_data2b.md`): none refuted, 16 renames (for example the shared-root correction `BrowserShared_*` in bank 72), a few statuses changed (recorded in the verifier documents).  `tools/sprite_chain_check.py` walks every sprite object table and checks that each sprite block name is the block the chain reaches (0 mismatches).
* Naming pass 4 (`analysis/naming2/fn4_renames.tsv`; notes `docs/research/naming2_fn4.md`, verification `naming2_verify_fn4.md`): the 59 neutral `Function_*` labels left by pass 2 were read one by one; 32 are named (14 CONFIRMED, 18 PROBABLE: nine one-`ret` stubs `Stub_Nop_<bank>_<addr>`, the pieces of the glyph routines of the text engine, three Mobile SDK helpers, two steps of the HTML line layout, screen helpers), 27 stay neutral (unreferenced code without an executed twin, or a role not determined).  An independent reader re-derived every row: of the first 31, 17 upheld, 12 corrected (the corrections are merged), 1 downgraded, 1 retracted; the two layout rows were both corrected (one renamed).  Two `call nz` after `ldh a, [hJoyHeld]` can never be taken (LDH sets no flags; Z is the farcall's).
* Overlay aliases (RAM pass 3, `analysis/naming2/overlay_aliases.tsv`, `ram/overlays.asm`; notes `docs/research/naming2_ram3.md` section 5, verification `naming2_verify_ram3.md`): 364 screen-local aliases of 104 overlay bytes (62 in WRAM0, 42 in HRAM; 286 CONFIRMED, 78 PROBABLE; 10 more rows are HYPOTHESIS records, never applied), with the historical ram3 package accounting for 2,070 references in 71 files; the neutral name stays the only global name of each address and an alias is used only in its own file or function range.  Six independent readers re-derived all 276 rows of the packages: 229 upheld, 42 corrected, 4 narrowed, 1 widened, none retracted.  It corrects four rows of the ram2 overlay table (the title idle counter `C27E:C27F` is big-endian, `C286` is a one-shot sound latch, `C0E6` is the item to draw as normal in the help and mail menus, `C10E/C10F` in `Tilemap_FillRectSequential` is a constant and a start tile) and shows that `FFE0` is an index into the link pointer table.
* Banked WRAM pointer operands (`analysis/naming2/wramx_consumers.tsv`, `wramx_calls.tsv`, `ramop7_manual.tsv`, `ramop9_manual.tsv`, `ramop10_manual.tsv`; notes `docs/research/naming2_ramop7.md`, verification `naming2_verify_ramop7.md`): the address `$Dxxx` is another variable in every WRAM bank, so a pointer operand is written as a name only when the routine that receives it proves the bank (`tools/apply_ram_operands.py --areas wramx`).  1,535 operands became `wSpriteSlot0..13` (the 14 sprite slots of bank 7), `wPaletteBufBg` / `wPaletteBufObj` (the palette staging buffer of bank 7), `wSpriteSlots` and `wSpriteSlotBackup`, and 612 of the 662 generated `wSpriteSlots + N` expressions became `wSpriteSlotK + $xx`; the independent reader found and the tool now refuses the false accepts (calls that change the bank, fragments after a `ret`).  Four of the generator's `wSpriteSlots + N` names (`page_list.asm:2531-2535`) are wrong in effect: they ran under WRAM bank 1 after `Dialog_Show` (a stale bank shadow); 1,793 banked WRAM operands stayed numeric after it (1,490 after the next entry), most of them the unnamed tile staging windows of banks 2 and 3.
* Bank 7 screen buffers (`docs/research/naming2_ramop8.md`, verification `naming2_verify_ramop8.md`): `wScreenTileMap` (`$D000`, tile numbers, 32 x 32 bytes, row stride `$20`) and `wScreenAttrMap` (`$D400`, the attributes, `$0400` above it) are the two buffers that the `Tilemap_*` routines fill and `Gfx_UploadBgMapBuffers*` send to the VRAM maps (the first `$240` bytes, 18 rows, by general-purpose DMA that the project calls HDMA; `CommScene_UploadBackgroundMap` sends all `$400`); 303 pointer operands now carry their names (`ld de, wScreenTileMap + $121`) through the consumer rules, with two new proofs: the bank in A (`Gfx_StartHDMA`, `0` = the bank in force) and routines that keep the bank only when A is 0.  The second reader corrected the family of the `Tilemap_*` rules (the second pass writes at `+$0400`, so only the tile map pointer is valid), found a missing effect row (`Gfx_WaitForFrameTop`) and a latent flaw in the tool (a one-operand `add` did not count as a write of A); 36 tests.
* Tile staging windows, account work area, dialog tile stage, palette fade buffers (`docs/research/naming2_ramop9.md`, verification `naming2_verify_ramop9.md`): `wTileStage2` (bank 2 `$D000-$DFFF`) and `wTileStage3` (bank 3 `$D000-$D8FF`) are where the 8x16 text renderer and the pixel canvas write the tiles that HDMA sends to VRAM, `wDialogTileStage` is the dialog box's `$DC00-$DFFF` of bank 7, `wTextEntryBuf` ... `wDialEntries` (bank 3 `$DE80-$DFFF`) are the `TextBuf` entry buffers and the account fields of the registration and settings screens, and `wPaletteFadeFrom/To/Levels` (bank 7 `$D880-$D9FF`) are the start colours, end colours and progress words of the palette fades (the ROM's own blend routine was run on 4,000 random cases against `From + (To - From) * progress / 256`).  941 pointer operands, 104 uses of neutral names and 12 table words now carry names (20 new names); new proofs: `needs = dest` (the bank stored in `hTextTiles_DestBank`), bank `*`, the replays for `switch` and A = 0 rows, the pseudo consumer `(direct)`, every spelling of the bank register, `CAVEAT` in a `DEF` line, and by-hand rows with a context check (`tools/apply_manual_sites.py`).  Two readers found no false accept in the tree; they reverted 6 names that were true by address but not at the site (the POP3 header summary that bank 2E keeps at `$D400`, debug string scratch) and the coordinator 3 more, and 549 banked WRAM pointer operands stay numeric (336 without a rule, 103 with a proven bank but no name, 65 with the bank not shown, 20 marked `; raw`).  The four-colour fade mode contradicts itself (fills offset `$70`, blends `$60`; no caller; HYPOTHESIS).
* Mail library, sound driver, mail screens, browser and HTML buffers (`docs/research/naming2_ramop10.md`, verification `naming2_verify_ramop10.md`): the mail library of the SDK (bank 0F) is entered only through `Mail_DispatchFar` and runs only under WRAM bank 5 (invariant L5: `wMail_Work`, a union by selector, `wMail_TextBuf1/2`, `wPromptTextBuf`), the sound driver (bank 04) only under bank 1 (invariant S1: `wSoundDrv_Tracks` 8 x `$3C`, `wSoundDrv_Channels` 4 x `$18`, the tempo accumulators), both re-checked by `tools/invariants_check.py` (452 stub calls, 12 `Mail_DispatchFar` sites, every far call in the ROM, 3,951 observed instruction starts); the mail screens' `wMailInfo` (the POP3 summary of the mail server flows, over the compose buffers), `wMailTextScratch` (including the connect dialog's result text, the connection password, PROBABLE), the 21-byte `wMailSessionBlock` and `wAbookListState`; the browser's bank 6 work area (`wBrowserPageUrl`, the link heap, the dictionary history), the bank 4 page store and the HTML parser's output stream.  494 pointer operands, 197 uses of old or neutral names and 12 table words now carry names (31 new names, 12 more `CAVEAT`s); new proofs: the bank at the consumer (a bank write between the load and the call), `(direct)` behind a switch and a loop head with the `overrun` guard, the join of every way into a local label, `needs fixed`, A = 0 only for `keeps if A=0`, `; raw` never rewritten.  Four readers found no false accept in the tree (three on synthetic code, closed), reversed the five debug string scratch pointers that a new rule had named `wTileStage2`, eight uses of `wSoundDrv_HeaderTrackCount` that are the dirty-flag mask, the sender field that two lines in `pop3_top.asm` called `wEditAddressBuf`, and corrected the extent of `wHtmlLinkHeap` (2,048 bytes) and of a page title (21 bytes); 55 banked WRAM pointer operands stay numeric (41 marked `; raw`, 14 values), every other one is named.
* Bank27 computed tile pairs (`docs/research/typing_27_digit_pairs.md`, verification `typing_27_verify_digit_pairs.md`): PROBABLE ten-pair table at27:5048 read by the computed consumer27:5021; exactly8/10 second bytes equal first+$10, with indices3/9 preserved. The table, four zero bytes and three direct call sites have no natural activity in the existing69 scenarios. Two in-place comments correct the former no-reference/row-padding interpretation, preserving all bytes, aliases and locator lines; neighboring material and Function_27_4EC0 retain KEEP, and no runtime/visual/English/hardware or whole-bank closure is claimed.
* Bank26 original blank message (`docs/research/typing_26_blank_message.md`, verification `typing_26_verify_blank_message.md`): existing41-byte block is CONFIRMED text,20 Shift-JIS full-width spaces plus NUL; original ROM26 consumer48:403E selects a16-zero-byte glyph in ROM48 and two WRAM2 tile buffers. All41 bytes and11 caller starts share15 aggregate natural scenarios. Only two comments change in place; raw data, aliases and metadata remain exact. Function_26_5106 stays neutral, neighboring/unresolved material retains KEEP, and no runtime/visual/English/hardware or whole-bank semantic closure is claimed.
* Bank25 mailbox icon-bar attributes (`docs/research/typing_25_mailbox_attrs.md`, verification `typing_25_verify_mailbox_attrs.md`): original94-byte consumer /62 starts, six-byte pointer table CONFIRMED; VRAM1 rows0/1 and WRAM7 rows1/0 are distinct. Whole288-byte data stays PROBABLE (120 naturally read +24 unread spacing +144 unread tail); tail meaning HYPOTHESIS. Three in-place comment replacements preserve original bytes, aliases and locator lines. Existing69 aggregate original scenarios establish bounded cohorts, without new runtime/PPU/hardware claims; remaining material retains KEEP and bank26 was subsequently verified in eecbd640; the ordered next frontier is bank27.
* Bank22 remaining naturally read data (`docs/research/typing_22_remaining_data.md`, verification `typing_22_verify_remaining_data.md`): two original109-byte Shift-JIS/NUL strings and three opaque7-byte WRAM1 session templates now have CONFIRMED bounded consumer headers. Original bytes, kinds, line counts and namespace remain exact. The prior verification appendix now counts616 unexecuted raw instruction starts, distinct from588 maintained source units. Object-palette catalogue status at22:5C90 and its matching graphics-index row were subsequently confirmed in99f2ca1, preserving all64 RGB555 bytes; unread37/11, zero5/6448 and unresolved/unexecuted paths retain KEEP.
* Bank22 original address-book tile family (`docs/research/typing_22_address_book_tiles.md`, verification `typing_22_verify_address_book_tiles.md`): four ROM22 transfers prove the contiguous 2560-byte family of 160 tiles; the existing 26/2534-byte physical split crosses a tile. The first header is CONFIRMED and the continuation remains CONFIRMED, with raw data and both labels preserved. Full family and continuation have 9 whole/10 union natural scenarios; the first 26 bytes have 10/10. The five naturally read data headers were subsequently confirmed in40da055 and the object-palette catalogue inconsistency was corrected in99f2ca1; bank25 was subsequently verified and published in3707dd6, and bank26 was subsequently verified in eecbd640 and the ordered bounded queue proceeds to bank27; unread and unresolved material retains bounded KEEP.
* Bank73 remaining original map/attribute rectangles and ticker text-bank byte (`docs/research/typing_73_browser_remaining.md`, verification `typing_73_verify_browser_remaining.md`): four bounded rectangles 19 whole/19 union; byte73:4000 is the text ROM bank, expressed as BANK(BrowserStart_Strings). Table/text remain8 whole/19 union. Unread1024, raw animation tail3, literal-zero tail7441, code12 without entry and optional/dynamic paths retain their stated limits. This auditable disposition permits the ordered bank22 queue; it does not assert whole-bank semantic completion.
* Bank73 original animation (`docs/research/typing_73_browser_animation.md`, verification `typing_73_browser_animation_verify.md`): maps175 + attributes175 are CONFIRMED five5x7 frames,18 whole/19 union. The mixed physical176 stays PROBABLE: only attributes173 are confirmed, with raw tail3 purpose HYPOTHESIS. Retired tiles176/PNG remain historical; active assets947, tiles405, palettes143. Existing aliases, bytes and unread1024/7441 regions remain bounded.
* Bank73 original sprite chain (`docs/research/typing_73_browser_sprite99.md`, verification `typing_73_browser_sprite99_verify.md`): 5E60-5EC3 is CONFIRMED table4 + frames45/45 + script5; existing aliases and second chain76 remain exact. The former palette asset stays preserved but its catalogue/rules rows retire; active assets 948 and palettes 143. Mixed physical 5EC0-5F17 has 18 whole/19 union reads, distinct from the first chain19/19.
* Bank73 original browser rectangles (`docs/research/typing_73_browser_rectangles.md`, verification `typing_73_browser_rectangles_verify.md`): only 4367-438F / 43AD-43D5 / 441B-4439 / 4461-447F have CONFIRMED bounded tile/attribute headers, 40/40/30/30 bytes. Fixed original consumers prove geometry, ROM73, WRAM7 and corresponding VRAM banks; every byte is read in eight whole/eight union natural scenarios. Existing assets, aliases, source lines, neighboring units and frozen catalogue statuses are unchanged.
* Bank73 original ticker text (`docs/research/typing_73_ticker_text.md`, verification `typing_73_ticker_text_verify.md`): only original JP 4009-4097 has a CONFIRMED header for four existing Shift-JIS strings, 142 bytes including four NULs. Natural coverage is 19 union/eight whole-unit scenarios, with 19/19/8/8 per string. Original source/renderer banks are proved; no arbitrary selector clamp or English localized-layout/runtime confidence is inferred. Existing string bytes, aliases, assets and all other units are unchanged.
* Bank73 ticker pointer table (`docs/research/typing_73_ticker_table.md`, verification `typing_73_ticker_table_verify.md`): only 4001-4009 has a CONFIRMED bounded header for two title/body pointer pairs. All eight bytes are read across 19 natural scenarios, with eight whole-table scenarios. No universal index clamp is established; at that table checkpoint, the separate 142-byte string header remained PROBABLE; its bounded original JP refinement is recorded above. Existing words, labels, assets and instruction bytes are unchanged.
* Bank4E descriptor 1 (`docs/research/typing_4e_descriptor65a0.md`, verification `typing_4e_descriptor65a0_verify.md`): only 65A0-65BF is represented as five ROM47 far pointers, three WRAM7 destinations and five coordinate pairs. All 31 bytes are naturally read; the bounded whole header is CONFIRMED. Other descriptors, the 27-word table without a universal clamp, all bank47 assets and their statuses remain unchanged.
* Bank4E HomeURL representation (`docs/research/typing_4e_homeurl.md`, verification `typing_4e_homeurl_verify.md`): the already CONFIRMED 55-byte public ROM URL is shown as 54 ASCII bytes plus NUL in its original slot. Both aliases, all source line numbers and original bytes remain unchanged; no confidence promotion or other bank4E representation is included.
* Bank4D slot-chain confidence (`docs/research/typing_4d_slot_chain.md`, verification `typing_4d_slot_chain_verify.md`): the existing 27-byte frame/script chain is fully naturally read in three scenarios and receives a CONFIRMED header. The eight-byte root stays PROBABLE because its four-byte zero entry is unread; its legacy operand-byte locator is corrected to DE at 67:4E09 and farcall at 67:4E10. Bytes, macros, labels and asset statuses are preserved.
* Bank4D slot-map confidence (`docs/research/typing_4d_slot_maps.md`, verification `typing_4d_slot_maps_verify.md`): two existing 80-byte map/attribute pairs receive CONFIRMED headers from the exact 2x20 rectangle consumer and full natural reads in 3/1 scenarios. Four existing asset statuses follow; the third map and its table word remain unread, with whole-table PROBABLE status and no arbitrary cursor-safety claim. Original bytes, labels and instructions are preserved.
* Bank4D choice-map confidence (`docs/research/typing_4d_choice_maps.md`, verification `typing_4d_choice_maps_verify.md`): four existing 140-byte map/attribute pairs receive CONFIRMED headers from an exact5x14 rectangle consumer and full natural reads in 3/2/5/3 scenarios. Eight existing asset statuses follow; names, bytes and instructions are preserved. BG boundaries, unread sprite entries/padding and the third slot map remain PROBABLE.
* Bank4C result/text evidence (`docs/research/typing_4c_results.md`, verification `typing_4c_results_verify.md`): three existing strings have complete natural reads including NUL and receive CONFIRMED headers. The error table remains PROBABLE: 37 physical bytes, 36 guarded positions and only three observed bytes. Names, encoding and instructions are unchanged; partial scheme/fetch/cache tables and historical proof locators remain explicit.
* Bank4C page-cache typing (`docs/research/typing_4c_page_cache.md`, verification `typing_4c_page_cache_verify.md`): two naturally read record addresses are explicit words; both table aliases and whole-unit PROBABLE status remain. Four physical records support a three-slot initialized ring, and six unread bytes stay raw. Twelve active SRAM metadata locators move with the eight inserted source lines; no universal index or copy-length bound is inferred.
* Bank4C dialog typing (`docs/research/typing_4c_dialog.md`, verification `typing_4c_dialog_verify.md`): the original eight-byte argument keeps its neutral name and whole-unit PROBABLE status. The naturally read destination is represented as `dw $C220`; four unread bytes remain raw. The stored `$F0` bank argument is ignored by the fixed-WRAM write path, with no sentinel or universal ABI claim.
* Bank5C typing (`docs/research/typing_5c_comm_error.md`, verification `typing_5c_comm_error_verify.md`): 192 bytes of palettes and a31-byte frame/script/object chain receive eight exact CONFIRMED headers from complete natural reads. A file-local OAM prefix helper emits the three-byte prefix before `CommErr_Frame0_Piece2Attr`; that named symbol and its ASSERT preserve the attribute byte at frame offset12. Shared macros and engine instructions are unchanged. Three palette catalog entries and matching README rows are confirmed. Digit/text unread bytes and historical layout classification debt remain explicit.
* Original mail-library templates (`docs/research/naming2_neutral_network.md`, verification `naming2_verify_neutral_network.md`): five CONFIRMED argument roles in six operands, one overwritten TOP copy kept neutral, all 43 bytes naturally read. Immutable ROM seeds remain distinct from mutable runtime copies; storage stays PROBABLE. Twenty-two exact metadata rows preserve 23 bank-aware proof sites. Current strict neutral instruction cohort:15 names/18 operands, zero pending instruction groups,14 keeps and one partial alias; the structured-data table is named `SpriteFrameTable_6A_72A0` and its redundant `Data_6A_72A0` export has since been retired. The existing MailSession_CompareWordDeltas alias has already replaced the sole Function_26_5106 instruction operand; historical checkpoint counts remain in their dated notes.
* Mail probe and KEEP contracts (`docs/research/naming2_neutral_mail.md`, verification `naming2_verify_neutral_mail.md`): one CONFIRMED last-row probe role in two calls with its neutral alias preserved, three KEEP decisions and unexecuted result paths explicit. The early scanner RET consumes saved BC; session equality and SRAM lookup consumers remain unobserved. Five manual and two screen-operation locators move, including four guarded repairs of preexisting stale proof fields. At the mail checkpoint, the strict neutral instruction cohort was 21 names/25 operands, six pending groups, 14 keeps and one partial alias; the structured-data macro remains separate.
* Keyboard cursor flags (`docs/research/naming2_neutral_kbd.md`, verification `naming2_verify_neutral_kbd.md`): four CONFIRMED role names and four neutral aliases in four instruction operands; two unobserved siblings remain KEEP. All three 11-byte tables retain PROBABLE storage, with 16 unread bytes. Type10 exits before the predicates; the default-cursor table has ten entries. At the keyboard checkpoint, the strict neutral instruction cohort was 22 names/27 operands, ten pending groups, 11 keeps and one partial alias; the separate structured-data macro reference remains unchanged.
* Help menu maps and objects (`docs/research/naming2_neutral_help.md`, verification `naming2_verify_neutral_help.md`): eight CONFIRMED roles in 30 instruction spellings (24 old symbolic plus six guarded numeric roots), eight neutral aliases preserved. Five map pairs and both complete selected sprite chains have complete natural byte reads; the page1 selected map retains 60 unread bytes as PROBABLE. A four-byte entry crosses the historical source boundary; legacy RGB/palette classification conflicts with the demonstrated sprite chain and remains explicitly documented without retyping. At the Help checkpoint, the strict neutral instruction cohort was 26 names/31 operands, 16 pending groups, nine keeps and one partial alias; the separate structured-data macro reference is unchanged.
* Shared CommScene VRAM sources (`docs/research/naming2_neutral_70.md`, verification `naming2_verify_neutral_70.md`): three CONFIRMED roles in eight instruction operands; each existing 512-byte source contributes to two upload windows. Four calls naturally executed 160 times in 18 scenarios, with exact bank-aware source/destination spans. Headers now include both direct and cross-boundary consumers. Original neutral aliases, types, statuses, bounds and asset bytes stay unchanged. At CommScene checkpoint 835fb5b, the strict neutral instruction cohort was 34 names/55 operands, 24 pending groups, nine keeps and one partial alias; one structured-data macro reference remains separate.
* Registration/result-page tables (`docs/research/naming2_neutral_account.md`, verification `naming2_verify_neutral_account.md`): object-table base selects entry1, not an assumed safe zero sentinel; the 29-byte result aggregate contains two source lists and a five-byte index list. Four CONFIRMED roles, two scoped interior labels, five operand spellings, unchanged data and PROBABLE unread storage. Four active loader-call locators remapped. At account checkpoint a4e33ad, the strict neutral instruction cohort was 37 names/63 operands, 27 pending groups, nine keeps and one partial alias.
* Shared bank-5E entry resources (`docs/research/naming2_neutral_5e.md`, verification `naming2_verify_neutral_5e.md`): three CONFIRMED names in 34 operands, eight exact shared text-entry HDMA loads and nine BG palette loads (eight full, one keyboard +$28/$18 partial). All 17 consumers naturally demonstrated; original aliases, types, bounds and bytes retained. Shared-reader file headers corrected and 20 active label cells updated. At 37a4fa9 the remaining strict neutral instruction cohort was 39 names/66 operands; the registration/result-page follow-up above updates it. Initial worklist counts are not a remaining-operand census.
* Shared graphics source names (`docs/research/naming2_neutral_gfx.md`, verification `naming2_verify_neutral_gfx.md`): three CONFIRMED roles, 36 instruction operands and 18 natural consumers; shared 768-byte VRAM8000/VB1 source, exact 40-byte BG6..7/OBJ5..7 palette, and a shared source with two different destination slices (the +$190 crossing window stays intact). Palette header/asset confidence explicitly reconciled; no new type, bytes or boundaries. At ea2f1c6 the remaining strict neutral instruction cohort was 42 names/100 operands; the bank-5E follow-up above updates it.
* Neutral instruction-label naming (`docs/research/naming2_neutral_code.md`, verification `naming2_verify_neutral_code.md`): a strict census corrects the historical 40 to 64 names/176 instruction operands, plus one separate data-macro reference. Eighteen new names (17 CONFIRMED, one PROBABLE) replace 37 operands; three more use existing PROBABLE aliases per consumer. Mixed HDMA uses remain neutral, old aliases stay, five exact data/text regions have demonstrated local status upgrades, and active line/context records follow their original instructions. At d64fe05 the remaining strict instruction cohort was 45 names/136 operands; the shared-source follow-up above updates it. No new natural run or ROM byte changes.
* Menu map variants (`docs/research/naming2_menu_variants.md`, verification `naming2_verify_menu_variants.md`): four labels now distinguish SettingsMenu FlagSet/FlagClear and Account_ActionConfirmPage NonzeroVariant/Variant0 by their demonstrated branches. All 24 active definition/use/metadata substitutions are independently reviewed; neutral aliases and paths remain unchanged. Hidden-mode RAM semantics remain PROBABLE.
* Audio header readability (`docs/research/naming2_audio_headers.md`, verification `naming2_verify_audio_headers.md`): all 42 overlong music-header pointer rows in 22 files split into two ordered `dw` lines with unchanged group comments. No bytes, labels or statuses change; independent forced rebuild and full symbol comparison passed. No line-based record references these music files. Six non-audio long `dw` rows remain outside the pass.
* RAM naming pass ram12 (`docs/research/naming2_ram12.md`, verification `naming2_verify_ram12.md`): all 34 SRAM bases and 107 explicit sites read independently; 106 sites now use bank-proven names, seven new S1 fields (six CONFIRMED, one PROBABLE), and one write-only/unknown store stays neutral. The manual writer now checks SRAM definitions/banks and revalidates already-written rows; 20 stale context fields were refreshed after independent bank/value checks. HRAM also covers all 21 bases/403 sites: one global rename, 49 aliases and one FFC2 extension; 176 named/227 neutral sites. FFC3 browser stores remain neutral after independent refutation. WRAM completes all 97 bases/549 sites with 19 global names, 57 aliases, 278 named/271 neutral sites. Six mixed parser scopes were rejected (20 neutral sites). Entire pass:152 bases/1,059 sites,560 named/499 neutral; seven banked fields,20 global renames,106 local aliases and one FFC2 extension, all independently reviewed.
* The 123 neutral banked uses of the mail library and the sound driver (`docs/research/naming2_ramop11.md`, verification `naming2_verify_ramop11.md`; `analysis/naming2/ramop11_manual.tsv`, 138 rows written by `tools/apply_manual_sites.py`): 107 uses of `wMail_Work + $XX` / `wMail_ComposeState` / `wMail_TextBuf2` (every one in bank 5 by invariant L5; the 14 Base64 decoder uses of `$D023` are `wMail_Work + $23` because the name `wMail_ComposeState` says composer or encoder), 14 more sites by hand with a field name where the reader proved it per site (`wMail_ComposeItem`, `wMail_ItemListPointer`, `wMail_OutputBankVar`, `wMail_OutputStream + $03/$04`), and three new names in `ram/banked.asm`: `wMailReplyRecord` (`$D526`, PROBABLE, CAVEAT: the index of the mailbox record a reply answers), `wSoundDrv_VibratoTri` (`$D01E`, CONFIRMED: the triangle value of the vibrato LFO) and `wSoundDrv_ParamDirtyMask` (`$D03C`, PROBABLE, CAVEAT: the dirty-flag mask of one SetTrackParam request); no neutral `wRam_Dxxx` use is left where a banked name replaces it (the two `wRam_D525` stores stay: written, never read).
* RAM pointer operands (`analysis/naming2/ramop6_names.tsv`; notes `docs/research/naming2_ramop6.md`, verification `naming2_verify_ramop6.md`): 1,394 raw `ld hl|de|bc, $XXXX` operands of WRAM0, HRAM and the hardware registers now carry the name of their object (122 names; `tools/apply_ram_operands.py`, `--check` audits).  The first version rewrote 46 operands that are values (negative numbers added with `add hl, rr`, sprite position pairs, dead loads) and the independent reader found them; the tool's rules now leave them out, and 65 operands stay numeric on purpose (39 values, 21 marked `; raw` with the reason, 5 overlay bases).  `wMobileSDK_ServerIp` is a new 4-byte object; four phantom HRAM objects were removed.  Banked WRAM immediates are covered by the passes above (ramop7 to ramop10), ROM pointers by the bullet below (romop1); VRAM immediates are not covered.
* ROM pointer operands (`analysis/naming2/rom_consumers.tsv`; notes `docs/research/naming2_romop1.md`, verification `naming2_verify_romop1.md`; `tools/apply_rom_operands.py`, `tools/test_rom_operands.py`): 708 raw `ld hl|de|bc, $XXXX` operands with a ROM address are labels now where a consumer rule proves that the routine reads the register as a ROM pointer (23 rules: `Sprite_InitSlot` 592, the palette, HDMA, text-tile and tilemap routines, `Sprite_SetHook`, the string and table helpers, the packet senders of bank 75), 1,367 bank loads are `ld a, BANK(Label)` (719 of them beside a pointer that already was a label), and 161 new labels name the entries of the sprite object tables that the callers use as table bases (`<Table>_Entry<N>`, `gfx/`, 23 files).  The ROM is identical; `$0000` and the values below `$0150` are never converted.  The entry index of `Sprite_LoadObjectEntry` is `id & $3F` (the carry of the shifts is lost; the `& $7F` of the notes was wrong), bit 7 of the id is the script's loop flag, and the rule of `Sprite_InitSlot` was replayed in 21 natural scenarios (33,739 executions, all as modelled).  Left numeric: 100 pointers into the middle of a block or to a line that no label starts, 3 vector or null values, and 1,449 immediates in `$0150-$7FFF` whose consumer has no rule (pairs, counts, divisors, loads without a call: classified in the note).  Blocks typed as tiles that also hold a palette or a tilemap (22 pointers, 4 wrong block kinds) are the input of the next graphics pass.
* ROM pointers inside blocks and in front of data lines (`docs/research/naming2_romop2.md`, verification `naming2_verify_romop2.md`; `analysis/naming2/rom_consumers.tsv` now has six columns, `tools/apply_rom_operands.py`, 74 tests): 61 more operands: 24 palette reads, 9 HDMA tile windows and 10 tilemap Ptr reads written `Label + $offset` (each with a comment `; BB:AAAA`: an offset has no definition line to grep), 16 string pointers and one palette as new neutral labels `String_BB_AAAA` / `Palette_71_66C0` in front of the exact data line, and `dw CopyBytes` after `call FarCall_Inline16`.  The rule behind it: the routine reads a known number of bytes (constants before the call) and every line of the read is data of that kind; the reader replayed the real ROM code of all 76 first-version sites (the consumer read exactly what the rule says) and found the rules too lax in places: the tool now refuses a zero count, a read that leaves the bank or crosses code or another asset, an HDMA source off the 16-byte tile, an anchor that cuts a tile or a palette, and a tile sheet label that states another VRAM destination (15 windows stay numeric).  22 palettes and tilemaps inside blocks typed as tiles waited for the graphics retyping (next bullet).
* Graphics retyping (`docs/research/naming2_retype1.md`, verification `naming2_verify_retype1.md`; `tools/retype_blobs.py`, `tools/retype_palettes.py`, `tools/retype_lib.py`, `tools/palette_reads_check.py` with 18 checker tests and 6 kept-fragment tests): the graphics blocks are typed as what the code reads.  11 blobs whose HDMA windows mixed tiles, palettes and/or tilemap bytes (the HDMA request copies the whole blob into VRAM, so the blob looked like tiles) are split into tiles, palettes, a 32-byte gap and the pair; 3 more cases (`4B:5870`, `71:6680`, the 20 x 2 pair `56:526A`); 23 palette arrays that the code loads whole were cut in fragments, typed as tiles or typed "content class unknown" and are now ONE block each of exactly the bytes of the loads.  Every statement of a header about a load (the bytes the call takes, the buffer, the call address, whether it ran in a natural scenario) is generated from the code; two BG palettes are over-read by their call (the length of 40 bytes is by adjacency, PROBABLE).  Result: tile sheets 409 -> 406, palettes 133 -> 144, tilemap pairs 169 -> 180, whole-screen PNGs 83 -> 92, 25 operands became exact labels; `make palette-check` guards the recorded immediate palette loads; round 2 checked all 37 load sites and corrected two fragment notes and false accepts in the checker. Inherited mixed blocks remain (see the verification note).
* VRAM immediates (survey of 2026-10-06 at commit 6704de5; no change to the source): 709 `ld hl|de|bc, $8000-$9FFF` operands stay numeric on purpose.  655 are in DE and 536 of all of them are the destination word of an HDMA or GDMA request (`Gfx_StartHDMAWithService` 446, `Gfx_StartHDMA` 55, `Gfx_GdmaAtVBlankNoDi` 14, `Gfx_StartHDMAAtVBlank` 10, `Gfx_GdmaAtVBlank` 6, `Gfx_StartHDMAAtVBlank_2A_5C3B` 5; bit 0 of the word is the VRAM bank flag, so `$9401` is `$9400` in bank 1) whose source block already carries the destination in its label (`Gfx_*_Tiles9400Vb1`); the rest are tile-canvas rectangles (`TileCanvas_UploadRect` 42), sprite positions that only look like addresses (`Sprite_SetPosition` 8), connect-dialog map rows (6) and loads whose consumer is not a call (64).  A constant such as `VRAM_9400_B1` would say nothing the hexadecimal address and the block label do not say; a convention can be added if a reader asks for one.
* Sound effect calls (`docs/research/naming2_sfx1.md`, verification `naming2_verify_sfx1.md`; `constants/macros.inc`, `consts.asm`, `tools/apply_play_sfx.py`): the eight-line idiom of the user interface's sound calls (367 sites in 62 files) is the macro `play_sfx ID` (2,569 lines fewer, ROM identical), and 20 ids have a PROBABLE constant `SFX_*` (cursor move, confirm, cancel, reject, save, delete, text cursor, character entered / erased, popup open / close, link follow, history back, the communication scene closes, ...; 343 sites), named by the role of the call that two readers checked at every site; 10 ids stay numbers (`$2F` has two causes, eight have one site, `$48` is dead).  After the macro A is the `hWRAMBank` shadow and BC, DE, HL are clobbered (one site, `top_menu.asm`, stores the leftover A); the macro assumes `hWRAMBank == rSVBK` on entry and four sites differ in the replays (open question).  The WRAM / SRAM bank-switch idioms stay explicit on purpose (the bank proofs read them).
* Joypad masks (`docs/research/naming2_pad1.md`, verification `naming2_verify_pad1.md`; `constants/hardware.inc`, `tools/apply_pad_masks.py`, `tools/test_pad_masks.py`): the three joypad variables `hJoyHeld`, `hJoyPressed`, `hJoyPressedRepeat` hold one bit per button (0 A, 1 B, 2 Select, 3 Start, 4 Right, 5 Left, 6 Up, 7 Down; CONFIRMED three ways: the poll at `7D:7B7C-7BED`, each key alone in the emulator, the dispatcher `00:056A`), and 306 tests that follow a read of one of them are written as `PADB_*` / `PADF_*` (105 `bit`, 197 `and`, 3 `cp`, 1 `xor`; 239 of the 254 reads head a chain; 15 stay numeric, 40 more need an interprocedural proof); the combination B + Select + Right (`$16`) is the hidden-mode switch (`wHiddenModeFlag`; executed in `register_hidden`, `register_hidden_manual`, `settings_phone`, `fuzz_register`); `hJoyPressed` is also written by five screens (`$80` / `$40` injected before a D-pad routine); the repeat counters `wJoyRepeatCounters` are in reverse bit order.
* Structural names for the sound data (`docs/research/naming2_audio6.md`, verification `naming2_verify_audio6.md`; `analysis/naming2/audio6_renames.tsv`, applied by `tools/apply_renames.py`): 316 neutral `Data_` / `Table_` labels of the song and effect streams are named by what they are in the stream, not by what they play: `SoundSongNN_TrackK_Loop` (86: the target of the track's final `sound_jump`), `_AfterJump` (86: the first byte behind it, which no path reaches), `_SubN` (98: a pattern that `sound_call` enters), `SoundSongNN_TrackPtrs` (16) and `SoundSfxNN_TrackPtrs` (30: the pointer tables behind the headers); the old names stay as aliases.  A reader re-derived all 316 from the ROM bytes alone (316 of 316), and the natural traces raised 213 of them to CONFIRMED (the final jump of 82 of the 86 tracks executed; 97 of 98 call sites read with their return); 103 stay PROBABLE (the unreachable `AfterJump` bytes, song `$19`, effect `$37`, the tables with words no code reads).  8 interior labels stay neutral.  The headers that said "unread interior" were stale for 16 of 41 regions (their bytes are read in natural scenarios): corrected, they give the number of natural scenarios that read them.
* Naming pass 5 (`analysis/naming2/label5_renames_pkg*.tsv`; notes `docs/research/naming2_label5.md`, verification `naming2_verify_label5.md`): the 438 neutral `Label_` jump targets were read one by one in five packages; 410 are named (313 CONFIRMED, 97 PROBABLE), 6 stay HYPOTHESIS records and 1 more neutral label (7 left); readers re-derived all 425 rows (the corrected manifests are applied: debug error test handlers `_Ignore*`, the dead twin of the summary loop named after its live twin).  The pass found that the button order of `JoypadDispatch` is CONFIRMED (501 site/word/scenario triples), that twelve labels were artifacts of mistyped tables (`68:793D` are bank-`$4B` pointers, `2A:4A66` is a caption), that seven stray dead-code fragments had split functions, that the comm scene "text" sprites are a walking figure, an "@" icon and a burst (20 labels renamed `Sprite`), and several quirks of the original ROM in never-executed code (`naming2_label5.md` sections 5 and 6).
* SRAM names pass 4 (`analysis/naming2/sram4_names.tsv`, `sram4_sites.tsv`; notes `docs/research/naming2_sram4.md`, verification `naming2_verify_sram4.md`): 85 bank-qualified SRAM names (63 CONFIRMED, 22 PROBABLE) and 349 raw `ld hl|de|bc, $XXXX` operands replaced in 52 files, each with the proof of the bank; three readers re-derived all of them (names 60 upheld, 25 corrected; sites 186 upheld, 3 corrected; no wrong bank).  The overlapping names of the time-shared scratch areas follow a file-scope rule (STYLE.md, "Overlay names in banked memory"), audited by `python3 tools/apply_banked_names.py --check`.  `sSram_MailRecords` is 3612 bytes, not 3868.
* Historical neutral-label census (source, recounted on 2026-10-06 after the audio6 pass; the 6,445 global labels with an address comment of 2026-10-05 plus the 161 `_Entry<N>` labels of romop1): 739 have a neutral name (Function 27, Label 7, Data 395, Table 46, String 134, graphics kinds 130; before audio6 there were 1,055, of which 316 are the sound streams' labels that now have structural names).  At that historical census, 199 of the 739 were mentioned by code or by a data table and 40 by code (the current strict instruction count is in the neutral-code pass above); the rest (252 `Data_`, 117 `String_`, 17 `Table_`, 17 `Function_`, all the graphics kinds) have no reference at all, and most of the referenced ones are sprite frame tables that only dead tables reach.  The rest have a semantic name (some end in the original position, e.g. `Gfx_StartHDMAAtVBlank_2B_4723`, when one name applies to several places).  Every neutral
  name is a claim of ignorance, not an error (`STYLE.md` section 4).

## Reference ROM (CONFIRMED, `docs/ROM_INFO.md`)

2 MiB, MBC5+RAM+BATTERY (0x1B), CGB-only (0xC0), 128 banks, 32 KiB SRAM, Japan, header and global checksums valid.  85 banks hold data, 43 are entirely 0x00.

## What is known

| topic | status | where |
|---|---|---|
| Boot flow, RAM interrupt stubs (`jp $CBF1..CBFD` written at `00:04A0`), OAM-DMA copy, MBC5 bookkeeping in HRAM (`FF8A-FF8D`, `FFF4/FFF5`) | CONFIRMED | `docs/research/boot_and_home.md` |
| Far-call convention `call $06D1 ; dw addr ; db bank` (5,274 static sites), inline jump tables (`$0545/$0540/$056A/$0551`) | CONFIRMED | same |
| Bank 75 is the Mobile Adapter GB SDK (= Pokémon Crystal bank 44 code, byte-identical modulo relocation); bank 0F is the mail library (= Crystal 45).  Crystal community names are PROBABLE-only imports | CONFIRMED (code identity) / PROBABLE (names) | `docs/research/crystal_xref.md` |
| Adapter protocol (libmobile) and the Trainer's serial/timer path: `Int_Serial 00:01B7 -> 75:56D2`, `Int_Timer 00:01ED -> 75:58EA`, 16 packet templates verified, checksum routine verified | CONFIRMED mostly | `mobile_protocol.md`, `mobile_trainer_serial.md` |
| Text is Shift-JIS with NUL terminators; JIS X 0208 12x12 1bpp font in banks 76-7E; 55 HTML files in banks 3D/3E (index in 3F); graphics loaded raw (no compression proven) | CONFIRMED / PROBABLE | `text_encoding.md`, `bank_survey.md` |
| SRAM: five integrity schemes (mirrored pages + checksum, `MOBILE TRAINER00` magic, big-endian checksum image in bank 2) | CONFIRMED (disassembly) | `sram_layout.md` |
| Dynamic evidence: union of executed instruction starts over 69 natural mGBA scenarios (+3 forced-execution runs kept separate), 77,991 ROM starts | CONFIRMED | `dynamic_tracing.md` (round 1: 18 scenarios / 43,265 starts; round 2: 41 / 72,224; round 3: 67 / 77,979; round 4: 72 / 77,991), `analysis/coverage_union.tsv` |
| Ghidra 12.1.3 + GhidraBoy (cc9f565) builds and runs headlessly; it adds no code/data classification beyond `tools/cfg.py`; useful for decompiler views of single routines | CONFIRMED | `docs/research/ghidra.md` |

## Open questions (selected)

* (Settled: `65:4000`, `0E:4000`, `7C:7B7C` and `7C:7D1F` are `Startup_Run`, `Title_Run`, `Nav_TitleStart` and `Nav_TitleMobileSettings`, all executed in the natural scenarios.)  The role of bank 04 is settled too: it is the sound driver, CONFIRMED: `SoundDrv_FrameTick` ran 3,420,468 times in 63 of the 64 natural scenarios, writes the APU registers of all four channels, loads song records and starts tracks; see `docs/research/audio_format.md`.
* Joypad read is in bank 7D (`7D:7B7C`, CONFIRMED: `naming2_pad1.md`); `hRam_FFA7` is OR-ed into the pressed value by the dispatcher `00:056A`; its writers are listed in `ram/hram.asm`, but a nonzero button-injection role remains unproven.  Serial/timer IE is enabled in bank 75 (`75:4390`, PROBABLE).
* Bank 6C `HelpScript_Run`/`HelpScript_StepText` and the bank 72 `Dialog_Open` reader are statically mapped; see `docs/research/text_encoding.md` sections 4.1–4.2 and 6 and `help_script_stream_map_20261020.md`. The six dialog cursor-table paths, all 69 current record types and arguments at all identified caller paths are reconciled, including the state-derived `wBrowserPendingMessage` domain. The reader has no D/E range checks for other inputs; the constant first header byte `$86` still has no validated meaning. Each of the ten selector IDs in the dispatch matrix below has at least one observed natural route; remaining limits include conditional `$06/$18` branches, values and bounds outside inspected inputs, interpretation of `$86`, unresolved glyph meanings, and hardware behavior. Do not treat these limits as missing natural-entry coverage for `$81`, `$91`, or `$92`. The natural HomePage (`$11`), PageList (`$12`) and AddressBook (`$0A`) topics now have complete observed routes through return to their Help menus (14, 7 and 13 rendered screens); see `docs/research/homepage_help_script_natural_route_20261023.md`, `docs/research/pagelist_help_script_natural_route_20261023.md` and `docs/research/addressbook_help_script_natural_route_20261023.md`. Their SRAM flag/topic associations are CONFIRMED for these routes. The Help menu's inspected SRAM gates and locked/unlocked captions are also confirmed on two natural save states; see `docs/research/help_menu_unlock_natural_routes_20261023.md`. Do not treat reader, caller-argument or cursor-path identification as pending.
* The low-use far-call/jump entries are reconciled, not open: `FarCall_Inline16` (`00:06BC`) has one call site at `4F:4008` with inline `dw CopyBytes`; `FarCall_Reg` (`00:06E5`) and the tail-jump entries (`00:0716`, `00:072E`) have no call/jp byte patterns in the ROM scan. Their source names, mechanics, and limits are documented in `home/farcall.asm`, `docs/research/home_function_names.md`, `docs/research/boot_and_home.md`, and `docs/research/code_map.md`. This closes the bounded call-site/convention question, not arbitrary entry or ABI assumptions.
* Resolved in round 4 (CONFIRMED by execution, `dynamic_tracing.md` section 12): a page that ends inside a list, and a `<br clear=left>` or `<br clear=all>` inside a list, freeze the game on a blank screen in `Html_Layout_ClearAllFloats` (`74:5252`) / `Html_Tag_Br_ClearLeft/ClearAll` (`74:4BF4`, `74:4C33`): the retry never succeeds because the test compares the cursor x with `hViewX` while `Html_Layout_GetLimitsAtY` adds the list indent to it; no button leaves it, only a power cycle (scenarios `browser_ul`, `browser_brl`, `browser_bra`; controls `browser_ulc`, `browser_brc`; `naming2_ram3.md` section 5.4 and `naming2_label5.md` section 5 had it as a HYPOTHESIS).
* The frozen bootstrap mapper’s executed-start overlap at `2A:4440` is resolved in the analysis proposal: `tools/mapper.py` now discards the conflicting unexecuted `call $4441` walk only when the coverage and legal decode establish the executed instruction boundary. The regression suite passes 21 tests and the read-only check reports 78,108 executed starts with zero missing starts; this does not alter `config/`, maintained ASM, or the five unresolved natural-entry candidates. See [executed-start precedence revalidation](docs/research/code_map.md#current-executed-start-precedence-revalidation-2026-10-24).
* Banked WRAM the operand passes did not settle (`naming2_ramop11.md` section 5): `wRam_D525` (two stores of the reply flows that nothing in the ROM reads: no role name is true), the roles of `wMailSessionBlock` `+$0B` and `+$0D` (static reading only), the byte `$D023` of the mail library (`wMail_ComposeState` is the phase byte of three multi-call jobs: composer, Base64 encoder and decoder; the decoder sites are written `wMail_Work + $23`), the selectors 3, 5, 7 and 9-12 of the mail library (static reading, PROBABLE), the six `ConnectDialog_Run` template words; the four-colour mode of the palette fade (`PalFade_Start_FourColors` 4F:41A4 fills offset `$70`, `PalFade_Step_FourColors` 4F:4243 blends offset `$60`).
* Graphics blocks still `db` (no proven type: unknown content class, sprite/OAM records, animation scripts, object tables): listed in `gfx/README.md`, "Still `db`".

## What remains

The earlier numbered list is superseded as a task breakdown by the current finite closure audit and its linked ledgers. The main unresolved workstreams are:

1. The entry/role questions in [`japanese_operation_boundary_worklist_20261023.tsv`](docs/research/japanese_operation_boundary_worklist_20261023.tsv), plus fragment `26:5344–537C`, code/data candidate `28:4BA6–4BC2`, and the fourth zero record `4B:76CC–76D0` (structurally PROBABLE, purpose/use unknown). The 28-byte candidate begins after the confirmed one-pair script at `28:4BA3`; its classification, entry and purpose remain HYPOTHESIS ([bounded graphics evidence](docs/research/japanese_graphics_asset_completeness_followup_20261023.md#sprite-animation-script-contracts)). Require distinct positive caller, producer, table consumer or trace before promoting entry or purpose; do not repeat the closed direct-call, immediate, computed-dispatch, or 70-scenario scans.
2. The unresolved Bank 53 name-to-window associations and global frame-selection/unused status documented in [`bank53_names_frames_assets_audit_20261023.md`](docs/research/bank53_names_frames_assets_audit_20261023.md). The finite asset/PNG presence audit is closed; do not reopen it without new source or scope. The maintained browser selector's declared 0–26 domain now has a bounded source result: all entries select Bank 47 descriptors, and known direct callers exclude the seven out-of-domain indices that would read descriptors from WRAM. Corruption, aliases and hidden indirect callers remain outside that result; see [the frame-selector domain audit](docs/research/japanese_remaining_semantics_batch_20261024.md#browser-frame-selector-domain-and-ram-descriptor-route-2026-10-24).
3. The individually retained uncertain data and graphics contracts in the current source comments and [`gfx/README.md`](gfx/README.md), together with the other explicitly selected open questions above. For the unreferenced Bank 4E frame preview, the `4E:41E0` cursor list now has a statically established reader/layout and a separate six-byte post-terminator tail; natural entry and tail purpose remain unknown ([reader contract](docs/research/japanese_frame_wipe_cursor_contract_20261023.md)). Bank `4A:51B0` is confirmed as bytes included in the settings-menu HDMA upload, but the five static screen/cursor maps do not select its resulting tile `$77`; see the [bounded transfer and map check](docs/research/settings_menu_hdma_tail_20261024.md). Its palette role and global use remain unknown. The five Bank 2A profile scripts now have confirmed count/pair mechanics; only entries 9 and 13 are selected by the traced `Profile_InitScreen` calls, while selection of every other profile-table entry remains unestablished ([script contract](docs/research/profile_animation_script_contract_20261024.md)). The current generic-name census and ledgers reconcile at `f4ff5e2b`: 106 strict bank/address-suffix rows, 434 broad suffix rows, 268 `Candidate` labels (539 union rows, 163 shared), 2,764 local anchors, and 786 RAM equates; all 15 coverage families match. The stale `4A:51B0` Candidate ledger row left by its supported rename to `Data_SettingsMenu_HdmaTailVram9770` was removed. RAM dispositions and address-only path census remain closed for their declared lexical scopes. None of these results claims every data purpose or natural use is known.

No item authorizes English translation or ZIP reuse. Both remain paused until the Japanese review is complete and the Operator explicitly approves resumption.

## Published original bank 27 verification (2026-10-07)

Original bank 27 was published as `f2ee01f93dc7a605da664b86e8c7603be2361cae` after separate canonical batteries of 37 commands by the executor, independent reviewer and coordinator. Each returned 36 rc 0 plus the separately retained historical ramop7 schema rc 2; none is reported as 37 PASS. The coordinator then checked a fresh GitHub clone with make, sym-check and palette-check, all rc 0: all 4,176 tracked files match the published tree and the complete ROM/SYM remain byte-exact. The source changes only the two existing comments at 2013/2020; the ten-pair interpretation stays PROBABLE, including the two exceptions to +$10, the unchecked reader input and the lack of natural execution. The four zeros remain zero/PROBABLE. No new emulator, English, visual or hardware observation is claimed.

At the time of this bank-27 checkpoint, English parity with that pass, the proposed ZIP changes and the conditional language-patch build were still pending. The next original unit was then the seven 64-byte bank-28 palettes and their thirteen loaders; that verification and publication are recorded below. Bank-29 research was also still prepared for rebase and independent review at that historical point.

## Published original bank 28 palette comments (2026-10-07)

Seven existing 64-byte RGB555 palette blocks have raw-original identity, thirteen literal staging loaders and full-block reads in 14/10/11/15 cohorts of the existing 69 Japanese scenarios. The published comment-only pass splits three inherited 128-byte headers into BG/OBJ halves with zero physical source-line delta. Its canonical executor, independent-review and coordinator checks completed; the whole ROM remained byte-identical and the original SYM unchanged. Other object-table hypotheses and raw 28:4BA6 remain unchanged. This adds no new emulator, English, visual or hardware observation; see the [research and verification records](docs/research/typing_28_palettes.md).

### Bank 28 verified execution (2026-10-07)

Executor, independent reviewer and coordinator each completed the canonical 37-command protocol: 36 commands returned zero; ordinal 27 retained the known ramop7 missing-column schema rc 2. The coordinator read all 139,102 bytes / 1,107 lines of its merged logs, checked the complete source and postguards, and recorded 222 ResourceWarning events and 222 tracemalloc hints; no traceback occurred. These warning counts are recorded rather than presented as a warning-free run. The whole rebuilt ROM matches the original SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` (`RESULT: IDENTICAL`), and SYM remains `cbc229d7ec60c419e78a9bf2aacf848eb9b3a47e690c95f0a26484a575aa26ce`. This establishes byte equivalence for this comment-only pass, not new runtime, visual, English or hardware behavior.

The prepared bank-28 statements above remain historical. All seven 64-byte palette interpretations and thirteen loader windows were independently confronted with the original bytes and the existing 69/69/50 natural corpus. Four source owners retain 495 total lines / 393 significant noncomment lines; seven comment changes include three blank-to-comment substitutions, so the blank-retaining strict vector loses exactly three EMPTY entries. All labels, assets, 289 TSV files, 649 active anchors and 1,947 historical locators remain exact. The integration guard was corrected through a separate typed continuation before the first coordinator command: it protects regular files, directories and two existing libmgba symlinks without reapplying source or replaying commands. Git publication and the fresh remote comparison are subsequent steps.

### Published bank 28 and parallel continuity (2026-10-07)

Original bank-28 source commit `236072d374593dadea8b39509e0d11dab2d76716` is published through a normal push and verified in a fresh HTTPS clone of main. Fresh make, sym-check and palette-check each returned zero; all 13,756 bytes / 364 lines of those logs were read. All 4,178 source bytes, Git blobs and modes were checked, with filesystem modes recorded separately (actual root 0777, fresh 0664, fresh original reference 0444). The whole ROM remains `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` and SYM `cbc229d7ec60c419e78a9bf2aacf848eb9b3a47e690c95f0a26484a575aa26ce`; 334 object-owning sources, 15,535 banked labels and 51 constants. The final coordinator publication receipt SHA-256 is `a48ef74030dd177426112b8cd36c83086e2525d9a408b1d3b3a00bec29095685`. Earlier pending-publication statements are historical stages.

English branch `codex/translation-en-reflow` is published at `de315cf05796f14a5ba31473b7a6d8b488ed19ab` (parents ff8b79b + original 0fee8d6). Executor, independent, coordinator and GitHub-fresh six-command checks each completed with six rc 0. The coordinator and fresh logs were read in full (9,054 bytes / 72 lines and 22,226 bytes / 428 lines), and all 4,180 sources / Git blobs plus 675 generated outputs were checked. The ROM remains `a75d58bf4e6fd0817d9993b851ae4735f32ca77f0bb043727aa2a83bbc4b7f04` and SYM `072f531941cce39056ac6028a32d9351a700cf0fb90f0357c291154b9974eebc`; 345 ASM files / 336 objects, 15,540 banked labels and 51 constants. Local origin remains `/tmp/mobile-trainer-translation-inplace`; publication used the explicit GitHub URL. The source/glyph/assets inventory remains 540 localized paths, 303 glyphs and 947 assets; runtime, layout, rendering, translation fidelity and hardware are UNVALIDATED. The final receipt SHA-256 is `f3230193a3660b94a80a4af20f281b2ac5f726f1836789be12d3c151df7a4d88`.

Next original pass: the three bank-29 numeric templates, with fresh OWN/rebase from this published documentation baseline before executor/independent/coordinator checks. A parallel review of 29:5090–5376 retains HYPOTHESIS and all labels: zero observations in the existing natural corpus is bounded evidence; 4,001 unbanked raw word matches refute the old literal word-absence claim but do not establish callers. That header correction is a separate pending scope. English parity with bank 28 follows through private agents before new ZIP work. ZIP reuse still has 5,182 pending offsets / 21 units / 11 owners; the proposed bank-25 delta of 85 bytes and FullHelp relocation are not adopted. The requested make english / language-patches/en design includes text, sprites, tiles, editable PNGs, maps, attributes, palettes, box/layout redraws and ASM with original fallback; implementation remains conditional on complete verified ZIP parity.

## Fresh prepared original bank 29 proposal after bank 28 publication (2026-10-07)

The bank-29 proposal now has a fresh OWN/base at published `0bb401b59b54e14b8d31b8109125ae4cfd6b461e`, following source bank28 `236072d374593dadea8b39509e0d11dab2d76716`. The explicit `0fee → 236072d → 0bb401b` rebase preserves all earlier prepared and published documentary text. The proposed source scope remains only `engine/mail/result_screens.asm`: three template headers, two raw-to-SJIS blocks (22 bytes), existing labels and aliases preserved. The owner retains 2,447 lines; raw significant lines change 2,109→2,113 because four charmap controls are added, so lexical vectors differ while the narrowly normalized emission vectors remain equal.

Fresh original bytes and all69coverage/69dataaccess/50callgraphs confirm the same bounded8/4/7full-template read cohorts, nine caller windows and complete279-byte/177-start/ten-Divide16 formatter bodies. Merged dataaccess does not attribute temporal events to a particular reader. Build/adoption and canonical37 review remain pending; source28 publication/fresh3 does not establish bank29 equivalence. See `docs/research/typing_29_number_templates.md` and `docs/research/typing_29_verify_number_templates.md`, which retain the0fee prepared notes as marked history. No new English, emulator, visual or hardware claim is made.

## Verified original bank 29 decimal-template representation (2026-10-07)

The five-path candidate on published original `0bb401b` was independently reviewed and integrated. Executor, independent reviewer and coordinator each completed their single canonical37 battery: **36 rc0 plus historical ordinal27 rc2 with the exact 97-byte missing-column diagnostic**, not 37 passing commands. The two private runs preserve 671 generated files; the coordinator preserves its separately inventoried 674 outputs including three pre-existing macro fixtures. All complete logs and before/after source, Git, filesystem mode, tool, reference and generated-output guards were read and bound by the coordinator. ResourceWarning events and tracemalloc hints are counted separately. The rebuilt original ROM compares byte for byte IDENTICAL, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; SYM `cbc229d7ec60c419e78a9bf2aacf848eb9b3a47e690c95f0a26484a575aa26ce` and MAP `6d100afc5c489140c7fe41a2ca182d8858ea2a60877bbd0b5958331b09b43b72` remain byte-exact.

Only two eleven-byte DB representations and their charmap controls, three template headers and two explanatory comments change in the maintained owner; its 2,447 lines, existing labels/aliases and 289 metadata TSVs remain intact. Raw lexical vectors differ as documented; the narrow emission proof and rebuilt-ROM comparison are separate. The recorded 8/4/7 template cohorts use existing original traces only. No new runtime, visual, English or hardware evidence is claimed; unobserved branches and the unrelated library retain their uncertainty. Earlier prepared/pending statements are retained as historical stages. Publication and clean GitHub checkout checks are the next separate stage.

## Published original bank 29 provenance (2026-10-07)

Original source commit `28c26377039742d48ad0c9a5b0afab85857e0220` (parent `0bb401b`) is published by a normal push and verified in a clean HTTPS GitHub checkout. Fresh make, sym-check and palette-check each returned zero; all 13,818 bytes / 365 lines were read, all 4,180 source files and Git blobs/modes matched, and all 671 fresh generated files were bound. The whole ROM/SYM/MAP remain byte-exact to their original references. Actual root filesystem mode0777 and fresh0644 are recorded separately from Git100644 and ignored reference0444. The fresh receipt SHA-256 is `2de4d7606542dc79b7769f6854f15f062fa9d24e2ceb98d37f6d6ae2f4b0b1bf`. This append changes documentation only; all 4,176 outside files and the 674 coordinator outputs inherit the verified source commit. Earlier pending statements are historical.

At the historical checkpoint recorded here, the SYM retained 693 `Function_*` compatibility labels across 46 banks; 24 had no additional descriptive global alias, across 18 banks. This was an alias census, not a total of unfinished banks or proof that existing aliases/uncertain data were semantically closed. A fresh lexical scan of the maintained Japanese source roots and `build/mobile_trainer.sym` at `086bed07` finds no `Function_*` labels; this does not establish semantic closure of all functions or uncertain data. All 128 banks reconstruct byte for byte.

The next original scope is the separate29:5090–5376 library-header correction, retaining HYPOTHESIS and names until evidence supports more. English is still separately published atde315cf; private bank28 parity EX/INDsix-check packages passed and await coordinator integration/publication/fresh checks. These original bank29 results do not establish English behavior. ZIP85/FullHelp are not adopted; make english remains conditional on complete verified ZIP parity.

A separate coordinator readback checked all 12,540 Git blobs across actual JP, actual EN and the fresh JP checkout (198,013,136 bytes), with current complete regular rawGit file snapshots before and after equal; receipt SHA-256 1b21b2b1f9ae9a67a591c86f6f8543c2fcb97f93003eff4245aaf0cec0b8d1ba. This separate readback does not retrospectively supply per-command JP/fresh rawGit snapshots absent from the first fresh-check helper; that helper guarded their source, output, HEAD and status each command and the full EN owner. The successful three checks were not replayed.

The user-requested bounded audit of `data/text/pokemon_names_bank53.asm`, frame windows, tile resources and exported PNGs is now complete and reconciled to current main in `docs/research/pokemon_names_bank53_asset_audit_20261020.md`. It found no missing referenced file or orphan PNG/binary in the reviewed 208-file scope. The eight KEEP compositions and 25 name/frame associations remain open; computed readers, natural selection and global unused status are not established.


## Prepared bank 29 candidate-library header correction (2026-10-07)

The library span `29:5090–5376` remains HYPOTHESIS. A separate prepared pass corrects 15 header/synopsis comment lines: external calls and raw outside word/CALL/JP matches preclude the former literal self-contained/no-match claims. Bank-selection writes, physical-bank padding, ROM/mapper accesses and incoming SVBK/DE contracts remain unresolved. The owner body, labels/aliases, line counts and metadata are preserved. Existing natural69/69/50 files show zero span occurrences within their bounded corpus; this is not universal absence. No new gates, emulator, forced trace or rebuilt-ROM equivalence is claimed. See [the evidence limits](docs/research/typing_29_palette_library_evidence_limits.md) and [prepared verification](docs/research/typing_29_verify_palette_library_header.md).


## Published bank 29 candidate library header correction (2026-10-08)

Original source `f450f1b6c9be703e6632d1d679689e7cba38f826` (parent `7fb572c`) is published in the five-path scope. Fifteen header/synopsis comment lines were corrected; the owner body, labels/aliases, 559 lines, 517 significant lines and metadata remain intact. Every library entry remains HYPOTHESIS: raw patterns and zero hits in the bounded natural corpus do not establish callers, live bank/SVBK context or intended behavior. Earlier prepared statements remain historical.

Executor, independent reviewer and coordinator each completed one canonical 37 battery: 36 rc0 plus ordinal 27's exact 97-byte historical schema diagnostic at rc2. ROOT logs are 142,297 bytes / 1,104 lines, with 222 ResourceWarning events and 222 hints and no traceback; the separate private 1,878-line totals are not substituted. ROM/SYM/MAP remain byte-exact and the ROM compares IDENTICAL. The 674 actual outputs include three pre-existing fixtures; private/fresh outputs total 671. Fresh GitHub make, sym-check and palette-check each returned zero, with all 13,487 bytes / 358 lines read and all 4,182 source files/Git blobs and 671 outputs matched. See [verification](docs/research/typing_29_verify_palette_library_header.md) for receipt hashes and modes.

English `7e5e4b13aa7bc01cb977716899c1099074dae002` is separately published/fresh-six accepted; its literal pre-clone closure limitation is retained in verification. This original pass does not integrate English bank29 or add runtime, visual or hardware evidence. The following DOC3 append inherits the verified source without replaying builds; its publication remains a separate stage. The requested bank53 audit remains deferred.


## Prepared bank 00 A2A/D34 contract corrections (2026-10-08)

A separate six-path proposal on published original `010c349c630f7f10db67581e0e3ef90e0c1fe7f7` corrects one A2A comment and four D34 comments, retaining neutral PROBABLE entries. Ordinary A2A returns A=D; D34 sign-extends a WRAM0 byte and rewrites only the explicit low-bank selector from entry A. Shadow/high-bank, stack/alias, interrupt and caller limits remain unresolved. Source bodies, 517/135 lines, labels and metadata are unchanged. [Analysis](docs/research/typing_00_a2a_d34_contract_corrections.md) and [prepared verification](docs/research/typing_00_verify_a2a_d34_contract_corrections.md) record raw/natural evidence and qualified chronology. Builds and canonical37 are pending ROOT review/approval; no new runtime or equivalence is claimed.


## Published original bank 00 A2A/D34 comment corrections (2026-10-08)

Original source `9466d8def5d4cc4a186dcf00bbdbf2a42fc61361` (parent `010c349c630f7f10db67581e0e3ef90e0c1fe7f7`) is published by a normal six-path commit and push. Five comment rows correct ordinary register and selector effects; the two routine bodies, 517/135 lines, neutral PROBABLE labels and metadata remain unchanged. The bounded natural corpus has zero observations of either routine; stack/alias, interrupt, bank-shadow/high-bank and caller limits remain qualified. Earlier prepared/pending text is retained as history.

Executor, accepted independent V2 and coordinator each completed one canonical 37 battery: 36 rc0 plus ordinal 27's exact historical 97-byte schema diagnostic at rc2. The independent V1 reference-alias partial negative remains separate. ROOT logs total 140,092 bytes / 1,105 lines, with 222 ResourceWarning events and 222 hints; private 1,878-line totals are separate. ROOT rebuilt the original ROM byte for byte IDENTICAL, retaining ROM/SYM/MAP and all 674 outputs, including three pre-existing fixtures. [Verification](docs/research/typing_00_verify_a2a_d34_contract_corrections.md) records receipt hashes and the new native environment. Fresh GitHub make, sym-check and palette-check each returned zero. ROOT accepted all 13,729 bytes / 363 lines of the three logs, 4,184 source files/Git blobs and 671 fresh outputs. The complete native/tool closure and whole current owners were guarded immediately before clone and every command; the original ROM remains IDENTICAL. Fresh source/output mode0644, actual mode0777, Git100644 and references0444 remain separate. Fresh result SHA-256 `6ab9817734003fffbbef8b14c65bc93ef7e39afbe15b5776528e4112700811b5` and ROOT fresh acceptance SHA-256 `b43d4450ef8b3b2a9f295a1b95700a8677e15fa6e31e74da7fc275200d875a8d` record this completed source stage. This documentation-only follow-up inherits the verified source without replaying builds; its final publication receipt is recorded separately. No new runtime, visual, English integration or hardware evidence is claimed; English remains frozen at `7e5e4b13`.


## Fresh prepared bank26 word-delta alias on bank00 final documentation (2026-10-08)

A separate six-path private proposal on `1004c664dddcbaf9a046a8910f37dd6b4f785a57` adds the PROBABLE `MailSession_CompareWordDeltas` alias at26:5106 and changes its existing CALL operand, retaining neutral Function_26_5106 atline93 and every local scope. OwnerLOC1300/2030 and289metadata locators remain unchanged; exactlytwo strict vectors change. The existing49/seven-scenario natural entries and39available callgraph returns do not observe the20-start equality arm or establish field meanings. [Analysis](docs/research/typing_26_compare_word_deltas_alias.md) and [prepared verification](docs/research/typing_26_verify_compare_word_deltas_alias.md) preserve the historical010c proposal and explicit freshrebase. Canonical37/ROM comparison are pending new ROOT review/approval; expectedSYM adds exactlyone alias, while twoOBJ and MAP metadata may differ.


### Bank 26 word-delta alias: accepted source verification (2026-10-08)

SOURCE commit `b884275d35117609657fcadb72bc8baaf73c2511` preserves the neutral `Function_26_5106` entry and adds `MailSession_CompareWordDeltas` at the same address; the maintained caller uses the alias. Each separate EX, IND and ROOT 37-command run completed with 36 rc0 results and the known ordinal-27 schema diagnostic (exact 97-byte output, rc2). The original ROM remained byte-identical; the sole added SYM alias, sole MAP alias line and two affected object metadata profiles were checked separately. Source publication contains 4,186 tracked files.

The restricted word-delta contract remains PROBABLE. Natural evidence covers 52 of 72 instruction starts; the 20-start equality branch remains unobserved, and field meanings remain HYPOTHESIS. No complete-body confidence promotion follows from the build checks. Fresh GitHub make, sym-check and palette-check each returned zero. ROOT accepted all 13,903 bytes / 367 lines of the three logs, 4,186 source files/Git blobs and 671 fresh outputs. The complete native/tool closure and whole current owners were guarded immediately before clone and every command; the original ROM remains IDENTICAL. Fresh source/output mode0644, actual mode0777, Git100644 and references0444 remain separate. Fresh result SHA-256 `bdf3d4f3278827bb1858e5d0012b6f1421cfd83103c58508046672c9a6242101` and ROOT fresh acceptance SHA-256 `c587369a7cfc8365bdc0a6b9438a416fdace6ad63ff21f346b3647079aac0de5` record this completed source stage. This documentation-only follow-up inherits the verified source without replaying builds; its final publication receipt is recorded separately.


## Prepared header corrections — banks23/24/27/1A (2026-10-08)

A private comment-only pass corrects twenty byte stores at23:6D61, “くーくー” at24:42E7, rWX at27:4EF5 and six strings at1A:477E. Entries/statuses remain qualified; emitting rows, labels, source lines and metadata locators stay unchanged. See [header facts](docs/research/typing_23_24_27_1a_header_facts.md) and [prepared verification](docs/research/typing_23_24_27_1a_verify_header_facts.md). Validation/publication of this family is pending independent/ROOT review.

- **Header facts 23/24/27/1A verified (2026-10-08):** source `4e868038ea664d364b09fd626f1a3dfb0c27246d` was published and rebuilt from a new GitHub clone. `make`, `make compare` and `make sym-check` each returned 0; ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`, `RESULT: IDENTICAL`, and all 671 output files match the accepted original pass. Seven comment rows changed; neutral labels, physical source rows and metadata locators remain intact. See `docs/research/typing_23_24_27_1a_verify_header_facts.md`. Entry/domain/purpose qualifications remain HYPOTHESIS.


## Prospective header limits in banks 2C and 4F

A private combined comment pass corrects the unsupported caller/impossibility wording at 2C:4760, the 80-byte-plus-NUL text count at 2C:4779, and the four-instruction count/natural-absence wording at 4F:4243. It preserves neutral names, HYPOTHESIS/PROBABLE status, both emitting bodies and all locator positions. This aa61 preparation is historical and waits for current header-family publication, fresh OWN/rebase and separately approved combined validation; it is not a completed gate. See [bounded facts](docs/research/typing_2c_4f_header_limits.md) and [prepared static verification](docs/research/typing_2c_4f_verify_header_limits.md).


## Published 2C/4F header limits (2026-10-08)

Original SOURCE `f19d9c6c094b7fa4b49a9a746235615347327c0d` (parent `29c29142`) is published by a normal six-path commit and push. Seven comment rows correct caller wording, the 80-byte-plus-NUL text count and the four-instruction count; neutral labels, emitting bodies, physical rows and all 289 metadata TSVs remain intact. Entry/purpose and unobserved natural paths retain HYPOTHESIS/PROBABLE qualifications. Earlier preparation statements remain historical.

Separate executor, independent reviewer and ROOT canonical37 batteries each completed 36 rc0 plus ordinal27's exact historical 97-byte schema diagnostic at rc2. The original ROM remains byte-identical. ROOT accepted all five publication logs, ten before/after owner records, raw Git transitions, current owners and 674 outputs, then confirmed the remote HEAD. Source publication acceptance SHA-256: `0a08d2eaf4a4072feb941ea3a33fb97de61ac928beae3c8f4ba1b233dab53993`.

A new HTTPS GitHub clone at that HEAD contains 4,190 source files. Fresh `make`, `make compare`, `make sym-check` and `make palette-check` returned zero; all 13,597 bytes / 359 lines of these four logs were read. The rebuilt ROM reports SHA-256 OK and RESULT: IDENTICAL (`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); symbols retain 15,536 labels and 51 constants. Palette checking reports 162 loads, 116 arrays, two documented over-reads and zero errors. All 671 fresh outputs match the accepted original pass. Fresh acceptance SHA-256: `42800a8b5b5ac9a1dd12542287a49c3254b8b4e200bc309a61995a495855e449`. Actual filesystem0777, measured fresh0664, Git100644 and private references0444 are separate. The earlier fresh0644 assertion was incorrect; a later direct measurement found all 4190 source files and 671 outputs at0664, without chmod or changes to bytes/check outcomes.

The direct fresh validator does not claim per-command snapshots of actual owners or the complete native closure. Its first invocation stopped before builds on a missing script key; a later textual assertion incorrectly expected comparison wording from successful sym-check. The same clone was continued, and no completed build/check was repeated. This documentation append inherits the verified source without another canonical37 run. No new runtime, English, visual or hardware evidence follows. English ZIP102/parity remains a parallel workstream. The unused-frame, asset and bank53 Pokémon-name audit is required before declaring the original disassembly complete.


## Prospective browser ReturnOnly aliases

A portable private proposal adds PROBABLE ReturnOnly aliases at 4C:4016 and 4E:58AB, retains both neutral labels and existing comments, and rebinds only against private parent29c provenance. The future adopted parent/count and execution/publication authority remain NULL. It remains after the 2C/4F pass; no queue completion is claimed. The 4C eighteen-instruction header is inherited regional attribution, not the one-byte RET leaf length. SYM/MAP/object symbol records require new bound expectations. See [bounded proof](docs/research/naming_browser_return_only.md) and [prepared verification](docs/research/naming_browser_verify_return_only.md).


## Original integration validated (2026-10-08)

ROOT integrated the two non-emitting aliases on published parent `734dc4f`, preserving the neutral labels. Executor, independent reviewer and ROOT each completed one canonical37: 36 commands returned zero, and ordinal27 retained its exact historical 97-byte schema diagnostic at rc2. Actual `make` reports SHA-256 OK and RESULT: IDENTICAL; sym-check and palette-check passed. All 671 actual outputs match the independently accepted private implementation. SYM has 15,538 labels and 51 constants, with only the two expected aliases added. This establishes original-ROM equivalence, not natural entry coverage or a domain purpose. Fresh GitHub validation follows publication.


## Prepared original bank 55 lookup comments (2026-10-08)

A private five-path comment-only proposal on historical original `aa61d893`
retained neutral `Function_55_6EEC`/`Data_55_6EF7` at that checkpoint. Those
spellings are historical: the routine was later named `Kbd_Type6To10Flag`,
and the table is now `Table_Kbd_Type6To10Flag_ByType` (see the current
2026-10-21 follow-up below).
The bounded static contract returns ROM55[$6EF7+unsigned A], preserves
BC/DE and leaves ADC-derived F=$00; indices 0–5 yield zero and 6–10 one,
with no bounds check. Caller/handler entry, natural input domain and purpose
remain HYPOTHESIS. The correction distinguishes conditional selection of
55:5F29 from its unconditional CALL at 55:5F2A. Only six ASM comment rows
change. [Analysis](docs/research/naming_keyboard_55_lookup.md) and
[prepared verification](docs/research/naming_keyboard_55_verify_lookup.md)
record the zero candidate observations in the bounded original corpus and
the unchanged source vectors. Future parent is unassigned; it is queued after
23→24→27→1A, 2C→4F and the browser return duo. Build/canonical37, rebinding,
integration and byte comparison remain pending; this is not an adoption result.


## Fresh published RET validation (2026-10-08)

Original `a609e884bff63f4bcc56d034a597eeecc9ac6e6c` rebuilt in a new GitHub clone. Fresh make returned0 and SHA-256 OK; the reference was absent at that first build. After adding the private original reference, make compare, make sym-check and make palette-check each returned0; comparison was IDENTICAL. The make command was not repeated after a textual assertion incorrectly required comparison wording. All4192 tracked sources match the publication and all671 outputs match the accepted pass. Source/output filesystem modes were measured0664, independently of Git100644. Runtime and purpose remain qualified.


## Original integration verified (2026-10-08)

The bank55 lookup comment pass was rebased on published original a609e88. ROOT executed one canonical37, with36rc0 and the expected ordinal27 rc2/97-byte historical schema diagnostic. make reported SHA-256 OK and RESULT: IDENTICAL; symbols/palettes passed and all671 outputs remain byte-exact to the private pass. Neutral labels, emitting source and metadata remain unchanged. Independent verification is a composite: its first1–5 succeeded, ordinal6 stopped because private source0444 made a copied PNG read-only, then the failed PNG test and remaining tests/ordinals7–37 completed in a writable private copy. The successful commands were not replayed; this is not a single independent37 all-pass result. Domain/entry remain HYPOTHESIS. Fresh validation follows publication.


## Prepared original 6C:61AC header limits (2026-10-08)

A private five-path proposal on historical aa61d893 replaces three existing
comments, retaining neutral PROBABLE `Function_6C_61AC`. The 31-byte block
decrements C0DA modulo 256: old 0 returns after becoming $FF; old 1 reloads 35,
toggles only C0D9 bit 0 and prepares D=($78+new byte)mod 256,E=$80,HL=$DA20 for
the sprite helper. Its WRAM7 writes and SVBK restoration from the software
shadow remain qualified. Input domain, entry and purpose are unproved;
universal A/F and unrelated deferred-text-sound semantics are not adopted.
[Analysis](docs/research/naming_6c_61ac.md) and
[prepared verification](docs/research/naming_6c_verify_61ac.md) preserve the
bounded natural absence and unchanged source vectors/1,019 lines. Future
parent and actual 37 results remain unassigned; no adoption or equivalence
result is claimed.


## Fresh bank55 publication verified (2026-10-08)

A new GitHub clone of original b91d60c43bd55c1d62f7704db570753062a74e58 passed make, make compare, make sym-check and make palette-check once each. ROM SHA-256 OK and RESULT: IDENTICAL; all4194 tracked sources match their published Git blobs and all671 outputs match the accepted pass. Source modes were measured0664, separate from Git100644. No new natural execution or hardware claim follows.


## Original bank6C integration verified (2026-10-08)

Three comment rows in help_script.asm qualify the unobserved31-byte fragment at6C:61AC. The counter address is C0DA; conventional local behavior decrements it, reloads35 on expiry, toggles C0D9 and calls the bank7 sprite-position helper with HL=DA20. Entry, purpose and broader register/bank contracts remain HYPOTHESIS. Neutral symbols, all emitting rows and metadata locators stay unchanged. Executor, independent reviewer and ROOT each completed a new canonical37,36rc0 and expected ordinal27 rc2/exact97-byte schema diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL; symbols and palettes pass, and all671 actual outputs are byte-exact to the accepted private implementation. This validates reconstruction, not natural reachability. Fresh GitHub checks follow publication.


## Prepared bank 7C:7D8D choreography header (2026-10-08)

The neutral `Function_7C_7D8D` retains PROBABLE static polling and HYPOTHESIS entry/purpose. Direct entry passes incoming A; prefix 7D8B(A=0) remains unproved. Exact 111-byte/39-start/nine-far-triple scope, final JR7D82 and finite natural-zero evidence are preserved. [Analysis](docs/research/typing_7c_7d8d_choreography.md) and [prepared verification](docs/research/typing_7c_verify_7d8d_choreography.md) record a comment-only historical aa61 proposal; future parent/integration and gates are NULL. English is UNVALIDATED.


## Fresh bank6C publication verified (2026-10-08)

A new GitHub clone of135019cdc384ebf17a6d4f1a1773b74a9d6fd75c passed make, compare, sym-check and palette-check once each. The original ROM is byte-identical, all4196 tracked sources equal published Git blobs, and all671 outputs equal the accepted pass. Source filesystem0664 and Git100644 remain distinct. This adds reconstruction evidence only.


## Original bank7C integration verified (2026-10-08)

Two existing comments qualify the111-byte fragment at7C:7D8D:84 CPU bytes plus27 inline farcall data bytes,39 starts and nine farcalls. Direct entry leaves the first argument A unspecified; the final JR at7DFA targets7D82, and there is no RET in this bounded interval. No routine purpose or natural entry is established. Neutral symbols, emitted bytes and metadata positions remain unchanged. Executor, independent reviewer and ROOT each completed one new canonical37 with36rc0 plus expected ordinal27 rc2/exact97-byte diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL; symbols and palettes pass, and all671 actual outputs equal the independently accepted private pass. Fresh published validation follows.

- **2D:4E42/4E54, named mail-body locators (operation PROBABLE; natural entry/domain HYPOTHESIS):** current source names the wrapper `MailBody_LocateCell` and helper `MailBody_LocateCellInMappedWram`; the old `Function_2D_*` aliases are retired. Static decoding shows prior-row width-12 scanning and an early `RET` at4E72 that consumes saved entry BC, leaving the caller return stacked. Ordinary-return and WRAM1/RAMG effects are qualified separately. The finite canonical189 set records no observed scoped entry. See `docs/research/typing_2d_4e42_4e54_stack_scan.md` for the source-label history and conditional contracts.


## Fresh bank7C publication verified (2026-10-08)

Original d16493abbdfd68ed1321fb0dbda533fbe369d945 passed make, compare, sym-check and palette-check once each in a new GitHub clone. All4198 tracked sources match published Git blobs and all671 outputs match the accepted pass. SHA-256 OK and RESULT: IDENTICAL establish original-ROM reconstruction; no new natural entry or hardware evidence is inferred.


## Original bank2D integration verified (2026-10-08)

Four existing comments qualify the74-byte/49-start wrapper and helper at2D:4E42/4E54. Under the conventional stack interpretation, the early RET at4E72 consumes saved BC as PC rather than the real return address; it lacks the balancing POP BC. This behavior is preserved. The12-cell bound applies to the width before the NUL case; the selected scan phase has separate bounds and the FF counter represents255 units. WRAM1 selection and mapper disable on ordinary wrapper return do not establish a universal bank/ABI contract. Entry and purpose remain HYPOTHESIS. All emitted rows, neutral labels and metadata locators stay unchanged. Executor, independent reviewer and ROOT each completed one canonical37:36rc0 plus expected ordinal27 rc2/exact97-byte schema diagnostic. Actual make reports SHA-256 OK/RESULT: IDENTICAL; symbols/palettes pass and all671 outputs match the accepted private implementation. Fresh publication checks follow.

### Static boundary at 68:5D2F

PROBABLE: `Function_68_5D2F` is a one-byte `RET`; the adjacent unlabelled sequence
`[68:5D30,68:5D9C)` is 108 bytes and cannot be entered by fall-through from that RET.
Its SRAM/WRAM comparison shape is statically supported; entry, purpose and natural
reachability remain HYPOTHESIS. The sequence is now labelled
`Account_PasswordEntry_CompareStoredPassword` at its first byte; the historical
54-instruction decode spans both parts and does not establish one function.
No instruction operand or emitted byte changes.
See [boundary note](docs/research/naming_68_5d2f_ret_boundary.md) and
[verification limits](docs/research/naming_68_verify_5d2f_ret_boundary.md).


## Original bank68 integration verified (2026-10-08)

Three comments separate the RET at68:5D2F from the108-byte/53-start comparison candidate. The candidate selects SRAM1 and WRAM3; unequal strings clear bit2 of C278, so A is not a general Boolean result. Hardware restoration depends on synchronized shadows and a stable stack/scratch context. Entry and purpose remain HYPOTHESIS; neutral symbols and all emitted bytes remain unchanged. Executor, independent reviewer and ROOT each completed a new canonical37:36rc0 plus expected ordinal27rc2 with its exact97-byte diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL; symbols and palettes pass, and all671 actual outputs equal the accepted private pass. Fresh published validation follows. ROOT guarded source hashes each command; no fresh native or actual English-owner closure is claimed.


### Static split returns at 73:6143

PROBABLE conditional mechanics: [73:6143,6149) and [73:6149,614F) are two six-byte/three-start segments, each LD A,[C0F8/C0F9], XOR1, RET. Neither ordinary path falls through. XOR1 toggles only bit0; no Boolean domain, purpose or entry is established. The bounded dispatch table excludes these entries; an indexed FillBytes clear elsewhere includes both fields. Entry/purpose remain HYPOTHESIS. The second span now has the mechanical label `ReadC0F9_Xor1`; no emitted byte changes. See [split-return note](docs/research/naming_73_6143_split_returns.md) and [verification limits](docs/research/naming_73_verify_6143_split_returns.md).


## Original bank73 integration verified (2026-10-08)

Seven comments describe two independent6-byte/3-start fragments at73:6143 and6149. Each reads C0F8 or C0F9, performs XOR1 and returns without a store or bank selection. The RETs at6148/614E prevent ordinary fallthrough into614F; arbitrary byte inputs do not make XOR1 a general Boolean negation. Entry and purpose remain HYPOTHESIS; neutral symbols and all emitted bytes remain unchanged. Executor, independent reviewer and ROOT each completed a new canonical37:36rc0 plus expected ordinal27rc2 with its exact97-byte diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL; symbols and palettes pass, and all671 actual outputs equal the accepted private pass. Fresh published validation follows. ROOT guarded source hashes each command; no fresh native or actual English-owner closure is claimed.


### Static SRAM boundaries at 70:46A6

PROBABLE bounded mechanics: [70:46A6,4740) has three returning paths and [70:4740,477F) is now labelled `SaveCheck_GetStateBlockBit7`. Both save FFF5/FF8C, use FFF2 scratch and select SRAM1; no WRAM shadow access occurs. Shadow-based restoration and flags have path-specific stack/bank prerequisites. Tested field purpose, entry and natural reachability remain HYPOTHESIS; the name describes the bounded bit-read operation, not proven entry. See [boundary note](docs/research/naming_70_46a6_sram_boundaries.md) and [verification limits](docs/research/naming_70_verify_46a6_sram_boundaries.md).


## Original bank70 integration verified (2026-10-08)

Twenty-five comments qualify the217-byte/107-start region at70:46A6 and the unlabelled segment at4740. It saves the FFF5/FF8C SRAM shadows and uses FFF2 as scratch, with no WRAM selector. The three first-region RETs and final477E RET delimit ordinary paths. Random16/division produce bounded2..4 or0A..0F values without a probability claim; hardware restoration depends on coherent shadows and a stable stack. Entry and purpose remain HYPOTHESIS; neutral symbols and all emitted bytes remain unchanged. Executor, independent reviewer and ROOT each completed a new canonical37:36rc0 plus expected ordinal27rc2 with its exact97-byte diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL; symbols and palettes pass, and all671 actual outputs equal the accepted private pass. Fresh published validation follows. ROOT guarded source hashes each command; no fresh native or actual English-owner closure is claimed.


### Static return boundaries at 75:7E89

PROBABLE43-byte/27-start sequence returns at7EAD/7EB3 rather than falling into7EB4. Saved oldC6C1 byte/flags and same-bank75:5F10 call require balanced stack, stable bank and ordinary callee return; pointer arithmetic wraps, no success/ABI/domain guarantee. Entry/purpose HYPOTHESIS. See [boundary note](docs/research/naming_75_7e89_return_boundaries.md) and [verification limits](docs/research/naming_75_verify_7e89_return_boundaries.md).


## Original bank75 integration verified (2026-10-08)

Four comments qualify the43-byte/27-start fragment at75:7E89. Its command byte is read from(P+2)mod65536 and XOR80 toggles bit7, rather than guaranteeing that bit is set. RET Z7EAD and RET7EB3 end ordinary paths before7EB4. The same-bank packet-send callee can loop or change fields; POP AF discards its carry result, and later local bit0 handling does not restore the entire saved flags byte. No unconditional completion, preservation or caller ABI is claimed. Entry and purpose remain HYPOTHESIS; neutral symbols and all emitted bytes remain unchanged. Executor, independent reviewer and ROOT each completed a new canonical37:36rc0 plus expected ordinal27rc2 with its exact97-byte diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL; symbols and palettes pass, and all671 actual outputs equal the accepted private pass. Fresh published validation follows. ROOT guarded source hashes each command; no fresh native or actual English-owner closure is claimed.

### Prospective ORIGINAL bank54 entry limits

A bounded prospective proposal preserves Function_54_41C5 and corrects six header comment rows: the ordinary entry54:41C5-41D4 ends at its firstRET after seven instructions/15 original-ROM bytes; the following poll is separate. Body PROBABLE; entry/purpose HYPOTHESIS. Analysis and prepared verification: docs/research/typing_54_41c5_entry_limits.md and docs/research/typing_54_verify_41c5_entry_limits.md. No runtime/build/publication or queue-completion claim is added.


## Original bank54 integration verified (2026-10-08)

The bounded bank54:41C5 fragment has seven instruction starts and15 bytes through RET41D3. It initializes C1DB=3, C1D8=1 and C1D9=0; the polling body at41D4 is outside that bounded path. Local return and register effects assume a valid nonaliasing stack and no intervening interrupt. Entry and purpose remain HYPOTHESIS; neutral symbols and all emitted bytes remain unchanged. Executor, independent reviewer and ROOT each completed a new canonical37:36rc0 plus expected ordinal27rc2 with its exact97-byte diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL; symbols and palettes pass, and all671 actual outputs equal the accepted private pass. Fresh published validation follows. ROOT guarded source hashes each command; no fresh native or actual English-owner closure is claimed.


### Bounded neutral entries after54: banks27,2E,29

Entry/purpose remain HYPOTHESIS. Bank27 full prefix ends in WRAM7 via00:082C; direct4EEB tail only LCDOn/BC0/RET. Bank2E15-byte candidate preserves18F0 toRET4F99, a one-step path rather than its looping siblings. Bank29 leaves separate LCDC.bit2 and conditional LY waits from the742-byte library/mapper/padding limits. No aliases or emitted changes; historical natural data and missing19 graphs do not establish unreachability.

- [typing_27_palette_map_tail](docs/research/typing_27_palette_map_tail.md)
- [typing_27_verify_palette_map_tail](docs/research/typing_27_verify_palette_map_tail.md)
- [typing_2e_wait_glyph_tail](docs/research/typing_2e_wait_glyph_tail.md)
- [typing_2e_verify_wait_glyph_tail](docs/research/typing_2e_verify_wait_glyph_tail.md)
- [typing_29_leaf_lcdc_ly_limits](docs/research/typing_29_leaf_lcdc_ly_limits.md)
- [typing_29_verify_leaf_lcdc_ly_limits](docs/research/typing_29_verify_leaf_lcdc_ly_limits.md)


## Original bank27/2E/29 integration verified (2026-10-08)

Twenty-two comments qualify six bounded entries without changing labels or emitted bytes. The bank27 prefix temporarily restores the saved WRAM shadow before Gfx_UploadBgMapBuffers selects WRAM7; direct4EEB enters only the LCDOn/BC0/RET tail. Bank2E4EB2 makes60 calls conditional on ordinary helper returns, with no universal60-frame duration;4F9A decrements once and its18F0 branch reaches the preceding RET. Bank29 clears LCDC.bit2 at5090 and calls selected-bank7BB7 before potentially unbounded LY polling at511E. Physicalbank29 padding is distinct from7D Joypad_Update. Stack, mapping, IRQ, callee and buffer prerequisites remain qualified; purpose and unproved entries remain HYPOTHESIS. Executor, independent reviewer and ROOT each ran one new canonical37:36rc0 plus expected ordinal27rc2/exact97-byte diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL; symbols/palettes pass and all671 actual outputs equal the accepted private version. Source hashes were held for every ROOT command; no fresh native or actual English-owner per-command closure, new runtime, visual or hardware evidence is claimed. Fresh publication validation follows.


### Remaining neutral headers: bounded effects without aliases

All28 neutral-only groups remain KEEP. Five owners gain15 bounded comment rows for audio offsets, WRAM6 static copies, the full2B687C family, explicit4E6172 SRAM1 and hypothetical55interior5F2A. Entry/purpose and stack/mapping/IRQ remain qualified; no natural/forced or absent-entry promotion. See [bounded mechanics](docs/research/typing_neutral_remaining_headers.md) and [verification limits](docs/research/typing_neutral_verify_remaining_headers.md).


## Original remaining neutral headers integration verified (2026-10-08)

Five source owners receive fifteen bounded comments: twelve existing comment rows and three explicit blank-to-comment rows. No emitted bytes, physical line counts, symbols or aliases change. Six spans contain258 bytes and109 CPU starts, separately from12 inline farcall bytes. Audio table471A/index25 points to49B6 and44AF/index6 to49CD; names remain neutral and driver-state prerequisites qualified. WRAM6 copies include terminating zeros. The2B687C family extends through RET6919, rather than ending at6909, and its predecessor is a table plus RET rather than a previous JR. Routine4E6172 explicitly selects SRAM1 and disables RAMG on ordinary exit without restoring prior configuration. The hypothetical keyboard interior5F2A skips the XOR; no observed entry is claimed. All28 neutral-only groups remain KEEP and are not a completion or reachability measure. The old local2B case headers retain inherited141-byte prefix metadata; the corrected complete158-byte family boundary above and research note qualify them. Executor, independent reviewer and ROOT each ran one new canonical37:36rc0 plus expected ordinal27rc2/exact97-byte diagnostic. ROOT make reports SHA-256 OK/RESULT: IDENTICAL, symbols and palettes pass, and all671 outputs equal EX and the coherent parent. ROOT source hashes held for each command. Independent raw/emitter proof preceded EX facts, but a candidate note exposed an EX summary after independent ordinal25 before terminal; the remaining fixed protocol, source and expectations stayed unchanged. No blind review, full result isolation, fresh native or English-owner closure, new natural execution, visual or hardware proof is claimed. Fresh publication verification follows.


### Asset catalogue and layout audit (2026-10-08)

The current947 active assets reemit607576 original-ROM bytes. All405 tile-sheet and38 font-span PNG rules reproduce their bytes; the92 declared screen views reproduce their indices/resolved counts and final known palette colours. This verifies the declared models, not natural execution or whole-ROM semantic resource completeness. The88 tilemaps without screen views include11 bank41–46 cases (eight belowhalf coverage andthree fragmented bank42 sources) plus two separate bank47 cases.

Twenty-five Shift-JIS names in53:4000 and24 physical record windows41–46 do not imply a missing25th image. A further graphic window47:68F0 already has an editable PNG; its visual identity remains unproved, and no species name is assigned. The27-style table points to bank47 descriptors, not the name table or the24 windows. Image/name order, computed readers and natural reachability remain unproved. The24 existing preview metadata rows have no matching capture, and their loaded pixels agree with the explicit model chosen by coverage; accidental capture selection is not supported for those rows.

See [catalogue/layout methods](docs/research/assets_original_catalogue_and_layout_audit.md) and [Pokémon frame/name limits](docs/research/assets_pokemon_frames_and_name_limits.md). No assets, rules, tools, assembly, frozen classification or new runtime/build evidence changes in this documentation pass.


### Settings menu highlight record format

Three existing headers correct BC=$020A at68:5270 and the farcall site68:5285, separating the bank load at5283. The five words68:528C–5296 address five40-byte bank4A records:20 tile numbers (2×10) followed by20 attributes$0A. The first160 bytes remain CONFIRMED read data and the final40 remain PROBABLE; no aliases or emitted bytes change. Historical natural69 READ intervals are finite and do not promote the tail or prove per-call/visual behavior. Cursor bounds, stack/bank/IRQ and ordinary helper returns remain qualified. See [bounded format facts](docs/research/settings_menu_highlight_pair_records.md) and [prepared verification](docs/research/settings_menu_highlight_pair_records_verification.md). New private gates, independent review and integration remain pending.


## Current private settings highlight validation

One newly authorized private canonical37 completed36 rc0 results and the expected ordinal27 rc2 with its exact97-byte historical schema diagnostic. Make reports SHA-256 OK and compare reports RESULT: IDENTICAL. All671 freshly measured output sizes/SHA values, whole SYM/MAP and original ROM bytes equal the guarded parent88 fresh envelope;15538 labels and51 constants remain unchanged. D334 contains10912 unchanged rules and5623 current dependency bindings; only the two comment-owner source hashes change, with explicit published198cdf BEFORE and current4224 AFTER bindings. All4224 frozen source guards plus two original references held before and after every command. This four-document result appendix is appended only after the completed pipeline, with no build replay or emitted changes. Independent verification, ROOT adoption, actual integration and publication remain pending; no new natural/native/visual/hardware evidence or fresh native closure is claimed.


## ROOT original integration verification (2026-10-08)

ROOT adopted the qualified executor and independent reviews and ran one actual canonical 37-check pipeline: 36 zero return codes and the expected ordinal 27 return code 2 with its exact 97-byte schema diagnostic. All 4,224 source hashes held before and after each command; all 671 output hashes equal both private builds and the original parent fresh build. The ROM is byte-identical to the original, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Symbols retain 15,538 labels and 51 constants; palettes pass. ROOT performed a programmatic whole-byte scan of all logs and exact diagnostic/hash checks; this is not a blind or human full-log-read claim. ResourceWarning diagnostics are retained in the receipts, not described as warning-free results.

This four-document result appendix was added after the successful checks; only documentation changes and the successful pipeline is not replayed. The two source owners retain all emitted lines, labels and physical line counts. Tail-record use remains PROBABLE, and no new natural-menu, visual or hardware evidence is claimed. Publication and fresh reconstruction are subsequent stages.


## Residual local cases at 2B:687C — bounded comment correction

Seven existing comment rows now use the full returning `[687C,691A)` family and finite348-file named-reference qualification. Own raw reencoding covers158 bytes/60 CPU starts plus the preceding12-word table and RET687B; the four farcall operands remain inline data. Historical141-byte prefix metadata and complete-family notes stay intact. Entry/purpose remain HYPOTHESIS, with no alias, LOC, level or emitted change. See [the bounded note](docs/research/typing_2b_687c_residual_localcase_bounds.md). This private scope awaits ROOT review and a separately authorized new verification; no build or publication result is asserted.


## Current private local-case validation

One newly authorized private canonical 37-command pipeline completed: 36 return codes 0 and the expected ordinal 27 return code 2 with the exact 97-byte historical schema diagnostic. Make reports SHA-256 OK; compare reports RESULT: IDENTICAL. All 671 output files match the published 7986 fresh parent in whole bytes, sizes and SHA-256, including the original ROM, SYM and MAP. The symbol table retains 15,538 labels and 51 constants. D334 retains 10,912 raw rules and 5,623 bindings; current source/dependency hashes rebind only engine/mail/mail_viewer_sender.asm, with explicit published SOURCE4224 BEFORE and tested SOURCE4225 AFTER phases. All 4,225 frozen source guards, two original references and the six resolved executable guards held before and after every command. This is an executable inventory, not a full native/library closure or new native capture. Whole logs and diagnostic/warning lines are preserved; success is not described as warning-free.

These three documentation result appends follow the completed terminal and output measurements; no command is replayed and all 671 outputs remain unchanged. The seven ASM comment changes retain all emitted lines, physical positions, labels and evidence levels. Independent verification, ROOT adoption, actual integration and publication remain pending. No new natural-menu, graph capture, purpose proof or hardware evidence is claimed.


## ROOT local2B original integration verification (2026-10-08)

ROOT adopted the qualified executor and independent reviews and ran one actual canonical 37-check pipeline: 36 zero return codes and the expected ordinal 27 return code 2 with its exact 97-byte schema diagnostic. All 4,225 source hashes held before and after each command; all 671 output hashes equal both private builds and the original parent fresh build. The ROM is byte-identical to the original, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Symbols retain 15,538 labels and 51 constants; palettes pass. ROOT performed a programmatic whole-byte scan of all logs and exact diagnostic/hash checks; this is not a blind or human full-log-read claim. ResourceWarning diagnostics are retained in the receipts, not described as warning-free results.

This three-document result appendix was added after the successful checks; only documentation changes and the successful pipeline is not replayed. The single source owner retains all emitted lines, labels, levels and physical line counts. The complete family ends at691A; entry and purpose remain HYPOTHESIS, and no new natural-menu, visual or hardware evidence is claimed. Publication and fresh reconstruction are subsequent stages.


## Current archival callgraph candidate — 69 natural graphs

The private DOC_EVIDENCE22 candidate on published 8eab restores 19 guarded historical lite callgraphs (1,774,403 bytes / 61,742 data rows) alongside the 50 unchanged published graphs (80,700 rows): 69 natural graphs / 142,442 scenario-aggregate rows. Natural coverage and dataaccess remain 69 each; three forced graphs stay separate. The restored 19 contain no entry target for the 28 current neutral-only groups, a finite result with no unreachable/caller-completeness or semantic promotion claim. Dated 50-graph notes remain history. See [archive provenance and consumer limits](docs/research/historical_lite_callgraph_archive_adoption.md). Current tools and code are unchanged; mapper and trace driver are outside the finite canonical-37 closure and were not run. The 671 fresh-parent outputs are preserved, with no new gates or capture. ROOT/independent frozen review, integration and publication of this archival candidate remain pending.


## ROOT archival adoption verification (2026-10-08)

ROOT and the independent reviewer accepted the frozen 22-path archival scope on published/fresh `8eab941`. The actual tree now contains 69 natural callgraphs (142,442 scenario-aggregate rows); all 19 restored files reproduce the guarded historical bytes. All 4,223 parent files outside the two documentation appendices remain byte-identical, and all 671 verified parent outputs remain byte-identical. The source inventory is 4,245 paths. Code, metadata, tools, assets, config, scenarios, the old 50 graphs and natural coverage/dataaccess are preserved. ROOT checked all current source/payload/output hashes and the qualified independent review; these are static preservation checks, not a new build, ROM execution or blind/human full-log review.

No canonical37, mapper, generator or trace capture was replayed. The closed parent reconstruction and finite dependency audit justify carrying forward the unchanged emitted-output proof for this archival-only change. The separate mapper consumer and destructive lite-republication risk remain documented above. Restored19 zero targets for28 neutral-only groups establish only that bounded result; no semantic level, unreachable claim, names/frame mapping or hardware evidence changes. Earlier private/pending wording remains chronological history. Publication and post-publication Git-blob preservation checks follow this adoption.


## Private computed attribute lookup correction at 4E:6543

The focused [lookup bounds note](docs/research/frame_4e_computed_attribute_lookup_bounds.md) records the eight-byte table and the computed reader at 4E:6486-649D. One existing HYPOTHESIS comment is replaced; the 571-line owner, all emitted source positions, labels and levels remain intact. The separate ADD $43 / ADC $65 address construction does not refute a bounded absence of a literal16-bit $6543 operand. All256 conditional arithmetic cases agree with the guarded bytes. The natural69 aggregates do not cover the body or READ the table within this finite corpus; no universal reader/entry absence, PNG/name mapping or new runtime evidence follows. Source4246/scope4 is a private candidate; new gates, ROOT adoption and publication remain pending.


## Current private computed lookup validation

One newly authorized private canonical 37-command pipeline completed: 36 return codes 0 and the expected ordinal 27 return code 2 with the exact 97-byte historical schema diagnostic. Make reports SHA-256 OK; compare reports RESULT: IDENTICAL. All 671 output files equal the original 8eab fresh parent in whole bytes, sizes and SHA-256, including ROM, SYM and MAP. The source-only archival successor fe5238f carried that closed output proof; it did not build a new ROM. Symbols retain 15,538 labels and 51 constants. D334 retains 10,912 raw rules and 5,623 bindings; current source/dependency hashes rebind only engine/browser/frame_graphics.asm, with explicit published SOURCE4245 BEFORE and tested SOURCE4246 AFTER phases. All 4,246 frozen source guards, two original references and the six resolved executable guards held before and after every command. This is an executable inventory, not a full native/library closure or new native capture. Whole logs and diagnostic/warning lines are preserved; success is not described as warning-free.

These three documentation result appends follow the completed terminal and output measurements; no command is replayed and all 671 outputs remain unchanged. The one existing ASM comment retains 571 LOC, every significant source position, labels and evidence levels. Literal 16-bit operand absence is not refuted by the computed 8-bit address construction. The corpus 69 result remains finite and the arithmetic cases remain static. Independent verification, ROOT adoption, actual integration and publication remain pending; no new natural/forced, PNG/name mapping, purpose or hardware proof is claimed.


## ROOT computed frame lookup integration verification (2026-10-08)

ROOT adopted the qualified executor and independent reviews and ran one actual canonical 37-check pipeline: 36 zero return codes and the expected ordinal 27 return code 2 with its exact 97-byte schema diagnostic. All 4,246 source hashes held before and after each command; all 671 output hashes equal both private builds and the original parent fresh build. The ROM is byte-identical to the original, SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Symbols retain 15,538 labels and 51 constants; palettes pass. ROOT performed programmatic whole-byte log scans and exact diagnostic/hash checks, without claiming blind review or human full-log reading. ResourceWarning diagnostics remain preserved.

The independent reviewer preserved an initial ordinal1 protocol failure: its child return code was not persisted before an overly strict modification-time check rejected 18 byte-identical regenerated binaries. A corrected V2 runner persisted return codes before post-command guards and treated modification times as observations. The authorized V2 repeated ordinal1 to recover that unvalidated check; ordinals2–37 ran for the first time. Its completed profile is 36 zero codes plus ordinal27 code2/exact97. This is not a global no-replay or unique37 claim; source bytes, sizes, modes and link counts, two references and six executable guards held. The original incident remains part of the evidence.

Three documentation appendices follow the successful ROOT checks without replay. The sole ASM edit is the existing physical line485 comment in the 571-line owner; instructions, data, labels and levels are preserved. A computed ADD $43 / ADC $65 reader does not refute the narrower absence of a literal 16-bit $6543 operand. Arithmetic256 cases and natural69 zero observations remain finite static/corpus results; reader purpose, names/frame association, unobserved entry, natural rendering and hardware remain unproved. Publication and fresh reconstruction follow.


Descriptor suffix qualification: the frame/name note now separates the direct6196–6291 first15-byte reads from called body/title/scrollbar helpers reading0F/11/1B/1D. Preview6291–6543 directly reads0F/11 in four phases with two selectors. This PROBABLE static derivation preserves descriptor1's separate CONFIRMED natural-read evidence and all sibling/asset statuses. MAIN placement and PREVIEW pair images remain conditional fixtures, with full helper map/canvas mutations outside their scope; record47:68F0 still has no descriptor-table selection, species assignment or new natural-reachability proof.

Verification, 2026-10-11: the private candidate and the actual MAIN checkout each completed the canonical37 profile (36 checks rc0; the documented ordinal27 negative case rc2 with its exact97-byte diagnostic). All4246 source files held during each run, and all671 build outputs matched the newly reconstructed d6a01a0 baseline byte for byte. `make` reported SHA-256 OK / RESULT: IDENTICAL; symbol and palette checks passed. This pass changes documentation only. No new runtime capture, species association, natural-reachability or hardware claim is made.


Sibling descriptor representation: four PROBABLE 31-byte units at 4E:6581/65BF/65DE/65FD use the existing dw/db layout of descriptor 1, retaining all 124 scoped bytes, headers and aliases. The owner grows 571→635 lines; the active manual/overlay locator census requires no metadata rebinding. New parent-relative ROM/SYM/MAP, relocation and canonical37 gates remain pending.

The same frame/name note records a bounded 25-window asset audit: 39 tile PNG reemissions, all maps/attributes/palettes exact, 14 complete editing views and 11 missing views (8 partial, 3 additional bank-42 fragmented cases). The catalog/source gaps and legacy-preview omission do not establish missing ROM artwork or species associations.

### Typed frame descriptors and bounded asset audit: ROOT integration

Four existing PROBABLE 31-byte descriptors at 4E:6581, 65BF, 65DE and 65FD now use explicit far pointers, WRAM7 destinations and coordinate pairs. Their 124 original bytes are unchanged. The complete owner grows from 571 to 635 physical lines; active metadata locators precede the changed rows and require no rebind. Neutral aliases, headers, instruction bytes, the 27-word descriptor table and the existing CONFIRMED descriptor remain unchanged. The asset/name audit above distinguishes complete raw assets from partial composition models and missing editing views; no name-to-frame association or reachability conclusion is added.

One private staged canonical37 and one ROOT actual canonical37 each close with 36 rc0 results and the historical ordinal27 rc2/exact97-byte diagnostic. Make reports SHA-256 OK and RESULT: IDENTICAL; symbol and palette checks pass. All 671 ROOT outputs equal the measured private candidate; 670 are identical to the freshly verified parent0eeb, with only the owner object changed. Independent RGB9 decoding explains its 20 word and 20 bank relocations, recovering the full parent section after resolution. ROM, SYM and MAP are byte-identical to the parent; 15,538 labels and 51 constants remain. The private logs contain 444 ResourceWarning occurrences, which do not change the expected return codes; no warning-free claim is made. These documentation appends follow the completed ROOT terminal without replaying checks. Publication and fresh verification follow; no new natural, visual, species or hardware evidence is claimed.

### Ordinal bank-53 pointers: representation prepared

The existing bank-53 name table uses 25 ordinal labels and symbolic word pointers, preserving its 50 pointer bytes and 319 Shift-JIS string bytes. The two original aliases and PROBABLE headers remain; the owner gains 25 physical lines and no emitted bytes. The ordinals name text-table entries, with no name-to-frame association or newly established reader. See [the bounded asset/name note](docs/research/assets_pokemon_frames_and_name_limits.md#ordinal-presentation-of-the-bank-53-name-table). Active proof metadata requires no rebind in the finite audited scope. Executable validation is pending; the new SYM/MAP labels and owner relocations must be measured against the published typed-descriptor parent rather than assumed byte-identical.


### ROOT integration of bank53 ordinal pointer labels (2026-10-11)

The original bank53 name table now uses25 ordinal PokemonName00..24 aliases and symbolic word pointers. Existing aliases, the319-byte Shift-JIS/NUL text block, table order and all369 bytes remain unchanged; source classifications remain PROBABLE. A reader or a name-to-frame association has not been established. One private staged canonical37 and one ROOT actual canonical37 each completed with36 rc0 results plus the documented ordinal27 rc2/exact97-byte diagnostic. The initial private post-check5 measurement assumed ascending object-patch serialization and failed; actual serialization is48 down to0. Its failed terminal was preserved, an independently reviewed DATA-only finalizer associated patches by their unique offsets, and the same37-check BEGIN resumed at6 without replaying versions or checks1–5. Independent complete RGB9 decoding verifies25 new exports,24 additional word relocations and all symbol/patch metadata, resolving the entire369-byte section to the original. All671 actual outputs equal the reviewed private candidate;668 equal MAIN454e0fe, while the owner object, SYM and MAP change only as measured. Removing the25 aliases from SYM/MAP recovers their literal parent files. Make reports SHA-256 OK and RESULT: IDENTICAL; symbol checking reports15563 labels and51 constants, and palette checking passes. The private43 logs contain444 ResourceWarning occurrences; expected check results are unchanged. These documentation appends follow the completed ROOT terminal without replay. Publication and fresh verification follow, without new natural-flow, LCDC, species, rendered or hardware evidence.

The finite unselected-frame audit distinguishes eleven missing editing views from exact preserved source bytes. The 24 existing legacy unused previews reproduce their declared browser-style pixel model; the separate window 47:68F0 has tilemap 47:72F0 and an existing editing PNG. These conditional models establish no additional original loader, species/name association or whole-ROM graphics completeness. See [the per-window view limits](docs/research/assets_pokemon_frames_and_name_limits.md#unselected-frame-windows-editing-views-and-legacy-models).

### Verified finite audit of unselected frame views (2026-10-11)

One private and one ROOT integration canonical37 each completed with36 zero return codes and the known ordinal27 rc2/exact97-byte diagnostic. All671 rebuilt outputs equal published MAINa4d374c, including every object, SYM, MAP and the original ROM; all4246 frozen sources remained as reviewed during testing. The private43 complete logs contain444 ResourceWarning occurrences; these warnings are recorded. Independent DATA decoder assertions about palette/attribute-map representation and an invented readonly-log mode were preserved and corrected before final receipts, without source changes or gate replay. This DOC3 pass records the eleven editing-view omissions,24 complete legacy pixel-model comparisons and the distinction between window47:68F0 and tilemap47:72F0. It adds no PNG, loader, LCDC, species/name association, natural-flow or hardware evidence. A separately reviewed future view can combine the four existing aligned assets of42:4D50; no ROM bytes are missing there.

The bank26 zero-tail follow-up now names the 16 bytes at 26:7AB0–7AC0 Profile_InitScreen_HDMALoadZeroTail: the 12 previously neutral bytes plus the following four zeros complete the aligned final transfer unit in the Profile_InitScreen request to VRAM0 $8290–$82A0. This establishes the transfer boundary, not tilemap selection or display; the old sprite-overread attribution remains qualified. See [the reader and boundary limits](docs/research/boot_and_home.md#historical-bank26-audit-the-twelve-zero-bytes-superseded-below).

### Conditional bank42 editing composition from existing assets

The `bank42/tilemap_5750` catalogue entry combines the four complete tile assets in42:4D50..5750 while preserving the old15 record rows and92 screen rows. Its360 cells resolve only under the documented unsigned/VRAM1/first32-palette-word model; it remains HYPOTHESIS. Physical asset bounds exclude the final sheet's nine padding tiles, and ten previous bank41–46 view omissions remain. No original loader, LCDC.bit4, species/name association or natural-flow evidence follows. See [the complete-asset composition and limits](docs/research/assets_pokemon_frames_and_name_limits.md#bank42-conditional-composition-from-four-complete-tile-assets).

### ROOT verification of the conditional bank42 editing view (2026-10-11)

The scope7 pass adds one conditional indexed editing PNG and a complete-asset fallback in screen_png.py. Private and ROOT canonical37 completed36rc0 plus ordinal27rc2/exact97; make reports SHA-256 OK and RESULT: IDENTICAL, and all671 outputs equal published b833350. The candidate4247 sources held during verification. All92 prior screen rows and947 asset rows remain unchanged; the new row makes93, with20 PROBABLE and73 HYPOTHESIS views. The finite model and recorded warnings retain the [reader and rendering limits](docs/research/assets_pokemon_frames_and_name_limits.md#verified-conditional-bank42-editing-view-2026-10-11).

### Located bank6C help-script lookup and reader

The primary reader at6C:60AF maps A0..FF through the192-byte HelpScript_SingleByteToSjis table to96 big-endian numeric glyph codes;80..9F consume a second byte, and bytes below80 enter the control dispatcher. The bounded numeric mapping is CONFIRMED; the65-entry historical stream corpus and the13-byte mixed prefix before the lookup retain their existing classifications and unresolved semantics. The bank48 font-run selection supplies original16-byte source ranges for94 nonzero codes; the two zero codes reach a sentinel without a glyph copy. This establishes source selection, without a new natural glyph, rendering, timing or hardware result. See [the located reader and limits](docs/research/text_encoding.md#6-help-script-text-convention-bank-6c).

### Verified original bank6C reader integration (2026-10-11)

The five-file pass replaces one literal lookup operand with the existing HelpScript_SingleByteToSjis symbol and corrects bounded reader/table comments. Private and ROOT canonical checks each completed 36 zero returns plus ordinal 27 with the expected return 2 and exact 97-byte diagnostic. ROOT make reports SHA-256 OK and RESULT: IDENTICAL; symbol and palette checks pass. All 670 other outputs equal the published 12bd70d parent. The sole changed engine object adds one import and one word relocation; independent complete RGB9 parsing, unchanged old normalized expressions and bindings, linked SYM/MAP addresses, raw section restoration and whole-ROM comparison preserve the 2116-byte section. This is not a fresh numerical evaluation of all 262 old expressions. Both canonical runs recorded 444 ResourceWarnings; the verification does not promote historical streams, natural invocation, rendering or hardware evidence.

### Located bank72 dialog lists and record reader

Static source and original-byte comparison establish four lists with69 references to68 distinct bank72 records. Dialog_Open at72:402A selects a list with D and a record with E; it skips the first header byte, uses the second for layout and dialog type, and initializes the result from the third. The separate byte$AF at63D7 remains HYPOTHESIS/unclassified. TextTiles_RenderLine at48:403E consumes paired bytes and stops on NUL; the records have32 text bytes per line, without a newly established reader clamp. The finite69 historical trace sets cover list/record reads in39 scenarios, without proving all records rendered, general index bounds, natural-menu behavior or hardware execution. See [the located record reader and remaining limits](docs/research/text_encoding.md#41-message-records-in-bank-72-located-list-and-record-reader).

### Verified original bank72 dialog-reader documentation (2026-10-11)

The three-document pass locates the list and record readers and replaces stale header and glyph-mapping descriptions. Private and ROOT canonical checks each completed 36 zero returns plus ordinal 27 with the expected return 2 and exact 97-byte diagnostic. All 671 build outputs equal the published 4ec9ad3 parent, including every object, dependency file, SYM, MAP and original ROM. ROOT make reports SHA-256 OK and RESULT: IDENTICAL; symbol and palette checks pass. Both canonical runs recorded 444 ResourceWarnings. This documentation and static-byte verification does not establish general index bounds, complete record execution, rendered glyphs, natural-menu behavior or hardware execution.

FFA7 producer audit: six maintained source producers explicitly store zero; 51:41D3 stores returned A. Its two ordinary source routes yield A=0 under coherent stack/mapping and uninterrupted shared scratch. Interior/computed entries, malformed state and IRQ/reentrancy are outside this bounded static proof. The current hJoyDispatchExtraMask alias describes the one-shot OR/clear consumer, without a physical or injected-button interpretation. See docs/research/ram_map.md and docs/research/boot_and_home.md; no new natural execution or hardware evidence is added.

### Verified bounded FFA7 producer correction (2026-10-11)

The five-file pass qualifies the returned-A producer and the existing one-shot OR/clear consumer, preserving the physical lines of home/jump_table.asm. Private and ROOT canonical checks each completed 36 zero returns plus ordinal 27 with the expected return 2 and exact 97-byte diagnostic. All 671 build outputs equal the published 87b0753 parent, including the home object, every dependency file, SYM, MAP and original ROM. ROOT make reports SHA-256 OK and RESULT: IDENTICAL; symbol and palette checks pass. Both canonical runs recorded 444 ResourceWarnings. The two ordinary source routes conditionally yield A=0 under the recorded stack/mapping/shared-scratch prerequisites; this does not establish universal zero writes, a physical or injected-button purpose, new natural execution or hardware behavior.

## Current neutral ledger hygiene (2026-10-11)

The current maintained source and linked symbol census identify28 global neutral-only Function/Label ROM address groups (23/5 in18 banks), separately from15 neutral instruction names/18 operands (14 KEEP plus one PARTIAL_ALIAS). The former27 counter subtracted the already-existing26:5106 alias twice. The initial65-row worklist now records the published MailSession_CompareWordDeltas alias as APPLIED_ALIAS while preserving its old one-site count, historical KEEP reasoning and legacy HYPOTHESIS row status. Source naming remains PROBABLE; unknown field meaning and the unobserved equality path remain open. The separate structured-data row for `Data_6A_72A0` is now APPLIED; the redundant export was retired without changing the established table label or bytes. The28-group count is neither a reachability nor semantic-completion metric. See docs/research/naming2_neutral_code.md; historical pass results and published FFA7 appendices remain intact.

### Verified current neutral ledger reconciliation (2026-10-11)

The five-file ledger pass corrects the current counters and records the already-published PROBABLE MailSession_CompareWordDeltas alias as APPLIED_ALIAS, retaining the initial site count, historical KEEP reasoning and legacy HYPOTHESIS row status. The initial65-row ledger has47 APPLIED,14 KEEP,two APPLIED_ALIAS,one PARTIAL_ALIAS and one PENDING; the separate current instruction cohort is15 names/18 operands. The28 global neutral-only groups remain23 Function plus five Label groups in18 banks. Private and ROOT canonical37 each complete36 zero returns and the expected ordinal27 return2/exact97-byte diagnostic, with444 ResourceWarnings. All671 build outputs equal published0d713c7, including everyOBJ/D/SYM/MAP and the original ROM; make reports SHA-256 OK and RESULT: IDENTICAL, with passing symbol and palette checks. No ASM, alias, confidence, new runtime observation, asset or name/frame association changes. The pending6A structured macro and separate73 unit remain subsequent work.

At that 2026-10-11 checkpoint, the mechanical `SpriteFrameTable_6A_72A0` alias reused blank line52 while preserving the generic `Data_6A_72A0` label. The later retirement of that redundant export is documented below; the 75-line historical owner layout, emitted macros and storage confidence were preserved throughout. See docs/research/naming2_neutral_help.md; no visual-purpose or completeness claim follows.

### Verified mechanical 6A frame-table alias (2026-10-11)

The five-file pass adds `SpriteFrameTable_6A_72A0` in the former blank line 52 and updates the sole object-entry operand at line 75. `Data_6A_72A0` and every existing physical source position remain. Private and ROOT canonical37 each completed 36 zero returns and the expected ordinal27 return2 with its exact97-byte diagnostic; each recorded444 ResourceWarnings. All668 unaffected build outputs equal published parent `457244b`; the owner OBJ, SYM and MAP match the independently measured private candidate. Full RGB9 inspection preserves all68 nodes,1993 existing symbol records, the2985 raw section bytes and all four word-patch metadata records, adding one exported alias and changing only the offset2981 symbolic target. Fresh numeric resolution of all four words in both objects reproduces the complete original2985-byte section. Removing the single added alias line from SYM and MAP restores the parent bytes. The linked ROM remains original SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; make reports SHA-256 OK and RESULT: IDENTICAL, with symbol and palette checks passing. Ledger dispositions become47 APPLIED,14 KEEP,three APPLIED_ALIAS,one PARTIAL_ALIAS and zero PENDING, with historical HYPOTHESIS row status and CONFIRMED storage evidence retained. No new natural execution, visual identity, hardware or semantic-completion claim is made.


The bounded loader10/bank42 audit in docs/research/assets_pokemon_frames_and_name_limits.md separates four results: the valid27-entry descriptor table selects only three bank47 families; direct LCDC transforms preserve bit4 and boot83 establishes signed mode only along a qualified reaching path; twenty hypothetical canvas subsets refine transfer-prefix unknown-cell counts without rendering a procedure; and all13632 bank42 source bytes, including2496 bytes outside the asset catalogue, are present and exact. All30 emitted bank42 assets are catalogued, while raw/zero fragments, two-byte tile-grid offsets and PNG padding explain the remaining editing boundaries. Ten editing views, complete selector/vector/LCDC provenance and name/frame/species associations remain open. No new source classification, runtime evidence or asset is added.

The separate73:5E60 mechanical frame-table alias retains the existing Data alias,230 physical owner lines, literal first-chain frame/script pointers and all existing bytes/classifications. It does not change the initial65-row naming ledger or add natural-flow, visual or species evidence.


### Product-checked conditional RAW editing views and private native parity (2026-10-13)

The private original-source extension based on published MAIN `2e0f3fff688f70a48063ff72be496d570574fa51` adds conditional editing PNGs for 42:4000 and 42:67F0. Each resolves all 360 cells under the explicit unsigned/VRAM1/first32-palette-word HYPOTHESIS model. Four raw/HYPOTHESIS backings preserve exactly 80 original bytes, including the 16 `$FF` bytes at 42:69A0; original labels, headers and boundaries remain. The catalogue has 951 assets and 95 screens, preserving the prior 947 asset rows and 93 screen rows. Eight of the earlier ten editing-view omissions remain open.

One ROOT product-fixture run completed 21 PASS groups and 145 route receipts; group15 was then `DEFERRED_ROOT_NATIVE`. The product codec performed 20,480 inverses, both exports/imports preserved 46,080 indices, and 93 legacy screen roundtrips plus 947 asset identities held. Synthetic flip/UID/identity hooks retain fixture-only qualification. ROOT's two final private-source PNGs equal those accepted fixture bytes. Native parity was pending at that initial product stage. After `tools/line_addresses.py` copied `raw_png.py` into marked-build fixtures, the corrected private 27-path source completed its own Japanese37 plus English3 pass: 39 rc0 and the expected ordinal27 rc2/exact97-byte diagnostic, preserving original-ROM identity and the English ROM/checksum. The subsequent final documentation/manifest refresh still requires actual integration checks. See [the bounded inventory and RAW view limits](docs/research/assets_pokemon_frames_and_name_limits.md#product-checked-conditional-bank42-raw-byte-views-private-staging-2026-10-13). No source confidence, natural loader/LCDC/species association, general graphics completeness or hardware claim is promoted.

Published MAIN `2e0f3fff688f70a48063ff72be496d570574fa51` already provides `make english` with 563 explicit overrides and verified English ROM `1f1c28855ef560e9da4b2f2a3d4d8d9fc74162dff51381f9efc562025c9023a1`/E0FC. Its actual Japanese37 plus English3 terminal completed 39 zero returns and the expected ordinal27 rc2/exact97-byte diagnostic, with original-ROM identity; those receipts remain tied to the published parent. A separate fresh8 profile also completed eight rc0 with original and English ROM identities and zero warnings; it does not repeat the full canonical37 or validate the staged RAW source. The staged shared-source parity refresh retains every override/payload and historical base identifier, adds 11 fallbacks for the RAW resources/codec/two PNGs, and refreshes existing source/documentation pins. The corrected private candidate reproduced that English ROM; its private acceptance is recorded in the current language-build note, and does not certify subsequent documentation/manifest bytes or publication. ZIP reuse, full WholeHelp, English natural execution/rendering/fidelity and hardware remain qualified in [the current language-build note](docs/LANGUAGE_BUILDS.md).

### Errata operacional de replay: CTX17 (2026-10-17)

A identidade de ROM publicada em72a3464b continua a evidência de reconstrução
aceita naquela rodada; ela não detecta contexto quebrado em metadados de replay.
O passe Function516 introduziu13 divergências de contexto de lib/mobile/mail.asm:
ramop10 linhas3592,3973,3641,4228,4271,4353,4811,4869; ramop11 linhas4004,4047,
4408,4753,4926. BEFORE516 tinha Function_0F_*:: imediatamente antes do ld e ctx
correspondente. SOURCE516 retirou essas definições preservando a linha física
vazia, mas ctx passou à properalias duas linhas acima. Não eram dívida do parent516.
O predicado loose normaliza os operandos de memória antigos/atuais; esse detalhe
não elimina a divergência real do primeiro componente de contexto.

PRIVATE38 reteve292 already/8 skipped e133 already/5 skipped em29/30. Audio9
acrescentou quatro divergências em audio/engine.asm:807: PRIVATE31 v1 relatou
288 already/12 skipped e133 already/5 skipped. CTX12 anterior é parcial e fica
preservado; CTX17 propõe17 células de ctx:13LIB+4Audio, só o primeiro componente
passa a vazio. File/line/proof/status/operand/valor/banco/proposed text e os demais
componentes não mudam. Nenhuma fonte ASM ou ferramenta é alterada.

A auditoria estática finita cobre todas as tabelas9/10/11:156+300+138=594 manual
(637rows totais), um ctx manual opcional vazio em ramop10 preservado. O cálculo
usa exatamente split('\n'), incluindo a linha vazia de EOF: os quatro aparentes
casos NOTICE causados por splitlines não são reparos e permanecem intactos.
Previsão para28/29/30:0 to-write,156/300/138 already,0 skipped. A nova bateria
ROOT deve exigir os três logs literais; RC0 sozinho não certifica replay completo.
Mapas/SYM, ASM/OBJ e bytes previstos de31 não recebem delta por este reparo de
metadados. Artefatos/aceites v1 permanecem evidência finita do protocolo anterior;
sem adoção MAIN nessa versão. English e evidência natural/hardware não avançam.


The AdapterCheck and phone-entry graphics owner has a descriptive Bank 4A path, with 26 resource files moved under the consumer-specific directory. The resource payloads, including the ten existing PNG views and two inactive legacy byte-views, are retained byte for byte. The mixed `$9400` upload keeps its tile-prefix qualifier; `Data_4A_6480` is retired as a redundant alias while `Gfx_AdapterCheck_Tiles9400Vb1` remains the catalog label. This source unit changes 27 paths and 72 metadata cells, predicts one fewer symbol, and preserves the existing confidence and rendering limits. It was integrated in `c19640fffee619846994b1d49a4a8df26ef39882`; the preserved ACTUAL and FRESH receipts each report 38 accepted checks, and both rebuilds match the original ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. The receipts are under `.tmp/jp-settings4a-path72-native-integration-20261018/`; the root pass does not add runtime, natural-display or hardware evidence. See [the path contract](docs/research/adapter_check_and_phone_entry_4a_resource_paths.md). English remains suspended.


## Japanese global naming and asset audit (2026-10-20)

The source census at base commit `55fad258` covered 243 non-GFX assembly files:
it found no `Function_BB_AAAA` or `Font_BB_AAAA` definitions, but 1,893 generic
ROM labels (1,660 adjacent to semantic aliases and 233 without one) plus 583
`wRam_AAAA` definitions. In GFX, no owner or path component was a pure `bankNN`;
618 physical files had type-and-address basenames and 1,906 generic labels. The
ChoiceMenu pass below reduces those GFX counts to 610 paths and 1,902 labels.
These are census categories, not automatic rename requests: aliases, interior
data, and unknown regions require separate evidence.

The first reviewed GFX unit renames the four ChoiceMenu map/attribute pairs in
bank 4D to `settings_phone_choice_menu_entry0..3` paths, retains bank/address
provenance, and removes four redundant `Tilemap_4D_*` aliases. Each binary stays
70 bytes with its original hash. `make` returned `RESULT: IDENTICAL` for the
2-MiB ROM (SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`);
`make sym-check` passed with 14,713 labels and 51 constants; `make palette-check`
reported 162 loads, 116 arrays, two documented overreads and zero errors.

A later GFX cleanup in `gfx/mail_server/delete_progress.asm` retired 47
`Data_23_*` aliases while retaining their exact-address tile, map, frame and
animation-script names. `Data_23_7C03` remains because no descriptive co-alias
was found. The pre-edit source hash matched the pinned census input; no other
ASM/include consumers, tool/metadata mentions or local scopes were found for
the retired names. Independent review accepted the exact diff. `make` returned
`RESULT: IDENTICAL` against the original ROM; `make sym-check` reported 14,461
labels and 51 constants; `make palette-check` reported 162 loads, 116 arrays,
two documented over-reads and zero errors. No graphics bytes or semantic/runtime
claims changed.

The independent Pokémon/frame audit reconfirmed all 369 bank53 name bytes and
found no established name-to-frame association. Within its bounded asset scope,
17 editing views exist and eight remain KEEP; the expanded 137-asset bank41–47
set and 53 source PNGs reproduce the declared bytes, with no orphan PNGs or
binaries among the 71 images in the reviewed frame/browser directories. The
dispatcher and legacy preview names do not establish universal unused status.
Full closure still requires investigating the remaining generic labels and
address-only GFX basenames in evidence-backed units. English remains suspended.

The finite asset result reconciled its snapshot to `main` at `c2b33d2f8de865da52ab877fa25005fec55de559`: 549/576 tracked inputs retain exact blob IDs, the remaining 27 ASM owners differ only in comments/global labels, and no PNG or binary resource changed. The documentation-only checkpoint `4a38c8b8f1cbba089894240ceeb8399e47e87244` records that reconciliation; the audit inputs and original ROM remain unchanged. The ROM's current SHA-256 is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Eight KEEP compositions and all 25 name/frame associations remain open; see `docs/research/pokemon_names_bank53_asset_audit_20261020.md`.

Follow-up on the current main branch: commit `47830bec` retired the redundant
local-scope data labels at `55:6F3B` and `27:417A`; `ac5db3ec` documented the
bounded bank53/frame coverage and its eight KEEP editing-view gaps. The next
source pass removed four exact-address aliases in `audio/music/music_01.asm`:
`Data_04_5788`, `Data_04_57F3`, `Data_04_5832` and `Data_04_58BC`. Their
descriptive same-address labels `SoundSong01_Track1..3` and
`SoundSong01_Header` remain. This is label cleanup only; it does not establish
new audio semantics or alter source bytes. Current main build and Japanese
symbol/palette checks remain the publication gates. See
[`audio2_verify_static.md`](docs/research/audio2_verify_static.md) for the
bounded alias evidence and result.

A follow-up retired the last generic label in that music owner,
`Data_04_574D`, while retaining `SoundSong01_Track0` at 04:574D. Its remaining
mentions in the older audio audit and rename ledgers describe historical state
only; no bytes changed. The symbol count at that checkpoint was 14,632.

The following audio SFX owner cleanup retired 76 exact-address `Data_05_*`
aliases from `audio/sfx.asm`; each retains its existing `SoundSfx*` label.
The census and independent review found no source/tool/metadata consumers or
local scopes for the retired spellings. The original 2-MiB ROM remains
`RESULT: IDENTICAL`; current symbol and palette checks report 14,633 labels / 51
constants and 162 loads / 116 arrays / two documented over-reads / zero errors.
This does not change the earlier PROBABLE classifications of headers or make
new claims about natural playback. English remains suspended.

The same bounded census supports retiring all 35 exact-address `Data_05_*`
aliases in `audio/music/music_17.asm`, keeping their `SoundSong17_*` labels.
Current maintained ASM/include files contain no consumers outside that owner;
the old spellings remain in frozen analysis/configuration records as history.
This label-only cleanup adds no audio interpretation or runtime claim. The
build remains `RESULT: IDENTICAL` with the original SHA-256; the current
symbol count at that checkpoint was 14,597 and `palette-check` reported zero
errors.

Another exact-address cohort of 31 redundant `Data_04_*` labels was retired
from `audio/music/music_05.asm`, preserving the same-address `SoundSong05_*`
labels. The current maintained ASM/include scan found no external consumers or
local scopes; frozen ledgers keep the earlier spellings as history. The change
adds no audio interpretation or playback claim. At this checkpoint the ROM
still builds identically and the symbol count is 14,566.

The next paired music-owner pass retired 20 `Data_05_*` aliases each from
`audio/music/music_12.asm` and `audio/music/music_0e.asm`, preserving the
same-address `SoundSong12_*` and `SoundSong0E_*` labels. The pre-edit owner
hashes match the pinned census inputs; an updated ASM/include scan found no external
consumers or local scopes. This removes generic aliases only and makes no new
sound interpretation.

The `music_14.asm` follow-on retired 18 exact-address `Data_05_*` aliases for
existing `SoundSong14_*` names. Four positions without a same-file descriptive
co-alias remain named `Data_05_*`; this pass does not infer their purpose.
The pre-edit owner hash matched the pinned census input, and the pre-edit
ASM/include scan found no outside consumers or local scopes. The ROM remains
byte-identical and the symbol count is 14,508.

The address-book cursor animation block at bank 2F now names its frame and
script `Abook_ViewCursor_Frame0` and `Abook_ViewCursor_Script`. The consumer
passes `Table_Abook_ViewCursorAnims` to `Sprite_InitSlot`; its four entries
share the script, and the frame table points to the frame. The macro boundaries
remain table `$57C0..$57C2`, frame `$57C2..$57EF`, and script `$57EF..$57F2`.
The structural bounds are CONFIRMED by the source layout; the association with
the address-book cursor is PROBABLE from the consumer and table names. This
renames two generic labels without changing directives or data. Build and symbol
checks pass; this does not establish runtime behavior.

The bank 3F HTML/mobile-dictionary index now uses five consumer-supported
semantic names: `Table_HtmlStore_KeywordPointers`, `String_HtmlStore_UrlPrefix`,
`Table_HtmlStore_PageFarPointers`,
`Table_MobileDict_CategoryPageLists`, and
`Data_MobileDict_CategoryPageIndices`; the five redundant generic labels at
these addresses were retired after searching maintained-source references.
The corresponding consumers establish
55 far pointers, 11 category-list pointers, and 61 page indexes as static
contracts. `Data_HtmlStore_ByteAfterUrlPrefix` names the byte structurally;
the purpose of its `$02` value stored in `wRam_C2DC` remains unresolved.
`3F:40B7..40B9` is a zero-word terminator
checked before a bank byte is read, not padding or a far pointer. No new runtime
claim follows. The bounded 268-byte span matches the original ROM; full
reconstruction equivalence remains determined by `make`. See
[`docs/research/html_index_bank3f_naming.md`](docs/research/html_index_bank3f_naming.md).

The debug-flags screen's single object record now names its frame and script
`DebugFlags_CursorFrame0` and `DebugFlags_CursorScript`; four redundant generic
aliases at the table/data/frame/script addresses were retired after checking
maintained-source references. The table links to `DebugFlags_ObjAnimData`, the
frame contains one OAM entry, and the script selects frame 0 for four ticks.
The structure is CONFIRMED; association with the cursor is PROBABLE. Existing
traces label the debug path forced-only, so this does not establish natural
execution. See
[`docs/research/debug_flags_cursor_sprite.md`](docs/research/debug_flags_cursor_sprite.md).

The bank-4D graphics catalog now uses the current owner symbols for eight
ChoiceMenu entries: the shared `$5810` tilemap/attribute-map base and six tile
payloads. This is a metadata-only correction in the `label` column; the eight
referenced payloads total 4,560 bytes and retain their recorded hashes. It
does not add PNG round-trip evidence or change ROM data. The English fallback
pin for `gfx/assets.tsv` was already stale before this pass and remains
untouched; no English build or manifest update was performed. See
[`docs/research/gfx_assets_bank4d_label_sync.md`](docs/research/gfx_assets_bank4d_label_sync.md).
The required `make png-check` initially exposed a pre-existing ordering drift
between the 950 generated PNG rules and the asset manifest. Regenerating the
two sidecars changed only row order; all rule records, payload sizes and hashes
remain the same, and the PNG check now passes.

The mail connection-screen owner also had 23 redundant `Data_27_*` aliases under existing descriptive graphics and animation labels. They were removed after confirming same-address symbols and no generic references, tool/metadata mentions or local scopes; the byte-identical build and static checks pass. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The communication-scene graphics owner also lost 22 redundant `Data_70_*` aliases under exact-address frame, animation-script and graphics labels. Current symbols and source scans confirmed no generic-name consumers; bytes and confidence are unchanged. The byte-identical build and symbol, palette and PNG checks pass. Details are in the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The communication-error text owner also lost 21 redundant `Data_21_*` aliases under exact-address descriptive text-record labels. Current symbol and source scans found no generic-name consumers; emitted bytes and confidence are unchanged. The byte-identical build and symbol, palette and PNG checks pass. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The `audio/music/music_04.asm` owner lost 18 `Data_05_*` aliases under the existing `SoundSong04_*` labels at the same addresses. Searches found no generic-name consumers; no stream interpretation or confidence changed. Build identity and symbol, palette and PNG checks pass. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The `audio/music/music_0a.asm` owner lost 18 `Data_05_*` aliases under existing `SoundSong0A_*` labels at matching addresses. Current source searches found no generic-name consumers; no musical interpretation or confidence changed. The build remains identical and all symbol, palette and PNG checks pass. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The `audio/music/music_11.asm` owner lost 18 `Data_05_*` aliases under existing `SoundSong11_*` labels at matching addresses. Current source searches found no generic-name consumers; no musical interpretation or confidence changed. The build remains identical and all symbol, palette and PNG checks pass. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The profile-editor graphics owner lost 17 `Data_66_*` aliases under existing descriptive resource labels at matching addresses. Current source searches found no generic-name consumers; emitted bytes and confidence are unchanged. Build identity and symbol, palette and PNG checks pass. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The bank-66 keyboard graphics owner first lost 15 same-address `Data_66_*` aliases under its existing page/VRAM and tilemap labels. Seventeen catalogue rows now use those maintained source labels. A later consumer review replaced the two remaining spans at `66:6A90-7210` with `Gfx_MailDraftExitOptions_Tiles`: three static 640-byte transfers are **CONFIRMED**, while the mail-draft exit meaning is **PROBABLE** and natural display of every picker mode remains unproved. The original bytes are preserved; the Japanese ROM remains byte-identical and symbol, palette, PNG, and PNG-rule checks pass. See [the resource review](docs/research/typing_66_mail_draft_exit_options.md) and [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The adjacent bank-62 keyboard graphics owner lost 12 same-address `Data_62_*` aliases under its existing page/VRAM labels. The catalogue now uses the maintained symbols; four partial-tile spans retain neutral names. No data bytes or confidence levels changed. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The shared-browser menu graphics owner lost 16 `Data_72_*` aliases under existing menu-frame, script and tile labels at matching addresses. Exact-token searches found no generic-name consumers; bytes and confidence are unchanged. Build identity and symbol, palette and PNG checks pass. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md).

The account action-confirm source lost two `Data_68_*` aliases under its cursor-position and message-ID labels. In the bitmap blitter, `Data_51_73D1` was retired under `Table_Bmp_RowEndMask`; its incorrect palette heuristic was corrected to describe the indexed row-end masks and static consumer. `Data_68_4000`, `Data_68_41DB` and `Data_51_740C` were also retired under their existing descriptive symbols; their fixed magic text, mail separator and PROBABLE edge mask now have current comments. The non-aligned row-mask branch is not claimed as executed. No data bytes changed.

The renewed bank53/frame inventory found no missing referenced file or orphan binary/PNG in its bounded 208-file scope. It confirms the existing 25 name strings and 137 bank41–47 assets byte-for-byte, but still cannot associate the 25 names with frame images. `Table_53_4000` is now `Table_PokemonNamePointers`; the redundant `String_53_4032` alias of `PokemonName00` at `53:4032` was retired. Eight frame windows remain KEEP; see [the refreshed asset audit](docs/research/pokemon_names_bank53_asset_audit_20261020.md).

The bank22 address-book tile continuation at `22:5CEA` is now `AddrBook_ListAndAddressGraphicsContinuation`. It starts in the middle of a tile and completes the 160-tile family rooted at `22:5CD0`; the label does not imply a standalone tile sheet, and the exporter leaves it as raw data. See the follow-up in [the bank22 verification note](docs/research/typing_22_verify_address_book_tiles.md).

A literal scan at `c3b3db48` found no generic `Function_BB_AAAA` or `Font_BB_AAAA` names in the maintained Japanese assembly roots, and no `bankNN` paths under `gfx/`. At that checkpoint, after the TOP copy, twelve structural/positional data renames and four redundant-alias retirements, the count was 976 definitions in the six maintained roots plus one in `zero_labels.asm` (977 total). This historical lexical result does not establish semantic completion. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md) for the current count.

The TOP poll's eight-byte pre-header copy at `54:4C35` remains named `Data_Pop3Top_BytesCopiedBeforeHeaderArgs`; its downstream purpose is HYPOTHESIS and storage classification PROBABLE. The bank-4C connect-dialog block now has the caller-derived structural name `Data_BrowserLoadPage_ConnectDialogArgs` (whole-unit PROBABLE, four of eight bytes unread), and the unexplained SMTP interval at `54:4764` has the positional name `Data_Smtp_BytesBeforeCloseParen` (purpose HYPOTHESIS, no reads in 69 available natural-scenario traces). The keyboard interval at `55:6F95` is now `Kbd_Candidate_PaletteWordsAndReloadCounts` [PROBABLE indexed layout]; natural entry, caller and visible effect remain HYPOTHESIS because the candidate reader has no proven entry. The former `Data_6C_485A` interval is now `String_HelpScript_MobileTrainerWelcome`, a 63-byte NUL-terminated stream decoded through the located bank-6C reader and lookup; text identity remains PROBABLE; a bounded emulator sample is recorded in docs/research/help_script_stream_map_20261020.md, while complete rendered output remains unverified. `Data_05_4024` and `Data_05_41D0` are now `SoundSong0E_Track0_Continuation` and `SoundSong0E_Track3_Continuation`; both label interior portions of decoded streams without asserting independent playback entries. `Data_05_4E22`, `Data_05_4F6A`, `Data_05_4FD5`, and `Data_05_5085` are now `SoundSong14_Track0_Continuation`, `SoundSong14_Track1_Continuation`, `SoundSong14_Track2_Continuation`, and `SoundSong14_Track3_Continuation`, with extents of 56, 28, 46 and 28 interior bytes respectively before their one-byte `sound_end` commands. `Data_05_5E23` and `Data_05_609A` are now `SoundSong1A_Track0_Continuation` (19 interior bytes) and `SoundSong1A_Track3_Continuation` (52 interior bytes), likewise before `sound_end`. All six track memberships remain PROBABLE. In `audio/music/music_1d.asm`, the four generic `Data_05_*` labels at the track starts and stream header were removed; their same-address semantic labels remain. The redundant `Table_05_6314` alias was also retired while `SoundSong1D_TrackPtrs` remains. The old spellings survive in frozen analysis manifests and in the unchanged `config/regions/bank05.tsv` historical region map. At that historical 2026-10-20 checkpoint, `data_consumers.py --stats` reported 564 neutral data groups and 147 rejected automatic candidates. On the current rebuilt Japanese symbol map, the same exact recognizer reports zero neutral data groups and zero manifest rows; this is a bounded lexical result, not proof that every data role is semantically identified.

At `54:4C3D` and `54:4C44`, the redundant exported aliases `Data_54_4C3D` and `Data_54_4C44` were removed under the existing CONFIRMED labels `Data_Pop3Top_DecodeHeaderArgs` and `Data_MailScan_InputPrefix`. They had no current assembly/tool consumers; frozen `config/` and `analysis/` snapshots retain their historical spellings. The data bytes, boundaries, read evidence, and PROBABLE storage classifications are unchanged.

At the 2026-10-21 checkpoint, `audio/music/music_07.asm` also lost 17
same-address `Data_04_*` aliases under existing `SoundSong07_*` names; the
776 audio directives were preserved and the original ROM remains identical.
The 55:6EF7 lookup is now named `Table_Kbd_Type6To10Flag_ByType` (**PROBABLE**
storage relation, valid indexed domain 0..10); its unchecked higher indices
read beyond the eleven-byte table, natural sampled reads remain zero, and the
related entry/purpose remain HYPOTHESIS. Five bounded entry reports were
independently reviewed without promoting an entry or intent. The bank29
candidate owner now uses `engine/gfx/palette_library_candidate.asm` and
`PalLibCandidate_*`; its entry and intended role remain HYPOTHESIS. A broader
audit found positive consumers inside two other owners still named
`unreferenced`, along with overbroad candidate-screen/frame names and stale
generated provenance; it recommends scoped migrations rather than blanket
renames. See
[`docs/research/original_closure_followup_20261021.md`](docs/research/original_closure_followup_20261021.md).

The latest routine-label reconciliation supersedes the older `naming2_fn4.md`
count: the current source and rebuilt SYM have zero literal
`Function_BB_AAAA`/`Label_BB_AAAA` labels, and all 28 historical routine
addresses in the triage matrix resolve to their current operation names.
Natural roots and application purpose remain unproved for those 28; four
priority entry slices remain UNKNOWN. This is a naming census, not function or
entry-point closure. A filtered recheck at `2281dffc` found the same nine
internal/conditional references and no exact raw `$ADDR` operands for these
targets; computed and stack routes remain open. See the current-status section
in the linked follow-up.

The `audio/music/music_02.asm` owner then lost 15 same-address `Data_04_*`
aliases under retained `SoundSong02_*` labels. An independent scoped encoder
reproduced the same 1,043 bytes before and after and matched ROM 04:58C6–5CD9;
the full build, symbol check and quick audio-driver check also pass. The 18
historical alias spellings in frozen rename and mapper records remain as
provenance. This deletion does not change stream interpretation or confidence.

The 2026-10-21 naming pass also retired 44 redundant `Table_05_AAAA` aliases
in audio track-pointer tables (29 sound effects and 15 songs). Every removed
symbol was an unreferenced same-address alias of an existing
`SoundSfxNN_TrackPtrs` or `SoundSongNN_TrackPtrs` label; table contents and
confidence are unchanged. See
[`docs/research/audio_track_pointer_aliases_20261021.md`](docs/research/audio_track_pointer_aliases_20261021.md).

The same naming pass retired 12 unreferenced `Table_74_AAAA` aliases in the
HTML keyword pointer lists, retaining their same-address `Html_*Ptrs` labels
and preserving every word and target. Details are in
[`docs/research/html_keyword_pointer_aliases_20261021.md`](docs/research/html_keyword_pointer_aliases_20261021.md).

The private GFX naming census found no current `gfx/bankNN` directories. Its
1,495 exact type/bank/address labels are divided into 605 candidates with
lexical evidence, 648 provenance/co-alias cases and 242 indeterminate cases;
this is a prioritization aid, not a rename decision or completion claim. The
asset inventory and provenance limits are recorded in
[`docs/research/gfx_generic_name_audit_20261021.md`](docs/research/gfx_generic_name_audit_20261021.md).

In `engine/help/mobile_dictionary.asm`, 12 `Table_1A_AAAA` aliases were
retired under the existing `Table_MobileDict_*` names; exact-token searches
found only their declarations and explanatory comments. References in the
comments were updated, while table data and confidence remain unchanged. See
[`docs/research/mobile_dictionary_table_aliases_20261021.md`](docs/research/mobile_dictionary_table_aliases_20261021.md).

In `engine/browser/page_view.asm`, nine unreferenced `Table_4E_AAAA` aliases
were retired under existing `Browser_PageView_*` and `Browser_Menu_*` table
names. Their words and comments were not reinterpreted; see
[`docs/research/browser_page_view_table_aliases_20261021.md`](docs/research/browser_page_view_table_aliases_20261021.md).

The HTML URL, tag-dispatch, line-break dispatch and count-pass owners also lost
four unreferenced `Table_74_AAAA` aliases under existing structural labels.
Comments now use the retained names; the count-pass table extent remains
PROBABLE. See
[`docs/research/html_dispatch_table_aliases_20261021.md`](docs/research/html_dispatch_table_aliases_20261021.md).

The keyboard source lost nine unreferenced `Table_55_AAAA` aliases under its
existing direction, sprite-offset and page-loader table labels. No table
contents or behavior claims changed; see
[`docs/research/keyboard_table_aliases_20261021.md`](docs/research/keyboard_table_aliases_20261021.md).

The mailbox owner lost eight unreferenced `Table_25_AAAA` aliases under its
existing record-address, hint and icon-bar attribute table labels. Values and
SRAM interpretation remain unchanged; details are in
[`docs/research/mailbox_table_aliases_20261021.md`](docs/research/mailbox_table_aliases_20261021.md).

The address-book save-sender owner lost seven unreferenced `Table_2A_AAAA`
aliases: six over existing record/slot address lists and one over its existing
caption string. Contents are unchanged; see
[`docs/research/save_sender_address_table_aliases_20261021.md`](docs/research/save_sender_address_table_aliases_20261021.md).

The source header for `String_2B_5807` now records its two direct operands in
`Fill99E1Pattern46_Draw5807TwiceAndUpload` (`2B:57EF` and `2B:57FB`) and its
reader, `MailGrid_DrawTextLine12`. The string's intended display role and the
candidate routine's natural entry remain unresolved; details are in
[`docs/research/original_closure_followup_20261021.md`](docs/research/original_closure_followup_20261021.md).

The redundant `Data_6A_72A0` export has been removed from
`gfx/help/help_screens_b.asm`; its former line remains blank, preserving
physical source locators. `SpriteFrameTable_6A_72A0` and the payload remain
unchanged. `make` returned `RESULT: IDENTICAL` with ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`sym-check` reports 334 sources/13,396 labels/51 constants and the saved
before/after SYM and MAP diff contains only the removed export.
`palette-check` reports 162 loads/116 arrays/two documented over-reads/zero
errors. The worklist disposition is now APPLIED (48 APPLIED, 14 KEEP, two
APPLIED_ALIAS, one PARTIAL_ALIAS, zero PENDING); its legacy HYPOTHESIS status
and the table's unresolved visual purpose are retained. See
[`docs/research/naming2_neutral_help.md`](docs/research/naming2_neutral_help.md).

Eight generic animation labels in the dialog-window and no-adapter owners now
describe their confirmed table entry, shared cursor frames/script and selected
no-adapter animation. An independent review verified all direct consumers and
re-emitted 82 bytes against the original ROM; the rebuilt SYM has eight
address-preserving substitutions and no label-count change. The Japanese ROM
remains `RESULT: IDENTICAL`, and symbol and palette checks pass. The dialog
animation is shared by entries 0 and 1; these names do not claim a rendered
subject or natural runtime selection. See
[`gfx_dialog_no_adapter_animation_names_20261021.md`](docs/research/gfx_dialog_no_adapter_animation_names_20261021.md).

The eight bank41–46 `KEEP` views were rechecked against selectors and placement
state. The current descriptor set selects only bank47, and no original path to
these windows was established; a hypothetical clear/upload model fills seven
windows and leaves 12 cells at `42:5AA0` unresolved. All eight remain `KEEP`,
and the 25 name-to-image associations remain HYPOTHESIS. This is a finite
negative result, not proof of global non-use; details and the retained matrix
are in [`pokemon_names_bank53_asset_followup_20261020.md`](docs/research/pokemon_names_bank53_asset_followup_20261020.md#eight-keep-placement-recheck-2026-10-21).

The keyboard-panel graphics source lost 30 unused same-address aliases in
bank5F. Existing descriptive resource names, data, addresses and confidence
remain unchanged; the 485 physical source lines are preserved. The original
build is still `RESULT: IDENTICAL`, with 13,215 labels/51 constants in
`sym-check` and no unrelated symbol movement. The generic-data census is now
832 definitions in the six maintained roots plus one in `zero_labels.asm`,
excluding the protected `engine/mail/sample_data.asm`. See the exact mapping
and scan limits in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-5f-keyboard-panel-same-address-aliases-2026-10-21).

Five generic labels in the `ConfirmPages` animation object now identify its
confirmed table entry and frame/script structure. Seven original consumers and
an independent byte emitter support the addresses; the reviewer preferred
`ConfirmPages_ObjTable_Entry1` over a broader compound name. The Japanese
build remains byte-identical with five address-preserving SYM substitutions.
This does not name the object's depicted subject or resolve adjacent partial
`SettingsMenu` data; see
[`gfx_confirm_pages_animation_names_20261021.md`](docs/research/gfx_confirm_pages_animation_names_20261021.md).

The two bank-04 music owners for songs 06 and 08 lost 27 unused generic
`Data_04_*` aliases over their existing `SoundSong*` stream labels. The tokens
occurred only at their declarations, with no external or tool references and
no local-label scope changes. The 792- and 972-byte stream owners and all
confidence annotations are unchanged. The ROM remains `RESULT: IDENTICAL`;
details and the address map are in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-04-song-06-and-song-08-same-address-aliases-2026-10-21).

The same pass pattern then retired 15 unused same-address `Data_04_*` aliases
from `audio/music/music_09.asm`. Its `SoundSong09_*` labels, 906-byte
contents, comments and confidence are unchanged; no alias had a current token
consumer or local-label child. The original build remains byte-identical. See
the mapping and bounded scan in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-04-song-09-same-address-aliases-2026-10-21).

The same bounded audit retired 14 declaration-only `Data_04_*` aliases from
`audio/music/music_0b.asm` over same-address `SoundSong0B_*` labels. No
cross-file, tool or local-label consumer was found; the 591-byte owner and
384 physical lines remain unchanged. The address map and scan limits are in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-04-song-0b-same-address-aliases-2026-10-21).

Song `0C` received the same bounded audit: 13 declaration-only `Data_04_*`
aliases were removed over same-address `SoundSong0C_*` labels. No consumer was
found in the examined sources, tools or local-label scope; the 457-byte owner
and 303 physical lines are unchanged. See the mapping in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-04-song-0c-same-address-aliases-2026-10-21).

Song `0D` lost five declaration-only `Data_04_*` aliases over same-address
`SoundSong0D_*` labels. The bounded scan found no other-source, tool or
local-label consumer; the 208-byte owner and 163 lines are unchanged. Its
address map is in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-04-song-0d-same-address-aliases-2026-10-21).

Song `0F` in bank 05 lost 14 declaration-only `Data_05_*` aliases over
same-address `SoundSong0F_*` labels. No consumer was found in the examined
sources, tools or local-label scope; its 808-byte owner and 536 lines are
unchanged. See the map in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-05-song-0f-same-address-aliases-2026-10-21).

The refreshed generic-name census also retired 28 declaration-only address
aliases in bank 72's dialog-message list and records. No cross-file, tool or
local-label consumers were found; `data/text/dialog_messages.asm` retains its
623 physical lines and all ROM data. The address map and scan limits are in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-72-dialog-message-same-address-aliases-2026-10-21).

A further same-address pass retired 24 generic palette/table labels in bank
23's mail-server delete-progress data, where matching named labels already
exist. No other-source, tool or local-label consumers were found; the owner
retains its 598 physical lines and all ROM data. See the address map and scan
limits in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-23-mail-server-delete-progress-aliases-2026-10-21).

In bank 70's communication-scene data, 23 generic address labels were also
retired over existing named tables, graphics, palettes and tilemaps. No
cross-file, tool or local-label consumers were found. Comment-only mentions
were updated to the retained names; code and ROM data are unchanged. The exact
map and census limits are in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-70-communication-scene-address-aliases-2026-10-21).

Bank 71's account-screen data then lost 22 address aliases over existing named
graphics, palettes, tilemaps, and sprite tables. The historical
`retype_blobs.py` transformer no longer emits its old palette alias; it still
recognizes the old input spelling. Its address map and that tool file are
documented in
[`docs/research/generic_data_name_audit_20261020.md`](docs/research/generic_data_name_audit_20261020.md#bank-71-account-screen-address-aliases-2026-10-21).

In the bank-05 song-10 stream, 13 generic address labels were retired under
the existing track, loop, after-jump, and stream-header names. No active
source or tool consumer used the aliases; stream commands and ROM bytes are
unchanged. See the [generic data-label audit](docs/research/generic_data_name_audit_20261020.md#bank-05-song-10-stream-aliases-2026-10-21).

The bank-05 song-1A stream also lost 14 `Data_05_*` aliases under its existing
track, loop, subroutine, after-jump, and header names. No active source or tool
consumer used them; stream commands and ROM bytes are unchanged. See the
[generic data-label audit](docs/research/generic_data_name_audit_20261020.md#bank-05-song-1a-stream-aliases-2026-10-21).

The bank-05 song-1C stream also lost 11 `Data_05_*` aliases under its existing
track, loop, subroutine, after-jump, and header names. No active source or tool
consumer used them; stream commands and ROM bytes are unchanged. See the
[generic data-label audit](docs/research/generic_data_name_audit_20261020.md#bank-05-song-1c-stream-aliases-2026-10-21).

The 1B song stream lost two co-addressed `Data_05_*` aliases under its
existing track and header labels. No active source or tool consumer used
them; bytes and confidence remain unchanged. See the [generic data-label
audit](docs/research/generic_data_name_audit_20261020.md#bank-05-song-1b-stream-aliases-2026-10-21).

**Bank 4B tile extraction (2026-10-21).** Positive transfer records cover all 1,456 bytes at `4B:4AD0–5080`; the interval now has an exact 91-tile PNG source while its higher-level screen and Pokémon associations remain unproved. See [the transfer audit](docs/research/bank4b_result_page_indexed_tiles_20261021.md). The Japanese disassembly remains active; English work remains suspended pending the Operator's explicit confirmation.

The bank-5D account-screen graphics owner no longer exports twelve redundant
`Data_5D_*` aliases or the co-addressed `Table_5D_7318`; asset-catalog rows
use the retained graphics, palette and tilemap labels. Its naturally selected
object entry at `5D:731C` is now named `Objects_Registration_WriteConfig_Entry1`
from the `B=$81` `Sprite_InitSlot` call and the bounded frame/script reader
evidence. Opaque `Data_5D_5000` remains neutral. The clipped `5D:6C00` tile
slice is now named `Gfx_Registration_WriteConfig_Tiles8A00Vb1`: it is the
second half of the confirmed 68:6B19 HDMA from `5D:6A00` to VRAM `$8800` in
VBK 1. A fresh six-root ASM scan finds 562 `Data_BB_AAAA::` definitions in
140 owners, excluding the protected mail sample and `zero_labels.asm`; this
lexical count is not a semantic-completion measure. No screen depiction or broader runtime claim is added; see the
[owner audit](docs/research/generic_data_name_audit_20261020.md#bank-5d-account-screen-aliases-and-object-entry-2026-10-21).

The bank-4A settings and confirmation owner also lost nine redundant
`Data_4A_*` aliases and `Table_4A_5838`; catalog cells now point to the
retained resource names. Five cursor-selected highlight map records have
entry-specific labels and bank-68 uses those bank-4A labels instead of raw
words. The selected settings object entry at `4A:583C` and its script target
at `4A:5866` now have structural names; the frame records and script are now
expressed in macros. The old 16-byte 2bpp file is retained outside the active
catalogue as byte-view evidence. The
prior note's count of 550 `Data_BB_AAAA::` labels was high by 24: a
whitespace-aware tracked-source census at `1c6a6ccb` counted 526 definitions
in 137 owners, excluding the protected sample and `zero_labels.asm`. The
suspected unread palette at `4A:51B0` remains neutral. See the [bank-4A audit](docs/research/generic_data_name_audit_20261020.md#bank-4a-settings-and-confirmation-resources-2026-10-21).

The communication-scene table at `70:4832` and its four probable entry chains
now use `CommScene_ObjAnim*` names. The labels distinguish four frame-pointer
lists, 26 list-ordered frame records and four paired candidate scripts; no
executed caller, depicted subject or first-two-field meaning is claimed. The
26 neutral `Data_70_*` labels became structural labels without changing data
spans. The exact six-root `Data_BB_AAAA::` count is now 447 in 136 owners after
these alias retirements.
`make` remains `RESULT: IDENTICAL`, and `make sym-check` passes 12,743 labels
and 51 constants. See the [bank-70 naming audit](docs/research/generic_data_name_audit_20261020.md#bank-70-communication-scene-object-animation-records-2026-10-21).
The second probable object-animation group at `70:4C5C` now uses
`CommScene_ObjAnimTable2` plus entry/list-index labels for its 14 frames and
candidate script. Its caller and depicted subject remain unknown. See the
[bank-70 naming audit](docs/research/generic_data_name_audit_20261020.md#bank-70-second-communication-scene-object-animation-group-2026-10-21).

Two further probable groups at `70:4DBB` and `70:5272` now use entry-,
frame-list- and frame-index names for 22 frame records and five candidate
scripts. Callers, sprite subjects and the first two OAM field meanings remain
unknown. See the [bank-70 naming audit](docs/research/generic_data_name_audit_20261020.md#bank-70-third-and-fourth-communication-scene-object-animation-groups-2026-10-21).

Bank 51's communication-time graphics owner has also lost eleven generic
same-address `Data_51_*` aliases under existing resource labels. Eight asset
catalog entries now use those names, and the unknown tile-data tail remains
neutral. See the [bank-51 alias audit](docs/research/generic_data_name_audit_20261020.md#bank-51-communication-time-graphics-aliases-2026-10-21).

The bank-24 page-list owner now names two probable tile regions and
candidate-prefixed frame tables, frame records and animation scripts in the
unmatched animation area. The candidates remain HYPOTHESIS where no known
object-table row selects them; `ByteMatch_PageListProto_ObjTableFirstRow_24_6520`
records an exact byte match to the first prototype row, without establishing
bank-24 table use. See the
[bank-24 page-list audit](docs/research/generic_data_name_audit_20261020.md#bank-24-page-list-tiles-and-candidate-animation-records-2026-10-21).
A whitespace-aware six-root census now finds 430 generic `Data_BB_AAAA::`
definitions in 136 owners; this is a label count, not a completion percentage.
The ROM remains `RESULT: IDENTICAL`, `sym-check` passes with 12,732 labels and
51 constants, and palette/PNG checks pass.

Bank 4D's settings graphics now use bounded `TileSlice` names for five
confirmed DMA-covered tile intervals, preserving cross-boundary upload
limits. Eight same-address `Data_4D_*` aliases and two generic object-table
aliases were retired under existing symbols. The updated six-root count is
417 `Data_BB_AAAA::` definitions in 135 owners. See the [bank-4D audit](docs/research/generic_data_name_audit_20261020.md#bank-4d-settings-graphics-slices-and-object-table-aliases-2026-10-21). The 43 files owned by that bank-4D settings unit now use consumer, VRAM destination/bank and source-address paths. The rename preserves all 43 file hashes and the 25 ROM-backed binary slices; `make` remains byte-identical, and symbol, palette and PNG checks pass. See the [semantic Bank 4D resource path audit](docs/research/gfx_bank4d_semantic_resource_paths.md).

Bank 42's 27 type/address-only graphics labels now use
`FrameDesignCandidate_*` names tied to the existing four filename-derived
families. They remain candidate resources: no natural loader or screen
composition has been established. The six-root generic `Data_BB_AAAA::`
count is now 403 in 134 owners. See the [bank-42 naming audit](docs/research/gfx_generic_name_audit_20261021.md#bank-42-candidate-owner-names-2026-10-21).

The bank-6A help-screen owner has lost ten redundant `Data_6A_*` aliases
under existing tilemap, graphics and palette labels. The ambiguous RGB-word
include and the frame-continuation span remain neutral. The six-root generic
`Data_BB_AAAA::` count is now 393 in 134 owners. See the [bank-6A audit](docs/research/generic_data_name_audit_20261020.md#bank-6a-help-screen-exact-address-aliases-2026-10-21).

The bank-74 HTML keyword owner has also lost eleven redundant `Data_74_*`
aliases under its existing `Html_*Names` labels. Pointer lists and string/value
bytes are unchanged. The six-root generic count is now 382 in 133 owners. See
the [bank-74 audit](docs/research/generic_data_name_audit_20261020.md#bank-74-html-keyword-name-aliases-2026-10-21).

The mail-session graphics owner in bank 26 now uses a bounded tile-slice name
for the internal `66F0-67E0` segment and no longer exports eight duplicate
`Data_26_*` aliases. The two remaining standalone generic labels stay
unresolved. The six-root count is now 373 in 133 owners. See the [bank-26
audit](docs/research/generic_data_name_audit_20261020.md#bank-26-mail-session-tile-aliases-and-clipped-tile-slice-2026-10-21).

The bank-2A save-sender owner now names its 19 frame records, eight animation
scripts, one slot-animation entry table and seven frame-pointer tables by
structure. Its orphan script and two unobserved graphics resources retain
candidate/PROBABLE limits. The six-root generic `Data_BB_AAAA::` count is now
346 in 132 owners. See the [bank-2A audit](docs/research/generic_data_name_audit_20261020.md#bank-2a-save-sender-animation-structures-2026-10-21).

The bank-1D mail-menu owner no longer exports fifteen same-address generic
Data/tilemap/attrmap aliases under existing resource labels. A follow-up
resolved the former `Data_1D_62B0` as the nine-frame table for the animated
mail-menu icon, with the records, script and object-table entry represented by
sprite macros. This also removed the false palette asset classification; the
ROM remains byte-identical. The earlier six-root count of 337 was a dated
checkpoint and predates later naming passes. See the bank-1D audit and its
sprite-format follow-up in the research documentation.

The bank-0E title-screen owner no longer exports ten exact-address `Data_0E_*`
aliases under its existing graphics, tilemap and palette labels. Its six-root
generic Data census is now 327 definitions in 131 owners. See the [bank-0E
audit](docs/research/generic_data_name_audit_20261020.md#bank-0e-title-screen-resource-aliases-2026-10-21).

The bank-29 compose-object owner now names its unselected animation block and
orphan frame/script group with candidate-qualified structural labels, and no
longer exports eleven redundant `Table_29_*` aliases. The six-root generic
Data census is now 317 definitions in 130 owners. See the [bank-29
audit](docs/research/generic_data_name_audit_20261020.md#bank-29-compose-object-candidate-animation-names-2026-10-21).

The bank-2C address-picker owner no longer exports seven exact-address
`Data_2C_*` aliases or duplicate table/palette labels. Its unobserved tile block
at `2C:6FD0` now has a context-qualified candidate name; `Data_2C_7355` remains
unresolved. The six-root generic Data census is now 310 definitions in 130
owners. See the [bank-2C audit](docs/research/generic_data_name_audit_20261020.md#bank-2c-address-picker-resource-names-2026-10-21).

The bank-55 keyboard page tables now name eight previously address-only
trailer spans by the preceding T6/T78 page they separate. The existing
PROBABLE grade and byte layout remain unchanged. The six-root generic Data
census is now 302 definitions in 129 owners. See the [bank-55 audit](docs/research/generic_data_name_audit_20261020.md#bank-55-keyboard-page-trailer-names-2026-10-21).

The bank-47 scrollbar owner no longer exports six exact-address `Data_47_*`
aliases. Its isolated 64-byte block at `47:4040` now has a candidate-qualified
tile-slice name, with the existing PROBABLE evidence retained. The six-root
generic Data census is now 295 definitions in 128 owners. See the [bank-47
audit](docs/research/generic_data_name_audit_20261020.md#bank-47-browser-scrollbar-tile-names-2026-10-21).

The bank-28 delete-method owner no longer exports seven `Data_28_*` aliases
under its existing tile, tilemap and object-animation labels. The six-root
generic Data census is now 288 definitions in 127 owners. See the [bank-28
audit](docs/research/generic_data_name_audit_20261020.md#bank-28-delete-method-exact-address-aliases-2026-10-21).

The bank-1A mobile-dictionary owner no longer exports six same-address
`Data_1A_*` aliases. Its eleven zero bytes at `1A:4A85` now use a bounded
zero-byte-span label, with the existing PROBABLE region classification
preserved. The six-root generic Data census is now 281 definitions in 126
owners. See the [bank-1A audit](docs/research/generic_data_name_audit_20261020.md#bank-1a-mobile-dictionary-labels-2026-10-21).

The bank-4E browser frame owner now names the computed eight-byte attribute
lookup at `4E:6543`; five exact-address descriptor aliases and one duplicate
frame-table alias were removed. Lookup mechanics are statically confirmed,
while broader role and natural entry remain HYPOTHESIS. The six-root generic
Data census is now 275 definitions in 125 owners. See the [bank-4E audit](docs/research/generic_data_name_audit_20261020.md#bank-4e-browser-frame-descriptors-2026-10-21).

The bank-71 communication panel now has eight indexed 4x12 caption
tilemap/attribute pairs (`CommPanel_CaptionMap0..7`); their captions and
natural selection meanings remain unresolved. Four confirmed graphics source
slices in the account screens also received owner-qualified names, with the
asset catalog updated. The eight zero bytes after the maps remain a separately
labeled HYPOTHESIS. The six-root generic Data census is now 269 definitions
in 124 owners. See the [bank-71 audit](docs/research/generic_data_name_audit_20261020.md#bank-71-communication-panel-and-account-screen-graphics-2026-10-21).

The bank-28 mail-body owner no longer exports five exact-address `Data_28_*`
aliases, its duplicate palette/table aliases, or the stale generic asset labels
for the 4550 tilemap pair. The unreferenced code-shaped span at `28:4BA6` now
has the bounded candidate name `WramClearCandidate_28_4BA6`; entry and purpose
remain HYPOTHESIS. The six-root generic Data census is now 263 definitions in
123 owners. See the [bank-28 body-view audit](docs/research/generic_data_name_audit_20261020.md#bank-28-mail-body-view-resources-2026-10-21).

The bank-2E tidy-screen owner now names the split HDMA graphics source at
`2E:5AF0`, the isolated HYPOTHESIS data at `2E:7710`, and the two-frame
table plus its frame records and script at `2E:7921-795C`. Six trailing bytes
fit a two-step script shape but have no target in the bounded object-table
walk; that candidate remains HYPOTHESIS. See the [bank-2E tidy-screen audit](docs/research/generic_data_name_audit_20261020.md#bank-2e-mail-server-tidy-screen-data-structures-2026-10-21).

The historical candidate label for the tile block at `26:7840` was superseded
after a later independent review found that it is contained in a static
Profile_InitScreen HDMA request from `26:7820`; see the
[corrected slice audit](docs/research/japanese_profile_init_screen_tile_slice_20261022.md).
Its transfer destination is established, while selection by a tilemap and
display remain unproved.
The probable RGB555 block at `26:73E0` is now `CandidatePalette_26_73E0` with
a matching `.pal` path. No active transfer/load or screen mapping was found;
its content classification remains PROBABLE and its use HYPOTHESIS.
Excluding the protected `engine/mail/sample_data.asm`, the six-root
generic-data census is now 257 definitions in 122 owners, down from 263 in
123 owners after this pass.

In the bank-25 mailbox owner, three `Data_25_*` aliases under confirmed
tilemap/palette labels were retired, and the 17-tile arrow/label resource at
`25:6BD1` gained a candidate-qualified name with its PROBABLE grade retained.
The two read spans at `25:6AC8` and `25:6E71` remain neutral. See the
[bank-25 mailbox audit](docs/research/generic_data_name_audit_20261020.md#bank-25-mailbox-resources-2026-10-21).
Excluding the protected `engine/mail/sample_data.asm`, the six-root
generic-data census is now 253 definitions in 122 owners, down from 257 after
this pass.

A count-scope correction: the initial bank-2E/bank-25 census command had not
excluded `engine/mail/sample_data.asm`. It matched only the generic-label
pattern and did not inform semantic analysis, but violated the access boundary.
The totals above were recomputed with an explicit Git pathspec exclusion; the
research audit records the corrected commit-by-commit counts and method.

The settings-screen sprite owner in bank 71 no longer exports three exact
`Data_71_*` aliases under its named frame/script records. Standalone spans at
`71:723F` and `71:7271` remain neutral pending stronger content evidence. The
restricted six-root generic-data census is now 250 definitions in 122 owners.

Five exact `Data_25_*` aliases under the named mail-server status tiles and
tilemaps were retired; the catalog already used the retained labels. The
restricted six-root generic-data census is now 245 definitions in 121 owners.

Bank 6A's help-script owner no longer exports four `Data_6A_*` aliases or its
duplicate palette/table names. Its unobserved 64-tile footer/frame span gained
the candidate label `HelpScript_CandidateTiles_6E20`, preserving PROBABLE; the
ten-byte span at `6A:69E6` remains neutral. The six-root generic-data census
is now 241 definitions in 121 owners. See the [bank-6A help-script audit](docs/research/generic_data_name_audit_20261020.md#bank-6a-help-script-resources-and-object-table-2026-10-21).

In the bank-2C mail-title graphics owner, three exact `Data_2C_*` aliases and
one palette alias were retired under existing resource labels. The probable
object-animation pointer table and target now have candidate-qualified names;
their caller and runtime role remain unproved, and the 1308-byte mixed span at
`2C:5150` remains neutral. The restricted six-root generic-data census is now
237 definitions in 121 owners. See the [bank-2C mail-title audit](docs/research/generic_data_name_audit_20261020.md#bank-2c-mail-title-resource-names-2026-10-21).

The bank-7F browser page-list candidate graphics owner no longer exports five
exact `Data_7F_*` aliases, two address-only palette aliases or the duplicate
`Table_7F_6DB0`; seven catalog rows now use its maintained candidate labels.
All resources remain PROBABLE, and their prototype loader is outside the
natural coverage set. The restricted six-root generic-data census is now 232
definitions in 121 owners. See the [bank-7F candidate audit](docs/research/generic_data_name_audit_20261020.md#bank-7f-browser-page-list-candidate-assets-2026-10-21).

Song 13 and song 15 in bank 05 no longer export five exact `Data_05_*` aliases
each under their named track starts and headers. No track bytes, pointer
tables or confidence grades changed. The restricted six-root generic-data
census is now 222 definitions in 118 owners. See the [song 13/15 alias audit](docs/research/generic_data_name_audit_20261020.md#bank-05-song-13-and-15-stream-aliases-2026-10-21).

The bank-28 delete-all-screen graphics owner no longer exports four exact
`Data_28_*` aliases or its duplicate BG-palette label; the existing resource
symbols and catalog entries remain authoritative. Confidence and byte ranges
are unchanged. The restricted six-root generic-data census is now 218
definitions in 117 owners. See the [bank-28 resource audit](docs/research/generic_data_name_audit_20261020.md#bank-28-delete-all-screen-resource-aliases-2026-10-21).

The bank-72 dialog-window owner no longer exports four exact `Data_72_*`
aliases under its confirmed tile, tilemap and palette resources. The catalog,
bytes, ranges and confidence are unchanged. The restricted six-root
generic-data census is now 214 definitions in 117 owners. See the [bank-72
dialog-window audit](docs/research/generic_data_name_audit_20261020.md#bank-72-dialog-window-resource-aliases-2026-10-21).

The bank-29 connection-time graphics owner no longer exports two exact
`Data_29_*` aliases or the duplicate background-palette alias. The catalog now
uses the descriptive resources reached by bank-27 loader sites. The probable
palette at `29:5376` and ten-byte fragment at `29:53F6` remain neutral. The
restricted six-root generic-data census is now 212 definitions in 116 owners.
See the [bank-29 connection-time audit](docs/research/generic_data_name_audit_20261020.md#bank-29-connection-time-graphics-aliases-2026-10-21).

The four repeated 12-tile spans after keyboard pages 0–3 in bank 62 now have
page-qualified candidate names. Their payloads are byte-identical, while the
natural loaders stop before them; no use is claimed. Their grades remain
PROBABLE. The restricted six-root generic-data census is now 208 definitions
in 115 owners. See the [bank-62 candidate tile audit](docs/research/generic_data_name_audit_20261020.md#bank-62-keyboard-page-tail-tile-candidates-2026-10-21).

In bank 63's no-adapter screen owner, three exact `Data_63_*` aliases and the
duplicate object-table label were retired. The 64-byte span at `63:6480` is
the confirmed tail of the tile upload to VRAM `$8800` and now has a qualified
resource name. The restricted six-root generic-data census is now 204
definitions in 114 owners. See the [bank-63 resource audit](docs/research/generic_data_name_audit_20261020.md#bank-63-no-adapter-screen-resources-2026-10-21).

In bank 2F's address-book editor, three exact `Data_2F_*` aliases were removed
under the tile, tilemap and palette labels. The probable pointer table and its
candidate object-animation data now use feature-qualified candidate names;
the caller remains unknown and natural use is not claimed. The restricted
six-root generic-data census is now 200 definitions in 113 owners. See the
[bank-2F audit](docs/research/generic_data_name_audit_20261020.md#bank-2f-address-book-editor-resource-names-2026-10-21).

Bank 44's four border attribute maps now have package-specific `Attrmap_*`
names, with matching catalog entries. The content class is probable, and the
owner still has no demonstrated loader; this does not claim natural use. The
restricted six-root generic-data census is now 196 definitions in 112 owners.
See the [bank-44 attribute-map audit](docs/research/generic_data_name_audit_20261020.md#bank-44-border-attribute-maps-2026-10-21).

The bank-27 communication-time digit-pair table no longer exports its exact
duplicate `Data_27_5048` label; its existing computed-reader name remains.
Other unknown spans in the owner stay neutral. The restricted six-root
generic-data census is now 195 definitions in 112 owners. See the [bank-27
table audit](docs/research/generic_data_name_audit_20261020.md#bank-27-communication-time-digit-pair-table-alias-2026-10-21).

Four exact generic aliases in the bank-65 startup dispatch data were retired
under their existing status and configuration jump-table labels. Comments now
refer to those retained labels. The source bytes and table extents are
unchanged; `make` remains byte-identical, `sym-check` passes with 12,329
labels, and `palette-check` reports zero errors. See the
[startup table alias note](docs/research/startup_jump_table_aliases_20261021.md).

The palette-fade handlers and scroll-split row-pointer tables also lost six
exact generic aliases under existing labels. The paired scroll-data comments
now cite those retained pointer-table names. The pass preserves all bytes,
boundaries and probable grades; build, symbol and palette checks pass. See the
[palette/scroll table note](docs/research/palette_scroll_table_aliases_20261021.md).

Four generic aliases were also removed from bank-65 notice-page input and
digit-record tables; maintained source consumers use the retained names.
Frozen `config/` and generated `analysis/` snapshots keep historic spellings.
The alias map and bounded evidence are in the
[notice-page table note](docs/research/notice_pages_table_aliases_20261021.md).

Three address-only table aliases in the main navigation dispatchers have also
been retired under their existing `Nav_*JumpTable` labels. The three original
boundary grades remain probable, and the six-entry settings boundary remains
bounded as documented. The active naming notes now use the retained labels;
frozen mapper snapshots keep the old aliases. See the
[navigation-table audit](docs/research/navigation_table_aliases_20261021.md).

The top-menu input table and cursor target pairs now use their retained
`Table_TopMenu_*` names without duplicate numeric aliases; readers and
documented targets are unchanged. See the
[top-menu table note](docs/research/top_menu_table_aliases_20261021.md).

Bank 54's confirmed guest-login string and SMTP argument seed no longer have
their redundant `Data_54_*` aliases. The SMTP SRAM comment now names the
maintained source block, and the stale hypothesis candidate was removed from
the data-consumer tool. Historical snapshots remain identifiable by the
[alias note](docs/research/mobile_guest_and_smtp_data_aliases_20261021.md).
This pass's checked link used make overrides to reuse the existing object for
the protected mail sample because the unqualified dry-run scheduled that file;
see the note for the exact command and the interrupted invocation's unresolved
reachability.

The canvas remap and glyph blitter owners also lost four exact numeric aliases
under the names already used by readers and current research. Evidence grades,
table boundaries and coverage qualifications are unchanged; see the
[canvas alias note](docs/research/canvas_data_aliases_20261021.md).

The title-screen state, highlight-map and cursor-position tables now export
only their maintained names; their existing readers and evidence grades are
unchanged. See the [title-table note](docs/research/title_table_aliases_20261021.md).

The mobile-dictionary input dispatcher also no longer exports its duplicate
`Table_4C_4FF5` name; its five-entry confirmed table is unchanged. See the
[input-table note](docs/research/mobile_dictionary_input_alias_20261021.md).

The main title-choice dispatcher likewise uses only `Table_Main_TitleChoices`
now; its three probable pointer entries and boundary are unchanged. See the
[main-table note](docs/research/main_title_choice_alias_20261021.md).
The adjacent `1C:4016` bytes are now emitted and named as a probable
`JP Main_TitleLoop`, matching the local inline-dispatch-tail pattern. No direct
execution or default-index behavior is claimed; the unreferenced `$C9` at
`1C:401C` remains neutral. See the
[dispatch-tail note](docs/research/main_title_dispatch_tail_20261021.md).

The mailbox icon-bar attribute block no longer exports the duplicate numeric
data name. Its confirmed first-three-record read boundary and uncertain tail
remain as before; see the
[mailbox note](docs/research/mailbox_iconbar_data_alias_20261021.md).

At bank 26's confirmed blank-message string, the duplicate `Data_26_588E`
export was also retired under `MailSession_Msg_Blank`; the historical
text-classification note now records this later label-set-only change.

The communication-error record and message-pointer tables now export only
their existing semantic names; bytes and confirmed/probable boundaries are
preserved. See the
[communication-error alias note](docs/research/comm_error_table_aliases_20261021.md).


Three HYPOTHESIS script-shaped blocks in the top-menu owner now use
`TopMenu_CandidateSpriteScript_*` names instead of `Data_1E_*`. Their format is
plausible, but no known object-table row selects them and neighboring frame
tables do not establish an association. The bank-1E audit records the bounds.
A bank-6A help-ticker pass renamed the eight ordinary title/body pointer pairs,
the locked-item ticker table and its selected text records from address-only
labels. `HelpMenu_ShowItemText` supplies either the ordinary record base
(`6A:64B2`) or `HelpMenu_LockedTickerTable` (`6A:6651`) to `Ticker_Start`
(`48:42D4`); the ticker reads the bank byte and indexes title/body pointers.
This establishes table structure and roles from source readers, not natural
rendering of every record. Details and unchanged confidence boundaries are in
the [bank-6A ticker naming audit](docs/research/generic_data_name_audit_20261020.md#bank-6a-help-menu-ticker-tables-and-strings-2026-10-21).

A fresh path-bounded exact-name scan of the six maintained source roots plus
`zero_labels.asm`, excluding the protected mail sample before reading, finds
36 `Data_BB_AAAA` definitions in 32 owners and no exact generic `Function`,
`Font`, or `Label` definitions. This is a lexical count, not semantic closure.
The same scan now finds 0 `String_BB_AAAA`, no exact `Table_BB_AAAA`, 41
`Tiles_BB_AAAA`, 24 `Tilemap_BB_AAAA`, 4 `Attrmap_BB_AAAA`, and 25
`Palette_BB_AAAA` definitions; the remaining prefixes are an owner-by-owner
evidence worklist. Since this census, the 800-byte bank-5D span at `5D:5000`
has been identified as four consecutive 5x20 tilemap/attribute pairs selected
by `wPasswordEntry_Variant` and copied by `Tilemap_CopyRectAndAttr`; the exact
generic data count is now 36/32. This structural identification does not claim
that every variant was naturally exercised or identify the visual contents.
The four former generic table labels are described in the
[table-name audit](docs/research/generic_data_name_audit_20261020.md#remaining-generic-table-labels-2026-10-21),
with the unreferenced duplicate kept explicitly candidate-qualified. Two HTML
store record headers were also renamed by their literal first-page filenames;
no claim of browser load/display is added. A debug-screen triangle glyph and
two candidate blank-line records now have content-oriented labels; the latter
two remain HYPOTHESIS because no readers were found. The duplicate address
selection prompt in bank 2A is also candidate-qualified, with an exact byte
match to the named bank-2C prompt but no reader for the duplicate. Three
browser-menu strings are now labeled by their selected action text; table
structure is static evidence and does not imply natural rendering of every
entry. Eight continuation labels in the four bank-24 page-list messages now
describe their message and line position; that structure is PROBABLE, with
natural display not established. Thirty-nine keyboard
text labels in bank 55 now describe their T6/T78 page and character run; the
split rows remain PROBABLE where inferred from NUL/blank separators. These
static names do not claim independent display of every segment. See the
[keyboard text audit](docs/research/generic_data_name_audit_20261020.md#bank-55-keyboard-text-segments-2026-10-21).
Eight strings in the test configuration image, mail grid and mail-server
message area now use content/candidate names. Their exact Japanese/ASCII bytes
are retained; installer execution, independent mail-grid use and three blank
line readers remain unproven. See the
[small text-owner audit](docs/research/generic_data_name_audit_20261020.md#small-text-owners-test-image-mail-grid-and-server-messages-2026-10-21).
The 32 address-only labels in the bank-72 dialog owner now identify 23 text
payloads by their pointer-table index and nine remaining segments as
candidates by literal content/blank structure. Table index mapping is static;
natural selection and display remain unproven. See the
[dialog-string audit](docs/research/generic_data_name_audit_20261020.md#bank-72-dialog-text-anchors-2026-10-21).
The final neutral string, at `24:42E7`, is now
`String_Browser_CandidateGooPageTitle`: code at `24:42B0` copies it into
`wBrowserPageTitle` beside the `goo.ne.jp` URL. The destination relationship is
static evidence; natural routine entry and the literal's meaning remain
unproven.
Five bank-2C bytes in the mail-title editor now use candidate names describing
the literal `$C9` return bytes or `$C3,$72,$49,$C9` sequence. Their code/data
role remains HYPOTHESIS; the names do not claim execution or callers.
Four bank-2F spans in the address-book name editor now use candidate names for
three literal `$C9` bytes and one opcode-shaped byte span. Their code/data role
remains HYPOTHESIS; the names do not claim execution or callers.
Three bank-73 browser-start spans now distinguish a candidate attributes-plus-
unread-tail block, candidate tiles, and a confirmed object-animation script
tail. The first two remain candidates because their whole extents or consumers
are not established.
Three bank-25 spans in the mailbox owner now use candidate names for two
literal JP instructions and one opcode-shaped sequence. Their code/data role
remains HYPOTHESIS; the names do not claim execution or callers.
Three bank-27 spans in the send/receive owner now describe a candidate JR,
return opcode, and CALL/JP sequence. Encoded target addresses are documented,
but natural entry and execution remain unproved.
Two bank-71 settings-screen spans now use a candidate tile-fragment name and a
name for data confirmed read by executed code whose content remains unknown.
Two bank-2F address-editor spans now describe a candidate POP/compare/JR byte
sequence and a candidate RET opcode byte; entry into either span remains
unproved.
Two bank-2F address-book dispatcher bytes are named as candidate RET opcodes;
their code/data classification and reachability remain HYPOTHESIS.
Two bank-25 mailbox spans now say that executed code reads them while keeping
their content class unknown and their transfer boundaries explicit in docs.

The 2026-10-22 Bank 53/frame follow-up confirms that all 137 bank41–47 asset
blobs match the prior audited checkpoint and that the current 978-row graphics
catalog passes its exporter check. The PNG validation exposed stale generated
`gfx/png_rules.tsv` and `gfx/png.mk`; regenerating those manifests restored
`make png-check`. This confirms current declared PNG inputs and constraints,
not the unresolved 25 Pokémon-name/frame associations or the use of the eight
KEEP windows. See the [Bank 53 asset audit](docs/research/pokemon_names_bank53_asset_audit_20261020.md#reconciliation-after-graphics-label-updates-2026-10-22).

The 2026-10-22 maintained gfx-path scan found no `bankNN` directories and one
owner whose filename was only resource type plus bank/address. It is now
`gfx/mail/address_obj_hdma_bytes_copy_bank7f.asm`. Direct ROM comparison confirms its 720 bytes exactly equal `2D:7880–7B50`, the MailAddr OBJ HDMA source sequence. This identifies byte content only: no consumer/load for the physical `7F:7830` copy is established. See [the bounded duplicate audit](docs/research/gfx_7f_mailaddr_bytes_copy_20261023.md).

A later filename census found that the source-level result does not cover asset
basenames: after owner-aligned Page List, error-screen, browser-scrollbar,
ConnectDialog, MailView, MailSession, MailServer, CommTimeHMS, Mailbox Profile and TextCursor palette path updates, 80 type/address stems remain across 9 descriptive `gfx/` folders, covering 161
files. There are still no current `bankNN` directories. Of 100 logical payload
entries in that residual inventory, 99 have `gfx/assets.tsv` rows (75
CONFIRMED and 24 PROBABLE); the lexical pass did not revalidate their loaders
or visual roles. The `tiles_5860` files in Bank 4A are a documented byte-view of
sprite/script bytes, not tile art, and remain outside the active catalogue.
Resolve the other basenames owner by owner before renaming or treating any as
unused. See the [complete filename census](docs/research/gfx_generic_name_audit_20261021.md#japanese-typeaddress-asset-filename-census-2026-10-22).

The same current-tree reconciliation corrected a stale `gfx/assets.tsv` name
at `73:49E0` from `Data_73_49E0` to its existing source label
`BrowserStart_CandidateTiles_49E0`; its backing and PNG now use the candidate
name as well. The HYPOTHESIS/PROBABLE resource classification is unchanged.

The 2026-10-22 Bank 2C candidate address-screen graphics now have descriptive
paths for their static VRAM destinations, tilemap/attribute pair, and BG/OBJ
palettes. The asset bytes and confidence levels are unchanged; natural entry
and the intended screen role remain HYPOTHESIS. See the dated [Bank 2C
resource-path note](docs/research/address_book_candidate_screen_graphics_paths.md).


The 2026-10-22 Top Menu path pass replaced 21 address-only graphics filenames
with names based on confirmed VRAM destinations and map dimensions. All 21
renamed payload/preview files match their former Git blobs; the Japanese build
remains byte-identical. English remains paused and its old-path references were
not inspected. See the [Top Menu resource-path note](docs/research/top_menu_resource_paths_20261022.md).


The 2026-10-22 Japanese name census found zero address-form Function_*,
Func_*, Sub_*, or Label_* definitions and zero exact address-only Font_*,
Tiles_*, Tilemap_*, Palette_*, or Attrmap_* definitions in the safe maintained
source set. Fifteen neutral Data_BB_AAAA labels remain without a supported
replacement. A broader scan found 595 typed sprite-frame, frame-table, and
script labels. Two reviewed batches and one Address Picker structural batch had named 60; this pass names another 33 Save Sender Address frame/table/script labels by repeated entry groups, retaining candidate/confidence qualifiers. About 502 address-only sprite labels remain for owner-by-owner review; this count is a lexical naming census, not reachability. Address-based RAM definitions
whose lexical non-use does not prove they are unused also remain under review. See
the [Japanese naming follow-up](docs/research/japanese_name_and_gfx_path_followup_20261022.md).

The same follow-up names 17 additional Japanese graphics stems from direct
static consumers and VRAM/palette destinations. Payload hashes and confidence
cells are preserved; HelpMenu screen models remain HYPOTHESIS and palette
grouping remains PROBABLE. The 2026-10-22 Save Sender and Bank 4B evidence
update is recorded in the [sprite/data follow-up](docs/research/japanese_sprite_data_followup_20261022.md).

The 2026-10-22 `screen_ops.tsv` reconciliation regenerated all 917 operation
rows from current Japanese sources. All 917 file/line locators now resolve to
the corresponding loader call (including the five previously stale locator
groups); a second generation produced the same SHA-256. The 818 resolved and
99 unresolved operation payloads are unchanged, so this refresh updates source
locations only and does not resolve the table-driven calls.

## Bank 4B result-page candidate asset paths (2026-10-22)

The two PROBABLE result-page tile spans at `4B:5080` and `4B:5420` now use
owner-derived candidate filenames. Binary and PNG hashes are unchanged; the
maintained Japanese gfx census is now 78 address-only stems across eight
directories, with 97 catalog rows (75 CONFIRMED, 22 PROBABLE). This is a path
classification checkpoint, not proof of natural use or semantic closure. See
[the Bank 4B audit](docs/research/bank4b_result_page_indexed_tiles_20261021.md).


## Bank 7F browser prototype page-list candidate asset paths (2026-10-22)

The three page-list prototype tile sources at `7F:62B0`, `7F:66B0`, and
`7F:6AE0` now name their static VRAM/VBK destinations; the tilemap/attribute
pair and BG/OBJ palettes also use role-qualified candidate paths. Transfer and
source evidence is static in `PageListProto_InitScreen`; no natural-entry or
screen-meaning claim is made, and all seven rows remain PROBABLE. Raw and
payload hashes are preserved in the private PRE/POST manifests. The Japanese
address-only GFX filename census is now 72 stems across 7 directories and 147
files; 90 asset rows remain (75 CONFIRMED / 15 PROBABLE). This is a path and
classification checkpoint, not semantic closure. Details are in the
[dated GFX name audit](docs/research/gfx_generic_name_audit_20261021.md#bank-7f-browser-prototype-page-list-candidate-paths-2026-10-22).


## Bank 5D/5E account graphics paths (2026-10-22)

Twenty-eight address-only stems in the Japanese account/Login ID, mail,
password, confirmation, and registration-write-config resources now use
static owner and transfer-derived paths. The shared palette, nonzero
action-confirm branch, manual-confirm shared tiles, and split `5D:6C00` upload
are scoped in their names. All 34 payload catalog rows stay CONFIRMED and six
screen previews stay HYPOTHESIS. Three source files are shorter than their
static transfer requests; they were preserved at the original sizes. The 61
raw file hashes match the private PRE/POST manifests. The Japanese lexical GFX
filename census is now 44 address-only stems / 86 files in five directories,
with 56 catalog rows (41 CONFIRMED / 15 PROBABLE). See the [dated GFX audit](docs/research/gfx_generic_name_audit_20261021.md#bank-5d5e-account-graphics-path-mapping-2026-10-22).


## Japanese local-label checkpoint (2026-10-22)

The Mobile SDK, 15 sprite-counter routines, and inline image blitter now have
282 additional operation-named local labels, with 360 local branch references
updated. The `$75:418E` SDK target and the `$51:72D4`/`$51:7383` blitter targets
remain address-local because the evidence does not support more specific
names. The sprite-counter fallback is named `.use_default_entry`: it selects
the `Entry36` table item after the `$08` comparison and does not prove a digit
9 case. See the [pass report and exact mapping](docs/research/japanese_local_label_pass_20261022.md).

At the earlier body-editor/SDK checkpoint, the six-root lexical census counted
3,872 numeric local labels, ten exact `Data_BB_AAAA` labels retained as neutral,
and three correspondence-only spans without a semantic type claim. The later
`Browser_DrawTitleBar` review renamed `.l5225` to `.copy_title_bytes_to_buffer`,
so a fresh inventory at source commit `2d264633` starts at 3,871 address-only
local labels. No address-form Function/Func/Sub/Label/Font definitions were
found. The 2026-10-22 consolidated batch below renames 546 and explicitly
accounts for the remaining 3,325; this is inventory closure, not semantic
closure. The English overlay remains paused and was not modified.
## Consolidated generic local-label census (2026-10-22)

A complete six-root Japanese source inventory counted 3,871 address-only local labels (`.lAAAA`) across 333 maintained ASM/INC files, excluding protected mail sample data. A single reconciled batch reviewed and renamed 546 labels across HOME/audio/mobile library and engine subsystems. Independent review accepted all 546 final names: 542 as proposed and four after narrowing the claim to the exact static operation. The remaining 3,325 labels are categorized by owner as short cosmetic anchors or unresolved flow/data/phase boundaries; their presence means semantic naming is still open and the ROM is not declared 100% closed. The exact row-by-row map and confidence limits are in the [consolidated census report](docs/research/japanese_generic_name_census_batch_20261022.md) and [mapping TSV](docs/research/japanese_local_label_batch_mapping_20261022.tsv).

The ten previously reviewed `Data_BB_AAAA` spans remain neutral because source/byte review did not establish a supported type or role. The English overlay remains paused and untouched. Validation on the isolated Japanese worktree reported a byte-identical ROM, successful symbol/palette/PNG checks, and no non-token source changes.


## Complete short generic-label sweep (2026-10-23)

The exact local placeholders `.loop`, `.skip`, and `.done` were inventoried at baseline `883d10f` across 122 files (500 definitions). The earlier 99-owner-local renames and the final 401-entry review cover the entire baseline population. All 500 now have operational local names; all static-only naming confidence is `PROBABLE`. The complete definition/reference/rationale map is in [the full decision ledger](docs/research/japanese_short_label_full_decision_ledger_20261023.tsv), with the [baseline inventory](docs/research/japanese_short_label_candidate_inventory_20261023.tsv) retained for provenance. The independent high-effort reviewer checked all 401 remaining proposals against their complete owners; four semantic overclaims and two overly narrow names were corrected before application. No `.loop`, `.skip`, or `.done` definitions remain in the maintained Japanese ASM roots.

A source reconstruction check confirms all 122 files equal the `883d10f` baseline with only the 500 listed local-symbol substitutions. Validation after that historical batch: `make` returned `RESULT: IDENTICAL` against the protected ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; `make sym-check` passed (335 files, 12,185 labels, 51 constants); `make palette-check` passed (162 loads, 116 arrays, two documented over-reads, zero errors). A later comprehensive pass reviewed every 2,764 `.lAAAA` anchor then present, renamed 408 after independent semantic review, and retained 2,356 with individual evidence-limited reasons. The current status and full ledger are in the [generic-name sweep](docs/research/japanese_generic_name_sweep_20261023.md). Semantic closure remains open; these checks are not runtime or hardware evidence. The English translation stayed paused and untouched.


## Japanese finite closure status (2026-10-23)

This section supersedes earlier count-only summaries above for the finite scopes listed here. At source revision `b389b8eb` (documentation reconciliation `cbf78540`), the Japanese build remains byte-identical to the protected original. The current closure audit records the exact build, symbol, palette, PNG, GFX, name-census and test results: [Japanese closure audit](docs/research/japanese_closure_audit_20261023.md). The 15 lexical census families and their row ledgers are closed; this means their present definitions are inventoried and dispositioned, not that every function, data role or natural path is semantically understood.

A later bank-7C check confirms that all three font spans reconstruct the existing 846-cell PNG pixel-for-pixel; the 10-byte/80-pixel gap is historical and resolved in current source ([dated verification](docs/research/assets_pokemon_frames_and_name_limits.md#dated-verification-bank-7c-font-sheet-pixel-inverse-2026-10-23)).

A direct GDB watchpoint in the ordinary-input `kbd_abook` mGBA scenario captured one read at bank `48`, offset `69AB`, from PC `48:47D6` (`ld a,[bc]` in `Font_BlitGlyph8x16`). The runtime shadow return and original callsite bytes confirm this event came through `Kbd_DrawGlyphPreview`. The font-code argument, full historical aggregate attribution, zero-byte intent, global reachability and hardware behavior remain unknown; see the [bounded trace follow-up](docs/research/font_reader_69ab_bounds_20261020.md#direct-read-pc-witness-2026-10-23).

The finite Bank 53/frame pass found no missing referenced PNG or orphan asset in its stated scope. A later re-read of the 70 paired scenario coverage/data-access reports found no data-load range intersecting `53:4000–4171`; this bounded corpus result does not establish global absence or unused frames ([details and input digest](docs/research/bank53_names_frames_assets_audit_20261023.md#scenario-data-read-corpus-recheck-at-5e6d275)). All 25 name-to-window associations and natural selection remain unknown, and the two Porygon entries are unassigned. Eight editable compositions remain `KEEP` because the conditional view model lacks backing keys; they are not missing ROM bytes or referenced PNGs. Do not repeat the finite inventory unless its source set or scope changes.

A separate source-only direct-selector census at `7393820d` checked 333 maintained `.asm`/`.inc` files for immediate `$53` loads into A and external name-table symbols. All six immediate matches assign `hTextY` or `wSpriteSlot2`; no direct ROM-bank selection or external `PokemonName` symbol reference was found. A byte-pattern scan of the original ROM found 5,274 raw `FarCall` encodings and none whose inline bank byte is `$53` or whose target word is `$0540/$0545/$0551/$056A`; direct `FarJump`, `FarJumpTable`, and `JumpTableBank` call encodings were absent. These raw matches are not all verified instruction starts. Computed bank selection and indirect access remain open; this does not establish the names' frame associations or unused status ([source-scan scope and binary evidence](docs/research/bank53_names_frames_assets_audit_20261023.md#direct-bank-53-immediate-selector-census-at-7393820d-2026-10-23)).

The currently tracked operation entry/role questions include `2B:6CF5`, `2D:4E42/4E54`, `29:511E`, `70:4740`, and the local fragment `55:5DF5–5E02`; local mechanics have bounded names, while entry, caller, or purpose remains UNKNOWN/HYPOTHESIS as specified in the [operation-boundary worklist](docs/research/japanese_operation_boundary_worklist_20261023.tsv) and [entry follow-up](docs/research/japanese_entry_byte_construction_followup_20261023.md). The latest natural mail-reply trace did not execute any exact candidate bank/address pair or record a `call/rst/jphl` edge to one; same-address hits in other physical banks are excluded from candidate evidence ([bounded trace cross-check](docs/research/japanese_open_questions_followup_20261023.md#follow-up-against-the-subsequently-added-natural-mail-reply-trace)). Of the separate spans `26:5344–537C`, `28:4BA6–4BC2`, and `4B:76CC–76D0`, the first is already classified as the PROBABLE code fragment `MailSession_WriteVram1TileAndWram7ScreenRows`; only its natural entry and intended role remain HYPOTHESIS. The code/data identity of `28:4BA6–4BC2` and the purpose/use of `4B:76CC–76D0` remain unresolved. Their current 70-scenario corpus check found no exact instruction starts, direct call/rst/jphl edges, or overlapping data-read ranges; this does not prove global unreachability or non-use ([bounded result](docs/research/japanese_open_questions_followup_20261023.md#additional-codedata-spans-checked-against-the-retained-natural-corpus-at-1c9224e8)). Preserve these limits; promote claims only with positive caller, producer, trace, or other direct evidence.

The natural Japanese scenario `zz_jp_inbox_explore_replay` adds 117 instruction starts to the 69-scenario union: 74 in the bank-25 reply continuation, seven in the reply routine tail, and 36 in fragment `2D:6726–676F`. It records `25:4591 -> 25:54A7` twice and one `ret_unmatched 25:5568 -> 25:4594`; that anomaly does not establish a conventional return contract. A deterministic replay confirms the conditional edge `2D:66D3 -> 2D:6726` for three events: the branch executes three times, its fall-through `2D:66D5` never executes, and the target executes three times. The dialog call site at `2D:6740` is also reached three times. This is bounded synthetic-emulator evidence; screenshots do not show a modal prompt at the sampled frames. The `26:5344–537C` code fragment was not executed in this particular replay; the wider 70-scenario corpus also found no starts or direct edges there. Its static code classification is PROBABLE, while entry and intended role remain unresolved. Details and replay limits are in [the natural mail-reply trace note](docs/research/japanese_natural_mail_reply_trace_20261023.md). The English translation remains paused.
A separate natural UI route from the saved `mail_receive` state opened the third mailbox record and selected Reply; the trace records `25:4591 -> 25:54A7` once and captures the reply-address screen. This confirms that route for one additional record only; `2B:6CF5` remains unresolved. Evidence and limits: [third-record follow-up](docs/research/japanese_natural_mail_reply_trace_20261023.md#third-record-reply-route-2026-10-23).

The generic-name sweep reports zero strict address-only global names and zero bare `bankNN/` GFX directories or address-only asset basenames in its defined source set. It does not certify complete semantics for all retained candidate, local, or owner-qualified names; see [the current generic-name sweep](docs/research/japanese_generic_name_sweep_20261023.md). English translation and ZIP reuse remain paused until the Japanese review is complete and the Operator gives explicit new approval.

At published revision `b130cb555400f171bea0cd6b719dfb552540e55b`, a new bounded source-path audit checked the sprite-hook callback producers, the text/mail/CommScene indexed dispatchers, and the current mapper's 34 decoded indirect-transfer sites. Only `70:40AC` falls in candidate physical banks `29/2B/2D/70`; its complete CommScene state table does not select `70:4740`. No inline `call $0545` / `$056A` table belongs to those four banks. This does not prove global unreachability: the candidate entries remain UNKNOWN for natural entry, with existing operation names and evidence limits. The bank-2B code-span note at `69C5–6CF5` is exclusive at `6CF5`; the bytes at `2B:6735` (`CD C5 69`) call `MailView_DrawTextLine20` at `2B:69C5`, not `MailReply_ComposeFromRecord` at `2B:6CF5`. See the [bounded sprite-hook, dispatch, and candidate-bank audit](docs/research/japanese_sprite_hook_root_audit_20261024.md). No English/ZIP work was resumed.

**Japanese finite-audit revalidation at source checkpoint `25501d4b` (2026-10-24).** The 349-file name census passes all 15/15 families with zero open rows: 2,764 local anchors, 106 strict bank/address-suffix entries, 540 broad dispositions and 786 RAM equates; all ledgers reconcile without missing, stale, duplicate or incomplete rows. Strict `Function_<bank>_<address>`, `Data_<bank>_<address>`, and `Font_<bank>_<address>` labels are absent, as are `Function_` labels, bare GFX `bankNN` directories, and address-only asset basenames. All 264 mapper candidate spans are covered by 104 current linked sections; 187 contain symbol starts and 77 are bounded by adjacent same-bank symbols. Current gates pass: `make` is `RESULT: IDENTICAL`, `sym-check` 335/12,214/51, `palette-check` 162/116/2/0, `png-check` 418/4/37/95, GFX export 988 assets, PNG rules 987, and `make test` all suites passed. The finite Bank 53/artwork inventory found no missing referenced PNG or orphan asset. This closes the current verifiable census and inventory scopes; it does not close global code semantics or natural reachability. Five listed function-root questions and the separate local fragment `55:5DF5`, three code/data spans, Bank 53 name-to-window associations (including both Porygon entries), and global used/unused status remain UNKNOWN/HYPOTHESIS as documented. English/ZIP work remains paused until the Operator gives explicit approval.

**Japanese indirect-entry boundary review (2026-10-24; source base `dd004b92`, docs HEAD `6e2a5437`).** Three bounded static reviews plus original-ROM slice checks examined sprite stack-hook callbacks, indexed Bank 70 dispatch, far-call/jump-table/WRAM stub routes, a keyboard fragment, three auxiliary spans, and the Bank 4B zero record. The actual `00:0B36–0B53` trampoline is now documented; the 15 examined textual hook producers use only five target pairs, with other buffer transports still limiting global conclusions. No positive producer/natural root was found for the remaining candidates; the valid `67:53D6` selector has only three entries and does not select `4B:76CC`. These results narrow specific mechanisms only: natural entry/purpose for the listed candidate operations, global use of the zero record, and global frame-unused status remain unproved. Japanese closure is not 100%; English/ZIP remains paused. See [the bounded indirect-entry and boundary review](docs/research/japanese_indirect_entry_boundary_review_20261024.md).


**Historical Japanese final-gate recheck at docs HEAD `a88a540e` (2026-10-24).** `make` is `RESULT: IDENTICAL` to the protected 2 MiB original; sym-check is 335/12,214/51, palette-check 162/116/2/0, png-check 418/4/37/95, GFX catalog 988, PNG rules 987, and `make test` exits 0 (with the known non-fatal `ResourceWarning`). The Japanese name census passes 15/15 families with 2,764 local, 106 strict suffix, 540 broad disposition and 786 RAM rows; no strict generic function/address names, unreviewed generic markers or bare `gfx/bankNN` paths remain. `mapper.py --check` reports 78,108 executed starts with zero missing starts, sweep failures, boundary crossings or tiling problems. These finite gates do not prove all semantics: candidate natural roots, Bank 53 name/frame links, the two Porygon assignments and global frame-use status remain unresolved as documented. Bank 53 asset-presence work is closed for its audited scope; do not repeat it without new evidence. English/ZIP remains paused. See the [Japanese closure audit](docs/research/japanese_closure_audit_20261023.md).

## Natural mailbox coverage and name-ledger correction (2026-10-24)

At source checkpoint `07b0c0dd`, the new natural-button scenario `zzzz_mailbox_cursor_count` deterministically executes six starts at `25:491B–4925` and reaches `25:4929`; the jump at `25:4927` remains unobserved. The scenario and its input macro are now in the retained trace corpus. It sorts after existing scenarios to preserve their union indexes. Rebuilding the natural coverage union yields 78,128 unique instruction starts with zero decoder errors. A cross-bank coverage reconciliation promotes three fully executed ranges and splits three partly executed ranges into nine evidence-accurate pieces; see the current [Japanese closure audit](docs/research/japanese_closure_audit_20261023.md#natural-mailbox-coverage-and-full-name-ledger-reconciliation-2026-10-24). The source change only corrects a stale coverage comment; byte identity is verified separately by the build gate.

The full name census also caught a missed current row for `Padding_BmpValidateEntryAlignment_51_70D1`. Both ledgers and the coverage matrix now match: 107 bank/address-suffix rows, 540 broad dispositions, and all 15 census families pass with zero missing/stale/duplicate/incomplete rows. This label describes the owner and bytes, while its alignment interpretation remains PROBABLE and its exact use unknown. Japanese semantic closure is still incomplete: the five natural-entry questions, `55:5DF5`, unresolved auxiliary spans, Bank 53 name/frame associations, natural frame selection, Porygon assignments and global frame-use status remain open. English/ZIP remains paused pending explicit Operator approval.


## Consolidated Japanese residual work (2026-10-24)

The concern about repeated micro-surveys is addressed by one merged matrix in the [Japanese closure audit](docs/research/japanese_remaining_semantics_batch_20261024.md), based on three independent, read-only, disjoint-scope reviews at cc2d80ac17a741a7507b4d3fc7c9d98a0ff2a893. The complete generic-name census is closed for its declared 15 families (zero generic function prefixes, zero bare gfx/bankNN paths, and all ledgers reconciled: 2,764 local anchors, 107 suffix rows, 546 broad dispositions (441 address-suffix labels, 268 Candidate labels, 163 overlaps), 786 RAM rows). At this verification, `mapper.py --check` reported 78,114 executed starts with zero missing starts, sweep failures, boundary crossings or tiling problems. The Japanese ROM is **not** 100% semantically closed. At the current documentation checkpoint, `data_consumers.py --stats` recognizes zero neutral data groups under its exact `Data/Table/String/Tiles/Tilemap/Attrmap/Palette/Font_BB_AAAA` pattern; this remains distinct from semantic closure.

The remaining work is grouped by evidence path: seven GFX spans / 82 bytes whose exact bytes and owners are known but consumers remain unconfirmed; six Bank 42 starts align with preceding catalogued 16-byte tile boundaries, which does not prove that subsequent bytes are tiles; five natural-entry candidates whose local mechanics are already named and partly CONFIRMED but roots or roles remain unknown; one keyboard fragment; three auxiliary spans; 25 Bank 53 name-to-window associations (including two unassigned Porygon rows and conflicting Pikachu/Pichu hypotheses); natural frame selection; and global used/unused status. No mass rename, new PNG, or semantic promotion is justified by the current evidence. Reopen only on distinct positive consumers, producers, natural traces, or a source-complete selector census.

The 2026-10-24 follow-up added a distinct static comparison for `28:4BA6`: eight bytes match the active OAM-clear loop body, but the candidate clears a shorter OAM interval and fills a larger WRAM span without the active reset's preservation/restoration behavior. A whole-ROM scan found no exact 28-byte clone elsewhere. These results support only a reset-like HYPOTHESIS, not a function identity or entry; the exact-clone receipt is documented in the [consolidated residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#whole-rom-exact-clone-check-of-28-4ba6). A whole-source scan of bank-42 resource operands also found no explicit `BANK(...)` selection or external owner-label reference, but its indirect bank arguments and 99 unresolved `screen_ops.tsv` rows remain open, so the six bank-42 tails cannot be called unused. See [the indirect-entry review](docs/research/japanese_indirect_entry_boundary_review_20261024.md) and [the consolidated matrix](docs/research/japanese_remaining_semantics_batch_20261024.md).

Corpus scope is explicit: the 70-scenario / 78,122-start manifest 9c784734fb895133f4ea822e6a2934c98c9318e751a414c88966de1c5e6dd1b3 belongs to the negative check for the three auxiliary spans; it does not define every natural-root scan, whose evidence retains its own scope. The mailbox scenario brings the current union to 78,128 starts. The focused mailbox delta was processed and extended that negative check; future additions should reconcile only new-input coverage, callgraph, and dataaccess outputs rather than repeat prior inputs. Current gates on the canonical checkout pass: make is RESULT: IDENTICAL; sym-check passes 335 sources / 12,221 labels / 51 constants; palette-check passes 162 loads / 116 arrays / two documented over-reads / zero errors. English/ZIP remains paused.


**Auxiliary-span corpus delta (2026-10-24).** The prior 70-scenario negative result for 26:5344–537C, 28:4BA6–4BC2, and 4B:76CC–76D0 was extended by processing only the new zzzz_mailbox_cursor_count coverage, callgraph and dataaccess artifacts. The current union has 71 scenarios / 78,128 instruction starts; no starts, direct call/rst/jphl edges, or intersecting ROM data reads were found in those three spans. This finite result does not update the separate natural-root scans or prove global unreachability/use. The checker and hashed receipt are retained in .tmp/jp-open-span-corpus-audit-20261023/ and detailed in [the open-question follow-up](docs/research/japanese_open_questions_followup_20261023.md#incremental-check-of-the-only-added-scenario-for-the-three-auxiliary-spans-2026-10-24).

**Current Bank 28 classification at source checkpoint `508ac738` (2026-10-24).** The source label at `gfx/mail/body_view.asm:72` is `ClearWram0AndFillWram7WithFF`. Its complete instruction sequence clears WRAM0 `$C000–$C08F`, selects WRAM bank 7, fills `$DA00–$DAFF` with `$FF`, and returns; this supports **PROBABLE code**. This supersedes older statements above and in dated notes that retain `WramClearCandidate_28_4BA6` or call code/data identity HYPOTHESIS. Entry, caller, intended purpose and natural use remain UNKNOWN. A later classification of all 34 unresolved indirect-transfer sites found no non-sprite physical Bank 28 route in the decoded mapper inventory; the WRAM-driven sprite callback remains the only explicit bank-changing transfer, with arbitrary computed slot aliases unresolved. This does not exclude copied code, unrecognized transfers, or computed data reads. See the [consolidated residual matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#complete-classification-of-the-34-unresolved-indirect-transfers). The Japanese review remains open; English/ZIP remains paused pending explicit approval.

**Generic-name ledger reconciliation at census checkpoint `2a77411a` (2026-10-24).** The source reclassification in `3261f72f` retired `WramClearCandidate_28_4BA6` in favor of `ClearWram0AndFillWram7WithFF`; the old row was consequently stale in both generic-name ledgers. After removing that obsolete lexical disposition and updating the coverage matrix, the 349-file census reports 106 bank/address-suffix names, 440 broad address-suffix names, 267 `Candidate` names, and 545 union rows (162 overlaps). The detailed ledgers match the live source. The path audit now separately checks bare `bankNN` and `bankNN_...` basenames across active source/resource roots for physical banks 00–7F; the current count is zero. The ordinary file `ram/banked.asm` is excluded as a false positive because `ED` is outside that physical-bank range. The Bank 28 code classification remains PROBABLE, while entry and purpose remain unresolved. Reproduction: `python3 tools/japanese_name_census.py --generic-list`; this is a bounded lexical/ledger result, not closure of all function semantics.

**Residual-ledger refresh at Japanese HEAD `0dd05ed2` (2026-10-24).** The [consolidated matrix](docs/research/japanese_remaining_semantics_batch_20261024.md) now includes bounded follow-ups that postdate the earlier closure summaries above: the 71-scenario projection over 33 candidate intervals; the 7,022-case dispatcher projection and corrected writable-stack precondition; the classified Bank 28 reader/alias routes and Bank 26 sprite-hook, mapper and literal-target routes; the explicit Bank 53 name-consumer census; and the result-page banner-kind producer domain. These are scoped static or retained-trace results, not universal reachability or unused proofs. In particular, all 25 Bank 53 name-to-frame links remain HYPOTHESIS, eight editable compositions remain KEEP for missing VRAM placement evidence, and no frame or ROM interval is globally classified unused. The six Bank 42 tail candidates have exact 16-byte PNGs, but their natural consumer/phase remains unconfirmed; `Account_ResultPage_LoadBanner` can reach `42:5F00–6180` for out-of-domain inputs, while the 11 declared callers supply only kinds 0–4 and variants 0–2. Five natural-entry candidates, the keyboard fragment and auxiliary spans still lack a newly established natural root/use. The latest canonical-checkout gate result recorded at this checkpoint is: `make` SHA-256 OK / RESULT IDENTICAL; `make sym-check` 335 files / 12,223 labels / 51 constants; `make palette-check` 162 loads / 116 arrays / 2 documented over-reads / 0 errors; `make png-check` 424 tile sheets / 4 raw views / 37 font sheets / 95 screen PNGs. No English/ZIP work was resumed. Treat the dated matrix and its receipts as the detailed evidence; do not repeat a closed finite scan without new source, scope or positive evidence.

**HTML image-list boundary at Japanese HEAD `5b83847c` (2026-10-24).** The 28 HTML/browser helper rows are now grouped by their initialized source, text-stream, record and resource producers in the [current helper matrix](docs/research/japanese_bank_helper_calls_20261024.tsv). A natural browser-driven mGBA scenario with synthetic HTTP and a 3,612-byte page reaches 257 distinct `<img>` tags: 256 URLs are stored, insertion 256 writes the terminator at `E000–E001` outside `W4:DE00–DFFF` (echoing the first shadow-OAM bytes), and insertion 257 is rejected. Thirty-one image requests then complete before the existing SRAM resource-capacity guard stops the chain. `Sprite_ClearShadowOAM` clears the affected shadow bytes two frames later; no lasting visual effect is claimed. This does not establish natural roots for remaining candidates, any Pokémon/frame association, or global used/unused status. The exact limits and receipt hashes are in the [HTML image-list note](docs/research/japanese_html_img_list_limit_20261024.md) and `.tmp/jp-html-img-list-limit-20261024/`. The Japanese source comment now reflects the measured 256-entry boundary. Validation: `make` SHA-256 OK / `RESULT: IDENTICAL`; `make sym-check` 12,224 labels / 51 constants; `make palette-check` 162 loads / 116 arrays / 2 documented over-reads / 0 errors. Commit `5b83847c` is published on `main`; English/ZIP remains paused.

**Full-byte Ghidra reference projection at Japanese HEAD `55eeee57` (2026-10-24).** A fresh read-only query checked every byte in the Bank 53 table/string block (369 bytes) and the 25 frame-candidate windows (85,200 bytes) against the retained region-seeded Ghidra program: zero represented references were found in either scope. This widens the earlier Bank 53 Ghidra query to every string byte and all candidate windows. It remains HYPOTHESIS-only: computed/register-built addresses, runtime copies and gaps in the Ghidra analysis remain outside this query; no global non-use or Pokémon-name/frame association is established. Details and reproduction receipt are in [the current residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#full-byte-ghidra-reference-projection-2026-10-24) and `.tmp/jp-bank53-full-block-xref-20261024/`. The Japanese source and ROM are unchanged, and English/ZIP remains paused.

**Text-renderer source-domain census (2026-10-24).** A 333-file maintained ASM/INC scan found 105 direct text-renderer calls. All 58 `BANK(symbol)` operands (51 distinct symbols) resolve outside Bank 53; the two dynamic renderer bank reads are ticker paths whose six callers select only header banks 73, 6A, 1D or 1E. This narrows one generic reader path but does not prove global non-use or a Pokémon-name/frame link. Evidence and limits are in the [residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#text-renderer-bank-domain-census-2026-10-24); English/ZIP remains paused.

**Direct far-byte reader census (2026-10-24).** All 90 maintained direct `ReadByteFar` sites have explicit bank inputs; the 25 dynamic register/RAM cases resolve to the connect dialog, dictionary, ticker, checksum, and bounded text-render producers. None selects Bank 53 for a ROM read. This remains a source-scoped result and does not prove global non-use or frame association; see the [residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#direct-readbytefar-bank-source-census-2026-10-24). English/ZIP remains paused.

**HTML parser-generated bank domains (2026-10-24).** The two direct `Html_ParseSource` callers supply SRAM bank 3; parser metadata/line records use WRAM bank 4; generated text records store WRAM bank 5; `<img src>` resource records use SRAM bank 3. These parser-generated producers do not select ROMX Bank 53. Other readers and indirect paths remain open. Evidence and scope: [residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#html-parser-and-text-record-bank-domain-2026-10-24).

**Font blitter bank inputs (2026-10-24).** Both `BankSwitch_H` sites in `Font_BlitGlyph8x16` are destination WRAM selections for all five maintained direct callers: the three text-tile renderers use WRAM 2/3/7; keyboard preview and help-script destinations use WRAM 3. The corresponding rows in the bank-helper matrix are closed for this producer domain. See the [residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#font-blitter-destination-bank-producer-domain-2026-10-24).

**Literal entry encodings for the two residual candidates (2026-10-24).** The hash-pinned byte scan found no direct absolute transfer, inline farcall, exact bank/address pointer or owner-bank relative `JR` into `4E:47EB` or `48:4A8C`. The sole raw `$4A8C` immediate belongs to a bank-22 string at `22:4A8C`, not the bank-48 code address. Computed/indirect entry remains unproven; neither candidate is classified unused. Evidence: [residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#literal-entry-encodings-for-the-two-bank-switch-candidates-2026-10-24).

**Indirect-transfer cross-check for the two residual candidates (2026-10-24).** A byte-validated pass checked all 34 currently decoded `JP HL`/`push;ret` sites against `4E:47EB` and `48:4A8C`, including the complete 256-byte index domain of the `4E:589A` browser dispatch; no target matches either candidate. The separate sprite callback remains WRAM-driven, and its 15 declared setter calls do not include either candidate. This narrows the current decoded indirect-transfer inventory only; arbitrary callback-field mutation, copied code, unrecognized flow and data readers remain open. Neither entry/use is declared globally unreachable or unused. Evidence and limits: [residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#computed-transfer-cross-check-for-both-candidates-2026-10-24) and `.tmp/jp-indirect-two-entry-crosscheck-20261024/`.

**Bank 53 name/frame direct-symbol matrix (2026-10-24).** A grouped 349-source scan found zero external source references to the 26 Bank 53 name symbols and zero external references to the 104 labeled assets inside all 25 candidate frame windows. Together with the bounded browser descriptor-selector projection, the maintained direct-symbol graph has no name-to-window chain and the modeled selector chooses Bank 47 assets only. Raw/computed pointers, generic RAM/SRAM descriptors, copied data and global use remain outside the claim; Pokémon/frame identities stay HYPOTHESIS and no asset is marked unused. See the [Bank 53/frame revalidation](docs/research/japanese_frame_bank53_revalidation_20261024.md#current-direct-symbol-consumer-matrix-2026-10-24) and `.tmp/jp-frame-name-consumer-matrix-20261024/`.

**Browser frame-selector producer domain (2026-10-24).** All 27 declared table entries (0–26) resolve to five Bank 4E descriptors whose source fields select ROM47. The 101 out-of-domain indices include seven that point into WRAM, but the known direct callers either validate/reset persisted styles to 1–26 or overwrite them with 0 before dispatch; the preview chooser remains without a caller. This is a bounded static producer result, not a claim against corrupted SRAM, aliases or hidden indirect flow. Receipt: [selector domain and RAM descriptors](docs/research/japanese_remaining_semantics_batch_20261024.md#browser-frame-selector-domain-and-ram-descriptor-route-2026-10-24), `.tmp/jp-browser-frame-selector-domain-20261024/`.

**Trampoline-projection diagnostic triage (2026-10-24).** The retained 1,794 diagnostics are 1,791 typed sprite/audio data macros, one HRAM `LOAD` image boundary and two HRAM-as-ROM decode mismatches; all 30 expression misses resolve to exact WRAM/SRAM address words. They are not missing executable instructions. This removes the diagnostic-count objection, while candidate natural entry and whole-source completeness remain open. See [the triage note](docs/research/japanese_remaining_semantics_batch_20261024.md#triage-of-trampoline-projection-diagnostics-2026-10-24) and `.tmp/jp-trampoline-projection-delta-20261024/`.

**Five candidate root transfer census (2026-10-24).** The retained 104,207-entry instruction index has zero external same-bank near transfers and zero ROM0 direct transfers into the four candidate spans; the 5,290-row explicit far-call inventory and 7,022 inline-dispatch cases also have zero targets there. All 34 indirect transfers from the retained mapper report were classified: the Bank 70 dispatcher at `70:40AC` selects only state handlers through `70:449D`; no indirect site in Banks 2B, 2D, or 29 can target those physical banks under its mapped-bank contract. The ROM0 `JumpTableInline` site `00:0550` is covered by the 7,022-case matrix; `00:0EEF` is the fixed-ROM0 text-handler dispatcher. This closes those enumerated control-transfer domains, not copied code, arbitrary RAM aliases or unmodeled mapper state; natural reachability remains UNKNOWN. See the [candidate transfer census](docs/research/japanese_remaining_semantics_batch_20261024.md#candidate-direct-and-indirect-transfer-census-2026-10-24) and `.tmp/jp-candidate-indirect-entry-census-20261024/`.

**72-scenario mapper refresh for candidate cross-check (2026-10-24).** A fresh `tools/mapper.py` run against all 72 retained data-access scenarios found the same 34 indirect transfer sites and passed mapper validation with zero missing executed starts, sweep failures, boundary crossings or tiling problems. Its full private output is preserved in `.tmp/jp-current-mapper-recheck-20261024/` and powers the updated two-candidate cross-check. The tracked `analysis/mapper/` generation remains the 18-scenario review snapshot because its handwritten sample audit is bound to that older population; do not treat that tracked report as current scenario coverage. See [the residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#computed-transfer-cross-check-for-both-candidates-2026-10-24).

**Computed reader domains reconciled for Bank 53 names and frame candidates (2026-10-24).** The 42 direct HTML/browser `BankSwitch_H/D` sites previously marked as needing pointer invariants now map, under documented parser outputs, to SRAM 3 page/image data or WRAM 4/5 records and text; the URL list uses WRAM 4. The full ROMX-owned switch census accounts for 57 sites: these 42, five fixed RAM paths, six history/cache sites in SRAM, two WRAM font destinations, and the two unrooted candidate helpers themselves. Separately, all 90 direct `ReadByteFar` inputs and 105 text-renderer inputs were reviewed; no Bank 53 ROM source was found. This closes those direct producer domains but not arbitrary corruption, copied data/code, unknown readers or global non-use. No natural name-to-frame producer or root for `4E:47EB` / `48:4A8C` has been identified; do not claim global unused or unreachable status. Evidence and precise scope: [the residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#computed-reader-domain-reconciliation-for-the-nameframe-candidates-2026-10-24).

**Built-in HTML store reader domain (2026-10-24).** A separate audit covers the manual bank-switch path in `HtmlStore_BuildPageUrl`/`HtmlStore_LoadPage`: all 55 far-pointer targets in `3F:4012–40B7` resolve to physical banks `3D` or `3E`, and all 61 Mobile Dictionary category indices are within `0–54`. The normal dictionary route establishes SRAM bank 3 for page-request data; the fixed table-driven route cannot select Bank 53 or candidate windows in Banks 41–47. This closes that route without establishing global non-use. Source/ROM pins and receipt: [residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#built-in-html-store-reader-domain-2026-10-24), `.tmp/jp-html-store-bank-domain-20261024/`.

**Manual glyph-reader bank domain (2026-10-24).** Exhaustive checking of all 65,536 16-bit glyph inputs against the font-validity bitmap and row tables shows that maintained wide-glyph reads select only Banks 76–7E, while ASCII glyph copies select Bank 76. This closes those direct glyph paths against the Bank 53/name and frame-candidate ranges; `Glyph_CopyToLeftBuf` remains a separate no-static-caller generic copier outside this result. Reproduction and hashes: [residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#manual-glyph-reader-bank-domain-2026-10-24), `.tmp/jp-glyph-manual-bank-domain-20261024/`.

**Sprite object-table input census (2026-10-24).** All 712 direct `Sprite_InitSlot` callsites in the maintained assembly roots resolve to symbolic object tables; none selects a table in physical Bank 41–47 or Bank 53. This closes only direct object-table selection, not dynamic pointers, computed dispatch, or graphic DMA routes, and does not establish Pokémon-name/frame links or global asset use. Reproduction and limits: [residual semantics matrix](docs/research/japanese_remaining_semantics_batch_20261024.md#sprite-object-table-reader-domain-2026-10-24).


**Explicit MBC writer inventory (2026-10-24).** A full maintained-source pass located 55 explicit MBC register writes across 27 function owners. The paths partition into the reader families already bounded by the residual matrix, fixed boot/SDK/string domains, and a small set of generic or candidate helpers without a direct lexical caller. This is not a source-complete global reader proof. See the [inventory and retained limits](docs/research/japanese_remaining_semantics_batch_20261024.md#explicit-mbc-register-writer-inventory-2026-10-24).


**Current source reconciliation of the screen-loader matrix (2026-10-24).** Replaying the current extractor in memory accounts for all 917 named graphics loader operations by routine/file/type order; 74 stored line locators per side are stale. Its 818 statically resolved source ranges do not overlap the 25 candidate windows or Bank 53; the 99 unresolved operations remain covered by the existing grouped audit and its conditional-case limits. See the [source reconciliation](docs/research/japanese_remaining_semantics_batch_20261024.md#current-source-reconciliation-of-the-screen-loader-matrix-2026-10-24).

**Declared RAM execution, interrupt-vector, and sprite-callback routes (2026-10-24).** The retained 72-scenario report has 14 RAM instruction starts; a maintained-source audit found one `LOAD` image (OAM DMA at HRAM `$FF80`), the fixed far-call trampoline, five files with explicit vector stores/restores, 15 direct `Sprite_SetHook` callsites, and six direct raw callback-field clears to `$FF`. `Sprite_InitSlot` zeroes callback fields; slot backup copies preserve all 224 bytes. The vector and active callback targets resolve outside the candidate spans; ticker's `$C133` VBlank chain saves/chains/restores the previous vector. The generic caller-supplied `00:0A2A` store helper has no lexical direct caller. This bounds inventoried routes only; arbitrary computed writes and corrupted state remain open. See the [RAM execution census](docs/research/japanese_remaining_semantics_batch_20261024.md#ram-execution-and-interrupt-vector-route-census-2026-10-24) and `.tmp/jp-ram-execution-dispatch-census-20261024/`.

**Generic copy-helper source operands (2026-10-24).** Replayed the 333-source/311-callsite census (excluding protected `engine/mail/sample_data.asm`); no directly resolved symbolic `HL` source overlaps the nine catalogued candidate spans. 77 sites remain derived lexical inputs, so computed/stack arguments and handwritten readers remain open. See the [bounded callsite census](docs/research/japanese_remaining_semantics_batch_20261024.md#generic-rom-copy-reader-callsite-census-2026-10-24) and `.tmp/jp-reader-census-20261024/`.

**Generic copy destinations (2026-10-24).** A bounded nearest-`DE` pass resolves 188 direct destination setups to WRAM/echo, SRAM, or VRAM; three low numeric operands resolve through `MailRecord_GetFreeSlotPtr` to SRAM0 record fields, not MBC registers. A separate 100-site `MobileAPI` call census resolves both `$38` calls (`MobileAPI_ReadConfig`) to `sConfigImage` in SRAM2, which is the dynamic `wMobileSDK_DestPointer` producer. 120 of 311 sites still inherit DE and remain unclassified by the local copy-call pass. See the [destination reconciliation](docs/research/japanese_remaining_semantics_batch_20261024.md#generic-copy-destination-reconciliation-2026-10-24) and `.tmp/jp-copy-destination-reconciliation-20261024/`.
