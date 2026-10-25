# Bank 29 bounded operation labels

This Japanese-only pass adds operation names at twelve previously unlabelled
instruction boundaries in the candidate library section
`engine/gfx/palette_library_candidate.asm`. It does not claim that the entries
are naturally called, that the entire region is a live palette library, or
that the names identify intended application purpose. The `PalLibCandidate_`
prefix retains the section's existing uncertainty. `CONFIRMED` below applies
only to the literal operation decoded from the immutable ROM bytes; entry,
caller, and broader role remain unproved unless stated otherwise.

The names at `29:50C7` and `29:50D5` bound local loop entries, not demonstrated
external call targets. The `29:50CE` wrapper has a static internal call to the
already named `29:511E` leaf. The 256-iteration OBJ loop and writes to mapper
register addresses are recorded literally; neither is normalized into an
assumed intended operation. The sequence at `29:50DA` reads the fixed ROM0
bytes `CD 18`, calculates `$B312`, writes `$12` to the MBC5 RAM-enable
register region, then writes `$B3+LY` through the same region. This establishes
the static register commands under the documented MBC5 decode, not a natural
call, runtime LY, hardware observation, or intended purpose.
