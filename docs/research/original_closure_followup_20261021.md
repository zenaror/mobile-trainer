# Original-ROM closure follow-up — 2026-10-21

This is a current-source checkpoint, not a claim that the Japanese ROM is
semantically complete. The original ROM remains byte-identical after the
changes below. English work remains paused pending explicit Operator
confirmation.

## Reviewed entry candidates

Independent review accepted the bounded static reports for 2B:6CF5,
6C:61AC, 29:5090–5376, 2D:4E42/4E54 and 55:5DF5/6EEC. These reviews verify
the cited local mechanics and the limits of each report; they do not prove a
natural entry, original intent, or universal absence of callers. The bank29
path/prefix recommendation is separate from its entry conclusion. Its
historical `50 graphs / 19 missing / 189 opcode patterns` counts were
reconciled against the current 69 coverage/dataaccess/callgraph files and the
expanded 323-pattern scan before the owner was renamed. The current source
header reflects the finite current corpus; neither count proves universal
non-use.

A new path-safe static reconciliation after checkpoint `fa58ee1e` rechecked
the four still-UNKNOWN natural-entry cases: `2B:6CF5`, `2D:4E42/4E54` and
`29:511E`. It confirmed only the internal CALL edges `2D:4E49 -> 4E54` and
`29:50CE -> 511E`; these do not establish a natural root. The helper at
`2D:4E54` starts with `SP=H`, but via its wrapper `SP=W-4`, leaving `4E4C`,
saved BC and the outer return on the stack. The `2B:6CF5` success path uses
`S+8` while cancellation uses `S`; `29:511E`'s selected call does not prove
bank `7D`, and the bank29 padding window is zero-filled. Each entry remains
**UNKNOWN** pending a real producer of its stack/bank state or caller. The
scan reconciled 347 guarded source inputs to current `main` `2d73ecad`, with
319 exact matches and 28 differences limited to comments, blank lines or
global labels; 104,200 earlier indexed records still matched original bytes.
No source, build, runtime or trace changed. The retained read-only report is
`.tmp/agent-entry-return-reconcile-20261021/REPORT.md` (SHA-256
`6f5f920ae3df5698496d799b9ca4e8516061e589f59b0075d9e3bfdb24a1e854`), with
`RESULT.json` recording its input hashes.

The existing dynamic-trace inventory separately lists `2B:6CF5` and the
`29:5117–5335` palette-fade library interval as forced-only in
`docs/research/dynamic_tracing.md` §11.4. Those forced runs do not supply a
natural caller or resolve the stack/bank frontiers; the four entry questions
remain UNKNOWN. No new natural trace record was found in the bounded evidence
review.

## Current naming changes

The bounded owner-local review of `engine/mail/mail_title_entry.asm` kept
`Data_2C_47CA`, `Data_2C_487D`, `Data_2C_493E` and `Data_2C_49E8` neutral:
each is a single `$C9` byte at a text/code boundary, and the bounded source
search found no direct consumer. `Data_2C_4A01` begins `$C3,$72,$49,$C9` and
decodes linearly as `JP $4972 ; RET`, targeting `MailTitle_KeyboardLoop`;
the bounded source search found no direct entry to 4A01. This is not proof
that the byte sequence is code or universally unreachable; the mapper's
code-prefix-like classification is not enough to promote it. These labels
remain **HYPOTHESIS** pending stronger entry evidence.

In `engine/keyboard/keyboard.asm`, four exact co-located `Data_55_*` aliases
at 55:62A0, 65D7, 66C0 and 6C0A were retired. Their retained labels
`Table_Kbd_CursorSpriteOrigin`, `Table_Kbd_InputModeReturnCodes`,
`Table_Kbd_PickerSpritePositions` and `Table_Kbd_PickerTabTilePtrs` are the
names used by the code. The references in `ram/wram.asm`, current naming notes
and current naming notes now use those labels; the active `data_consumers`
generator no longer proposes these already-named blocks. The restricted
six-root census is 187 `Data_BB_AAAA`/`Font_BB_AAAA` definitions across 110
owners; `engine/mail/sample_data.asm` and `languages/` were excluded before
content reads. `sym-check` and `data_consumers.py` now exclude the protected
mail sample source; `sym-check` reconciles its symbols using only the linker
map section, without opening the source. Because changing `ram/wram.asm`'s
comment invalidated every RGBASM object, the Japanese build was attempted with
Make's `-o build/engine/mail/sample_data.o` override to reuse the previously
verified object. A Make restart after dependency regeneration nevertheless
ran RGBASM on the protected source. The source was not changed, its contents
were not printed or semantically inspected, and the resulting ROM still
compares byte-for-byte. The source-only `sym-check` and `data_consumers.py`
scans now exclude it; `sym-check` uses the corresponding linker-map section
for symbol reconciliation. No confidence grades changed.

In `engine/keyboard/type_helpers.asm`, four exact co-located `Data_55_*`
aliases at 55:6EB5, 6ECB, 6FC7 and 6FF4 were retired. Their retained labels
`Table_Kbd_Mode2DefaultCursorFlag_ByType`,
`Table_Kbd_ArgCDefaultCursorFlag_ByType`,
`Table_Kbd_RejectSymbol_Chars` and
`Table_Kbd_MarkerSpritePositions` already name the same bytes and are the
operands used by the readers. A source search found no active references to
the duplicate exports outside their definitions; frozen config and analysis
artifacts retain historical spellings. This removes generic aliases only and
changes no bytes or confidence. The two cursor-flag tables retain PROBABLE
whole-storage status (7/11 and 10/11 bytes read); the reject-symbol list has
CONFIRMED reads but its broader content class is not promoted; marker
positions remain PROBABLE as a whole.
The restricted six-root census is now 191 `Data_BB_AAAA`/`Font_BB_AAAA`
definitions across 111 owners (down from 195/112), still excluding the
protected mail sample and `languages/`; frozen xref/config snapshots are not
regenerated by this source-only pass.

In `audio/music/music_07.asm`, 17 `Data_04_*` globals were removed where each
was an exact-address alias immediately under a retained `SoundSong07_*`
label. Independent review found no source/tool/metadata consumer, no affected
local scope, and confirmed all 776 audio directives remain unchanged. This
retires redundant labels only; it does not alter stream interpretation or
confidence.

`Data_55_6EF7` is now `Table_Kbd_Type6To10Flag_ByType`. The `Kbd_Type6To10Flag`
reader indexes eleven bytes for A=0..10 and returns 0 for 0..5 or 1 for 6..10.
The storage name is **PROBABLE** and describes that bounded table relation;
the routine does not check A, and values above 10 read beyond the table.
Natural traces read none of the eleven bytes. The entry and original purpose
of 55:5DF5 remain **HYPOTHESIS**. Historical naming notes retain the earlier
neutral-name decision as provenance; this paragraph records the current
superseding source state.

The bank29 owner formerly called
`engine/gfx/unreferenced_palette_library.asm` is now
`engine/gfx/palette_library_candidate.asm`; its eight operation names use the
`PalLibCandidate_*` prefix. The name change removes an unsupported global
non-use implication while preserving each bounded operation suffix. The
existing 36 calls and self-loop are internal to the owner; no external source
caller or root entry is established. Local-label qualification changed with
the global names, and the generated SYM check validates current addresses.
The candidate entry, selected bank and intended role remain HYPOTHESIS.

The former mixed bank-2C address-book graphics owner has been split at
`2C:7C80`: candidate resources at 2C:7740–7C80 now live in
`gfx/address_book/address_screen_candidate_bank2c.asm`, while the confirmed
entry-view tilemap and palettes at 2C:7C80–7FD0 are in
`gfx/address_book/entry_view_screen_bank2c.asm` and are read by
`AbookView_SetupScreen`. The engine candidate owner remains
`engine/address_book/confirm_screen_candidate.asm`. The 15
`AddrScreenUnused_*` names now use `AddrScreenCandidate_*`; three live labels
(`Data_AddrBookEntry_TilemapAttr`, `Palette_AddrBookEntry_Bg` and
`Palette_AddrBookEntry_Obj`) remain intact. All ten generic co-located aliases
were retired: their source/catalogue references were absent outside their
definitions except six `gfx/assets.tsv` label cells, which now point to the
existing semantic labels. Historical analysis and frozen configuration
references retain their original spellings as provenance (49 matching lines
in ten files). The candidate entry and its intended
confirmation role remain HYPOTHESIS; the renames assert no natural use or
global absence of callers. Preview PNG bytes and all ROM payload baselines
were preserved by the path migration. An independent bounded encoding check
confirmed the same 2,192 emitted bytes at 2C:7740–7FD0 after alias removal
(SHA-256 `483390eebbe4a0b3f6e565312a20e2df32461a077368b97b97d4594bbe21efc1`).

A bounded source-owner audit then searched maintained ASM under `engine/`,
`home/`, `data/`, `lib/`, `audio/` and `gfx/`, excluding the protected mail
sample; it did not inspect `languages/` or frozen `config/`. The remaining
filename-matched candidate/prototype owners keep cross-owner references within
their corresponding page-list or address-screen candidate code. The bank-29
palette-library candidate exports had no external ASM symbol references in the
scan. No further owner combining a positively evidenced natural consumer with
a candidate/unreferenced region was established. This is a bounded source
inventory, not proof against indirect/computed entry or universal non-use;
prototype and candidate natural availability remains at its recorded
evidence level. Inputs and scope are recorded in
`.tmp/candidate-owner-audit-20261021/RESULT.json`.

The bank-7F graphics owner is now `gfx/browser/page_list_candidate.asm` with
assets under `gfx/browser/page_list_candidate/`. The linked engine owner
`engine/unreferenced/page_list_prototype.asm`, all 74 `PageListProto_*` globals
and their consumers remain unchanged. Static source inventory found 102
symbolic reference lines from that engine owner to the graphics globals; this
does not establish natural entry or original purpose, which remain
HYPOTHESIS. At the time of this checkpoint, the separate `page_list_prototype_objects` and bank-52
`page_list_prototype_messages` owners were unchanged. A later path review split the mixed bank-7F owner at `7F:7B00`: the 720-byte tile block moved to `gfx/unresolved/tiles_7f_7830.asm` because no symbolic load was found in reviewed source, while the 453-byte palette/object tables/animation data moved to `gfx/text_cursor/objects.asm` because the latter has positive text-editor consumers. This path correction leaves historical confidence and source evidence intact. Frozen locators retain their earlier paths; current asset metadata and image inventory use the split owners.

In `engine/gfx/scroll_split.asm`, four exact co-located `Data_7F_*` aliases at
7F:7385, 747F, 75CB and 771E were retired. Their retained labels
`ScrollSplit_StepUp3Deltas`, `ScrollSplit_StepUp4Deltas`,
`ScrollSplit_StepDown3Deltas` and `ScrollSplit_StepDown4Deltas` already name
the same storage. Historical mapper/config records keep their former names;
no byte, extent or confidence changed. The restricted six-root
`Data_BB_AAAA`/`Font_BB_AAAA` census is now 183 definitions across 109 owners,
still excluding `engine/mail/sample_data.asm` and `languages/`.

In `engine/browser/menus.asm`, three exact co-located `Data_72_*` aliases at
72:6556, 6892 and 6ADF were retired under the retained
`Data_BrowserMenu_*_SlideScript` labels. The current `data_consumers.py`
special-case suggestions for those aliases were removed; existing CONFIRMED
and PROBABLE grades remain unchanged, including the unexecuted 72:6556 load
site. Frozen xref/config/analysis records keep the historical names. The
restricted six-root census is now 180 `Data_BB_AAAA`/`Font_BB_AAAA`
definitions across 109 owners, excluding the protected mail sample and
`languages/`.

In `audio/music/music_18.asm`, the exact co-located aliases `Data_05_5AF6`
and `Data_05_5B02` were retired under `SoundSong18_Track0` and
`SoundSong18_Header`. Current consumers already use the semantic labels in
`audio/music_pointers.asm` and the track-pointer word. The audio stream/header
confidence and all emitted directives remain unchanged; frozen analysis
locators retain the historical aliases. The restricted six-root census is
now 178 generic `Data_BB_AAAA`/`Font_BB_AAAA` definitions in 108 owners.

In `engine/mobile/pop3_retr.asm`, the exact co-located aliases `Data_54_4FC3`
and `Data_54_4FCB` were removed under the existing POP3 RETR descriptor
labels; the stale tool-only hypothesis rows for those aliases were deleted.
`Data_54_511B` was removed under the existing two-byte
`Data_Text_Ellipsis2` label. The descriptor-field interpretations remain
unresolved, and the existing PROBABLE/CONFIRMED evidence levels and all bytes
are unchanged. Frozen xref/config/analysis records keep the historic names.
The restricted six-root census is now 172 generic definitions across 106
owners.

In `engine/account/result_page.asm`, three exact co-located aliases
`Data_68_77D0`, `Data_68_7831` and `Data_68_7849` were retired under
`Account_ResultMessageIds`, `Data_Account_ResultPage_BannerTables` and
`Account_ResultPage_SecondBannerIndexByKind`. The current function-name
reference was updated; frozen symbol/xref/config/analysis records retain their
historical address labels. Existing aggregate/table confidence limits and
all bytes remain unchanged. The restricted six-root census is now 166 generic
definitions across 104 owners.

In `engine/mail_server/delete_hidden.asm` and `delete_flows.asm`, five exact
co-located aliases `Data_22_4C5B`, `Data_22_4DA6`, `Data_22_4EE9`,
`Data_23_4B4A` and `Data_23_4C8D` were retired under the existing
`Data_MailSrvDel*SessionBlockTemplate` names. Their byte-identical seven-byte
payloads and source copy loops are unchanged; the field meanings remain
undecoded. The now-obsolete `data_consumers.py` suggestion block was removed.
Frozen xref/config/naming manifests retain historical spellings. The
restricted six-root census is now 161 generic definitions across 102 owners.

In `data/text/top_menu_ticker.asm`, three exact co-located aliases
`Data_1E_4000`, `Data_1E_400D` and `Data_1E_409F` were retired under
`Data_TopMenu_StringIndexBank`, `String_TopMenu_Title0` and
`String_TopMenu_Title2`. The code and pointer table already use the retained
labels. Frozen xref/config/analysis records keep the old spellings; the bank
byte, string bytes, addresses and existing CONFIRMED grades are unchanged.
The restricted six-root census is now 169 generic definitions across 105
owners.

In `engine/mail/result_screens.asm`, exact co-located aliases `Data_29_49DA`,
`Data_29_4F6C` and `Data_29_5060` were retired under
`Data_MailServerStatus_NumberTemplate_M0`,
`Data_MailServerStatus_NumberTemplate_M2` and `MailServerStatus_Tiles_5060`.
Current source consumers already use the retained descriptive labels; frozen
xref/config/analysis entries preserve historical spellings. Existing text
and graphics confidence levels and payload bytes are unchanged. The
restricted six-root census is now 175 generic definitions across 107 owners.

## Broader name audit and remaining limits

A maintained-source audit found 59 paths carrying `unused` or
`unreferenced`, including two graphics owners with explicit external source
consumers. It found 15 `AddrScreenUnused_*` globals and 24 hypothetical
`BrowserFrameCandidate_*` preview names. No directory named exactly `gfx/bankNN`
exists; eight `screens_bankNN` source files are content-qualified filenames
that retain bank provenance. The browser-frame renderer now names these as
candidates, points provenance to the six actual `gfx/frame_designs/` owners,
and limits its selection statement to the 27 descriptors for styles 0..26.
The 24 existing preview payloads and current table metrics are retained; no
whole-preview README regeneration was performed because it would change
unrelated rows. Both the address-book and page-list gfx-owner path migrations
are now integrated with scoped README/inventory edits. No global unused/dead
claim follows from these finite scans.

The current source contains no literal `Function_BB_AAAA` definitions. A
controlled six-root lexical comparison at `41c92b60` finds 898
`Data_BB_AAAA::` definitions plus one in `zero_labels.asm` (899 total), with
`engine/mail/sample_data.asm` expressly excluded and not read. The common
restricted baseline at `5a1171cd` was 954 plus one; 56 removals/renames now
reconcile across Song03, Song07/keyboard naming, Song02 and the six bank2C
aliases. The older 959 count used another inclusion set and remains historical.
These lexical counts do not measure unidentified functions, unclassified
data, or completion. A fresh scan at this checkpoint finds no `Function_*`
labels in the maintained Japanese ASM roots or generated SYM; it does not
prove all code roles are understood. The old “current SYM retains 693” wording
has been qualified as a historical checkpoint in the status and translation
docs.

The fresh bank53 audit is recorded in
`pokemon_names_bank53_asset_audit_20261020.md`: all 25 name/frame associations
remain unproved, and eight KEEP windows still lack demonstrated complete
reaching VRAM state. The bounded asset/file scope has no missing reference or
orphan, and per-window missing U160 keys are tabulated. The data-consumer-group
census was rerun in a private snapshot excluding the protected mail sample.
The tool counted 522 neutral groups and 122 candidate sites, but rejected all
122 under its strict load-shape rules and emitted no manifest rows. This is
not a consumer map or proof of non-use; the follow-up remains open. Inputs,
hashes and the precise limitation are recorded in
`generic_data_name_audit_20261020.md`. Other unresolved roots and the final
definition-of-done review also remain open.

The extended path-safe lexical audit at this commit covers 336 maintained
ASM/INC files including RAM owners. It finds 898 `Data_BB_AAAA` definitions,
zero address-only `Function_`, `Font_`, `Label_` or `wRam_` labels, zero
function-like generic global prefixes, and no `gfx/bankNN` directories. These
results do not certify semantic function or data closure.

## Verification

At this checkpoint: `make` produced the original 2,097,152-byte ROM with
SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`
and `RESULT: IDENTICAL`; `make sym-check` passed with 13,502 labels;
`make palette-check` passed (162 loads, 116 arrays, two documented
over-reads); `make png-check` passed (408 tile sheets, four raw byte views,
37 font sheets and 95 screen PNGs); `python3 tools/png_rules.py mk-check`
passed (978 rules), and `git diff --check` was clean.

The detailed private review receipts and inventories remain under the
ignored `.tmp/` task directories until their dependent follow-up work and
retention review are complete.

### PNG-count correction (2026-10-21)

A fresh `make png-check` reports 409 tile sheets, four raw byte views, 37
font sheets and 95 screen PNGs. The current `gfx/png_rules.tsv` also contains
409 `tiles` rows. The earlier 408 tile-sheet count in this note and the bank53
follow-up is a historical checkpoint; the live counts in `docs/EDITING_IMAGES.md`
and `gfx/README.md` now match the fresh manifest and check output. The check
passed with no errors; no PNG or ROM asset was modified.

## Consumer census correction (2026-10-21)

Manual review of every site emitted by the strict candidate detector found
114 incorrect bank associations and eight real static reader sites covering
six neutral groups. All eight fell outside the detector's accepted shapes;
516 of 522 groups remain undecided in this pass. A zero-row manifest is
therefore not evidence of no readers. The complete bank-aware chains,
classification and proposed bounded follow-up are in
`.tmp/agent-data-consumer-mismatch-20261021/REPORT.md` (SHA-256
`0235dfba74b8d468319e4e3725e471ddaeae9db02d3d78f9d82da2bf12196b8a`).

The same review confirmed a stale comment at `2B:641` for `String_2B_5807`:
it claimed no direct reference, while current source has two symbolic operands
and the callee reads the string at `2B:5896`. The source header now records the
two operand addresses (`2B:57EF` and `2B:57FB`), the reader, and the remaining
uncertainty about display intent. This is a static-source correction only; it
does not establish natural entry into the candidate routine. A separate
independent review found the co-located `Data_6A_72A0` alias has no active
assembly operands and shares its address with `SpriteFrameTable_6A_72A0`; it
recommends retiring the generic alias while preserving its physical line as
blank and updating the current worklist comment. This recommendation has now
been integrated: the generic export is retired, its physical line is blank,
and the worklist explanation is current. The frozen region table and dated
history remain unchanged. The prior reviews made no tracked source changes
and ran no builds.

## Bank53 name-consumer trace and scope correction (2026-10-21)

A Japanese-only static trace checked six literal `$53` contacts at `68:66E2`,
`24:458F`, `24:4716`, `24:4733`, `24:50C8` and `24:5372`. In the examined
flows `$53` supplies coordinates; bank and indirect pointer values come from
separate fields. No bank53 consumer was demonstrated, and all 25
name-to-frame associations remain HYPOTHESIS. The report and result are
retained under `.tmp/agent-bank53-name-consumer-20261021/` (report SHA-256
`abcfab2608126ff783fa2044d66ad2bea6c44e29b905c1a9f69a8a4ec514485f`);
computed-pointer limits and two weak numeric candidates remain open.

Scope incident: an initial private-copy filter failed to exclude `languages/`
and transiently copied and hashed 565 files (1,863,145 bytes); one broad macro
search may also have read them. The search output was discarded, no English
content was semantically analyzed or used, and the task-created copies were
removed with the receipt retained in the private report. The corrected
Japanese source set explicitly excludes `languages/`. No translation files
were changed, built or published. `engine/mail/sample_data.asm` was not copied
or opened.

## Private consumer-read prototype (2026-10-21)

A bounded prototype was run on Japanese inputs from `4721ff20`, with the
protected source and all `languages/` paths excluded before opening files.
It recognized all eight positive provenances and produced no READ for the 114
known incorrect-bank links. Of the eight, five reached exact in-extent READs
and three stopped at UNKNOWN_INDEX; the latter were not promoted to reads.
Group totals are 4 READ, 2 UNKNOWN, and 516 UNRESOLVED. UNRESOLVED does not
mean unused. This reuses the old 122 seed links and is not an independent
complete search of all consumers.

Limits are 64 instructions per path, call depth 3, and 256 states per seed.
Thirteen synthetic mechanism tests passed separately from ROM evidence. The
first execution, which stopped at UNKNOWN_STACK for `2B:6D2A`, is preserved
alongside the corrected run. Full output and command/source receipts remain
under `.tmp/agent-consumer-read-prototype-20261021/` (`REPORT.md` SHA-256
`554649a2fdf3b6d69c9ed8dcb98f2870e34bc1d33beb986e20b8827ebc3cde2b`). This
remains a private research prototype, not a source/tool integration or proof
of natural execution. No build ran.

## Consumer mention expansion and routine-entry triage (2026-10-21)

The symbolic mention expansion classified 826 mentions for the 522 groups.
It found no new executable seed, but retained 217 indirect/component
references across 161 groups as `UNKNOWN_INDIRECT_READ`. Together with the
prior flow prototype, the current ledger is 4 `READ`, 162 `UNKNOWN`, and 356
`UNRESOLVED`; unresolved groups are not declared unused. The report and
per-group evidence are in `.tmp/agent-consumer-symbolic-expansion-20261021/`
(report SHA-256
`b91bfb5ae82eaa24b3a2c4d52a4325368183b813705c8d4e235083098a91733b`).

A separate Japanese-only routine triage found zero current global
`Function_BB_AAAA` or `Label_BB_AAAA` definitions among 7,975 globals. It
reconciled all 28 historical neutral routine addresses to their current
names and bodies: nine have explicit same-bank static edges (two table
words, seven CALL/JP); 19 had no explicit incoming edge in the bounded scan.
All 28 operations are PROBABLE local descriptions, while natural entry and
application purpose remain HYPOTHESIS. The bounded coverage file has zero
entry rows and zero covered starts for those intervals; computed/stack/
indirect transfers and unlabelled adjacent fragments remain open. The matrix
is `.tmp/agent-neutral-routine-triage-20261021/REPORT.md` (SHA-256
`9dd94553cea8c2ced6177a700cb75e408db39d05a6340de954648ca4e54e0f5d`). No
trace or build ran, so this is not a whole-ROM closure claim.

## Indirect data references and computed-entry slices (2026-10-21)

The 217 indirect/component mentions were reviewed by context: 216 remain
`UNKNOWN_INDIRECT_READ` and one belongs to an already known read. No new
`READ` was established; the combined data ledger remains 4 `READ`, 162
`UNKNOWN`, and 356 `UNRESOLVED`. The 25 paired `DW`/`DB BANK` fields are
structurally coherent with candidate intervals but do not establish a
consumer. Browser style selection masks to 0..127 for a 27-entry table, and
the intervening frame service's C register preservation is unproven, so style
2 remains unknown. Receipt:
`.tmp/agent-indirect-bank-triage-20261021/REPORT.md` (SHA-256
`6564982a3a8384e0e61311b4d4f16796cc1422fa7368d5160dc381b188db4248`).

A separate finite byte/source slice for 28 historical routine addresses
found three conditional static routes (two audio dispatches and one return
continuation), four priority slices that remain `UNKNOWN`, and 21
`NOT_FOUND_WITHIN_METHOD`. No natural root was established for any of the 28;
the audio dispatches are internal table routes rather than new external
roots. Computed, stack, RAM-copy, interrupt, and unsupported emitter paths
remain outside this method. Evidence excludes the protected source and its
corresponding ROM byte range before searching. Full graphs and exceptions
are in `.tmp/agent-computed-entry-slices-20261021/REPORT.md` (SHA-256
`3852272b339e561de37611b56be4577e33aeb0da977c7eb78518b5f0f4d81275`).
Static routes do not prove natural execution; no build or runtime test ran.

## Bank 67 password-change data aliases (2026-10-21)

Removed `Data_67_5E43`, `Data_67_5EB4` and `Data_67_5F5E` from
`engine/settings/password_change.asm`. Each was an exact same-address alias of
the retained `Net_PwdChgCgiUrl`, `Net_PppIdKey` or `Net_DefaultDnsPair` label;
an exact-token search found no active assembly or tool consumer beyond the
declarations. Existing CONFIRMED read evidence, content-class uncertainty,
bytes and extents are unchanged. Frozen analysis/config records were not
rewritten.

## Bank 29 address-book entry graphics aliases (2026-10-21)

Removed the four address-only aliases `Data_29_5B10`, `Palette_29_5E10`,
`Data_29_5E50` and `Data_29_6250` from
`gfx/address_book/entry_screen_bank29.asm`, retaining the exact same-address
labels `Gfx_AbookEdit_Tiles8000`, `Palette_AbookEdit_Obj`,
`Gfx_AbookView_Tiles9300Vb1` and `Gfx_AbookView_Tiles9700Vb1`. The four
catalogue rows in `gfx/assets.tsv` now use those retained labels. Exact-token
search found no active assembly/tool consumers of the retired spellings; the
graphics load evidence and existing CONFIRMED grades remain unchanged. No
payload, bank, address, length, or confidence changed.

## Bank 28 shared address-book resource aliases (2026-10-21)

Removed `Data_28_4BD0`, `Data_28_4FD0`, `Palette_28_51D0`,
`Table_28_5210` and `Data_28_5280` from
`gfx/address_book/shared_tiles_bank28.asm`, keeping the exact-address labels
`Gfx_AddrBookShared_Tiles8000`, `Gfx_AddrBookShared_Tiles8400`,
`Palette_AbookList_Bg`, `AddrBookShared_ObjTable` and
`AddrBookShared_ObjAnimData`. The three matching `gfx/assets.tsv` rows now use
the retained labels. The sprite-data rule is keyed by bank/address and accepts
an already semantic table root; its evidence references the retained tile
labels. Current-source/tool searches found no other use of the retired names.
Existing storage classes, evidence levels, bytes and extents are unchanged;
historical `config/` and `analysis/` snapshots are untouched.

## Bank 22 hidden delete-menu tilemap aliases (2026-10-21)

Removed `Data_22_5110`, `Data_22_53E0` and `Data_22_56B0` from
`gfx/mail_server/delete_menu_hidden.asm`. They were exact-address aliases of
`Tilemap_MailSrvDelHidden_Button1`, `Tilemap_MailSrvDelHidden_Button0` and
`Tilemap_MailSrvDelHidden_Button2`, respectively. Exact-token searches found
no active assembly or tool references beyond the declarations. Tilemap and
attrmap includes, extents, CONFIRMED loader evidence and bytes are unchanged;
historical config/analysis records remain untouched.

## Bank 72 dialog script and jump-table aliases (2026-10-21)

Removed `Data_72_43A1` and `Data_72_4572` under the existing dialog slide-script
labels, plus `Table_72_43AA`, `Table_72_4596` and `Table_72_4698` under the
existing cursor-type, input-dispatch and monitored-input table labels in
`engine/dialog/dialog.asm`. The two obsolete manual `data_consumers.py`
mapping rows were removed as well. Exact-token searches found no other active
assembly/tool consumers. Script bytes, pointer words, boundaries, and existing
CONFIRMED/PROBABLE classifications are unchanged; frozen config/analysis names
remain as historical evidence.

## Bank 67 usage-time data aliases (2026-10-21)

Removed `Data_67_61D2` and `Data_67_6246` from
`engine/settings/usage_time.asm`; their exact same-address labels
`Net_UsageTimeCgiUrl` and `Net_PppIdKeyDup` remain. The generic spellings had
no current assembly/tool consumers beyond their declarations. Existing
CONFIRMED read evidence, storage extents, content-class uncertainty, and bytes
are unchanged; historical config/analysis records were not edited.

## Bank 2F address-book list resource aliases (2026-10-21)

Removed `Data_2F_4D40`, `Table_2F_5010` and `Data_2F_5050` from
`gfx/address_book/list.asm` under `Tilemap_Abook_List`,
`Table_Abook_ButtonCursorAnims` and `Abook_ButtonCursor_ObjAnimData`.
Exact-token search found no active assembly/tool consumers beyond the
declarations. Tilemap/attrmap payloads, animation pointer words, frame records,
extents and prior CONFIRMED/PROBABLE classifications are unchanged; no frame
interpretation or execution status was promoted.

## Bank 7F JIS row lookup aliases (2026-10-21)

Removed `Data_7F_40F9` and `Data_7F_4150` from `engine/text/glyph.asm` under
`GlyphFont_RowBankTable` and `GlyphFont_RowFirstTable`. The 87-byte tables,
their index/access descriptions, and their existing PROBABLE classifications
are unchanged; no active source/tool references used the address-only names.
Frozen analysis/config spellings remain historical records.

## Bank 2B mail-viewer animation table aliases (2026-10-21)

Removed nine `Table_2B_*` labels from `gfx/mail/mail_viewer.asm`, each an
exact-address alias of a retained `MailView_*Frames` or
`Table_MailView_Anims` label. Exact-token searches found no current source or
tool consumers beyond the declarations. Animation entries, frame pointers,
script bytes, extents and confidence classifications are unchanged.

## Bank 2A, 5D and 22 resource aliases (2026-10-21)

Removed `Data_2A_7CF0`, `Data_2A_7DD0`, `Data_5D_4000`, `Data_5D_4400`,
`Data_22_5980` and `Data_22_5C50` under their existing address-book tile,
keyboard tile, mail tilemap and mail palette labels. The keyboard asset
catalogue now references the retained `Gfx_Kbd_T4_*` symbols. Exact-token
search found no active source/tool consumers of the removed names. Resource
bytes, extents, bank/address assignments and existing evidence grades are
unchanged; frozen config/analysis records were not rewritten.

## Bank 72 browser menu table aliases (2026-10-21)

Removed `Table_72_65EB`, `Table_72_6643`, `Table_72_6927`,
`Table_72_697F`, `Table_72_6AEC` and `Table_72_6B4C` from
`engine/browser/menus.asm`. Each shared an address with an existing semantic
input-table, dialog-result-table or menu-record label. Current-source/tool
search found no other use of the numeric spellings. Table words, menu record
bytes, boundaries and existing evidence grades are unchanged; historical
config/analysis data was not rewritten.

## Bank 2B draft-menu animation aliases (2026-10-21)

Removed eight `Table_2B_*` labels from `gfx/mail/draft_menu.asm`; each was an
exact-address alias of the existing `Table_MailDraftMenu_Anims` or
`MailDraftMenu_Anim*Frames` symbol. No active source/tool consumer used the
numeric spellings; the test-only `tools/test_rom_operands.py` fixture still
covers semantic-name preference when both spellings exist in a synthetic
tree. Animation records, frame pointers, extents and confidence classifications
are unchanged.

## Bank 2F address-book list table aliases (2026-10-21)

Removed six numeric `Table_2F_*` aliases and `Data_2F_4D03` from
`engine/address_book/list.asm`, keeping the co-addressed slot-address tables,
help tables and `Data_Abook_HelpBoxAttrBlocks`. Updated the attribute-block
header to cite `Table_Abook_HelpBoxAttrs` and removed its now-obsolete manual
mapping from `tools/data_consumers.py`. Exact-token search found no remaining
active consumers. `Data_2F_4094` remains neutral HYPOTHESIS because the three
bytes have no supported code/data classification. make remains byte-identical;
sym-check reports 12,456 labels, and data-consumers remains 288 groups / 93
rejected / 0 proposed rows.

## Bank 2A profile-editor resource and animation aliases (2026-10-21)

Removed `Palette_2A_6E10` and six `Table_2A_*` labels from
`gfx/profile/profile_editor.asm`, retaining `Palette_Profile_Bg`,
`Table_Profile_Anims` and the five `Profile_Anim*Frames` names at the same
addresses. No active source/tool consumer referenced the numeric spellings.
Palette contents, animation records, extents and evidence classifications are
unchanged.

## Bank 2B received-mail grid aliases (2026-10-21)

Removed `Table_2B_6430`, `Table_2B_6440`, `Data_2B_6442` and
`Data_2B_647F` from `gfx/mail/received_mail_grid.asm`; the co-addressed
`Table_MailGrid_Anims`, `MailGrid_Anim0Frames`, `MailGrid_Anim0Frame0` and
`MailGrid_Anim0Script` symbols remain. Exact-token search found no active
source/tool consumers. Sprite records, frame pointers, animation bytes and
extents are unchanged.

## Bank 68 communication-panel state and caption tables (2026-10-21)

Expanded the documented `CommPanel_StateTable` extent from four to five words
through `$744C`. States 0-3 point to `CommPanel_StateDraw`,
`CommPanel_StateScreenOn`, `CommPanel_StateWait` and `CommPanel_StateHide`; state
4 is explicitly assigned at `CommPanel_StateWait` and dispatches to
`CommPanel_StateWaitCloseOnly` at `$7594`, which executed in four scenarios.
This replaces the generic single-word `Table_68_744A` with a single semantic
five-entry state table. Removed its duplicate `Table_68_7442` plus
`Table_68_764C`, `Table_68_765E` and `Data_68_7652` aliases, and the obsolete
manual caption-record mapping. make remains byte-identical; sym-check reports
12,447 labels and data-consumers reports 287 groups / 93 rejected / 0 rows.

## Bank 68 account confirmation table aliases (2026-10-21)

Removed `Table_68_635C`, `Table_68_659A` and `Table_68_67AE` from
`engine/account/confirm_screens.asm`, retaining `Account_ConfirmCursorPositions`,
`Account_ConfirmManualCursorPositions` and `Dial_DefaultNumberTable`. They were
exact-address aliases and had no current source/tool consumers. Bytes and
table extents are unchanged. make remains byte-identical; sym-check reports
12,444 labels.

## Bank 68 account state and resource table aliases (2026-10-21)

Removed eleven exact-address `Table_68_*` aliases across account helpers,
password entry, registration, settings and result screens, retaining the
semantic `Dial_EntryNumberBuffers`, state/input tables, password maps, banner
sources and digit tilemap table. Search found no current source/tool references
to the retired spellings. Table bytes and extents are unchanged; make remains
byte-identical and sym-check reports 12,433 labels.

## Address-book slot, icon and animation aliases (2026-10-21)

Removed eleven exact-address aliases across `engine/address_book/address_book.asm`,
`address_picker.asm`, `save_confirm.asm` and `view.asm`: slot-address tables,
the caption table, the view-cursor animation table and its frame table now
export only their existing semantic names. Exact-token search found no active
source/tool references to the retired spellings. Payloads and extents are
unchanged; make is byte-identical and sym-check reports 12,422 labels.

## Browser tables and URL alias cleanup (2026-10-21)

Removed fifteen exact-address aliases across browser entry, page-list,
page-loader, page-render, page-results, session-start, frame-style,
history-cache, start-choice and communication-disconnect sources. Existing
semantic labels for result tables, URL/data tables, state-kind dispatch,
page-cache slots, element handlers and frame-wipe groups remain. Exact-token
search found no active source/tool consumers. Payloads and extents are
unchanged; make is byte-identical and sym-check reports 12,407 labels.

## Communication subsystem table and tile aliases (2026-10-21)

Removed ten exact-address `Table_*`/`Data_*` aliases in communication scene,
connection icon, connect dialog, notice dialog and time summary owners. Existing
semantic state/input/gfx tables, digit cells/tile data and the blank tile are
retained. Updated the notice-dialog evidence comments to refer to
`Table_CommNotice_DigitCells`. Exact-token source/tool search found no remaining
consumer of the old labels. make is byte-identical; sym-check reports 12,397
labels and data-consumers remains 287 groups / 93 rejected / 0 rows.

## Mail, record-address and date-table aliases (2026-10-21)

Removed eighteen exact-address `Data_*`, `String_*` and `Table_*` aliases from
mail compose/mailbox/date, body/title editing, profile/name editing, draft menu,
mail viewer/grid, staging and server tidy owners. Existing semantic names now
identify the record-address tables, mail-grid tables, date tables, help strings
and the four pair-walk Shift-JIS tables. Removed the obsolete manual twins rule
from `tools/data_consumers.py`; the body-editor trailing `$C9` note now refers
to the semantic loop-pairs table. No live ROM/source/tool consumer remains for
the old spellings. make is byte-identical; sym-check reports 12,363 labels and
data-consumers reports 287 groups / 93 rejected / 0 rows.

## Mailbox object palette and animation aliases (2026-10-21)

Removed `Palette_26_7AC0`, `Table_26_7B00` and `Data_26_7BE0` from
`gfx/mailbox/objects.asm`, keeping `Palette_Profile_Obj`, `Mailbox_ObjTable`
and `Mailbox_ObjAnimData`. Updated the active asset manifest to use
`Palette_Profile_Obj`; sprite preview metadata already used the semantic object
table name. No ROM payload, extent or runtime reference changed. make remains
byte-identical, sym-check reports 12,360 labels, and palette-check reports
162 loads / 116 arrays / 0 errors.

## Help and HTML label aliases (2026-10-21)

Removed six exact-address `Data_74_*`/`Table_6C_*` aliases from the help menu,
help script, HTML tag and URL owners. Existing names for the help input tables,
item-destination offsets, list bullet and URL scheme names remain. Exact-token
search found no active source/tool references to the retired symbols. Bytes
and extents are unchanged; make is byte-identical and sym-check reports 12,381
labels.

## Debug and communication-error resource aliases (2026-10-21)

Removed ten exact-address `Data_*`/`Table_*` aliases from the communication
error, non-CGB warning, debug flags, debug error test and sound-test owners.
Existing names for the BGP fade table, joypad/digit tables, debug palette,
debug flags, hex characters and sound-test palette/buttons remain. No active
source/tool consumer used the retired spellings. Payloads and extents are
unchanged; make is byte-identical and sym-check reports 12,387 labels.

## JIS and ASCII font bank aliases (2026-10-21)

Removed eleven `Data_BB_AAAA` aliases from the existing `GlyphFont_*` and
`Font_SjisValidBitmap` resource roots in `data/fonts/`. Updated the seven
affected font asset rows to use `GlyphFont_Ascii6x12` and the six bank-specific
`GlyphFont_Jis12x12_*` symbols, and removed the obsolete neutral-to-font
reclassification rule from `tools/data_consumers.py`. Glyph bytes, bank
mapping, row ranges and PROBABLE/CONFIRMED grades are unchanged. make remains
byte-identical; sym-check reports 12,349 labels; palette-check and data-consumer
checks pass (162/116/0 and 287/93/0).

## Bank 67 settings data/table aliases (2026-10-21)

Removed sixteen exact-address `Data_67_*`/`Table_67_*` aliases in settings
adapter-check/config, choice/confirm/continue screens, password change/save,
slot menu and usage-fee owners. Existing semantic state tables, cursor maps,
slot/tilemap tables, config-address table and URL label remain. Updated evidence
comments that referenced the retired state/config aliases. No bytes or extents
changed. make is byte-identical and sym-check reports 12,333 labels.

## Current routine-label reconciliation (2026-10-21)

At published main commit `9587f18ff5cb8bae693dc824351ce08f402510bc`, an exact
scan of current source definitions and the rebuilt `build/mobile_trainer.sym`
finds zero literal `Function_BB_AAAA` or `Label_BB_AAAA` names. The 28
historical neutral routine addresses in
`.tmp/agent-neutral-routine-triage-20261021/MATRIX.tsv` still resolve to their
recorded current operation names at the same bank/address in the rebuilt SYM
(28/28). This reconciles the old `naming2_fn4.md` count of 27 neutrals against
later source changes; that historical count must not be reported as the
current number of generic function labels.

The 28 local-operation descriptions remain PROBABLE, and natural roots and
application purpose remain HYPOTHESIS for all 28. Four priority slices remain
UNKNOWN (`2B:6CF5`, `2D:4E42/4E54`, `29:511E`); another unlabelled caller
fragment at `55:5DF5–5E02` and other computed/stack/copy paths remain outside
the closed census. The computed-entry report's 21
`NOT_FOUND_WITHIN_METHOD` rows are bounded negative results, not 21 adjacent
fragments or proof of absence. This reconciliation validates current names
and addresses only; it does not establish complete routine entry mapping or
semantic closure.

A current-source recheck at `2281dffc769377606f97a2e1c49ee02718f59007`
re-read 334 tracked ASM/INC files after filtering out the protected
`engine/mail/sample_data.asm` before opening sources. The 28 target names
still match the rebuilt SYM at their addresses (28/28); the source contains
zero exact generic `Function_BB_AAAA`/`Label_BB_AAAA` definitions, nine
non-definition references matching the prior triage's known edges, and no
exact `$ADDR` immediate for any target. The nine references are internal or
conditional and do not establish a natural root. Computed, stack, copied-code
and interrupt paths remain outside this scan, so all four priority slices
remain UNKNOWN. Reproducible source guards and rows are retained in
`.tmp/jp-routine-recheck-2281-20261021/` (`RESULT.json` SHA-256
`fae135723363a995c71d85816d5442fdef454186a8b3c8773f6d8a0ed28a3075`,
`SOURCE_GUARDS.json` SHA-256
`fd0f3968f4121722debd9fa96f6782b53951698620c9150fa718b6ffcfaf1044`).

## HelpMenu object data identified at bank 6A:6330 (2026-10-21)

The original ROM (`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`)
contains a 9-word frame table at 6A:6330. Its pointers are 6342, 6363, 6384,
63A5, 63C6, 63E7, 6408, 6429 and 645A. The record counts are 8, 8, 8, 8, 8,
8, 8, 12 and 16 OAM pieces, and each record ends exactly at the next pointer;
the final one ends at 649B. The 9-step script at 649B ends at 64AE. The object
entry at 64AE–64B2 contains pointers to 6330 and 649B and is loaded by the
existing HelpMenu setup. The entry straddles the source-owner boundary at
64B1; its low bytes remain in `gfx/help/help_screens_a.asm` and its high script
pointer byte is now expressed symbolically in `data/text/help_menu_ticker.asm`.

`Data_6A_6330`, `Data_6A_6448`, `SpriteFrame_6A_645A` and
`SpriteScript_6A_649B` were replaced by `SpriteFrameTable_HelpMenu`, nine
`SpriteFrame_HelpMenu_*` records and `SpriteScript_HelpMenu`, encoded with the
existing checked sprite macros. The `.pal` file and its asset/rule rows were
removed because the bytes are frame pointers and OAM/script data, not an RGB
palette. An independent encoder checked all 382 bytes at 6A:6330–64AE against
the original ROM before editing. `make` rebuilt 2,097,152 bytes with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` and
`RESULT: IDENTICAL`; `make sym-check` passed with 12,176 labels and 51
constants; `make palette-check` passed with 162 loads, 116 arrays, two
documented over-reads and zero errors. `gfx_export.py check` and
`png_rules.py mk-check` also passed. No rendering or hardware behavior is
claimed. The previous 6A:6330/6448 neutral-label and palette-conflict notes are
historical and superseded for the current source.

## Three generic data labels retired (2026-10-21)

Three bounded owner-local audits supplied positive consumer/transfer evidence
for labels that previously retained address-only names:

- `Data_2C_5150` is now `Gfx_MailTitle_Tiles8000Continuation`. The 704 bytes
  at `2C:5150–5410` are the continuation of the HDMA source beginning at
  `Gfx_MailTitle_Tiles8000` (`2C:5140`), loaded into VRAM bank 0 at
  `$8010–$82CF`. The slice is byte-identical to ROM offset `0xB1150`, with
  SHA-256 `4e206881ecf76156ee8b8f79c887788b36ebd3dda47d67aa15dfc4019bba4aba`.
  The old 1308-byte header crossed the next named graphics block at `5410` and
  was corrected to the actual 704-byte extent.
- `SpriteScript_2C_7354` is now `AddrSlotIcon_AnimScript`, and
  `Data_2C_7355` is now `AddrSlotIcon_AnimScript_FirstStep`. Entries 12–15
  point to the script; `Sprite_LoadObjectEntry` reads the first pair `$00,$05`
  as frame index 0 and delay 5. The two-byte slice at `2C:7355` has SHA-256
  `9f1afa4dc124cba73134e82ff50f17c8f7164257c79fed9a13f5943a6acb8e3d`.
- `Data_2D_7940` is now `Gfx_MailAddr_ObjHDMALoadTail`. The 528-byte slice is
  the tail `[7940,7B50)` of the confirmed HDMA load from `2D:7880` to VRAM
  bank 0 `$80C0–$82CF`; the slice SHA-256 is
  `c938b9927040205d4877aace6460753083534d28b0394e85a4a85d37c1f92744`.
  Static setup evidence associates 240 bytes with initialized object frames;
  the remaining 288 bytes are transfer-only in this call chain. The name
  describes the load boundary, not a claim that every tile is displayed.
  `gfx/assets.tsv` now points to this symbol while retaining `PROBABLE` for
  the asset's visual tile classification.

`tools/data_consumers.py --stats` now reports 124 neutral groups, 38
automatic candidates rejected, and zero manifest rows. The exact maintained
source label scan still finds zero `Function_BB_AAAA` definitions; this does
not close the remaining broad generic-name or asset/PNG audits. The build
remains byte-identical: SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
`make sym-check` and `make palette-check` also pass. Evidence is static; no
natural runtime, rendered display or hardware behavior is claimed.

## Bank 56 stored-password load continuation (2026-10-21)

`Data_56_68C0` is now `Gfx_ConnectDialog_StoredPassword_Tiles9100Vb1_LoadContinuation`.
`ConnectDialog_Draw_StoredPassword` starts an HDMA at `56:67C0`, with a
`$30` block count (768 bytes), destination VRAM bank 1 `$9100–$93FF`. The
renamed 512-byte slice `56:68C0–6AC0` supplies the latter 512 bytes of that
load, mapping to VRAM `$9200–$93FF`; the first 256 bytes begin inside the
already named `Gfx_ConnectDialog_StoredPassword_Tiles8800` region. Its
INCBIN matches the original ROM slice at physical offset `0x15A8C0`, SHA-256
`ee9967c1d4805c4674707bf4d7bf4f923a4337acc39994c836dd219ea2a34d18`.
`gfx/assets.tsv` now references the descriptive label; asset classification
remains **CONFIRMED** as tile graphics. This names the transfer continuation
and makes no extra screen-display claim. Build is `RESULT: IDENTICAL`,
`sym-check` and `palette-check` pass; at this checkpoint the neutral-data
census was 123 groups.

## Bank 2F:4094 code/data candidate (2026-10-21)

The three bytes at `2F:4094–4097` are `C3 00 40`, a valid unconditional
`JP $4000` to the confirmed `AbookList_Run` entry. However, the `AbookList_Run`
flow at `2F:4091` jumps to `AbookList_Run_ButtonRow` at `2F:4131`; it does
not fall through to 4094. The next separately named code begins at `2F:4097`,
and a bounded maintained-source reference scan found no direct entry operand
to 4094. The mapper's `code-prefix-like` classification records the legal
opcode/target, not an inbound edge or natural execution. The source comment
was corrected to preserve that positive opcode evidence while keeping the
code-versus-unused-stub status **HYPOTHESIS** and retaining `Data_2F_4094` as
the neutral label. No function name or reachability claim is introduced.

## Bank 5F keyboard map-to-graphics gap (2026-10-21)

`Data_5F_58F3` is now `Padding_Kbd_T3ToT5_TileAlignment` with **PROBABLE**
confidence. The source interval `5F:58F3–5900` is exactly 13 zero bytes
(physical ROM offset `0x17D8F3`, SHA-256
`dd46c3eebb1884ff3b5258c0a2fc9398e560a29e0780d4b53869b6254aa46a96`).
`Tilemap_Kbd_T3` begins at `56EB` and spans 520 bytes (13 rows × 20 columns,
tilemap then attributes), ending exactly at `58F3`. `Kbd_LoadPageGraphics_T5`
loads its T5 tiles beginning at `5900`, a 16-byte-aligned source, in HDMA
blocks; the 13 zero bytes fall between the two named resources. No named
direct reader of the gap was found. The most economical interpretation is
alignment padding, while reserved/unreferenced zero data cannot be excluded.
The Japanese build remains byte-identical; `sym-check` and `palette-check`
pass. At this checkpoint the neutral-data census was 122 groups.

## Bank 29 mail-screen alignment gap (2026-10-21)

`Data_29_53F6` is now `Padding_CommTimeHMS_TileHDMAAlignment` with
**PROBABLE** confidence. The ten-byte interval `29:53F6–5400` consists of
zeros at physical ROM offset `0xA53F6`, SHA-256
`01d448afd928065458cf670b60f5a594d735af0172c8d67f22a81680132681ca`.
The preceding palette extent ends at `53F6`; the next graphics asset starts
at `5400`, which is 16-byte aligned and is the source of the static HDMA load
to VRAM bank 1 `$9000–$93FF`. No named direct reader of the gap was found.
The alignment role is likely but does not exclude reserved zero data. The
Japanese ROM remains byte-identical, with `sym-check` and `palette-check`
passing. `data_consumers --stats` now reports 121 neutral groups, 38
automatic candidates rejected and zero rename rows.

## Exact generic-name and graphics-path census (2026-10-21)

A maintained-source `git grep` over `home/`, `engine/`, `data/`, `gfx/`,
`audio/` and `lib/`, excluding `engine/mail/sample_data.asm` and
`languages/`, found zero definitions matching the exact
`Function_BB_AAAA::`, `Label_BB_AAAA::` or `Font_BB_AAAA::` patterns, and 27
definitions matching `Data_BB_AAAA::`. A filesystem and tracked-path check
found no `gfx/bankNN` directories. The prior examples
`Function_75_4000`, `Data_68_6960` and `Font_48_4ADB` are absent as current
definitions. These counts cover only these exact spellings: they do not prove
that every code entry is identified or that all other neutral families
(`Table_`, `String_`, `Tiles_`, `Tilemap_`, `Attrmap_`, `Palette_`) are
resolved. The wider `data_consumers` census remains 121 neutral groups.
