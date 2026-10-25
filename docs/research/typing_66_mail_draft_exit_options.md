# Bank 66 mail-draft exit options

## Result

`Gfx_MailDraftExitOptions_Tiles` names the 1,920-byte resource at `66:6A90`.
The label's semantic meaning is **PROBABLE**: the previous 112-tile view contains
three Japanese captions associated with leaving the mail editor, but the
preserved static evidence does not prove that each picker mode was naturally
reached or rendered in a recorded session.

The byte extent and transfer geometry are **CONFIRMED** from the assembly and
the `Gfx_StartHDMA` contract. `Kbd_LoadPickerTabTiles` (`55:6BD7`) indexes
`Table_Kbd_PickerTabTilePtrs` (`55:6C0A`) with `wKbdInputMode`; the three bank
66 sources are `6A90`, `6D10`, and `6F90`. Each transfer requests `$28` blocks
of 16 bytes to the tile area at VRAM `$8800`, bank 1, so the windows are:

| Mode index | ROM span | Size | Tiles |
|---:|---|---:|---:|
| 0 | `66:6A90-6D10` | 640 bytes | 40 |
| 1 | `66:6D10-6F90` | 640 bytes | 40 |
| 2 | `66:6F90-7210` | 640 bytes | 40 |

The third window includes the 128 `$FF` bytes formerly labeled `Data_66_7190`.
Its end is exactly the next tilemap at `66:7210`; there is no map overread.
The combined resource is 120 tiles. The exact PNG is 120×64 pixels (15×8
tiles), generated from the combined binary and reversible through the normal
tile PNG rules. No ROM bytes were changed; the payload remains the original
1,792-byte span followed by the 128-byte `$FF` tail.

The strings visible in the first 112 tiles read approximately:
