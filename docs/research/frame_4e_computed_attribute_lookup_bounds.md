# Bounded computed attribute lookup at 4E:6543

## Static mechanical facts

The ROM interval 4E:[6543,654B) contains exactly eight bytes:

It follows the RET at 4E:6542 and precedes the separate descriptor pointer table at 654B.

At 4E:[6486,649D), the 23-byte loop loads an attribute, masks its low three bits, adds the 8-bit immediate $43, then forms the high address byte with $00 plus ADC $65.

It reads `[DE]` and writes `(old_attribute & $E0) | table[old_attribute & $07]`.

The result sets attribute bit 3 (VRAM bank 1), clears bit 4, and preserves bits 5, 6 and 7.

The mapping requires ROM bank 4E at the local read, valid WRAM7 screen buffers, ordinary farcall returns, valid stack and the surrounding helper/IRQ discipline. The bounded source and home-bank switching/farcall helpers support that prerequisite; arbitrary interior entry, disrupted returns or asynchronous bank changes are not proved safe. Purpose and entry qualifications are retained. Descriptor selection, other frame headers, PNG classifications and names are outside this correction.
