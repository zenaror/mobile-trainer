# Japanese reconstruction

The maintained RGBDS source reconstructs the 2,097,152-byte Japanese ROM:

```text
SHA-256 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570
```

Run `make` to build and check the hash. With the reference ROM present,
`make compare` also compares every byte. `make sym-check` validates source
labels against the linker map, `make palette-check` checks palette definitions,
and `make png-check` checks editable graphics.

The bank layout, decoded routines, data tables, strings and graphic resources
are represented in the maintained source. Confidence labels qualify uncertain
names and interpretations. Byte identity does not establish a natural caller,
original purpose, hardware behavior or global non-use.

[Known interpretation limits](japanese_remaining_semantics_batch_20261024.md)
list the unresolved regions. [Candidate routine contracts](japanese_semantic_roots_and_destinations_20261025.md)
describe their local behavior and required bank/stack conditions.
