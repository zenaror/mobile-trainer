# Sprite-hook callback route and Japanese candidate roots (2026-10-24)

## Question

Could the per-sprite callback path provide a producer or natural entry for any
of the five unresolved Japanese candidates: `2B:6CF5`, `2D:4E42`, `2D:4E54`,
`29:511E`, or `70:4740`?

## Evidence

`Sprite_StepAndDrawSlot` in bank `00` dispatches the slot callback stored at
`+0B..+0D` through the push-return sequence at `00:0B36..0B53`. The setter
`Sprite_SetHook` at `00:0A45` stores the supplied 16-bit address and bank in
those three bytes. A source-wide enumeration found 15 direct setter call sites
under `engine/`, `home/`, `lib/`, and `data/` (3 in `engine/browser/menus.asm`,
1 in `engine/browser/status_sprites.asm`, 4 in `engine/dialog/dialog.asm`, 1 in
`engine/comm/connect_dialog_screen.asm`, and 6 in
`engine/comm/connect_dialog.asm`; total 15). Their non-null callback targets resolve to exactly
four symbols:

| Callback | ROM location | Use |
|---|---:|---|
| `Sprite_HookAddSlideOffset` | `00:0A1A` | Dialog/browser cursor position adjustment |
| `ConnIcon_UpdateState` | `69:4034` | Connection icon state update |
| `ConnectDialog_ObjHook_Caret` | `57:52D8` | Connect-dialog caret |
| `ConnectDialog_ObjHook_FollowRaster` | `57:531E` | Connect-dialog raster-follow behavior |

The remaining setter calls clear the callback with address zero. None of these
four callback addresses is one of the five candidates. Therefore the audited
sprite-hook producer/dispatch path does not establish a caller or natural root
for those candidates.

Three other indexed `JP HL` dispatches in the same subsystem neighborhoods
were checked against their complete maintained tables:

| Dispatcher | Table and scope | Result for candidates |
|---|---|---|
| `TextEngine_NextByte` (`00:0EEF`) | 32 command words in `Table_TextEngine_CmdHandlers`, bank `00` | All targets are bank-00 command handlers; no switchable-bank candidate can be selected by this table. |
| `Mail_Dispatch` (`0F:425F`) | 13 selector words in `Mail_SelectorTable`; `Mail_DispatchFar` selects bank `0F` before dispatch | Every target is one of the 13 bank-0F handlers listed in `lib/mobile/mail.asm`; this route does not dispatch to `2B:6CF5`. |
| `CommScene_RunState` (`70:40AC`) | Three kind tables with 10, 9, and 5 state words (24 handlers total), all in bank `70` | The complete table does not contain `70:4740`; this state machine does not establish its entry. |

These results bound those specific producers. They do not imply that other
indirect transfers, code-pointer tables, or direct writes have been exhausted.

## Candidate-bank filter over the current mapper pipeline

To choose the next finite review without relying on the September generated
report, `tools/mapper.py` was imported from the current checkout at commit
`d4ad496804d190241a084944ea943339ae77ccb4`; `Inputs()` and `run_pipeline()`
were run in memory with the committed ROM/coverage/trace inputs. The ROM inputs
`baserom.gbc` and `Mobile Trainer (Japan).gbc` both measured 2,097,152 bytes
and SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
The pipeline converged after two rounds (103,605 then 103,440 decoded
instructions) and produced 34 unresolved `jp hl` / `push rr ; ret` sites. Of
the physical banks containing the candidates (`29`, `2B`, `2D`, `70`), the
only such site is
`70:40AC jp hl`. The current pipeline found no inline `call $0545` / `$056A`
tables whose call site is in those four banks. The complete table for
`CommScene_RunState` at `70:40AC` was checked above and does not select
`70:4740`.

This closes the decoded same-bank indirect-transfer route for these candidates
within the current mapper evidence: no such site was found in banks `29`,
`2B`, or `2D`, and the sole bank-`70` site has a bounded table excluding
`70:4740`. It does not rule out code hidden in unclassified spans, runtime
computed transfers originating elsewhere, stack pivots, or execution outside
the retained trace corpus; it is not a global-unreachability claim.

The September `analysis/mapper/bank2B.tsv` row for the decoded span
`2B:[69C5,6CF5)` says it was entered by a call at `2B:6735`. That call is
`CD C5 69` in the original ROM and targets `MailView_DrawTextLine20` at
`2B:69C5`; the span's exclusive end at `6CF5` is not a call target or
fall-through edge. This mapper annotation therefore supplies no entry to the
candidate `MailReply_ComposeFromRecord` at `2B:6CF5`.

The in-memory check was reproduced with:

```python
import sys
sys.path.insert(0, "tools")
import mapper
inputs = mapper.Inputs()
discovery, mapped = mapper.run_pipeline(inputs, quiet=True)
```

Filtering `discovery.cfg.unresolved` by `node[0] in {0x29, 0x2B, 0x2D,
0x70}` yields only `70:40AC`; filtering `mapped.inline_tables` by the same
bank set yields no rows.

## Limits

This is a bounded result over the maintained assembly's direct
`Sprite_SetHook` call sites and the callback values passed there. It does not
prove global unreachability, rule out writes that bypass the setter, computed
transfers from other subsystems, execution absent from retained traces, or
resolve the candidates' roles. Their natural-entry status remains UNKNOWN;
their operation descriptions retain their existing confidence levels.

## Explicit slot-field writer census (2026-10-24)

To narrow the direct-write caveat, I scanned all 339 `.asm` and `.inc` files
under the maintained roots `home/`, `engine/`, `lib/`, `data/`, `gfx/`,
`audio/`, and `ram/` for explicit references to callback bytes `slot+$0B..$0D`.
The SHA-256 of the ordered `path + per-file SHA-256` list is
`f84c377db8d669bd1fef30f256e9b2b364f72e9721fde3bdaf1ed99df35c3d14`.

The only 15 references to `wSpriteSlotN+$0B` load the address passed to
`Sprite_SetHook`; no explicit `wSpriteSlots+constant` operand resolves to a
callback-byte offset modulo the 16-byte slot stride. The only six explicit
stores to `wSpriteSlotN+$0B..$0D` are in `MailDraft_Menu`
(`engine/mail/draft_menu.asm`): after setting A to `$FF`, it fills all 16 bytes
of slots 1 and 2, including their callback fields and active byte at `+$0F`.
These are inactive-slot initializations, not installed callback targets. A
scan for literal absolute `$DAxx` operands matching callback-byte addresses
found none.

The sprite-engine's generic slot writers were also checked in `home/sprites.asm`.
`Sprite_ResetAll` fills the 14-slot page with `$FF`; `Sprite_ClearSlot` fills
one 16-byte slot with `$FF`. `Sprite_InitSlot` first fills a slot with zero,
sets `+$0E` to the animation-table bank, then calls `Sprite_LoadObjectEntry`.
That loader writes slot offsets `+$02..+$0A` and `+$0F`; it leaves callback
bytes `+$0B..+$0D` at zero. Thus these setup paths install no callback address.
The bank-3 save/restore pair copies the 256-byte slot page to and from its
backup; it preserves slot state and is not itself a separate callback
initializer.

This narrows the bypass-setter question only for explicit symbol-plus-offset
and literal-address writes plus the generic engine helpers described above. It
does not cover other writes through dynamically computed pointers, raw aliases
of WRAM, or unmaintained ROM code; candidate natural-entry status remains
unchanged.

## Reproduction

From the repository root:

```sh
rg -n 'call Sprite_SetHook|farcall Sprite_SetHook' engine home lib data --glob '*.asm'
rg -n '^(Sprite_HookAddSlideOffset|ConnIcon_UpdateState|ConnectDialog_ObjHook_Caret|ConnectDialog_ObjHook_FollowRaster)::' home engine lib data --glob '*.asm'
rg -n 'wSpriteSlot[0-9]+ \+ \$0(B|C|D)\b|wSpriteSlots \+' home engine lib data gfx audio ram --glob '*.asm' --glob '*.inc'
rg -n '\$DA(0B|0C|0D|1B|1C|1D|2B|2C|2D|3B|3C|3D|4B|4C|4D|5B|5C|5D|6B|6C|6D|7B|7C|7D|8B|8C|8D|9B|9C|9D|AB|AC|AD|BB|BC|BD|CB|CC|CD|DB|DC|DD)\b' home engine lib data gfx audio ram --glob '*.asm' --glob '*.inc'
```

The callback bank/address labels are in `home/sprites.asm`,
`engine/comm/connection_icon.asm`, and `engine/comm/connect_dialog_screen.asm`.
