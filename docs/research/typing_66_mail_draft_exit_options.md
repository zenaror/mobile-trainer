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

- `メールをセーブしてしゅうりょうします` — save the mail and exit;
- `かいたメールをみることができます` — view the mail that was written;
- `メールをかくのをやめます` — stop writing the mail.

These readings identify the visible design, not proof of an observed menu
selection. Trace coverage reports execution of the loader, but does not prove
that all three values or screen states occurred naturally. Preserve that
distinction in filenames, inventory notes, and future runtime claims.

## Prior neutral labels

The earlier data-name audit retained `Data_66_6A90` as heuristic-only and
`Data_66_7190` as unknown. That was appropriately conservative before the
three exact consumer windows were consolidated. The new typed resource covers
both spans because the confirmed loader selects and transfers across them;
only the semantic claim about the three exit choices remains PROBABLE. The
frozen analysis outputs were not regenerated or edited.

## Reproduction and verification

The source is `gfx/keyboard/type6_pages_type10_picker_and_shared_tail_bank66.asm`; catalog and path migration are
in `gfx/assets.tsv` and `docs/research/gfx_resource_path_map.tsv`. The prior
112-tile PNG view was retained under `jp-gfx-mail-draft-exit-20261021` (review artifact)
for provenance. Verify the exact payload and PNG with `make png-check`, then
run the protected Japanese `make`, `make sym-check`, and `make palette-check`
gates. The expected ROM result is byte-identical to the source ROM.
