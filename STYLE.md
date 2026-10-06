# Style guide

The source was produced once by a bootstrap generator (see `README.md`, "History") and is now **edited by hand**.  This guide records the conventions the
existing code follows, so that new code, comments and renames stay consistent with it.  The general assembly style follows
[pokecrystal's STYLE.md](https://github.com/pret/pokecrystal/blob/master/STYLE.md) (tabs for indentation, comments above the code, `PascalCase` labels, local
labels for jump targets inside a function).  Where old code disagrees, the surrounding code wins; when you meet an edge case that is not covered here, add it.

Every example below is taken from the tree; `grep` for it if in doubt.

## Contents

1. Evidence vocabulary
2. Files and sections (and `layout.link`)
3. Comments (function notes, block headers, address comments)
4. Labels and names (local labels, neutral and semantic names, RAM, constants)
5. Far calls and inline data
6. Code
7. Text (Shift-JIS charmap)
8. Graphics (assets, `INCBIN`, `RGB`)
9. Words, tables and pointers
10. Checks and tools
11. Git and commits

## 1. Evidence vocabulary

Everything the analysis claims has one of three statuses, written in capitals:

| status | meaning |
|---|---|
| `CONFIRMED` | demonstrated: executed in an emulator trace, a byte-identical library routine, an unambiguous disassembly fact.  Say how (address, trace, note). |
| `PROBABLE` | strong evidence that is not conclusive (static reach, a match with the Crystal SDK, a consistent usage pattern). |
| `HYPOTHESIS` | unverified; a guess that may guide the next test. |

Rules: never upgrade a status without a cited fact; a name that is not backed by evidence stays neutral (section 4); never invent semantics to make code look tidier;
never delete earlier analysis without a stated reason.  Record the reasoning in `docs/research/*.md` and cite the note or the addresses in a comment at the code.

Where a status is written in the source:

| what | form | example |
|---|---|---|
| a block of code | `[STATUS] note` in a comment under the label (section 3) | `; [CONFIRMED] fill BC bytes at HL with A ...` under `FillBytes::` |
| a block of data, words, ptrtable, text, gfx, zero | a header line `; ---- <kind> $start-$end (n bytes) [STATUS] note` above the label | `; ---- words $161A-$1620 (6 bytes) [CONFIRMED] 3 pointers into SRAM bank 1 ...` |
| a RAM name | the status word after `size N ...` in the `DEF` line's comment (`ram/*.asm`) | `DEF wGlyphBufLeft EQU $C0A0 ; size 24 array PROBABLE [g8] ...` |
| a constant | the status word right after the `;` (`consts.asm`) | `DEF ABOOK_SLOT_COUNT EQU $0006 ; CONFIRMED Address-book slots: ...` |

* Kinds of block header: `data`, `words` (table of 16-bit values), `ptrtable` (little-endian address table), `text`, `gfx`, `zero`.  A block of code has no header any more
  (its note moved under the label); one leftover `; ---- code` header exists in `data/fonts/jis12x12_rows_25_33.asm`.
* `[g1]`..`[g8]` and `[sdk]` inside the notes of RAM names name the analysis group whose note (`docs/research/naming_g1.md` .. `naming_g8.md`, `naming_sdk.md`) adopted the name.
* `grep -rn '\[PROBABLE\]'` / `'\[HYPOTHESIS\]'` over the tree lists what still needs evidence.
* The evidence trail that is not in the source: per-symbol evidence text in `config/symbols/*.tsv`, region notes in `config/regions/*.tsv`, RAM evidence in `config/ram/*.tsv`,
  cross-bank operands in `config/xrefs.tsv` (all frozen, see `config/README.md`), the reasoning in `docs/research/*.md`, executed-code evidence in `analysis/` and `traces/`.

## 2. Files and sections

* One file = one floating section named after the path: `SECTION "engine/mail/compose", ROMX` (`ROM0` for bank 00).  Sections carry no `[$addr]`/`BANK[]`; `layout.link` pins each of them.
  (333 sections at the time of writing: 28 `ROM0`, 305 `ROMX`, including the one of `zero_labels.asm`.)
* Every file starts with a three-line header: path, `bank BB, $start-$end (n bytes); pinned by layout.link`, one line of purpose; then a blank line and the `SECTION`.  Keep it correct when you move things.

  ```asm
  ; home/copy.asm
  ; bank 00, $04D8-$0540 (104 bytes); pinned by layout.link
  ; FillBytes/FillWords/CopyBytes/CopyBytesBackward

  SECTION "home/copy", ROM0
  ```
* Files contain no `INCLUDE` of headers: `includes.asm` (hardware names `constants/hardware.inc`, RAM names `ram.asm`, macros `constants/macros.inc`, the Shift-JIS charmaps
  `constants/sjis_charmap.asm`, `constants/gfx_macros.inc`) is pre-included by the Makefile (`rgbasm -P includes.asm`).  The only `INCLUDE` lines in the source are the `.pal`
  palette files (section 8); asset paths resolve because the Makefile passes `-I .`.
* Directories: `home/` (ROM0), `lib/mobile/` (SDK banks 75 and 0F), `engine/<subsystem>/` (code), `data/` (text, HTML store, fonts, tables), `gfx/<screen>/` (tiles, tilemaps,
  palettes and object tables named after the consumer), `audio/`.  Paths are lowercase, `[a-z0-9_]`, `.asm`.  A graphics block stored in a different bank than the code that loads
  it is named after the consumer and carries `_bankNN` (`gfx/mail/connect_screen_bank29.asm`); blocks with no known consumer are `gfx/bankNN.asm`.  The reasoning behind the
  file split is in [`analysis/layout/README.md`](analysis/layout/README.md).
* Data that only one routine uses stays in the routine's file, as in pokecrystal.
* Special files: `ram.asm` + `ram/{sram,wram,hram,banked}.asm` (equates only, no bytes), `consts.asm` (numeric constants), `zero_labels.asm` (labels that point into all-zero padding,
  tiny pinned sections).  `includes.asm`, `ram.asm` and `ram/*.asm` are not objects; every other `.asm` file is one.

### Adding, moving and removing code

* Everything in the ROM is pinned by `layout.link` (`org $addr` followed by the section names, per bank).  Sections are packed back to back, so adding a byte to a routine
  makes its section run past the next `org` and the link fails with `Cannot decrease the current address (from $16a3 to $16a2) at layout.link(54)`
  (tested: one extra `nop` in `home/copy.asm`).  To grow a routine, move the following sections (edit their `org` lines) or free space first; to move a section, change its `org` line.
* A section that is not in `layout.link` floats: rgblink puts it into free space (tested: a new `SECTION "engine/new_thing", ROMX` went to `01:4000`, in an empty bank), which of
  course changes the ROM hash.  Use this for new code; a `farcall` to a floating label works (`BANK(Label)` is resolved by the linker).
* If you delete a file, delete its two lines (`org`, section name) from `layout.link`.  If you rename a section, rename it there too.
* `engine/account/comm_panel.asm` is reached by falling through from the end of `engine/account/registration_verify.asm` (`68:733C`); the two sections must stay adjacent.
  This is the only fall-through between files that the layout check found (`analysis/layout/README.md`, section 1 rule 2).
* The all-zero space between and after the sections is not in any file; the linker pads it with `$00` (`rgblink -p 0x00`).  A label inside padding lives in `zero_labels.asm`.
* After a change run `make`: the SHA-256 tells you whether the ROM is still the original.  A *deliberate* change (a patch) of course changes it; work on a copy of the
  tree/branch for that and keep the reference hash for the unmodified build.  Adding a string or an asset byte changes the size of its section, which has to be accommodated in `layout.link`.

## 3. Comments

```asm
; Use tabs for indentation, spaces for alignment.
; Comments go above the code they describe; short trailing comments after data lines are used
; (the meaning of a word, `; record header`) and are fine there.
```

### The comment of a function

The note of a block of code is a comment block directly under the label, after all alias labels and before the first instruction, indented with one tab and wrapped
at 100 columns (a tab counting 4):

```asm
FillBytes:: ; 00:04D8
	; [CONFIRMED] fill BC bytes at HL with A (BC=0 fills 256 bytes when B=0); used to clear
	; VRAM/WRAM/HRAM in Boot
	inc b
```

* The comment starts with the **evidence status** of the block in brackets, `[CONFIRMED]`, `[PROBABLE]` or `[HYPOTHESIS]` (section 1), then the note.  The tag is always written,
  also for `CONFIRMED`, so that a missing tag can never be mistaken for a status; it comes first so that it stays visible when the note wraps.
* The note keeps the wording and the evidence of the original analysis (executed in N scenarios, reached by static flow only, entered by a table/jrcc from X, ...).  Notes are
  never shortened to make them look tidy; a name or a claim without evidence is not added (a comment that says what a function does is written only when that is demonstrated,
  and then it says how).  When you learn more, extend the note and change the tag only with a cited fact.
* A piece of code that has no label (the fall-through part of a function cut into a separate block by the coverage analysis) has its note above its first instruction, after a blank
  line, indented like the code.  A note under a local label works the same way (`.l0531`, `.loop` in `home/copy.asm`).
* The address is on the label line (`; BB:AAAA`, below); the size of a block is the distance to the next one.
* `data`, `words`, `ptrtable`, `text`, `gfx` and `zero` blocks keep their `; ---- kind $start-$end (n bytes) [STATUS] note` header, followed by a blank line and the label:

  ```asm
  ; ---- text $4006-$4011 (11 bytes) [PROBABLE] html_url_prefix: "file://di/",0 (ASCII) (verified structure, layout from engine code)

  String_3F_4006:: ; 3F:4006
  	db "file://di/", 0
  ```

### Address comments

`Name:: ; BB:AAAA` gives the bank and address at the time of writing.  They are hints for navigation, `build/mobile_trainer.sym` (written by `make`) is authoritative:
run `python3 tools/sym_check.py --fix` after moving code to refresh them.  Local labels carry the same comment (`.loop ; 00:04DC`).  A label inside `LOAD` (code copied to RAM)
reads `; 00:05AC (runs at $FF80)`.  A label that is an alias (below) has no comment.  To find the source of an address quoted in `docs/`: `grep -rn '; 68:766E' --include=*.asm .`

## 4. Labels and names

```asm
Name::                     ; ROM label: all global labels are exported, the linker resolves cross-file references
Account_ResultPage:: ; 68:766E   subsystem prefix, underscore, PascalCase
Function_68_6E1A::         ; neutral: bank 68, address 6E1A, no evidence for a name yet
.loop ; 00:04DC            ; local label (below)
```

### Neutral names

A name without evidence keeps the position it had in the original ROM and is never renamed by the tools: `Function_BB_AAAA` (routine entry), `Label_BB_AAAA` (jump target that
has to stay global), `Data_BB_AAAA` (data), `Table_BB_AAAA` (word/pointer table), `String_BB_AAAA` (text), `Tiles_BB_AAAA`, `Tilemap_BB_AAAA`, `Attrmap_BB_AAAA`, `Palette_BB_AAAA`, `Font_BB_AAAA`
(`BB` the bank, `AAAA` the CPU address in upper-case hex).

* When code is moved, the position in the name does not follow; that is acceptable: it is the historic (original ROM) address, useful for cross-reference with `docs/research/`.
* When a symbol receives a semantic name, the neutral name stays as an **alias label** on the next line, without address comment, so that the historic name still resolves:

  ```asm
  SoundDrv_LoadSongHeader:: ; 04:430A
  Function_04_430A::
  	; [CONFIRMED] 5 insn(s); ...
  ```
  (1,022 such aliases at the time of writing.)  Note that a local label belongs to the last global label above it, so the `.sym` file lists `Function_04_430A.loop` there.
* Generic names are not invented for new code: name new code with a semantic name only when you can state the evidence, otherwise give it the neutral form of its position.

### Semantic names

`Subsystem_ThingDone` (`Title_Run`, `Account_ResultPage`, `MailStr_Boundary`, `CommPanel_WaitClose`, `SoundDrv_CmdSetTempo`, `MobileSDK_*` for bank 75, `Int_VBlank`, `Rst_08`).  Use one only with
evidence; then rename over the whole tree (search and replace), and `make` plus `make sym-check` prove nothing else changed.

* Data and text keep their kind prefix: `String_<Subsystem>_<What>` (`String_Abook_HelpNew`), `Table_<Subsystem>_<What>` (`Table_MailDraftMenu_Captions`), `Data_<Subsystem>_<What>` (`Data_Browser_FrameDesc0`).
* Graphics: `Gfx_<Screen>_Tiles<n or address>` for tile data (`Gfx_Title_Tiles0`, `Gfx_AddrBook_Tiles8F00`), `Tilemap_<Screen>_<What>`, `Attrmap_<Screen>_<What>`, `Palette_<Screen>_Bg|Obj`
  (`Palette_Title_Bg`).  A tile block that `Gfx_StartHDMA[WithService]` loads into VRAM bank 1 (odd `E` in `de`) ends in `Vb1` after the address (`Gfx_Profile_Tiles9300Vb1`); the address is `de & $FFF0`.
* When the same semantic name applies to several positions, the original position is appended to keep them unique (`Gfx_StartHDMAAtVBlank_2B_4723`, `Gfx_StartHDMAAtVBlank_2C_669D`).
* Names must be unique across the ROM (labels, constants and RAM names share one namespace) and must not clash with an RGBDS keyword.

### Local labels

A branch target that is used only by `jr`/`jp` of its own function is a local label (`.name`, no colon, `; BB:AAAA` comment kept on the line), as in pokecrystal:

```asm
FillBytes:: ; 00:04D8
	inc b
	dec b
	jr nz, .l04E1
.loop ; 00:04DC
	ld [hli], a
	dec c
	jr nz, .loop
	ret
.l04E1 ; 00:04E1
```

* Scope: a local label belongs to the closest global label above it; the linker lists it as `Function.name` in the `.sym` file (`FillBytes.loop`).  `tools/sym_check.py` checks
  local labels like global ones.  No blank line in front of a local label.
* Names: `.lAAAA` is the default (`AAAA` = the address of the old generic name `Label_BB_AAAA`, so the historic position is kept; the bank is that of the file).  A role name is used only when
  the code itself shows the role **and** it is unique in its scope: `.loop` (every jump to it is backward), `.done` (every jump is forward and the label is directly followed by `ret`),
  `.skip` (one conditional forward jump over one to three plain instructions).  Anything else, and every case where the role is not obvious, keeps `.lAAAA`.  Rename a local label
  to a meaningful name (`.next_char`) only with evidence, like any other name.
* Stay global (`Label_BB_AAAA::`): a label that is referenced by `call`, `farcall`, `ld`, `dw`/`db`, an expression, another function or another file (jump tables, callbacks, entry
  points), or that is not referenced at all.  A label that stays global also ends the scope of the labels above it, so a local label used on both sides of it stays global as well.
* A function can fall through into the next global label; that is fine.
* Local labels change nothing in the ROM.  `python3 tools/localize_labels.py --check` and `python3 tools/tidy_comments.py --check` exit 0 when the tree is in this form.
* New code uses local labels for its own jump targets.

### RAM

`ram/*.asm` holds equates only, one `DEF` per name with the evidence in the comment.  Prefix by memory area as in pokecrystal: `w` WRAM (`wShadowOAM`), `s` SRAM (`sSram_MailRecords`),
`h` HRAM/IO (`hROMBankLo`).  Neutral names are `wRam_XXXX`, `sSram_XXXX`, `hRam_FFXX` (the CPU address).  WRAM `$D000-$DFFF` and SRAM `$A000-$BFFF` are banked: the same CPU address is a
different variable in another bank, so a name there exists only in `ram/banked.asm` (comment starts `bank W1 ...`/`bank S1 ...`) and only where the bank of the access is known; a
neutral name never claims a bank.

**Overlay aliases.**  Some bank-independent bytes (`wRam_C27C-C280`, `wRam_C0D4-C0FF`, ...) are reused by every screen with a different meaning, so their neutral name stays the only
global name of the address.  `ram/overlays.asm` adds *screen-local aliases* of them, `DEF wSlotMenu_Cursor EQU wRam_C27D ; [STATUS] evidence`, named `<w|h><Screen>_<Role>` and used only in
the source file(s) listed in the `; ---- <scope>` line above their group: every mention of the neutral name inside those files is the alias, and every other file keeps the neutral name,
which stays defined.  An alias is the same number as its base (no byte of the ROM depends on it); its status is the evidence for the role in that scope, so a byte that one file uses
for two things gets no alias, unless a function range separates the two uses (`path@LabelA..LabelB`: the lines from the global label LabelA up to, not including, LabelB).  The same
address may therefore have several aliases with different meanings, each in its own scope: that is the point of a time-shared scratch area, and the neutral name remains the one name
that is true everywhere.  Two aliases of one base never overlap in scope (the tool refuses it), and a byte that the tree writes and never reads gets no name, only
a HYPOTHESIS record in the manifest.  The manifests are `analysis/naming2/overlay_aliases*.tsv`; `tools/apply_overlay_aliases.py` applies them (it builds and compares the ROM) and
`tools/apply_overlay_aliases.py --check` audits the file (every alias used only inside its scope).  Banked bytes (`$D000-$DFFF`) keep using `ram/banked.asm`.

**Banked names.**  A name in `ram/banked.asm` (`DEF sSettingsHiddenMode EQU $B012 ; bank S1 size 1 byte PROBABLE [ram4] evidence`) states the bank, the size in bytes, the kind (`byte`, `word`, `array`, `struct`), the status and the
evidence.  It is used only where the bank of the access is known: `tools/apply_banked_names.py` replaces `ld hl|de|bc, $XXXX` operands by the name (`name + $XX` inside a larger object), one row per file and operand with the proof of
the bank.  Nothing else is rewritten: a raw `$A000` in a wipe of several banks stays numeric or uses the constant `_SRAM`, and a descriptor that spells a bank and an address keeps its numbers.

**Overlay names in banked memory.**  A banked scratch area that several subsystems reuse at different times (SRAM bank 3 `$A000-$BFFF`: the network work area, the browser page buffer, the POP3 parse and summary blocks, the
password-change buffers; bank 2 `$A000-$A2FF`: the configuration image and the registration scratch) may carry one name per subsystem although the ranges overlap; the neutral `sSram_XXXX` stays the one name that is true
everywhere.  The rule is the file scope of the WRAM0 aliases: two overlapping names of one bank are accepted when (1) no source file mentions both, or (2) one is the container of the other (kind `struct`, or its `DEF` comment says
`container`: the umbrella name of a work area, or an array of named elements), or (3) the `DEF` comment of one says `overlay:` and names the other (a phase overlay inside one file).  Every overlapping name says `overlay:` and lists
the others; `python3 tools/apply_banked_names.py --check` audits `ram/banked.asm` against the sources.

**RAM pointer operands.**  An immediate `ld hl|de|bc, $XXXX` in `$C000-$CFFF` (WRAM0), in HRAM `$FF80-$FFFE` or in the hardware registers `$FF00-$FF7F` that is the address of something is written as the
name of the object that covers the address (`ld hl, wGlyphBufLeft`, `ld hl, wMobileSDK_Window + $0C`, `ld de, rLY`): the innermost semantic object, or the neutral `wRam_Cxxx` / `hRam_FFxx` when nothing semantic
covers it.  Not every such immediate is an address: in HRAM `ld bc, $FF9C ; add hl, bc` adds the number -100, and a DE handed to `Sprite_SetPosition` is a Y, X pair.  Those stay numeric (the tool recognises them by the
first use of the register), and so does a line whose comment starts with `; raw`, a human decision that gives its reason (a dead load, a scratch use of a named buffer, the base of a window wipe).  An address that has a
screen-local alias stays numeric inside the files of the alias.  Banked addresses (`$D000-$DFFF`, `$A000-$BFFF`) follow the bank rules above.  `python3 tools/apply_ram_operands.py --areas wram0,hram,io --check` lists the
operands that are still raw.

**Banked WRAM pointer operands.**  An immediate `ld hl|de|bc, $Dxxx` points into whichever WRAM bank is selected, so the number proves nothing: `$DA00` is the first sprite slot in bank 7, a dictionary history buffer in bank 6 and a
text tile buffer in bank 2.  `python3 tools/apply_ram_operands.py --areas wramx` rewrites one only when a *consumer rule* proves the bank in which the pointer is dereferenced: a row of `analysis/naming2/wramx_consumers.tsv` (routine,
register, bank, `needs`, name family, proof).  The consumer is the first `call`, `farcall` or tail `jp Label` of the straight line after the load, with only plain instructions in between that touch neither the register nor a bank register (no
label, jump, macro or data line); `needs` is `-` when the routine selects the bank itself (`Sprite_InitSlot`, `Sprite_SetPosition`, `Sprite_ClearSlot`, `Sprite_SetHook`, `Palette_LoadToBuffer` and the `Tilemap_CopyRectAndAttr` family select bank 7), `switch` when its caller does, and `a` when the routine takes the bank of the
pointer in A (`Gfx_StartHDMA`, `Tilemap_ApplyMaskRect`: the constant in A at the call, from `ld a, $NN` or `xor a`, must be the bank, and 0 means the bank in force, which the idiom must show).  For `switch` the nearest write of the bank register before the
load, at most 60 lines back, must be the idiom `ld a, $07 / ldh [hWRAMBank], a / ldh [rSVBK], a` of that bank (or a call to a routine that sets it), and the scan ends without a proof at a global label, an unconditional `ret`/`jp`/`jr`, a call to a routine that
`analysis/naming2/wramx_calls.tsv` does not list as keeping the bank (`keeps`, or `keeps if A=0` with A = 0 at the call) or setting it, a conditional call, and a local label other than the head of a loop whose body keeps the bank.  The name is the innermost object of
`ram/banked.asm` for that bank, and must match the family of the rule (`ld hl, wSpriteSlot3`, `ld hl, wSpriteSlot2 + $0B`, `ld de, wPaletteBufObj`).  It states the bank in which the *consumer* dereferences the pointer; the caller's own bank may be another one.
Everything else stays numeric and is counted by consumer, which says which rule to write next.  The generated `wSpriteSlots + 17` is held to the same proof: `python3 tools/apply_ram_operands.py --elements wSpriteSlots --observed` writes it
`wSpriteSlot1 + $01` where bank 7 is shown by the scan or because every replayed execution of the instruction ran under bank 7 only (`analysis/rambank/observed_banks.tsv`, the source line mapped to its ROM address by `tools/line_addresses.py`); an
expression without proof keeps the old spelling, and a site proven by reading goes into `analysis/naming2/ramop7_manual.tsv` with its proof.  `python3 tools/apply_ram_operands.py --areas wramx --check` lists the operands a rule proves that are still numeric.

### Constants and numbers

* **Constants** are `UPPER_CASE` (`MAILREC_OFS_TIME`, `ABOOK_SLOT_COUNT`), written `DEF NAME EQU $xxxx ; STATUS note` followed by `EXPORT NAME` in `consts.asm` (so they are in the `.sym` file).
  Hardware registers are `rNAME` and bit masks `NAMEF_*` / `NAMEB_*` (`constants/hardware.inc`).
* Numbers: hexadecimal with `$` and upper-case digits (`$04D8`, `$FF`), decimal only for counts.  Instructions are lowercase with the explicit operand form of the existing code
  (`or a, a`, `ld a, $08`).

## 5. Far calls and inline data

The Trainer calls code in other banks through the routine at `00:06D1` (`FarCall`, `home/farcall.asm`), with the target address and bank stored right after the `call`:

```asm
	farcall CommPanel_Step        ; = call FarCall ; dw CommPanel_Step ; db BANK(CommPanel_Step)
```

* `farcall Label` (macro in `constants/macros.inc`) is the form of all 5,274 far calls; the bank byte is `BANK(Label)`, so it follows the label if it moves.  `FARCALL_FN` (`ram.asm`) names
  the entry label the macro calls.
* `farcall_raw $addr, $bank` spells the same three bytes for a target that has no label at exactly that address; no site needs it today.
* Other inline-data callees are documented in `config/conventions.tsv` (`call $06BC ; dw target` where the bank is taken from `hFFF3`, `jp` forms, jump tables read from the bytes after the call).
  Their inline bytes are written as `dw`/`db`.
* Never put a section boundary between a `call` and its inline bytes.

## 6. Code

* If evidence shows that bytes inside a block of code are data, split the block: end the code before, put `db`/`dw` after, and add the header of the data block.
* Code that is copied to RAM is a `LOAD "RAM_00_05AC", HRAM[$FF80]` ... `ENDL` block; its ROM image stays in the section (the OAM DMA routine, 10 bytes, in `home/lcd.asm`).
* Unreachable or never-executed code stays, with its status.  Do not delete it to tidy up: the ROM must stay identical.
* Conditional branches use `jr` where the original does; do not change instruction forms (a `jr` vs a `jp` changes the size).  The assembler options matter for identical bytes:
  the Makefile assembles with `-Weverything -P includes.asm -I .` and no optimisation flags; the build is warning-free, keep it so.

## 7. Text

The game's text is **Shift-JIS**, NUL terminated (`docs/research/text_encoding.md`).  It is written as readable strings, not as bytes:

```asm
	db "メール", 0
	db "ホームページ", 0
	db "</HTML>", $0D, $0A, 0
```

The strings are turned into the original bytes by two multi-byte RGBDS charmaps in `constants/sjis_charmap.asm` (`charmap "メ", $83, $81`), so the ROM stays identical (`make` prints
`SHA-256 OK`).  The file is **generated** by `tools/gen_sjis_charmap.py` from the ROM's text regions (do not edit it; `python3 tools/gen_sjis_charmap.py --check` tells whether it is current).

| charmap | contains | used by |
|---|---|---|
| `sjis` | ASCII `20`-`7E` (`5C` = `¥`, `7E` = `‾` as in the 6x12 Latin font) and every JIS X 0208 double-byte character that occurs in the ROM's text | all text under `data/` and the `text` blocks inside code files (`engine/`, `lib/`, `home/`, `audio/`) |
| `sjis_hw` | `sjis` + single bytes `A1`-`DF` as half-width katakana in JIS X 0201 order | `data/text/help_script.asm` (bank 6C, the "second convention"); the glyph a byte draws is unproven (`text_encoding.md` section 6), the charmap only names the bytes |

### Charmap discipline

* `includes.asm` includes the charmap file, which ends with `SETCHARMAP main`: the default charmap is empty and stays active in code, so a stray string in code is not re-encoded.
* A data file that has strings starts with `PUSHC sjis` (or `PUSHC sjis_hw`) right after its `SECTION` line and ends with `POPC`.  Never use `SETCHARMAP` in a source file; never define a charmap
  outside `constants/sjis_charmap.asm`.
* In a code file (code mixed with data) the charmap is pushed per block: `PUSHC sjis` goes directly before the first label or `db` of a `; ---- text` block and `POPC` directly after its last `db`;
  no instruction is ever between them.  `python3 tools/text_to_strings.py --audit` checks that the pairs are balanced and that no `"` occurs in code outside a pair.
* `rgbasm -Weverything` reports `-Wunmapped-char` for a character the active charmap lacks.  A character that the ROM never uses is not in the file: a patch that needs one adds a
  `charmap "X", $hh, $ll` line by hand (the exact cp932 code) and then `--check` no longer applies.
* `constants/charmap.asm` is analysis output of the survey (`tools/survey.py`), not used by the build; `constants/sjis_charmap.asm` is the charmap that the build uses.

### Writing strings

* **One string per line**, ending with its terminator (`db "…", 0`); a `$0D` (newline; CR LF in HTML) ends a line of a multi-line message: `db "…", $0D` / `db "…", 0`.  Label the start of a string
  that something refers to (`String_BB_AAAA::` or its semantic `String_<Subsystem>_<What>::`).
* **Bytes that are not a plain character stay explicit** between the quoted parts: control bytes (`$0D`, `$01, $20` in the keyboard rows, the `$86, $02, $01` record header), gaiji `F8`-`FF`,
  unknown singles, the bank 6C string header `$06, $xx, $yy, $03, $aa, $bb`.  Do not give them a character or a name without evidence (`text_encoding.md` sections 4 and 6 list what is known).
* Inside quotes write `\"` for `"`, `\\` for `\`, `\{` and `\}` for the braces (RGBDS escapes).  The ideographic space `81 40` is `"　"`.
* Long strings are not wrapped by hand: split at the game's own line breaks (`$0D`) only.  The decoded text is the source, so there is no trailing `; "…"` comment; a `db` line may still carry a
  hand-written comment (`; record header`).
* Records that contain text keep their structure: HTML store records (`data/html/pages_*.asm`) are `db "name.htm", 0` / `dw <body length> ; body length` / the body, one line per CR LF, ending
  `db "</HTML>", $0D, $0A, 0`.  The length word stays a number (it is the byte length of the body including its final `0`).  `data/html/keywords.asm` items are `db "html", 0, $01` (name, NUL,
  value byte).  The HTML store index (`data/html/index.asm`), the keyword tables and the ticker tables are `words`/`ptrtable`/`data` blocks with the same header convention.
* **Only what is provably text is converted**: regions whose header says `text`, data regions of `data/text/` that are nothing but clean NUL-terminated strings, and the item tables of `keywords.asm`.
  Tables, cell data, images, record headers and executed-read data of unknown content class (`; ---- data ... content class unknown`) stay `db $xx`; where such a region contains text-like bytes a
  comment says why it was left (`; kept as raw bytes: ...`, `data/text/help_script.asm`).  If evidence later shows that such bytes are a string, convert them by hand and change the block header.

### Tools

```
python3 tools/gen_sjis_charmap.py            # regenerate constants/sjis_charmap.asm (reads the ROM, or mobile_trainer.gbc)
python3 tools/gen_sjis_charmap.py --check    # is it current?
python3 tools/text_to_strings.py --dry-run   # what would still be converted (nothing, once done)
python3 tools/text_to_strings.py --audit     # charmap discipline in code files (balanced PUSHC/POPC, no quotes in code)
python3 tools/ptr_labels.py [--dry-run]      # numeric dw of a documented pointer table -> dw Label (needs a built .sym; all-or-nothing per table)
python3 tools/text_to_strings.py             # convert numeric text blocks, then `make` and check the SHA-256 (restores the files if it differs)
```

`tools/text_to_strings.py` is idempotent and is the way to convert text that is added later as raw bytes; it never touches lines that already are strings.

## 8. Graphics

The graphics blocks are files: the `.asm` files under `gfx/` and `data/fonts/` `INCBIN` them (784 `INCBIN` and 133 `INCLUDE` lines at the time of writing).  The layout, the file list (with
sizes, `bank:addr` and evidence status) and the PNG modes are in [`gfx/README.md`](gfx/README.md) (generated) and `gfx/assets.tsv` (machine readable).

* **What is a file**: 2bpp tile blocks (`.2bpp` + `.png`), tile-index maps (`.tilemap`), CGB attribute maps (`.attrmap`), CGB palettes (`.pal`, `RGB r, g, b` lines), the 8x16 1bpp font runs
  (`.1bpp`), the JIS 12x12 / 6x12 fonts and the Shift-JIS validity bitmap (`.bin`, with a view-only `_view.png`).  A `tilemap+attr` block that `copy_tilemap_rect_pair` loads is two files (tile
  bytes, then attribute bytes) INCBINed back to back.  A block is converted only when its block header note, its label or `config/symbols` says what it is and the bytes fit (palette: even size and
  every word < $8000; map: size = the width x height the note states); everything else (sprite frame records, animation scripts, object tables, "read as data, class unknown", fragments shorter than
  four tiles, partial tiles at the end of a tile block) stays `db`, written as rows of 16 bytes under its header.  No compression has been demonstrated: assets are stored raw.
* `zero` blocks are padding (`ds $N, $00`); the fonts (`data/fonts/`) are JIS X 0208 12x12 1bpp rows, one file per font bank.
* **In the `.asm`**: the block header (status + evidence, which states how the block is loaded: `tiles-vram: ... hdma_rom_to_vram at 0E:4231: hl=$43C0 ... de=$8000`), the labels and the pinning are
  unchanged; only the `db` rows are replaced, and the bytes must be exactly the ones the header counts (the section keeps its size, so `layout.link` and the SHA-256 do not change):

  ```asm
  ; ---- gfx $43C0-$47C0 (1024 bytes) [CONFIRMED] tiles-vram: 1 call site(s); first: hdma_rom_to_vram at 0E:4231: hl=$43C0 a=$0E c=$40 de=$8000 (dest VRAM $8000, vbank=0)

  Gfx_Title_Tiles0:: ; 0E:43C0
  Data_0E_43C0::
  	INCBIN "gfx/title/title_screen/title_tiles0.2bpp"
  ```
  ```asm
  Palette_Title_Bg:: ; 0E:5F30
  Data_0E_5F30::
  	INCLUDE "gfx/title/title_screen/title_bg.pal"
  ```
* **Paths**: `INCBIN` / `INCLUDE` paths are written relative to the repository root, with `/`, and resolve because the Makefile runs `rgbasm` from the root with `-I .`
  (`RGBASMFLAGS := -Weverything -P includes.asm -I .`); nothing else has to be configured.  The `-M` dependency files list every asset, so editing a `.2bpp` / `.pal` re-assembles only the file
  that includes it.  `.pal` files use the `RGB` macro of `constants/gfx_macros.inc` (`dw (b << 10) | (g << 5) | r`, components 0-31; e.g. `RGB 31, 31, 31` = `dw $7FFF`), pre-included by `includes.asm`.
* **Names**: directory = the `.asm` path without `.asm` (`gfx/title/title_screen.asm` -> `gfx/title/title_screen/`; fonts are directly in `data/fonts/`); file = the semantic label in `snake_case`
  without a leading `Gfx_` (and without a leading `tilemap_` / `attrmap_` / `palette_` that the extension repeats) (`Gfx_Title_Tiles0` -> `title_tiles0.2bpp`, `Palette_Title_Bg` -> `title_bg.pal`), or
  `<kind>_<addr>` (address in the bank, lowercase hex: `tiles_4000.2bpp`) when the block only has a neutral label.  A name says what the label or header says, not more: naming a screen needs
  evidence like any other name (rename the asset, its `INCBIN` line and the manifest together).
* **PNG <-> 2bpp**: the PNG is an indexed 4-shade image, 16 tiles per row (see `gfx/README.md`), and is the *exact source* of the `.2bpp` next to it:

  ```
  rgbgfx -c embedded -o gfx/title/title_screen/title_tiles0.2bpp gfx/title/title_screen/title_tiles0.png     # add -x <pad> when assets.tsv lists pad > 0
  python3 tools/gfx_export.py bin       # the same for every exact PNG (paths and pad from gfx/assets.tsv)
  python3 tools/gfx_export.py png       # the other way: every .2bpp/.1bpp/.bin -> PNG (also refreshes the view-only sheets)
  python3 tools/gfx_export.py check     # every PNG through rgbgfx == its .2bpp, every view sheet decodes back to its bytes, INCBIN sizes, manifest
  ```

  `rgbgfx` (shipped with RGBDS 1.0.3) is **optional**: it is only needed to edit PNGs; the ROM build never runs it.  Flags that would change the bytes are not used: no `-u` / `-m` (no tile dedupe),
  no `-t`, no palette reordering (`-c embedded` keeps the PNG's index order).  A view-only `_view.png` is never converted back.
* **A changed asset changes the ROM**: an edited `.2bpp` gives a ROM with a different hash.  Keep the size (the section must not grow, see section 2).
* **New assets**: put the file under `gfx/<area>/<name>/`, add a row to `gfx/assets.tsv` (columns as in its header; `png` = `-` before the first `png` run), `INCBIN` it at the right place with the block
  header and evidence status kept, then run `python3 tools/gfx_export.py png` (PNG + `png`/`pad` columns), `check` and `readme`.
* A `gfx` region inside a code file is converted like any other; its assets live in `gfx/<path of the .asm without its first directory, without .asm>/` (`engine/mail/result_screens.asm` gives
  `gfx/mail/result_screens/`).
* `.gitattributes` in `gfx/` and `data/fonts/` mark the binaries as binary (an attribute map without a NUL byte would otherwise be text to git and be changed by line-ending conversion).

**PNG is the source.** The graphics binaries (`.2bpp`, `.1bpp`, font `.bin`) are built from their PNG (`gfx/png_rules.tsv`, generated `gfx/png.mk`): edit the PNG, not the binary. `.tilemap`, `.attrmap` and `.pal`
are edited directly or through `tools/screen_png.py import`. After adding or removing assets run `python3 tools/png_rules.py rules` on an unedited tree, then `make png-check`.

## 9. Words, tables and pointers

* `words` = 16-bit values (`dw $B014, $B025, $B036` with the meaning in the header), `ptrtable` = address tables (`dw String_6A_64D3`: targets that have a label are written as labels; numeric ones
  such as `dw $6A64` stay numeric until the target has a name).
* `ptrtable` entries may point at string lines: `tools/ptr_labels.py` adds a generic `String_BB_AAAA::` label on demand.  A numeric `dw` becomes a label only when a label or a string-line start
  exists at that address in the same bank, all-or-nothing per table; record tables whose region note documents the pointer field are written `dw Label` followed by `db $xx` lines.
* Inline jump tables (`JumpTableInline`, `FarJumpTable`, `home/jump_table.asm`) are `dw` lists behind the call that uses them.

## 10. Checks and tools

| command | what it proves |
|---|---|
| `make` | every file assembles (warning-free), the link fits `layout.link`, the ROM has the reference SHA-256 (byte compare too when the original ROM is present) |
| `make sym-check` (`tools/sym_check.py [--fix]`) | every label is defined once and its `; BB:AAAA` comment matches `build/mobile_trainer.sym` |
| `python3 tools/tidy_comments.py --check`, `python3 tools/localize_labels.py --check` | the tree is in the form of section 3 / local-label form of section 4 (they are idempotent) |
| `python3 tools/gen_sjis_charmap.py --check`, `python3 tools/text_to_strings.py --dry-run` | the charmap is current / no numeric text block is left to convert |
| `python3 tools/gfx_export.py check` | the PNGs, `.2bpp` files, sizes and `gfx/assets.tsv` agree (needs `rgbgfx`) |
| `python3 tools/apply_overlay_aliases.py --check` | every alias of `ram/overlays.asm` is defined once, has a neutral WRAM0/HRAM base, and is used only inside the scope of its group |
| `python3 tools/apply_banked_names.py --check` | every pair of overlapping bank-qualified names in `ram/banked.asm` is a container and its field, a documented overlay, or used in disjoint files |
| `python3 tools/apply_ram_operands.py --areas wram0,hram,io --check` | no `ld hl\|de\|bc, $XXXX` of WRAM0, HRAM or the hardware registers is left numeric where an object covers the address (overlay bases excepted) |
| `python3 tools/apply_ram_operands.py --areas wramx --check` | no banked `ld hl\|de\|bc, $Dxxx` that a consumer rule of `analysis/naming2/wramx_consumers.tsv` proves is left numeric |
| `python3 tools/apply_ram_operands.py --elements wSpriteSlots --observed --check` | no `wSpriteSlots + N` is left where bank 7 is shown (needs rgbasm: it builds a marked copy of the tree) |

**Applying renames.** Names are changed with `python3 tools/apply_renames.py --manifest FILE` (manifest: TAB-separated `old_name new_name kind status evidence`; HYPOTHESIS rows are never applied).
It renames the definition (`New:: ; BB:AAAA`; the neutral old name stays below it as an alias without comment) and every reference in all `.asm`/`.inc` files, refuses unsafe rows (collisions,
non-unique or alias old names, conflicting rows), runs `make`, checks the SHA-256 and `sym_check`, and restores every file on failure.  Use `--dry-run` first, `--annotate` to add a
`; name evidence:` line.  The manifests that produced the current names are `analysis/naming2/*_renames.tsv` (evidence per row) with notes in `docs/research/naming2_*.md`.  Tests:
`python3 tools/test_apply_renames.py`.

**Applying overlay aliases.** Screen-local aliases of overlay variables (section 4, RAM) are added with `python3 tools/apply_overlay_aliases.py --manifest FILE` (manifest: TAB-separated
`alias base scope status evidence`, scope = files, globs, `!` exclusions and function ranges `path@LabelA..LabelB`, HYPOTHESIS rows are never applied): it appends the `DEF` lines to `ram/overlays.asm`, rewrites every mention of the neutral name in
the scope files, refuses unsafe rows (collisions, banked or already-named bases, a scope file that does not mention the base, overlapping scopes), runs `make`, checks the SHA-256 and
`sym_check`, and restores every file on failure.  Use `--dry-run` first.  The manifests are `analysis/naming2/overlay_aliases*.tsv`.  Tests: `python3 tools/test_overlay_aliases.py`.

**Applying banked names.** Bank-qualified names and the raw operands that use them are added with `python3 tools/apply_banked_names.py --names FILE --sites FILE` (names: TAB-separated
`name address bank size kind status evidence`; sites: `file operand name sites proof`, the file may carry a function range `path@LabelA..LabelB`; HYPOTHESIS rows are never applied): it appends the `DEF` lines to
`ram/banked.asm`, replaces the counted `ld hl|de|bc, $XXXX` lines, refuses a wrong count, an operand outside its name or a name defined twice, runs `make`, checks the SHA-256 and `sym_check`, and restores every file on
failure.  Use `--dry-run` first.  The manifests are `analysis/naming2/sram4_*.tsv`.  Tests: `python3 tools/test_banked_names.py`.

**Applying RAM operands.** `python3 tools/apply_ram_operands.py --areas wram0,hram,io` rewrites the raw pointer operands described in section 4 (RAM pointer operands) from the `DEF` lines of `ram/wram.asm`, `ram/hram.asm` and
`constants/hardware.inc` (no manifest: the object table is the rule), runs `make`, checks the SHA-256 and `sym_check`, and restores every file on failure.  Use `--dry-run` first.  The record of the mapping is
`analysis/naming2/ramop6_names.tsv`.  `--areas wramx` (banked WRAM, rules in `analysis/naming2/wramx_consumers.tsv`, bank effects of routines in `analysis/naming2/wramx_calls.tsv`) and `--elements NAME [--observed]` (an array's `NAME + N` expressions as element names) work the same way;
`python3 tools/line_addresses.py file.asm:LINE ...` prints the bank and the address of a source line (it builds a marked copy of the tree and never touches the repository).  Tests: `python3 tools/test_ram_operands.py`.

## 11. Git and commits

* Small commits, one topic each; `make` must print `SHA-256 OK` (unless the commit is a deliberate ROM change, which says so).
* Do not commit `mobile_trainer.gbc`, `build/`, or the original ROM (git-ignored).
