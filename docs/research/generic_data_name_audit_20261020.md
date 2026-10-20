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
