# Japanese disassembly status

The Japanese disassembly milestone is **99.9%**, with the interpretation limits
below retained. The maintained source reconstructs the original 2,097,152-byte ROM:

```text
SHA-256 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570
```

## Source coverage

The source contains the ROM's bank layout, instructions, data, text, graphics,
fonts, audio and RAM definitions. Build and source checks are documented in
[the development reference](docs/DEVELOPMENT.md).

## Interpretation limits

Some candidate routines have no demonstrated natural entry. Bank53 names have
no established executable link to frame selection, and the Bank23 panels have
no identified natural reader. Eight graphics compositions and other small
code/data questions retain their documented limits. Absence of observed use
is not proof of global non-use. Byte identity does not prove every semantic name.

- [ROM reconstruction](docs/research/japanese_closure_audit_20261023.md)
- [Candidate routine contracts](docs/research/japanese_semantic_roots_and_destinations_20261025.md)
- [Known interpretation limits](docs/research/japanese_remaining_semantics_batch_20261024.md)
- [Frame and Pokémon-name resources](docs/research/assets_pokemon_frames_and_name_limits.md)
- [Documentation index](docs/README.md)
