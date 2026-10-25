# HOME data and continuation alias retirement

The only extra existing owner is ram/hram.asm: its hRandomIndex comment follows the retained table identity.

## Four data identities and their consumers

Palette_AllWhite (00:0352) has 64 bytes, 32 little-endian RGB555 $7FFF words. The
two Palette_SetAllWhite loads point there and Palette_WritePort64 copies 64 bytes to
the selected palette data port. This confirms the data content/consumer identity;
it adds no hardware or newly observed display evidence.

Table_Random_XorBytes (00:0C34) has 256 literal bytes. Random increments the 8-bit
hRandomIndex, addresses that table plus the wrapped index and XORs the selected byte
with (5*oldState+2) mod256. This establishes the table's operand role, not a seed,
period, randomness-quality or security guarantee. The Random routine's inherited
PROBABLE status is retained. The hRandomIndex comment is the sole RAM edit.

Table_TextEngine_CmdHandlers (00:0EF0) consists of 32 little-endian handler pointers.
The interpreter branches to PutChar for A>=20h; otherwise it pushes the remaining
stream pointer and uses 0EF0+2*A to fetch a handler and JP HL. Table shape and static
index are CONFIRMED; each handler's existing entry/operation confidence remains its
own. In particular, Cmd01/nonnull-depth Cmd00 save/unwind crossed words as described
in home_function_names.md. Retirement establishes no ordinary recursion guarantee.

Table_Dial_SramEntryPtrs (00:161A) has three addresses: B014, B025 and B036, separated
by 11h. The consumer's selected-number branch selects SRAM1/enables RAM, decodes the
B013 selection by XOR A5h and doubles it in 8 bits. Its byte offset is (2*k)&FFh;
there is no bounds check for this three-pointer table. The name does not promise safe
arbitrary selection, terminated strings, writable output capacity, generic mapper
restoration or stack visibility. RAM names are contextual evidence only.

## Seven existing continuation identities

Boot_MainLoop (00:0328) far-calls Main_Run and, if it returns, the continuation jumps back to 0328.

TextEngine_ReloadBank (00:0ED8) loads the string-bank byte and calls BankSwitch_H,
then falls into NextByte. The helper uses current H: A=0 keeps mapping; otherwise H
below 80h selects ROM-low, 80h..BFh selects SRAM and C0h..FFh selects WRAM. Thus this
name is text-engine context, not a promise of universal ROM restoration. The known
crossed saved-word composition can violate ordinary string-pointer expectations.
TextEngine_NextByte (00:0EDD) reads HLI and dispatches the byte; it requires a valid
stream/mapping/stack and does not establish safe arbitrary control-byte execution.

TextEngine_AfterChar (00:0F5A) performs frame service, then compares the low X byte to
the right limit: X greater than the limit enters LineWrap, otherwise ReloadBank.
Control handlers also target AfterChar; the name does not establish exclusive reach
after a glyph or a general 16-bit bounds check. TextEngine_LineWrap (00:0F69) resets
the X pair from the saved line-start pair. Advance FFh returns; otherwise it adds the
line advance to Y and continues while Y is no greater than the maximum. Cmd0D drops
its pushed dispatcher pointer before falling here; direct wrap does not. Its RET
therefore inherits path-specific stack prerequisites, not general nested restoration.

Bank4_GateSetBusy (00:211D) sets bit7 through HL, saves AF around Bank4_SaveAndSelect
and returns. The reaching guards establish HL=wBank4State in the currently selected
banked WRAM window; arbitrary injected entry does not. Mapping, writable visible stack
and IRQ prerequisites remain conditional. Bank4_GateReturnBusy (00:2125) POPs HL,
sets A=FFh and RETs. The guard path deliberately consumes its own extra return word
to skip the stub continuation; it is not an ordinary independently called function
and does not promise universal AF/HL/stack preservation or generic reentrancy safety.

No existing descriptive identity was refuted by the finite content/consumer review.
The qualifications above constrain their meaning; they do not upgrade natural-entry,
emulator, hardware, mapper, interrupt, stack, buffer or all-input evidence.

## Retired alias map

| Old alias | Retained name | Bank:address |
|---|---|---|
| `Data_00_0352` | `Palette_AllWhite` | `00:0352` |
| `Label_00_0328` | `Boot_MainLoop` | `00:0328` |
| `Label_00_0ED8` | `TextEngine_ReloadBank` | `00:0ED8` |
| `Label_00_0EDD` | `TextEngine_NextByte` | `00:0EDD` |
| `Label_00_0F5A` | `TextEngine_AfterChar` | `00:0F5A` |
| `Label_00_0F69` | `TextEngine_LineWrap` | `00:0F69` |
| `Label_00_211D` | `Bank4_GateSetBusy` | `00:211D` |
| `Label_00_2125` | `Bank4_GateReturnBusy` | `00:2125` |
| `Table_00_0C34` | `Table_Random_XorBytes` | `00:0C34` |
| `Table_00_0EF0` | `Table_TextEngine_CmdHandlers` | `00:0EF0` |
| `Table_00_161A` | `Table_Dial_SramEntryPtrs` | `00:161A` |
