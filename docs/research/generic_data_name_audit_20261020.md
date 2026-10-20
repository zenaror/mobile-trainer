# Generic data-label audit: 82 retained `Data_*` labels

## Scope and method

This bounded audit starts from the published Japanese source snapshot
`a3238e6e998d44f6ec7ddfa479baad6743604110`. It covers the 82 exact
`Data_BB_AAAA` definitions without an adjacent descriptive alias in a census of
243 maintained ASM/include files. The audit checked source hashes, label
addresses against the existing symbol file, nearby bytes/layout and available
reader expressions. “No adjacent alias” is a lexical census result; it does not
mean that an object is semantically unknown or unused. In particular, 77 of the
82 labels have no lexical reference, which is not evidence of dead data.

The full grouped matrix, evidence JSON, and reproduction script are retained in
`.tmp/agent-generic-data-no-alias-20261020/`. `matrix.json` SHA-256 is
`f1b010b6295732eeafa2b2fa8a7be41d0cb2030f54c64f6605ebd9a531473378`;
the source manifest is `87477919d8aac2572708badd4b9dc123f5ba8608d39baf5a711fa810e2846132`.
The private snapshot is the audit input; this note records conclusions and does
not replace it.

## Descriptive names adopted in maintained sources

Seven candidates have direct structural or reader evidence. Their descriptive
names replace the neutral source labels at the same addresses:

| Address | Descriptive name | Evidence and confidence |
|---|---|---|
| `6A:65A1` | `String_HelpMenu_MailTitle` | **CONFIRMED**: seven bytes encode `メール` plus NUL; the help ticker pointer table selects it for record 4, page 2, item 1. |
| `72:5645` | `String_Dialog_Msg0113_Line2` | **CONFIRMED structural label**: 33 bytes form the second NUL-terminated line of the record beginning at `72:5621`; the line contains 16 full-width spaces. The name describes its position, not the UI meaning of blank text. |
| `55:62C8` | `Table_Kbd_CursorSpriteCharOffsets` | **PROBABLE mechanical role**: ten eight-byte sets of four two-byte offset pairs. `Kbd_UpdateCursorSprite` selects a set by `wKbdType`, indexes by `(wKeyboardCharLo - $80) * 2`, and adds the pair to the sprite-slot 11 origin. The name does not assert an unrestricted input domain. |
| `65:4BE2` | `Notice_PageTable_RegistrationStartTextPointer` | **CONFIRMED structural**: record 0 text pointer. `Notice_ShowPage` indexes the record at `Notice_PageTable + 6 * page id`; `Notice_DrawBodyText` reads its text pointer at record `+4`. It points to `NoticeText_RegistrationStart`. |
| `65:4C6C` | `Notice_PageTable_ResumeRegistrationTextPointer` | **CONFIRMED structural**: record 23 text pointer at the same stride and offset; it points to `NoticeText_ResumeRegistration`. |
| `68:4F35` | `Dev_TestConfigImage_DialSlot1Bcd` | **PROBABLE field role**: offset `$8E` in the 192-byte test image aligns with the SDK window's zero-based slot 1 (the second dial slot) BCD field. The parser has capacity 8 and stops at the first `$F` nibble; these `$FF` bytes produce empty output if the image field reaches that window. That mapping and installer execution are not proven. |
| `68:4F4D` | `Dev_TestConfigImage_DialSlot2Bcd` | **PROBABLE field role**: offset `$A6` in the 192-byte test image aligns with the SDK window's zero-based slot 2 (the third dial slot) BCD field. The parser has capacity 8 and stops at the first `$F` nibble; these `$FF` bytes produce empty output if the image field reaches that window. That mapping and installer execution are not proven. |

The ticker title, keyboard table, two notice-pointer fields and two test-image
fields now use descriptive names; the dialog line is not referenced by another
maintained source label. Seven old `Data_*` labels are retired from maintained
sources after checking that no active source/tool references them. Frozen
`config/regions/` and `analysis/mapper/` tables retain historical labels as
dated snapshots. The changes add no bytes or alter physical ranges.

## Follow-on co-alias cleanup

A broader static census at the `97d06d7d` snapshot found two additional neutral
aliases outside the 82-label no-co-alias cohort: `Data_65_4BC6` duplicates the
existing `Notice_PageSoundTable` symbol, and `Data_68_4EA7` duplicates
`Dev_TestConfigImage`. Neither neutral spelling has a maintained source or tool
consumer; the meaningful symbols remain in place. These aliases were removed
without changing bytes, source ranges, or confidence. The first retains its
existing table interpretation; the second retains its existing probable name
for the test configuration image. The broad census and reference matrix are
retained under `.tmp/agent-data-global-census-20261020/`.

The same census confirmed the structural position of `Data_5C_5144` as slot 32
in the message-pointer index space (`5C:5104 + 2*32`), between the 32-entry
pointer block and slots 33–37. Its raw word is `$0020`, not a valid ROM pointer;
no finite message triple selects slot 32. The label is now
`CommErr_MessageSlot32RawWord`. Its position is CONFIRMED, while the purpose of
`$0020` remains HYPOTHESIS/unknown; this is not an unused-slot claim.

An independent source review accepted all four new retirements after correcting
the parser wording to reflect its early stop at nibble `$F`. The reviewer also
confirmed the source directives and byte ranges are unchanged, and found no
active references to the retired labels. The `make` and symbol checks below
verify the maintained build and label map.

## Follow-on exact aliases in MailSrvDelProgress

After the census baseline above, `gfx/mail_server/delete_progress.asm` had 48
`Data_23_*` definitions. A separate owner-hash-pinned review retired 47 exact
same-address aliases for existing tilemap, tile, frame, and animation-script
names. `Data_23_7C03` remains because this census found no same-file descriptive
co-alias; its meaning was not inferred. The 47 removed names had no other
current ASM/include occurrence, tool/metadata mention, or local-label scope.
The independent reviewer accepted the exact owner snapshots and candidate
matrix; 705 source bytes were removed, with zero emitted bytes changed.

The pass is outside the original 82-label no-co-alias set above. Its source
hash before editing matched the pinned broad census input
`f4d1086a2408893c072d92517e54d4ad3554f76fedfbe2620aac16d5c9bfdc73`;
per-alias evidence is retained under
`.tmp/jp-gfx-delete-progress-alias-pass-20261020/review/`. Coordinator-run
gates: `make` returned `RESULT: IDENTICAL` with the original ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`,
`make sym-check` reported 14,461 labels and 51 constants, and
`make palette-check` reported 162 loads, 116 arrays, two documented over-reads,
and zero errors. No resource bytes, confidence levels, or runtime claims changed.

## Reconciled maintained-source count

The current exact-name count is 1,398 `Data_BB_AAAA::` definitions in the six
maintained Japanese source roots `home/`, `engine/`, `data/`, `gfx/`, `audio/`,
and `lib/`. The same `git grep` expression at parent `7923edc7` counted 1,445;
the 47-definition difference is exactly the MailSrvDelProgress pass above. This
reconciles the earlier handoff's 1,446 figure, which was high by one. The count
excludes `languages/` and does not state how many resources are semantically
identified; it is only a reproducible lexical count of exact global definitions.

## Co-located `Label_*` aliases

A separate read-only audit pinned to parent `7923edc7` inventoried 493 global
`Label_BB_AAAA::` definitions in the same six roots. All 493 shared an address
with another named label. This is not evidence that they are 493 functions, nor
does it independently validate each descriptive name. The lexical inventory
found 231 targets referenced by `dw`, 261 only by `jp`/`jr`, one fall-through
target and no symbolic `call`/`farcall` references. Eleven active source
operands still used the generic spelling for seven addresses.

This follow-on retires those seven exact-address aliases and changes the eleven
operands to their existing operation/resource names: `SoundDrv_CmdStoreTrackByte1E`,
`SoundDrv_ParamStoreTrackWord27`, `Browser_LoadPage_ReturnOnly`,
`Browser_DrawElement_ReturnOnly` (five entries), `Kbd_HideAndReturn9`,
`Fill99E1Pattern46_Draw5807TwiceAndUpload`, and `LCDOn_ReturnBCZero`. Existing
PROBABLE/HYPOTHESIS comments remain on the surviving names; this does not prove
natural entry, callers, or application purpose. The pinned inventory and its
limitations are retained at `.tmp/label-entry-audit-20261020-agent/`.

A follow-on keyboard pass retires 12 more co-located aliases in bank 55:
`Kbd_LoadPageGraphics_T6`, its four page entries and tail, and
`Kbd_LoadPageGraphics_T78`, its four page entries and tail. Existing naming
evidence rates all 12 CONFIRMED from dispatch tables and natural trace counts.
The current source contains their descriptive labels and table operands already
use those spellings; `tools/data_consumers.py` now looks them up by those names.
Its two `Label_55_6952`/`Label_55_6A65` keys remain only to interpret historical
`config/xrefs.tsv` rows. A targeted `kbd_tokens()` run returns all 23 mappings,
including the page entries. The full `data_consumers.py --stats` run now
completes. Manual rules skip a candidate only when its surviving named target
is present at the old bank/address; stale targets for the dialog scripts,
character-pair tables and locked HelpMenu ticker were aligned with verifier
corrections. The obsolete whole-block `Data_4A_68D0` AdapterCheck hypothesis
was removed because the source now models the object table and internal
structures separately. `--stats` reports 581 neutral data groups, 161 sites
(158 rejected, 3 accepted), and one remaining HYPOTHESIS row. A private
manifest and inventory from this working tree based on `3d5fe3af` are retained
under `.tmp/data-consumers-working-tree-after-3d5fe3af/`; they do not update the historical
`analysis/naming2/data2_renames.tsv`.

## Retirement of remaining co-located `Label_*` aliases

A fresh read-only inventory pinned to `56840723776003175be999ba35bd9af943b53b9d`
found the remaining 474 global `Label_BB_AAAA::` definitions in the six
maintained Japanese roots. Every one shared its address with exactly one
non-neutral global label; the audit found zero source operands using the generic
spelling. The inventory counts 861 incoming `jp`, `jr` and `dw` operands through
the surviving names. This pass deletes only the redundant `Label_*` definition
lines. It does not rename the surviving labels or assert that their comments
prove a natural entry or application-level meaning.

The old-to-current name/address ledger is
[`../../analysis/naming2/retired_coincident_label_aliases.tsv`](../../analysis/naming2/retired_coincident_label_aliases.tsv)
(474 rows). All 474 old aliases were the final global label in their alias
group; 392 following local labels consequently use the surviving semantic name
as their qualified scope after the cleanup. A repository-wide search found no
qualified references to the retired `Label_*.local` symbols in maintained code;
the current `ram/overlays.asm` boundaries were changed to the mapped names.
Historical `analysis/` and `config/` rows remain historical evidence. The two
`Label_55_6952`/`Label_55_6A65` keys in `tools/data_consumers.py` remain only for
reading old `config/xrefs.tsv` rows, not as source labels.

The current exact-name count is zero `Label_BB_AAAA::` definitions in the six
maintained roots. `make` returned `RESULT: IDENTICAL` at original SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` found 13,968 source labels and 51 constants with every address
comment valid; `make palette-check` reported 162 loads, 116 arrays, two
documented over-reads and zero errors; `make png-check` validated 408 tile
sheets, four raw byte views, 37 font sheets and 95 screen PNGs. No ROM bytes
changed. The current-snapshot inventory and reproduction script are retained
under `.tmp/label-entry-audit-head-56840723/`.

## Retired keyboard/help ticker data aliases

A targeted current-source census found six neutral `Data_BB_AAAA::` aliases
that shared an address with a named table and had no current source operand or
local scope: `Data_55_641C`, `Data_55_6E9F`, `Data_55_6EE1`, `Data_55_6F0D`,
`Data_55_6F23`, and `Data_6A_6651`. All six were retired in this checkpoint;
`Data_55_6F3B` had already been retired with its one local scope
mapped from `.l6F51` to the surviving table name. The old/current names,
addresses and owner files are preserved in
[`../../analysis/naming2/retired_keyboard_table_aliases.tsv`](../../analysis/naming2/retired_keyboard_table_aliases.tsv).
The four keyboard predicate tables remain PROBABLE storage; confidence and
consumer notes are unchanged. `Table_HelpMenu_LockedItemTicker` remains the
one-byte bank field at `6A:6651`; adjacent pointer arrays remain separate
blocks. The build remains byte-identical after these alias-line removals.

## Retired Mobile SDK packet/data aliases (2026-10-20)

A current-source address census at published parent
`153fbd7976485b7883f95332c416eca2164ae6ba` found eight redundant
`Data_75_BB_AAAA` aliases in `lib/mobile/main.asm`. Each shared the exact
`.sym` address with the descriptive label shown below, had no direct source
references, metadata/tool mentions or scoped locals, and did not own bytes.
The aliases were removed; the accepted names, comments, data declarations and
their prior confidence levels remain unchanged. The durable old-to-current
mapping is in [`retired_mobile_sdk_data_aliases.tsv`](../../analysis/naming2/retired_mobile_sdk_data_aliases.tsv).

| Retired alias | Retained label | Address |
|---|---|---|
| `Data_75_5FFB` | `MobilePacket_Idle` | 75:5FFB |
| `Data_75_6063` | `MobilePacket_WaitForTelephoneCall` | 75:6063 |
| `Data_75_606D` | `MobilePacket_TransferData` | 75:606D |
| `Data_75_6073` | `MobilePacket_TransferData_Tail` | 75:6073 |
| `Data_75_6078` | `MobilePacket_OpenTCPConnection` | 75:6078 |
| `Data_75_6084` | `MobileSDK_TimingTable` | 75:6084 |
| `Data_75_612D` | `MobileStr_CrLfCrLf` | 75:612D |
| `Data_75_7B40` | `MobileSDK_Md5InitConstants` | 75:7B40 |

The pre-change census receipt is retained in
`.tmp/data-global-census-head-153fbd79/`: `RESULT.json` SHA-256
`84f742c088f9a5f8ac3f2e82879a456371372dddac15ee7ab9c9598d08d6f960`,
`data_matrix.tsv` SHA-256
`907e4e938d56df23ad6185302835fcea4b222cdfeb8bc4d6aceff8a684ee0af5`, and
`census.py` SHA-256
`a60418ffdadc8efc00944937240aa051609e6e6a7e10282d586d74ad38144142`.
That census counted 1,393 generic Data definitions before this eight-alias
retirement; it is a source-name inventory, not a count of unidentified data.
The build remains `RESULT: IDENTICAL` to the original ROM, and symbol,
palette and PNG checks pass. The change adds no new packet semantics or
runtime evidence.

## Retired registration cursor alias (2026-10-20)

The same pinned census identified `Data_68_7B19` as a redundant alias of
`Registration_DeleteCursorPositions` at `68:7B19` in
`engine/account/delete_registration.asm`. The generic spelling had no direct
references, metadata/tool mentions or local scope. Its declaration was
removed; the four position bytes, descriptive label and CONFIRMED evidence
annotation remain unchanged. The mapping is preserved in
[`retired_account_data_aliases.tsv`](../../analysis/naming2/retired_account_data_aliases.tsv).
The ROM remains `RESULT: IDENTICAL`; sym, palette and PNG checks pass. This
does not identify any additional data semantics.

The same evidence-backed cleanup retired `Data_68_6E03`, an exact same-address
alias of `Config_HostPrefixStrings` in `engine/account/register_config.asm`.
It had no generic-name references, metadata/tool mentions or local scope; the
two NUL-terminated host-prefix strings and CONFIRMED annotation are unchanged.
The mapping is included in the account alias ledger.

## Retired page-list graphic aliases (2026-10-20)

A bounded pass removed 46 `Data_24_*` globals from
`gfx/browser/page_list.asm`. Each had an exact same-address descriptive
co-alias (including the existing page-list tilemap, animation-frame and
script names), with zero direct references, tool/metadata mentions or scoped
locals. Only alias declarations were deleted; payloads and evidence annotations
remain unchanged. The old/current names and prior confidence are recorded in
[`retired_page_list_data_aliases.tsv`](../../analysis/naming2/retired_page_list_data_aliases.tsv).

The private pass receipt is `.tmp/page-list-data-alias-pass-20261020/`:
`PRECHECK.json` SHA-256
`09c32f3fa1ec1918780d2cb3430131bde4bef5ae3248d26390fc7d15c98f6e11`,
`RESULT.json` SHA-256
`79dffb1b977f3c7210d216170dc42ac47c534237bbff85993196f4f088c299ea`, and
the ledger SHA-256 is
`53885a0fb87e8516db309b16b3e4fa42f6bb37701c190305b90752734fe1b993`.
Build, symbol, palette and PNG gates all pass with original ROM identity.
No graphic usage, runtime or semantic claim is added.

## Retired top-menu graphic aliases (2026-10-20)

The same bounded procedure retired 36 `Data_1E_*` aliases in
`gfx/top_menu/top_menu.asm`, where each address already had a descriptive
top-menu tilemap, animation-frame or script label. The census found no direct
generic-name references, tool/metadata mentions or scoped locals. Payloads,
existing names and confidence annotations are preserved; the mapping is in
[`retired_top_menu_data_aliases.tsv`](../../analysis/naming2/retired_top_menu_data_aliases.tsv).

Receipt: `.tmp/top-menu-data-alias-pass-20261020/` contains `PRECHECK.json`
(SHA-256 `e982bedf35ccf80886b3b89120529a7515d5c7623b19a67e9eedd2355bddd50e`)
and `RESULT.json` (SHA-256
`7e7b8d6b84db1b4055e3ceace786bc85849a45683f20cdf65970c9076d7bbe73`); the
ledger SHA-256 is
`845d95687ff95f6cadf9fe3cdaa27354bca964410410d256f2eb7b6f788375f1`.
Build, symbol, palette and PNG gates pass with byte-identical original ROM.

## Retired communication-result graphic aliases (2026-10-20)

Another owner-level pass removed 33 redundant `Data_24_*` aliases from
`gfx/mail/comm_result.asm`. Each had an exact same-address descriptive
`MailResult_*` label; the fixed census and current symbol file confirmed the
addresses, and found no generic-name source references, tool/metadata mentions
or local scopes. The old/current names and preserved confidence values are in
[`retired_comm_result_data_aliases.tsv`](../../analysis/naming2/retired_comm_result_data_aliases.tsv).

Private receipt `.tmp/comm-result-data-alias-pass-20261020/` records
`PRECHECK.json` SHA-256
`a498ede7204f6b0472ff9e801d643e78156faee3e836d69cf31eea7377de4359` and
`RESULT.json` SHA-256
`e837451a974d29b67f4df983401306e07193357e8e73ab44cfabb26f888b266f`; the
ledger SHA-256 is
`a9f5d8e64eea2a939849c6518d7867b77c00d1b49ba91831e4340b2d61dfcc20`.
The original ROM, symbols, palettes and PNG checks pass. No runtime claim is
added.

## Remaining limits

The other 75 labels from the original no-alias subset remain unchanged. The audit groups them into interior labels,
overlapping font storage, mixed streams, fragments needing positive entry proof,
and explicit KEEP decisions. No data removal is justified by this census.
`Data_68_6960` is already represented by `Config_DefaultImage2` and therefore
was not one of the 82. `Data_7C_57CD` remains a physical font-chunk marker inside
a glyph, with no established algorithmic need to remove it. The audit also found
no remaining definitions in `gfx/` within this subset.

This is not a complete census of all data, code entries, graphical resources,
or semantic completion. It adds no runtime, natural-execution, rendering, or
hardware evidence. Source changes still require `make`, `make sym-check`,
`make palette-check`, `make png-check`, byte comparison against the original,
and independent review before publication.
