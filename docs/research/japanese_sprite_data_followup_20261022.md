# Japanese sprite and data naming follow-up (2026-10-22)

This pass continues the Japanese-only naming audit. The English translation remains paused.

## Save Sender Address animation data

In `gfx/address_book/save_sender_address.asm`, 33 address-suffixed frame-table, frame, and script labels between `2A:5290` and `2A:5495` were renamed by structural groups of four repeated entries in the 28-entry table at `2A:5220`: indices 0–3, 4–7, 8–11, 12–15, 16–19, 20–23, and 24–27. Table-entry indices are used as grouping keys, not runtime sprite IDs. The entry layout is confirmed by `Sprite_InitSlot`/`Sprite_LoadObjectEntry`: the index is masked to 7 bits, shifted into a four-byte entry offset, and the two pointers are copied into slot fields.

Frame tables and their pointer targets are `PROBABLE` under the existing structural reader contract; script semantic interpretation remains `HYPOTHESIS`. The names use `SaveSenderAddrCandidate_` because this audit found no symbolic consumer of this block in the bounded readers examined. The independent review found no natural-use, visible-screen, animation-meaning, or unreachable-frame proof. The orphan three-byte script at `2A:545C` remains separately named `SpriteScriptCandidate_2A_545C`; it is not one of the 33 renamed symbols. The table at `2A:5220` is also unchanged. The rename changes symbols and comments only; it does not change byte extents.

## Bank 4B second-banner tile slice

`Data_4B_5400` is now `Gfx_Account_ResultPage_SecondBanner1_Tiles9310Vb1`. The second banner descriptor list at `68:7840` and its caller select source `4B:5370`; a 640-byte transfer maps `4B:5370–55F0` to VRAM1 `$9280–$9500`. Thus `4B:5400–5420` is statically included at VRAM1 `$9310–$9330`, exactly two 2bpp tiles. This is `CONFIRMED` as a static transfer association only. The prior claim of no source/transfer consumer is superseded for this interval. No natural execution or visual interpretation is claimed.

## Remaining reviewed neutral data

The bounded audit of 15 address-only data spans supports renaming only `Data_4B_5400`. Fourteen remain neutral because their isolated bytes or unsupported candidate formats do not establish identity or role. In particular, `Data_48_69AB` is a confirmed font-reader target but its semantic identity is unknown. The false `Data_5F_6980` candidate remains rejected because the nearby loader selects bank `$71`, not `$5F`.

## Verification basis and limits

The Save Sender review checked the exact ROM-backed range `2A:5220–5495`, pointer spans, and bounded engine readers; no source bytes or section boundaries were changed. The Bank 4B conclusion follows the ROM-backed descriptor list and shared helper contract. These static findings do not substitute for a runtime trace.
