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
