# Top-menu same-address aliases

At Japanese source revision `ba4700c896246538aee78f939e96096df3e6117f`,
`gfx/top_menu/top_menu.asm` contained 16 address-only aliases immediately
beside descriptive labels at the same addresses. An independent review against
that revision checked symbol addresses, all 347 maintained ASM/INC files, 142
tool files, local-label scope, macros, includes and the asset catalog before
accepting the retirement.

| Address | Retired label | Retained label |
|---|---|---|
| `1E:40D7` | `Data_1E_40D7` | `Tilemap_TopMenu_1E_40D7` |
| `1E:48C1` | `Data_1E_48C1` | `Tilemap_TopMenu_1E_48C1` |
| `1E:49A0` | `Data_1E_49A0` | `Gfx_TopMenu_Tiles8000` |
| `1E:4DA0` | `Data_1E_4DA0` | `Gfx_TopMenu_Tiles8400` |
| `1E:51A0` | `Data_1E_51A0` | `Gfx_TopMenu_Tiles8800` |
| `1E:55A0` | `Data_1E_55A0` | `Gfx_TopMenu_Tiles8C00` |
| `1E:59A0` | `Data_1E_59A0` | `Gfx_TopMenu_Tiles9000` |
| `1E:5BA0` | `Data_1E_5BA0` | `Gfx_TopMenu_Tiles9000Vb1` |
| `1E:5FA0` | `Data_1E_5FA0` | `Gfx_TopMenu_Tiles9400Vb1` |
| `1E:6320` | `Table_1E_6320` | `TopMenu_Anim1Frames` |
| `1E:63BA` | `Table_1E_63BA` | `TopMenu_Anim2Frames` |
| `1E:63FD` | `Table_1E_63FD` | `TopMenu_Anim3Frames` |
| `1E:6450` | `Table_1E_6450` | `TopMenu_Anim4Frames` |
| `1E:6526` | `Table_1E_6526` | `TopMenu_Anim5Frames` |
| `1E:6559` | `Table_1E_6559` | `TopMenu_Anim6Frames` |
| `1E:656F` | `Table_1E_656F` | `TopMenu_ObjTable` |

The nine generic resource labels had no remaining source or tool consumers.
The nine corresponding file records required 11 label-cell updates in
`gfx/assets.tsv`: each of the two tilemap/attribute pairs points at its shared
tilemap label, and the seven graphics records point at their existing VRAM
destination labels. The seven generic frame/object-table labels had no asset
catalog records. No local labels occur in the owner, and the used macros and
two RGB includes introduce no hidden symbol dependencies.

The 16 declaration lines were removed, taking the owner from 547 to 531 lines;
the existing resource data, frame tables, comments, and confidence levels are
unchanged. Frozen `config/`/`analysis/` snapshots and the historical rename
ledger retain old spellings as evidence. They are not active source or asset
catalog references.

The refreshed pre-edit generic-coalias census is
`.tmp/generic-coalias-post-ba4700c8-20261021/RESULT.json`: 716 candidates in
347 ASM/INC files, source-set SHA-256
`c12a9fc4e40c15b858371fabe192d1f25592bc9e58d1932a668d26781eb73a5f`. The
reviewed owner SHA-256 is
`2bb2b17f9cfda584ba25753bf3717e3414bb19a9368353e5f71acd6c49d18439`; the
updated catalog SHA-256 is
`66300b400d6a38c2684852de3ccf51f5172c1c5800f6e56926a20b2a495e4e05`.

Post-edit gates pass: `make` returned `RESULT: IDENTICAL` against the Japanese
ROM SHA-256
`6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`;
`make sym-check` passed with 12,845 labels and 51 constants;
`make palette-check` passed with 162 loads in 116 arrays, two documented
over-reads and zero errors; `make png-check` passed with 408 tile sheets,
4 raw byte views, 37 font sheets and 95 screen PNGs.

This is a bounded alias retirement. It makes no new claim about natural
execution or the semantic completeness of the top-menu animation data.
