# Prepared original 6C:61AC counter and sprite contract

## Whole block and ordinary static operation

Expiry reads $C0D9, XORs $01 and stores the result. This toggles bit 0 and
preserves its other bits. The incoming byte is not proven boolean. It then
sets D=($78+new $C0D9) modulo 256, E=$80 and HL=$DA20. D would be $78/$79
only under a separately demonstrated 0/1 domain; that domain is not shown
for this entry. These are operations, not established field meanings.

## Far-call and WRAM bank qualification

The CALL at 6C:61C4 is `cd d1 06` followed by inline `65 0a 00`, invoking
ROM0 `Sprite_SetPosition` at 00:0A65. Once ordinary expiry flow reaches this
site the call is unconditional. The helper selects physical WRAM7 and writes
D and E to $DA20–$DA21. It restores SVBK using its saved `hWRAMBank` software
shadow. Preservation of an arbitrary physical entry bank is not shown:
the physical bank is restored only when its entry selector and shadow agree.

The far-call uses HRAM scratch/trampoline state and the stack; its common return path can rewrite ROM-low selection from the saved shadow.

## Entry, corpus and unresolved purpose

`wHelpScript_DeferredTextSfx` is a CONFIRMED overlay at the same RAM address
in another documented scope. That scope explicitly excludes 61AC. Its name,
initializer and semantics are not evidence of this routine's purpose or of
a boolean input domain. Counter/state operation descriptions therefore remain
separate from hypotheses about blinking, timing, animation or deferred sound.

Own original-ROM bytes confirm the counter address C0DA through 21 DA C0 and the unchanged operand wRam_C0DA.

The helper selects WRAM7 and writes D/E to DA20/21; it restores SVBK from the software shadow.

Coherent mapping/shadow, initialized HRAM trampoline, valid nonaliasing stack and uninterrupted, non-reentrant flow remain material preconditions.

## Counter/toggle/write operation alias

`DecC0DA_OnZeroReload23ToggleC0D9AndSetDA20` is a PROBABLE operation alias for `Function_6C_61AC`. It replaces only the earlier neutral-name recommendation; entry, caller, field domain and application purpose remain HYPOTHESIS. It names the existing31-byte/14-start operation, including3 inline farcall-data bytes, without a blink, frame timer, prompt-arrow or animation claim. The alias occupies blank998 and the neutral definition stays on999; every instruction/data/locator row and local scope is unchanged. Original bytes remain `21 DA C0 35 C0 36 23 FA D9 C0 EE 01 EA D9 C0 16 78 82 57 1E 80 21 20 DA CD D1 06 65 0A 00 C9`.

DEC[C0DA] is modulo256. If the result is nonzero the routine returns immediately; old0 becomesFF, while only old1 reaches expiry. On that early path HL=C0DA, A/BC/DE receive no explicit change, and F is theDEC result (Z0,N1,H for nibble borrow,C preserved), under the ordinary uninterrupted stack/state contract. Expiry stores23 atC0DA, readsC0D9, XORs01 and stores it, toggling bit0 without proving a Boolean byte. It computesD=(78+newC0D9)mod256, E=80 and HL=DA20, then unconditionally reaches the encoded farcall to ROM0:0A65 followed byRET. D is78/79 only under an additional0/1 domain that is not established here.

The helper `Sprite_SetPosition` explicitly selectsWRAM7 and writesD toDA20 andE toDA21, usingFFF2 and the stack; it restoresSVBK from the savedFF8D software shadow. Physical selector preservation therefore requires initial shadow/hardware agreement. The complete farcall uses HRAM argument/target scratch and an initialized trampoline, plus its own stack items; its cleanup can rewrite ROM-low selection from a saved shadow and does not preserve calleeF generally. No universal AF return/preservation or arbitrary-bank restoration is assigned to the complete operation. Caller/callee completion, coherent ROM6C/high-selector/shadow state, valid nonaliasing stack/scratch and absence of relevant IRQ/reentrant mapper interference remain preconditions. The counter has no proved unit, cadence or calling frequency.
