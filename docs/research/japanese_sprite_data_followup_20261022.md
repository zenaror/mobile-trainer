# Japanese sprite and data naming follow-up (2026-10-22)

This pass continues the Japanese-only naming audit. The English translation remains paused.

## Save Sender Address animation data

In `gfx/address_book/save_sender_address.asm`, 33 address-suffixed frame-table, frame, and script labels between `2A:5290` and `2A:5495` were renamed by structural groups of four repeated entries in the 28-entry table at `2A:5220`: indices 0–3, 4–7, 8–11, 12–15, 16–19, 20–23, and 24–27. Table-entry indices are used as grouping keys, not runtime sprite IDs. The entry layout is confirmed by `Sprite_InitSlot`/`Sprite_LoadObjectEntry`: the index is masked to 7 bits, shifted into a four-byte entry offset, and the two pointers are copied into slot fields.

Frame tables and their pointer targets are `PROBABLE` under the existing structural reader contract; script semantic interpretation remains `HYPOTHESIS`. The names use `SaveSenderAddrCandidate_` because this audit found no symbolic consumer of this block in the bounded readers examined. The independent review found no natural-use, visible-screen, animation-meaning, or unreachable-frame proof. The orphan three-byte script at `2A:545C` remains separately named `SpriteScriptCandidate_2A_545C`; it is not one of the 33 renamed symbols. The table at `2A:5220` is also unchanged. The rename changes symbols and comments only; it does not change byte extents.

## Bank 4B second-banner tile slice

`Data_4B_5400` is now `Gfx_Account_ResultPage_SecondBanner1_Tiles9310Vb1`. The second banner descriptor list at `68:7840` and its caller select source `4B:5370`; a 640-byte transfer maps `4B:5370–55F0` to VRAM1 `$9280–$9500`. Thus `4B:5400–5420` is statically included at VRAM1 `$9310–$9330`, exactly two 2bpp tiles. This is `CONFIRMED` as a static transfer association only. The prior claim of no source/transfer consumer is superseded for this interval. No natural execution or visual interpretation is claimed.

## Remaining reviewed neutral data

The bounded audit of 15 address-only data spans supported renaming only `Data_4B_5400` at that checkpoint. Fourteen then remained neutral because their isolated bytes or unsupported candidate formats did not establish identity or role. A later independent boundary review structurally renamed `Data_48_69AB` to `FontReader_OutOfRunSource_48_69AB`; the source relationship is now named, while content identity and intent remain unknown. The false `Data_5F_6980` candidate remains rejected because the nearby loader selects bank `$71`, not `$5F`.

## Verification basis and limits

The Save Sender review checked the exact ROM-backed range `2A:5220–5495`, pointer spans, and bounded engine readers; no source bytes or section boundaries were changed. The Bank 4B conclusion follows the ROM-backed descriptor list and shared helper contract. These static findings do not substitute for a runtime trace.

## Independent review of the remaining 14 address-form data labels

Two independent read-only reviewers examined disjoint sets of seven labels against private copies of Japanese `main` at `bff2a223c21015351c893c1092a807a17e74bd9f`. Both copies used the immutable ROM with SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Neither reviewer changed source, ran a build, nor opened English/ZIP material. Their conclusion agrees: retain all 14 labels as neutral because the available evidence does not establish a stronger semantic identity or a safe alias to retire.

The independently reviewed spans were `Data_1C_401C`, `Data_23_46CC`, `Data_24_4BCC`, `Data_24_6520`, `Data_26_5062`, `Data_2F_4094`, `Data_4E_5390`, `Data_48_69AB`, `Data_5F_6980`, `Data_72_63D7`, `Data_72_6711`, `Data_75_6D62`, `Data_7F_4C77`, and `Data_7F_51ED`. Byte decodes such as `RET`, `XOR A`, `POP BC`, or `JP AbookList_Run` are not by themselves evidence of entry or intended purpose. Bounded scans found no literal source references that establish incoming use; calculated references, copied bytes, or an unmodeled bank/stack path remain possible and are not ruled out.

One additional structural observation concerns `Data_24_6520`: its 16 bytes are byte-for-byte equal to the first 16-byte record of `PageListProto_ObjTable` at `7F:6DB0`. This equality is confirmed, but the reason for the duplicate and any relationship between the two banks remain hypotheses; no bank-`24` consumer was found. It did not justify a semantic-type rename or an unused claim. The reviewed configuration snapshot also contains a stale far-call location for the bank-72 menu entry: `4E:4D16` is the call site; `4E:4D10` lies inside the prior CALL operand. Frozen generated configuration was not edited.

### Follow-up at `ae6b9ccef65207421f832ff856afe1659ece9865`

The later all-13-label audit confirmed that the first relationship is a
byte-for-byte match and found the same kind of exact content relation for
`Data_26_5062`: its five bytes equal the tail of `MailSession_Cancel` at
`26:505D–5062`, and that full sequence occurs only at those two ROM
locations. A unique masked cross-version code match also locates
`Data_75_6D62` at offset +$19 of the Crystal SDK local
`.asm_112d4c` block. The source labels now name these correspondences only:
`ByteMatch_PageListProto_ObjTableFirstRow_24_6520` and
`ByteMatch_MailSessionCancelTail_26_5062` and
`MaskedMatch_CrystalSDK_Local112D4C_75_6D62`. The type/use of each interval
and the cause of each match remain **HYPOTHESIS**. The other ten
`Data_BB_AAAA` labels remain neutral because the combined source, xref,
far-call, coverage, and 72 data-access-report cross-checks supplied no stronger
names. See [generic_data_name_followup_20261023.md](generic_data_name_followup_20261023.md)
for the per-label matrix and scan limits.

The checks were static and ROM-byte-based. The reviewers' negative reference scans do not prove global non-use; no runtime trace, newly built ROM, natural-use, or hardware evidence was produced by this review. The source-level outcome is documentation only and does not alter ROM bytes or source data extents.

### Follow-up: bank 48 reader-source boundary (2026-10-22)

The earlier all-neutral recommendation for `Data_48_69AB` is superseded by the
independent bounded review in
[`font_reader_69ab_bounds_20261020.md`](font_reader_69ab_bounds_20261020.md#structural-name-correction-2026-10-22).
The new label describes a statically selected reader source outside the
declared `Font_GlyphRun_83BF` `INCBIN`; the stored bytes' original identity and
intent remain unknown. No natural execution, output, or hardware claim was
added.
