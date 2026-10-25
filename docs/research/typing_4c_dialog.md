# Bounded typing of the original bank 4C dialog argument

The physical unit `Data_BrowserLoadPage_ConnectDialogArgs` occupies eight bytes, `4C:430A–4312`. Its structural name records that `Browser_LoadPage_AskConnect` passes bank `$4C` and pointer `$430A` directly to `ConnectDialog_Run`; it does not assert a universal eight-byte ABI. The whole-unit status remains **PROBABLE**. The representation exposes the naturally consumed little-endian destination as `dw $C220`; it preserves every byte, the next instruction at `4312`, and the original argument-loading instructions.

| Offset | Original bytes | Interpretation |
| --- | --- | --- |
| +0 | `03` | Initial dialog mode |
| +1, +2 | `00 00` | Uninterpreted bytes |
| +3 | `F0` | Destination bank argument |
| +4, +5 | `20 C2` | Little-endian destination `$C220` |
| +6, +7 | `00 00` | Uninterpreted bytes in this object |

`Browser_LoadPage_AskConnect` loads D with bank `$4C`, BC with `$430A`, and calls `ConnectDialog_Run` at `4C:42FC`. The call has 108 natural executions across 19 scenarios. The dialog stores the argument bank and pointer, then reads byte zero through `ReadByteFar`. Its accept path advances the saved argument pointer by three and reads the bank argument and destination address. The resulting pointer, rather than a guessed value pattern, establishes the two-byte field.

H=`$C2` selects the fixed-WRAM branch at `48:465C`, which writes B and advances HL without consulting the stored bank argument.

`$F0` is therefore not evidence of a ROM bank, SRAM bank or sentinel.

The generic dialog reader of argument offset six belongs to mode four. Its aggregate natural executions do not prove a read of this mode-three object: `430B`, `430C`, `4310` and `4311` remain unread. The eight-byte boundary is pinned by the adjacent instruction, not demonstrated as a universal dialog ABI size. Only four of these eight bytes have natural data reads.
