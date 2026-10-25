# Home operation names and reference alias retirement

## Two precise copy names

`CopyStringMax_ZeroSourceIfEntryCountZero` (00:14D1) replaces the ambiguous ZeroSrcOnEmpty name. Only entry BC=0 performs the explicit zero store through source HL, with HL/DE/BC unchanged and local A=0,F=80h. For entry N>0 it copies the first byte then joins sibling CopyStringMax at 14C6. Later exhaustion returns without that explicit source store. On stable ordinary input k=min(N, first NUL offset+1) bytes copy, including NUL when found; otherwise exactly N bytes copy with no appended terminator. Ordinary local exits give BC=N−k, pointers+k modulo65536 and A=0,F=80h, not a last-byte return. No local PUSH/CALL or bank selection occurs. Writable source is needed for the zero-entry effect; DE overlap can still modify source storage, so this is not a universal source-preservation promise. FarCall cleanup can change flags.

`CopyFar16ByteBlocks` (00:172D) replaces the false BC-byte copy implication. Save sourcebank A in FFB1, sample destinationbank[C10E] once into FFB0, then repeatedly stage16 source bytes through C10E..C11D and issue16 destination writes. There is no partial tail or initialzero-count return. Let N=256B+C at entry; the isolated counter's numeric byte count M is:

For ordinary isolated exits, HL/DE advance M modulo65536. Except for B=FF,C a positive multiple16, exit B=0,C=F0h+(inputC mod16),A=C,F=D0h. The exceptional earlyzero class gives BC0,A0,F80h. Numeric counter termination does not guarantee safe memory completion.

BankSwitch_H/D select once per16-byte stage using the then-current high byte: nonzero bank selects ROM-low below80h, SRAM at80h..BFh or WRAM atC0h..FFh; bank 0 keeps the mapping at that stage, which a previous destination stage may already have changed. No original mapping, ROM-high, SRAM enable or VBK is restored/selected, and there is no DI or frame service. Crossing a region boundary inside 16 bytes is not normalized. FFB0/FFB1 and C10E..C11D are clobbered scratch. Source/destination/scratch/stack must not corrupt the algorithm, and the stack must remain visible across bank switches. Maximum additional stack is6 bytes including the nested bank-helper CALL, excluding the outer return word. A valid entry return frame is required.

Boot_ReinitRuntimeFar (1711) does not preserve incoming A: it overwrites A with 4F before calling Boot_ReinitRuntime, then returns callee A through hScratchA after restoring the saved ROM-low shadow/$2100. That is not sampled hardware state or generic bank restoration; callee reset effects remain broad.

## Original-contract erratum (2026-10-15, V2)

Sprite_LoadObjectEntry takes A directly, with an effective A&$3F four-byte index; Sprite_InitSlot supplies its B via A.

### Crossed nested-string saved words

Let R be the post-operand return pointer, K the old string bank and F_s the saved AF flags.

For a later Cmd00 at nonzero depth, POP HL at 0F9D first discards that dispatcher's current pointer. After decrementing depth, POP HL at 0FA5 reads the saved AF word, so HL=(K<<8)|F_s; POP AF at 0FA6 reads R, so A=R>>8 and F=R&F0h. The string-bank shadow becomes R>>8 at 0FA7. ReloadBank uses that byte with H=K as the BankSwitch_H region selector, and resumes from HL=(K<<8)|F_s, not R. Selector A0 makes no mapper change; other values follow region rules. On the canonical control01 dispatcher path F_s=0; arbitrary injected entry does not inherit that condition.

### HTML-store far records and header arithmetic

The index 3F:4012 begins A4 48 3E, so its first far record is 3E:48A4, not a record contained in bank3F. Its filename terminator is followed by record_length=0113h. With sufficient capacity 275 payload bytes copy, including the HTML NUL, but header 0111h is stored. This numeric static example neither declares intended format nor supplies a runtime experiment or buffer-safety guarantee.

For Gfx_StartHDMA and its service variant, writing unmasked C-1 gives general-purpose mode only for C=1..$80. LCD-on transfer waits for $91<=LY<B; LCD-off skips that wait. C=0 writes FF and C>$80 sets bit7, so no all-C general-purpose claim is retained. Each visible map upload uses C=$24, 36 decimal 16-byte blocks,576 bytes per buffer. VBlank_WaitStartDI returns IME=0/LY>=$90 only after the LCD-on wait completes; its LCD-off exit skips EI/HALT/DI and preserves entering IME absent interference. Tilemap_ApplyMaskRect implements ([HL] AND D) OR E, not a slash operation.

Html_MatchKeyword returns metadata after the table keyword rather than a byte after the input text. Its mismatch retry additionally relies on the caller-provided FFB0/FFB1 saved start; a terminated keyword table alone is insufficient. All these corrections describe the original code and its admitted domains, with existing evidence levels retained.
