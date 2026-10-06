; gfx/mail/compose_objects.asm
; bank 29, $6290-$64F4 (612 bytes); pinned by layout.link
; animation entry tables, OAM frames and scripts (bank 2D reads 6350)

SECTION "gfx/mail/compose_objects", ROMX

; ---- words $6290-$62C0 (48 bytes) [PROBABLE] animation entry table: 12 entries of 4 bytes (frame-table pointer, script pointer) in the format of the sprite-slot initialiser 00:0A82/0AB8 (4-byte entry at DE+4*(A&$3F): word -> slot[2..3] frame table, word -> slot[6..7] script); each animation appears 4 times in a row (4 identical entries)

Table_29_6290:: ; 29:6290
	dw Table_29_62C0, Data_29_62EF, Table_29_62C0, Data_29_62EF, Table_29_62C0, Data_29_62EF, Table_29_62C0, Data_29_62EF
	dw Table_29_62F2, Data_29_6318, Table_29_62F2, Data_29_6318, Table_29_62F2, Data_29_6318, Table_29_62F2, Data_29_6318
	dw Table_29_631D, Data_29_6343, Table_29_631D, Data_29_6343, Table_29_631D, Data_29_6343, Table_29_631D, Data_29_6343

; ---- words $62C0-$62C2 (2 bytes) [PROBABLE] frame table: 1 pointer(s) $62C2 to OAM frames (extent = first target); pointed to by an animation entry

Table_29_62C0:: ; 29:62C0
	dw Data_29_62C2

; ---- data $62C2-$62EF (45 bytes) [PROBABLE] OAM frame: count=11 then 11 x (y,x,tile,attr) = 45 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

Data_29_62C2:: ; 29:62C2
	db $0B, $00, $08, $00, $02, $00, $10, $01, $02, $00, $18, $02, $02, $08, $00, $03
	db $02, $08, $08, $04, $02, $08, $10, $05, $02, $08, $18, $06, $02, $10, $00, $07
	db $02, $10, $08, $2A, $02, $10, $10, $2B, $02, $10, $18, $2C, $02

; ---- data $62EF-$62F2 (3 bytes) [HYPOTHESIS] 3-byte animation script record 01 00 04 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

Data_29_62EF:: ; 29:62EF
	db $01, $00, $04

; ---- words $62F2-$62F6 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $62F6, $6307 to OAM frames (extent = first target); pointed to by an animation entry

Table_29_62F2:: ; 29:62F2
	dw Data_29_62F6, Data_29_6307

; ---- data $62F6-$6307 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

Data_29_62F6:: ; 29:62F6
	db $04, $00, $00, $08, $01, $00, $08, $09, $01, $00, $1A, $0A, $01, $00, $22, $0B
	db $01

; ---- data $6307-$6318 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

Data_29_6307:: ; 29:6307
	db $04, $FF, $00, $08, $01, $FF, $08, $09, $01, $00, $1A, $0A, $01, $00, $22, $0B
	db $01

; ---- data $6318-$631D (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

Data_29_6318:: ; 29:6318
	db $02, $00, $2E, $01, $08

; ---- words $631D-$6321 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6321, $6332 to OAM frames (extent = first target); pointed to by an animation entry

Table_29_631D:: ; 29:631D
	dw Data_29_6321, Data_29_6332

; ---- data $6321-$6332 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

Data_29_6321:: ; 29:6321
	db $04, $00, $1A, $08, $01, $00, $22, $09, $01, $00, $00, $0A, $01, $00, $08, $0B
	db $01

; ---- data $6332-$6343 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

Data_29_6332:: ; 29:6332
	db $04, $00, $1A, $08, $01, $00, $22, $09, $01, $FF, $00, $0A, $01, $FF, $08, $0B
	db $01

; ---- data $6343-$6348 (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

Data_29_6343:: ; 29:6343
	db $02, $00, $2E, $01, $08

; ---- zero $6348-$6350 (8 bytes) [PROBABLE] zero padding inside the animation-resource block
	ds $8, $00

; ---- words $6350-$63F0 (160 bytes) [PROBABLE] animation entry table: 40 entries of 4 bytes (frame-table pointer, script pointer) in the format of the sprite-slot initialiser 00:0A82/0AB8 (4-byte entry at DE+4*(A&$3F): word -> slot[2..3] frame table, word -> slot[6..7] script); each animation appears 4 times in a row (4 identical entries)

Table_MailBody_ObjectEntries:: ; 29:6350
Table_29_6350::
	sprite_object_entry MailBody_29_Anim0Frames, MailBody_29_Anim0Script ; entry 0
	sprite_object_entry MailBody_29_Anim0Frames, MailBody_29_Anim0Script ; entry 1
	sprite_object_entry MailBody_29_Anim0Frames, MailBody_29_Anim0Script ; entry 2
	sprite_object_entry MailBody_29_Anim0Frames, MailBody_29_Anim0Script ; entry 3
Table_MailBody_ObjectEntries_Entry4:: ; 29:6360
	sprite_object_entry MailBody_29_Anim4Frames, MailBody_29_Anim4Script ; entry 4
	sprite_object_entry MailBody_29_Anim4Frames, MailBody_29_Anim4Script ; entry 5
	sprite_object_entry MailBody_29_Anim4Frames, MailBody_29_Anim4Script ; entry 6
	sprite_object_entry MailBody_29_Anim4Frames, MailBody_29_Anim4Script ; entry 7
Table_MailBody_ObjectEntries_Entry8:: ; 29:6370
	sprite_object_entry MailBody_29_Anim8Frames, MailBody_29_Anim8Script ; entry 8
	sprite_object_entry MailBody_29_Anim8Frames, MailBody_29_Anim8Script ; entry 9
	sprite_object_entry MailBody_29_Anim8Frames, MailBody_29_Anim8Script ; entry 10
	sprite_object_entry MailBody_29_Anim8Frames, MailBody_29_Anim8Script ; entry 11
Table_MailBody_ObjectEntries_Entry12:: ; 29:6380
	sprite_object_entry MailBody_29_Anim12Frames, MailBody_29_Anim12Script ; entry 12
	sprite_object_entry MailBody_29_Anim12Frames, MailBody_29_Anim12Script ; entry 13
	sprite_object_entry MailBody_29_Anim12Frames, MailBody_29_Anim12Script ; entry 14
	sprite_object_entry MailBody_29_Anim12Frames, MailBody_29_Anim12Script ; entry 15
Table_MailBody_ObjectEntries_Entry16:: ; 29:6390
	sprite_object_entry MailBody_29_Anim16Frames, MailBody_29_Anim16Script ; entry 16
	sprite_object_entry MailBody_29_Anim16Frames, MailBody_29_Anim16Script ; entry 17
	sprite_object_entry MailBody_29_Anim16Frames, MailBody_29_Anim16Script ; entry 18
	sprite_object_entry MailBody_29_Anim16Frames, MailBody_29_Anim16Script ; entry 19
Table_MailBody_ObjectEntries_Entry20:: ; 29:63A0
	sprite_object_entry MailBody_29_Anim20Frames, MailBody_29_Anim20Script ; entry 20
	sprite_object_entry MailBody_29_Anim20Frames, MailBody_29_Anim20Script ; entry 21
	sprite_object_entry MailBody_29_Anim20Frames, MailBody_29_Anim20Script ; entry 22
	sprite_object_entry MailBody_29_Anim20Frames, MailBody_29_Anim20Script ; entry 23
Table_MailBody_ObjectEntries_Entry24:: ; 29:63B0
	sprite_object_entry MailBody_29_Anim24Frames, MailBody_29_Anim24Script ; entry 24
	sprite_object_entry MailBody_29_Anim24Frames, MailBody_29_Anim24Script ; entry 25
	sprite_object_entry MailBody_29_Anim24Frames, MailBody_29_Anim24Script ; entry 26
	sprite_object_entry MailBody_29_Anim24Frames, MailBody_29_Anim24Script ; entry 27
Table_MailBody_ObjectEntries_Entry28:: ; 29:63C0
	sprite_object_entry MailBody_29_Anim28Frames, MailBody_29_Anim28Script ; entry 28
	sprite_object_entry MailBody_29_Anim28Frames, MailBody_29_Anim28Script ; entry 29
	sprite_object_entry MailBody_29_Anim28Frames, MailBody_29_Anim28Script ; entry 30
	sprite_object_entry MailBody_29_Anim28Frames, MailBody_29_Anim28Script ; entry 31
	sprite_object_entry MailBody_29_Anim32Frames, MailBody_29_Anim32Script ; entry 32
	sprite_object_entry MailBody_29_Anim32Frames, MailBody_29_Anim32Script ; entry 33
	sprite_object_entry MailBody_29_Anim32Frames, MailBody_29_Anim32Script ; entry 34
	sprite_object_entry MailBody_29_Anim32Frames, MailBody_29_Anim32Script ; entry 35
	sprite_object_entry MailBody_29_Anim36Frames, MailBody_29_Anim36Script ; entry 36
	sprite_object_entry MailBody_29_Anim36Frames, MailBody_29_Anim36Script ; entry 37
	sprite_object_entry MailBody_29_Anim36Frames, MailBody_29_Anim36Script ; entry 38
	sprite_object_entry MailBody_29_Anim36Frames, MailBody_29_Anim36Script ; entry 39

; ---- words $63F0-$63F2 (2 bytes) [HYPOTHESIS] frame table: 1 pointer(s) $63F2 to OAM frames (extent = first target) [verifier: NO entry of the two entry tables 6290/6350 (and no other word/ld in the ROM) references this object: an unreferenced 13th animation in the block; structure (frame table extent = first target, frame count, script count) matches its siblings and tiles into 6406]

Table_29_63F0:: ; 29:63F0
	dw Data_29_63F2

; ---- data $63F2-$6403 (17 bytes) [HYPOTHESIS] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table [verifier: NO entry of the two entry tables 6290/6350 (and no other word/ld in the ROM) references this object: an unreferenced 13th animation in the block; structure (frame table extent = first target, frame count, script count) matches its siblings and tiles into 6406]

Data_29_63F2:: ; 29:63F2
	db $04, $00, $00, $0C, $00, $00, $08, $0D, $00, $08, $00, $0E, $00, $08, $08, $0F
	db $00

; ---- data $6403-$6406 (3 bytes) [HYPOTHESIS] 3-byte animation script record 01 00 04 [verifier: NO entry of the two entry tables 6290/6350 (and no other word/ld in the ROM) references this object: an unreferenced 13th animation in the block; structure (frame table extent = first target, frame count, script count) matches its siblings and tiles into 6406]

Data_29_6403:: ; 29:6403
	db $01, $00, $04

; ---- words $6406-$640A (4 bytes) [PROBABLE] frame table: 2 pointer(s) $640A, $640F to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim0Frames:: ; 29:6406
Table_29_6406::
	sprite_frame_table MailBody_29_Anim0Frame0, MailBody_29_Anim0Frame1

; ---- data $640A-$640F (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim0Frame0:: ; 29:640A
Data_29_640A::
	sprite_frame 1
	sprite_oam 0, 0, $00, 1

; ---- data $640F-$6414 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim0Frame1:: ; 29:640F
Data_29_640F::
	sprite_frame 1
	sprite_oam -1, 0, $00, 1

; ---- data $6414-$6419 (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim0Script:: ; 29:6414
Data_29_6414::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $6419-$641D (4 bytes) [PROBABLE] frame table: 2 pointer(s) $641D, $6422 to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim4Frames:: ; 29:6419
Table_29_6419::
	sprite_frame_table MailBody_29_Anim4Frame0, MailBody_29_Anim4Frame1

; ---- data $641D-$6422 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim4Frame0:: ; 29:641D
Data_29_641D::
	sprite_frame 1
	sprite_oam 0, 0, $01, 1

; ---- data $6422-$6427 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim4Frame1:: ; 29:6422
Data_29_6422::
	sprite_frame 1
	sprite_oam -1, 0, $01, 1

; ---- data $6427-$642C (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim4Script:: ; 29:6427
Data_29_6427::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $642C-$6430 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6430, $6435 to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim8Frames:: ; 29:642C
Table_29_642C::
	sprite_frame_table MailBody_29_Anim8Frame0, MailBody_29_Anim8Frame1

; ---- data $6430-$6435 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim8Frame0:: ; 29:6430
Data_29_6430::
	sprite_frame 1
	sprite_oam 0, 0, $02, 1

; ---- data $6435-$643A (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim8Frame1:: ; 29:6435
Data_29_6435::
	sprite_frame 1
	sprite_oam -1, 0, $02, 1

; ---- data $643A-$643F (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim8Script:: ; 29:643A
Data_29_643A::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $643F-$6443 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6443, $6448 to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim12Frames:: ; 29:643F
Table_29_643F::
	sprite_frame_table MailBody_29_Anim12Frame0, MailBody_29_Anim12Frame1

; ---- data $6443-$6448 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim12Frame0:: ; 29:6443
Data_29_6443::
	sprite_frame 1
	sprite_oam 0, 0, $03, 1

; ---- data $6448-$644D (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim12Frame1:: ; 29:6448
Data_29_6448::
	sprite_frame 1
	sprite_oam -1, 0, $03, 1

; ---- data $644D-$6452 (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim12Script:: ; 29:644D
Data_29_644D::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $6452-$6456 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6456, $645B to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim16Frames:: ; 29:6452
Table_29_6452::
	sprite_frame_table MailBody_29_Anim16Frame0, MailBody_29_Anim16Frame1

; ---- data $6456-$645B (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim16Frame0:: ; 29:6456
Data_29_6456::
	sprite_frame 1
	sprite_oam 0, 0, $04, 1

; ---- data $645B-$6460 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim16Frame1:: ; 29:645B
Data_29_645B::
	sprite_frame 1
	sprite_oam -1, 0, $04, 1

; ---- data $6460-$6465 (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim16Script:: ; 29:6460
Data_29_6460::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $6465-$6469 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $6469, $646E to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim20Frames:: ; 29:6465
Table_29_6465::
	sprite_frame_table MailBody_29_Anim20Frame0, MailBody_29_Anim20Frame1

; ---- data $6469-$646E (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim20Frame0:: ; 29:6469
Data_29_6469::
	sprite_frame 1
	sprite_oam 0, 0, $05, 1

; ---- data $646E-$6473 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim20Frame1:: ; 29:646E
Data_29_646E::
	sprite_frame 1
	sprite_oam -1, 0, $05, 1

; ---- data $6473-$6478 (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim20Script:: ; 29:6473
Data_29_6473::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $6478-$647C (4 bytes) [PROBABLE] frame table: 2 pointer(s) $647C, $6481 to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim24Frames:: ; 29:6478
Table_29_6478::
	sprite_frame_table MailBody_29_Anim24Frame0, MailBody_29_Anim24Frame1

; ---- data $647C-$6481 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim24Frame0:: ; 29:647C
Data_29_647C::
	sprite_frame 1
	sprite_oam 0, 0, $06, 1

; ---- data $6481-$6486 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim24Frame1:: ; 29:6481
Data_29_6481::
	sprite_frame 1
	sprite_oam -1, 0, $06, 1

; ---- data $6486-$648B (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim24Script:: ; 29:6486
Data_29_6486::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $648B-$648F (4 bytes) [PROBABLE] frame table: 2 pointer(s) $648F, $6494 to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim28Frames:: ; 29:648B
Table_29_648B::
	sprite_frame_table MailBody_29_Anim28Frame0, MailBody_29_Anim28Frame1

; ---- data $648F-$6494 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim28Frame0:: ; 29:648F
Data_29_648F::
	sprite_frame 1
	sprite_oam 0, 0, $07, 1

; ---- data $6494-$6499 (5 bytes) [PROBABLE] OAM frame: count=1 then 1 x (y,x,tile,attr) = 5 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim28Frame1:: ; 29:6494
Data_29_6494::
	sprite_frame 1
	sprite_oam -1, 0, $07, 1

; ---- data $6499-$649E (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim28Script:: ; 29:6499
Data_29_6499::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $649E-$64A2 (4 bytes) [PROBABLE] frame table: 2 pointer(s) $64A2, $64B3 to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim32Frames:: ; 29:649E
Table_29_649E::
	sprite_frame_table MailBody_29_Anim32Frame0, MailBody_29_Anim32Frame1

; ---- data $64A2-$64B3 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim32Frame0:: ; 29:64A2
Data_29_64A2::
	sprite_frame 4
	sprite_oam 0, 0, $08, 1
	sprite_oam 0, 8, $09, 1
	sprite_oam 0, 26, $0A, 1
	sprite_oam 0, 34, $0B, 1

; ---- data $64B3-$64C4 (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim32Frame1:: ; 29:64B3
Data_29_64B3::
	sprite_frame 4
	sprite_oam -1, 0, $08, 1
	sprite_oam -1, 8, $09, 1
	sprite_oam 0, 26, $0A, 1
	sprite_oam 0, 34, $0B, 1

; ---- data $64C4-$64C9 (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim32Script:: ; 29:64C4
Data_29_64C4::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8

; ---- words $64C9-$64CD (4 bytes) [PROBABLE] frame table: 2 pointer(s) $64CD, $64DE to OAM frames (extent = first target); pointed to by an animation entry

MailBody_29_Anim36Frames:: ; 29:64C9
Table_29_64C9::
	sprite_frame_table MailBody_29_Anim36Frame0, MailBody_29_Anim36Frame1

; ---- data $64CD-$64DE (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim36Frame0:: ; 29:64CD
Data_29_64CD::
	sprite_frame 4
	sprite_oam 0, 26, $08, 1
	sprite_oam 0, 34, $09, 1
	sprite_oam 0, 0, $0A, 1
	sprite_oam 0, 8, $0B, 1

; ---- data $64DE-$64EF (17 bytes) [PROBABLE] OAM frame: count=4 then 4 x (y,x,tile,attr) = 17 bytes (same layout as the frames of bank 50:6CC4, tuples emitted by the 00:0AE8 sprite engine); pointed to by a frame table

MailBody_29_Anim36Frame1:: ; 29:64DE
Data_29_64DE::
	sprite_frame 4
	sprite_oam 0, 26, $08, 1
	sprite_oam 0, 34, $09, 1
	sprite_oam -1, 0, $0A, 1
	sprite_oam -1, 8, $0B, 1

; ---- data $64EF-$64F4 (5 bytes) [HYPOTHESIS] 5-byte animation script record 02 00 2e 01 08 (referenced as 2nd word of an animation entry; slot[6..7]; byte format not decoded)

MailBody_29_Anim36Script:: ; 29:64EF
Data_29_64EF::
	sprite_anim 2
	sprite_anim_step 0, 46
	sprite_anim_step 1, 8
