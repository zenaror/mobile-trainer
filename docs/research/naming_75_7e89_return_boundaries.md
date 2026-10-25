# Bank 75: Function_75_7E89 and its return boundaries

## Callee and field consumers

The complete reference ROM contains six little-endian89 7E occurrences, in banks2B,2E,5D,77,7B and7D. They are raw bytes in other banks, not executed bank75 references. No natural-caller, application-domain or asset-absence claim follows. No emulator, synthetic dispatch or hardware experiment was run.

Own literal callee/predecessor encodings match15+92+40+11bytes; earlycarry/busy/poll loops/DI/EI andHLclobber preclude universalcompletion/ABI.

Own34API+37state table words exact; neithercontains7E89.

Finite348 maintainedsearch onlydefinition does not excludecomputed/interior/overlapping/binary entry.

Historicalunion69 is not fresh/full69/69/50 or19missinggraphproof; absence notunreachability.

Purpose/entryHYPOTHESIS; mechanicsPROBABLEconditional.

No sampled fields/credentials/new natural/hardware evidence.

## Operation alias with an independently supported acknowledgement field

`MobileSDK_TryQueueSavedPacketWithXor80Ack` is a PROBABLE operation alias for `Function_75_7E89`. It replaces the earlier no-alias naming recommendation for the operation only. Entry, natural callers and application purpose remain HYPOTHESIS; the existing neutral name, instruction positions and local-label scopes are retained. The name describes preparation followed by an attempted queue call, not a completed transmission, a successful queue or an ABI equivalent to `MobileSDK_ResendPacket`.

The original 43-byte/27-start body remains `21 C1 C6 7E F5 CB 9E CB 86 21 BA C6 2A 5F 2A 57 2A 66 6F 23 23 3A 2B EE 80 EA BE C6 06 05 CD 10 5F F1 CB 47 C8 21 C1 C6 CB C6 C9`. It reads old C6C1 and saves that byte in A together with incoming F, clears C6C1 bits 3/0, then reads size DE from C6BA/B and pointer P from C6BC/D, little endian. It reads the byte at `(P+2) mod65536`, XORs $80 and stores the result into fixed WRAM C6BE, restores HL=P, sets B=5 and calls same-bank 75:5F10. The wrapper has no explicit store through P and does not rewrite the packet's command byte: it writes the computed expected-ack field. This is not a guarantee that arbitrary P aliases, stack effects, interrupts or callee effects leave a purported packet buffer untouched. No size, domain or pointer-wrap check is emitted; P=FFFE/FFFF reads0000/0001, and XOR80 can clear an already-set bit7.

The Ack part of the alias has direct original-code support beyond inherited names. At 75:56F2, the original bytes `21 A8 C6 19 F0 01 77 3E A8 BD C2 C8 58` construct C6A8+DE, read serial SB (FF01), store the received byte and continue the check only when the target's low byte is A8. The preceding transmit-remaining decrement restricts this path to the final two bytes with D=0. The code then reads C6BE. On the ordinary non-FF path, 75:5723..5734 contains `FA BE C6 FE FF 28 13 FE EE 28 06 FE 9F 20 02 3E 95 BE`; after sentinel FF and the explicit EE/9F handling (9F maps to95), opcode BE at5734 compares that expected value with the received byte at C6A8. `JR NZ` at5735 selects the mismatch path. This supports a local expected acknowledgement comparison; it does not make every byte value an ordinary command, exclude the special cases or establish this candidate's use. `traces/coverage_browser_errors.tsv:14531-14537` records797 hits per start in the received-byte collection fragment; lines14556-14564 record396 hits per start through the C6BE/compare path. These are existing aggregate observations, not values sampled for 7E89.

The positive same-bank relative at 75:5A17 (`MobileSDK_ResendPacket`) first tests its incoming [HL] against6 and may return through5B45. Its normal send path clears the same C6C1 bits and loads the same saved size/pointer fields before B=5/CALL5F10. The 31 original bytes are `7E FE 06 CA 45 5B 21 C1 C6 CB 9E CB 86 21 BA C6 2A 5F 2A 57 2A 66 6F 06 05 CD 10 5F C3 45 5B`. All seventeen starts have five hits each in `traces/coverage_browser_errors.tsv:14816-14832`. Unlike7E89, it does not recompute C6BE from P+2, does not save/restore the old C6C1 byte and entry F, and exits through5B45 rather than the candidate's saved-bit0 returns. Its execution supports the shared saved-argument queue operation, not candidate entry or equivalent error/carry behavior.

After a valid balanced callee return,7E89 POP AF discards the callee's carry/status. Final A is the saved old C6C1 byte, not incoming A. BIT0 of that byte produces Z=!savedbit0, N=0, H=1 and C=incoming carry. Saved bit0 zero returns at7EAD without a later local C6C1 store; saved bit0 one sets bit0 in the then-current C6C1 and returns at7EB3. It does not restore the whole byte, and the earlier bit3 clear does not guarantee final bit3 zero after intervening effects. No universal BC/DE/HL preservation, whole-AF preservation, final-bit0-zero or success status is promised. Stable ROM75 instruction fetching and calls, a valid nonaliasing stack, readable fields/P and no relevant IRQ/mapper interference remain preconditions; the packet-send/poll effects and potential noncompletion remain explicit.
