# Typing 29 leaf lcdc ly limits

# Banco 29: limites das folhas 5090 e 511E — pesquisa privada estática

## Operation alias for clearing LCDC bit 2

- `27:468B/468D/468F`, in `engine/mail/send_receive.asm:824-826`, occurs inside `MailConnect_Screen` after a palette fade and window-position write, before the counted wait loop.

The candidate makes no bank selection or calls. Under a valid conventional return stack and no relevant interrupt interference, BC/DE/HL are unchanged, A contains the sampled LCDC byte with bit 2 clear, and flags are those of AND (Z reflects that result, N=0, H=1, C=0). The source does not disable interrupts around the read/modify/write; an interrupt that changes LCDC between sampling and writing can invalidate an atomic-update interpretation. None of the relative-fragment counts establishes execution, a caller or an entry of 29:5090, and none establishes the whole 742-byte library.

Its selected-bank call to $7BB7 and potentially unbounded LY polling retain the previously documented return, mapping and interrupt limits; no identity or context is borrowed from physical 7D:7BB7.

## Selected-address call and conditional LY polling operation

`CallSelected7BB7_IfReturnsPollLyByFFA4Bit0` is a PROBABLE operation alias for `Function_29_511E`.

The original ROM interval29:511E..5145 (exclusive), file offsets A511E..A5145, contains39 bytes and24 instruction starts: `C5 D5 CD B7 7B D1 C1 F0 A4 E6 01 28 10 F0 44 FE 24 C8 FE 48 C8 FE 6C C8 FE 90 20 F1 C9 F0 44 FE 48 C8 FE 90 20 F7 C9`. PUSH BC and PUSH DE save those pairs, then CALL $7BB7 targets the currently mapped ROMX address. No farcall or mapper selection occurs locally before that call. Only if it returns conventionally and preserves the saved stack values do POP DE/BC restore the entry pairs and execution reach the polling suffix.

The Joypad_Update identity at physical7D:7BB7 must never be borrowed for this selected-bank call.

After an ordinary balanced return to the expected29 bytes, the suffix samples FFA4.bit0 once. If that sampled bit is one, the loop at512B reads LY once per pass and tests that sample against24/48/6C/90. If the sampled bit is zero, the loop at513B tests its LY sample against48/90. The mode is not reread inside either loop; later changes to FFA4 do not select another branch in the shown suffix. All numbers are hexadecimal. Polling has no timeout, may fail to terminate and is not a promise of the next scanline occurrence, frame count or elapsed duration. A matching value can permit immediate return.

On an ordinary polling return, A is the accepted LY sample and F=$C0 (Z=1,N=1,H=0,C=0), from the matching CP; RET/JR do not change those flags. BC/DE retain their saved entry values only under the valid balanced nonaliasing stack/callee assumptions. HL is not saved by this wrapper, so any callee clobber remains unknown; incoming AF is not preserved. The locally known extra stack usage is four saved bytes plus two CALL-return bytes, in addition to unknown callee/interrupt use. There is no explicit WRAM or mapper store in the polling suffix, but stack stores and arbitrary transitive callee/IRQ effects are not excluded. The wrapper does not restore bank selectors, memory state or callee effects.
