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

## Reproduction

From the repository root:

```sh
rg -n 'call Sprite_SetHook|farcall Sprite_SetHook' engine home lib data --glob '*.asm'
rg -n '^(Sprite_HookAddSlideOffset|ConnIcon_UpdateState|ConnectDialog_ObjHook_Caret|ConnectDialog_ObjHook_FollowRaster)::' home engine lib data --glob '*.asm'
```

The callback bank/address labels are in `home/sprites.asm`,
`engine/comm/connection_icon.asm`, and `engine/comm/connect_dialog_screen.asm`.
