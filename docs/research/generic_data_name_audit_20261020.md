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

At this audit snapshot, the exact-name count was 1,398 `Data_BB_AAAA::` definitions in the six
maintained Japanese source roots `home/`, `engine/`, `data/`, `gfx/`, `audio/`,
and `lib/`. The same `git grep` expression at parent `7923edc7` counted 1,445;
the 47-definition difference is exactly the MailSrvDelProgress pass above. This
reconciles the earlier handoff's 1,446 figure, which was high by one. The count
dated count excludes `languages/` and does not state how many resources are semantically
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

## Retired keyboard-panel graphic aliases (2026-10-20)

The keyboard panel owner `gfx/keyboard/panels_bank5f.asm` had 32 redundant
`Data_5F_*` aliases over existing descriptive panel, frame and script labels.
The candidate census and current `.sym` confirmed every exact address and
found no direct generic-name references, tool/metadata mentions or scoped
locals. The aliases alone were removed; bytes and the existing confidence
annotations remain. See
[`retired_keyboard_panels_data_aliases.tsv`](../../analysis/naming2/retired_keyboard_panels_data_aliases.tsv).

Receipt `.tmp/keyboard-panels-data-alias-pass-20261020/`: `PRECHECK.json`
SHA-256 `379f931af1266d954b36380c7a5b3e4634b78f649ca199949e9b28ada06db02e`,
`RESULT.json` SHA-256
`fb4ddb837e908923c4624d6f6f7877086c94ea3cb7c67349018a9e894661bf70`, and
ledger SHA-256
`f4c1d2f3eb4a729fffb418f183c8bc6721989640565bfe2b2e93bab9e873a6b9`.
All byte, symbol, palette and PNG checks pass.

## Retired compose-object graphic aliases (2026-10-20)

In `gfx/mail/compose_objects.asm`, 30 `Data_29_*` aliases had exact
same-address `MailBody_*` frame or script labels. The owner was unchanged
since the census parent, and current symbols confirmed the same addresses;
there were no generic-name source references, tool/metadata mentions or
scoped locals. Only the redundant declarations were removed. The mapping is
in [`retired_compose_objects_data_aliases.tsv`](../../analysis/naming2/retired_compose_objects_data_aliases.tsv).

The private receipt `.tmp/compose-objects-data-alias-pass-20261020/` records
`PRECHECK.json` SHA-256
`f619436e895394867efcf2d94eae25d47cd019d641cc1df4aba0b0b41cb58c50` and
`RESULT.json` SHA-256
`7b97567f1033f5a85aeafd29283ac8f7e51282324332dd88fa210fa590411551`; the
ledger SHA-256 is
`ef7402e57fb10fa1467e8db6ba8003d96034b4d5b05f89d7b36d4043cabf17cb`.
The ROM, symbol, palette and PNG checks all pass.

## Retired draft-menu graphic aliases (2026-10-20)

In `gfx/mail/draft_menu.asm`, 26 `Data_2B_*` aliases shared exact addresses
with existing descriptive graphics, palette, map and animation labels. The
owner was unchanged from the census parent; the `.sym` and candidate matrix
showed zero generic-name references, tool/metadata mentions or scoped locals.
The aliases alone were removed, with bytes and confidence annotations kept.
See [`retired_draft_menu_data_aliases.tsv`](../../analysis/naming2/retired_draft_menu_data_aliases.tsv).

Receipt `.tmp/draft-menu-data-alias-pass-20261020/`: `PRECHECK.json` SHA-256
`7914c8d1f7db9bbade7c62d704e04df98ec99f9bbf0bb22d5a10619878a5a8e4`,
`RESULT.json` SHA-256
`601650122636d2ccc5665d731a325141a7f3dc387b4f6d3a481a4d31e1753c4d`, and
ledger SHA-256
`4788d954f08e265d5d6e293a26ebf8886513354eeafcf4d8b9c9e279eb2da2dc`.
All original-ROM and static graphics checks pass.

## Retired mail-viewer graphic aliases (2026-10-20)

The mail-viewer owner `gfx/mail/mail_viewer.asm` contained 24 redundant
`Data_2B_*` aliases for existing `MailView_*` frame and script labels. The
owner was unchanged since the census parent; current `.sym` addresses match,
and there are no generic-name references, tool/metadata mentions or scoped
locals. Only the aliases were removed. The ledger is
[`retired_mail_viewer_data_aliases.tsv`](../../analysis/naming2/retired_mail_viewer_data_aliases.tsv).

Receipt `.tmp/mail-viewer-data-alias-pass-20261020/`: `PRECHECK.json` SHA-256
`4dad5f0f63fd67f41fc3b88732c9bac6f305a917cf166bf5986f60324ad4cd40`,
`RESULT.json` SHA-256
`a6089eb16fca04d31c8f0630e4d102c76c056ccab2e0d18768602ffcffc3b316`, and
ledger SHA-256
`657b321558419b463d016fffaba26a2065cb55c141137a75115f3b91c5c66bc3`.
Build, symbol, palette and PNG checks all pass.

## Retired connect-screen graphic aliases (2026-10-20)

The owner `gfx/mail/connect_screen.asm` had 23 `Data_27_*` aliases at exact
addresses already named by descriptive connection-screen graphics and
animation labels. The owner hash matched the pinned census input, current
symbols confirmed every address, and the candidates had no generic-name source
references, tool/metadata mentions or scoped locals. Only the redundant
declarations were removed; bytes and confidence annotations remain unchanged.
See [the alias ledger](../../analysis/naming2/retired_connect_screen_data_aliases.tsv).

The private receipt `.tmp/mail-connect-data-alias-pass-20261020/` records
`PRECHECK.json` SHA-256
`d5622383cc1bdb64fb51f4c154ea459d786c8530836ee91e56359c5d47bc4167` and
`RESULT.json` SHA-256
`dc88a1488d03bd2d9b6ed0b00fbdae325da181390162a4afc52c0aa203ecc1f0`; the
ledger SHA-256 is
`c5a50bd4cae30f1d178a4aa5281a2c4b56c662671b8fc12ccad7390c9f804ec0`.
The build is byte-identical to the original; symbol, palette and PNG checks
pass.

## Retired communication-scene graphic aliases (2026-10-20)

The owner `gfx/comm/comm_scene.asm` had 22 `Data_70_*` aliases at exact
addresses already named by descriptive frame, animation-script and shared
graphics labels. Its source hash matched the census parent; the current symbol
file confirmed every alias and descriptive label at the same address. The
candidates had no source, tool/metadata or local-scope consumers. Only the
redundant declarations were removed; bytes and inherited confidence remain
unchanged. See
[`retired_comm_scene_data_aliases.tsv`](../../analysis/naming2/retired_comm_scene_data_aliases.tsv).

Private receipt `.tmp/comm-scene-data-alias-pass-20261020/`: `PRECHECK.json`
SHA-256 `3e8a4d72f5ef03c0ff12ace6838212b32c920de135985e115f95791155cb3114`,
`RESULT.json` SHA-256
`60eb024a43dd75adb6838ac900e7a4a3396bdf3ea2cc4de834ead4eb43d7d4f2`, and
ledger SHA-256
`d20bc73f6a241c5a07f543288f98c42788c28e925c694dd91fe37730eae09375`.
The original-ROM identity, symbol, palette and PNG checks all pass.

## Retired communication-error text aliases (2026-10-20)

In `data/text/comm_error_messages.asm`, 21 `Data_21_*` declarations shared
exact addresses with existing descriptive text-record labels. The owner hash
matched the census parent; the current `.sym` confirmed all pairs, and a
maintained-source scan found only each generic declaration. The census recorded
no other source, tool/metadata or local-scope consumers. The pass removes only
the redundant declarations, preserving all emitted bytes and existing
confidence levels. See
[`retired_comm_error_data_aliases.tsv`](../../analysis/naming2/retired_comm_error_data_aliases.tsv).

Receipt `.tmp/comm-error-data-alias-pass-20261020/`: `PRECHECK.json` SHA-256
`0e424cd281b4db7df5107f9e8591e5f31d72a6c94604eca35483c95f818d93dd`,
`RESULT.json` SHA-256
`d1e928ea6468916c43ea1be77080558483e08b7ce2bf52115179e7f7793ceec8`, and
ledger SHA-256
`e5cb3b98e362e2019e16bf99e4de3960f46bd51ae6e771ea668200534bd1e136`.
The original-ROM identity, symbol, palette and PNG checks all pass.

## Retired music 04 stream aliases (2026-10-20)

The owner `audio/music/music_04.asm` contained 18 `Data_05_*` declarations
at exact addresses already named by `SoundSong04_*` stream/header labels.
Its source hash matched the census parent, all current symbol addresses
matched, and maintained-source searches found no use beyond each generic
declaration. The census also recorded no tool/metadata mentions or scoped
locals. Only duplicate names were removed; no stream interpretation, emitted
bytes or confidence levels changed. See
[`retired_music04_data_aliases.tsv`](../../analysis/naming2/retired_music04_data_aliases.tsv).

Receipt `.tmp/music04-data-alias-pass-20261020/`: `PRECHECK.json` SHA-256
`abdd950ebce0463b613763b9c0a4c0cbe377277ed3b4de66541fa7af21e211b8`,
`RESULT.json` SHA-256
`889a5a1063af607ba3d9ba73f4659e44477e1f1295bc8d4cc13437f44bb3b330`, and
ledger SHA-256
`a40649c8be27092bd60c84d1f83595d30356c674eec4d8ff609d0e7dcb475819`.
All original-ROM and static resource checks pass.

## Retired music 0A stream aliases (2026-10-20)

The owner `audio/music/music_0a.asm` contained 18 `Data_05_*` declarations
at exact addresses already named by `SoundSong0A_*` labels. The owner hash
matched the census parent; current symbols confirmed every alias pair, and
maintained-source searches found no consumer beyond each generic definition.
The census also recorded zero tool/metadata mentions and local scopes. This
retires redundant names only; it adds no interpretation of the music streams
and changes no emitted bytes or confidence. See
[`retired_music0a_data_aliases.tsv`](../../analysis/naming2/retired_music0a_data_aliases.tsv).

Receipt `.tmp/music0a-data-alias-pass-20261020/`: `PRECHECK.json` SHA-256
`88afc66f16c675b5aeda06d1b56b1bb4e66a61a3992f926ae79b23b8b43b8dcb`,
`RESULT.json` SHA-256
`fd90b91365952446b59b425cfe165ecad0cb195e8f97269394f5749619f0f5a8`, and
ledger SHA-256
`65871a0f4f2ed9bfbb717ceefd93d6e9239cb1cf15eb2caaf10ffcb8a37d5633`.
All original-ROM and static resource checks pass.

## Retired music 11 stream aliases (2026-10-20)

The owner `audio/music/music_11.asm` contained 18 `Data_05_*` declarations
at exact addresses already represented by `SoundSong11_*` labels. The owner
hash matched the census parent, the current symbol map confirmed every pair,
and source searches found no consumer beyond each generic declaration. The
census also found no tool/metadata mention or local scope. Only redundant
spellings were removed; this adds no audio interpretation and preserves all
bytes and existing confidence. See
[`retired_music11_data_aliases.tsv`](../../analysis/naming2/retired_music11_data_aliases.tsv).

Receipt `.tmp/music11-data-alias-pass-20261020/`: `PRECHECK.json` SHA-256
`b1651171f630b4d751244abf7b2692e4d10d8fe769c834b671a79c129cf15892`,
`RESULT.json` SHA-256
`7910f841cb8e37e78b4acc8f1a26e73f13f2201264dfddb1f3c0c9e10416a5ad`, and
ledger SHA-256
`8ee7f0b37ddc843686f6797cab93a52cf26949e04cfb9fb59de41da2997b1c06`.
All original-ROM and static resource checks pass.

## Retired profile-editor graphic aliases (2026-10-20)

The owner `gfx/profile/profile_editor.asm` contained 17 `Data_66_*` aliases at
addresses already represented by existing profile-editor graphic labels. The
file hash matched the census parent; current symbols confirmed all address
pairs, and searches of maintained sources found no generic-name consumer beyond
each declaration. The census recorded zero tool/metadata mentions and local
scopes. This removes redundant labels only and preserves the emitted data and
inherited confidence. See
[`retired_profile_editor_data_aliases.tsv`](../../analysis/naming2/retired_profile_editor_data_aliases.tsv).

Receipt `.tmp/profile-editor-data-alias-pass-20261020/`: `PRECHECK.json`
SHA-256 `ba160d94c109f78bc071add2a7150417d6cf1c8a7fbb7127b0004cc2f8167400`,
`RESULT.json` SHA-256
`e5fd200d0f1ddc3ca1677ec79100756000ad39aea5da160b8d229bbacb86add7`, and
ledger SHA-256
`a4792c8c92872dcd2d4f012375c63f823b21de87ee0e6de1b87c843a386339e4`.
All original-ROM identity and static resource checks pass.

## Retired shared-browser menu graphic aliases (2026-10-20)

The owner `gfx/browser/menus.asm` had 16 `Data_72_*` declarations sharing
exact addresses with existing descriptive menu-frame, script and tile labels.
The source hash matched the census parent and the current symbol file confirmed
all pairs. Exact-token scans found no generic consumer beyond each declaration;
the census showed no other source, tool/metadata or local-scope uses. A substring
inside a longer descriptive name was excluded as a separate reference. Only
duplicate declarations were removed; bytes and confidence are unchanged. See
[`retired_browser_menus_data_aliases.tsv`](../../analysis/naming2/retired_browser_menus_data_aliases.tsv).

Receipt `.tmp/browser-menus-data-alias-pass-20261020/`: `PRECHECK.json`
SHA-256 `47fdadb755b9a4130cb8f0eb43f76697bf68b34ed372054ccc112d4d6558214a`,
`RESULT.json` SHA-256
`ff52af20f2a0961d4431be8ffcdb6e1441e801bd6b4096f490375a9a8659c83c`, and
ledger SHA-256
`e223df1696e7232e41e0110e1ab2fa4114331d71516046fa24aa49e53d3fa47f`.
All original-ROM and static resource checks pass.

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

## Descriptive code-fragment label at 26:5344

A separate bounded review found that `Data_26_5344` labels a PROBABLE 56-byte
code fragment rather than a data object. The maintained Japanese source now uses
`MailSession_WriteVram1TileAndWram7ScreenRows`, a mechanically reviewed name for
the fragment's VRAM1 tile writes and WRAM7 screen-map row writes. No callable
entry or intended role is established. This fragment was outside the original
82-label no-alias candidate set, so its retirement is reported separately.
Frozen `config/regions/` and `analysis/mapper/` snapshots retain the old spelling.

The preceding checkpoint's exact-name count was 1,001 `Data_BB_AAAA::`
definitions across the six Japanese source roots, plus two in `zero_labels.asm`
(1,003 total). A re-count at `fd70bc46` found 1,000 definitions across the
six roots and one in `zero_labels.asm` (1,001 total); the earlier `+2` count was
incorrect. After the six co-alias retirements below, the `8303f049` checkpoint
count was 994 across the six roots plus one in `zero_labels.asm` (995 total).
After the bank22 continuation rename, `b073197e` had 993 across the six roots
plus one in `zero_labels.asm` (994 total). At the post-TOP `54:4C35` checkpoint,
the count was 992 across the six roots plus one in `zero_labels.asm` (993
total). The later browser-dialog and SMTP interval renames are recorded below.
These are lexical label counts only, not a measure of unresolved semantic
resources.

## Literal generic-name scan (2026-10-20)

At source revision `c3b3db48`, a literal scan of the six maintained Japanese
source roots found zero `Function_BB_AAAA` and zero `Font_BB_AAAA` tokens,
including the previously cited `Function_75_4000` and `Font_48_4ADB`. A path
scan found zero `gfx/` files or directories named `bankNN`. At that revision,
`Data_BB_AAAA` counted 993 definitions in those roots plus one in
`zero_labels.asm`, 994 total. After the structural rename below, the count at
that checkpoint was 992 plus one, 993 total. These are exact spelling counts
only; they do not establish that every function or resource has a known
semantic role.

## Retired account and bitmap-mask aliases (2026-10-20)

The account action-confirm source had two `Data_68_*` labels at the same
addresses as `Account_ActionConfirmCursorPositions` and
`Account_ActionMessageIds`; owner and linked-symbol checks confirmed the
co-location, and current source scans found no uses beyond each declaration.
Both redundant aliases were removed. At `51:73D1`, `Data_51_73D1` duplicated
`Table_Bmp_RowEndMask`. The values `$FF,$7F,$3F,$1F,$0F,$07,$03,$01,$00` are
indexed by `width & 7`; the selected mask is ORed into the last bitmap byte for
a non-aligned row. The source header incorrectly described RGB555 palette words
and has been corrected to the static consumer. The non-aligned branch is not
claimed as executed. The changes preserve emitted bytes and confidence levels.

The same current-source review retired `Data_68_4000` under
`Settings_MagicString`, a fixed 16-byte `MOBILE TRAINER00` sequence copied to
SRAM and compared at length `$10`; `Data_68_41DB` under `Account_MailAtSign`,
the NUL-terminated `@` separator appended between two address components; and
`Data_51_740C` under `ImageBlit_AllBitsMask`. Its existing comment records the
two PROBABLE edge-strip reads and unchanged `$FF` mask role; the stale comment
operand now uses the descriptive label. These retirements change no bytes or
confidence.

## Bank22 address-book tile continuation (2026-10-20)

`Data_22_5CEA` at `22:5CEA` is now
`AddrBook_ListAndAddressGraphicsContinuation`.
The bounded bank22 audit confirms it
starts at tile phase 10 within the family based at `22:5CD0`: six bytes finish
the split tile and 158 complete tiles follow. Both the list and address-editor
transfers use the same family base with offsets, so the label names the shared
continuation without assigning a narrower visual role. The old name had no
source consumer outside its declaration. No bytes, confidence levels or asset
catalogue entries changed.

## POP3 TOP pre-header-arguments copy (2026-10-20)

`Data_54_4C35` at `54:4C35` is now
`Data_Pop3Top_BytesCopiedBeforeHeaderArgs`. The TOP poll copies all eight bytes
to `C240..C247`, then copies the seven-byte selector-6 header argument block
over `C240..C246`. The remaining `$08` at `C247` is outside the seven-byte
selector-6 structure. Existing traces show 34 executions of the load/copy
point across seven scenarios, and interval coverage records reads of all eight
bytes in those scenarios; the
static byte sequence agrees with the original ROM. This supports the
structural name only: the purpose of the first copy and surviving byte remains
HYPOTHESIS, and the storage header remains PROBABLE. The byte-identical RETR
template is not evidence that TOP invokes the RETR selector-4 parser. No data
bytes or asset files changed.

The read-only baseline at `b073197e` reported 577 neutral data groups and 152
immediate-reference candidates, all rejected by its strict automatic
load-shape checks. At the post-TOP checkpoint, the inventory reported 576
groups and 151 rejected candidates, with no automatic rename rows. That
checkpoint inventory and manifest are retained in
`.tmp/generic-data-final-census-20261020/`; their SHA-256 values are
`d541e13241bc6aed5fee8649a08ac09407d177687aaba5508d0b1bc57235cc1b` and
`1a5e0a79621043b8f81cfe9e0e31dbd8b2e0322a582f9aee1a472a0b8db0f605`,
respectively. A neutral group's presence or a rejected site does not establish
its semantic role.

## Browser dialog argument and SMTP interval labels (2026-10-20)

`Data_4C_430A` is now `Data_BrowserLoadPage_ConnectDialogArgs`. The structural
name follows the demonstrated caller `Browser_LoadPage_AskConnect`, which
passes this bank-4C address to `ConnectDialog_Run`. The eight-byte extent and
whole-unit **PROBABLE** status remain unchanged; four bytes have no natural read
in the recorded scenarios, and this name does not establish a universal
argument ABI. The bounded field evidence and read limits are in
[`typing_4c_dialog.md`](typing_4c_dialog.md).

`Data_54_4764` is now `Data_Smtp_BytesBeforeCloseParen`, a positional name for
the 12 source bytes immediately before `String_Mail_CloseParen` at `54:4770`.
The location and extent are established by the maintained source boundaries;
the purpose remains **HYPOTHESIS**. The 69 available natural-scenario traces
show no reads from this interval, and the maintained-source consumer search
found no reader.
It remains a separately labeled byte range; neither its contents nor adjacency
to `Data_Smtp_HeaderComposeArgs` establishes a descriptor, arguments, padding,
or runtime use.

## Positional keyboard data label (2026-10-20)

`Data_55_6F95` is now `Data_Kbd_BytesBeforeRejectSymbol`, naming only the
12-byte source interval before the confirmed `Kbd_RejectSymbol` boundary at
`55:6FA1`. The HYPOTHESIS routine at `55:6F46` appears to index four words at
`6F95` and four delay bytes at `6F9D`, but its entry is unproven and no natural
consumer is established. The label therefore makes no claim that the values
are used as animation colors or delays. The data bytes and HYPOTHESIS header
are unchanged; `docs/research/classify_g2.md` retains the conditional static
analysis and limits.

After the browser-dialog and SMTP renames, before the keyboard rename, the
exact lexical count was 990 generic `Data_BB_AAAA::` definitions in the six
maintained Japanese roots plus one in `zero_labels.asm` (991 total). This is a
spelling count, not semantic closure. A fresh post-build
`data_consumers.py --stats` run at that checkpoint reported 574 neutral data
groups, 150 rejected candidates, and zero manifest rows; its inventory and
manifest are retained in
`.tmp/generic-data-census-20261020-postbuild/` with SHA-256
`9c25331539df774e29b792543a25321db68dae378c8205702d1d6d9cf393cbb6` and
`1a5e0a79621043b8f81cfe9e0e31dbd8b2e0322a582f9aee1a472a0b8db0f605`.

After the positional keyboard rename, a fresh post-build census reports 573
neutral data groups, 148 rejected candidates, and zero manifest rows. The
inventory and manifest are retained in
`.tmp/generic-data-census-20261020-keyboard/` with SHA-256
`42345fc1ac73d897c075ea892dffcf95383a4ae0206ebedf668d0d65d0a513a1` and
`1a5e0a79621043b8f81cfe9e0e31dbd8b2e0322a582f9aee1a472a0b8db0f605`.

## Decoded HelpScript welcome stream (2026-10-20)

`Data_6C_485A` is now `String_HelpScript_MobileTrainerWelcome`. Its 63 bytes
end in NUL at `6C:4898`; the next source boundary is `6C:4899`. The located
reader `HelpScript_StepText` at `6C:6009` treats `$10` as a line advance,
dispatches `$40` to the delay handler at `6C:607A`, and maps bytes `$A0..$FF`
through the 96-word table at `6C:58C7`; `$80..$9F` consume a second byte. The
`$40` handler consumes the following `$3C` argument, adding it to the delay
counter only when `wHelpScriptAdvanceMode` is zero and otherwise skipping it.
The mapping and complete source interval match the original ROM. The decoded
text welcomes the reader to Mobile Trainer and invites them to enjoy Mobile
System GB; `$40,$3C` is a control pair, not printable `@<`. Text identity and
the label remain **PROBABLE** because this pass did not verify final glyph
rendering or the natural menu/display path.

The original-byte and table comparison receipt is
`.tmp/bank6c-welcome-string-audit-20261020/RESULT.json`; the corrected receipt
pins the source/table hashes and ROM hash, and records the decoding limits.
Its SHA-256 is
`9cd94528accc14eca141892474e663a3d900059066a473f1dfaeb5fdcdfe1ace`.
The superseded pre-review receipt is retained as
`RESULT.pre-review-incorrect.json` (SHA-256
`7290208bce1822eb506a2369c4c755a49c207d74e4552ea8fc9eb1a0c22d2ab0`) so the
review correction remains auditable.
After this rename, the exact lexical count is 988 `Data_BB_AAAA::` definitions
across the six maintained roots plus one in `zero_labels.asm` (989 total). A
fresh post-build census reports 572 neutral groups, 147 rejected candidates,
and zero manifest rows; the inventory and manifest are in
`.tmp/generic-data-census-20261020-helptext/` with SHA-256
`e4ca8416a6232a1bcac1110f45738eb64d3ea42999f54746ad62a6064d32ad57` and
`1a5e0a79621043b8f81cfe9e0e31dbd8b2e0322a582f9aee1a472a0b8db0f605`.

## Song 0E track-0 continuation (2026-10-20)

The `Data_05_4024` symbol is now `SoundSong0E_Track0_Continuation`. The
source file is the 562-byte song-0E owner; the track table points to
`SoundSong0E_Track0` at `05:4000`, and its loop label is at `05:4004`.
`05:4024` follows that loop prefix in the same decoded command stream and
reaches `sound_jump SoundSong0E_Track0_Loop` at `05:4043`. The next named
label, `SoundSong0E_Track0_AfterJump`, begins at `05:4046`; therefore this
symbol covers a 34-byte interior continuation, while the existing shared
classification header spans 35 bytes through the one-byte `sound_end` at
`05:4046`. The track membership and byte interval are **PROBABLE**; this name
does not assert a separate entry point or a new playback path.

The frozen `config/regions/bank05.tsv` and generated
`analysis/mapper/bank05.tsv` still classify the 35-byte range as an
unclassified interior stream; they were not changed. Current maintained
source decodes the commands and the original-byte build preserves them. The
bounded post-build `data_consumers.py --stats` census reports 571 neutral
groups, 147 rejected immediate candidates and zero rename rows; its inventory
and manifest are retained in
`.tmp/jp-bank05-track-cont-pass-20261020/` with SHA-256
`d354a7bb2a604bebe10b3b7b2901fd9cc8168152e0a9358cd803903f43861fba` and
`1a5e0a79621043b8f81cfe9e0e31dbd8b2e0322a582f9aee1a472a0b8db0f605`.
The generic `Data_BB_AAAA::` count at that checkpoint was 987 in the six
maintained roots plus one in `zero_labels.asm` (988 total); this lexical result
is not a measure of semantic completion.

## Song 0E track-3 continuation (2026-10-20)

The `Data_05_41D0` symbol is now `SoundSong0E_Track3_Continuation`. The
label at `05:41D0` follows `SoundSong0E_Track3_Sub1` at `05:419F` and begins
with its final `sound_wait` and `sound_ret`, then includes a `sound_call`
to Sub1, the complete Sub2 body, the later Sub1/Sub2 calls, and the final
`sound_jump` at `05:4214`, targeting `SoundSong0E_Track3_Loop` at `05:416B`.
The next label,
`SoundSong0E_Track3_AfterJump`, is at `05:4217`; consequently the symbol
marks a 71-byte interior portion and the shared classification header spans
72 bytes including `sound_end`. Track membership and this boundary reading
are **PROBABLE**; the label does not imply a separate entry or playback path.

The frozen bank05 region maps remain unchanged. The decoded source and
original-byte comparison preserve the ROM. The post-build bounded
`data_consumers.py --stats` census reports 570 neutral data groups, 147
rejected candidates and zero rename rows. Its inventory and manifest are
retained in `.tmp/jp-bank05-track3-cont-pass-20261020/`; inventory SHA-256 is
`531ad6c5fd0a00c0b127fabd66e86c5477587a0fae743cb1d5d9134304686a17` and
manifest SHA-256 is
`1a5e0a79621043b8f81cfe9e0e31dbd8b2e0322a582f9aee1a472a0b8db0f605`.
At that checkpoint, the generic symbol count was 986 in
the six maintained roots plus one in `zero_labels.asm` (987 total), a lexical
count rather than a completion measure.

## Song 14 and Song 1A track continuations (2026-10-20)

Six interior source labels were replaced after comparing each source start,
track body, final jump, following `AfterJump` label, and decoded audio commands:

| Former label | New label | Interior bytes | Final jump | Next `AfterJump` |
|---|---|---:|---|---|
| `Data_05_4E22` | `SoundSong14_Track0_Continuation` | 56 | `05:4E57` to loop `05:4DA3` | `05:4E5A` |
| `Data_05_4F6A` | `SoundSong14_Track1_Continuation` | 28 | `05:4F83` to loop `05:4EAA` | `05:4F86` |
| `Data_05_4FD5` | `SoundSong14_Track2_Continuation` | 46 | `05:5000` to loop `05:4F9A` | `05:5003` |
| `Data_05_5085` | `SoundSong14_Track3_Continuation` | 28 | `05:509E` to loop `05:5031` | `05:50A1` |
| `Data_05_5E23` | `SoundSong1A_Track0_Continuation` | 19 | `05:5E33` to loop `05:5DD3` | `05:5E36` |
| `Data_05_609A` | `SoundSong1A_Track3_Continuation` | 52 | `05:60CB` to loop `05:602E` | `05:60CE` |

Each shared source classification span is one byte longer than its interior
portion because it includes the `sound_end` at the next `AfterJump` label.
The names say which decoded stream each interior byte position continues;
they do not claim independent entry points or playback paths. Track membership
and this interpretation remain **PROBABLE**.

The frozen bank05 region maps remain unchanged. The post-build bounded
`data_consumers.py --stats` census reports 564 neutral groups, 147 rejected
candidates, and zero rename rows. Inventory SHA-256 is
`9cc2534dd8f6b08da66397b32855db8476b683d25496500f7951b7e67d7fbab5`; manifest
SHA-256 is
`1a5e0a79621043b8f81cfe9e0e31dbd8b2e0322a582f9aee1a472a0b8db0f605`. Both
are retained in `.tmp/jp-bank05-neutral-song-continuations-20261020/`. The
generic `Data_BB_AAAA::` count is 980 in the six maintained roots plus one in
`zero_labels.asm` (981 total); this lexical count does not establish semantic
completion.

## Song 1D redundant generic aliases (2026-10-20)

Five same-address aliases were removed from `audio/music/music_1d.asm`:
`Data_05_62D0`, `Data_05_62E7`, and `Data_05_62FD` duplicated the existing
`SoundSong1D_Track0..2` labels; `Data_05_6312` duplicated
`SoundSong1D_Header`; and `Table_05_6314` duplicated
`SoundSong1D_TrackPtrs`. A maintained-source search found no consumers of the
old spellings; their remaining occurrences are in the frozen audio2/audio6
rename manifests and `config/regions/bank05.tsv`, retained as historical
analysis evidence. The region map is unchanged. No addresses or emitted bytes
changed.

At the `4c5143ec` checkpoint, four `Data_BB_AAAA::` removals reduced the exact
count to 976 in the six maintained roots plus one in `zero_labels.asm` (977
total). The redundant `Table_05_6314` removal did not affect that Data-label
count. The bounded post-build `data_consumers.py --stats` census at this
checkpoint reported 564 neutral groups, 147 rejected candidates, and zero
rename rows: all five aliases shared their addresses with semantic labels and
were excluded from neutral groups. These are historical checkpoint counts.
The
inventory SHA-256 is
`9cc2534dd8f6b08da66397b32855db8476b683d25496500f7951b7e67d7fbab5`; manifest
SHA-256 is
`1a5e0a79621043b8f81cfe9e0e31dbd8b2e0322a582f9aee1a472a0b8db0f605` in
`.tmp/jp-audio1d-redundant-aliases-20261020/`.

## Test configuration fields and current-reader review (2026-10-20)

The former mixed `Data_68_4F17` span is now represented by three bounded
fields in `engine/account/dev_test_config.asm`. `Dev_TestConfigImage_PopServerFieldPadding`
at `68:4F17` covers the two zero bytes at the end of the 20-byte POP-server
field; `Dev_TestConfigImage_ServerIp` at `68:4F19` covers four zero bytes; and
`Dev_TestConfigImage_DialSlot0Bcd` at `68:4F1D` covers the eight-byte first
dial-slot field. These roles are **PROBABLE**. The SDK copies `Window+$4A`
through `$C6DD` and places the server field at `$C705–$C708`; slot export uses
the image offsets and eight-byte BCD parser. The test image's correspondence
to a connected adapter, installer execution, and persistence remain unproven.
The comments identifying the copy setup now correctly point to `68:4E6A`.

The exact `Data_48_69AB` investigation found a static, conditional reader path
from keyboard-table pairs `$FF82/$FF83` through `Kbd_DrawGlyphPreview` to
`Font_BlitGlyph8x16`. An independent reviewer rejected the proposed
`ZeroGlyphFallback` names: the code's ordinary table arithmetic reads the two
zero halves, but neither “glyph” nor “fallback” is established as the stored
object's identity or intent. The neutral label remains pending further
evidence; see [the bounded reader note](font_reader_69ab_bounds_20261020.md).

The same current-source review corrected a stale `Function_2B_687C` token in
`gfx/previews/sprites.tsv` to the existing operation name
`Sprite_SetSlots1And2Y68XByC_InitSlot2`. It changed only the metadata token.

## Current lexical count correction (2026-10-20)

The `977 total` above is the historical count at the `4c5143ec` checkpoint, not
the current tree. A fresh literal scan of the six maintained roots at
`5a1171cde22b0cd017d4eb44312c9dd3834d529f` finds **959** definitions matching
`Data_BB_AAAA::` in `.asm` files and none in `.inc`; `zero_labels.asm` adds one,
for **960 total**. The `.asm` counts by root are: `engine` 132, `data` 54,
`gfx` 553, `audio` 219, `lib` 1, and `home` 0. Comparing the same six roots
and `zero_labels.asm` at `4c5143ec` with current `HEAD` yields 17 removed
definitions and no additions. This reconciles the intervening structural
renames and alias retirements; it is still a lexical inventory, not a count of
unknown objects or proof of semantic completion.

## Song03 redundant-alias follow-up (2026-10-20)

Commit `018d2470710c8ffaaa01c5b98690d0034d49bc49` removes the 17 remaining
`Data_04_*` definitions from `audio/music/music_03.asm`. Each was a same-address
alias of an existing `SoundSong03_*` label; exact-token scans found no current
source/tool/metadata operand or local-scope dependency. Historical mapper and
rename-ledger spellings remain unchanged. Independent review accepted the exact
17-line removal, confirmed the 325 emitting directive rows are preserved, and
kept the four `AfterJump` roles PROBABLE. No stream meaning, playback, natural
entry, or hardware evidence was promoted.

At `018d2470`, the six maintained roots contain **942** exact
`Data_BB_AAAA::` definitions; `zero_labels.asm` adds one, for **943** total.
`tools/data_consumers.py --stats` still reports **523** neutral groups, **123**
rejected candidate sites, and zero manifest rows. These lexical/tool counts do
not measure semantic completion. `make` is SHA-256 OK and `RESULT: IDENTICAL`
to the Japanese original; `make sym-check` reports 13,544 labels and 51
constants; `make palette-check` reports 162 loads/116 arrays, two documented
overreads and zero errors. Full review is retained in the private
`.tmp/parallel-jp-census-20261020/REPORT.md` and
`.tmp/parallel-jp-function-audit-20261020/SONG03_REVIEW.md`.

## Restricted six-root reconciliation after later alias retirements (2026-10-21)

To avoid opening the protected `engine/mail/sample_data.asm`, this controlled
comparison uses the same six maintained roots and exact `Data_BB_AAAA::`
definition pattern while explicitly excluding that path, `languages/`, and
all non-ASM/INC files. The ignored file is neither read nor counted. A
reproducible script and per-root results are retained in
`.tmp/generic-data-census-20261021/` (result SHA-256
`d0967b53efa11522f4280a4f57fbcdb5bdd4928240188a43ccd49a05b48c1643`).

| checkpoint | engine | data | gfx | audio | lib | home | six roots | `zero_labels.asm` | total |
|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|
| `5a1171cd` restricted baseline | 127 | 54 | 553 | 219 | 1 | 0 | 954 | 1 | 955 |
| `018d2470` after Song03 | 127 | 54 | 553 | 202 | 1 | 0 | 937 | 1 | 938 |
| `338f5344` after Song07 and keyboard naming | 126 | 54 | 553 | 185 | 1 | 0 | 919 | 1 | 920 |
| `58db93a4` after Song02 | 126 | 54 | 553 | 170 | 1 | 0 | 904 | 1 | 905 |
| `41c92b60` after bank2C aliases | 126 | 54 | 547 | 170 | 1 | 0 | 898 | 1 | 899 |

The 56-definition drop in the restricted corpus is accounted for by the
17 Song03 alias deletions, 18 definitions retired or structurally renamed by
the Song07/keyboard checkpoint, 15 Song02 alias deletions, and six generic
bank2C alias deletions. The older 959 six-root result at `5a1171cd` used a
different inclusion set and is not directly comparable to this table; the
protected file's content was not inspected to resolve that discrepancy. These
are exact lexical counts only, not counts of unidentified data or a semantic
completion measure.

## Reconciliation of the historical 59-group cohort (2026-10-20)

The retained original 82-row non-GFX matrix is authenticated to commit
`a3238e6e998d44f6ec7ddfa479baad6743604110`; all 243 source guards, nine
manifest entries, 82 symbol addresses, and 82 ROM-span hashes match their
recorded inputs. Comparing all 333 maintained ASM/include files in the later
`4c5143ecd9ea8808cd91991f647263554ec39375` snapshot against its Git objects
derives **59 surviving old labels and 23 retired labels**. This is specifically
the surviving original non-GFX no-co-alias cohort; it is not a remainder of the
current 523-group `data_consumers.py` census and must not be subtracted from it.

A separate historical receipt for the cited **49 spans** was not located in
the bounded retained-file search. The original 82-row matrix happens to contain
49 rows whose decision is not `NEEDS_ENTRY_ANALYSIS`, but no evidence connects
that predicate to the handoff's 49-span count. Only 28 names from that candidate
49-row subset survive at the later 4c snapshot. Keep the 49-span provenance
unresolved; do not equate the two counts. The full search and reproducible
derivation are in `.tmp/parallel-jp-census-20261020/HISTORICAL_MATRIX_SEARCH.md`
(SHA-256 `c8035b2e8bfa3a720b4a5fd3302eb4180f28eeb55eb3d86306809b12c12a67b1`).
No source change, build, or cleanup was needed for this historical reconciliation.

## Protected-file-excluded data-consumer tool run (2026-10-21)

To refresh the dated consumer-group metric without reading
`engine/mail/sample_data.asm`, the unchanged `tools/data_consumers.py` and its
model dependencies were run in `.tmp/data-consumer-census-private-20261021/`.
The private source snapshot contains 331 maintained ASM files from the six
source roots and physically omits the protected file; it uses the Japanese
ROM and `build/mobile_trainer.sym` copied from commit
`25ede6ec0042d14b45fd1707abf2c7705bb4360d`. The normal script hash is
`4ded7d379c655bc4c4004e0c3e7f3eea451cb74cfb0f856792abdd733da44954` and
matches the repository copy. The source archive hash is
`9c56f4128fd0bd1240d2d11766af8e939017e3e992d608566bbcd239474da9a8`; the
configuration/tools input archive hash is
`0f8b886b723714cbd7dffb97c356205edc3d5a98b643055ed54e203ddc2d34cf`.

The normal run completed with exit 0 and reports 522 neutral data groups, 122
candidate immediate sites, 122 rejected sites, and zero manifest rows. A
separate diagnostic copy of the script (not the production tool) counted the
rejection shapes: 91 `Sprite_InitSlot`, eight `Gfx_StartHDMAWithService`,
eleven tilemap loaders, three palette loaders, and nine other/unrecognized
loader candidates; every candidate failed the tool's strict load-shape
acceptance predicate. Therefore this is a valid bounded rerun of the tool
metric, but it is **not** a consumer map and does not show that the 522 groups
have no readers. The older 523/570 tool counts likewise are not semantic
completion counts. The 899 lexical `Data_BB_AAAA::` definitions above are a
different measure and must not be reconciled by subtracting these groups.

The exact normal stdout is retained in
`.tmp/data-consumer-census-private-20261021/DATA_CONSUMER_STATS.txt` (SHA-256
`3d67dd47e89e93fa6ab0be3fcc283d040c729bf866fe6ef35a6257525590b78d`); the
private diagnostic stdout is `DATA_CONSUMER_DIAGNOSTIC.txt` (SHA-256
`546ee9338002122abd34506f08b50d41ffa5c84d0a60dd440a6dcf6b0ac0c02f`). The
consumer census remains an open follow-up requiring a method that can assign
real consumer contracts without relying on the currently rejecting tool.

## Safe lexical scan of generic source names (2026-10-21)

A separate path-list-based scan used `git ls-files` and excluded the exact
`engine/mail/sample_data.asm` path before opening any source file. Its 331-file
input set is pinned by aggregate SHA-256
`d382dc614f8686ec237949876091425734e87548406a5f54af3aa35fae422a76` at
`25ede6ec0042d14b45fd1707abf2c7705bb4360d`. It found 898
`Data_BB_AAAA::` definitions, zero `Function_BB_AAAA::`, `Font_BB_AAAA::` or
`Label_BB_AAAA::` definitions, and no global labels beginning with
`Function_`, `Func_`, `Routine_`, `Subroutine_`, `Code_`, `Unknown_`,
`Unidentified_` or `Entry_`. It also found no direct `gfx/bankNN` directory.
This is a lexical census only; the remaining neutral data labels and semantic
coverage of routines remain open.

An earlier broad `rg` command in this pass used an exclusion glob that may not
have matched the protected file when `engine/` was supplied as a separate
search root. Its output was discarded and was not used in these counts. The
safe scanner checks the exact repository-relative path before any content read;
its source is retained as
`.tmp/data-consumer-census-private-20261021/safe_source_name_scan.py` (SHA-256
`bfadfffd61c998716b270fe1cba1901c848fed1687faaaab62e904b274250f46`) and its
result as `SOURCE_NAME_SCAN.json` (SHA-256
`8ef10a8e54ca72f8779587a2ae8fe684c230f08042a5566136343b80ce771a31`).

An extended path-safe scan added the tracked `ram/` owners (336 ASM/INC files
total) and checked the exact generic `wRam_AAAA` form as well. It reconfirms
898 `Data_BB_AAAA` labels, zero generic `Function_`, `Font_`, `Label_` or
`wRam_` address labels, zero other global function-like generic prefixes, and
no `gfx/bankNN` directories. The input-set SHA-256 is
`dc4811db834dc0caf4a382e3eba42d4943ce623760867370e24cef8e1fc434ce`; the
source is `.tmp/data-consumer-census-private-20261021/safe_generic_identifier_scan.py`
(SHA-256 `55cbd325077cdf2556bb1ddb9b0be799547767c099c4036b4b9eedcf66d892f7`)
and its result is `GENERIC_IDENTIFIER_SCAN.json` (SHA-256
`b6863c0687479c5ca4d5187a823377a70bdeb99984955cd3476db0bdc072fc7d`).

## Follow-up: consumer candidates manually classified (2026-10-21)

An independent static review of every candidate used a private source snapshot
that physically omitted `engine/mail/sample_data.asm`. Of 122 candidate
links, 114 assigned an incorrect bank and eight sites are valid static
consumers of six neutral data groups, but those consumers use forms outside
the detector's four accepted load shapes. The 516 remaining groups have no
decision in this pass. Thus the earlier zero-row output measures rejected
naming proposals, not the absence of readers. `CLASSIFICATION.tsv` and
`GROUP_LEDGER.tsv` are retained under
`.tmp/agent-data-consumer-mismatch-20261021/`; the full report SHA-256 is
`0235dfba74b8d468319e4e3725e471ddaeae9db02d3d78f9d82da2bf12196b8a`.

The eight sites include bank-aware string reads, a DE-to-HL tilemap source,
an indexed mail table, and a ticker table. The review also found that the
comment for `String_2B_5807` says there is no direct reference despite two
symbolic references and a local reader at `2B:5896`. This contradiction is
confirmed statically but remains to be corrected in the assembly comment.
No assembly, tool, or ROM changes were made, and no build was run for this
review.

## Redundant browser frame-table alias retired (2026-10-21)

The source label `Data_73_5E60` was a duplicate of the existing
`SpriteFrameTable_73_5E60` at the same address. A current path-safe Git search
excluding `languages/` and the protected `engine/mail/sample_data.asm` found
no other consumer of `Data_73_5E60`; the table-backed object-root entry already
uses the descriptive name. The generic export is retired and its source line
is blank to preserve line numbering. Frame and script directives, address,
payload bytes and confidence are unchanged. This is a redundant-alias cleanup,
not evidence for visual identity, a Pokémon association, or global use.

The controlled six-root lexical census at `25ede6ec` recorded 898 generic data
definitions in 331 ASM owners (excluding the protected sample). A fresh
path-scoped scan of current tracked non-language ASM files, again excluding the
protected sample, finds 897 after this retirement. This count is lexical; it
does not establish that the remaining generic labels are all unidentified or
have safe semantic replacements.

## Redundant Shift-JIS ellipsis alias retired (2026-10-21)

`Data_54_4CAD` was an exact-address duplicate of the existing, CONFIRMED
`String_Text_Ellipsis` label. Its bytes are `$81 $63 $00`; `Text_TruncateSjis`
passes the semantic label to `CopyString` or copies its two payload bytes with
`CopyBytes`. A path-scoped tracked-file search excluding `languages/` and the
protected `engine/mail/sample_data.asm` found the generic spelling only in its
source declaration, plus historical docs and the frozen `config/` and
`analysis/` evidence tables. The duplicate source export is retired, its line
is blank to preserve line numbering, and no bytes or confidence changed.

After the `Data_73_5E60` and `Data_54_4CAD` retirements, the same lexical scan
of tracked non-language ASM files excluding the protected sample finds 896
`Data_BB_AAAA::` definitions. This is a naming census, not a count of
unidentified resources or a semantic completion measure.

## CommScene aliases and remaining animation-shaped data (2026-10-21)

Four same-address `Data_70_*` aliases at `$5490`, `$5890`, `$5C90` and `$6090`
duplicated existing `Gfx_CommScene_Tiles*` labels. They were retired from the
assembly and the four catalog rows in `gfx/assets.tsv` now use the descriptive
names. The 4,096 ROM bytes and all four HDMA loader references remain intact.
Independent review accepted all four retirements. A before/after SYM and MAP
comparison found exactly four removed symbol lines and no other changes.
`make`, `make sym-check`, `make palette-check` and `make png-check` passed;
the ROM remains `RESULT: IDENTICAL`. This count does not imply semantic
uncertainty for every label.

The other 68 generic data labels in `gfx/comm/comm_scene.asm` remain neutral:
58 records fit count-plus-four-byte-entry shapes and 10 fit count-plus-two-byte
script shapes. Their formats are PROBABLE, but their four island object tables
have no executed caller in the checked evidence, so the records are not renamed.
Comments were corrected against `Sprite_LoadObjectEntry` and
`Sprite_StepAndDrawSlot` in `home/sprites.asm`: the object index effectively
uses the low six bits, the script pointer is stored at slot+6/+7, and the script
index is at slot+8. This corrects the prior `B&7F` and script-read descriptions
without claiming execution for the isolated tables.

The separate SaveSender/address-book audit retained all 27 candidate labels.
It found no aliases or sufficiently supported replacement names; 2,549 source
bytes were accounted for, but no local consumer chain was established. Details
and bounded private reports remain under `.tmp/agent-comm-scene-data-audit-20261021/`,
`.tmp/agent-comm-scene-alias-review-20261021/` and
`.tmp/agent-save-sender-data-audit-20261021/`.

## Top-menu animation tilemap frame sequence (2026-10-21)

`Data_1E_4357` is now `TopMenu_AnimTilemapFrames`. Independent review accepted
the name and CONFIRMED the bounded static layout: two frames at `$4357` and
five at `$44E3`, each `$C6` bytes (99 tile IDs followed by 99 attributes for a
9×11 rectangle). The two bank-1F call paths use `Tilemap_CopyRectAndAttr` with
`B=$09`, `C=$0B`, and `wTopMenu_AnimFrame` selects the offset. Their address and
bank immediates now use the semantic label while preserving the original
encoding. Existing traces read 990 bytes; the remaining 396 have no recorded
read, and the loops do not prove a general bounds check. No display or universal
frame-reachability claim is made. The independent report is retained at
`.tmp/agent-top-menu-anim-review-20261021/REPORT.md` (SHA-256
`ed07ba53f9a5ab9c8f5a7c0ac6108f60922ff9afd496b3a44fc1cde29488eadc`).
The census pinned to `1485975350e230be41906fce14af44c1ef7b262a` found 888
generic data labels in the six maintained roots and one separate
`zero_labels` definition (889 total), excluding
`languages/` and `engine/mail/sample_data.asm`. The script and receipt are
retained in `.tmp/generic-data-current-safe-census-20261021/`; their SHA-256
values are respectively `88de64d009ad50018f8fcb7d068448eec1d642b5b09d1b18d7846a3de2babae8`
and `6fbb8b15e07454b5b3345a8459f9f0773ae0489dd659459635c0049227fcadc0`.

## Top-menu palette alias retirement (2026-10-21)

`Palette_1E_62A0` and `Palette_1E_62E0` duplicated the existing
`Palette_TopMenu_Bg` and `Palette_TopMenu_Obj` labels at the same addresses.
The two aliases had no source consumers; current palette-load operands and
`gfx/previews/screen_ops.tsv` already use the semantic labels. The source
exports were removed and the corresponding `gfx/assets.tsv` label fields now
match the retained names. Both 64-byte palette blocks, their PROBABLE status,
and every load/call remain unchanged. Historical `config/`, `analysis/` and
prior research rows retain their snapshot spellings as provenance; they are
not current source exports.

`make` produced `RESULT: IDENTICAL` at the original ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
`make sym-check` reports 13,388 source labels and 51 constants; palette checks
report 162 loads, 116 arrays, two documented over-reads and zero errors; PNG
checks pass for 408 tile sheets, four raw byte views, 37 font sheets and 95
screen PNGs. The two-label change removes no ROM bytes.

## Dialog message address aliases retired (2026-10-21)

Nine `String_72_AAAA` exports in `data/text/dialog_messages.asm` duplicated
same-address semantic message labels and had no maintained ASM/INC references
outside their declarations. They are retired in favor of the existing record
names:

| Retired alias | Retained label |
|---|---|
| `String_72_5483` | `String_Dialog_Msg010D` |
| `String_72_5552` | `String_Dialog_Msg0110` |
| `String_72_5621` | `String_Dialog_Msg0113` |
| `String_72_5666` | `String_Dialog_Msg0114` |
| `String_72_5735` | `String_Dialog_Msg0200` |
| `String_72_5804` | `String_Dialog_Msg0203` |
| `String_72_5918` | `String_Dialog_Msg0207` |
| `String_72_6080` | `String_Dialog_Msg0222` |
| `String_72_6392` | `String_Dialog_Msg022B` |

The alias lines were replaced with blank lines to preserve source line numbers.
String bytes, table entries, address comments, and confidence are unchanged.
Historical `config/` and `analysis/` references remain snapshot evidence. The
original ROM rebuild is byte-identical; `sym-check` reports 13,379 labels and
51 constants, palette checks pass (162/116/2/0), and PNG checks pass
(408/4/37/95).

## Connect-dialog string aliases retired (2026-10-21)

Three `String_56_AAAA` exports duplicated existing labels in
`data/text/connect_dialog.asm`: `String_56_4000` with
`String_ConnectDialog_Messages`, `String_56_4047` with
`String_ConnectDialog_PasswordEntryPrompt`, and `String_56_4159` with
`String_ConnectDialog_CancelPasswordStorageConfirm`. A path-safe search found
no active source consumers of the address-only names; the connect-dialog
reader uses the semantic names. The three alias lines were blanked to preserve
line numbering. Existing strings, addresses and confidence are unchanged.
`tools/data_consumers.py` contains a historical mapping for
`String_56_4000`; its `already_named` guard verifies the retained name at the
same address and skips the removed alias. Frozen `config/` and historical
`analysis/` records keep their original spellings.

The Japanese ROM rebuild is `RESULT: IDENTICAL` with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`sym-check` reports 13,376 labels and 51 constants, palette checks pass
(162/116/2/0), and PNG checks pass (408/4/37/95).

## Browser-start ticker aliases and refreshed census (2026-10-21)

`Data_73_4000`, `Table_73_4001` and `String_73_4009` were redundant
same-address exports beside `Data_BrowserStart_StringIndexBank`,
`BrowserStart_StringTable` and `BrowserStart_Strings`. An exact-token scan of
the maintained Japanese ASM/INC, tools and gfx metadata found the generic
spellings only at their declarations. Current browser code and the far ticker
reader use the descriptive field and string labels. The alias lines are blank
to preserve physical line numbers; the bank byte, four pointer words, strings,
region boundaries and existing confidence are unchanged. Historical xref,
region and naming ledgers retain the old spellings as snapshot evidence.

The refreshed safe source census excludes `languages/` and
`engine/mail/sample_data.asm`; it read 347 tracked ASM/INC files and confirms
887 `Data_BB_AAAA::` definitions in the six maintained roots plus one in
`zero_labels.asm` (888 total). The source-set SHA-256 is
`7d43bf2a7de0ce52f8ca099b87ff8b8117bb7ceaf325dc7f3b93e9abc8757d3e`.
Reproduction script SHA-256 is
`88de64d009ad50018f8fcb7d068448eec1d642b5b09d1b18d7846a3de2babae8`; result
receipt SHA-256 is
`fc2b0d1eb12f9e8d6d10d6e74e177793eb69667dba7013769124730778064ef5` under
`.tmp/generic-data-current-safe-census-20261021/`.

The original build remains `RESULT: IDENTICAL` with ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`sym-check` reports 13,373 labels and 51 constants, palette checks pass
(162/116/2/0), and PNG checks pass (408/4/37/95).

## CommNotice screen-table alias retired (2026-10-21)

`Table_50_4244` duplicated `Table_CommNotice_Screens` at `50:4244`. Its only
remaining current-source mentions were the declaration and eight explanatory
comments in `gfx/comm/notice_dialog.asm`; the routine in
`engine/comm/notice_dialog.asm` already indexes the semantic name. The generic
export was retired and the comments now use `Table_CommNotice_Screens`. The
eight pointer words, target addresses, PROBABLE table classification and
physical line counts remain unchanged. Historical `config/` and `analysis/`
rows preserve the old snapshot name.

`make` remains `RESULT: IDENTICAL` with original ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`sym-check` reports 13,372 labels and 51 constants, palette checks pass
(162/116/2/0), and PNG checks pass (408/4/37/95).

## Bank 55 keyboard same-address aliases (2026-10-21)

A corrected case-insensitive symbol census found 23 address-only labels in
`data/keyboard/pages.asm` that exactly co-address existing keyboard labels.
The neutral spellings had no consumers outside their declaration in current
non-language source or tools; no local labels followed any declaration. The
semantic names are already used by the page-pointer table or identify the
keyboard header, neighbour table, and neighbour-record blocks. Retired the
23 redundant exports while keeping their physical source-line slots blank.
All bytes, pointer values, block extents and existing PROBABLE classifications
remain unchanged. Historic `config/` and `analysis/` snapshots retain the old
address names.

Address mapping (`bank 55`): `4000 Data_55_4000` -> `Table_Kbd_StartCell`;
`4014 Table_55_4014` -> `Table_Kbd_PagePointers`; `4046 Data_55_4046` ->
`Data_Kbd_Page_Digits`; `40B2 Data_55_40B2` -> `Data_Kbd_Page_IdChars`;
`4142 Data_55_4142` -> `Data_Kbd_Page_PhoneKeypad`; `41D2 Data_55_41D2` ->
`Data_Kbd_Page_Ascii3`; `4286 Data_55_4286` -> `Data_Kbd_Page_Ascii4`;
`433A Data_55_433A` -> `Data_Kbd_Page_Ascii5`; `43EE String_55_43EE` ->
`Data_Kbd_Page_T6_Hiragana`; `460A String_55_460A` ->
`Data_Kbd_Page_T6_Symbols`; `46BE String_55_46BE` ->
`Data_Kbd_Page_T78_Hiragana`; `48DA String_55_48DA` ->
`Data_Kbd_Page_T78_Symbols`; `498E Data_55_498E` ->
`Data_Kbd_Page_T9_Ascii`; `4A42 Table_55_4A42` ->
`Table_Kbd_NeighbourRecords`; `4A56 Data_55_4A56` ->
`Data_Kbd_T0_NeighbourRecords`; `4B9A Data_55_4B9A` ->
`Data_Kbd_T1_NeighbourRecords`; `4D4A Data_55_4D4A` ->
`Data_Kbd_T2_NeighbourRecords`; `4EFA Data_55_4EFA` ->
`Data_Kbd_T3_NeighbourRecords`; `5116 Data_55_5116` ->
`Data_Kbd_T4_NeighbourRecords`; `5332 Data_55_5332` ->
`Data_Kbd_T5_NeighbourRecords`; `554E Data_55_554E` ->
`Data_Kbd_T6_NeighbourRecords`; `576A Data_55_576A` ->
`Data_Kbd_T78_NeighbourRecords`; `5986 Data_55_5986` ->
`Data_Kbd_T9_NeighbourRecords`.

The private census receipt is under
`.tmp/generic-coalias-census-20261021/` (result SHA-256
`4554836f20cf0d5d16644a968d20083e9264f2612c4177ec0230ef183ac74f74`,
source-set SHA-256
`8a7e32fb618b16fc1dd0d64bebb80361bd0450a595c3d237cf3bd9fef6df9861`).
The corrected census is a candidate inventory, not a blanket approval for
other aliases.
## CommNotice resource aliases retired (2026-10-21)

`gfx/comm/notice_dialog.asm` contained 32 same-address generic labels co-addressing existing named tilemap, attrmap, graphics, palette, or animation resources. The corrected census found no references outside the owner and no tool references. In-file token occurrences were limited to the 32 declarations and eight comments describing each attribute map as paired with its tilemap, plus two comments naming the object table; those ten comment tokens were updated to the retained semantic names. No local labels followed the retired declarations. Physical source lines are preserved blank; resource bytes, extents, table entries and confidence classifications are unchanged. Historical snapshots preserve the old spellings.

| Address | Retired label | Retained label |
|---|---|---|
| 50:439A | `Tilemap_50_439A` | `Tilemap_CommNotice_A_CutOver60` |
| 50:4502 | `Attrmap_50_4502` | `Attrmap_CommNotice_A_CutOver60` |
| 50:466A | `Tilemap_50_466A` | `Tilemap_CommNotice_A_AskOver60` |
| 50:47D2 | `Attrmap_50_47D2` | `Attrmap_CommNotice_A_AskOver60` |
| 50:493A | `Tilemap_50_493A` | `Tilemap_CommNotice_A_CutSoon` |
| 50:4AA2 | `Attrmap_50_4AA2` | `Attrmap_CommNotice_A_CutSoon` |
| 50:4C0A | `Tilemap_50_4C0A` | `Tilemap_CommNotice_A_AskSoon` |
| 50:4D72 | `Attrmap_50_4D72` | `Attrmap_CommNotice_A_AskSoon` |
| 50:4EDA | `Tilemap_50_4EDA` | `Tilemap_CommNotice_B_CutOver60` |
| 50:5042 | `Attrmap_50_5042` | `Attrmap_CommNotice_B_CutOver60` |
| 50:51AA | `Tilemap_50_51AA` | `Tilemap_CommNotice_B_AskOver60` |
| 50:5312 | `Attrmap_50_5312` | `Attrmap_CommNotice_B_AskOver60` |
| 50:547A | `Tilemap_50_547A` | `Tilemap_CommNotice_B_CutSoon` |
| 50:55E2 | `Attrmap_50_55E2` | `Attrmap_CommNotice_B_CutSoon` |
| 50:574A | `Tilemap_50_574A` | `Tilemap_CommNotice_B_AskSoon` |
| 50:58B2 | `Attrmap_50_58B2` | `Attrmap_CommNotice_B_AskSoon` |
| 50:5A20 | `Data_50_5A20` | `Gfx_CommNotice_A_Tiles9000` |
| 50:5E20 | `Data_50_5E20` | `Gfx_CommNotice_A_Tiles9400` |
| 50:5FC0 | `Data_50_5FC0` | `Gfx_CommNotice_A_Tiles8000Vb1` |
| 50:5FD0 | `Data_50_5FD0` | `Gfx_CommNotice_A_Tiles9000Vb1` |
| 50:62F0 | `Data_50_62F0` | `Gfx_CommNotice_B_Tiles9000` |
| 50:66F0 | `Data_50_66F0` | `Gfx_CommNotice_B_Tiles9400` |
| 50:6890 | `Data_50_6890` | `Gfx_CommNotice_B_Tiles8000Vb1` |
| 50:68A0 | `Data_50_68A0` | `Gfx_CommNotice_B_Tiles9000Vb1` |
| 50:6BC0 | `Palette_50_6BC0` | `Palette_CommNotice` |
| 50:6CC0 | `Table_50_6CC0` | `CommNotice_Anim0Frames` |
| 50:6CC4 | `Data_50_6CC4` | `CommNotice_Anim0Frame0To1` |
| 50:6CE6 | `Data_50_6CE6` | `CommNotice_Anim0Script` |
| 50:6CEB | `Table_50_6CEB` | `CommNotice_Anim1Frames` |
| 50:6CEF | `Data_50_6CEF` | `CommNotice_Anim1Frame0To1` |
| 50:6D11 | `Data_50_6D11` | `CommNotice_Anim1Script` |
| 50:6D16 | `Table_50_6D16` | `CommNotice_ObjTable` |

The attached address census is only a candidate inventory. This pass does not infer any additional resource purpose beyond the existing names or promote the resource confidence. The original build remains byte-identical; see the 2026-10-21 checkpoint and its validation results in the current reverse-engineering status.

Validation for the CommNotice checkpoint: `make` returns `RESULT: IDENTICAL`
with ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` reports 13,317 labels and 51 constants. A before/after symbol
comparison found exactly the 32 retired labels missing, with no added or moved
labels. `make palette-check` passes (162/116/2/0), `make png-check` passes
(408/4/37/95), and `tools/data_consumers.py --stats` reports 519 groups, 120
rejected candidates and zero rows.
## Mobile dictionary same-address aliases retired (2026-10-21)

The corrected bank/address census found 72 generic labels in `engine/help/mobile_dictionary.asm`, each at the exact address of one existing semantic label. The generic token appeared only in its declaration; the scan found no other tracked ASM/INC or tool references, and no local labels scoped under these declarations. The set is made up of category-tab positions, category counts, and dictionary-entry strings already named `Table_MobileDict_*`, `Data_MobileDict_*`, or `String_MobileDict_*`. The existing semantic names remain the sole description; category-entry numbering is preserved without inferring string meaning. Retired all 72 redundant exports and left their source lines blank to preserve physical line numbering. ROM bytes, table boundaries, entries, and pre-existing confidence remain unchanged. Frozen `config/` and historical analysis may retain the old names.

| Address | Retired label | Retained label |
|---|---|---|
| 1A:437B | `Data_1A_437B` | `Table_MobileDict_TabPositions` |
| 1A:444F | `Data_1A_444F` | `Data_MobileDict_Cat01Count` |
| 1A:4462 | `String_1A_4462` | `String_MobileDict_Cat01Entry00` |
| 1A:446D | `String_1A_446D` | `String_MobileDict_Cat01Entry01` |
| 1A:4476 | `String_1A_4476` | `String_MobileDict_Cat01Entry02` |
| 1A:447F | `String_1A_447F` | `String_MobileDict_Cat01Entry03` |
| 1A:448E | `String_1A_448E` | `String_MobileDict_Cat01Entry04` |
| 1A:449D | `String_1A_449D` | `String_MobileDict_Cat01Entry05` |
| 1A:44A4 | `String_1A_44A4` | `String_MobileDict_Cat01Entry06` |
| 1A:44B1 | `String_1A_44B1` | `String_MobileDict_Cat01Entry07` |
| 1A:44BC | `String_1A_44BC` | `String_MobileDict_Cat01Entry08` |
| 1A:44C7 | `Data_1A_44C7` | `Data_MobileDict_Cat02Count` |
| 1A:44CC | `String_1A_44CC` | `String_MobileDict_Cat02Entry00` |
| 1A:44E0 | `Data_1A_44E0` | `Data_MobileDict_Cat03Count` |
| 1A:44F1 | `String_1A_44F1` | `String_MobileDict_Cat03Entry00` |
| 1A:44F8 | `String_1A_44F8` | `String_MobileDict_Cat03Entry01` |
| 1A:44FF | `String_1A_44FF` | `String_MobileDict_Cat03Entry02` |
| 1A:4508 | `String_1A_4508` | `String_MobileDict_Cat03Entry03` |
| 1A:4511 | `String_1A_4511` | `String_MobileDict_Cat03Entry04` |
| 1A:4520 | `String_1A_4520` | `String_MobileDict_Cat03Entry05` |
| 1A:452D | `String_1A_452D` | `String_MobileDict_Cat03Entry06` |
| 1A:4536 | `String_1A_4536` | `String_MobileDict_Cat03Entry07` |
| 1A:453F | `Data_1A_453F` | `Data_MobileDict_Cat04Count` |
| 1A:4546 | `String_1A_4546` | `String_MobileDict_Cat04Entry00` |
| 1A:454F | `String_1A_454F` | `String_MobileDict_Cat04Entry01` |
| 1A:455C | `String_1A_455C` | `String_MobileDict_Cat04Entry02` |
| 1A:456B | `Data_1A_456B` | `Data_MobileDict_Cat05Count` |
| 1A:4574 | `String_1A_4574` | `String_MobileDict_Cat05Entry00` |
| 1A:4581 | `String_1A_4581` | `String_MobileDict_Cat05Entry01` |
| 1A:458C | `String_1A_458C` | `String_MobileDict_Cat05Entry02` |
| 1A:4597 | `String_1A_4597` | `String_MobileDict_Cat05Entry03` |
| 1A:45A8 | `Data_1A_45A8` | `Data_MobileDict_Cat06Count` |
| 1A:45B7 | `String_1A_45B7` | `String_MobileDict_Cat06Entry00` |
| 1A:45C2 | `String_1A_45C2` | `String_MobileDict_Cat06Entry01` |
| 1A:45D1 | `String_1A_45D1` | `String_MobileDict_Cat06Entry02` |
| 1A:45DA | `String_1A_45DA` | `String_MobileDict_Cat06Entry03` |
| 1A:45E5 | `String_1A_45E5` | `String_MobileDict_Cat06Entry04` |
| 1A:45F2 | `String_1A_45F2` | `String_MobileDict_Cat06Entry05` |
| 1A:45FB | `String_1A_45FB` | `String_MobileDict_Cat06Entry06` |
| 1A:4608 | `Data_1A_4608` | `Data_MobileDict_Cat07Count` |
| 1A:4625 | `String_1A_4625` | `String_MobileDict_Cat07Entry00` |
| 1A:462E | `String_1A_462E` | `String_MobileDict_Cat07Entry01` |
| 1A:4637 | `String_1A_4637` | `String_MobileDict_Cat07Entry02` |
| 1A:463E | `String_1A_463E` | `String_MobileDict_Cat07Entry03` |
| 1A:464D | `String_1A_464D` | `String_MobileDict_Cat07Entry04` |
| 1A:465A | `String_1A_465A` | `String_MobileDict_Cat07Entry05` |
| 1A:4667 | `String_1A_4667` | `String_MobileDict_Cat07Entry06` |
| 1A:4674 | `String_1A_4674` | `String_MobileDict_Cat07Entry07` |
| 1A:467D | `String_1A_467D` | `String_MobileDict_Cat07Entry08` |
| 1A:4692 | `String_1A_4692` | `String_MobileDict_Cat07Entry09` |
| 1A:46AB | `String_1A_46AB` | `String_MobileDict_Cat07Entry10` |
| 1A:46C0 | `String_1A_46C0` | `String_MobileDict_Cat07Entry11` |
| 1A:46D1 | `String_1A_46D1` | `String_MobileDict_Cat07Entry12` |
| 1A:46E4 | `String_1A_46E4` | `String_MobileDict_Cat07Entry13` |
| 1A:46F9 | `Data_1A_46F9` | `Data_MobileDict_Cat08Count` |
| 1A:46FC | `String_1A_46FC` | `String_MobileDict_Cat08Entry00` |
| 1A:4705 | `Data_1A_4705` | `Data_MobileDict_Cat09Count` |
| 1A:470A | `String_1A_470A` | `String_MobileDict_Cat09Entry00` |
| 1A:4711 | `String_1A_4711` | `String_MobileDict_Cat09Entry01` |
| 1A:471E | `Data_1A_471E` | `Data_MobileDict_Cat10Count` |
| 1A:4721 | `String_1A_4721` | `String_MobileDict_Cat10Entry00` |
| 1A:4736 | `Data_1A_4736` | `Data_MobileDict_Cat11Count` |
| 1A:474B | `String_1A_474B` | `String_MobileDict_Cat11Entry00` |
| 1A:475A | `String_1A_475A` | `String_MobileDict_Cat11Entry01` |
| 1A:4763 | `String_1A_4763` | `String_MobileDict_Cat11Entry02` |
| 1A:477E | `String_1A_477E` | `String_MobileDict_Cat11Entry03` |
| 1A:4785 | `String_1A_4785` | `String_MobileDict_Cat11Entry04` |
| 1A:478C | `String_1A_478C` | `String_MobileDict_Cat11Entry05` |
| 1A:4793 | `String_1A_4793` | `String_MobileDict_Cat11Entry06` |
| 1A:479A | `String_1A_479A` | `String_MobileDict_Cat11Entry07` |
| 1A:47A1 | `String_1A_47A1` | `String_MobileDict_Cat11Entry08` |
| 1A:47A4 | `String_1A_47A4` | `String_MobileDict_Cat11Entry09` |

Census input: `.tmp/generic-coalias-census-post-fd0bdbd1/RESULT.json`; source-set SHA-256 `087b01cc94f76aad2e802f7691f1d69c0f0b06e56fa9963f8fcf1178ec77560c`. This census is a bounded lexical/static review, not proof of natural execution or broader dictionary behavior.

Validation for the mobile-dictionary checkpoint: `make` returns
`RESULT: IDENTICAL` with ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` reports 13,245 labels and 51 constants. A before/after map
comparison found exactly the 72 retired labels missing, with no added or moved
labels; the source remains 964 lines. `make palette-check` passes (162/116/2/0),
`make png-check` passes (408/4/37/95), and `tools/data_consumers.py --stats`
reports 519 groups, 120 rejected candidates and zero rows. The protected sample
file was excluded from the current source-label census, which finds 846 generic
`Data_BB_AAAA::` definitions in the six roots plus one in `zero_labels.asm`.
## Bank 5F keyboard-panel same-address aliases (2026-10-21)

The 30 generic exports in `gfx/keyboard/panels_bank5f.asm` co-addressed one existing named resource each: keyboard tile data, tilemaps, the shared palette, the object table, or animation-frame tables. The base census found no outside-source or tool references and no local labels; a current exact-token scan confirmed every old spelling appeared only at its declaration before the pass and appears nowhere in the permitted ASM/INC or tool files after it. The retained symbols still resolve to the same bank/address. Their declarations became blank physical lines; all 485 source lines, assets, table contents, addresses and existing confidence remain unchanged. No additional behavior is inferred.

| Address | Retired label | Retained label |
|---|---|---|
| 5F:4000 | `Data_5F_4000` | `Gfx_Kbd_T9_Tiles8800Vb1` |
| 5F:4400 | `Data_5F_4400` | `Gfx_Kbd_T9_Tiles8C00Vb1` |
| 5F:4800 | `Data_5F_4800` | `Gfx_Kbd_T9_Tiles9000Vb1` |
| 5F:4810 | `Data_5F_4810` | `Tilemap_Kbd_T9` |
| 5F:4CD0 | `Palette_5F_4CD0` | `Palette_SharedPanels_BgObj` |
| 5F:4CF8 | `Table_5F_4CF8` | `Kbd_ObjTable` |
| 5F:4D48 | `Table_5F_4D48` | `Kbd_Anim1Frames` |
| 5F:4D83 | `Table_5F_4D83` | `Kbd_Anim15Frames` |
| 5F:4D9A | `Table_5F_4D9A` | `Kbd_Anim2Frames` |
| 5F:4DC5 | `Table_5F_4DC5` | `Kbd_Anim7Frames` |
| 5F:4DE3 | `Table_5F_4DE3` | `Kbd_Anim4Frames` |
| 5F:4E01 | `Table_5F_4E01` | `Kbd_Anim5Frames` |
| 5F:4E23 | `Table_5F_4E23` | `Kbd_Anim6Frames` |
| 5F:4E45 | `Table_5F_4E45` | `Kbd_Anim9Frames` |
| 5F:4E57 | `Table_5F_4E57` | `Kbd_Anim10Frames` |
| 5F:4E69 | `Table_5F_4E69` | `Kbd_Anim11Frames` |
| 5F:4E7B | `Table_5F_4E7B` | `Kbd_Anim12Frames` |
| 5F:4E8D | `Table_5F_4E8D` | `Kbd_Anim13Frames` |
| 5F:4E9F | `Table_5F_4E9F` | `Kbd_Anim17Frames` |
| 5F:4EB5 | `Table_5F_4EB5` | `Kbd_Anim19Frames` |
| 5F:4ECB | `Data_5F_4ECB` | `Tilemap_Kbd_T0` |
| 5F:50D3 | `Data_5F_50D3` | `Tilemap_Kbd_T1` |
| 5F:52DB | `Data_5F_52DB` | `Tilemap_Kbd_T4` |
| 5F:54E3 | `Data_5F_54E3` | `Tilemap_Kbd_T2` |
| 5F:56EB | `Data_5F_56EB` | `Tilemap_Kbd_T3` |
| 5F:5900 | `Data_5F_5900` | `Gfx_Kbd_T5_Tiles8800Vb1` |
| 5F:5D00 | `Data_5F_5D00` | `Gfx_Kbd_T5_Tiles8C00Vb1` |
| 5F:6100 | `Data_5F_6100` | `Gfx_Kbd_T5_Tiles9000Vb1` |
| 5F:69B0 | `Data_5F_69B0` | `Tilemap_Kbd_T5` |
| 5F:6BB8 | `Data_5F_6BB8` | `Palette_Kbd_T5_Bg1` |

The original build remains `RESULT: IDENTICAL` (ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`); symbol, palette, PNG and data-consumer checks pass. The current safe generic-data count explicitly excludes `engine/mail/sample_data.asm`: 832 definitions in the six roots plus one in `zero_labels.asm` (833 total).

## Bank 04 song 06 and song 08 same-address aliases (2026-10-21)

The two maintained song owners lost 27 redundant `Data_04_AAAA` exports over existing `SoundSong06_*` and `SoundSong08_*` stream, loop, after-jump, substream and header labels. The current symbol map confirms each pair shares the exact address. A complete-token scan of each owner found only the declaration; the bounded census found no references in other tracked, non-language ASM/INC files or tools and no local labels whose qualification depended on an alias. Each declaration became a blank line; 792 bytes in song 06 and 972 bytes in song 08, comments, data, and confidence remain unchanged. The names describe existing stream boundaries; no audio playback claim is added.

| Address | Retired label | Retained label |
|---|---|---|
| `04:683C` | `Data_04_683C` | `SoundSong06_Track0` |
| `04:6840` | `Data_04_6840` | `SoundSong06_Track0_Loop` |
| `04:6897` | `Data_04_6897` | `SoundSong06_Track0_AfterJump` |
| `04:6898` | `Data_04_6898` | `SoundSong06_Track1` |
| `04:689C` | `Data_04_689C` | `SoundSong06_Track1_Loop` |
| `04:6931` | `Data_04_6931` | `SoundSong06_Track1_AfterJump` |
| `04:6932` | `Data_04_6932` | `SoundSong06_Track2` |
| `04:6936` | `Data_04_6936` | `SoundSong06_Track2_Loop` |
| `04:69F3` | `Data_04_69F3` | `SoundSong06_Track2_AfterJump` |
| `04:69F4` | `Data_04_69F4` | `SoundSong06_Track3` |
| `04:69F8` | `Data_04_69F8` | `SoundSong06_Track3_Loop` |
| `04:6B39` | `Data_04_6B39` | `SoundSong06_Track3_AfterJump` |
| `04:6B3A` | `Data_04_6B3A` | `SoundSong06_Header` |
| `04:7093` | `Data_04_7093` | `SoundSong08_Track0` |
| `04:7097` | `Data_04_7097` | `SoundSong08_Track0_Loop` |
| `04:7171` | `Data_04_7171` | `SoundSong08_Track0_AfterJump` |
| `04:7172` | `Data_04_7172` | `SoundSong08_Track1` |
| `04:7176` | `Data_04_7176` | `SoundSong08_Track1_Loop` |
| `04:72D6` | `Data_04_72D6` | `SoundSong08_Track1_AfterJump` |
| `04:72D7` | `Data_04_72D7` | `SoundSong08_Track2` |
| `04:72DB` | `Data_04_72DB` | `SoundSong08_Track2_Loop` |
| `04:739C` | `Data_04_739C` | `SoundSong08_Track2_AfterJump` |
| `04:739D` | `Data_04_739D` | `SoundSong08_Track3` |
| `04:73A1` | `Data_04_73A1` | `SoundSong08_Track3_Loop` |
| `04:73CA` | `Data_04_73CA` | `SoundSong08_Track3_Sub1` |
| `04:7444` | `Data_04_7444` | `SoundSong08_Track3_AfterJump` |
| `04:7445` | `Data_04_7445` | `SoundSong08_Header` |

## Bank 04 song 09 same-address aliases (2026-10-21)

`audio/music/music_09.asm` lost 15 redundant `Data_04_AAAA` exports over
existing `SoundSong09_*` stream, loop, after-jump, substream and header labels.
The current symbol map confirms each address pair. Full-token scans found each
old spelling only at its declaration, with no references in other tracked,
non-language ASM/INC files or tools, and no local labels depending on the
removed globals. The declarations became blank lines; the 906-byte owner,
comments, data and confidence remain unchanged. This does not claim any new
audio playback behavior.

| Address | Retired label | Retained label |
|---|---|---|
| `04:745F` | `Data_04_745F` | `SoundSong09_Track0` |
| `04:7463` | `Data_04_7463` | `SoundSong09_Track0_Loop` |
| `04:74B6` | `Data_04_74B6` | `SoundSong09_Track0_AfterJump` |
| `04:74B7` | `Data_04_74B7` | `SoundSong09_Track1` |
| `04:74BB` | `Data_04_74BB` | `SoundSong09_Track1_Loop` |
| `04:7568` | `Data_04_7568` | `SoundSong09_Track1_AfterJump` |
| `04:7569` | `Data_04_7569` | `SoundSong09_Track2` |
| `04:756D` | `Data_04_756D` | `SoundSong09_Track2_Loop` |
| `04:76B5` | `Data_04_76B5` | `SoundSong09_Track2_AfterJump` |
| `04:76B6` | `Data_04_76B6` | `SoundSong09_Track3` |
| `04:76BA` | `Data_04_76BA` | `SoundSong09_Track3_Loop` |
| `04:76F0` | `Data_04_76F0` | `SoundSong09_Track3_Sub1` |
| `04:7723` | `Data_04_7723` | `SoundSong09_Track3_Sub2` |
| `04:77CE` | `Data_04_77CE` | `SoundSong09_Track3_AfterJump` |
| `04:77CF` | `Data_04_77CF` | `SoundSong09_Header` |

## Bank 04 song 0B same-address aliases (2026-10-21)

The `audio/music/music_0b.asm` owner lost 14 redundant `Data_04_AAAA` exports
over existing `SoundSong0B_*` stream, loop, after-jump, substream and header
labels. The census was made from 347 tracked non-language ASM/INC files,
explicitly excluding `engine/mail/sample_data.asm`; all 14 candidates had no
references in other source files or tools and no local-label scope dependency.
The current symbol map confirmed each same-address pair, and full-token scans
found every old name only at its declaration. The 591-byte owner and 384
physical lines remain unchanged; each declaration became a blank line. This
does not claim any new audio playback behavior.

| Address | Retired label | Retained label |
|---|---|---|
| `04:79A4` | `Data_04_79A4` | `SoundSong0B_Track0` |
| `04:79A8` | `Data_04_79A8` | `SoundSong0B_Track0_Loop` |
| `04:79F3` | `Data_04_79F3` | `SoundSong0B_Track0_AfterJump` |
| `04:79F4` | `Data_04_79F4` | `SoundSong0B_Track1` |
| `04:79F8` | `Data_04_79F8` | `SoundSong0B_Track1_Loop` |
| `04:7ABC` | `Data_04_7ABC` | `SoundSong0B_Track1_AfterJump` |
| `04:7ABD` | `Data_04_7ABD` | `SoundSong0B_Track2` |
| `04:7AC1` | `Data_04_7AC1` | `SoundSong0B_Track2_Loop` |
| `04:7B5B` | `Data_04_7B5B` | `SoundSong0B_Track2_AfterJump` |
| `04:7B5C` | `Data_04_7B5C` | `SoundSong0B_Track3` |
| `04:7B60` | `Data_04_7B60` | `SoundSong0B_Track3_Loop` |
| `04:7B98` | `Data_04_7B98` | `SoundSong0B_Track3_Sub1` |
| `04:7BD8` | `Data_04_7BD8` | `SoundSong0B_Track3_AfterJump` |
| `04:7BD9` | `Data_04_7BD9` | `SoundSong0B_Header` |

## Bank 04 song 0C same-address aliases (2026-10-21)

The `audio/music/music_0c.asm` owner lost 13 redundant `Data_04_AAAA` exports
over existing `SoundSong0C_*` stream, loop, after-jump and header labels. The
pre-pass census spans 347 tracked non-language ASM/INC files and explicitly
excludes `engine/mail/sample_data.asm`; it found no references in other source
files or tools and no local-label scope dependencies. The pre-pass symbol map
confirms each same-address pair, and the pre-pass token scan found each old
spelling only at its declaration. After the pass, the 13 aliases are absent
from the current SYM. The 457-byte owner and its 303 physical lines remain
unchanged; each declaration became a blank line. No audio playback behavior is
inferred.

| Address | Retired label | Retained label |
|---|---|---|
| `04:7BF3` | `Data_04_7BF3` | `SoundSong0C_Track0` |
| `04:7BF7` | `Data_04_7BF7` | `SoundSong0C_Track0_Loop` |
| `04:7C42` | `Data_04_7C42` | `SoundSong0C_Track0_AfterJump` |
| `04:7C43` | `Data_04_7C43` | `SoundSong0C_Track1` |
| `04:7C47` | `Data_04_7C47` | `SoundSong0C_Track1_Loop` |
| `04:7CBC` | `Data_04_7CBC` | `SoundSong0C_Track1_AfterJump` |
| `04:7CBD` | `Data_04_7CBD` | `SoundSong0C_Track2` |
| `04:7CC1` | `Data_04_7CC1` | `SoundSong0C_Track2_Loop` |
| `04:7CF7` | `Data_04_7CF7` | `SoundSong0C_Track2_AfterJump` |
| `04:7CF8` | `Data_04_7CF8` | `SoundSong0C_Track3` |
| `04:7CFC` | `Data_04_7CFC` | `SoundSong0C_Track3_Loop` |
| `04:7DA1` | `Data_04_7DA1` | `SoundSong0C_Track3_AfterJump` |
| `04:7DA2` | `Data_04_7DA2` | `SoundSong0C_Header` |

## Bank 04 song 0D same-address aliases (2026-10-21)

The pre-pass census and symbol map identified five declaration-only
`Data_04_AAAA` aliases in `audio/music/music_0d.asm`, each at the same address
as an existing `SoundSong0D_*` stream or header label. The 347-file tracked
non-language ASM/INC scan excluded `engine/mail/sample_data.asm` and found no
cross-file or tool references; no local-label scope depended on the globals.
The five aliases are absent from the post-pass SYM. The 208-byte owner and its
163 physical lines are unchanged. This adds no audio playback claim.

| Address | Retired label | Retained label |
|---|---|---|
| `04:7DBC` | `Data_04_7DBC` | `SoundSong0D_Track0` |
| `04:7DE7` | `Data_04_7DE7` | `SoundSong0D_Track1` |
| `04:7E10` | `Data_04_7E10` | `SoundSong0D_Track2` |
| `04:7E52` | `Data_04_7E52` | `SoundSong0D_Track3` |
| `04:7E82` | `Data_04_7E82` | `SoundSong0D_Header` |

## Bank 05 song 0F same-address aliases (2026-10-21)

The pre-pass census and symbol map identified 14 declaration-only
`Data_05_AAAA` aliases in `audio/music/music_0f.asm`, each sharing an address
with an existing `SoundSong0F_*` stream, loop, after-jump, substream or header
label. The 347-file tracked non-language ASM/INC scan explicitly excluded
`engine/mail/sample_data.asm`; it found no references in other source files or
tools and no local-label scope dependencies. The aliases are absent from the
post-pass SYM. The owner remains 808 bytes and 536 physical lines. No audio
playback behavior is inferred.

| Address | Retired label | Retained label |
|---|---|---|
| `05:4232` | `Data_05_4232` | `SoundSong0F_Track0` |
| `05:4236` | `Data_05_4236` | `SoundSong0F_Track0_Loop` |
| `05:42E7` | `Data_05_42E7` | `SoundSong0F_Track0_AfterJump` |
| `05:42E8` | `Data_05_42E8` | `SoundSong0F_Track1` |
| `05:42EC` | `Data_05_42EC` | `SoundSong0F_Track1_Loop` |
| `05:43AE` | `Data_05_43AE` | `SoundSong0F_Track1_AfterJump` |
| `05:43AF` | `Data_05_43AF` | `SoundSong0F_Track2` |
| `05:43B3` | `Data_05_43B3` | `SoundSong0F_Track2_Loop` |
| `05:44BF` | `Data_05_44BF` | `SoundSong0F_Track2_AfterJump` |
| `05:44C0` | `Data_05_44C0` | `SoundSong0F_Track3` |
| `05:44C4` | `Data_05_44C4` | `SoundSong0F_Track3_Loop` |
| `05:44F3` | `Data_05_44F3` | `SoundSong0F_Track3_Sub1` |
| `05:4535` | `Data_05_4535` | `SoundSong0F_Track3_AfterJump` |
| `05:4540` | `Data_05_4540` | `SoundSong0F_Header` |

## Bank 72 dialog message same-address aliases (2026-10-21)

The refreshed census at `a5727635` found 28 declaration-only generic labels
in `data/text/dialog_messages.asm` sharing addresses with the existing
`Dialog_ListTable` or `String_Dialog_Msg*` labels. In addition to the nine
`String_72_AAAA` exports recorded above, this pass retires 26 address-named
`String_72_AAAA` aliases, one `Table_72_AAAA` alias and one `Data_72_AAAA`
alias. The scan covered 347 tracked non-language ASM/INC files and explicitly
excluded `engine/mail/sample_data.asm`; it found no other-source or tool
references and no dependent local labels. The declarations are absent from
the post-pass SYM. The file retains its 623 physical lines; message bytes,
table entries and confidence comments are unchanged. This removes duplicate
exports only and makes no new claim about message meaning.

| Address | Retired label | Retained label |
|---|---|---|
| `72:502B` | `Table_72_502B` | `Dialog_ListTable` |
| `72:50BD` | `String_72_50BD` | `String_Dialog_Msg0000` |
| `72:518C` | `String_72_518C` | `String_Dialog_Msg0102` |
| `72:51D1` | `String_72_51D1` | `String_Dialog_Msg0103` |
| `72:52A0` | `String_72_52A0` | `String_Dialog_Msg0106` |
| `72:532A` | `String_72_532A` | `String_Dialog_Msg0108` |
| `72:53F9` | `String_72_53F9` | `String_Dialog_Msg010B` |
| `72:54C8` | `String_72_54C8` | `String_Dialog_Msg010E` |
| `72:550D` | `String_72_550D` | `String_Dialog_Msg010F` |
| `72:55DC` | `String_72_55DC` | `String_Dialog_Msg0112` |
| `72:56AB` | `String_72_56AB` | `String_Dialog_Msg0115` |
| `72:56F0` | `String_72_56F0` | `String_Dialog_Msg0116` |
| `72:577A` | `String_72_577A` | `String_Dialog_Msg0201` |
| `72:57BF` | `Data_72_57BF` | `String_Dialog_Msg0202` |
| `72:58D3` | `String_72_58D3` | `String_Dialog_Msg0206` |
| `72:59A2` | `String_72_59A2` | `String_Dialog_Msg0209` |
| `72:59E7` | `String_72_59E7` | `String_Dialog_Msg020A` |
| `72:5A71` | `String_72_5A71` | `String_Dialog_Msg020C` |
| `72:5AFB` | `String_72_5AFB` | `String_Dialog_Msg020E` |
| `72:5B85` | `String_72_5B85` | `String_Dialog_Msg0210` |
| `72:5C0F` | `String_72_5C0F` | `String_Dialog_Msg0212` |
| `72:5C99` | `String_72_5C99` | `String_Dialog_Msg0214` |
| `72:5CDE` | `String_72_5CDE` | `String_Dialog_Msg0215` |
| `72:5DAD` | `String_72_5DAD` | `String_Dialog_Msg0218` |
| `72:5DF2` | `String_72_5DF2` | `String_Dialog_Msg0219` |
| `72:5F90` | `String_72_5F90` | `String_Dialog_Msg021F` |
| `72:5FF6` | `String_72_5FF6` | `String_Dialog_Msg0220` |
| `72:612B` | `String_72_612B` | `String_Dialog_Msg0224` |

## Bank 23 mail-server delete-progress aliases (2026-10-21)

The refreshed census at `ca677625` found 24 declaration-only address-named
aliases in `gfx/mail_server/delete_progress.asm`, sharing addresses with
existing named palette, sprite-object or animation-frame-table labels. The
347-file tracked non-language ASM/INC scan excluded
`engine/mail/sample_data.asm`; it found no other-source or tool references and
no dependent local labels. The aliases are absent from the post-pass SYM. The
owner remains 598 physical lines; palette bytes, object records, frame
tables, comments and confidence are unchanged. No new runtime claim is made.

| Address | Retired label | Retained label |
|---|---|---|
| `23:7910` | `Palette_23_7910` | `Palette_MailSrvDelProgress_Bg` |
| `23:7950` | `Palette_23_7950` | `Palette_MailSrvDelProgress_Obj` |
| `23:7990` | `Table_23_7990` | `Table_SpriteCounter_Digits` |
| `23:7AE0` | `Table_23_7AE0` | `SpriteCounter_Digits_Anim0Frames` |
| `23:7AEA` | `Table_23_7AEA` | `SpriteCounter_Digits_Anim4Frames` |
| `23:7AF4` | `Table_23_7AF4` | `SpriteCounter_Digits_Anim8Frames` |
| `23:7AFE` | `Table_23_7AFE` | `SpriteCounter_Digits_Anim12Frames` |
| `23:7B08` | `Table_23_7B08` | `SpriteCounter_Digits_Anim16Frames` |
| `23:7B12` | `Table_23_7B12` | `SpriteCounter_Digits_Anim20Frames` |
| `23:7B1C` | `Table_23_7B1C` | `SpriteCounter_Digits_Anim24Frames` |
| `23:7B26` | `Table_23_7B26` | `SpriteCounter_Digits_Anim28Frames` |
| `23:7B30` | `Table_23_7B30` | `SpriteCounter_Digits_Anim32Frames` |
| `23:7B3A` | `Table_23_7B3A` | `SpriteCounter_Digits_Anim36Frames` |
| `23:7B44` | `Table_23_7B44` | `SpriteCounter_Digits_Anim40Frames` |
| `23:7B4E` | `Table_23_7B4E` | `SpriteCounter_Digits_Anim44Frames` |
| `23:7B58` | `Table_23_7B58` | `SpriteCounter_Digits_Anim48Frames` |
| `23:7B62` | `Table_23_7B62` | `SpriteCounter_Digits_Anim52Frames` |
| `23:7B6C` | `Table_23_7B6C` | `SpriteCounter_Digits_Anim56Frames` |
| `23:7B76` | `Table_23_7B76` | `SpriteCounter_Digits_Anim60Frames` |
| `23:7B80` | `Table_23_7B80` | `SpriteCounter_Digits_Anim64Frames` |
| `23:7B8A` | `Table_23_7B8A` | `SpriteCounter_Digits_Anim68Frames` |
| `23:7B94` | `Table_23_7B94` | `SpriteCounter_Digits_Anim72Frames` |
| `23:7B9E` | `Table_23_7B9E` | `SpriteCounter_Digits_Anim76Frames` |
| `23:7BA8` | `Table_23_7BA8` | `MailSrvDel_ProgressObject_Anim0Frames` |

## Bank 70 communication-scene address aliases (2026-10-21)

The refreshed census at `e3138584` identified 23 declaration-only generic
labels in `gfx/comm/comm_scene.asm` co-located with existing descriptive
labels for a pointer table, object/frame tables, tiles, palettes and tilemaps.
The earlier four `Data_70_*` aliases in this file were handled in a separate
checkpoint. The 347-file tracked non-language ASM/INC scan excluded
`engine/mail/sample_data.asm`; it found no other-source or tool references and
no dependent local labels. The owner comments also named some aliases; those
comment-only mentions now use the retained same-address labels. No code
references were changed. The declarations are absent from the post-pass SYM.
The file's physical line count and all ROM data, address comments and
confidence levels are unchanged.

| Address | Retired label | Retained label |
|---|---|---|
| `70:4822` | `Table_70_4822` | `CommScene_TextBoxMaps` |
| `70:534C` | `Table_70_534C` | `CommScene_ObjTable` |
| `70:535C` | `Table_70_535C` | `CommScene_Anim1Frames` |
| `70:539A` | `Table_70_539A` | `CommScene_Anim2Frames` |
| `70:53D8` | `Table_70_53D8` | `CommScene_Anim3Frames` |
| `70:53EB` | `Table_70_53EB` | `CommScene_SpriteObjTable` |
| `70:5403` | `Table_70_5403` | `CommScene_Sprite_Anim1Frames` |
| `70:542E` | `Table_70_542E` | `CommScene_Sprite_Anim2Frames` |
| `70:5459` | `Table_70_5459` | `CommScene_Sprite_Anim3Frames` |
| `70:5467` | `Table_70_5467` | `CommScene_Sprite_Anim4Frames` |
| `70:5475` | `Table_70_5475` | `CommScene_Sprite_Anim5Frames` |
| `70:6A90` | `Tiles_70_6A90` | `Gfx_CommScene_Tiles9400Vb1` |
| `70:6C90` | `Palette_70_6C90` | `Palette_CommScene_Bg` |
| `70:6CD0` | `Palette_70_6CD0` | `Palette_CommScene_Obj` |
| `70:6D10` | `Tilemap_70_6D10` | `Tilemap_CommScene` |
| `70:7090` | `Tilemap_70_7090` | `Tilemap_CommScene_TextBox0` |
| `70:7130` | `Tilemap_70_7130` | `Tilemap_CommScene_TextBox1` |
| `70:71D0` | `Tilemap_70_71D0` | `Tilemap_CommScene_TextBox2` |
| `70:7270` | `Tilemap_70_7270` | `Tilemap_CommScene_TextBox3` |
| `70:7310` | `Tilemap_70_7310` | `Tilemap_CommScene_TextBox4` |
| `70:73B0` | `Tilemap_70_73B0` | `Tilemap_CommScene_TextBox5` |
| `70:7450` | `Tilemap_70_7450` | `Tilemap_CommScene_TextBox6` |
| `70:74F0` | `Tilemap_70_74F0` | `Tilemap_CommScene_TextBox7` |

## Bank 71 account-screen address aliases (2026-10-21)

The refreshed census at `2e47c34d` found 22 declaration-only address-named
labels in `gfx/account/screens_bank71.asm`, each co-located with an existing
named graphics, palette, tilemap, object-table, frame or animation-script
label. The 347-file tracked non-language ASM/INC scan excluded
`engine/mail/sample_data.asm`; it found no other-source references or local
dependencies. It found one tool file, `tools/retype_blobs.py`. After the update,
that file retains two textual occurrences of `Palette_71_66C0` to recognize
and replace the one-shot historical input spelling, while no longer emitting
the alias.
The owner comments and code references are unchanged; no ROM data changed.
The owner remains 263 physical lines and its aliases are absent from the
post-pass SYM.

| Address | Retired label | Retained label |
|---|---|---|
| `71:4000` | `Data_71_4000` | `Gfx_CommPanel_Tiles8000` |
| `71:4300` | `Data_71_4300` | `Gfx_CommPanel_SharedVramSource` |
| `71:4890` | `Data_71_4890` | `Gfx_CommPanel_Tiles9400Vb1` |
| `71:4C90` | `Data_71_4C90` | `Palette_CommPanel_Obj` |
| `71:4C98` | `Data_71_4C98` | `Tilemap_CommPanel_71_4C98` |
| `71:4F68` | `Data_71_4F68` | `Tilemap_CommPanel_71_4F68` |
| `71:4FB8` | `Table_71_4FB8` | `CommPanel_ObjTable` |
| `71:4FC0` | `Table_71_4FC0` | `CommPanel_Anim1Frames` |
| `71:4FC6` | `Data_71_4FC6` | `CommPanel_Anim1Frame0` |
| `71:4FE7` | `Data_71_4FE7` | `CommPanel_Anim1Frame1` |
| `71:500C` | `Data_71_500C` | `CommPanel_Anim1Frame2` |
| `71:5031` | `Data_71_5031` | `CommPanel_Anim1Script` |
| `71:5340` | `Data_71_5340` | `Gfx_Registration_DeleteConfirm_Tiles9000Vb1` |
| `71:5740` | `Data_71_5740` | `Gfx_Registration_DeleteConfirm_Tiles9400Vb1` |
| `71:5DC0` | `Data_71_5DC0` | `Gfx_Registration_Delete_Tiles9400Vb1` |
| `71:6580` | `Data_71_6580` | `Gfx_Registration_DeleteExecute_Tiles9000Vb1` |
| `71:66C0` | `Palette_71_66C0` | `Palette_Registration_Delete_Obj` |
| `71:66C8` | `Data_71_66C8` | `Tilemap_Registration_DeleteConfirm_71_66C8` |
| `71:6998` | `Data_71_6998` | `Tilemap_Registration_DeleteConfirm_71_6998` |
| `71:6C68` | `Data_71_6C68` | `Tilemap_Registration_DeleteExecute` |
| `71:6F38` | `Table_71_6F38` | `Registration_DeleteExecute_ObjTable` |
| `71:6F40` | `Table_71_6F40` | `Registration_DeleteExecute_Anim1Frames` |


## Bank 73 browser-start co-located aliases (2026-10-21)

The owner-local review of `gfx/browser/start_choice.asm` found 16 generic
`Data_73_*` definitions. Thirteen were exact-address aliases of existing
descriptive labels, with no other active source, asset-tool or metadata
consumers after rerunning the reference scan with the protected
`engine/mail/sample_data.asm` excluded. The alias declarations were retired;
all 13 physical source lines remain blank, preserving owner line positions.
The three labels without a descriptive co-label remain neutral: `Data_73_4530`
covers mixed animation attributes plus a three-byte unread tail,
`Data_73_49E0` identifies a tile sheet whose role remains PROBABLE, and
`Data_73_5EC0` begins with a three-byte sprite-script tail before the next
frame table. No safer full-span label is established for those ranges.

| Address | Retired label | Retained label |
|---|---|---|
| `73:4097` | `Data_73_4097` | `BrowserStart_Map` |
| `73:438F` | `Data_73_438F` | `BrowserStart_BottomMapNormal` |
| `73:43AD` | `Data_73_43AD` | `BrowserStart_TopAttrNormal` |
| `73:43D5` | `Data_73_43D5` | `BrowserStart_BottomAttrNormal` |
| `73:4439` | `Data_73_4439` | `BrowserStart_TopAttrSelected` |
| `73:4461` | `Data_73_4461` | `BrowserStart_BottomAttrSelected` |
| `73:447F` | `Data_73_447F` | `BrowserStart_AnimFrames` |
| `73:45E0` | `Data_73_45E0` | `BrowserStart_Tiles0` |
| `73:4DE0` | `Data_73_4DE0` | `BrowserStart_Tiles1` |
| `73:51E0` | `Data_73_51E0` | `BrowserStart_Tiles2` |
| `73:55E0` | `Data_73_55E0` | `BrowserStart_Tiles3` |
| `73:59E0` | `Data_73_59E0` | `BrowserStart_Tiles4` |
| `73:5DE0` | `Data_73_5DE0` | `BrowserStart_Palettes` |

The owner changed from SHA-256 `ae217a6052abd28e0b17f80e20b106a700119d3d644abbed9b381be3f9a65319`
to `5194c2e6ca25ae69275235f8cfe16a56ddfdcc133989c60ee6f12922b5749093`; its
physical line count is unchanged. `make` reports `SHA-256 OK` and
`RESULT: IDENTICAL` for original ROM
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
`make sym-check` passes with 12,832 labels and 51 constants.
`make palette-check` passes with 162 loads, 116 arrays, two documented
over-reads and zero errors. No asset bytes or confidence labels changed.

## Bank 4B account result page aliases (2026-10-21)

Retired the unused same-address aliases `Data_4B_42D0`, `Data_4B_46D0`, and
`Data_4B_5898` from `gfx/account/screens_bank4b.asm`. The corresponding
descriptive labels already name the confirmed upload resources and tilemap;
`engine/account/result_page.asm` uses those descriptive labels directly.
The assembly-root reference scan found no other source consumers for the
retired aliases. Updated the four affected `gfx/assets.tsv` rows, including
the attribute map row that shares the tilemap's base label. No bytes, paths,
or resource classifications changed. Other labels in the owner, including
`Data_4B_5080`, `Data_4B_5400`, and `Data_4B_5420`, remain neutral because they
do not have an equally strong descriptive co-label.

## Bank 71 asset catalogue labels (2026-10-21)

Reconciled 16 stale `gfx/assets.tsv` label cells with the labels now defined
in `gfx/account/screens_bank71.asm`: the CommPanel and registration-delete
tilemaps, their matching attribute maps, and six confirmed tile resources.
These entries had retained old `Data_71_*` catalog strings after the source
labels became descriptive. The asset files, bank/address fields, and source
bytes are unchanged. The remaining source-only `Data_71_*` labels at `4500`,
`5038`, `5098`, `5B40`, `61C0`, and `6440` have no verified descriptive
co-label in this owner and remain neutral.

## Graphics catalogue stale labels (2026-10-21)

Reconciled 53 distinct `Data_<bank>_<address>` values in `gfx/assets.tsv` that
no longer exist as source symbols. For each value, its catalog owner has
exactly one current descriptive global label at the same bank/address. The
70 affected catalog rows span four owners: `gfx/comm/notice_dialog.asm`
(8 labels / 8 rows), `gfx/comm/connect_dialog_bank56.asm` (16 / 22),
`gfx/account/screens_bank5e.asm` (15 / 19), and
`gfx/keyboard/panels_bank5f.asm` (14 / 21). The extra rows are the matching
attribute maps that share each tilemap's base label. No assembly label,
resource path, source byte, confidence level, or ROM byte changed.

The reconciliation script required a unique descriptive symbol at the exact
bank/address in the owner source before changing the catalog field. Its
private report and full old-to-new mapping are retained in
`.tmp/gfx-catalog-label-audit-20261021/`: `MAPPINGS.json` SHA-256
`d1964383d6fa677d1404f86566b194b96bd22de441ec865eb0b86650fb3f4268` and
`RESULT.json` SHA-256 recorded in the OMM checkpoint. Catalog content hashes
were `4c948911f65712eee86bedd14c20b33a95aad14bdbd7d49e6287eb683b862adc`
before and `f6d4a8290d7b84644e6fad923968ffeaa814ef6f2dcbb186f006ebd10bec0199`
after the update. The remaining source `Data_<bank>_<address>` labels in these
owners do not have a verified co-address semantic label and were left intact.

## Bank 66 keyboard resource aliases (2026-10-21)

Retired 15 same-address `Data_66_*` exports from
`gfx/keyboard/tiles_bank66.asm`. Thirteen were co-located with existing
page/VRAM-specific `Gfx_Kbd_*` names; two were co-located with existing
confirmed tilemap names. The source/tool reference scan found no consumers
outside this owner and `gfx/assets.tsv`. Updated the 17 corresponding catalog
rows, including tilemap attribute maps that share their tilemap's base label.
Source bytes, graphics paths, bank/address ranges and confidence levels are
unchanged. The heuristic-only `Data_66_6A90` span and the unknown-content data
at `Data_66_7190` retain their neutral names.

## Bank 62 keyboard resource aliases (2026-10-21)

Retired 12 same-address `Data_62_*` exports from
`gfx/keyboard/tiles_bank62.asm`. Each shared its address with an existing
page/VRAM-specific `Gfx_Kbd_T78_*` label. The maintained-source and tool scan
found active references only in the owner and `gfx/assets.tsv`; the 12 asset
rows now use the retained source labels. No data bytes, paths, address ranges
or confidence levels changed. Four heuristic partial-tile spans at `4A40`,
`5540`, `6040` and `6B40` remain neutral.

## Bank 05 song 10 stream aliases (2026-10-21)

Retired 13 co-addressed `Data_05_*` aliases from
`audio/music/music_10.asm`. Each address already has an exact track, loop,
after-jump marker, or stream-header name. The maintained-source and tool
search found no consumers outside this owner. Stream commands, pointer words,
line positions, and confidence annotations are unchanged.

| Address | Retained label |
|---|---|
| `05:455A` | `SoundSong10_Track0` |
| `05:455E` | `SoundSong10_Track0_Loop` |
| `05:45A4` | `SoundSong10_Track0_AfterJump` |
| `05:45A5` | `SoundSong10_Track1` |
| `05:45A9` | `SoundSong10_Track1_Loop` |
| `05:461A` | `SoundSong10_Track1_AfterJump` |
| `05:461B` | `SoundSong10_Track2` |
| `05:461F` | `SoundSong10_Track2_Loop` |
| `05:466C` | `SoundSong10_Track2_AfterJump` |
| `05:466D` | `SoundSong10_Track3` |
| `05:4671` | `SoundSong10_Track3_Loop` |
| `05:46E5` | `SoundSong10_Track3_AfterJump` |
| `05:46E6` | `SoundSong10_Header` |

## Bank 05 song 1A stream aliases (2026-10-21)

Retired 14 co-addressed `Data_05_*` aliases from
`audio/music/music_1a.asm`. Existing `SoundSong1A_*` labels name the track
entries, loops, after-jump markers, one subroutine, and stream header. The
maintained-source/tool search found no consumers outside the owner. Stream
commands, pointers, bytes, and confidence annotations are unchanged.

| Address | Retained label |
|---|---|
| `05:5DCF` | `SoundSong1A_Track0` |
| `05:5DD3` | `SoundSong1A_Track0_Loop` |
| `05:5E36` | `SoundSong1A_Track0_AfterJump` |
| `05:5E37` | `SoundSong1A_Track1` |
| `05:5E3B` | `SoundSong1A_Track1_Loop` |
| `05:5F66` | `SoundSong1A_Track1_AfterJump` |
| `05:5F67` | `SoundSong1A_Track2` |
| `05:5F6B` | `SoundSong1A_Track2_Loop` |
| `05:6029` | `SoundSong1A_Track2_AfterJump` |
| `05:602A` | `SoundSong1A_Track3` |
| `05:602E` | `SoundSong1A_Track3_Loop` |
| `05:605D` | `SoundSong1A_Track3_Sub1` |
| `05:60CE` | `SoundSong1A_Track3_AfterJump` |
| `05:60CF` | `SoundSong1A_Header` |

## Bank 05 song 1C stream aliases (2026-10-21)

Retired 11 same-address `Data_05_*` aliases from
`audio/music/music_1c.asm`. Existing `SoundSong1C_*` names cover the three
track entries and loops, two after-jump markers, one subroutine, and stream
header. The maintained-source/tool search found no references outside this
owner. Stream bytes, pointers, and confidence annotations are unchanged.

| Address | Retained label |
|---|---|
| `05:60F9` | `SoundSong1C_Track0` |
| `05:60FD` | `SoundSong1C_Track0_Loop` |
| `05:6174` | `SoundSong1C_Track0_AfterJump` |
| `05:6175` | `SoundSong1C_Track1` |
| `05:6179` | `SoundSong1C_Track1_Loop` |
| `05:625E` | `SoundSong1C_Track1_AfterJump` |
| `05:625F` | `SoundSong1C_Track2` |
| `05:6263` | `SoundSong1C_Track2_Loop` |
| `05:628B` | `SoundSong1C_Track2_Sub1` |
| `05:62BB` | `SoundSong1C_Track2_AfterJump` |
| `05:62BC` | `SoundSong1C_Header` |

## Bank 05 song 1B stream aliases (2026-10-21)

Retired two same-address `Data_05_*` aliases from
`audio/music/music_1b.asm`: `05:60E9` remains `SoundSong1B_Track0`, and
`05:60F5` remains `SoundSong1B_Header`. The maintained-source/tool search
found no consumer outside the owner. Stream and pointer bytes, confidence,
and physical source positions are unchanged.

## Bank 5D account-screen aliases and object entry (2026-10-21)

The bank-5D account-screen owner lost twelve same-address `Data_5D_*` aliases
under the existing tile, tilemap and palette labels. The active asset catalog
now points to those retained labels in thirteen rows; no assembly operands or
tool logic used the aliases. The same-address `Table_5D_7318` alias was removed
under `Objects_Registration_WriteConfig`. The selected four-byte object entry
at `5D:731C` now has the structural name
`Objects_Registration_WriteConfig_Entry1`: `register_config.asm` passes the
table base with `B=$81` to `Sprite_InitSlot`, and the current source records
its 65-byte frame/script chain as naturally read in eight scenarios. This
does not identify the depicted subject. The two remaining neutral labels in
this owner, `Data_5D_5000` and `Data_5D_6C00`, retain their names because the
former has unknown content class and the latter is only a clipped interior of
a broader tile upload. Frozen `config/` and historical `analysis/` spellings
remain as provenance. Payload bytes, source-line positions and confidence
annotations are unchanged. A fresh lexical scan over the six maintained ASM
roots now counts 562 `Data_BB_AAAA::` definitions across 140 owners; the
protected mail sample and `zero_labels.asm` are outside this count. This count
tracks labels only and is not a semantic-completion measure.

## Bank 4A settings and confirmation resources (2026-10-21)

The bank-4A settings/confirmation owner lost nine same-address
`Data_4A_*` aliases under retained graphics, tilemap and palette names; ten
asset-catalog label cells now use those names. The same-address
`Table_4A_5838` alias was removed under `SettingsMenu_ObjTable`, and the
selected entry at `4A:583C` is now `SettingsMenu_ObjTable_Entry1`. Its frame
table and two OAM records are source-labeled; the entry's second pointer at
`4A:5866` is now `SpriteScript_SettingsMenu_ObjTable_Entry1`. The bytes at
that target are represented by the same editable 16-byte source file using
offset-limited `INCBIN`s; the file's existing one-tile 2bpp PNG is retained
as a HYPOTHESIS visual byte view because the span also contains six bytes of
unclassified prefix and five trailing zero bytes.

The five 40-byte menu-highlight records at `4A:5770`, `5798`, `57C0`, `57E8`
and `5810` now have entry-specific `Tilemap_SettingsMenu_ItemHighlightMap_*`
labels. The bank-68 cursor table uses these bank-4A symbols in place of raw
words; its emitted values are unchanged. The first four records retain their
CONFIRMED bounded reader evidence; entry 4 remains PROBABLE with no observed
natural read. `Data_4A_51B0` remains neutral because its suspected unread
palette role is unproved, and `Data_4A_5860` remains neutral for its
unclassified six-byte prefix. The earlier note reported 550 definitions in
140 owners. Re-running the whitespace-aware `Data_BB_AAAA::` definition query
at `d09ead4f` gives 526 in 137 owners, excluding the protected mail sample and
`zero_labels.asm`; the earlier 550 count was high by 24. At `1c6a6ccb` the
count remained 526. This remains a lexical count, not a semantic-completion
measure.

## Bank 70 communication-scene object animation records (2026-10-21)

`gfx/comm/comm_scene.asm` now names the probable object-animation structure at
`70:4832` as `CommScene_ObjAnimTable`. Its four non-null entries point to
frame-pointer lists and paired candidate scripts. The frame labels use entry
and list position only; they do not identify the depicted object or action.
The table has no confirmed executed caller, so its role remains **PROBABLE**.
Each frame block has the observed count-prefixed 4-byte record shape; the
meaning of the first two fields remains unknown.

The 26 former `Data_70_*` labels were replaced as follows. Within each row,
frame numbers follow pointer order, starting at zero:

| Entry | Frame records (`old address` -> `new frame index`) | Frame-pointer list | Candidate script |
|---|---|---|---|
| 1 | `4852->0, 4857->1, 4868->2, 4881->3, 48B2->4, 4903->5` | `Table_70_4846` -> `CommScene_ObjAnimEntry1_FramePointers` | `Data_70_4904` -> `CommScene_ObjAnimEntry1_Script` |
| 2 | `4919->0, 497E->1, 49E3->2, 4A50->3` | `Table_70_4911` -> `CommScene_ObjAnimEntry2_FramePointers` | `Data_70_4AB9` -> `CommScene_ObjAnimEntry2_Script` |
| 3 | `4ACE->0, 4B1F->1, 4B48->2, 4B61->3, 4B72->4, 4B7B->5` | `Table_70_4AC2` -> `CommScene_ObjAnimEntry3_FramePointers` | `Data_70_4B84` -> `CommScene_ObjAnimEntry3_Script` |
| 4 | `4B9D->0, 4BEE->1, 4C17->2, 4C30->3, 4C41->4, 4C4A->5` | `Table_70_4B91` -> `CommScene_ObjAnimEntry4_FramePointers` | `Data_70_4C4F` -> `CommScene_ObjAnimEntry4_Script` |

The former master `Table_70_4832` is now `CommScene_ObjAnimTable`. The source
labels and pointer operands changed; data directives and physical byte spans
did not. A bounded maintained-source/tool search found no consumers outside
this owner. Frozen `config/regions/bank70.tsv` and the historical
`docs/research/naming2_data2.md` retain old spellings as snapshots and were not
rewritten. No natural-use, sprite-subject, or global-unused claim follows from
this pass. The exact six-root query now counts 500 `Data_BB_AAAA::`
definitions in 137 owners after these 26 renames; `engine/mail/sample_data.asm`
and `zero_labels.asm` remain excluded. This is only a lexical count.
