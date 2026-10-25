# Japanese disassembly status

The Japanese reconstruction was accepted at **99.9%** on 2026-10-25, with the
remaining semantic unknowns documented. This is an agreed project status,
not a measured percentage of understood instructions.

The maintained RGBDS source reconstructs the original 2,097,152-byte ROM:

```text
SHA-256 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570
```

## Accepted delivery

- Byte-identical Japanese ROM, maintained Assembly and editable graphics.
- Completed finite symbol, path, frame and asset inventories.
- Build, symbol, palette, PNG and tool-test checks passed at acceptance.
- Confidence levels and original bytes retained for unresolved material.

## Known limits

Some candidate routines have no demonstrated natural entry, Bank53 names have
no established executable link to frame selection, and the Bank23 panels have
no identified natural reader. Eight graphics compositions and other small
code/data questions retain their documented limits. Absence of observed use
is not proof of global non-use.

These are accepted uncertainties. Further Japanese investigation requires a
specific new input, contradiction or requested scope. English translation
remains paused until separately authorized.

## Reference documents

- [Accepted closure and final checks](docs/research/japanese_closure_audit_20261023.md#accepted-japanese-closure-2026-10-25)
- [Semantic contracts](docs/research/japanese_semantic_roots_and_destinations_20261025.md)
- [Residual evidence register](docs/research/japanese_remaining_semantics_batch_20261024.md)
- [Dated delivery evidence](docs/research/japanese_delivery_history.md)
- [Development and validation reference](docs/DEVELOPMENT.md)
