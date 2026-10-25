# Remaining neutral headers: bounded local effects and entry limits

## Conditional SRAM-bit mapping operation at 4E:6172

`IfA1_MapSram1A9EDBit7To19Or1A_DisableRam` is a PROBABLE description of the local operation at4E:6172, preserving `Function_4E_6172`.

The maintained emitters are `engine/browser/canvas.asm:104..122`, with local-label row117. RET6195 separates the operation from frame_graphics.asm at6196. The raw header has CGB flagC0, cartridge type1B, ROM-size06 and RAM-size03 at offsets143/147/148/149. `docs/ROM_INFO.md:15..20` identifies these as CGB-only, MBC5+RAM+BATTERY,2MiB ROM and32KiB/four SRAM banks. These identify the reconstruction's declared target; they are not a new hardware test. Under that MBC5 mapping, `constants/hardware.inc:95,98` identify write addresses0000 as RAM-enable and4000 as SRAM-bank selection. A CPU write to4000 here programs the mapper rather than modifying the selected ROMX bytes.

`ram/hram.asm:6,77` identify FF8C/hSRAMBank and FFF5/hSRAMEnable as software mirrors. `ram/banked.asm:140` defines SRAM1:A9E8 as the sixteen-byte save-check block, making its+5 byte A9ED. No name for the field's complete domain or application meaning is inferred from that container. The operation explicitly selects SRAM1 before its only SRAM-data read.

### Two distinct return contracts

For incoming A!=1, CP1 followed by RET NZ returns without accessing SRAM/shadows/mapper. A,B,C,DE,HL are unchanged by the local instructions. F is overwritten by the comparison: Z=0,N=1,H=1 exactly when the incoming low nibble was0,C=1 exactly when incoming A was0. Incoming AF is therefore not preserved; even A0 returns with Z0 on this path.

For incoming A=1, the operation writes0A to hSRAMEnable then rRAMG, writes1 to hSRAMBank then rRAMB, sets B=1A, reads SRAM1:A9ED and tests bit7. If that bit is set, B becomes19; if clear, B stays1A. XOR A then forces A0 and F80, and the following stores/LD A,B/RET do not change F. Thus ordinary final A=B=19 for a set bit or1A for a clear bit, with Z1/N0/H0/C0 regardless of that nonzero A result. C,DE,HL have no explicit modifications; B changes. No whole AF or BC preservation is claimed.

The A1 path finishes with hSRAMEnable=0 and rRAMG=0 while hSRAMBank=1 and rRAMB=1 remain selected. Earlier SRAM-bank/enable state is not saved or restored. No data byte in SRAM is explicitly written. The local stores affect HRAM mirrors and MBC registers. No ROM-bank, SVBK or VBK register is written, no CALL/PUSH/POP occurs and no DI/EI is issued; each RET consumes the ordinary return word. There is no transitive callee contract to infer, although interrupt effects remain outside the uninterrupted local contract.

### Transient state, stack and interrupt limits

The ordering matters: RAM is enabled before SRAM1 is selected, so the previously selected SRAM bank can be temporarily enabled. Each software mirror is written before its corresponding hardware register, creating an interval during which an IRQ observer can see a new mirror with older hardware state. On exit the enable mirror becomes0 before the hardware disable store. No atomic update or interrupt-safe mapper protocol is established.

The contract requires coherent ROM4E instruction mapping under the declared MBC5 register decode, SRAM1 readable after the explicit writes, and a valid nonaliasing return stack whose accessibility is not invalidated by enabling/selecting/disabling SRAM. A stack in SRAM, a stack overlapping the HRAM mirrors, or an incompatible switchable-WRAM stack context is not automatically safe. The local operation selects no CGB WRAM/VRAM bank; any bank-dependent stack mapping must remain stable. Relevant IRQ/mapper writes between selection and read, changes to the sampled byte, or interference with registers/stack can invalidate the ordinary result or final state.
