# Bank 2A profile animation script contract

## Confirmed reader semantics

The sprite reader establishes the conditional record format. `Sprite_LoadObjectEntry` at `00:0AB8` reads the two pointers from each four-byte object-table entry and initializes the script count plus first pair. `Sprite_StepAndDrawSlot` at `00:0B02–0B35` reads the count and selected pair; the first byte selects a frame-table pointer and the second reloads the per-slot countdown at slot+5. `00:0B71` uses the frame-table index to select an OAM frame pointer. The second field is therefore a slot-update countdown reload; no wall-clock duration or measured animation rate is claimed.

## Bank 2A profile records

The 20 entries at `Table_Profile_Anims` (`2A:6E50`) each store a frame-table pointer and a script pointer. Original ROM bytes and current source establish these five scripts:

| script | span | bytes | pairs (frame-table index, countdown reload) | table entries | selection status |
|---|---|---|---|---|---|
| `Profile_Anim0Script` | `2A:6ECE–6ED2` | `02 00 2A 01 08` | `(0,$2A),(1,$08)` | 0–3 | table pointer confirmed; selection not established |
| `Profile_Anim4Script` | `2A:6F01–6F05` | `02 00 2A 01 08` | `(0,$2A),(1,$08)` | 4–7 | table pointer confirmed; selection not established |
| `Profile_Anim8Script` | `2A:6F3C–6F40` | `02 00 08 01 23` | `(0,$08),(1,$23)` | 8–11 | entry 9 selected by `Profile_InitScreen` |
| `Profile_Anim12Script` | `2A:6F77–6F7B` | `02 00 08 01 23` | `(0,$08),(1,$23)` | 12–15 | entry 13 selected by `Profile_InitScreen` |
| `Profile_Anim16Script` | `2A:6F92–6F94` | `01 00 04` | `(0,$04)` | 16–19 | table pointer confirmed; selection not established |

`Profile_InitScreen` loads `DE=2A:6E70` (`Table_Profile_Anims_Entry8`) and `B=$81`; `Sprite_InitSlot` masks the entry selector to 1, so it reads entry 9 at `2A:6E74`, whose words are `6F06,6F3C`.

It also loads `DE=2A:6E80` (`Table_Profile_Anims_Entry12`) with `B=$81`, selecting entry 13 at `2A:6E84`, whose words are `6F41,6F77`.

The other table entries point at scripts with the same confirmed reader format, but the inspected `Sprite_InitSlot` consumers pass `B=$81` at the entry-8 and entry-12 base pointers, selecting only entries 9 and 13. Selection of every other entry remains unestablished. Do not claim a visual, hardware, or timing result. All script bytes remain unchanged.

## Original-byte hashes

Bank 2A maps at file offset `$A8000`; hashes below cover each exact script span:
