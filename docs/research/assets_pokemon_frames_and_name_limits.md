# Pokémon graphic windows and name-table limits

## Byte facts and model provenance

Bank 53:4000 contains 25 little-endian pointers (50 bytes) followed by25 Shift-JIS/NUL strings (319 bytes), ending4171. Own decode/reemit reproduces all 369 bytes. The maintained table/header's “no reader found” is a finite historical statement, not proof of no computed reader.

The bank 41–46 loop describes24 physical windows of stride 0D50. A further window47:68F0–7640 has 2560 tile bytes, 360 tilemap bytes at72F0,360 attributes at7458 and 128 palette bytes at75C0. Its current editable PNG already exists: `gfx/browser/frames_2_3/tilemap_72f0.screen.png`. All 360 cells select bank 1 with tile number below 128; the declared 160-unsigned and 128-signed models select the same byte/palette sources for every cell, and the existingPNG matches the own model in all 23,040 RGB pixels. This proves conditional composition identity, not an executed loader.

The 27-style table4E:654B selects five 31-byte descriptors but only three distinct sets of five far pointers, all in bank 47 (record starts4100/4E50/5BA0). It does not select 68F0, point into bank 41–46 or reference the bank 53 name table. The physical fourth record remains HYPOTHESIS. Its visual identity remains unproved; no species name or image/name mapping is adopted from visual resemblance. The counts 25 names and 24+1 windows neither establish a bijection nor shared order.

## Locator-only contacts

![25 physical windows, labels are bank:record addresses; H means HYPOTHESIS](assets/browser_frame_windows25.png)

The first 24 cards use the 160-tile editing model, with unresolved cells pink. The last card is 47:68F0. Card order is address order, not name-table order or a menu order.

![Four bank 47 physical records, descriptor and hypothesis provenance](assets/browser_frame_records47.png)

D marks the first three windows selected by maintained descriptors; H marks 47:68F0, outside that table. These images use the 128 BG signed/menu/32OBJ model; unprovided cells are pink. D describes static pointer/load provenance, not CONFIRMED natural reachability.

## Name-table order, no image assignment

| index | address | Shift-JIS text | image assignment |
|---:|---|---|---|
|0|53:4032|　　ポリゴン|unproved|
|1|53:403F|　ピカチュウ|unproved|
|2|53:404C|　　トゲピー|unproved|
|3|53:4059|　　ニャース|unproved|
|4|53:4066|　　ルギア|unproved|
|5|53:4071|　　プリン|unproved|
|6|53:407C|　　ワニノコ|unproved|
|7|53:4089|　　エンテイ|unproved|
|8|53:4096|　　ハッサム|unproved|
|9|53:40A3|　　コダック|unproved|
|10|53:40B0|　ブラッキー|unproved|
|11|53:40BD|　　マリル|unproved|
|12|53:40C8|　バンギラス|unproved|
|13|53:40D5|　ハクリュー|unproved|
|14|53:40E2|　ウソッキー|unproved|
|15|53:40EF|　　ピチュー|unproved|
|16|53:40FC|　　レディバ|unproved|
|17|53:4109|　キレイハナ|unproved|
|18|53:4116|　ミュウツー|unproved|
|19|53:4123|　　ホウオウ|unproved|
|20|53:4130|　ソーナンス|unproved|
|21|53:413D|　　ディグダ|unproved|
|22|53:414A|　フシギバナ|unproved|
|23|53:4157|　　エーフィ|unproved|
|24|53:4164|　ポリゴン２|unproved|

## Finite consumer confrontation

Own 343 ASM + 5 INC source scan finds Table_53_4000 only at its definition; String_53_4032 occurs at its definition and the first dw in the same table. No BANK expression of a current bank 53 symbol was found. Six literal `ld a,$53` sites immediately store to hTextY (account/confirm_screens:514) or wSpriteSlot2 (browser/page_list:685/880/894/2216/2578); those six instructions do not select ROM bank 53. Three adjacent exact ROM patterns2100403e53,3e53210040,004053 had zero matches. These observations cover only their stated source/symbol/pattern scope. They do not exclude arithmetic, delayed bank changes, computed pointers, runtime copying or unobserved paths. No missing callergraph was reconstructed and no new natural scenario was captured.

Keep image/name assignment, purpose of unused layouts and natural reachability HYPOTHESIS. A missing preview, fragmentary tile extraction or absent literal pattern must not be promoted to a missing ROM resource. All 947 active assets already reproduce original bytes; this audit changes only documentation and the two explanatory contacts. Actual integration, later publication and any new runtime evidence are separate ROOT operations.


## Descriptor suffix consumers and composition limits

The following is a PROBABLE static consumer derivation from the original bank 4E bytes and maintained source. It qualifies the conditional image models above; it does not add a natural observation or change any storage status. Descriptor 1 at 65A0 retains its separately documented CONFIRMED evidence: all31 bytes were read collectively across15 historical natural scenarios; this is not a claim that each call reads all31 bytes. The other four descriptors retain their current PROBABLE headers.

The five descriptors at 6581/65A0/65BF/65DE/65FD have the same 31-byte layout. Their first 15 bytes are five address/bank triples; all source banks are 47. The following 16 bytes contain three WRAM7 map destinations and five X/Y pairs, rather than more far pointers. Values below are hexadecimal; each row is two bytes.

| offset | field | original values across the five descriptors | consumers and first read sites in ROM4E |
|---|---|---|---|
| 0F | body-map destination | D061 in all five | ClearBodyArea 612B: read6141; ReloadFrameTilemap: read5DAF; preview reads6347/64B3 |
| 11 | title-map destination | D004 at6581/65A0/65FD; D002 at65BF/65DE | ClearTitleArea 60E4: read60FA; ReloadFrameTilemap: read5DE6; preview reads637D/64F9 |
| 13 | up-arrow X,Y | 48,10 in all five | ShowUpArrow 5F58: read5F8C |
| 15 | down-arrow X,Y | 48,78 in all five | DrawScrollIndicators 5EC0: read5F2B |
| 17 | timer X,Y before reader adds08/10 | 70,80 at6581/65A0; 71,7A at65BF/65DE; 70,7E at65FD | DrawCommTimer 5FB9: read5FEB |
| 19 | connection-icon X,Y | 08,00 at6581/65A0; 84,00 at65BF/65DE; 00,00 at65FD | ConnIcon_StartSprite 604C: read607E; unproved-entry getter6087: read609F |
| 1B | scrollbar-map destination | D073 in all five | DrawScrollbarTrack 5E11: read5E32 |
| 1D | scroll-thumb X,Y base | 98,18 in all five | UpdateScrollThumb 5E5B: read5E76 |

`Browser_LoadFrameGraphics` at6196–6291 directly consumes only offsets00–0E, but its complete call path also uses suffix fields. Its calls at625F/6265/626B target ClearBodyArea612B, ClearTitleArea60E4 and DrawScrollbarTrack5E11. The first two read0F/11 and fill map rectangles through4F:45C6; they also clear the body/title tile canvases through4F:4604. The track helper returns early if the scrollbar is disabled. Its enabled path reads1B, writes the track and attributes in WRAM7, and falls directly from the loop ending5E5A into UpdateScrollThumb5E5B, which conditionally reads1D. Consequently “MAIN reads only15 bytes” is valid only for the direct6196–6291 body, not its full helper path. Arrow, timer and connection-icon consumers are additional routines; this does not claim they are all invoked by that loader.

All descriptor table reads above require ROM4E mapped. FarCall00:06D1 saves and restores the caller ROM bank around its inline target; resource transfers temporarily select the bank47 sources. Tilemap_FillAscendingWithAttr4F:45C6 explicitly selects WRAM7 and restores its incoming WRAM bank. DrawScrollbarTrack explicitly selects WRAM7; TileCanvas_FillRect4F:4604 instead writes tile staging banks2/3 and restores its incoming WRAM bank. These destination effects must not be confused with descriptor or source-ROM banks.

`Browser_FrameStylePreview_LoadGraphics` at6291–6543 has four direct suffix queries, all to0F/11. They use two selectors in distinct phases:

Rectangle dimensions in the next table are decimal; attributes, tile starts, addresses and offsets are hexadecimal.

| phase | selector | offset/read site | map fills |
|---|---|---|---|
| before SRAM3 snapshot | hFramePreview_Style | 0F/6347 | 5x18 at destination and7x18 at destination+A0; attribute04, tile starts20/80 |
| before SRAM3 snapshot | hFramePreview_Style | 11/637D | two1x15 rows at destination and destination+20; attribute01, tile starts00/0F |
| after tile-bit and attribute remapping | wBrowserFrameStyle | 0F/64B3 | same body geometry; attribute07, tile starts20/80 |
| after tile-bit and attribute remapping | wBrowserFrameStyle | 11/64F9 | same title geometry; attribute00, tile starts00/0F |

The first pair precedes the0800-byte WRAM7 map snapshot to SRAM3:B000. The later pair follows the6477 tile-bit loop and6486 attribute lookup. The latter body phase also fills the body canvas withFFFF; the title phase clears its canvas with0000 before the final uploads. This routine does not directly consume every byte of the16-byte suffix. Its maintained PROBABLE status and forced-only evidence remain unchanged.

The MAIN placement and PREVIEW pair pixel models are conditional fixtures for their declared transfers and map choices. They do not model all helper map/canvas mutations, uploads, sprites or reveal steps, and are not full-procedure predictions. The complete47:68F0 editing PNG still matches its own declared composition in23040 RGB pixels; that physical record is absent from the three far-pointer sets selected by the27 words. None of these facts supplies an observed LCDC mode, a species assignment, an image/name order or natural reachability for the fourth record.

The finite69-scenario coverage union records execution of the MAIN first-pointer reader61DD and the named body/title/track/thumb readers, while the four preview suffix readers have no rows. This instruction metadata does not identify which descriptor supplied a given read, reestablish whole-descriptor data coverage, or prove absence of other paths. The existing descriptor1 natural-data-read result remains the separate authority for its CONFIRMED header.

Verification, 2026-10-11: the private candidate and the actual MAIN checkout each completed the canonical37 profile (36 checks rc0; the documented ordinal27 negative case rc2 with its exact97-byte diagnostic). All4246 source files held during each run, and all671 build outputs matched the newly reconstructed d6a01a0 baseline byte for byte. `make` reported SHA-256 OK / RESULT: IDENTICAL; symbol and palette checks passed. This pass changes documentation only. No new runtime capture, species association, natural-reachability or hardware claim is made.


## Representation of the four remaining descriptors

The units at 4E:6581, 65BF, 65DE and 65FD use the same existing dw/db field representation as descriptor 1. Each retains 31 original bytes: five ROM47 far pointers, three WRAM7 map destinations and five X/Y pairs. Their four PROBABLE headers and all semantic/neutral aliases remain exact. Descriptor 1, the 27 table words, all instructions and all asset bytes/statuses are unchanged. The suffix consumer and conditional composition qualifications above still apply.

Own symbolic reemission from the current resource-label addresses, BANK values and WRAM7 base reproduces all 124 scoped original bytes. This is a bounded data-format check; ROM build/comparison is a separate gate. Eight literal db rows become 72 dw/db directives; the owner grows from 571 to 635 physical lines. All 19 literal maintained owner locators in the finite scan of 1,079 tracked non-config TSV files precede the changed data and retain their exact instructions and physical lines. The four manual-site manifests selected by canonical37 contain no owner mention. Label-scoped overlays retain their exact pre-data ranges, and five preview tile_ops fields remain counts. No metadata row requires rebinding.

This candidate is based on published 0eeb205. New private build, ROM/SYM/MAP comparison, relocation review, canonical37, independent review and ROOT integration/publication remain pending. The owner object may change when numeric pointer bytes become linker expressions; those differences require measurement against this parent. Descriptor 1's collective natural-read evidence does not promote its four siblings. No execution or hardware evidence is added.

## Bounded inventory of 25 physical frame windows

The current active catalog contains 947 assets totaling 607,576 bytes, reemitted exactly against the original ROM. The separate global presence check found all 442 distinct editable PNG files; that does not claim reemission of all 442 PNGs. For the 25 physical windows in banks 41–46 (four $0D50 strides per bank) plus 47:68F0, own PNG decoding/reemission verified the 39 tile-sheet PNG sources that intersect those windows. All 25 tilemaps (360 bytes each), attribute maps (360 bytes each) and palettes (128 bytes each) are catalogued and original-exact.

Fourteen windows have existing complete editing views, checked against all 23,040 conditional model indices and the first 32 RGB palette entries. Eleven lack a complete editing view: eight existing composition models resolve only 114 or 144 of the 360 map cells, and three additional windows have fragmented tile sources in bank 42. All four bank-42 tile windows are fragmented, including one of the eight partial cases. Their 2,496 bytes outside the active catalog remain represented exactly in maintained source: 71 bytes of partial tile-tail db, 2,409 ds zero bytes and 16 unclassified FF db bytes. This is a source/catalog boundary, not missing ROM bytes or proof of missing artwork.

The legacy unused-preview family has all 24 listed rows and 24 PNG files. It omits the fourth bank-47 record at 68F0, whose editing PNG already exists. These records/windows and pixel models do not prove selection by the 27-descriptor table, natural execution, species/name associations or completeness of all ROM graphics. The unselected windows keep their conditional/HYPOTHESIS qualification; no asset or descriptor level is promoted.

### ROOT adoption of the typed descriptor pass

The four 31-byte PROBABLE descriptor bodies now express their existing fields with word, bank and byte directives. Independent object decoding resolves the 40 new relocation fields and recovers the complete parent section. One private staged canonical37 and one ROOT actual canonical37 each produce the expected 36 rc0 plus ordinal27 rc2/exact97-byte diagnostic; all671 ROOT outputs equal the private candidate, with670 equal to parent0eeb and only frame_graphics.o changed. Original ROM/SYM/MAP remain identical, as do all raw assets. The asset25 conclusions retain their finite source/emission and conditional-model limits. No Pokemon-name/frame bijection, natural reader, visual validation or hardware evidence follows. This result appendix is added only after the ROOT terminal, without another build.

### Ordinal presentation of the bank-53 name table

The existing 25-entry table at 53:4000 now uses symbolic pointers to PokemonName00 through PokemonName24, labels for the existing string starts at 4032 through 4164. Table_53_4000 and String_53_4032 remain aliases. Own reemission using the maintained Shift-JIS charmap preserves all 50 pointer bytes and 319 string bytes, including the original spacing and NUL terminators. The owner grows from 67 to 92 physical lines; no emitted byte or existing address changes. Both original PROBABLE headers remain unchanged.

The ordinals describe this text table only. They do not establish an association with the 27 descriptor-table rows, the five descriptors or the 25 conditional physical frame windows. No computed reader, natural selection, species/frame assignment or confidence promotion is inferred. The finite active-manifest and non-config TSV audit finds no affected physical proof locator. Executable verification and the predicted additions of 25 symbols and 24 word relocations remain pending until the authorized staged pass measures the resulting ROM, SYM, MAP and owner object.


### ROOT integration of bank53 ordinal pointer labels (2026-10-11)

The original bank53 name table now uses25 ordinal PokemonName00..24 aliases and symbolic word pointers. Existing aliases, the319-byte Shift-JIS/NUL text block, table order and all369 bytes remain unchanged; source classifications remain PROBABLE. A reader or a name-to-frame association has not been established. One private staged canonical37 and one ROOT actual canonical37 each completed with36 rc0 results plus the documented ordinal27 rc2/exact97-byte diagnostic. The initial private post-check5 measurement assumed ascending object-patch serialization and failed; actual serialization is48 down to0. Its failed terminal was preserved, an independently reviewed DATA-only finalizer associated patches by their unique offsets, and the same37-check BEGIN resumed at6 without replaying versions or checks1–5. Independent complete RGB9 decoding verifies25 new exports,24 additional word relocations and all symbol/patch metadata, resolving the entire369-byte section to the original. All671 actual outputs equal the reviewed private candidate;668 equal MAIN454e0fe, while the owner object, SYM and MAP change only as measured. Removing the25 aliases from SYM/MAP recovers their literal parent files. Make reports SHA-256 OK and RESULT: IDENTICAL; symbol checking reports15563 labels and51 constants, and palette checking passes. The private43 logs contain444 ResourceWarning occurrences; expected check results are unchanged. These documentation appends follow the completed ROOT terminal without replay. Publication and fresh verification follow, without new natural-flow, LCDC, species, rendered or hardware evidence.

### Unselected frame windows: editing views and legacy models

The following eleven physical windows have no declared editing PNG. All of their 360-byte tilemaps, 360-byte attribute maps and 128-byte palettes are preserved as exact original assets. The cell counts below describe the conditional model that places 160 physical tiles at VRAM1:8000 with unsigned addressing and uses the first64 palette bytes for BG colours. No loader of these windows has been established by this finite audit. Unknown cells need an unprovided VRAM-bank0 source or a tile index outside the assumed 160-tile window; they are not missing ROM bytes.

| Window base | Tilemap | Conditional known / unknown cells | Tile bytes in catalogue / outside catalogue | Current omission |
|---|---|---:|---:|---|
| 41:5AA0 | 41:64A0 | 144 / 216 | 2560 / 0 | Below the 180-cell threshold |
| 41:67F0 | 41:71F0 | 144 / 216 | 2560 / 0 | Below the 180-cell threshold |
| 42:4000 | 42:4A00 | 360 / 0 | 1680 / 880 | No single 2560-byte asset |
| 42:4D50 | 42:5750 | 360 / 0 | 2560 / 0 | No single 2560-byte asset |
| 42:5AA0 | 42:64A0 | 114 / 246 | 1984 / 576 | Fragmented sources and below 180 cells |
| 42:67F0 | 42:71F0 | 360 / 0 | 1520 / 1040 | No single 2560-byte asset |
| 43:4D50 | 43:5750 | 144 / 216 | 2560 / 0 | Below the 180-cell threshold |
| 43:67F0 | 43:71F0 | 144 / 216 | 2560 / 0 | Below the 180-cell threshold |
| 44:4D50 | 44:5750 | 114 / 246 | 2560 / 0 | Below the 180-cell threshold |
| 45:4D50 | 45:5750 | 144 / 216 | 2560 / 0 | Below the 180-cell threshold |
| 46:67F0 | 46:71F0 | 114 / 246 | 2560 / 0 | Below the 180-cell threshold |

The eight partial cases remain below the current 50% inclusion threshold. Bank42 also has fragmented tile sources in all four physical windows. The three full-cell cases are omitted because derive_records requires one2560-byte tile asset at the window base. In 42:4D50, however, four existing aligned assets cover all 2560 bytes (27 + 60 + 2 + 71 tiles), and the existing view/import model can map the parts separately. That is a bounded future conditional-view opportunity, not a new editing PNG, a proved loader or a change of content classification. Other bank42 gaps remain exact maintained db/ds/unclassified bytes; no retyping or extraction follows from this pixel model.

All 24 existing legacy unused-preview PNGs reproduce the own browser-style model in all 23,040 RGB pixels each. That model places 128 BG tiles at VRAM1:9000/9400, loads 64 shared browser-menu tiles from 72:6C10 at VRAM1:8800 and places the record's 32-tile piece at VRAM0:8000. Its addressing is selected by unsigned/signed loaded-slot coverage when there is no capture; that heuristic does not establish LCDC.bit4. The loader 4E:6196 preserves bit4 with AND9F. The legacy unresolved=0 field counts unresolved operations, not whether every displayed cell has a supplied tile slot. The legacy model and the160-unsigned editing model therefore have different meanings.

The legacy family loop covers banks 41–46 only. The separate unselected physical window begins 47:68F0; its tilemap is 47:72F0 and its existing editing PNG is gfx/browser/frames_2_3/tilemap_72f0.screen.png. Those two addresses name the window base and its map respectively. The maintained 27-word descriptor table selects only three bank 47 resource bases and does not select this fourth window. No new species/name association, natural execution, confidence promotion or claim of whole-ROM graphics completeness is made.

### Verified finite audit of unselected frame views (2026-10-11)

One private and one ROOT integration canonical37 each completed with36 zero return codes and the known ordinal27 rc2/exact97-byte diagnostic. All671 rebuilt outputs equal published MAINa4d374c, including every object, SYM, MAP and the original ROM; all4246 frozen sources remained as reviewed during testing. The private43 complete logs contain444 ResourceWarning occurrences; these warnings are recorded. Independent DATA decoder assertions about palette/attribute-map representation and an invented readonly-log mode were preserved and corrected before final receipts, without source changes or gate replay. This DOC3 pass records the eleven editing-view omissions,24 complete legacy pixel-model comparisons and the distinction between window47:68F0 and tilemap47:72F0. It adds no PNG, loader, LCDC, species/name association, natural-flow or hardware evidence. A separately reviewed future view can combine the four existing aligned assets of42:4D50; no ROM bytes are missing there.

### Bank42: conditional composition from four complete tile assets

The editing catalogue adds only `bank42/tilemap_5750`, whose physical window starts42:4D50 and whose map starts42:5750. Four existing contiguous assets (27+60+2+71 tiles) supply all2560 tile bytes before the360-byte map,360-byte attribute map and128-byte palette region. The composition remains HYPOTHESIS: unsigned tile numberk is assumed to select record tilek in VRAM bank1, and BG palettes0–7 use the first32 words of the64-word palette region. All360 cells resolve within that model; this supplies no original loader or LCDC.bit4 proof.

The derivation retains the old single2560-byte asset branch and all15 earlier record rows. A fallback accepts only aligned contiguous complete assets: every coalesced load starts at asset tile0 and its count times16 equals the declared physical size. It rejects partial boundaries, gaps and padding. This adds one catalogue row while retaining all92 earlier screen rows,947 asset rows and442 tile/font PNG sources. The71-tile final sheet has nine padding tiles, which the declared physical extent excludes.

Ten earlier bank41–46 editing-view omissions remain. The other bank42 fragments and all db/ds/unclassified bytes retain their source and classifications. This conditional composition does not associate frames with names or species, establish a natural rendering result, or claim whole-ROM graphics completeness. The separate47:68F0 window and47:72F0 map retain their existing editing view.

### Verified conditional bank42 editing view (2026-10-11)

One private and one ROOT integration canonical37 completed with36 zero return codes and the expected ordinal27 rc2/exact97-byte diagnostic. All671 outputs equal published MAINb833350, including every object, SYM, MAP and the original ROM; all4247 candidate sources held during testing. The unique targeted derive/export/import dry-run added one2340-byte indexed PNG and reported zero tile/palette changes. Its complete23040 indices and RGB pixels match an independent original-ROM model. The private43 logs contain444 ResourceWarning occurrences; ROOT37 logs contain444 occurrences. These observational warnings are recorded. Readonly receipt assertions about PNG mode, post-seal artifact writes and the pre-latch ordinal1 flag were corrected without source changes or gate replay. The view remains HYPOTHESIS under the declared addressing/palette assumptions; no loader, LCDC, species/name association, natural rendering or hardware proof is added.


## Bounded selection, LCDC inheritance and canvas availability

The following source/ROM audit uses published ef41bff as its fixed reference. It adds no runtime capture or preview. The 27 original words at4E:654B select6581 for index0,65A0 for1,65BF for2,65DE for3–22 and65FD for23–26. Each of the five far fields in each selected descriptor uses bank47. Thus this bounded table selects only the4100/4E50/5BA0 resource families, including their palette/map/OBJ fields; it supplies no bank41–46 window or47:68F0. This does not rule out another computed consumer outside that selection chain.

The three located MAIN call sites are4E:49A7 (PageView_Enter),4E:4E95 (PageList_BackToMenu) and4C:4F8F (MobileDictView_Show). The home-page and staged-URL starters store style1, the SRAM-URL starter stores0, and the dictionary viewer stores2 before MAIN. SaveCheck_Verify rejects a persisted low-seven-bit style of0 or at least1B after its other checks. Browser_BeginSession masks7F and substitutes1 only for0; that body supplies no upper bound. MAIN likewise masks7F without a local upper bound. The preview site4E:4002 reaches PREVIEW, which masks its external hFramePreview_Style input without a local upper bound: values27–127 are outside this documented table. Validation must follow the actual caller chain. The preview entry remains HYPOTHESIS and PREVIEW retains its existing PROBABLE/forced-only evidence.

LCDC addressing is a reaching-state question. Boot_ClearAndInit and Boot_ReinitRuntime explicitly write83 at4F:4798 and47A7, establishing bit4=0. The direct loader mask9F, LCDOff's direct mask7F, LCDOn's OR80, and the inspected menu/window transforms preserve entering bit4. The keyboard/dialog transform that copies inverted bit3 into bit6 also preserves bit4; all256 byte inputs satisfy these six inspected transformations. A path established by boot83 and confined to the preserving writes and valid callback/vector state therefore has signed BG addressing. This conditional static result is not a freshly observed loader-entry state. Gfx_StartHDMAWithService can call Sound_FrameService, while interrupt handlers can chain through saved RAM stubs; those state/provenance prerequisites remain outside a complete reaching-path proof. Forced preview entry alone establishes neither its inherited LCDC state nor selection of any omitted window.

MAIN's transfer prefix is also smaller than its canvas effects. Browser_ClearBodyArea and Browser_ClearTitleArea fill their staging rectangles with DE0000 through4F:4604. Upload arguments decoded from4E:60A6/60C5 select VRAM bank0 and supply zeroed canvas tiles in half-open ranges9000–91E0,9200–97A0 and8800–8FE0. The body map fills replace rows3–14, columns1–18, with attribute00 and tile IDs20–79 then80–FD. Title fills replace rows0–1, fifteen columns beginning at2 or4, with attribute01 and IDs00–1D. These coordinates come from the existing valid descriptor geometry; substituting one of the omitted physical windows is hypothetical.

An independent coordinate census considers only original cells that are unknown under the signed transfer-prefix availability model, then accounts for this map-clear/zero-canvas subset. “Replaced” counts cells whose original map entry is overwritten; “supplied” counts unchanged original cells whose requested bank0 slot receives a zero canvas tile. Both title-column positions are evaluated. Counts are not a procedure renderer or recovered frame art.

| Physical window | Prefix unknown | Replaced, title2 / title4 | Original slot supplied, title2 / title4 | Still unknown, either position |
|---|---:|---:|---:|---:|
|41:5AA0|216|216 /216|0 /0|0|
|41:67F0|216|216 /216|0 /0|0|
|42:4000|0|0 /0|0 /0|0|
|42:5AA0|246|234 /230|0 /4|12|
|42:67F0|0|0 /0|0 /0|0|
|43:4D50|216|216 /216|0 /0|0|
|43:67F0|216|216 /216|0 /0|0|
|44:4D50|246|244 /244|2 /2|0|
|45:4D50|216|204 /204|12 /12|0|
|46:67F0|246|244 /244|2 /2|0|

For42:5AA0 the remaining twelve original cells are rows3–14,column0, requesting VRAM1:8E70. The subset does not supply that slot. Nine windows have no remaining original prefix-unknown cells after these conditional operations; this does not establish a full procedure output, scrollbar/text/IRQ/PPU closure, a natural rendering result or an original selector for these windows. In particular, prefix unknown counts cannot be reused as whole-procedure unknown counts, and a supplied zero canvas is different from recovering omitted graphic content.

## Bank42 physical source gaps and editable boundaries

Own literal emission of gfx/bank42.asm, including INCBIN assets, RGB palette includes and raw db/ds, reproduces all13632 original bytes at42:4000–7540. All30 emitted asset extents have matching active catalogue rows and physical sizes; the directory's binary/palette files are exactly those30 assets. No omitted emitted INCBIN or forgotten existing binary asset was found in this finite inventory. The three gap-bearing2560-byte physical windows partition as follows; “outside catalogue” describes representation, not missing ROM bytes.

| Window | Declared tile-asset bytes | Outside catalogue | Explicit source partition |
|---|---:|---:|---|
|42:4000|1680|880|871 ds zero bytes +9 db bytes in a partial gfx tail|
|42:5AA0|1984|576|538 ds zero bytes +38 db bytes in partial gfx tails|
|42:67F0|1520|1040|1000 ds zero bytes +24 partial-tail db bytes +16 separate unclassified FF bytes|

The remaining42:4D50 window has all2560 bytes in four aligned complete assets and already has its separately qualified editing view. Across the three other windows,2496 bytes remain explicitly represented as2409 ds zero bytes,71 partial gfx-tail db bytes and16 unclassified FF bytes. Their existing HYPOTHESIS/PROBABLE headers and raw classifications are retained; zeros or FF patterns alone do not establish tiles or padding semantics.

Assets beginning at4802,5F92 and6FF2 start two bytes into their physical window's16-byte grid. Their whole local tile chunks cannot simply become window tilek without accounting for neighbouring bytes and rephasing. Existing tile sheets also contain sheet-only padding: nine cells for the71-tile52E0 asset, five for59 tiles at5AA0, seven for25 at6810 and fifteen for49 at69B0. Catalogue/rule sizes, padding counts, file hashes and all18 bank42 tile-PNG headers/CRCs agree; this header/extent audit is not a PNG pixel reemit. Those padding cells are outside the declared ROM asset extents and cannot fill any physical gap.

The current fragmented-record derivation requires all160 physical tile starts to belong to aligned declared whole-tile assets and each coalesced load to cover exactly one complete asset. The three gap-bearing windows fail those requirements. Their raw source bytes could support a separately qualified read-only numeric composition, but current editing imports write existing tile sheets rather than db/ds or cross-boundary chunks. A future editable view needs exact byte/VRAM placement, tile alignment, backing for every edited tile, bounds excluding sheet padding, palette/attribute rules and unknown-cell handling. It must not acquire a loader, LCDC mode or classification merely from a successful composition.

This audit closes the finite missing-source/forgotten-binary question for bank42, the documented27-entry selector partition, direct bit4-preservation mechanics and the twenty conditional canvas subsets. The ten missing editing views, complete caller/vector/LCDC reaching proof, unresolved42:5AA0 slot, raw-byte semantic roles and all25-name/frame/species associations remain open. The25 bank53 ordinals,27 descriptor rows, five descriptors and25 physical windows still do not establish a bijection. No source or asset retyping, PNG generation, new natural observation or confidence promotion accompanies this documentation proposal.

## Independent finite frame and PNG inventory (published source eebd63fd, 2026-10-13)

A separate DATA-only reader checked the published 4,812-file source snapshot against the original ROM and current PNGs. **CONFIRMED within this finite inventory:** the 25 physical windows each contain 3,408 bytes (85,200 bytes total); their source fragments reemit the original window bytes, and 39 intersecting tile PNGs reemit their declared asset bytes. Bank 53 has a separate 50-byte table of 25 pointers and 319 bytes of Shift-JIS/NUL strings; bank 4E has 27 selector words and five descriptors. These counts describe distinct structures, not a mapping between them.

Under the documented conditional addressing, load and palette models, 24 legacy previews match 552,960 RGB pixels, while 15 editing PNGs match 345,600 pixel indices and RGB values. The legacy previews and editing views use different models and serve different purposes; matching pixels do not prove a natural loader entry state or hardware display. The independent receipt is `OWN_FRAME25_INDEPENDENT_REVIEW.json` (SHA-256 `7d1ced8f8597bd9dd58a609bbe9d3f6fd71ade1575e71b33d1d2fafa3d5912e4`); its tuple/list readback erratum was resolved without changing the receipt bytes.

The ten absent **editing views** are 41:5AA0, 41:67F0, 42:4000, 42:5AA0, 42:67F0, 43:4D50, 43:67F0, 44:4D50, 45:4D50 and 46:67F0. Each still has original ROM bytes and a legacy preview. This finite coverage finds no absent original ROM resource in the audited windows; it does not establish whole-ROM graphics completeness, a name/frame/species bijection, selector order, absence of a computed reader, natural reachability, LCDC state or hardware rendering. Bank 42 raw `db`/`ds` spans are not thereby promoted to editable tile sources.

## Product-checked conditional bank42 RAW byte views (private staging, 2026-10-13)

The reviewed private source extends published MAIN `2e0f3fff688f70a48063ff72be496d570574fa51` with two complete editing views under the declared **HYPOTHESIS** model: unsigned tile numbers select record tile k in VRAM bank 1, and BG palette groups use the first 32 words of the record palette. Every one of the 360 cells in each view has a bounded backing source. This closes two of the ten editing-view omissions in the preceding published-source inventory under that model; it does not identify an original loader, LCDC state, rendered species or natural entry state.

| physical window | map / attributes / palette | conditional editing PNG | referenced record slots |
|---|---|---|---|
| 42:4000 | 4A00 / 4B68 / 4CD0 | `gfx/bank42/tilemap_4a00.screen.png` | 0–85 |
| 42:67F0 | 71F0 / 7358 / 74C0 | `gfx/bank42/tilemap_71f0.screen.png` | 0–77 |

Four neutral binary backings expose exactly 80 existing bytes through an explicit reversible 2bpp byte-view codec: 32 zero bytes at 42:4540–4560, 16 zero bytes at 42:6800–6810, 16 `$FF` bytes at 42:69A0–69B0 and 16 zero bytes at 42:6CC0–6CD0 (end addresses exclusive). Source `INCBIN` qualifiers retain the original raw/zero HYPOTHESIS headers, labels and region boundaries, including `Data_42_69A0`; residual `ds` spans retain their original extent. Storage is `raw`, purpose remains UNKNOWN, and the codec does not promote these bytes to a semantic tile class. The 42:4000 view combines the existing 84-tile asset with the two raw byte-view cells; 42:67F0 combines the existing 1/25/49-tile assets with three one-cell raw backings. Unreferenced gaps and rephased fragments remain untouched.

The active catalogue now has 951 assets and 95 screen rows: all 947 prior asset rows and 93 prior screen rows remain exact, with four raw/HYPOTHESIS assets and two HYPOTHESIS screen rows added. All 946 prior PNG-rule rows remain exact; four explicit `raw2bpp` rules are added. Physical bounds exclude sheet padding. The RAW BIN converter uses a path allowlist, refuses linked or multi-linked output leaves and pre-existing fixed `.bin.tmp` entries, and finalizes only its own exclusive temporary in the private single-writer tree. Its tested contract does not cover an uncooperative concurrent writer or all legacy PNG writers.

ROOT executed the reviewed product-fixture runner once: 21 groups PASS, with group 15 explicitly `DEFERRED_ROOT_NATIVE`, and 145 route receipts. Product calls verified 20,480 codec inverses, 46,080 exported indices across the two views, unchanged imports, 93 legacy screen roundtrips, preserved 947 legacy assets, shared-key collisions, palette groups, exact byte extents and RAW CLI/graphics-export/Make guards. Flip flags, UID mismatch and identity/temporary replacement hooks were synthetic fixtures using owned external sentinels; they establish no new ROM execution or hardware observation. The accepted result receipt is `ROOT-PRODUCT-ACCEPTANCE.json`, SHA-256 `77095b9a989e8227527470527a671c39decd0dd512630b0c28fa82403290513d`; `RESULTS.json` is `d5ef62eed38dff96ca5297d4fa3887cc6cedaf54cbfb10c40b412d2660a635ea`.

ROOT then generated only the two final PNGs in the private source. Their complete bytes equal the accepted fixture exports: 1,664 bytes / SHA-256 `635a3e20c938c51baac5b1bf4451fde0c5b9cd4b249eb63e1aa003572f925a9b` and 1,722 bytes / `f29f4456c3170b8d6c0f60eb63b84cfe7c5ddb93f87faef28e3fc130f9f639bc`, respectively. `ROOT-SOURCE-PNG2-ADOPTION.json` is `91480d0ec9cb299f9afb59b87fd3efccf7bbcd99b8a1fe94b5c1c4c83e8777bc`; the prior 4,822 private source files remained unchanged. At that initial product stage, directive reading correlated all 13,632 bank42 bytes with the original ROM while native parity was pending. After the marked-build fixture copy gained `raw_png.py`, the corrected private 27-path source completed Japanese37 plus English3, reproducing the byte-identical original ROM and unchanged English ROM/checksum. That accepted private snapshot retains the raw/HYPOTHESIS classifications and UNKNOWN purpose; the subsequent final documentation/manifest refresh still requires actual integration checks.

Eight editing-view omissions remain: 41:5AA0, 41:67F0, 42:5AA0, 43:4D50, 43:67F0, 44:4D50, 45:4D50 and 46:67F0. Their preserved ROM bytes and existing legacy previews remain separate from editable backing. The 25 bank53 names, 27 selector words, five descriptors, 25 physical windows and 24 legacy previews remain distinct structures; no bijection, absence of a computed reader, natural reachability, species/name association, observed LCDC mode or hardware rendering is established.
