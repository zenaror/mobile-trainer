# Japanese ROM status

The maintained RGBDS source rebuilds the 2 MiB **Mobile Trainer (Japan)** ROM byte for byte. The verified ROM SHA-256 is:

```text
6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570
```

The Japanese disassembly milestone is estimated at **99.9%**. This describes the current reverse-engineering assessment; it is not a claim that every routine or data item has a fully established meaning.

Some code and data still have limited semantic evidence. In particular, absence from observed execution does not prove global non-use, and byte-identical reconstruction does not prove that every symbol name or interpretation is correct. Source comments use `CONFIRMED`, `PROBABLE` and `HYPOTHESIS` to distinguish confidence.

See the [documentation index](docs/README.md) for build instructions and public technical references.
