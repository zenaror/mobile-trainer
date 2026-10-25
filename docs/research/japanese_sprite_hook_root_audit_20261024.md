# Sprite-hook callback route and Japanese candidate roots

## Question

| Callback | ROM location | Use |
|---|---:|---|
| `Sprite_HookAddSlideOffset` | `00:0A1A` | Dialog/browser cursor position adjustment |
| `ConnIcon_UpdateState` | `69:4034` | Connection icon state update |
| `ConnectDialog_ObjHook_Caret` | `57:52D8` | Connect-dialog caret |
| `ConnectDialog_ObjHook_FollowRaster` | `57:531E` | Connect-dialog raster-follow behavior |

| Dispatcher | Table and scope | Result for candidates |
|---|---|---|
| `TextEngine_NextByte` (`00:0EEF`) | 32 command words in `Table_TextEngine_CmdHandlers`, bank `00` | All targets are bank-00 command handlers; no switchable-bank candidate can be selected by this table. |
| `Mail_Dispatch` (`0F:425F`) | 13 selector words in `Mail_SelectorTable`; `Mail_DispatchFar` selects bank `0F` before dispatch | Every target is one of the 13 bank-0F handlers listed in `lib/mobile/mail.asm`; this route does not dispatch to `2B:6CF5`. |
| `CommScene_RunState` (`70:40AC`) | Three kind tables with 10, 9, and 5 state words (24 handlers total), all in bank `70` | The complete table does not contain `70:4740`; this state machine does not establish its entry. |

## Original-ROM immediate-pointer cross-check

It does not analyze non-immediate pointer arithmetic, runtime-computed pointers, or all possible WRAM writes.

This narrows the bypass-setter question only for explicit symbol-plus-offset
and literal-address writes plus the generic engine helpers described above. It
does not cover other writes through dynamically computed pointers, raw aliases
of WRAM, or unmaintained ROM code; candidate natural-entry status remains
unchanged.

## Computed pointer and helper-call census

A reproducible source-level pointer-provenance pass covered the same 339
maintained `.asm`/`.inc` files. It classified every symbolic call input to the
slot mutation helpers: all 15 `Sprite_SetHook` calls pass `wSpriteSlot2`,
`wSpriteSlot8`, or `wSpriteSlot12` plus `$0B`; all 524 `Sprite_SetPosition`
calls pass a slot base at offset `$00`; all 712 `Sprite_InitSlot` and 44
`Sprite_ClearSlot` calls also pass a slot base at offset `$00`. No callsite had
unknown or arithmetically computed HL provenance, and there are no maintained
numeric-address CALL/FARCALL operands for these four helpers. The separate
`wSpriteSlots + constant` operands in the source resolve to non-hook fields.

For pointer-based whole-page operations, `Sprite_UpdateAll` reads the slots, `Sprite_ResetAll` fills `$DA00..$DADF` with `$FF`, and `Sprites_RestoreSlotsFromBank3` is the only pointer-based `DE = wSpriteSlots` writer: it copies 256 bytes from `wSpriteSlotBackup`.

There is one known raw overlay writer: `DebugFlags_LoadHelpText` selects WRAM bank 3 and clears `wTileStage3` `$D000..$DBFF`, which overlaps the backup at `$D900..$D9FF`.

One concrete uncertainty remains: `StoreDEAtHL_SelectWramBank7` at `00:0A2A` accepts caller-supplied HL and writes E then D to `[HL]` and `[HL+1]`.

If reached indirectly with HL at callback offset `+$0B` or `+$0C`, it could overwrite the hook address bytes.

### Raw pointer-shaped bytes for `00:0A2A`

To check whether a stored address/bank triple supplies a hidden hook target,
the protected ROM was searched for the little-endian byte sequence
`2A 0A 00` (`address=$0A2A`, bank byte `$00`). All 15 matches are inside
manifested attribute maps, not code or callback records: six in the two
Bank-28 mail-body maps and nine in the Bank-41 orange-panel map. Every match
starts at column 19 of a 20-cell row, so the three bytes cross a row boundary
and are ordinary adjacent map attributes. The exact `CALL $0A2A` and
`JP $0A2A` opcode byte patterns each occur zero times in the ROM. Physical
banks were derived as `file_offset // $4000`, with CPU address
`$4000 + file_offset % $4000` for switchable banks; this avoids the bank-number
off-by-one that would misclassify those matches.

This closes only these exact pointer-shaped bytes and direct opcode forms; it
does not prove that `StoreDEAtHL_SelectWramBank7` has no computed caller, that
all arbitrary WRAM aliases are absent, or that no runtime-created hook exists.
The unresolved helper/caller question therefore remains, but these 15 matches
are not evidence for it.

```sh
rg -n 'call Sprite_SetHook|farcall Sprite_SetHook' engine home lib data --glob '*.asm'
rg -n '^(Sprite_HookAddSlideOffset|ConnIcon_UpdateState|ConnectDialog_ObjHook_Caret|ConnectDialog_ObjHook_FollowRaster)::' home engine lib data --glob '*.asm'
rg -n 'wSpriteSlot[0-9]+ \+ \$0(B|C|D)\b|wSpriteSlots \+' home engine lib data gfx audio ram --glob '*.asm' --glob '*.inc'
rg -n '\$DA(0B|0C|0D|1B|1C|1D|2B|2C|2D|3B|3C|3D|4B|4C|4D|5B|5C|5D|6B|6C|6D|7B|7C|7D|8B|8C|8D|9B|9C|9D|AB|AC|AD|BB|BC|BD|CB|CC|CD|DB|DC|DD)\b' home engine lib data gfx audio ram --glob '*.asm' --glob '*.inc'
python3 scan.py
python3 scan.py
```

The callback bank/address labels are in `home/sprites.asm`,
`engine/comm/connection_icon.asm`, and `engine/comm/connect_dialog_screen.asm`.
