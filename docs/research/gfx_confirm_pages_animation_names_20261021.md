# ConfirmPages animation labels (2026-10-21)

Five generic labels in `gfx/account/screens_bank4a.asm` now identify the
selected entry and its animation structure. The change is a symbol-only
relabel: all five names stay at their original bank/address and no emitted
bytes, confidence annotations, assets or composition rules change.

| Old label | Current label | Bank:address |
|---|---|---|
| `Data_4A_4004` | `ConfirmPages_ObjTable_Entry1` | `4A:4004` |
| `SpriteFrameTable_4A_4008` | `ConfirmPages_Anim1Frames` | `4A:4008` |
| `SpriteFrame_4A_400C` | `ConfirmPages_Anim1Frame0` | `4A:400C` |
| `SpriteFrame_4A_401D` | `ConfirmPages_Anim1Frame1` | `4A:401D` |
| `SpriteScript_4A_402E` | `ConfirmPages_Anim1Script` | `4A:402E` |

Seven static initialization sites provide bank `$4A`, object-table root
`$4000`, and selector `$81` (entry 1). The full bounded interval
`4A:4000–4033` decodes without gaps or overlaps; macro expansion, including the
null entry at `$4000`, emits 51 bytes equal to the original ROM. The entry/data
at `$4004–4033` contributes 47 bytes. The names express the confirmed root,
index and frame/script layout; they do not identify the object's depicted
subject, establish natural runtime selection, or cover the neighboring partial
`SettingsMenu` object.

Independent review accepted the four `ConfirmPages_Anim1*` labels, rejected the
broader spelling `ConfirmPages_ObjEntryAndAnimData`, and accepted
`ConfirmPages_ObjTable_Entry1` as the precise alternative consistent with the
checker’s `_EntryN` convention. Its report is retained in ignored
`agent-confirm-pages-review-20261021` (review artifact) (REPORT SHA-256
`da23df8d160fe689cac6e14b1602f872b2037d1d63f61b6b9cb014268adce554`; RESULT
SHA-256 `b0a393b066fdc243392a61083d450c66420fc1850809e6f4eae2c1ad009345ff`).
The proposal evidence is in `gfx-confirm-pages-static-20261021` (review artifact).

After integration, `make` reports `RESULT: IDENTICAL`, ROM size 2,097,152 and
SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` passes with 334 source files, 13,394 labels and 51 constants;
`make palette-check` reports 162 loads, 116 arrays, two documented over-reads
and zero errors. The rebuilt SYM contains the five new exports at the reviewed
addresses, no old exports, and the same 13,394-label total.
