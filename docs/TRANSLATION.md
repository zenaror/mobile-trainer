# Translating and modifying the game: images and text

A practical guide for translators and modders.  It says what can be changed, how, what the build does with a change, what the limits are and how to check a modified build.
Every claim carries its evidence; where nothing is known it says so.  Status words as in `STYLE.md` (CONFIRMED / PROBABLE / HYPOTHESIS).  "Tested" means: done once in a private copy of
the tree on 2026-09-30 with the tools of this repository, the result seen in emulator screenshots; it is one observation, not a proof of the general rule.

Companion documents:

* [`docs/EDITING_IMAGES.md`](EDITING_IMAGES.md): the PNG -> ROM pipeline (what `make` does with an edited PNG, constraints, screen PNGs, font sheets).  This guide does not repeat it.
* [`docs/research/image_text_inventory.md`](research/image_text_inventory.md): every picture that carries Japanese text (transcriptions, sizes, what loads it).
* [`gfx/previews/README.md`](../gfx/previews/README.md): composed screens and sprite sheets, with the numbers that check them against an emulator.
* [`docs/research/text_encoding.md`](research/text_encoding.md): the text encoding and the font banks; [`STYLE.md`](../STYLE.md) section 7: how strings are written in the source.

## 1. The two kinds of text

| | text in pictures | text drawn at run time |
|---|---|---|
| what it is | kana / kanji / Latin **baked into 2bpp tiles** (titles, banners, button labels, legends such as "A 次へ  B 戻る") | Shift-JIS strings rendered from font data while the game runs |
| where | `gfx/**/*.png` (tile sheets, 409 of them; list in the inventory) | strings in `data/text/*.asm`, `data/html/*.asm` (the HTML store, 55 pages), text blocks in `engine/`, keyboard tables in `data/keyboard/`; glyphs in `data/fonts/` |
| how to change | edit the PNG, `make` (docs/EDITING_IMAGES.md) | edit the string in the `.asm` (section 3) or the glyph in the font PNG |
| seen in the previews as | the normal picture | grey checker cells (tile data the scene does not load; drawn by the text engine) |

Which screens are pictures and which use fonts (evidence in brackets):

* **Pictures only**: title and logo screens, top menu, mail menu, profile, address book (banners, labels, legends), mailbox / received-mail grid / mail result / mail-server screens (banners and labels), registration and settings screens (banner pages, prompts, legends, yes/no buttons), the no-adapter screen, the non-Game-Boy-Color screen, browser frames and menus, help banner and footer.  Compare `gfx/previews/screens/*.png` with `evidence/*.png`: on these screens the static cells match the emulator screenshot pixel for pixel.
* **Font text drawn into the same screens**: the text of the help pages and the ticker line at the bottom of menus (`data/text/top_menu_ticker.asm`, `help_menu_ticker.asm`, `browser_start_ticker.asm`), the dialog messages of bank 72 (`data/text/dialog_messages.asm`), the connect dialog messages (`data/text/connect_dialog.asm`), the communication error messages (`data/text/comm_error_messages.asm`, drawn with `TextEngine_Run`, `CommErr_PrintMessage` 5C:531E: CONFIRMED by the code), the registration notices and prompts (`data/text/registration_*.asm`; which renderer draws them is not traced), the help script (`data/text/help_script.asm`, bank 6C), the HTML pages of the browser, mail text typed on the keyboards, digits and times (for example the communication time "分 秒").
* **Sprites**: some screens draw words with sprites (mail session screens, `CommScene_TextObjTable` 70:53EB); their tiles are in the tile sheets (inventory, classes TXT/ART), their layout is in the sprite tables (`gfx/previews/sprites/`).

## 2. Changing pictures

Workflow, constraints and tools: [`docs/EDITING_IMAGES.md`](EDITING_IMAGES.md).  In short: edit `gfx/.../name.png` (indexed PNG, four shades, pencil only, same size), run `make`; `make png-check` explains problems.
For a translator the points that matter:

1. **Find the picture.**  Look the screen up in section 2 of the inventory (it names the tile PNGs, the tilemap and the preview of each screen) or open `gfx/previews/screens/<routine>.png`.  The tile sheets hold text as a continuous stream cut into tiles (16 per PNG row), so one line of text usually wraps over two PNG rows; the screen view (`docs/EDITING_IMAGES.md` section 3, `tools/screen_png.py`) shows the tiles in their screen positions.
2. **The size is fixed.**  A picture is a fixed number of tiles and the tilemap (which tile sits in which cell, `*.tilemap`, binary) is not editable as an image.  An English label has to fit the cells the Japanese label occupies, redrawn inside the existing tiles (the pipeline refuses resized images).  The 8x8 tile grid is the only alignment rule the code imposes that was found; how many *cells* a label may use is given by the tilemap of each screen.
3. **Tiles are shared.**  One tile block can be loaded by several screens, and inside a screen one tile can appear in several cells (`docs/EDITING_IMAGES.md` section 3 explains the "shared tile" refusal).  Check the "tile PNGs loaded" column of the inventory before redrawing a block that several screens load (for example `gfx/address_book/shared_tiles_bank28/*`, the keyboard pages).
4. **Four shades, colours by palette.**  A tile has four shades (0 white ... 3 black in the PNG); the colours come from the screen's palette (`*.pal`, `RGB r, g, b` lines, 0-31 per channel; the BG attribute of each cell selects one of eight palettes).  Editing a `.pal` changes every cell that uses that palette.  Light-on-dark and dark-on-light text exist in the same sheets; keep the shade roles of the original tile (text, outline, background).
5. **Text drawn at run time cannot be fixed in the picture.**  The hatched cells of a preview are filled while the game runs.  The screens have no "English mode": nothing in the code that was traced selects another picture set by language (HYPOTHESIS by absence: no language variable was found; not exhaustively searched).
6. **Latin text that is already in pictures** (logo "GB MOBILE SYSTEM GB", "START MENU / B BACK" in the unused frame records of banks 41-46, "EXIT", "END", "OK", "GAMEFREAK" in bank 5B) needs no translation; the unused frame records even carry English legends next to the Japanese ones (inventory section 2.1) although nothing selects them.

Tested (images): one tile PNG of the title screen (`gfx/title/title_screen/title_tiles6.png`, the "スタート" button) was changed by inverting a 64x16 pixel area; `make` rebuilt `title_tiles6.2bpp`, printed `SHA-256 differs ... EDITED GRAPHICS, expected`, `compare_rom.py` reported 256 differing bytes in two runs inside `Data_0E_57C0`, size unchanged; the emulator screenshot of the title screen differed from the original in exactly a 48x16 pixel box at the button and nowhere else.  Reproduce: edit, `make`, then `BASEROM=<built rom> python3 tools/render_screens.py capture --work DIR --only boot_states` and compare `DIR/shots/boot_states/*control_boot.png` with the screenshot of the unmodified ROM.

## 3. Changing strings

Strings are written as readable Shift-JIS in the source (`db "メール", 0`) and assembled through the charmaps `sjis` / `sjis_hw` (`constants/sjis_charmap.asm`, generated; `STYLE.md` section 7).  A character that the ROM never used is not in the charmap: add a `charmap "X", $hh, $ll` line by hand (the exact cp932 code).  The full-width Latin letters and digits used in the tests below were already mapped.

### 3.1 What a build does with a string edit (tested)

* **The layout is pinned.**  Every source file is one section pinned to its original bank and address by `layout.link`.  A string that makes its file longer than the original overflows into the next pinned section: the link fails (`error: Cannot decrease the current address (from $40ef to $40d7)  at layout.link(178)`; tested with a 12-byte string replaced by a 38-byte one in `data/text/top_menu_ticker.asm`).  A shorter string builds: the section simply ends earlier and all later strings of that file move.
* **Numeric pointers do not follow.**  Where a pointer table is written with numbers (`dw $4043`, `dw $4050` in `Table_TopMenu_Strings`) and a string before the target changes length, the table still holds the old address (tested: after shortening one string the table kept `$4043`, `$4050` while the labelled strings moved from `$409F` to `$409C`).  Either keep every string at its original byte length (pad with the ideographic space `"　"` or spaces as the original records do) or give the targets labels first (`python3 tools/ptr_labels.py`, `STYLE.md` section 9).  Tables that already use labels follow automatically.
* **`make` exits with an error after linking a text edit.**  The hash gate accepts only edited graphics (`SHA-256 MISMATCH`, exit status 1 for any other difference).  The ROM file `mobile_trainer.gbc` is written before the gate; `make mobile_trainer.gbc` builds it without the gate.  `python3 tools/compare_rom.py "Mobile Trainer (Japan).gbc" mobile_trainer.gbc` lists the differing runs.  (The Makefile belongs to the build system; this is an observation of its present behaviour, not a recommendation to change it.)

### 3.2 Which characters each renderer can draw

| renderer | used for (evidence) | characters | half-width ASCII (single bytes 20-7E) |
|---|---|---|---|
| **main text engine** `TextEngine_Run` 00:0ED3 | communication error messages (5C:531E calls it: CONFIRMED by the code); HTML pages and mail text (PROBABLE, not traced) | 12x12 JIS X 0208 font in banks 76-7E: kana, kanji level 1-2, symbols, Greek, Cyrillic, full-width Latin and digits; single bytes from the **6x12 Latin font** `76:67A8` | **drawn**, 6 px wide (CONFIRMED by the engine, `Glyph_AsciiAddr` 7F:400E; `text_encoding.md` section 3); bytes A0-DF and F0-F7 draw `?`; 5C draws a yen sign, 7E an overline |
| **bank-48 8x16 renderer** (`TextTiles_RenderLine` 48:403E, `Font_BlitGlyph8x16`, the tickers) | dialog messages (bank 72), help texts, menu tickers (84 callers of `TextTiles_RenderLine`, `naming_g4.md`); the connect dialog text and the top-menu ticker behave like it (observed) | **303 glyphs only**, runs keyed by Shift-JIS code: digits 824F, A-Z 8260, a-z 8281, hiragana 829F (83), katakana 8340 (85), punctuation 8140-81F4; **no kanji**; one glyph = one **pair** of bytes, 8 px wide | **not drawn**: tested in the top-menu ticker (ASCII string: empty line) and in the connect dialog (ASCII string: empty box); the routine reads bytes two at a time (48:404C-4086), so single bytes cannot work |
| on-screen keyboards (banks 5D/5F/62/66, 8x8 tile fonts) | what can be typed (hiragana, katakana, Latin upper/lower, digits, symbols pages; a hint "SELECT ▼えいご" is visible on the katakana page of the mail body) | the pages listed in the inventory (rows 223-260) | typed Latin letters are stored as ASCII (PROBABLE, not traced) |

Tested (full-width Latin): in `data/text/top_menu_ticker.asm` the ticker string for the Mail item was replaced by 23 full-width characters (`Ｗｒｉｔｅ　ｍａｉｌ　ａｎｄ　ｓｅｎｄ　ｉｔ　ｎｏｗ！`): the ticker scrolls "rite mail and send it ..." in 8x16 Latin glyphs.  In `data/text/connect_dialog.asm` the first message was replaced by full-width Latin (`Ｐｈｏｎｅ　ｃｈａｒｇｅｓ　ａｐｐｌｙ．` / `Ｉｓ　ｔｈａｔ　ＯＫ？`): the dialog shows "Phone charges ap" / "ply." / "Is that OK?".  Letters are 8 px cells with wide spacing, there is no lower-case descender handling to speak of (the glyph runs are the 8260 / 8281 Latin runs), and there is no proportional spacing.

Consequences for a translation (evidence as above; the rest is advice):

* In strings drawn by the **bank-48 renderer** write English with full-width Latin letters (`Ａ-Ｚ`, `ａ-ｚ`, `０-９`, full-width punctuation); kanji must be replaced by kana or Latin because the renderer has no kanji.  The glyph set is exactly the 303 glyphs of `data/fonts/font_8x16_*` (they can be redrawn as PNGs, `docs/EDITING_IMAGES.md` section 4, but not added).  Which punctuation exists: the runs 8140-81F4 (see the inventory, section 4).
* In strings drawn by the **main engine** ASCII works and is 6 px wide (more text per line); the JIS font has every full-width Latin letter too.
* The 8x16 font has no half-width katakana and the main engine draws bytes A0-DF as `?`; the help script of bank 6C uses single bytes A1-DF (the "second convention"), drawn by code that is not located (`text_encoding.md` section 6): do not translate that file by analogy with the others.

### 3.3 Length limits that are known

| text | limit | evidence |
|---|---|---|
| connect dialog messages (`data/text/connect_dialog.asm`) | 16 glyphs (8 px) per line, then the text wraps | tested: a 21-glyph line wrapped after 16 glyphs |
| dialog messages, bank 72 (`dialog_messages.asm`) | records of two lines of 16 full-width characters (32 bytes) padded with the ideographic space, record header `86 aa bb`; a few records have three lines | layout of the 69 records (PROBABLE); the renderer's wrap was not tested for these |
| communication error messages, bank 5C | lines of 12 full-width characters (24 bytes) separated by `$0D`; line height 12 px; text window set up in `CommErr_PrintMessage` (HRAM `$FFC0-$FFC7`) | original strings (CONFIRMED layout); the window limits were not decoded; longer lines were not tested |
| tickers (top menu, help menu, browser start) | no limit found; the longest original line is 37 full-width characters; the text scrolls | original strings; not tested with longer text |
| HTML pages | none found (the store records carry a byte length word that must equal the body length: `STYLE.md` section 7) | `data/html/` header comments |
| picture text | the cells of the tilemap (section 2) | `gfx/previews/screens/` |
| any string file | total byte length of the file (section 3.1) | tested |

What happens when a string is longer than the space the game gives it was not investigated beyond the two tests above; do not assume the engine clips or wraps safely.

## 4. Previews: how to see what a change does

`tools/render_screens.py` and `tools/render_sprites.py` compose what the game shows from the same assets the ROM is built from (tile `.2bpp`, `.tilemap` / `.attrmap`, `.pal`), so they can show an edit without an emulator; `gfx/previews/` holds the result for the unmodified assets.

* **Screens.**  125 scenes: 96 from the static loader calls of one routine each (`Gfx_StartHDMA*`, `Tilemap_CopyRectAndAttr*`, `Palette_LoadToBuffer`, `Tilemap_FillRectSequential`; 818 resolved operations, 99 calls whose arguments are not immediates were skipped and are listed in `gfx/previews/screen_ops.tsv`), 5 browser frame styles read through the far pointers of `Table_Browser_FrameDescriptors` (4E:654B), and 24 **unused** frame records (banks 41-46), composed under a HYPOTHESIS about their layout (the layout is proven for bank 47, only assumed for 41-46).
* **Checked against an emulator** (`python3 tools/render_screens.py capture --work DIR` replays the 67 trace scenarios with a patched copy of the tracer, `tools/trace/shot_state.patch`, which also dumps VRAM / palette RAM / OAM / LCD registers at each screenshot; 642 distinct screen states): 87 scenes match a capture (82 loader scenes, 5 frame styles; two of them only a forced-execution capture, which `screens.tsv` marks).  On the 17,520 cells in which the capture's map entry and tile data equal the scene's ("static" cells) the scene's pixels equal the screenshot in **1,019,924 of 1,020,202 pixels (99.97 %)**; 71 of the 73 scenes that have such cells are pixel-exact, the other two are `ConnectDialog_Draw_PasswordEntry` (97.5 %) and `ConnectDialog_Draw_SavePasswordConfirm` (91.4 %), whose capture is one of the three in which even the plain emulator-state renderer is not exact (window layer and raster effects, not analysed).  The remaining cells of those scenes are text and other content drawn at run time.  The composed palettes match the emulator's palette RAM exactly for most scenes (column `pal`); where they do not, the capture was taken mid-fade or in another state.
* **The renderer itself** (BG, window, sprites incl. 8x16, per-line scroll changes, flips, palettes) reproduces the emulator screenshot exactly in 639 of 642 distinct captures and 99.996 % of all pixels (`python3 tools/render_screens.py check --captures DIR`); the three others differ in 1.4 % or fewer pixels.  The colour conversion is `(v << 3) | (v >> 2)`.
* **Limits**: the preview draws one 32x32 map; it ignores the window layer of scenes that only use the BG (the dialog screens use the window: those scenes are matched as a window layer), mid-frame scroll changes (the tool picks the scroll per line that matches the screenshot, which is evidence-based but a fit), and everything the text engine draws.  Scenes are "what one routine loads", not always a complete screen: states that the code builds from several routines or from tables (help items, keyboard pages, notice dialogs, 14 scenes that no capture reached) are incomplete or missing.  Tile addressing ($8000 or $8800, LCDC bit 4) is taken from the capture when there is one, otherwise chosen by coverage and labelled in the `lcdc` column of `screens.tsv`.
* **Sprites.**  `gfx/previews/sprites/` has one sheet per object-table root (47 sheets, rows = entries, columns = frame indices, palettes of the screen; 37 roots 8x8 and 10 roots 8x16 sprites, the size taken from LCDC bit 2 in the captures that show the root, 8x8 where none does).  Frame records were found in 6,738 OAM instances of the captures; 290 distinct records appear, 178 of them with tile bytes and palettes identical to the assets context.  Drawn from that context onto the emulator background, 397 of 397 instances with an identical context equal the screenshot exactly; the other instances differ because the tile slots hold other data at that moment (the sheets then use `emulator` or `partial` context, see `sprites.tsv`).  Sprite graphics are edited like any tile sheet; the sprite tables (`home/sprites.asm` macros) are code/data, not images.

## 5. Checklist for a modified build

1. `make` for graphics edits (expect `EDITED GRAPHICS, expected` and the list of changed `.2bpp` / `.pal` files), `make mobile_trainer.gbc` for string edits (the SHA gate fails by design, section 3.1).  Do not edit `baserom.gbc` or `Mobile Trainer (Japan).gbc`; the original ROM is never modified.
2. `python3 tools/compare_rom.py "Mobile Trainer (Japan).gbc" mobile_trainer.gbc`: `size_delta=0` and every differing run inside the region you meant to change (the tool names bank, address and region).  An unexpected run means a pointer or layout problem (section 3.1).
3. `make png-check` (images); for strings re-read the file: lengths, `$0D` / NUL terminators, padding.
4. Run the scenario that reaches the screen with the modified ROM and look at the screenshots:
   `BASEROM=$PWD/mobile_trainer.gbc python3 tools/render_screens.py capture --work /tmp/check --only <scenario>` (needs the mGBA fork tree, `docs/research/dynamic_tracing.md` section 1; a scenario takes seconds to a minute).  Screens and the scenarios that show them: title / top menu `boot_states`; registration and settings `register`, `register_hidden_manual`, `settings_phone`; mail `mail_send`, `mail_receive`, `mail_mailbox`, `mail_server`, `kbd_compose`; browser `homepage`, `browser_bookmarks`; help `help`; no adapter `noadapter`; error numbers `mail_errors`, `browser_errors`, `register_errors`.  Screenshots are `DIR/shots/<scenario>/*.png`; names say which screen.
5. Compare with the unmodified build's screenshots (the same scenario, same frames: the harness is deterministic, `--verify-determinism` in `tools/trace/run_trace.py` proves it for the original): only the intended pixels should differ (Pillow `ImageChops.difference` gives the box; that is how the image test above was checked).
6. A change that only looks right in the preview is not verified: the previews are composed from assets, not from running the modified ROM.

## 6. Known limitations and open questions

* Tilemaps and attribute maps are binary: a longer label cannot take more cells without hand-editing `*.tilemap` bytes; no tool here edits them.  Tile blocks cannot grow (pinned layout).
* 99 loader calls with computed arguments are not resolved (help items, mail-menu buttons, notice dialogs, keyboard pages, browser frame tilemaps of some states): their pictures are in the inventory as tile sheets but not composed as screens.
* The notice dialogs (banks 50/51), the mail-session status images (banks 26/27), banks 58/60/61 text pools and the four message images of bank 52 could not be read (inventory section 5).
* Nothing was found that selects a language; the server side (DION, the web pages the game fetches) is not part of the ROM and not covered.
* The 8x16 renderer's behaviour with a string longer than the box, the ticker's maximum, which renderer draws the registration notices, and what the game does with a kana/kanji it cannot draw were not investigated.
* The bank 6C help script: encoding of the single bytes `E0-FF` and the reading routine are unresolved (`text_encoding.md` section 9).
* Unreferenced data (banks 41-46, bank-47 record 3, `gfx/unreferenced/`, `Font_GlyphRun_83BF` placeholders): translating it changes nothing visible unless something uses it.
