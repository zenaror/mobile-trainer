# Bank 29 palette sequence names (2026-10-23)

## Scope and evidence

This is a Japanese-source follow-up to the closed cross-category generic-name census at
b908b3b8bf63a27a1dafa5cbbe57e3baa8e1444c. It records four previously unlabeled,
RET-delimited code sequences in engine/gfx/palette_library_candidate.asm. The names describe
their **PROBABLE decoded local operations**. No natural entry, external caller, library ABI,
intended purpose, or execution is established; the candidate owner remains qualified as candidate.

The immutable original is Mobile Trainer (Japan).gbc, SHA-256
6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570. Bank 29 is mapped to
file offset 0xA4000 + (CPU address - 0x4000). Direct original-ROM slices:

| CPU interval, end exclusive | Bytes | SHA-256 | New label |
|---|---:|---|---|
| 29:5159–517D | 36 | f1dd631377c812515c4382bbd073a6a06d1d92831803a43a06470bcc43247b26 | PalLibCandidate_FadeCurrentPalettesTowardBlack |
| 29:517D–51B3 | 54 | 0623c0ac0f382b339ad91dc711d0b9d886757448960d6f23ee981cf792cfe458 | PalLibCandidate_FadePaletteBlockTowardBlackThenReload |
| 29:51B3–51D7 | 36 | 52c927a8b39be6d8a6b7e8a399e3a7ab22c96cec9e9c045d0bc8330a5721c439 | PalLibCandidate_FadeCurrentPalettesTowardWhite |
| 29:51D7–520D | 54 | 1c0edc9585fc272f102fcf17c3c0ae9d07c0b1b2967a0a5ece3d3ae55bbb4cf4 | PalLibCandidate_FadePaletteBlockTowardWhiteThenReload |

Each sequence saves/restores SVBK and calls existing candidate helpers. The 36-byte variants repeatedly read
current BG/OBJ palettes, apply eight steps toward the named endpoint per round, and write the buffer for
four rounds. The 54-byte variants copy a block from HL into the buffer, apply four-by-eight steps, and
write each round; after the loop they copy and write the source block once more without fading. This last
reload is retained in the two names because omitting it would misdescribe the decoded operation. Exact
buffer source/bank contracts remain unknown.

The new globals re-scope the existing local branch labels to their actual sequences (.l515E/.l5167,
.l5182/.l518B/.l518D, .l51B8/.l51C1, .l51DC/.l51E5/.l51E7). Instruction bytes and transfer
targets must remain unchanged. The source edit is a semantic naming/comment change only; the required
byte-identity build and symbol checks are recorded by the checkpoint commit and OMM handoff.
