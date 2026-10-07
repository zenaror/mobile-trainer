# Bounded typing of the original bank 4C dialog argument

The physical unit `Data_4C_430A` occupies eight bytes, `4C:430A–4312`. It keeps its neutral name and whole-unit **PROBABLE** status. The representation exposes the naturally consumed little-endian destination as `dw $C220`; it preserves every byte, the next instruction at `4312`, and the original argument-loading instructions.

| Offset | Original bytes | Interpretation | Natural evidence |
| --- | --- | --- | --- |
| +0 | `03` | Initial dialog mode | Read in 19 scenarios |
| +1, +2 | `00 00` | Uninterpreted bytes | Unread |
| +3 | `F0` | Destination bank argument | Read in 18 scenarios; ignored on the fixed-WRAM write path |
| +4, +5 | `20 C2` | Little-endian destination `$C220` | Both bytes read in 18 scenarios |
| +6, +7 | `00 00` | Uninterpreted bytes in this object | Unread |

`Browser_LoadPage_AskConnect` loads D with bank `$4C`, BC with `$430A`, and calls `ConnectDialog_Run` at `4C:42FC`. The call has 108 natural executions across 19 scenarios. The dialog stores the argument bank and pointer, then reads byte zero through `ReadByteFar`. Its accept path advances the saved argument pointer by three and reads the bank argument and destination address. The resulting pointer, rather than a guessed value pattern, establishes the two-byte field.

`WriteByteFar` dispatches by the destination high byte. H=`$C2` selects the fixed-WRAM branch at `48:465C`, which writes B and advances HL without consulting the stored bank argument. `$F0` is therefore not evidence of a ROM bank, SRAM bank or sentinel. This pass introduces no RAM name, destination-capacity guarantee, input-length bound or claim about every dialog mode.

The generic dialog reader of argument offset six belongs to mode four. Its aggregate natural executions do not prove a read of this mode-three object: `430B`, `430C`, `4310` and `4311` remain unread. The eight-byte boundary is pinned by the adjacent instruction, not demonstrated as a universal dialog ABI size. Only four of these eight bytes have natural data reads.

The preceding independent inventory covered all three banks 4C–4E: 16 maintained sections, 69 data units, 38 intervening code intervals and three zero tails; its full review passed 1,453 checks. The all-label and data-label reference censuses use different explicit criteria. Neither that inventory nor this bounded field establishes confidence for unrelated units. The cache ring, guarded error-result array, palette/HDMA overlaps, unused object entries and partially read bank-4E descriptors remain separate work.

No new runtime, replay, PPU or hardware evidence is claimed. Frozen generator/configuration tables, extracted assets and shared macros are unchanged. The original ROM comparison and independent integration gates are recorded in `typing_4c_dialog_verify.md`.
