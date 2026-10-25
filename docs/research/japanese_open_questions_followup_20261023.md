# Japanese entry and frame follow-up

## Bank 53 names and frame artwork

| Name index / Japanese label | Candidate window | Visual cue |
| --- | --- | --- |
| 00 ポリゴン | unresolved | No distinguishable Porygon artwork identified. |
| 01 ピカチュウ | 47:68F0 | Yellow head, long dark-tipped ears and red cheek. |
| 02 トゲピー | 46:4000 | Pointed egg-shaped body and head. |
| 03 ニャース | 46:4D50 | Cat face, forehead coin and whiskers. |
| 04 ルギア | 46:5AA0 | Pale elongated head and large side appendages. |
| 05 プリン | 46:67F0 | Round face, large eyes, ears and curled forelock. |
| 06 ワニノコ | 45:4000 | Small blue crocodile with open toothed mouth. |
| 07 エンテイ | 45:4D50 | Large beast with red/yellow crown-mask and pale mane. |
| 08 ハッサム | 45:5AA0 | Red angular creature with a large round-marked pincer. |
| 09 コダック | 45:67F0 | Duck-like head with wide bill and large eyes. |
| 10 ブラッキー | 44:4000 | Dark creature with yellow rings and red eye. |
| 11 マリル | 44:4D50 | Blue heads, round ears and pale belly. |
| 12 バンギラス | 44:5AA0 | Green spiny creature with dark belly. |
| 13 ハクリュー | 44:67F0 | Blue serpentine heads with a small horn and pale appendages. |
| 14 ウソッキー | 43:4000 | Brown tree-shaped figures with round green arms. |
| 15 ピチュー | 43:4D50 | Small yellow rodents with dark-tipped ears and cheek spots. |
| 16 レディバ | 43:5AA0 | Red insect with large eyes, antennae and spots. |
| 17 キレイハナ | 43:67F0 | Small figure with paired flowers on its head. |
| 18 ミュウツー | 42:4000 | Pale humanoid with pointed head and curved arm. |
| 19 ホウオウ | 42:4D50 | Red bird head, yellow crest and long beak. |
| 20 ソーナンス | 42:5AA0 | Blue elongated figures with compressed face and raised arms. |
| 21 ディグダ | 42:67F0 | Rounded brown heads with red oval noses emerging from ground. |
| 22 フシギバナ | 41:4000 | Broad green head, foliage and large flower. |
| 23 エーフィ | 41:4D50 | Lilac feline with long ears and forehead gem. |
| 24 ポリゴン２ | unresolved | No distinguishable Porygon2 artwork identified. |

The full-ROM scan found four occurrences of bytes `42 4E` and fourteen of
`54 4E`. These are raw words, not bank-qualified code edges. The complete
location list classifies them as follows:

| Physical bank:address | Word | Classification |
|---|---|---|
| `5F:4D12` | `42 4E` | Pointer to other-bank `Kbd_Anim6Script` at `5F:4E42`. |
| `77:6008`, `78:4CFB`, `7B:4C85` | `42 4E` | Font data in the named JIS 12x12 row sources. |
| `2D:4E4A` | `54 4E` | Operand of the sole bank-correct `CALL 4E54` at `2D:4E49`. |
| `2F:7AFB` | `54 4E` | Bytes within `Tilemap_AbookAddr`. |
| `4C:4F9F`, `4E:5335`, `4E:53BD`, `4E:53FB`, `4E:5456`, `4E:551E`, `4E:55F4`, `74:4211`, `74:421D`, `74:425E`, `74:426A` | `54 4E` | High-address/bank-byte crossings inside far-call payloads to bank `4E`, not references to bank `2D`. |
| `5F:4D1E` | `54 4E` | Pointer to other-bank `Kbd_Anim9Script` at `5F:4E54`. |

Reconciliation: one CALL operand, two other-bank animation pointers, four
font/tilemap data occurrences, and eleven far-call field crossings = eighteen
raw words. No `42 4E 2D` or `54 4E 2D` triple, absolute CALL/JP to `4E42`, or
same-bank relative branch into either candidate was found. `2D:4E54` has one
static CALL edge, but the caller `2D:4E42` has no established natural entry.
This closes the bounded literal-word scan only; computed pointers, stack
transfers, or unreviewed execution scenarios are not disproved.

### Bank 70:4740 against the retained 70-scenario corpus at `abb8e757`

`SaveCheck_GetStateBlockBit7` remains a PROBABLE local operation with HYPOTHESIS entry and role.

### Bank 70:4740 literal-target audit at `19edad18`

The three raw same-bank matches are all explained by existing data: `70:4DC0` is a byte-overlap between words in `CommScene_ObjAnimTable3` (`70:4DBB-4DCF`); `70:600D` and `70:5F4E` fall inside the confirmed tile asset `Gfx_CommScene_Tiles8800` (`70:5C90-6090`).

The only same-bank raw word whose value lands on an instruction boundary (`70:4750`) occurs inside that tile asset.

The full-ROM far-pointer scan found two overlapping byte triples for target
`70:475B`, at `4E:65C0` and `4E:65DF`. Neither is an aligned pointer: each
crosses the last two bytes of one 3-byte field and the first byte of the next
in `Data_Browser_FrameDesc2` (`4E:65BF`) or its byte-identical copy
`Data_Browser_FrameDesc3` (`4E:65DE`). The aligned fields target bank `47`,
including `47:5BA0` and `47:6870`; `70:475B` is not a frame-resource target.

## Additional code/data spans checked against the retained natural corpus at `1c9224e8`

| Span | Exact instruction starts in the 70 reports | `call`/`rst`/`jphl` edges to the span | Merged ROM-data-read ranges intersecting it |
|---|---:|---:|---:|
| `26:5344–537C` | 0 | 0 | 0 |
| `28:4BA6–4BC2` | 0 | 0 | 0 |
| `4B:76CC–76D0` | 0 | 0 | 0 |

## Bank 29:50CE exact-target scan at `9f077cd0`

To check for a direct literal pointer/call target to the wrapper without repeating the `29:511E` scan, the immutable Japanese ROM was scanned for every overlapping little-endian `CE 50` byte pair.

| Physical location | Bytes/context | Classification |
|---|---|---|
| `04:4760` | `3E 00 CE 50` | `CE 50` is the immediate operand of `ADC A,$50`, not a 16-bit address. |
| `04:4A32` | `3E 00 CE 50` | `CE 50` is the immediate operand of `ADC A,$50`, not a 16-bit address. |
| `27:502B` | `3E 00 CE 50` | `CE 50` is the immediate operand of `ADC A,$50`, not a 16-bit address. |
| `4B:6DE3` | inside `4B:6A90–6E90` | Bytes belong to `Gfx_SettingsPhone_ConfirmScreen_Tiles8800Vb1`, not a pointer table or instruction. |

## Mapper code-like candidates cross-checked against maintained assets

The remaining 250 rows have no overlap with `gfx/assets.tsv`; this crosswalk
does not classify them as code or data. The mapper file itself marks its
`code-like` hints as hypotheses and documents low positive rates in its
bounded hand samples. This batch resolves only the 14 listed mapper hints as
already represented asset bytes; their existing confidence levels and any
natural-load or frame-use questions remain unchanged. `make png-check` passed:
418 tile sheets, 4 raw byte views, 37 font sheets and 95 screen PNGs.
