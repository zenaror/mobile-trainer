# Bank 29 bounded operation labels (2026-10-23)

## Scope and evidence

This Japanese-only pass adds operation names at twelve previously unlabelled
instruction boundaries in the candidate library section
`engine/gfx/palette_library_candidate.asm`. It does not claim that the entries
are naturally called, that the entire region is a live palette library, or
that the names identify intended application purpose. The `PalLibCandidate_`
prefix retains the section's existing uncertainty. `CONFIRMED` below applies
only to the literal operation decoded from the immutable ROM bytes; entry,
caller, and broader role remain unproved unless stated otherwise.

The reference ROM is 2,097,152 bytes with SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
Physical bank `0x29` maps to offset `0xA4000 + (address - 0x4000)`. The
following half-open byte ranges were sliced from that ROM and decoded with the
repository's `tools/sm83.py`; the reported hashes pin the original bytes.
Adding labels and comments leaves each slice unchanged.

| CPU range | Bytes | SHA-256 | Added operation label | Directly decoded effect |
|---|---:|---|---|---|
| `29:5097–509E` | 7 | `825f6289bbe01683bc188e0a35b08f119bdc709f8a9f341094b64a682ca06f52` | `PalLibCandidate_SetLcdcBit2` | Set LCDC bit 2 and return. |
| `29:509E–50B6` | 24 | `46768fdd2f4cdfdc55ba1b7d58707191e7d49de42de1809534f9dc74072cc8f3` | `PalLibCandidate_ClearLcdcBit2AndCopyOffsetRecordsUntilFF` | Clear LCDC bit 2; copy four-byte records from HL to the address beginning at `$C000+C`; add D/E to each record's first/second bytes; stop when a record's first source byte is `$FF`. |
| `29:50B6–50C7` | 17 | `8117e1ba06cb4af563484732569c54438c05729758f97cc85ca1524bab9f1ff0` | `PalLibCandidate_ClearShadowOam160BytesAndReturnSavedBCInDE` | Zero 160 bytes at `wShadowOAM`; restore AF and HL; pop saved entry BC into DE. |
| `29:50C7–50CE` | 7 | `08890d80614c53b17d9efe44a099a8835037d937bff09357c4a961ebc1d0585f` | `PalLibCandidate_WaitAndServiceVBlankForBCount` | Call `VBlank_WaitAndService` and decrement B until zero; initial B=0 wraps through 256 iterations. |
| `29:50CE–50D5` | 7 | `28564ec3053cac35322d8095a13f69395c211c7c587697a90873f94a066bb51e` | `PalLibCandidate_Call511EThenWaitVBlanksForBMinusOneCount` | Call `29:511E`, decrement B, then enter the preceding wait loop if nonzero. B=1 waits zero times; B=0 wraps before the wait loop. |
| `29:50D5–50DA` | 5 | `afb48bb9e1f79b1a577a77006d21c3d99abc05526a48757c9bac896e41e01086` | `PalLibCandidate_AdvanceHLByDEStrideUntilCZero` | Decrement C; return at zero, otherwise add DE to HL and repeat. Initial C=0 wraps through 255 additions. |
| `29:50DA–50FC` | 34 | `5ee01a8e5e91fe110c5652dba1ee416dcf0a8c6ad45dc1d2cda8cb3838017a21` | `PalLibCandidate_DisableMbc5RamThenWriteLyDerivedGateValue` | ROM0 bytes at `$0C0E/$0C0F` are `CD 18` (`$18CD`); calculate `$B312`, write `$12` to the MBC5 RAM-enable region, then write `$B3+LY`. Under the documented MBC5 decode, the second command enables RAM only when `LY & $0F == 7`; entry and intended purpose remain unproved. |
| `29:50FC–510F` | 19 | `5c7f81d25cec6f576431d1df04d01cef44398980d0400e5b285a5240c44bed62` | `PalLibCandidate_DivideABy10ToFfb1QuotientFfb0Remainder` | Repeatedly subtract ten; store quotient in `$FFB1`, remainder in `$FFB0`, preserve HL. |
| `29:510F–5117` | 8 | `52702c5d90344834c1f75e644d28377fa964f27c454d38a6d9e323d7925f667e` | `PalLibCandidate_WriteRomBankLowAAndZeroHigh` | Write A to `$2000`, then zero to `$3000`; no live mapper effect is inferred. |
| `29:526D–529F` | 50 | `caeb1a1b690f30d1fe40c651716671f93bc2684e5b7ae22ab06518ffd6ed3849` | `PalLibCandidate_Zero64BgPaletteBytesAndWriteObjStreamFromDE` | Zero 64 BG palette bytes, then transfer the stream from DE to OBJ palette data. B starts at zero, so the second loop runs 256 iterations. |
| `29:534A–536F` | 37 | `adcef7bf5aaa1545d8ed194e6b1ea507aeb66e34398dec98c492789a9ff1f976` | `PalLibCandidate_Write64BgAnd64ObjPaletteBytesFromHLAtLy90` | Wait for LY `$90`, write 64 BG palette bytes from HL, then wait again and write 64 OBJ palette bytes. |
| `29:536F–5376` | 7 | `4e513edf21351f81369f39e289989ffdba1b27afdda9be9606733ff07a6bdda5` | `PalLibCandidate_SetLcdcBit1` | Set LCDC bit 1 and return. |

The names at `29:50C7` and `29:50D5` bound local loop entries, not demonstrated
external call targets. The `29:50CE` wrapper has a static internal call to the
already named `29:511E` leaf. The 256-iteration OBJ loop and writes to mapper
register addresses are recorded literally; neither is normalized into an
assumed intended operation. The sequence at `29:50DA` reads the fixed ROM0
bytes `CD 18`, calculates `$B312`, writes `$12` to the MBC5 RAM-enable
register region, then writes `$B3+LY` through the same region. This establishes
the static register commands under the documented MBC5 decode, not a natural
call, runtime LY, hardware observation, or intended purpose.

The ten affected `.lAAAA` ledger rows now use the owner label current at each
instruction boundary. Eleven additional nonnumeric locals in the same source
file also received refreshed line/owner coordinates because the inserted
global labels change their lexical scopes. The ledger's stored source hashes
remain the hashes of the reviewed snapshot that produced each original
disposition; this report pins the new source snapshot SHA-256
`27051d8770242a754d44633711dc4c5c5b3d4787af755add18c9c4f03357626b`.

## Validation and limits

After the label-only source change, `make` passed SHA-256 verification and
returned `RESULT: IDENTICAL` against the original ROM. `make sym-check` passed
with 335 source files, 12,208 labels, and 51 constants; `make palette-check`
passed with 162 loads, 116 arrays, and zero errors; `make png-check` passed
410 tile sheets, four raw views, 37 font sheets, and 95 screen PNGs. The full
Japanese name census passed, including 2,764/2,764 local-anchor matches and
the 786-row RAM ledger. No language overlay or ZIP content was inspected,
modified, built, or tested.
