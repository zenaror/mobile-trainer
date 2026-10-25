# Known interpretation limits

The ROM reconstruction is byte-identical. That establishes the stored bytes,
not the purpose or reachability of every region.

| Area | Established behavior | Unresolved interpretation |
|---|---|---|
| `2B:6CF5` | Copies recorded sender fields and runs reply editors | Natural caller and four-word stack unwind |
| `2D:4E42/4E54` | Selects WRAM1 and locates two-byte text cells | Natural caller and saved-BC early-return convention |
| `29:511E` | Conditional graphics/wait helper | Entry and returning callee at CPU `$7BB7` in the required bank state |
| `70:4740` | SRAM1 state-bit query | Natural caller and intended state-field meaning |
| `26:5344–537C` | Repeated VRAM1/WRAM7 writes | Entry and required stack/bank state |
| `28:4BA6–4BC2` | Clears WRAM0 and fills part of WRAM7 | Entry and intended initialization role |
| `53:4000–4170` | 25 Pokémon-name pointers and strings | Executable link from a name ordinal to frame selection |
| `23:7C03–7F30` | Four probable mail-status panels after 13 zero bytes | Natural reader and selector |
| Partial graphics compositions | Backing bytes and editable resources are retained | Complete placement/consumer contracts for eight compositions |
| Other small fragments and padding | Local operations or byte structure are described | Natural use or original purpose in the cases marked uncertain |

These rows overlap and are not a count of missing functions. A nearby `RET`,
a missing direct caller or absence from an observed path does not establish
that a resource is globally unused. Arbitrary inputs, altered bank state and
computed transfers require their own contracts.

See [candidate routines](japanese_semantic_roots_and_destinations_20261025.md)
and [frame/name resources](assets_pokemon_frames_and_name_limits.md).
