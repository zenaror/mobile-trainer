# Japanese sprite and data naming follow-up

## Save Sender Address animation data

The table at `2A:5220` is also unchanged.

## Bank 4B second-banner tile slice

The second banner descriptor list at `68:7840` and its caller select source `4B:5370`; a 640-byte transfer maps `4B:5370–55F0` to VRAM1 `$9280–$9500`.

Thus `4B:5400–5420` is statically included at VRAM1 `$9310–$9330`, exactly two 2bpp tiles.

The false `Data_5F_6980` candidate remains rejected because the nearby loader selects bank `$71`, not `$5F`.

The Save Sender review checked the exact ROM-backed range `2A:5220–5495`, pointer spans, and bounded engine readers; no source bytes or section boundaries were changed.

The independently reviewed spans were `Data_1C_401C`, `Data_23_46CC`, `Data_24_4BCC`, `Data_24_6520`, `Data_26_5062`, `Data_2F_4094`, `Data_4E_5390`, `Data_48_69AB`, `Data_5F_6980`, `Data_72_63D7`, `Data_72_6711`, `Data_75_6D62`, `Data_7F_4C77`, and `Data_7F_51ED`. Byte decodes such as `RET`, `XOR A`, `POP BC`, or `JP AbookList_Run` are not by themselves evidence of entry or intended purpose. Bounded scans found no literal source references that establish incoming use; calculated references, copied bytes, or an unmodeled bank/stack path remain possible and are not ruled out.

One additional structural observation concerns `Data_24_6520`: its 16 bytes are byte-for-byte equal to the first 16-byte record of `PageListProto_ObjTable` at `7F:6DB0`.

A unique masked cross-version code match also locates `Data_75_6D62` at offset +$19 of the Crystal SDK local `.asm_112d4c` block.

The new label describes a statically selected reader source outside the declared `Font_GlyphRun_83BF` `INCBIN`; the stored bytes' original identity and intent remain unknown.
