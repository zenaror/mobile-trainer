# Bank 75: Function_75_7E89 and its return boundaries

Prospective static documentation. Preserve the neutral label and the existing PROBABLE code classification. Entry, application purpose and natural callers remain HYPOTHESIS. No execution, runtime success, reconstruction equivalence or hardware result is established.

## Byte interval and contradictory header

The maintained `lib/mobile/main.asm` section is placed in ROMX bank75 by `layout.link`. Independent literal encoding of all27 instructions matches43 bytes at original-ROM offset0x1D7E89, the half-open interval [75:7E89,75:7EB4). The original Japanese reference ROM has SHA-256 6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570. CONFIRMED applies to this byte confrontation only; the existing code and unknown entry are not promoted to execution evidence.

```
21c1c67ef5cb9ecb8621bac62a5f2a572a666f23233a2bee80eabec60605cd105ff1cb47c821c1c6cbc6c9
```

RET Z at75:7EAD (C8) and RET at75:7EB3 (C9) contradict the old “falling into the code at7EB4” claim. `MobileState_Timeout` begins at7EB4 but neither ordinary return falls through there. The preceding [75:7E7A,75:7E89) block ends with JP75:5FA0 at7E86, providing no ordinary fall-through entry into7E89 either. Other transfers are not excluded.

## Qualified sequential contract

These deductions require stable bank75 instruction fetch and ROMX calls, a valid balanced nonaliasing stack, and an ordinary return from the callee. Reads and memory effects occur in their actual order; no arbitrary-entry or interrupt-wide ABI is inferred.

- LD HL,C6C1 / LD A,[HL] leaves incoming F unchanged. PUSH AF saves the old byte read from C6C1 and incoming F, not incoming A. RES3,[HL] and RES0,[HL] clear those memory bits before the argument reads and leave flags unchanged.
- Four sequential reads atC6BA..C6BD form DE fromC6BA/C6BB and pointer P fromC6BC/C6BD, both little endian. Existing names `wMobileSDK_ResendSize` and `wMobileSDK_ResendPointer` are retained; historical domain descriptions do not independently prove this neutral entry's purpose. Atomicity of the reads is unproved.
- INC HL twice forms (P+2) modulo65536. LD A,[HLD] reads that address, then DEC HL restores P modulo65536. XOR80 toggles bit7 of the read byte; it does not guarantee bit7 is set. The result is stored toC6BE and B becomes05. No size or pointer-domain check occurs. P=FFFE reads0000; P=FFFF reads0001. The read may address ROM, RAM or registers, including aliases of fields already modified.
- CALL at7EA7 encodes CD105F, targeting same-bank `Mobile_PacketSendBytes` at75:5F10, not ROM0. Locally prepared DE, HL=P, B=05 and C6BE do not guarantee callee success, completion or preservation.
- After an ordinary balanced return, POP AF7EAA restores A to the saved oldC6C1 byte and F to incoming F. BIT0,A7EAB sets Z to the complement of saved bit0, N=0,H=1, and preserves restored C. RET Z7EAD therefore returns Z=1; the later RET7EB3 returns Z=0. Both return N=0,H=1,C=incoming C and A=oldC6C1, not incoming A or the callee's status. POP AF discards the callee's carry result.
- When saved bit0 is zero, RET Z makes no later local store toC6C1. Clearing it before the call does not guarantee its final value after intervening effects. When saved bit0 is one, the later LD HL,C6C1 / SET0,[HL] explicitly sets bit0 in the value then present; it does not restore the whole saved flags byte. Final bit3 is not guaranteed clear solely from the earlier RES3. No unconditional preservation contract for BC,DE,HL or all of AF is claimed.

## Callee and field consumers

Independent finite encodings also match [75:5F10,75:5F6C),46 instructions/92 bytes; [75:40B4,75:40DC),24 instructions/40 bytes; [75:4225,75:4230),five instructions/11 bytes; and the15-byte predecessor above. These are same-bank bodies, with no ROM0 call in the inspected intervals.

The5F10 callee first calls `MobileSDK_WaitStatusPoll` at40B4 and can RET C5F13. If the serial phase is nonzero it calls `MobileSDK_ErrBusy` at4225, then SCF/RET5F1F. Its5F20 loop reads serial control SC=FF02 until bit7 clears. The poll helper can loop, uses DI/EI, and can load HL with a timer field before a carry return. Completion and preservation cannot be assumed universally.

On the later queue path, the callee readsC6BE. If it differs fromFF, it stores the then-current HL and DE intoC6BC/C6BD andC6BA/C6BB. It writes transmission fields, uses B as phase code, setsC6C1 bit5 and executes EI/RET. The existing CONFIRMED annotations on separate historical callee traces do not prove execution of Function_75_7E89.

The separate `MobileSDK_ResendPacket` at75:5A17 also reads those four fields and calls5F10 with B=05. It has different surrounding tests and lacks this saved-AF / P+2 XOR80 sequence. The finite resemblance helps qualify the fields, not assign a semantic alias to the unknown entry.

## Finite caller and dispatch evidence

A whole-file guarded search across all348 maintained ASM/INC files for Function_75_7E89 and explicit $7E89/0x7E89 found only the definition. No direct transfer or table operand using these spellings was found. Expressions, split bytes, dynamic return addresses and computed transfers remain possible.

All34 words of the API table [75:4070,75:40B4) and all37 words of the state table [75:61A7,75:61F1) match their maintained label targets and original bytes. Neither contains7E89. Both inspected dispatchers construct return-based transfers through selected addresses; these finite tables neither exhaust computed entries nor establish bounds for arbitrary dispatcher indices. The state table contains7EB4, supporting that separate entry without proving entry into7E89.

The complete reference ROM contains six little-endian89 7E occurrences, in banks2B,2E,5D,77,7B and7D. They are raw bytes in other banks, not executed bank75 references. No natural-caller, application-domain or asset-absence claim follows. No emulator, synthetic dispatch or hardware experiment was run.

## Minimal prospective scope

Replace only four existing header comment rows and add this note. Preserve all labels, instructions/data and the10242 physical rows of main.asm; all348 ASM/INC row/blank vectors and all289 analysis/gfx TSV payloads remain exact in this private proposal. No alias or build-output exception is added. It stays after the bank70 proposal and the prior queue; future parent, integration, authorization and gates remain unset. Index/publication updates and reconstruction checks require a later independently reviewed ROOT integration phase.


## Current private implementation after RET, 55, 6C, 7C, 2D, 68, 73 and 70

Historical29c scope2 proposal remains preserved. ROOT-authorized private scope5 uses guarded bank70 SOURCE4206 (395facd1), four comments10105..10108,10242 owner physical rows, RE/index suffixes once, original proposal note and separate verification note. SOURCE4208/outside4203; all348 ASM/inc vectors/LOC,1248 TSVs/289metadata and147 source.py timestamps exact; prior chain including2C4F preserved. No aliases/emitted text changes.

Own43 bytes/27 starts sealed before facts; all27 maintained emitters independently match. RET Z7EAD/RET7EB3 contradict historicalfallthrough7EB4; predecessorJP7E86 targets5FA0. Both boundary paths require ordinary balanced/nonaliasingstack, stableROM75/mapping and callee completion. Sequential DE fromC6BA/B andP fromC6BC/D; pointerP+2 wraps16bit and XOR80 togglesbit7, not guaranteesbit7one. B5 CALL75:5F10 samebank. POPAF restores oldC6C1/A and incomingF rather than incomingA/callee status; BIT0 yieldsZby savedbit0,N0H1,Cincoming. Final savedbit0one sets then-currentbit0 only; neither fullflags restoration nor finalbit3zero/bit0zero onearlyreturn guaranteed. No universalBCDEHL or success claim.

Own literal callee/predecessor encodings match15+92+40+11bytes; earlycarry/busy/poll loops/DI/EI andHLclobber preclude universalcompletion/ABI. Own34API+37state table words exact; neithercontains7E89. SixwholeROM wordoccurrences lie in otherbanks, not75callers. Finite348 maintainedsearch onlydefinition does not excludecomputed/interior/overlapping/binary entry. Historicalunion69 is not fresh/full69/69/50 or19missinggraphproof; absence notunreachability. Purpose/entryHYPOTHESIS; mechanicsPROBABLEconditional. No sampled fields/credentials/new natural/hardware evidence.

New onceprivate37 completed36rc0+ordinal27rc2exact97. Ordinal1 only top-levelmake; make/compare/sym-check/palette verified wholeROM IDENTICAL. All671 outputs/wholeSYM15538labels51constants/MAP equal guarded private70. RawD334/10912rules unchanged,5623 currentbindings rebind onlylib/mobile/main.asm; BEFORE4206 distinctAFTER4208. Source147.py exact, no.pyc copied; native/tools membership historical, no newcapture. Notes receive this documentation-only appendix after37 with no code/output changes orgate replay. Candidate stable forINDcopy. ROOT/INDadoption, actual/publishedparent, actualintegration, DOCrebase/freshchecks/publication/authority NULL.

Ownnegative: attempted prep-generatorAST unmatched parenthesis before any script/candidate write, no execution/gate. Original toolfailure preserved; v1 prep decimal operand KeyError1 beforepipeline preserved, v2 supports decimal operands in freshnamespace.


## Operation alias with an independently supported acknowledgement field (2026-10-15)

`MobileSDK_TryQueueSavedPacketWithXor80Ack` is a PROBABLE operation alias for `Function_75_7E89`. It replaces the earlier no-alias naming recommendation for the operation only. Entry, natural callers and application purpose remain HYPOTHESIS; the existing neutral name, instruction positions and local-label scopes are retained. The name describes preparation followed by an attempted queue call, not a completed transmission, a successful queue or an ABI equivalent to `MobileSDK_ResendPacket`.

The original 43-byte/27-start body remains `21 C1 C6 7E F5 CB 9E CB 86 21 BA C6 2A 5F 2A 57 2A 66 6F 23 23 3A 2B EE 80 EA BE C6 06 05 CD 10 5F F1 CB 47 C8 21 C1 C6 CB C6 C9`. It reads old C6C1 and saves that byte in A together with incoming F, clears C6C1 bits 3/0, then reads size DE from C6BA/B and pointer P from C6BC/D, little endian. It reads the byte at `(P+2) mod65536`, XORs $80 and stores the result into fixed WRAM C6BE, restores HL=P, sets B=5 and calls same-bank 75:5F10. The wrapper has no explicit store through P and does not rewrite the packet's command byte: it writes the computed expected-ack field. This is not a guarantee that arbitrary P aliases, stack effects, interrupts or callee effects leave a purported packet buffer untouched. No size, domain or pointer-wrap check is emitted; P=FFFE/FFFF reads0000/0001, and XOR80 can clear an already-set bit7.

The Ack part of the alias has direct original-code support beyond inherited names. At 75:56F2, the original bytes `21 A8 C6 19 F0 01 77 3E A8 BD C2 C8 58` construct C6A8+DE, read serial SB (FF01), store the received byte and continue the check only when the target's low byte is A8. The preceding transmit-remaining decrement restricts this path to the final two bytes with D=0. The code then reads C6BE. On the ordinary non-FF path, 75:5723..5734 contains `FA BE C6 FE FF 28 13 FE EE 28 06 FE 9F 20 02 3E 95 BE`; after sentinel FF and the explicit EE/9F handling (9F maps to95), opcode BE at5734 compares that expected value with the received byte at C6A8. `JR NZ` at5735 selects the mismatch path. This supports a local expected acknowledgement comparison; it does not make every byte value an ordinary command, exclude the special cases or establish this candidate's use. `traces/coverage_browser_errors.tsv:14531-14537` records797 hits per start in the received-byte collection fragment; lines14556-14564 record396 hits per start through the C6BE/compare path. These are existing aggregate observations, not values sampled for 7E89.

The positive same-bank relative at 75:5A17 (`MobileSDK_ResendPacket`) first tests its incoming [HL] against6 and may return through5B45. Its normal send path clears the same C6C1 bits and loads the same saved size/pointer fields before B=5/CALL5F10. The 31 original bytes are `7E FE 06 CA 45 5B 21 C1 C6 CB 9E CB 86 21 BA C6 2A 5F 2A 57 2A 66 6F 06 05 CD 10 5F C3 45 5B`. All seventeen starts have five hits each in `traces/coverage_browser_errors.tsv:14816-14832`. Unlike7E89, it does not recompute C6BE from P+2, does not save/restore the old C6C1 byte and entry F, and exits through5B45 rather than the candidate's saved-bit0 returns. Its execution supports the shared saved-argument queue operation, not candidate entry or equivalent error/carry behavior.

The callee 75:5F10 can return carry immediately after40B4, return a busy error after4225, or poll serial-control bit7 without a timeout. On the later queue path, it uses C6BE!=FF to decide whether to save the then-current HL/DE back to C6BC/D and C6BA/B; it copies DE into transmission remaining, HL into the transmission pointer, uses B as the phase code, sets C6C1.bit5 and returns after EI. `traces/coverage_browser_errors.tsv:15200-15219` records401 hits at the inspected call/argument-consumption starts, including5F2F/5F37. These are aggregate callee counts across its callers; none is assigned to7E89, and they do not demonstrate its completion or transmission.

After a valid balanced callee return,7E89 POP AF discards the callee's carry/status. Final A is the saved old C6C1 byte, not incoming A. BIT0 of that byte produces Z=!savedbit0, N=0, H=1 and C=incoming carry. Saved bit0 zero returns at7EAD without a later local C6C1 store; saved bit0 one sets bit0 in the then-current C6C1 and returns at7EB3. It does not restore the whole byte, and the earlier bit3 clear does not guarantee final bit3 zero after intervening effects. No universal BC/DE/HL preservation, whole-AF preservation, final-bit0-zero or success status is promised. Stable ROM75 instruction fetching and calls, a valid nonaliasing stack, readable fields/P and no relevant IRQ/mapper interference remain preconditions; the packet-send/poll effects and potential noncompletion remain explicit.

These original bytes, field producers/consumers and executed relative support the narrow operation alias without promoting unknown entry or application purpose. There is no ordinary fall-through into7EB4, no new runtime/visual/hardware result and no reconstructed-ROM equivalence claim from these static facts. The documented build, symbol check and byte comparison with the original ROM remain necessary to establish reconstruction equivalence.
