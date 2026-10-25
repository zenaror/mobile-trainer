# Independent reference of the graphics retyping (retype1)

## 3. Round 2: data and operands

The `5E:4D00` table understated nine loads as three.

Both manually added OBJ names point to the claimed buffer (HelpMenu: `$D840`; BrowserMenu Obj4: `$D860`).

## 4. Round 2: tools and artifacts

The tool reader reproduced two checker false accepts on `71:4C50-$4C90`: splitting the palette into 8+56 bytes and adding a false excess sentence; or leaving a stale first header that contains the second fragment. The original tool accepted both.

Corrections in `tools/palette_reads_check.py`:

* Only **two independently reviewed exceptions** qualify: BG loads `4D:5510-$5550` and `4D:7570-$75B0` in `REVIEWED_OVERREADS`.

The reviewed current tree still reports **162 loads / 116 arrays / 2 documented over-reads / 0 errors**. The same load addresses against pre-pass headers produce 38 errors. The checker proves this structural contract over the extracted immediate loads; it does not prove status, semantics or completeness of the extractor.

Assets counted independently: **919 -> 949**, tiles **409 -> 406**, palettes **133 -> 144**, maps/attributes **169 -> 180** each. All 23 arrays' 53 touched original regions match the table. The inventory's 406 live tile counts match the assets; five removed rows have zero tiles. `screen_png derive` reproduced `screens.tsv`; export found all 92 screens byte-identical. Unknown headers above assets are rejected by `gfx_export check`; the `headers` repair is idempotent. `png_rules edited` is empty and `mk-check` passes.

The complete repository suite on the reviewed baseline has **37 checks: 36 rc=0; `apply_manual_sites --dry-run ramop7` rc=2**, the known obsolete record-format exception.

## 5. Limits and inherited typing work

* `5C:6350-$6420`: three correct `.pal` assets of 64 bytes each, then a 16-byte object record under an old tile header.
* Browser start-choice explicit sources: map `73:438F-$43AD` / attrs `$43D5-$43F3`, map `$43F3-$441B` / attrs `$4439-$4461`. These are not contiguous pairs.
* Browser start-choice animation: five 5 x 7 maps `$447F-$452E` and attributes `$452E-$45DD`; old headers split the attributes and classify part as tiles. Proof is the computed pointer in `BrowserStart_AnimateFrame` (`73:6265`).
* `22:5CD0-$66D0` tile windows under palette/unknown headers, and `25:6AC8-$6BD1` unknown data inside tile windows. An HDMA read alone does not prove exclusive tile content: `26:7AB0-$7ABC` includes a sprite object over-read and must not be retagged mechanically.
