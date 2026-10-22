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
consumer notes are unchanged. At this historical checkpoint,
`Table_HelpMenu_LockedItemTicker` named only the one-byte bank field at
`6A:6651`, and adjacent pointer arrays remained separate blocks. The later
bank-6A ticker pass below corrects this boundary/name after following the
consumer through `Ticker_Start`. The build remained byte-identical after the
alias-line removals at this checkpoint.

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
was not one of the 82. At that historical checkpoint, `Data_7C_57CD` remained the physical font-chunk
marker inside a glyph. That generic label is superseded by
`GlyphFont_Jis12x12_7C_Fragment57CD`, which preserves the known font family and
the fact that the split is not at a glyph or row boundary. The audit also found
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
unchanged at that checkpoint. A later bounded consumer review superseded the
two neutral labels; see [`typing_66_mail_draft_exit_options.md`](typing_66_mail_draft_exit_options.md)
for the exact three transfer windows, evidence grade, and retained natural-
reachability limit.

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
does not identify the depicted subject. At this historical checkpoint,
the two remaining neutral labels in this owner, `Data_5D_5000` and `Data_5D_6C00`, retained their names because the
former had unknown content class and the latter was only a clipped interior of
a broader tile upload. The latter decision is superseded by the follow-up
`Gfx_Registration_WriteConfig_Tiles8A00Vb1` review recorded in
`original_closure_followup_20261021.md`; `Data_5D_5000` remains neutral. Frozen
`config/` and historical `analysis/` spellings remain as provenance. Payload
bytes, source-line positions and confidence annotations are unchanged. A fresh
lexical scan over the six maintained ASM roots now counts 562 `Data_BB_AAAA::` definitions across 140 owners; the
protected mail sample and `zero_labels.asm` are outside this count. This count
tracks labels only and is not a semantic-completion measure.

## Bank 4A settings and confirmation resources (2026-10-21)

The bank-4A settings/confirmation owner lost nine same-address
`Data_4A_*` aliases under retained graphics, tilemap and palette names; ten
asset-catalog label cells now use those names. The same-address
`Table_4A_5838` alias was removed under `SettingsMenu_ObjTable`, and the
selected entry at `4A:583C` is now `SettingsMenu_ObjTable_Entry1`. Its frame
table and two OAM records are source-labeled; the entry's second pointer at
`4A:5866` is now `SpriteScript_SettingsMenu_ObjTable_Entry1`. A follow-up
retyped `4A:5855-586A` as two complete frames and the selected two-step
animation script, all in RGBDS macros; `4A:586B-586F` is emitted as five zero
bytes with PROBABLE padding purpose. The old 16-byte `.2bpp` and PNG are
unchanged byte-view evidence outside the active asset catalog and PNG rules.

The five 40-byte menu-highlight records at `4A:5770`, `5798`, `57C0`, `57E8`
and `5810` now have entry-specific `Tilemap_SettingsMenu_ItemHighlightMap_*`
labels. The bank-68 cursor table uses these bank-4A symbols in place of raw
words; its emitted values are unchanged. The first four records retain their
CONFIRMED bounded reader evidence; entry 4 remains PROBABLE with no observed
natural read. The 32-byte `Data_4A_51B0` candidate has since been renamed
`Palette_SettingsMenu_ObjRampCandidates`: the physical block is four identical
4-colour RGB555 ramps adjacent to the confirmed settings-menu OBJ palette, but
no reader was found, so slot assignment and use remain **HYPOTHESIS**. This is
a format/context name, not evidence of a loaded palette resource. The earlier
note reported 550 definitions in
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

## Bank 70 second communication-scene object-animation group (2026-10-21)

The probable table at `70:4C5C` is now `CommScene_ObjAnimTable2`. Its first
four bytes are null and its second four-byte slot points to a 14-item
frame-pointer list and a candidate script. The frame labels encode only the
list position (zero through thirteen); their depicted subject and record
field meanings remain unknown. No executed caller is confirmed, so the
animation-table interpretation remains **PROBABLE**.

| Old label/address | Current label |
|---|---|
| `Table_70_4C5C` / `4C5C` | `CommScene_ObjAnimTable2` |
| `Table_70_4C64` / `4C64` | `CommScene_ObjAnimTable2_Entry1_FramePointers` |
| `Data_70_4C80`, `4C99`, `4CB2`, `4CCB`, `4CDC`, `4CED`, `4CFE`, `4D17`, `4D28`, `4D39`, `4D52`, `4D63`, `4D7C`, `4D8D` | `CommScene_ObjAnimTable2_Entry1_Frame0` through `Frame13`, in pointer order |
| `Data_70_4D9E` / `4D9E` | `CommScene_ObjAnimTable2_Entry1_Script` |

No data directives or physical spans changed. The bounded consumer search
found no current maintained-source or tool consumer outside the owner; frozen
`config/regions/bank70.tsv` and historical analysis retain prior spellings.
The six-root whitespace-aware lexical count is 485
`Data_BB_AAAA::` definitions in 137 owners after these 15 data-label renames;
this is not a measure of semantic completion.

## Bank 70 third and fourth communication-scene object-animation groups (2026-10-21)

The probable table at `70:4DBB` is now `CommScene_ObjAnimTable3`. Its null
entry 0 is followed by four pointer-list/script pairs. The table at `70:5272`
is now `CommScene_ObjAnimTable4`; it has a null entry 0 and one non-null
pair. Both retain **PROBABLE** status because no executed caller was found.
Frame labels below use pointer-list order from zero and do not identify a
sprite subject or resolve the first two OAM fields.

| Table entry | Frame-pointer list | Frame-record addresses in pointer order | Candidate script |
|---|---|---|---|
| `ObjAnimTable3` entry 1 | `4DCF` -> `CommScene_ObjAnimTable3_Entry1_FramePointers` | `4DD7, 4DE8, 4DFD, 4E1A` | `4E47` -> `CommScene_ObjAnimTable3_Entry1_Script` |
| `ObjAnimTable3` entry 2 | `4E50` -> `CommScene_ObjAnimTable3_Entry2_FramePointers` | `4E58, 4EB5, 4F16, 4F7B` | `4FE4` -> `CommScene_ObjAnimTable3_Entry2_Script` |
| `ObjAnimTable3` entry 3 | `4FED` -> `CommScene_ObjAnimTable3_Entry3_FramePointers` | `4FF7, 5050, 50A9, 50F6, 513B` | `517C` -> `CommScene_ObjAnimTable3_Entry3_Script` |
| `ObjAnimTable3` entry 4 | `5187` -> `CommScene_ObjAnimTable3_Entry4_FramePointers` | `5193, 51B4, 51CD, 51DE, 5203, 5240` | `5265` -> `CommScene_ObjAnimTable3_Entry4_Script` |
| `ObjAnimTable4` entry 1 | `527A` -> `CommScene_ObjAnimTable4_Entry1_FramePointers` | `5280, 52C1, 5302` | `5343` -> `CommScene_ObjAnimTable4_Entry1_Script` |

The old master/list names were `Table_70_4DBB`, `Table_70_4DCF`,
`Table_70_4E50`, `Table_70_4FED`, `Table_70_5187`, `Table_70_5272` and
`Table_70_527A`; former frame and script names were `Data_70_*` at the
addresses above. Only labels and pointer operands changed. No data directives
or physical byte ranges changed. The bounded maintained-source/tool search
found no consumers outside this owner; frozen `config/` and historical
analysis retain old names. The six-root whitespace-aware lexical count is now
458 `Data_BB_AAAA::` definitions in 137 owners after these 27 Data-label
renames. This is not a semantic-completion measure.

## Bank 51 communication-time graphics aliases (2026-10-21)

Retired eleven same-address `Data_51_*` declarations from
`gfx/comm/time_summary.asm` under existing descriptive graphics, tilemap and
palette names. The `.sym` file confirms each old and retained name shared the
same bank/address. Active source and tool scans found no uses of the old names
outside their declarations; eight `gfx/assets.tsv` label cells were aligned
to the retained names. `Data_51_5EE1` remains neutral because no same-address
descriptive label exists and its wider tile-data association is only
**PROBABLE**. Frozen `config/regions/bank51.tsv`, `config/xrefs.tsv` and
historical `analysis/` retain prior names as evidence snapshots. Data spans,
confidence comments and assets did not change. The whitespace-aware six-root
lexical count is 447 `Data_BB_AAAA::` definitions in 136 owners after these
eleven alias retirements; this is not a semantic-completion measure.

| Retired alias | Retained name | Address |
|---|---|---|
| `Data_51_42A0` | `Gfx_CommTime_SummaryA_Tiles9000Vb1` | `51:42A0` |
| `Data_51_46A0` | `Gfx_CommTime_SummaryA_Tiles9400Vb1` | `51:46A0` |
| `Data_51_4AA0` | `Tilemap_CommTime_SummaryA` | `51:4AA0` |
| `Data_51_4D70` | `Palette_CommTime_SummaryA` | `51:4D70` |
| `Data_51_4DB0` | `Gfx_CommTime_SummaryB_Tiles9000Vb1` | `51:4DB0` |
| `Data_51_51B0` | `Gfx_CommTime_SummaryB_Tiles9400Vb1` | `51:51B0` |
| `Data_51_55B0` | `Tilemap_CommTime_SummaryB` | `51:55B0` |
| `Data_51_5880` | `Palette_CommTime_SummaryB` | `51:5880` |
| `Data_51_58C0` | `Gfx_ConnIcon_Request2_Tiles8200` | `51:58C0` |
| `Data_51_5CC0` | `Gfx_ConnIcon_Request2_Tiles8600` | `51:5CC0` |
| `Data_51_5EC0` | `Palette_ConnIcon_Request2_Obj4` | `51:5EC0` |

## Bank 24 page-list tiles and candidate animation records (2026-10-21)

In `gfx/browser/page_list.asm`, the two probable 2bpp regions at `24:55D0`
and `24:5EF1` now use `PageList_Tiles_*` labels, matching their owner and
bounded tile-coherence notes; `gfx/assets.tsv` points to the new names. The
two frame-pointer tables at `24:6995` and `24:6A57`, their twelve
pointer-ordered records, and three structurally parsed animation scripts at
`24:6986`, `24:6A4F` and `24:6B11` now use `PageList_CandidateAnim*` labels.
The candidate prefix preserves the existing HYPOTHESIS on script association
and does not claim a known object-table row, caller, sprite identity, or
natural rendering. Both tables and their record extents remain PROBABLE from
the existing parser/layout evidence. `Data_24_6520` remains neutral because
the repeated words target addresses inside another tile-data interval and no
consumer or role is established. Only symbols and their two asset-catalog
cells changed; `dw` operands point at the corresponding new frame names, while
data directives, byte order, extents, and record comments remain unchanged.
The finite maintained-source/tool search found the old symbols only in this
owner and the two catalog cells; no external consumer was present. The
whitespace-aware six-root census now finds 430 `Data_BB_AAAA::` definitions
in 136 owners, down from 447 after the 17 structural labels were named. This
lexical count does not measure semantic completion.

## Bank 4D settings graphics slices and object-table aliases (2026-10-21)

Five confirmed tile-data intervals in `gfx/settings/screens_bank4d.asm` now use
`Gfx_SettingsPhone_*_TileSlice*` names tied to their bounded source range and
the confirmed VRAM destination of the containing DMA request. The `TileSlice`
word is intentional: intervals `4D:4200` and `4D:4D10` are tails of larger
uploads crossing neighboring resource boundaries, and intervals `4D:6570`,
`4D:6C70` and `4D:7170` are similarly clipped by higher-priority labels. These
names do not claim standalone uploads or widen any resource extent.

Eight `Data_4D_*` labels were exact-address duplicates of existing object-data
or graphics symbols, and `Table_4D_5D10`/`Table_4D_7960` duplicated the named
object tables. The current `.sym` snapshot confirmed all ten address pairs;
maintained source and tool scans found no active use of the old spellings
outside their owner, while six graphics catalog cells pointed to the aliases.
Those catalog cells now use the surviving resource names. The alias lines were
blanked in place, preserving the 274-line owner. No payload/directive changed.
The whitespace-aware six-root census is now 417 `Data_BB_AAAA::` definitions
in 135 owners, down from 430 in 136 owners after 13 Data labels were renamed
or retired; bank 4D no longer owns a generic `Data_BB_AAAA` label.
This lexical count does not measure semantic completion.

## Bank 42 frame-design candidate labels (2026-10-21)

In `gfx/frame_designs/metal_flame_and_creature_borders_42.asm`, 27 labels
whose names exposed only bank, type and address were changed to
`FrameDesignCandidate_*` names derived from the four existing asset-path
families and their bounded extents. All prior evidence grades remain; this
does not establish a natural loader or screen composition. The catalog and the
`tools/raw_png.py` metadata check now use the updated names. The
whitespace-aware six-root census is 403 `Data_BB_AAAA::` definitions in 134
owners, down from 417/135; the change is lexical and not a completion metric.

## Bank 6A help-screen exact-address aliases (2026-10-21)

Ten generic `Data_6A_*` declarations in `gfx/help/help_screens_a.asm` were
exact-address aliases of existing tilemap, graphics or palette labels. The
maintained assembly/INCLUDE search found no active operand using those generic
names. The aliases were blanked in place, preserving the owner's line count,
payloads, boundaries and existing confidence comments. The twelve affected
`gfx/assets.tsv` tilemap and tile rows now point to the surviving descriptive
labels. Frozen `config/` and historical `analysis/` indexes retain old
spellings as provenance; they were not regenerated or edited.

`Data_6A_6330` and `Data_6A_6448` remain neutral: the first marks the start of
the existing RGB-word include whose bytes also begin the demonstrated frame
table/OAM chain, and the second begins a continuation span. This pass does not
resolve that representation/classification conflict or assign a new role.
The six-root `Data_BB_AAAA::` census is now 393 definitions in 134 owners,
down from 403 after ten redundant exports were retired. This lexical count is
not a semantic-completion measure.

## Bank 74 HTML keyword-name aliases (2026-10-21)

Eleven `Data_74_*` labels in `data/html/keywords.asm` duplicated the
co-addressed `Html_*Names` labels for result codes, entities, meta attributes,
element attributes, attribute values and tag names. Exact-symbol searches in
the maintained ASM/INC tree and active tools found no consumer beyond the
declarations. The aliases were blanked in place; the owner remains 213 lines,
and every pointer, string/value byte, boundary and PROBABLE header is
unchanged. The earlier twelve `Table_74_*` pointer-list aliases recorded above
remain a separate completed pass.

The six-root `Data_BB_AAAA::` census is now 382 definitions in 133 owners,
down from 393/134 after these eleven redundant exports were retired. This
lexical count does not measure semantic closure.

## Bank 26 mail-session tile aliases and clipped tile slice (2026-10-21)

Eight `Data_26_*` labels in `gfx/mail/session_scenery.asm` duplicated existing
`MailSession_Tiles_*` labels at identical addresses. Their lines were blanked
in place, preserving the owner layout and tile payloads. The adjacent
`Data_26_66F0` begins a 240-byte tile-data interval inside the larger confirmed
transfer `26:66E0-67E0`; it is now `MailSession_Tiles_66F0_TileSlice` to retain
that bounded scope. The matching asset catalog label was updated, while the
generic asset path remains unchanged. `Data_26_59D8` has since been renamed
`Padding_MailSession_Tiles59E0Alignment` (**PROBABLE**): its eight zero bytes
follow the bank-26 code section and precede the confirmed tile HDMA source at
aligned `26:59E0`, with no named direct reader found. `Data_26_73E0` remains
neutral because it has only a palette heuristic. No path, payload, confidence
level or transfer boundary changed.

The six-root `Data_BB_AAAA::` census is now 373 definitions in 133 owners,
down from 382 after eight aliases were retired and one slice was renamed.
This lexical count does not measure semantic closure.

## Bank 2A save-sender animation structures (2026-10-21)

The save-sender owner had 37 type/address-only exports: 27 `Data_2A_*` labels,
eight `Table_2A_*` labels, `Tiles_2A_4FE0` and `Palette_2A_51E0`. Exact-symbol
searches across maintained ASM/INC and active tools found no external
consumers; all animation pointers are local to the owner, and only the two
resource labels appeared in `gfx/assets.tsv`. The 27 data labels now describe
19 frame records and eight scripts; the unreferenced script at `2A:545C` has a
candidate-qualified name. The eight table labels now distinguish the
slot-animation entry table from seven frame-pointer tables. The two remaining
type/address-only graphics labels are qualified as candidate tiles/palette,
preserving their existing PROBABLE evidence and lack of a demonstrated
loader. Existing header statuses, record extents, pointer words, payloads and
237-line owner layout are unchanged. These names describe bounded structures;
they do not identify a depicted object or establish natural entry.

The six-root `Data_BB_AAAA::` census is now 346 definitions in 132 owners,
down from 373/133 after the 27 generic data labels received structural names.
This lexical count is not a semantic-completion measure.

## Bank 55 keyboard-page trailer names (2026-10-21)

Eight `Data_55_*` labels in `data/keyboard/pages.asm` marked short trailer or
separator byte runs between successive page starts in `Table_Kbd_PagePointers`.
The existing comments identify the repeated `$FF83`/`$FF82` markers and their
executed reads; neighboring page labels and pointer order assign each run to
the preceding T6/T78 page. The labels now include the corresponding page class
and `Trailer` suffix. Existing PROBABLE evidence remains; this does not claim
that every marker's consumer or original design intent is understood. Exact
searches found no external active source/tool consumer, and the 870-line owner
and bytes remain unchanged.

The six-root `Data_BB_AAAA::` census is now 302 definitions in 129 owners,
down from 310/130 after these eight labels received bounded structural names.
This lexical count is not a semantic-completion measure.

## Bank 47 browser-scrollbar tile names (2026-10-21)

Six `Data_47_*` exports in `gfx/browser/frames_0_1.asm` duplicated existing
same-address scrollbar tile labels, each backed by a confirmed DMA source and
destination. Exact-token searches found no external maintained-source or
active-tool consumers. The remaining isolated 64-byte block at `47:4040` is
only PROBABLE from visual/tile heuristics and overlapping source coverage; it
now uses `Gfx_BrowserScrollbar_CandidateTileSlice_4040`. The seven catalog
rows point to the surviving or candidate-qualified names. The 78-line owner,
payloads and evidence levels are unchanged; no screen-descriptor or natural
loader claim is added for `47:4040`.

The six-root `Data_BB_AAAA::` census is now 295 definitions in 128 owners,
down from 302 definitions in 129 owners after these six aliases were retired
and one generic label received a structural name. This lexical count is not a
semantic-completion measure.

## Bank 28 delete-method exact-address aliases (2026-10-21)

Seven `Data_28_*` exports in `gfx/mail_server/delete_method_screen.asm`
duplicated same-address confirmed tile/tilemap resources or the existing
`MailServerDeleteMethod_ObjAnimData` label. Exact-token searches found no
external maintained-source or active-tool consumers; the asset catalog already
uses the retained resource names. The alias lines were blanked in place,
preserving the 116-line owner and every directive, payload, extent and evidence
grade. No palette or object-record role was changed.

The six-root `Data_BB_AAAA::` census is now 288 definitions in 127 owners,
down from 295 definitions in 128 owners after these seven aliases were
retired. This lexical count is not a semantic-completion measure.

## Bank 1A mobile-dictionary labels (2026-10-21)

Six `Data_1A_*` exports in `gfx/help/mobile_dictionary.asm` duplicated the
existing screen tilemap, three confirmed graphics blocks, background palette
and object-table labels. Exact-token searches found no external active source
or tool consumers; asset metadata already used the retained resource labels.
The remaining eleven-byte span at `1A:4A85` is all zero bytes, immediately
between the tilemap and the first confirmed tile transfer. Its address-only
label is now `MobileDict_ZeroByteSpan_4A85`; the existing PROBABLE region
classification remains, and the new name does not assign a padding role. The
66-line owner and all bytes/extents are unchanged.

The six-root `Data_BB_AAAA::` census is now 281 definitions in 126 owners,
down from 288 definitions in 127 owners after six aliases were retired and
one generic label was replaced by the bounded byte-span name. This lexical
count is not a semantic-completion measure.

## Bank 4E browser frame descriptors (2026-10-21)

`Data_4E_6543` is now `Browser_FrameAttributeLookup_6543`. The renderer at
`4E:6486-649D` masks each screen attribute to three bits, reads one of the
eight bytes at `4E:6543`, and combines it with the original attribute's upper
bits. The name describes that computed lookup; its broader screen role and
natural-entry evidence remain **HYPOTHESIS**.

The five `Data_4E_*` labels at `4E:6581/65A0/65BF/65DE/65FD` duplicated the
existing `Data_Browser_FrameDesc*` labels at the same addresses. The
`Table_4E_654B` declaration likewise duplicated
`Table_Browser_FrameDescriptors`. Exact-token source searches found no other
maintained-source consumers. Only redundant declarations were removed; the
27 pointer entries, descriptor bytes, comments and confidence levels remain
unchanged.

The six-root `Data_BB_AAAA::` census is now 275 definitions in 125 owners,
down from 281 definitions in 126 owners: five aliases were retired and one
generic label was renamed. This lexical count is not a semantic-completion
measure.

## Bank 71 communication panel and account-screen graphics (2026-10-21)

`Data_71_5038` and `Data_71_5098` are now the eight indexed
`CommPanel_CaptionMap0..7` records at `71:5038, 5098, 50F8, 5158, 51B8,
5218, 5278, 52D8`. `CommPanel_DrawCaption` at `68:7611` obtains an index from
the phase/variant records, reads `CommPanel_CaptionMaps` at `68:765E`, and
calls `Tilemap_CopyRectAndAttr` with `BC=$040C` and bank `$71`. The helper
copies four rows of twelve bytes, then the following source bytes to the
attribute buffer. Each map is therefore 48 tile bytes followed by 48
attribute bytes. Map indices and record boundaries are CONFIRMED; actual
caption text and the natural meaning/selection of each index remain unknown.
The eight zero bytes at `71:5338` are separately labeled
`ZeroByteSpan_71_5338`; their role remains HYPOTHESIS.

Four generic graphics labels were also replaced with source-slice names.
`Gfx_CommPanel_TileSource_4500` is within the `68:747A` transfer from
`71:4490` to `71:4890`, mapped to VRAM `$9000-$9400` in VB1.
`Gfx_Registration_DeleteConfirm_TileSource_5B40` is the final 40 tiles of
the `68:7A16` transfer from `71:59C0` to `71:5DC0`, mapped to VRAM
`$9000-$9400` in VB1. The delete-execute source slices at `71:61C0` and
`71:6440` participate in the overlapping transfers at `68:7BF7` and
`68:7BD3`; comments preserve both ranges and VRAM banks. Four matching
`gfx/assets.tsv` labels were updated. Source payloads, paths, and byte extents
are unchanged.

The six-root `Data_BB_AAAA::` census is now 269 definitions in 124 owners,
down from 275 definitions in 125 owners after all six generic labels in this
owner were replaced. This lexical count is not a semantic-completion measure.

## Bank 28 mail-body view resources (2026-10-21)

Five `Data_28_*` declarations in `gfx/mail/body_view.asm` were exact-address
aliases of the existing mail-body tile, tilemap and object-animation labels.
`Palette_28_4AF0` and `Table_28_4B70` likewise duplicated
`MailBody_BgPalette` and `MailBody_ObjTable`. Bounded exact-token searches
found no maintained-source or active-tool consumers for these aliases. The two
asset-catalog rows for the 4550 tilemap/attrmap pair now use
`Tilemap_MailView_BodyPage`; bytes, paths and extents are unchanged.

The 28-byte span at `28:4BA6`, previously `Data_28_4BA6`, is now
`WramClearCandidate_28_4BA6`. Direct decoding of the original bytes describes
the operation only conditionally: if entered at the first byte, it zeros
`$C000-$C08F`, selects WRAM bank 7, fills `$DA00-$DAFF` with `$FF`, and returns.
No call or pointer reference establishes that it is naturally entered or that
this is its intended purpose. Code classification, entry and purpose remain
**HYPOTHESIS**; this label records the bounded instruction pattern rather than
claiming a live routine.

The six-root `Data_BB_AAAA::` census is now 263 definitions in 123 owners,
down from 269 definitions in 124 owners. Five exact aliases were retired and
the sixth generic label was replaced by the code-candidate name. This lexical
count is not a semantic-completion measure.

## Bank 2C address-picker resource names (2026-10-21)

Seven `Data_2C_*` declarations in `gfx/address_book/address_picker.asm` were
same-address aliases under existing graphics, tilemap, palette or object-data
labels; `Table_2C_7210` and `Palette_2C_71D0` likewise duplicated named
symbols. Exact-token scans found no external maintained-source or active-tool
consumers. The asset catalog's probable tile block at `2C:6FD0` had the generic
type/address name `Tiles_2C_6FD0`; it is now `AddrPick_CandidateTiles_6FD0`,
and its catalog row follows the new name. The existing PROBABLE evidence and
lack of a loader remain. `Data_2C_7355` stays neutral because its two bytes
have no identified content class. Source lines, payloads, extents and
confidence comments are preserved.

The six-root `Data_BB_AAAA::` census is now 310 definitions in 130 owners,
down from 317 after seven exact aliases were retired. This lexical count is not
a semantic-completion measure.

## Bank 0E title-screen resource aliases (2026-10-21)

Ten `Data_0E_*` exports in `gfx/title/title_screen.asm` duplicated existing
same-address graphics, screen tilemap, highlight-start and background-palette
labels. Exact-token searches found no uses in maintained ASM/INC sources or
active tools beyond the declarations. The asset catalog already referenced the
descriptive labels. The aliases were blanked in place, preserving the 93-line
owner, data extents, resource files and evidence grades. Frozen `config/` and
historical `analysis/` indexes still contain their old symbol spellings as
provenance; neither was regenerated or edited.

The six-root `Data_BB_AAAA::` census is now 327 definitions in 131 owners,
down from 337 definitions in 132 owners after these ten exact aliases were
retired. This lexical count is not a semantic-completion measure.

## Bank 29 compose-object candidate animation names (2026-10-21)

The remaining ten generic `Data_29_*` labels in
`gfx/mail/compose_objects.asm` described frame records and script records in
the unselected `29:6290` animation-entry block and the adjacent unreferenced
group at `29:63F0`. They now use `MailBodyCandidate_*` names tied to their
frame/script structure and indices; the orphan group keeps an explicit
`Orphan` qualifier. Existing HYPOTHESIS/PROBABLE comments remain unchanged, so
these names do not claim a natural caller or selection. The table at `29:6350`
continues under `Table_MailBody_ObjectEntries`; its duplicate
`Table_29_6350` export was removed. Ten more `Table_29_*` declarations at
`29:6406` through `29:64C9` were exact aliases under existing
`MailBody_29_Anim*Frames` labels and were removed. Pointer expressions in the
candidate block now use its descriptive names. No bytes, directives, data
boundaries or confidence grades changed.

The six-root `Data_BB_AAAA::` census is now 317 definitions in 130 owners,
down from 327 definitions in 131 owners after these ten Data labels received
structural names. This lexical count is not a semantic-completion measure.

## Bank 1D mail-menu exact-address aliases (2026-10-21)

The `gfx/mail_menu/mail_menu.asm` owner had fifteen generic labels at
addresses already represented by more descriptive labels: nine `Data_1D_*`
aliases under the screen tilemap, six confirmed graphics blocks, background
palette and object-record stream, plus six type/address-only tilemap and
attribute-map aliases. Their source spans remain intact, and active maintained
source searches found no consumers of the retired names. The asset catalog
already used the retained labels, so it needed no change. The owner's 162-line
layout, includes, data boundaries and evidence levels are unchanged.

At that dated audit checkpoint, `Data_1D_62B0` remained neutral under a palette-like heuristic,
but the object table at `1D:63B6` points to it, and there is no demonstrated
frame-table layout. The pointer comment now records that limited finding
without assigning a role. The six-root `Data_BB_AAAA::` census is now 337
definitions in 132 owners, down from 346 after nine duplicate Data exports
were retired. This lexical count is not a semantic-completion measure.

## Bank 2E mail-server tidy-screen data structures (2026-10-21)

The six generic labels in `gfx/mail_server/tidy_screen.asm` were checked
against the bank's HDMA sites and local object/frame/script pointers.
`Data_2E_5AF0` is now `Gfx_MailServerMgr_Tiles9400Vb1_Tail_5AF0`, identifying
the source slice following the 16-byte prefix at `2E:5AE0`; the asset catalog
uses the same label. `Data_2E_7710` now has the owner-qualified probable
animation-data label `MailServerMgr_ObjAnimData_2E_7710`.

The four object entries at `2E:7700` point to a two-word frame table at
`2E:7921`, now expressed as `sprite_frame_table SpriteFrame_2E_7925,
SpriteFrame_2E_793E`. The six-piece records at both destinations use
`SpriteFrame` names. The script beginning at `2E:7957` now uses the two-step
animation macros, which emit the original five bytes. The following six bytes
at `2E:795C` also fit a two-step script shape, but no pointer from the bounded
object-table walk targets them; their candidate label and role remain
HYPOTHESIS.

No source payload or extent changed. The six-root `Data_BB_AAAA::` census,
excluding `engine/mail/sample_data.asm`, is now 257 definitions in 122 owners,
down from 263 definitions in 123 owners after these six generic declarations
were given structural or owner-qualified names. This is a lexical count, not a
semantic-completion measure.

## Bank 25 mailbox resources (2026-10-21)

`Data_25_6410`, `Data_25_66E0` and `Data_25_69B0` were exact-address
duplicates under the existing confirmed mailbox normal/delete-select tilemap
and background-palette labels. Their redundant export lines were removed in
place; payloads and offsets are unchanged. The 272-byte include at `25:6BD1`
is listed in the image-text inventory as 17 tiles containing arrow/label
pieces. It is now `Mailbox_CandidateTiles_ArrowLabel_6BD1`; the existing
PROBABLE classification and 15-byte zero pad remain, since no natural loader
was established. At this audit checkpoint, `Data_25_6AC8` and
`Data_25_6E71` remained neutral: their bytes are read in merged ranges, but no
sufficiently specific content class was shown. Their current names and
bounded transfer evidence are recorded in the
[mailbox read-data follow-up](#mailbox-read-data-spans-with-unknown-content-2026-10-21).
The asset catalog now uses the candidate name.

The six-root `Data_BB_AAAA::` census, excluding
`engine/mail/sample_data.asm`, is now 253 definitions in 122 owners, down from
257 in 122 owners after three exact aliases were retired and the candidate tile
asset received a qualified name. This remains a lexical count.

## Bank 71 settings-screen sprite aliases (2026-10-21)

`Data_71_6F44`, `Data_71_6F69` and `Data_71_6F6A` duplicated the same-address
`Registration_DeleteExecute_Anim1Frame0`, `Registration_DeleteExecute_Anim1Frame1`
and `Registration_DeleteExecute_Anim1Script` labels in
`gfx/settings/screens_bank71.asm`. The retained sprite labels already describe
the macro structures at those addresses. Only the redundant exports were
removed; macro sequence, byte extents, evidence grades and resource files are
unchanged. The two standalone spans at `71:723F` and `71:7271` remain neutral:
the former is a clipped, probable tile-like span, and the latter is read data
whose class is unknown.

The six-root `Data_BB_AAAA::` census, excluding
`engine/mail/sample_data.asm`, is now 250 definitions in 122 owners, down from
253 in 122 owners. This remains a lexical count.

## Bank 25 mail-server status resource aliases (2026-10-21)

Five `Data_25_*` declarations in `gfx/mail/server_status.asm` duplicated the
same-address tile and tilemap labels `MailServerStatus_Tiles_6F30`,
`MailServerStatus_Tiles_7330`, `MailServerStatus_Tilemap_Received`,
`MailServerStatus_Tilemap_NoneReceived` and
`MailServerStatus_Tilemap_ServerMgmt`. The existing descriptive labels agree
with the confirmed bank-29 HDMA/tilemap-copy call sites. Bounded source search
found no other maintained-source uses of the generic spellings; the catalog
already uses descriptive symbols. The five aliases were removed; assets,
extents, offsets and confidence were unchanged.

The restricted six-root `Data_BB_AAAA::` census is now 245 definitions in
121 owners, down from 250 in 122 owners. This remains a lexical count.

## Bank 6A help-script resources and object table (2026-10-21)

Four `Data_6A_*` labels at `6A:6716`, `69F0`, `6A10` and `6A20` duplicated
the existing help-script tilemap/tile labels. `Palette_6A_7220` and
`Table_6A_72BB` likewise duplicated `Palette_HelpScript_Bg` and
`Objects_HelpScript_Slot2`; those aliases were removed. The probable
64-tile span at `6A:6E20`, listed in the image-text inventory as footer legend
and frame pieces but with no demonstrated loader, is now
`HelpScript_CandidateTiles_6E20`; its PROBABLE grade remains. At that checkpoint, the ten zero
bytes at `6A:69E6` remained neutral. That decision is superseded by the probable
alignment label `Padding_HelpScript_Tiles69F0Alignment` in
`original_closure_followup_20261021.md`. Asset metadata was reconciled to current
labels. The preview sheet for the already named object-table root was renamed
to `Objects_HelpScript_Slot2_6A_72BB.png`; its SHA-256 is unchanged
(`ffcfa9d4fc2822a98626c17b783bb99e877074fb2a075d451cb83c5bd0e4d4d7`).

The restricted six-root `Data_BB_AAAA::` census is now 241 definitions in
121 owners, down from 245 in 121 owners. This remains a lexical count.

## Bank 2C mail-title resource names (2026-10-21)

In `gfx/mail/mail_title_entry.asm`, `Data_2C_4A30`, `Data_2C_4E30` and
`Data_2C_5100` duplicated the existing tile, tilemap/attribute and background
palette labels. These exact aliases had no source consumers and were removed.
The object-palette alias `Palette_2C_5670` was likewise redundant. The
unclassified 1308-byte span at `2C:5150` remains `Data_2C_5150` because its
content boundary is known but its role is not.

The table at `2C:56B0` and its 50-byte target at `2C:56C0` retain PROBABLE
confidence and now use `MailTitle_ProbableObjAnimFrameTable` and
`MailTitle_ProbableObjAnimFrameData`. The eight-word table repeatedly points
to the frame-record list and `$56EF`; the candidate describes the observed
shape, not a located natural caller or proven runtime role. No bytes or ranges
changed. The restricted six-root `Data_BB_AAAA::` census is now 237
definitions in 121 owners, down from 241 in 121 owners. This remains a lexical
count.

## Bank 27 communication-time digit-pair table alias (2026-10-21)

`Data_27_5048` duplicated the existing `Table_CommTime_DigitTiles_27_5048`
label over the same 20-byte table of ten two-tile entries. The computed reader
and its bounded index relation are already documented at the named table;
source search found no other consumer of the generic alias. The duplicate
export was removed, with table bytes, interpretation and PROBABLE confidence
unchanged. Other unclassified spans in this owner remain neutral. The
restricted six-root `Data_BB_AAAA::` census is now 195 definitions in 112
owners, down from 196 definitions in 112 owners. This remains a lexical
count.

## Bank 44 border attribute maps (2026-10-21)

The four 360-byte `Data_44_*` blocks were identified by their bounded
position and attribute-byte layouts as the 20x18 attribute maps of the
monochrome arc, blue bubble, rock and turquoise scroll border packages. Their
labels now use `Attrmap_ArcBorder_Monochrome`, `Attrmap_BubbleBorder_Blue`,
`Attrmap_RockBorder` and `Attrmap_ScrollBorder_Turquoise`; matching catalog
rows were updated. The owner still has no demonstrated loader, so all remain
PROBABLE and no natural-use assertion is added. Bytes and extents are
unchanged. The restricted six-root `Data_BB_AAAA::` census is now 196
definitions in 112 owners, down from 200 definitions in 113 owners. This
remains a lexical count.

## Bank 2F address-book editor resource names (2026-10-21)

Three exact `Data_2F_*` aliases in `gfx/address_book/address_editor.asm`
duplicated the existing tile, tilemap and palette labels and were removed.
The pointer table at `2F:7DD0` and its 159-byte target at `2F:7E20` remain
PROBABLE, with names `AbookAddr_CandidateObjAnimTable` and
`AbookAddr_CandidateSpriteData` (renamed in the follow-up below). The repeated target pointers and record
shape support the candidate classification, but no caller was located; these
names do not assert natural use. No bytes/ranges or confidence changed. The
restricted six-root `Data_BB_AAAA::` census is now 200 definitions in 113
owners, down from 204 definitions in 114 owners. This remains a lexical
count.

## Bank 62 keyboard page-tail tile candidates (2026-10-21)

The four 192-byte spans after the loaded tile ranges for keyboard pages 0–3
were named `Gfx_Kbd_T78_PageN_CandidateTailTiles`. All four payloads are
byte-identical (SHA-256
`7a2ab1f13e5b8deb57f2abc336fd99039d4d87d32fbe41939ec2ae320309458a`), each
is exactly 12 tiles, and the preceding natural loaders transfer only the
36-tile portion ending at the candidate span. No loader for these spans was
found. The labels express the repeated per-page structure and heuristic tile
classification without asserting that the bytes are displayed. PROBABLE
grades remain. Catalog names were reconciled. The restricted six-root
`Data_BB_AAAA::` census is now 208 definitions in 115 owners, down from 212
definitions in 116 owners. This remains a lexical count.

## Bank 29 connection-time graphics aliases (2026-10-21)

`Data_29_5400` and `Data_29_5800` duplicated the existing probable tile and
tilemap resource labels in `gfx/mail/connect_screen_bank29.asm`; the loader
sites in bank 27 use those descriptive names. `Palette_29_5AD0` likewise
duplicated `Palette_CommTimeHMS_Bg`. These three exact aliases were removed,
and the three affected asset-catalog rows now use the maintained names. The
heuristic palette at `29:5376` and ten-byte partial-tile span at `29:53F6`
remain neutral. Confidence and bytes are unchanged. The restricted six-root
`Data_BB_AAAA::` census is now 212 definitions in 116 owners, down from 214
definitions in 116 owners. This remains a lexical count.

## Bank 72 dialog-window resource aliases (2026-10-21)

Four exact `Data_72_*` aliases in `gfx/dialog/dialog_window.asm` duplicated
the existing confirmed names for the short/tall dialog tilemaps, window tiles
and dialog palette. Source search found no consumers beyond the definitions;
the aliases were removed. The separate object palette and cursor animation
records are unchanged. All load evidence, confidence, ranges and catalog rows
remain as before. The restricted six-root `Data_BB_AAAA::` census is now 214
definitions in 117 owners, down from 218 in 117 owners. This remains a lexical
count.

## Bank 28 delete-all screen resource aliases (2026-10-21)

Four `Data_28_*` labels in `gfx/mail_server/delete_all_screen.asm` duplicated
the same-address named tile and tilemap resources. `Palette_28_5EA0` likewise
duplicated `MailServerDeleteAll_BgPalette`. All five spellings had no
maintained-source consumers beyond their own declarations; they were removed.
Catalog rows continue to reference the descriptive labels. CONFIRMED tile and
tilemap evidence and PROBABLE palette classifications remain unchanged. The
restricted six-root `Data_BB_AAAA::` census is now 218 definitions in 117
owners, down from 222 in 118 owners. This remains a lexical count.

## Bank 05 song 13 and 15 stream aliases (2026-10-21)

The five `Data_05_*` labels in each of `audio/music/music_13.asm` and
`audio/music/music_15.asm` duplicated the already named four track starts and
the song header. Exact-token searches across maintained Japanese ASM found no
consumers of the generic spellings beyond their declarations. The aliases
were removed; stream bytes, header bytes, pointer tables, boundaries and
PROBABLE/CONFIRMED grades are unchanged. The restricted six-root
`Data_BB_AAAA::` census is now 222 definitions in 118 owners, down from
232 definitions in 120 owners. This is a lexical count, not a completion
measure for sound interpretation.

## Bank 7F browser page-list candidate assets (2026-10-21)

In `gfx/browser/page_list_candidate.asm`, five `Data_7F_*` labels duplicated
the existing probable tile/tilemap names or `PageListProto_ObjAnimData`; two
address-only palette labels duplicated the named background/object palettes,
and `Table_7F_6DB0` duplicated `PageListProto_ObjTable`. These exact aliases
were removed. The seven corresponding catalog rows now use the maintained
semantic labels. All these resources remain PROBABLE: their entries are not
reached in the natural coverage set, and this pass does not establish
prototype execution. The restricted six-root `Data_BB_AAAA::` census is now
232 definitions in 121 owners, down from 237 in 121 owners. This remains a
lexical count.

## Census scope correction (2026-10-21)

The first post-edit lexical count for the bank-2E and bank-25 checkpoints used
a recursive ASM reader that did not explicitly exclude the protected
`engine/mail/sample_data.asm`. It matched only the generic-label regex and no
semantic conclusion was drawn from that file, but the counting method violated
the repository's access boundary. The corrected counts above were computed
with a Git pathspec explicitly excluding that path. At the three commits, the
six-root restricted counts are 263/123, 257/122 and 253/122; the previously
written bank-2E and bank-25 totals have been corrected here. Future census
commands must explicitly exclude the protected path before opening files.

## Bank 63 no-adapter screen resources (2026-10-21)

In `gfx/error/no_adapter.asm`, exact aliases `Data_63_6080`,
`Data_63_6CC0`, `Data_63_7318` and `Table_63_7310` were removed under the
existing no-adapter tile/object labels. The 64-byte extent at `63:6480` is
the final four tiles of the 1024-byte upload from `63:60C0` to VRAM `$8800`;
its label and catalog row now identify it as
`NoAdapter_Gfx_8800_TailTiles`. Existing loader evidence is CONFIRMED, with
no claim beyond the exact upload. Bytes and confidence are unchanged. The
restricted six-root `Data_BB_AAAA::` census is now 204 definitions in 114
owners, down from 208 definitions in 115 owners. This remains a lexical
count.

## Exact gfx co-aliases retired (2026-10-21)

A current-source census and owner-by-owner static review identified 37 neutral
co-aliases across 17 `gfx/` owners. In each case, `.sym` put the neutral and
descriptive labels at the same bank/address; the neutral spelling had no active
source/tool operands and owned no local-label scope. The 37 redundant
declarations were removed without changing directives, bytes, physical ranges,
or confidence. `gfx/assets.tsv` now uses the surviving names in 18 navigation
labels across 13 distinct old spellings; all other manifest fields are
unchanged. The complete old-to-current map is in
[`analysis/naming2/retired_gfx_coaliases_20261021.tsv`](../../analysis/naming2/retired_gfx_coaliases_20261021.tsv).

The prototype message tiles at `52:4080` remain **PROBABLE**. The stale source
comment now records the static reference from `PageListProto_ShowMessage` and
explicitly leaves natural runtime use unconfirmed. The safe build returned
`RESULT: IDENTICAL`; `sym-check` passed with 12,261 labels and 51 constants,
`palette-check` passed with 162 loads/116 arrays/2 documented over-reads/0
errors, and `png-check` passed (409 tile sheets, 4 raw views, 37 font sheets,
95 screen PNGs). A dry-run check found no command compiling the protected
`engine/mail/sample_data.asm`.

## Exact data/engine co-aliases retired (2026-10-21)

The fresh static census and owner review identified 54 exact co-aliases in 27
`data/` and `engine/` owners outside the protected mail trees. The linked
`.sym` placed each neutral and descriptive label at the same bank/address; the
neutral labels had no active operands, tool consumers, or dependent local-label
scope. The declarations were removed and six source comments were updated to
name the surviving text or correct stale reference claims. No instruction,
encoded data, physical range, or existing confidence was changed. The durable
address/owner map is in
[`analysis/naming2/retired_engine_coaliases_20261021.tsv`](../../analysis/naming2/retired_engine_coaliases_20261021.tsv).

A follow-up scope review found no active dependence that requires keeping the
two remaining neutral aliases. They were removed; their six local symbols now
qualify under the semantic globals. The global old-to-current map and local
symbol counts are in
[`analysis/naming2/retired_coincident_label_aliases.tsv`](../../analysis/naming2/retired_coincident_label_aliases.tsv); the exact local mappings are:

| Old qualified symbol | Current qualified symbol | Address |
|---|---|---|
| `Table_7E_7D8F.l7DAA` | `Charset_Iso2022JpStates.l7DAA` | `7E:7DAA` |
| `Table_7E_7D8F.l7DF7` | `Charset_Iso2022JpStates.l7DF7` | `7E:7DF7` |
| `Table_7E_7D8F.l7DFE` | `Charset_Iso2022JpStates.l7DFE` | `7E:7DFE` |
| `Table_7E_7D8F.l7E17` | `Charset_Iso2022JpStates.l7E17` | `7E:7E17` |
| `Table_7E_7D8F.l7E30` | `Charset_Iso2022JpStates.l7E30` | `7E:7E30` |
| `Palette_7F_4D50.loop` | `Palette_Canvas_Bg.loop` | `7F:4D5E` |

These are symbol-scope changes only. The jump table remains five words; the
palette remains eight bytes, and the following code is not reclassified as
part of that palette. A static review checked every local definition and jump
within each scope and found no qualified source reference to the old names.

The three-area census has 145 candidates in 347 tracked ASM/INC files, with
`languages/` and `engine/mail/sample_data.asm` excluded before reads. The older
handoff count of 42 used an unreconciled scope or method and must not be
compared as the same metric.

## Exact mail co-aliases retired (2026-10-21)

The private owner review identified 52 neutral aliases across the two
maintained mail source trees. Each shared the exact linked bank/address with a
descriptive label, had no active source operand or local-label scope, and did
not own bytes. The aliases were retired; six comments now point to the
surviving labels. The old-to-current map is in
[`analysis/naming2/retired_mail_coaliases_20261021.tsv`](../../analysis/naming2/retired_mail_coaliases_20261021.tsv).

Three blank-help strings had a latent tool issue: `rules_manual()` performed an
unused direct lookup of the neutral spelling before `add()` could accept its
absence. Removing that lookup lets `data_consumers.py` resolve the existing
semantic label at the same address. The fix is narrowly scoped; the targeted
post-build `data_consumers.py --stats` run is the regression check. Existing
PROBABLE grades on strings and call-entry hypotheses remain unchanged; no
runtime claim is added.

## Current maintained-source lexical census (2026-10-21)

A path-bounded scan at `301fb1f33e4d710cd11559614531107591c9a013` read 334
tracked ASM/include files from the six maintained roots plus `zero_labels.asm`.
It explicitly excluded `engine/mail/sample_data.asm` before reading and did not
scan `languages/`, `analysis/`, or `build/`. The exact neutral definitions were
0 `Function_BB_AAAA`, 0 `Font_BB_AAAA`, 0 `Label_BB_AAAA`, and 73
`Data_BB_AAAA` across 44 owners. Other exact prefixes remaining in that same
scope were 8 `Table`, 107 `String`, 41 `Tiles`, 24 `Tilemap`, 4 `Attrmap`, and
25 `Palette` definitions. No `gfx/bankNN` directories were present. These are
lexical counts only; they do not establish semantic identification of all
functions, data, or assets.

The source-set SHA-256 is
`a170880cc5eba44fc56abcac8ac4a8933e9bcc6e5d127f52b3848e9ed24a7d67`; the
generic-label manifest SHA-256 is
`4fbd76ef1342c9e5c835a99640dc1baf806368ce7a51fb4e6147b983a85c53e2`. The
reproducible census receipt, manifest, and consumer screening are retained in
`.tmp/jp-neutral-data-followup-301fb1f3/`. The current `data_consumers.py`
screening found 93 immediate candidates and rejected all 93; it generated no
rename rows. That result is not a consumer map or evidence that the remaining
neutral data is unused. At that historical checkpoint, `Data_1D_62B0` still
lacked a demonstrated frame-table parse; the later mail-menu follow-up at the
end of this document supersedes that conclusion. The adjacent palette heuristic
was explicitly clipped around the two confirmed mail-menu palettes, and no
independently established consumer then supported a more specific name.

## Bank-1C title-dispatch tail follow-up (2026-10-21)

The former `Data_1C_4016` bytes `C3 07 40` are now emitted as
`jp Main_TitleLoop` under `Main_TitleChoices_JumpToLoop`. The exact operation
is confirmed by disassembly; its association with the adjacent inline table
is probable from position and the matching navigation-loop shape. No direct
execution or invalid-index behavior is claimed. The neighboring single-byte
`Data_1C_401C` (`$C9`) remains neutral because no caller or entry is established.

A fresh census with the same source exclusions finds 72 exact
`Data_BB_AAAA` labels across 44 owners in 334 tracked ASM/INC files. The
source-set SHA-256 is
`1afef8e9949e57ae7a3d6ffe2c4970ab8dbf02a12f22ff0b169beaa691f9711f`; the
receipt SHA-256 is
`e5295c44af8ec24bde27f85c033b197ed4e239e7ead93c9c09523ed41ba0f7d4`.
The receipt and manifest are retained under
`.tmp/jp-neutral-data-followup-20261021/`. `data_consumers.py --stats` still
reports 93 immediate candidates rejected, with no rename rows.


## Bank 1D mail-menu icon structure correction (2026-10-21)

The earlier neutral classification of `Data_1D_62B0` was wrong. The bytes at
`1D:62B0` are a nine-word frame table: its pointers land at `62C2`, `62DB`,
`62F4`, `630D`, `6326`, `633F`, `6358`, `6371`, and `638A`. Each target starts
a six-piece frame; the nine records end at `63A3`, where the nine-step
`SpriteScript_MailMenu_Icon` begins. `Table_MailMenu_Objects` at `63B6` points
to this frame table and script. The object is initialized as id `$80` by
`MailMenu_Run`, and the existing emulator preview renders its nine-frame
mail-menu animation. The prior RGB555 heuristic arose because the file encoded
these same bytes with `RGB` macros; no mail-menu code loads that region as a
palette.

The false palette file/catalogue entry was removed, and the pointer table, all
nine frames, script, and object entry now use sprite macros and descriptive
labels. Build evidence: `make` returned `RESULT: IDENTICAL` and the original ROM
SHA-256. This is a static structure classification plus an emulator preview,
not evidence of physical hardware execution.


## Bank 1E top-menu candidate script labels (2026-10-21)

Three former `Data_1E_*` labels in `gfx/top_menu/top_menu.asm` now use
`TopMenu_CandidateSpriteScript_*` names while retaining HYPOTHESIS status.
Their bytes parse locally as scripts with 5 steps (`1E:6445`), 1 step
(`1E:6551`), and 2 steps (`1E:6554`). None is named by a known object-table
row. The known `TopMenu_ObjTable` entry 4 uses the separate
`TopMenu_Anim4Script` at `1E:6513`; adjacency does not prove these scripts
belong to the neighboring frame tables. A bounded search found no source
consumer of the old labels and no little-endian word pointer to these addresses
in bank 1E. This does not prove universal non-use or natural behavior. The
labels and comments change only the source names; emitted bytes are unchanged.
A fresh exact-name scan of 334 tracked ASM/INC files (including
`zero_labels.asm`, excluding `engine/mail/sample_data.asm`
before reading) finds 68 `Data_BB_AAAA` definitions in 42 owners and zero exact
generic `Function_BB_AAAA`, `Font_BB_AAAA`, or `Label_BB_AAAA` definitions.
These are lexical counts, not a claim that all data semantics are resolved.


## Unreached sprite-data candidates in banks 2E and 2F (2026-10-21)

Before the relabeling below, the sprite-chain audit reported `2E:7710` as 0/16
bytes reached by any walked chain (10 nonzero bytes); it reported `2F:7E20` as
0/159 (131 nonzero bytes). At
`2E:7710`, the five object tables at `2E:76C0-7710` point to frame/script
addresses from `2E:77FA` onward; none targets `2E:7710`. The former
`MailServerMgr_ObjAnimData_2E_7710` name and its “reached” comment overstated
the evidence. A follow-up boundary audit found 11 repeated local pointer,
frame-shaped record and script groups across `2E:7710-77FA`. Both source
labels now say `MailServerMgr_CandidateSpriteData_*`; this makes the probable
format and hypothetical use explicit, while preserving the distinction from
the table-reached structures beginning at `2E:77FA`.

At `2F:7DD0-7E20`, the 40 words point into the adjacent `2F:7E20-7EBF` region,
whose bytes contain internally consistent pointer, frame-shaped, and
script-shaped structures. However, no root or caller for the candidate table
was found, and no known `Sprite_InitSlot` chain reaches it. The existing
`AbookAddr_CandidateObjAnimTable` remains candidate-qualified. The data label
is now `AbookAddr_CandidateSpriteData`: `sprite_chain_check.py` treats the
token `ObjAnimData` as an asserted chain-owned block, which is unsupported
here and produced a false hard mismatch. The region's format is PROBABLE while
its use remains HYPOTHESIS. The candidate label no longer contains the
checker-reserved `ObjAnimData` token, so it is not misread as a claim of a
reached chain. The checker result after that correction and the bank-29 label
correction is recorded in the following note. No bytes changed.


## Bank 29 candidate labels versus walked sprite-chain names (2026-10-21)

The eleven `MailBodyCandidate_Anim*Frames`, `*Frame*` and `*Script` labels in
bank 29 described probable structures with no known `Sprite_InitSlot` root.
The sprite-chain checker treats those suffixes as assertions that a walked
chain reaches the named structure, even when the prefix says `Candidate`;
this created 11 false hard mismatches. The labels now use `FramePointerList`,
`OamPieces` and `TimingSequence`, preserving the candidate meaning and
structure without asserting chain reachability. The checker reports zero hard
mismatches after the rename, but does not validate these unrooted candidates
or prove natural use. The orphan animation at `29:63F0` remains explicitly
candidate/orphan-qualified.

## Bank 26 probable tile block with no located transfer (2026-10-21)

`Data_26_7840` covers a 624-byte block with a PROBABLE 2bpp tile classification
(32 coherent tiles in the heuristic scan, plus blank/partial material). The
PNG/binary pair round-trips exactly, but the bounded source/xref/screen-operation
search located no transfer from `26:7840` and no screen composition using this
asset. Its filename and label now say `candidate_tiles_26_7840` /
`CandidateTiles_26_7840`; this records the probable content type without
assigning a screen, owner behavior, or natural use. The old bank/address spelling
remains in frozen region data as historical provenance. The 624-byte binary and
PNG contents are unchanged. The build is `RESULT: IDENTICAL`; `sym-check`,
`palette-check`, and `png-check` pass. At that historical checkpoint,
`gfx_export.py check` reported three slices of the 16-byte visual byte-view at
`4A:5860`; the later bank-4A follow-up retypes the span as sprite data and
removes its active asset entry.

A fresh exact-name scan of the same 334 tracked ASM/INC files (including
`zero_labels.asm`, excluding `engine/mail/sample_data.asm` before reading)
now finds 66 `Data_BB_AAAA` definitions in 41 owners, down one from the prior
checkpoint. Exact generic `Function`, `Font`, and `Label` definitions remain
zero. The count is lexical only; the remaining neutral labels stay where a
stronger content or consumer claim is unavailable.


## Bank 26 probable palette with no located consumer (2026-10-21)

The 64-byte block at `26:73E0` fits eight RGB555 palettes by the local
heuristic, so its content class remains PROBABLE. A bounded search of active
ASM, screen rows and xref records found no bank-26 load from this address and
no screen mapping. The neutral `Data_26_73E0` label and `palette_73e0.pal`
basename are now `CandidatePalette_26_73E0` and
`candidate_palette_26_73e0.pal`. This names the probable content type but not
an owning screen or natural use; the region remains a candidate. The 64 palette
words are unchanged. Combined with the immediately preceding tile-candidate
rename, the exact-name scan of 334 tracked ASM/INC files (including
`zero_labels.asm`, excluding the protected sample before reading) now finds 66
`Data_BB_AAAA` definitions in 41 owners, with zero exact generic `Function`,
`Font` or `Label` definitions. These lexical counts do not close data
semantics.

## Bank 4B account result-page candidate graphics names (2026-10-21)

The two probable tile blocks at `4B:5080` and `4B:5420` now use
`AccountResultPage_CandidateTiles_*` source labels and matching asset-catalog
cells. Their existing `.2bpp` files round-trip the exact ROM spans; local
heuristics classify both as coherent tile data, but the audit found no known
consumer that supports an owning-screen/use claim. The candidate names record
content class and adjacent result-page context without asserting natural use.
The 32-byte block at `4B:5400` remains `Data_4B_5400` because its bytes are
read as data but have no supported content class. No payload, extent, or
confidence changed.

The follow-up lexical scan of the six maintained source roots plus
`zero_labels.asm` finds 63 exact `Data_BB_AAAA` definitions in 41 owners and
zero exact `Function_BB_AAAA`, `Font_BB_AAAA` or `Label_BB_AAAA` definitions.
It excludes `engine/mail/sample_data.asm` before reading. These counts track
spellings, not semantic completion; neutral labels remain where evidence does
not support a stronger role.

The same source-bounded scan finds 107 `String_BB_AAAA`, 8 exact
`Table_BB_AAAA`, 41 `Tiles_BB_AAAA`, 24 `Tilemap_BB_AAAA`, 4 `Attrmap_BB_AAAA`
and 25 `Palette_BB_AAAA` definitions. These counts help locate residual
neutral names; each needs an owner-level evidence review before changing its
symbol or directory.


## Bank 6A help-menu ticker tables and strings (2026-10-21)

The help-menu source contains two bank-prefixed ticker records. The ordinary
record begins at `6A:64B2` (the byte at `64B1` completes the preceding object
entry); its eight title/body pairs begin at `64B3`. The locked-item record begins
at `6A:6651`, followed by eight four-byte pointer pairs through `6A:6672`.
`HelpMenu_ShowItemText` (`6C:4763`) selects the ordinary record or the locked
record after `HelpMenu_ItemIsLocked`; it passes that base in `HL`, the selected
item in `B`, bank `6A` in `A`, and calls `Ticker_Start` (`48:42D4`). The ticker
reader consumes the leading text-bank byte and indexes a title/body pointer
pair. These source-level consumers establish the records' layout and purpose
(PROBABLE). They do not establish natural rendering for every slot or prove
that all eight slots are exposed to users. Existing per-range CONFIRMED labels
and trace counts were not raised by this pass.

The eight ordinary title/body strings now use `HelpMenu_TickerEntryN_Title` and
`HelpMenu_TickerEntryN_Body` names. The locked table and non-null records use
`HelpMenu_LockedTickerTable`, `HelpMenu_LockedTickerEntries_*`, and
`HelpMenu_LockedTicker_EntryN_*`. The name at `6A:64B1` describes the mixed
object-tail/bank prefix; the pointer table label starts at `6A:64B3`, not at
that mixed prefix. Only symbols and operands changed; the bytes and extents did
not. The sole active direct reference to the renamed locked record was updated
in `engine/help/help_menu.asm`.

Coordinator gates after the change: `make` returned `RESULT: IDENTICAL` with
ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` passed with 12,168 source labels and 51 constants;
`make palette-check` reported 162 loads, 116 arrays, two documented over-reads
and zero errors; `make png-check`, `gfx_export.py check`, and
`sprite_chain_check.py` passed (zero hard mismatches and zero frame-index
violations).

The updated path-bounded lexical census (six maintained source roots plus
`zero_labels.asm`, excluding `engine/mail/sample_data.asm` before reading) is
63 exact `Data_BB_AAAA` definitions in 41 owners, 97 `String_BB_AAAA`, no
exact `Table_BB_AAAA`, 41 `Tiles_BB_AAAA`, 24 `Tilemap_BB_AAAA`, 4
`Attrmap_BB_AAAA`, and 25 `Palette_BB_AAAA`; exact generic `Function`, `Font`,
and `Label` remain zero. The ticker pass accounts for ten fewer String labels
and four fewer Table labels; the table pass below removes the final four exact
Table spellings. Counts describe spellings only, not semantic closure.


## Remaining generic table labels (2026-10-21)

The four remaining exact `Table_BB_AAAA` labels were reviewed against their
nearby readers and data:

| Address | Current label | Evidence and limit |
|---|---|---|
| `27:4FD8` | `CommTime_SummaryInputDispatchTable` | **PROBABLE**: five entry pointers follow the `JoypadDispatch` call; entries select the summary screen's A/B/Select/Start handlers or loop. The label does not assert natural input coverage. |
| `4E:4172` | `Browser_FrameStylePreview_InputDispatchTable` | **PROBABLE**: same five-entry `JoypadDispatch` pattern in the frame-style preview loop; dispatch table shape and handlers are static source evidence. |
| `2B:6DB0` | `MailReply_SramRecordBaseTable` | **PROBABLE**: `MailReply_ComposeFromRecord` indexes twelve words by record index and uses each value as an SRAM base before reading address/name fields at offsets `$ED`/`$C9`. The function's natural caller/entry status remains unproved. |
| `2A:7287` | `AddrBook_CandidateSramSlotAddressTable_7287` | **HYPOTHESIS**: six words are byte-identical to the referenced table at `2A:7221`, but no code reference to this copy was found. Its purpose and use remain unknown; candidate wording does not assert that it is read. |

The three supported structures now have consumer-oriented labels; the unreferenced
copy is still explicitly candidate-qualified. Source and operands changed only in
labels; the original byte stream is unchanged. After this pass, a path-bounded
scan of the six maintained roots plus `zero_labels.asm`, excluding
`engine/mail/sample_data.asm` before reading, reports 63 exact Data labels in
41 owners, 97 String, 0 Table, 41 Tiles, 24 Tilemap, 4 Attrmap and 25 Palette;
exact generic Function, Font and Label remain zero.


## Bank 3D/3E HTML store first-record names (2026-10-21)

The first record in each banked HTML store begins with a literal filename,
followed by its body length and HTML body. `String_3E_4000` at `3E:4000` now
uses `BrowserHtmlStore_RecordAmark`; its literal header is `a_mark.htm`.
`String_3D_4000` at `3D:4000` now uses `BrowserHtmlStore_RecordSaport`; its
literal header is `saport.htm`. This identifies the record from the bytes and
the owner comments that enumerate the store ranges. No named consumer was found
for either old symbol, so these names do not assert natural browser lookup or
rendering. The bytes, length fields, and record boundaries are unchanged.

After these two renames, the path-bounded census (six maintained roots plus
`zero_labels.asm`, excluding `engine/mail/sample_data.asm` before reading) is
63 exact Data labels in 41 owners, 95 String labels, no exact Table labels, 41
Tiles, 24 Tilemap, 4 Attrmap, and 25 Palette labels; exact Function, Font, and
Label remain zero. Counts are lexical, not a semantic-completion claim.


## Debug glyph and candidate blank-line records (2026-10-21)

`String_19_452F` contains the Shift-JIS character `▲` followed by NUL.
`DebugFlags_LoadHelpText` passes this label and its bank to
`TextTiles_RenderGrid`, then transfers the resulting tile to `$8000`. The label
is now `DebugFlags_UpTriangleGlyph`; its content is directly observed and the
source consumer is known. The broader UI meaning and natural execution of this
path are not asserted.

`String_22_4468` and `String_23_43DF` each contain 18 full-width spaces and a
NUL. Neither has a located code reference; their former comments already
identified the blank-line interpretation as uncertain. They are now
`MailSrvDelHidden_CandidateBlankLine` and
`MailSrvDel_CandidateBlankLine`, and their headers remain HYPOTHESIS. These
names describe the bytes and owner context without asserting that code reads
them.

After these three symbol-only changes, the path-bounded census is 63 exact
Data labels in 41 owners, 92 String labels, 0 Table, 41 Tiles, 24 Tilemap, 4
Attrmap and 25 Palette; exact Function, Font and Label remain zero. The build
returns `RESULT: IDENTICAL` with the original SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` passes with 12,168 labels and 51 constants.


## Bank 2A duplicate address-selection prompt (2026-10-21)

The string at `2A:4A3D` contains 41 bytes through NUL and matches the 41-byte
string `String_AddrPick_Caption` at `2C:6704` exactly in the original ROM. A
bounded search found no code reference to the `2A:4A3D` copy. Its label is now
`AddrBook_CandidateAddressSelectPrompt_2A`, and the source header marks its
relationship/use as HYPOTHESIS. The byte equality is CONFIRMED; whether the copy
is stale, selected indirectly, or serves another purpose remains unknown. No
claim of dead data is made. The bytes and extent are unchanged.

After this symbol-only rename, the exact lexical census is 63 Data labels in
41 owners, 91 String, 0 Table, 41 Tiles, 24 Tilemap, 4 Attrmap and 25 Palette;
Function, Font and Label exact patterns remain at zero. The build is
`RESULT: IDENTICAL` with original SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` passes with 12,168 labels and 51 constants.


## Bank 72 browser-menu action strings (2026-10-21)

Three strings selected through `BrowserMenu_TwoItemRecords` and
`BrowserMenu_ThreeItemRecords` now use action-oriented names:
`BrowserMenu_TwoItem_ReturnToTopMenu` (`72:6B23`),
`BrowserMenu_ThreeItem_DisconnectPhone` (`72:6B91`), and
`BrowserMenu_ThreeItem_ExitHomepage` (`72:6BBA`). The record words point to
these strings, while the nearby code indexes the record arrays by selection.
This establishes the static pointer relationship and message contents
(PROBABLE). The existing trace supports the first record read, not every
selection; this pass does not upgrade natural-execution evidence. Bytes and
record extents are unchanged.

The updated exact-prefix census is 63 Data labels in 41 owners, 33 String, 0
Table, 41 Tiles, 24 Tilemap, 4 Attrmap and 25 Palette; exact Function, Font,
and Label remain zero. The Japanese ROM build is `RESULT: IDENTICAL` with SHA
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` passes with 12,168 labels and 51 constants.

# Browser page-list message fragments (2026-10-21)

At `24:4B10`, `PageList_MessageTable` points to four consecutive 45-byte
Shift-JIS message records. Each record consists of five NUL-terminated lines;
the table entries and source extents place the records at `4B18`, `4B45`,
`4B72`, and `4B9F`. Eight neutral `String_24_*` labels marked the continuation
bytes after the first line and before the fifth. They are now named for their
message and structural line range: lines 2–4, or the trailing fifth line.
This is a structural interpretation (**PROBABLE**), not proof that each menu
action is naturally displayed. The byte directives and addresses are
unchanged. At this checkpoint `String_24_42E7` remained neutral: static code
copies it to the page-title buffer, but the text `くーくー` did not establish a
page identity or meaning. A later pass candidate-qualified it as described
below. The eight retired spellings had no other active source consumers.

## Bank 55 keyboard text segments (2026-10-21)

The 39 exact `String_55_AAAA` labels in `data/keyboard/pages.asm` were
declaration-only in the maintained source/tool scan. Their bytes fall within
the page-table-selected T6/T78 Hiragana, Katakana, full-width alphanumeric and
symbol pages. They are now named `String_KbdPage_<page>_<content>` from the
encoded character runs and neighboring NUL/blank separators. The names describe
the visible characters and structural grouping; they do not claim that each
split segment is independently selected or rendered. The 39 definitions group
as T6 Hiragana (7), T6 Katakana (8), T6 full-width alphanumeric (3), T6 symbols
(1), T78 Hiragana (7), T78 Katakana (8), T78 full-width alphanumeric (4), and
T78 symbols (1). Page association comes from the existing page-pointer table;
row boundaries are **PROBABLE** where they rely on NUL/blank separators. No
bytes, directives, page pointers or existing confidence annotations changed.
The empty leading segments are named as blank rows, not as proven padding.

## Small text owners: test image, mail grid and server messages (2026-10-21)

Eight further neutral strings now have content-oriented names. The three
strings inside `Dev_TestConfigImage` identify the literal IPv4-like text,
POP-host text and `NINTENDO TEST` vendor label; they do not prove installer
execution or the full field mapping. `String_MailGrid_SenderAndPlayLabels`
describes the two Japanese strings at `2B:57B5`; there is no demonstrated
reader. `String_MailGrid_CandidateBlankText` describes the six full-width
spaces loaded at `2B:5807`; a natural display role remains uncertain. Three
all-space strings in `2E:53C1`, `5410`, and `545F` are now candidate blank lines
named by their neighboring message groups; the comments retain that their
individual consumption is not proven. The encoded data and boundaries are
unchanged. These changes lower the exact generic `String_BB_AAAA` census by
eight, from 41 to 33.

## Bank 72 dialog text anchors (2026-10-21)

All 32 exact `String_72_AAAA` labels in `data/text/dialog_messages.asm` now
have descriptive names. For 23 labels, a raw word in `Dialog_List1_Browser`
or `Dialog_List2_Mail` points exactly three bytes before the labeled text,
where the three bytes are the `$86` message header. The list index maps to
IDs `0101`, `0105`, `0107`, `010C`, `0111`, `0114`–`0116`, and `0202`, `0205`,
`0208`, `020B`, `020D`, `020F`, `0211`, `0213`, `0217`, `0218`, `021E`, `021F`,
`0221`, `0223`, `022A`. Those labels now use `String_Dialog_Msg<ID>_Text`.
The pointer arithmetic and index-to-ID mapping are **CONFIRMED** from the
source table; interpretation as dialog IDs and natural selection/display stay
**PROBABLE** because runtime coverage does not include every table index.

The other nine labels have no direct pointer-entry-at-minus-three mapping.
They now use `String_Dialog_Candidate*` names based only on the decoded
characters or blank-line structure: phone disconnecting/disconnected text,
the `$F9,$44`-pattern minute text, an exceeded-duration tail, two candidate
blank records, and a no-previous-page message. Those content readings do not
prove a caller or runtime use. Payload bytes, message headers and table words
are unchanged. This removes 32 labels from the exact neutral
`String_BB_AAAA` census.

## Browser candidate page-title string (2026-10-21)

The final exact `String_24_42E7` label is now
`String_Browser_CandidateGooPageTitle`. `Wram6_CopyGooUrlAndTitleToPageBuffers`
at `24:42B0` copies the bytes into `wBrowserPageTitle`, immediately after
copying `Url_GooNeJp` into `wBrowserPageUrl`. The destination relationship and
neighboring URL support the candidate page-title name; entry into the routine
and the meaning of `くーくー` remain unproved. No bytes or addresses changed.
The exact neutral `String_BB_AAAA` count is now zero.

## Mail-title unclassified opcode-shaped bytes (2026-10-21)

Five `Data_2C_AAAA` labels in `engine/mail/mail_title_entry.asm` now use
candidate names based only on their literal byte sequences: four one-byte
`$C9` spans and one `$C3,$72,$49,$C9` span. Existing source headers classify
these as **HYPOTHESIS/UNCLASSIFIED** without code/data evidence. The names say
what the bytes resemble and keep the candidate qualifier; they do not classify
them as executed instructions, functions or padding. No byte or boundary
changed. The exact generic `Data_BB_AAAA` count drops from 63/41 owners to
58/40 owners.

## Address-book name-editor opcode-shaped bytes (2026-10-21)

Four `Data_2F_AAAA` labels in `engine/address_book/name_editor.asm` now use
candidate names based only on literal bytes: three single `$C9` bytes and one
five-byte span beginning with `$C9` and containing a `$C3` absolute-jump opcode.
The source headers classify each as **HYPOTHESIS/UNCLASSIFIED**. The labels do
not claim executed instructions, function boundaries, or padding. No byte or
boundary changed. The exact generic `Data_BB_AAAA` count drops from 58/40
definitions/owners to 54/39.

## Mailbox opcode-shaped spans (2026-10-21)

Three `Data_25_AAAA` labels in `engine/mail/mailbox.asm` now use candidate
names based on bytes: `$C3,$43,$40` (JP-shaped), `$C3,$1E,$41` (JP-shaped),
and `$26,$01,$C3,$00,$40` (LD/JP-shaped). The first two encode targets at
`25:4043` and `25:411E`, but that does not prove entry or execution. Source
headers retain **HYPOTHESIS/UNCLASSIFIED**; names do not claim code, dead code,
padding or runtime behavior. No byte or boundary changed. Exact generic
`Data_BB_AAAA` count drops from 54/39 definitions/owners to 51/38.

## Browser-start mixed data labels (2026-10-21)

Three neutral labels in `gfx/browser/start_choice.asm` now reflect their
existing evidence. `73:4530` is
`BrowserStart_CandidateBgAttributeSuffixAndUnreadTail_4530`: 173 bytes are
confirmed as the suffix of five 5x7 animation frames, while the last three
bytes remain unread and the whole 176-byte span is not promoted. `73:49E0` is
`BrowserStart_CandidateTiles_49E0`; the 1024-byte 2bpp tile interpretation is
heuristic and no consumer was found. `73:5EC0` is
`BrowserStart_ObjAnimScriptTail_5EC0`, the three-byte tail of the preceding
count-2 script; the following frame table and object records keep their own
labels. No bytes or boundaries changed. Exact generic `Data_BB_AAAA` count
drops from 51/38 definitions/owners to 48/37.

## Send/receive opcode-shaped spans (2026-10-21)

Three `Data_27_AAAA` labels in `engine/mail/send_receive.asm` now have
candidate names based on their literal bytes: `$18,$5E` encodes a JR to
`27:40FF`, `$C9` is a return opcode byte, and `$CD,$47,$47,$CA,$E5,$46`
encodes CALL `27:4747` followed by JP Z to `27:46E5`. These addresses align
with existing code labels, but do not prove entry into the spans. The source
headers remain **HYPOTHESIS/UNCLASSIFIED**. No bytes or boundaries changed.
Exact generic `Data_BB_AAAA` count drops from 48/37 definitions/owners to
45/36.

## Settings bank-71 data spans (2026-10-21)

Two neutral labels in `gfx/settings/screens_bank71.asm` now describe their
bounded evidence. `71:723F` is a 50-byte fragment clipped from a PROBABLE
2bpp region, named `Settings_Candidate2bppFragment_723F` to avoid promoting
the fragment to an asset type. Its tile interpretation remains candidate-qualified.
`71:7271` remains content-unknown but is confirmed read as data by executed
code in up to 3 of 18 traced scenarios, now reflected in its label. No
asset-purpose or natural-display claim is added, and no bytes/boundaries
changed. Exact generic `Data_BB_AAAA` count drops from 45/36 definitions/owners
to 43/35.

## Address-editor opcode-shaped spans (2026-10-21)

Two neutral labels in `engine/address_book/address_editor.asm` now use
candidate byte-shape names. `2F:6D3B` contains `$F1,$FE,$01,$28,$1B` (POP AF,
CP `$01`, JR-shaped displacement), and `2F:764C` contains `$C9` (RET opcode).
The code/data headers remain **HYPOTHESIS/UNCLASSIFIED**; no entry or execution
is claimed. No bytes or boundaries changed. Exact generic `Data_BB_AAAA` count
drops from 43/35 definitions/owners to 41/34.

## Address-book dispatcher return-opcode bytes (2026-10-21)

Two `Data_2F_AAAA` labels in `engine/address_book/address_book.asm` now use
candidate names for one-byte `$C9` sequences at `2F:7F3A` and `2F:7F4D`.
Both source headers remain **HYPOTHESIS/UNCLASSIFIED**; no entry or execution
is established. Bytes and boundaries are unchanged. Exact generic
`Data_BB_AAAA` count drops from 41/34 definitions/owners to 39/33.

## Mailbox read-data spans with unknown content (2026-10-21)

Two neutral bank-25 labels now use `Mailbox_ReadData_UnknownContent_*` names.
The source records 265 bytes at `25:6AC8` and 127 bytes at `25:6E71` as data
read by executed code; their content class remains unknown. The separate
`docs/research/boot_and_home.md` analysis bounds both within ROM-to-VRAM
requests and shows the physical 16-byte phases cut transfer units, so neither
span is promoted to an independently aligned tile asset. No bytes/boundaries
changed. Exact generic `Data_BB_AAAA` count drops from 39/33 to 37/32.

## Password-entry variant map pairs in bank 5D (2026-10-21)

`5D:5000–5320` is now named
`Data_AccountPasswordEntry_VariantTilemapAttributePairs`. The account screen
selects one of four pointers from `Account_PasswordEntryMaps` using the
`wPasswordEntry_Variant` value (0–3). Each pointer advances by `$C8` bytes;
the caller sets `B=$05`, `C=$14` and calls `Tilemap_CopyRectAndAttr`, whose
two rectangle copies consume 100 tile bytes and then 100 attribute bytes.
Thus the four 200-byte pairs exactly cover the 800-byte span. The caller list
is confirmed in source, while natural runtime use of every variant and the
visual interpretation of each map are not claimed. The table words now use
the semantic base label and explicit offsets; emitted bytes and data bounds
are unchanged. Exact generic `Data_BB_AAAA` count drops from 37/32 definitions/
owners to 36/32. The earlier decision to keep `Data_5D_5000` neutral records
the evidence available at that historical checkpoint. The sentence retaining
`Data_5D_6C00` is historical and superseded by the named VRAM `$8A00` slice in
`original_closure_followup_20261021.md`.

## Current Japanese data inventory after HelpMenu object reclassification (2026-10-21)

At the post-build source snapshot, `tools/data_consumers.py --stats` reports
128 neutral groups: 34 `Data_`, 41 `Tiles_`, 24 `Tilemap_`, 25 `Palette_` and
4 `Attrmap_`. Its 65 automatic immediate candidates are all rejected and the
rename manifest has zero rows. These are bounded inventory/results, not proof
that the remaining names have no readable structural identity. The source scan
excludes `engine/mail/sample_data.asm`, `languages/`, build products, tools,
docs and `.tmp/`.

The earlier neutral decisions for `Data_6A_6330` and `Data_6A_6448` are
superseded. The 6A:6330–64AE span is now `SpriteFrameTable_HelpMenu`, nine
typed frame records, and `SpriteScript_HelpMenu`; the separate object entry is
symbolically linked across the existing 64B1 source boundary. The false
`palette_6330.pal` asset and its catalogue/rule rows were removed. The full
recorded derivation and byte checks are in
`docs/research/original_closure_followup_20261021.md` and the retained
`.tmp/jp-bank6a-help-object-reclass-20261021/` evidence. At that snapshot,
the inventory had 128 groups, down from 130; the 34 remaining `Data_` groups still require
individual evidence review.

### Current follow-up: bank 2D zero-fill label (2026-10-21)

After the single source-label replacement `Data_2D_5E80` →
`Gfx_MailBody_HDMALoadZeroFill`, `python3 tools/data_consumers.py --stats`
reports 127 neutral groups (33 `Data_`, 41 `Tiles_`, 24 `Tilemap_`, 25
`Palette_`, 4 `Attrmap_`), with all 65 immediate candidates rejected and no
rename-manifest rows. This is the verified current count; the preceding
128/34 count above describes its earlier bank-6A snapshot. The label records
only the confirmed zero-fill transfer role, not use of the resulting VRAM
tiles. Evidence and boundaries are in
`docs/research/mail_gfx_resource_aliases.md`.


## Bank 6B non-CGB mixed-span correction (2026-10-21)

`Data_6B_4060` was split by its actual consumer boundary. The first 480 bytes
are copied by `NonCgb_ErrorScreen` as the continuation of the `$0240`-byte BG
tilemap starting at `6B:4000`; the remaining 576 bytes through `6B:4480` are
retained as a HYPOTHESIS tile-data candidate because no reader was found and
the loader copy ends at `6B:4240`. This retires one exact `Data_BB_AAAA` name
without promoting the tail to a confirmed asset or unused region. See
`original_closure_followup_20261021.md` for extents and hashes. The maintained-source exact-name count is now 19 `Data_BB_AAAA` definitions; the current neutral-data tool reports 113 groups (38 candidates rejected, no proposals).


## Final exact-address Data-name audit (2026-10-21)

A fresh source census after commit `ca494a48` found 16 exact
`Data_BB_AAAA` definitions in the maintained Japanese assembly, zero exact
`Function_BB_AAAA`, `Label_BB_AAAA` or `Font_BB_AAAA` definitions, and no
automatic rename rows from `tools/data_consumers.py --stats` (110 neutral
data groups; all 37 immediate candidates rejected). Each remaining exact
`Data_` label was inspected in its local source context. The names below stay
neutral because the available bytes or reads do not establish a defensible
content class, natural code entry, or semantic consumer; this is an explicit
unresolved inventory, not a claim that no indirect use exists.

| Label | Bounded evidence | Disposition |
| --- | --- | --- |
| `Data_1C_401C` | One `RET` between the title dispatch tail and the next branch; no entry established. | HYPOTHESIS; keep neutral. |
| `Data_23_46CC` | One `RET` at a split boundary before the confirmed delete-menu selection routine; no entry established. | HYPOTHESIS; keep neutral. |
| `Data_24_4BCC` | One `RET` after a confirmed Japanese text continuation and before the action-menu routine; no entry established. | HYPOTHESIS; keep neutral. |
| `Data_24_6520` | Sixteen bytes repeat two pointer-shaped words four times, but targets are inside tile data and do not form the adjacent object table. | HYPOTHESIS; keep neutral. |
| `Data_26_5062` | Five bytes decode linearly as two loads followed by `RET`; no caller, table or far pointer is known. | HYPOTHESIS; keep neutral. |
| `Data_26_7AB0` | At the 522ae8ef census, twelve zero bytes were confirmed read but their class was unknown. Superseded by the bank26 transfer-tail follow-up below. | Renamed to `Profile_InitScreen_HDMALoadZeroTail`; the full 16-byte extent has a confirmed transfer role, with display unproved. |
| `Data_2F_4094` | `C3 00 40` decodes as `JP AbookList_Run`, but the preceding routine jumps away and no incoming edge to this span is known. | HYPOTHESIS; code versus unused stub unresolved. |
| `Data_48_69AB` | Thirty-two zeros have a conditional read path; the reader's fallback/glyph role remains unproved. | CONFIRMED read as data; content class unknown. |
| `Data_4B_5400` | Thirty-two bytes are read as data in a finite subset of scenarios; no exact consumer or content class is established. | CONFIRMED read as data; content class unknown. |
| `Data_4E_5390` | One `POP BC` lies between two branches that skip it; no branch to this address is known. | HYPOTHESIS; keep neutral. |
| `Data_5F_6980` | Forty-eight `$06` bytes precede a confirmed resource. The only raw candidate is `HL=$6998` at `68:7A34`; `A=$71` before `Tilemap_CopyRectAndAttr` selects `71:6998`, so it is not a bank-5F read. | HYPOTHESIS; purpose unknown. |
| `Data_72_63D7` | One `XOR A` follows a string terminator; the adjacent far-call target begins at 63D8. | HYPOTHESIS; keep neutral. |
| `Data_72_6711` | One `XOR A` follows a `RET` and precedes a confirmed routine entry; no entry to 6711 is known. | HYPOTHESIS; keep neutral. |
| `Data_75_6D62` | One `RET` between Mobile SDK state-handler blocks; no caller or pointer is known. | HYPOTHESIS; keep neutral. |
| `Data_7F_4C77` | One `RET` follows a confirmed-read dotted-line buffer; no caller or pointer is known. | HYPOTHESIS; keep neutral. |
| `Data_7F_51ED` | One `RET` follows an unconditional jump in the page-list prototype; no entry is known. | HYPOTHESIS; keep neutral. |

The per-area reports remain the detailed evidence: `main_title_dispatch_tail_20261021.md`,
`generic_data_name_audit_20261020.md` (individual follow-ups),
`font_reader_69ab_bounds_20261020.md`, `bank4b_result_page_indexed_tiles_20261021.md`,
`original_closure_followup_20261021.md`, and `page_list_prototype_aliases_20261021.md`.
A fresh grep also found no remaining `gfx/bankNN` directory names. The
four unresolved natural-entry roots (2B:6CF5, 2D:4E42/4E54 and 29:511E)
remain separately open; their operation aliases describe bounded local
mechanics, not proven callers or natural entry. This census predates the
superseding bank26 follow-up below: the current exact-address `Data_BB_AAAA`
count is 15 after renaming the 16-byte HDMA tail. The 110 groups reported by
`data_consumers.py` are a separate analyzer count and remain unchanged. English
remains paused.


## Bank 26 Profile_InitScreen zero-tail (2026-10-21)

Data_26_7AB0 is now Profile_InitScreen_HDMALoadZeroTail. The 12-byte
CONFIRMED-read zero span at 26:7AB0–7ABC and the following four zero bytes at
7ABC–7AC0 are one 16-byte unit: Profile_InitScreen requests 0x2A blocks
(672 bytes) from bank 26 source 7820 to VRAM bank 0 at 8000, ending at source
7AC0 and destination 82A0. The span begins 0x290 bytes into that request, so
it maps to VRAM 8290–82A0, exactly one aligned 2bpp tile-sized unit, and every
bit is zero. This confirms its transfer-tail role and exact bytes, but not
whether the tilemap selects it or it is displayed. The original slice at file
offset 0x9BAB0 is 16 zero bytes, SHA-256
374708fff7719dd5979ec875d56cd2286f6d3cf7ec317a3b25632aab28ec37bb.
The earlier bank26 KEEP-neutral decision remains historical provenance and is
superseded only for this bounded transfer-tail name; no sprite/OAM attribution
or independent PNG/asset claim is made.

## Fresh neutral-data inventory at Japanese main 7c596ead (2026-10-22)

After `make` refreshed `build/mobile_trainer.sym`, `tools/data_consumers.py`
reported 15 neutral data groups, one candidate site, one rejected site, and
zero rename-manifest rows. The retained per-group inventory is
`.tmp/jp-data-label-census-20261022/INVENTORY.tsv` (SHA-256
`9122991c02f7a31c4ee02e542c72441779100b37b638b78c2b17d45d0a473b7c`); the
empty manifest is `MANIFEST.tsv` (SHA-256
`1a5e0a79621043b8f81cfe9e0e31dbd8b2e0322a582f9aee1a472a0b8db0f605`). Its
only listed site targets `Data_5F_6980` from
`Registration_DeleteConfirm_Setup+7C`, rejected as a generic immediate; the
source comment already records that A=`$71` selects bank71 at `$6998`, not
bank5F. No new consumer or semantic evidence supports renaming any of the 15
remaining exact labels. Keep their bounded dispositions above; this scanner
does not rule out computed or otherwise unmodeled access.

## Stale gfx catalog label reconciled at 73:49E0 (2026-10-22)

The Japanese assembly owner already defined `BrowserStart_CandidateTiles_49E0`
for the PROBABLE tile-like span, while `gfx/assets.tsv` still named that row
`Data_73_49E0`. The catalog now points to the existing source label, and its
backing/PNG paths are `gfx/browser/start_choice/browser_start_candidate_tiles`
with `.2bpp` and `.png` extensions. No source label, extent, confidence or
bytes changed; this corrects catalogue metadata and removes an address-only
resource basename without asserting natural use or a complete screen.
