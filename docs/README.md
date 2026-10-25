# Mobile Trainer documentation

The Japanese source reconstructs the original Game Boy Color ROM byte for byte.
Addresses use `bank:CPU-address` notation. `CONFIRMED`, `PROBABLE` and
`HYPOTHESIS` distinguish established behavior from interpretations.

## ROM reference

- [ROM identification](ROM_INFO.md)
- [Bank organization](research/bank_survey.md)
- [Boot, interrupts and ROM0 services](research/boot_and_home.md)
- [RAM and mapper state](research/ram_map.md)
- [SRAM records and checksums](research/sram_layout.md)
- [Mobile Adapter protocol](research/mobile_protocol.md)
- [Trainer serial implementation](research/mobile_trainer_serial.md)
- [Text, fonts and character encoding](research/text_encoding.md)
- [Sprite records and animation scripts](research/sprite_format.md)
- [Audio records and commands](research/audio_format.md)
- [Images and text stored in graphics](research/image_text_inventory.md)
- [Frame selection and Pokémon names](research/assets_pokemon_frames_and_name_limits.md)
- [Candidate routine contracts](research/japanese_semantic_roots_and_destinations_20261025.md)
- [Known interpretation limits](research/japanese_remaining_semantics_batch_20261024.md)

## Building and editing

- [Installation](../INSTALL.md)
- [Build targets, validation and source layout](DEVELOPMENT.md)
- [Assembly conventions](../STYLE.md)
- [Editing images](EDITING_IMAGES.md)
- [Editing text and language resources](TRANSLATION.md)
- [Language build interface](LANGUAGE_BUILDS.md)
- [Graphics catalogue](../gfx/README.md)

## Analysis tools

- [Control-flow mapping](research/code_map.md)
- [Tracer interface](research/dynamic_tracing.md)
- [Ghidra interface](research/ghidra.md)
- [Bootstrap table formats](FORMATS.md)

The maintained source lives in `home/`, `engine/`, `lib/`, `data/`, `gfx/`,
`audio/` and `ram/`. `layout.link` fixes each section's ROM position. The
bootstrap `config/` tables are historical and are not regenerated during a build.
