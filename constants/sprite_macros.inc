; constants/sprite_macros.inc -- macros for the sprite-object data of the ROM (pre-included through includes.asm).
;
; Every macro emits exactly the bytes that the sprite engine in bank 00 (home/sprites.asm: Sprite_InitSlot 00:0A82,
; Sprite_LoadObjectEntry 00:0AB8, Sprite_StepAndDrawSlot 00:0AE8) reads; nothing here adds, reorders or pads a byte.  The names say what the
; bytes are, not what a screen shows.  The full evidence for each format (CONFIRMED / PROBABLE / HYPOTHESIS per construct) and the open
; questions are in docs/research/sprite_format.md; the generator of the macro form is tools/sprite_to_macros.py.
;
; There is no bank byte anywhere in this data: every pointer is a 16-bit address in the ROM bank that the caller passes in A to
; Sprite_InitSlot (stored at slot+0E before the table is read), so `dw Label` is correct only for a label of that same bank.
;
;   object table one entry per object id:  sprite_object_entry FrameTable, Script        (4 bytes: dw, dw)
;                  the entry used is DE + 4 * (id & $7F); bit 7 of the id is stored in the slot and decides what happens when the
;                  script ends (set: start again, clear: stop stepping, the last frame stays drawn); an id of 0 (bit 7 clear) is a
;                  slot that is never stepped.  35 of the 49 tables have a real entry 0 (reachable as id $80), 14 a null one,
;                  written `sprite_object_entry 0, 0`
;   frame table    one pointer to a frame record per frame index:  sprite_frame_table Record0, Record1, ...   (dw list)
;                  it has no count byte; its length is only implied by the records that follow it and by the script's frame indices
;                  (several sprite_frame_table lines in a row are one table)
;   frame record   sprite_frame n, followed by n lines  sprite_oam y, x, tile, attr     (1 + 4n bytes)
;                  y, x are ADDED to the slot's Y + 16 / X + 8 (mod 256, so a byte above $7F reads as negative: it is written as a signed
;                  number), tile and attr go to the shadow OAM entry unchanged except attr = (attr AND slot+0A) OR slot+09 (default
;                  AND $FF, OR $00 = unchanged)
;   script         sprite_anim n, followed by n lines  sprite_anim_step frame, delay     (1 + 2n bytes)
;                  frame = index into the frame table ($FF = draw nothing, never used by the data), delay = Sprite_UpdateAll passes that
;                  the step lasts (counted down once per pass; 0 and 1 would both advance on the next pass, neither occurs in the data)
;
; The attr operand of sprite_oam is a CGB OAM attribute byte: bits 0-2 palette number, plus OAMF_BANK1 / OAMF_XFLIP / OAMF_YFLIP
; (constants/hardware.inc) for bits 3 / 5 / 6, the only bits that occur in the data.  The byte is copied to shadow OAM and from there by the
; OAM DMA routine (00:05AC) to OAM, so the hardware meaning of the bits applies (PROBABLE: the pass-through is CONFIRMED by the engine code,
; the bit meanings are the hardware's; the data evidence is in the research note).  A palette-only value is written as the plain number.
;
; The count macros check at assembly time that the number of following lines matches the count (a line too many or too few is an error in
; the same file; the byte stream cannot silently shift).

DEF _sprite_oam_left = 0
DEF _sprite_step_left = 0

MACRO _sprite_closed
	ASSERT _sprite_oam_left == 0, "sprite_frame: fewer sprite_oam lines than its count"
	ASSERT _sprite_step_left == 0, "sprite_anim: fewer sprite_anim_step lines than its count"
ENDM

; sprite_object_entry FrameTable, Script
MACRO sprite_object_entry
	_sprite_closed
	ASSERT _NARG == 2, "sprite_object_entry takes FrameTable, Script"
	dw \1, \2
ENDM

; sprite_frame_table Record0 [, Record1 ...]
MACRO sprite_frame_table
	_sprite_closed
	ASSERT _NARG >= 1, "sprite_frame_table takes at least one record"
	dw \#
ENDM

; sprite_frame n : record with n OAM pieces (the next n lines are sprite_oam)
MACRO sprite_frame
	_sprite_closed
	ASSERT _NARG == 1 && (\1) >= 0 && (\1) <= 255, "sprite_frame takes a count 0-255"
	DEF _sprite_oam_left = (\1)
	db (\1)
ENDM

; sprite_oam y, x, tile, attr : one OAM piece of a record
MACRO sprite_oam
	ASSERT _sprite_oam_left > 0, "sprite_oam outside a sprite_frame or more lines than its count"
	ASSERT _NARG == 4, "sprite_oam takes y, x, tile, attr"
	DEF _sprite_oam_left -= 1
	db (\1), (\2), (\3), (\4)
ENDM

; sprite_anim n : script with n steps (the next n lines are sprite_anim_step)
MACRO sprite_anim
	_sprite_closed
	ASSERT _NARG == 1 && (\1) >= 0 && (\1) <= 255, "sprite_anim takes a count 0-255"
	DEF _sprite_step_left = (\1)
	db (\1)
ENDM

; sprite_anim_step frame, delay : one step of a script
MACRO sprite_anim_step
	ASSERT _sprite_step_left > 0, "sprite_anim_step outside a sprite_anim or more lines than its count"
	ASSERT _NARG == 2, "sprite_anim_step takes frame, delay"
	DEF _sprite_step_left -= 1
	db (\1), (\2)
ENDM
