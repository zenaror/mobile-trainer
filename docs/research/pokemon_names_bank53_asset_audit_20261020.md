# Bank53 names and Pokémon frame assets: current audit (2026-10-20)

## Fresh checkpoint (2026-10-21)

A new read-only audit used an authenticated 577-file private snapshot of
Japanese commit `086bed07d3b6fefbe51ab92dcdae5a4e0cbd941b` and the original ROM
(SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`).
It reconfirmed the 369-byte name block, 25 selected physical windows / 85,200
bytes, 137 active bank41–47 assets, 53 exact tile/raw PNG inversions, 17
conditional editing views and 24 legacy candidate previews. Within the bounded
208-file resource directories, no referenced file or asset/PNG is missing or
orphaned.

The fresh U160 placement audit records the unresolved key counts for all eight
KEEP windows: 41:5AA0 has 216 unprovided cells (`0:00`); 41:67F0 has 216
(`0:42`); 42:5AA0 has 246 (`0:3C`×30, `1:E7`×216) plus 38 cross-boundary
backing gaps; 43:4D50 and 43:67F0 each have 216 (`0:00`); 44:4D50 has 246
(`0:2F`×30, `0:17`×216); 45:4D50 has 216 (`0:00`); 46:67F0 has 246
(`0:00`). Re-exporting represented tiles cannot fill missing reaching-VRAM
state. All 25 name/frame associations remain unproved. A bounded scan of 331
maintained ASM files (excluding the protected sample-data file) found the 51
name-symbol rows only in the bank53 owner; this is not a whole-program reader
absence proof.

The sealed private report is
`.tmp/agent-bank53-current-audit-20261021/REPORT.md` (SHA-256
`edddcd1a310ac0d4c9f028feffd1239e922567abc18089a474a9b7ac227b37c0`), with
`RESULT.json` SHA-256
`39a9c58444ba3237b083f8375c33f16cbc77521439117ec9c8234e0783788e2b` and
`SUPPLEMENT.json` SHA-256
`de38af8f8475d42631236ac9e303e5821f968866f3c02cc190df06a143e2bfd4`. No
source or asset edit is justified by this audit.

This read-only audit checked the source at Japanese `main` `fd70bc464b36dc982ae47775c87946c5bf789106`, with ROM SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. It refreshed the finite bank53, frame-window, PNG and asset-catalogue inventory. The source-only name changes at the end of this note do not alter those asset bytes.

## Reconciliation to current main (2026-10-21)

The sealed 577-path snapshot above is based on `086bed07d3b6fefbe51ab92dcdae5a4e0cbd941b`. At `main` source state `c2b33d2f8de865da52ab877fa25005fec55de559`, all 549 unchanged tracked inputs retain the exact Git blob IDs from that snapshot. The other 27 tracked inputs are ASM owners; after excluding comments, blank lines and global label definitions, their assembler/directive line sequences are identical to the snapshot. No PNG or binary asset path changed. The later `4a38c8b8f1cbba089894240ceeb8399e47e87244` checkpoint changes documentation only. The ROM itself is intentionally untracked, and its current SHA-256 is still `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.

This reconciles the finite asset inventory to current main: it still finds no
missing referenced file or orphan PNG/binary in the reviewed 208-file scope.
It does not complete the eight KEEP screen compositions or establish any of
the 25 Pokémon-name/frame associations, a universal reader search, natural
selection or global unused status. Reconciliation counts and changed paths are
preserved in `.tmp/root-bank53-head-reconcile-20261021/RESULT.json`.

## Bank53 name block

`53:4000..4171` re-emits exactly 369 original bytes: 25 little-endian local pointers (50 bytes) followed by 25 Shift-JIS/NUL strings (319 bytes). Original spacing and the full-width final digit are preserved. The current source calls the pointer table `Table_PokemonNamePointers`; its 25 targets remain `PokemonName00` through `PokemonName24`. These names identify string order and content only. No reader of the table or bank53 name-to-frame association was established.

## Frame and image inventory

The bounded bank41–47 catalogue has 137 assets (49 tile, 28 palette, 28 tilemap, 28 attribute-map and four raw-byte backings), all re-emitting their declared original-ROM bytes. Across the expanded asset scope, 53 tile/raw PNGs have exact PNG-to-binary inverses, excluding only their declared sheet padding. Seventeen editing views reproduce 391,680 pixel indices under their recorded conditional placement model. This does not establish natural loading or display.

The eight windows without a complete editable screen row are `41:5AA0`, `41:67F0`, `42:5AA0`, `43:4D50`, `43:67F0`, `44:4D50`, `45:4D50` and `46:67F0`. Their original bytes, component sheets and legacy previews exist; they remain KEEP because the evidence lacks complete justified VRAM placement and reversible backing. Twenty-four legacy previews passed CRC, PNG-structure and 160×144 dimension checks. The pass did not reproduce their old RGB model.

The bounded directories contain 208 files, including 71 PNGs. Every binary belongs to an active catalogue row, and every PNG belongs to a current PNG rule or screen row; no missing referenced file, orphan binary or orphan PNG was found. The 27 selector words choose five 31-byte descriptors. Their far fields select bank47 resource families `4100`, `4E50` and `5BA0`; no field selects a bank53 name ordinal. The counts and ordering do not prove a name/image bijection.

## Names and limits

The generic table label `Table_53_4000` is now `Table_PokemonNamePointers`. The redundant co-located `String_53_4032` alias was removed; `PokemonName00` already marks the first string. The source search found no operands using either old name. The existing PROBABLE storage classifications remain. No bytes, frame assignments, runtime claims or hardware claims changed.

The independent receipt and complete private snapshot are retained in `.tmp/bank53-asset-audit-20261020/`. `SEALED_RECEIPT.json` SHA-256 is `6847cc10f87612df2579747d019cbd765e137c31453c377fbb736fada568355f`; `REPORT.md` SHA-256 is `6527d83a72db278574c2601bf1c4f45b1da8c47b2868294c73bcd0802d4f2620`. The selected inputs were rehashed against the audited checkout. Unproved name/image associations, natural selection, universal reader absence and global unused status remain open.
