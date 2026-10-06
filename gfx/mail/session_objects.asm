; gfx/mail/session_objects.asm
; bank 28, $6F20-$7A5D (2877 bytes); pinned by layout.link
; object tables/records for the transfer and connect screens (banks 26/27)

SECTION "gfx/mail/session_objects", ROMX

; ---- words $6F20-$7040 (288 bytes) [PROBABLE] 18 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 6E80-7A5D (28:6E80-7A5D); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 6F24-6F28, 6F34-6F38, 7024-7028, 7034-7038 were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailSession_ObjTable_6F20:: ; 28:6F20
Table_28_6F20::
	sprite_object_entry MailSession_6F20_ObjAnimData, SpriteScript_28_7066 ; entry 0
	sprite_object_entry MailSession_6F20_ObjAnimData, SpriteScript_28_7066 ; entry 1
	sprite_object_entry MailSession_6F20_ObjAnimData, SpriteScript_28_7066 ; entry 2
	sprite_object_entry MailSession_6F20_ObjAnimData, SpriteScript_28_7066 ; entry 3
MailSession_ObjTable_6F20_Entry4:: ; 28:6F30
	sprite_object_entry SpriteFrameTable_28_72AF, SpriteScript_28_72D5 ; entry 4
	sprite_object_entry SpriteFrameTable_28_72AF, SpriteScript_28_72D5 ; entry 5
	sprite_object_entry SpriteFrameTable_28_72AF, SpriteScript_28_72D5 ; entry 6
	sprite_object_entry SpriteFrameTable_28_72AF, SpriteScript_28_72D5 ; entry 7
MailSession_ObjTable_6F20_Entry8:: ; 28:6F40
	sprite_object_entry SpriteFrameTable_28_706B, SpriteScript_28_70A4 ; entry 8
	sprite_object_entry SpriteFrameTable_28_706B, SpriteScript_28_70A4 ; entry 9
	sprite_object_entry SpriteFrameTable_28_706B, SpriteScript_28_70A4 ; entry 10
	sprite_object_entry SpriteFrameTable_28_706B, SpriteScript_28_70A4 ; entry 11
	sprite_object_entry SpriteFrameTable_28_71BE, SpriteScript_28_71F7 ; entry 12
	sprite_object_entry SpriteFrameTable_28_71BE, SpriteScript_28_71F7 ; entry 13
	sprite_object_entry SpriteFrameTable_28_71BE, SpriteScript_28_71F7 ; entry 14
	sprite_object_entry SpriteFrameTable_28_71BE, SpriteScript_28_71F7 ; entry 15
	sprite_object_entry SpriteFrameTable_28_71FE, SpriteScript_28_7234 ; entry 16
	sprite_object_entry SpriteFrameTable_28_71FE, SpriteScript_28_7234 ; entry 17
	sprite_object_entry SpriteFrameTable_28_71FE, SpriteScript_28_7234 ; entry 18
	sprite_object_entry SpriteFrameTable_28_71FE, SpriteScript_28_7234 ; entry 19
MailSession_ObjTable_6F20_Entry20:: ; 28:6F70
	sprite_object_entry SpriteFrameTable_28_70AB, SpriteScript_28_70D1 ; entry 20
	sprite_object_entry SpriteFrameTable_28_70AB, SpriteScript_28_70D1 ; entry 21
	sprite_object_entry SpriteFrameTable_28_70AB, SpriteScript_28_70D1 ; entry 22
	sprite_object_entry SpriteFrameTable_28_70AB, SpriteScript_28_70D1 ; entry 23
MailSession_ObjTable_6F20_Entry24:: ; 28:6F80
	sprite_object_entry SpriteFrameTable_28_70D6, SpriteScript_28_710F ; entry 24
	sprite_object_entry SpriteFrameTable_28_70D6, SpriteScript_28_710F ; entry 25
	sprite_object_entry SpriteFrameTable_28_70D6, SpriteScript_28_710F ; entry 26
	sprite_object_entry SpriteFrameTable_28_70D6, SpriteScript_28_710F ; entry 27
MailSession_ObjTable_6F20_Entry28:: ; 28:6F90
	sprite_object_entry SpriteFrameTable_28_7116, SpriteScript_28_7129 ; entry 28
	sprite_object_entry SpriteFrameTable_28_7116, SpriteScript_28_7129 ; entry 29
	sprite_object_entry SpriteFrameTable_28_7116, SpriteScript_28_7129 ; entry 30
	sprite_object_entry SpriteFrameTable_28_7116, SpriteScript_28_7129 ; entry 31
MailSession_ObjTable_6F20_Entry32:: ; 28:6FA0
	sprite_object_entry SpriteFrameTable_28_713A, SpriteScript_28_7173 ; entry 32
	sprite_object_entry SpriteFrameTable_28_713A, SpriteScript_28_7173 ; entry 33
	sprite_object_entry SpriteFrameTable_28_713A, SpriteScript_28_7173 ; entry 34
	sprite_object_entry SpriteFrameTable_28_713A, SpriteScript_28_7173 ; entry 35
	sprite_object_entry SpriteFrameTable_28_7239, SpriteScript_28_726F ; entry 36
	sprite_object_entry SpriteFrameTable_28_7239, SpriteScript_28_726F ; entry 37
	sprite_object_entry SpriteFrameTable_28_7239, SpriteScript_28_726F ; entry 38
	sprite_object_entry SpriteFrameTable_28_7239, SpriteScript_28_726F ; entry 39
	sprite_object_entry SpriteFrameTable_28_7274, SpriteScript_28_72AA ; entry 40
	sprite_object_entry SpriteFrameTable_28_7274, SpriteScript_28_72AA ; entry 41
	sprite_object_entry SpriteFrameTable_28_7274, SpriteScript_28_72AA ; entry 42
	sprite_object_entry SpriteFrameTable_28_7274, SpriteScript_28_72AA ; entry 43
MailSession_ObjTable_6F20_Entry44:: ; 28:6FD0
	sprite_object_entry SpriteFrameTable_28_712C, SpriteScript_28_7137 ; entry 44
	sprite_object_entry SpriteFrameTable_28_712C, SpriteScript_28_7137 ; entry 45
	sprite_object_entry SpriteFrameTable_28_712C, SpriteScript_28_7137 ; entry 46
	sprite_object_entry SpriteFrameTable_28_712C, SpriteScript_28_7137 ; entry 47
	sprite_object_entry SpriteFrameTable_28_717A, SpriteScript_28_7185 ; entry 48
	sprite_object_entry SpriteFrameTable_28_717A, SpriteScript_28_7185 ; entry 49
	sprite_object_entry SpriteFrameTable_28_717A, SpriteScript_28_7185 ; entry 50
	sprite_object_entry SpriteFrameTable_28_717A, SpriteScript_28_7185 ; entry 51
	sprite_object_entry SpriteFrameTable_28_7188, SpriteScript_28_7197 ; entry 52
	sprite_object_entry SpriteFrameTable_28_7188, SpriteScript_28_7197 ; entry 53
	sprite_object_entry SpriteFrameTable_28_7188, SpriteScript_28_7197 ; entry 54
	sprite_object_entry SpriteFrameTable_28_7188, SpriteScript_28_7197 ; entry 55
	sprite_object_entry SpriteFrameTable_28_719A, SpriteScript_28_71A9 ; entry 56
	sprite_object_entry SpriteFrameTable_28_719A, SpriteScript_28_71A9 ; entry 57
	sprite_object_entry SpriteFrameTable_28_719A, SpriteScript_28_71A9 ; entry 58
	sprite_object_entry SpriteFrameTable_28_719A, SpriteScript_28_71A9 ; entry 59
	sprite_object_entry SpriteFrameTable_28_71AC, SpriteScript_28_71BB ; entry 60
	sprite_object_entry SpriteFrameTable_28_71AC, SpriteScript_28_71BB ; entry 61
	sprite_object_entry SpriteFrameTable_28_71AC, SpriteScript_28_71BB ; entry 62
	sprite_object_entry SpriteFrameTable_28_71AC, SpriteScript_28_71BB ; entry 63
MailSession_ObjTable_6F20_Entry64:: ; 28:7020
	sprite_object_entry SpriteFrameTable_28_72DA, SpriteScript_28_72E5 ; entry 64
	sprite_object_entry SpriteFrameTable_28_72DA, SpriteScript_28_72E5 ; entry 65
	sprite_object_entry SpriteFrameTable_28_72DA, SpriteScript_28_72E5 ; entry 66
	sprite_object_entry SpriteFrameTable_28_72DA, SpriteScript_28_72E5 ; entry 67
MailSession_ObjTable_6F20_Entry68:: ; 28:7030
	sprite_object_entry SpriteFrameTable_28_72E8, SpriteScript_28_72F6 ; entry 68
	sprite_object_entry SpriteFrameTable_28_72E8, SpriteScript_28_72F6 ; entry 69
	sprite_object_entry SpriteFrameTable_28_72E8, SpriteScript_28_72F6 ; entry 70
	sprite_object_entry SpriteFrameTable_28_72E8, SpriteScript_28_72F6 ; entry 71

; ---- data $7040-$72FB (699 bytes) [PROBABLE] 18 object record(s): 18 frame tables, 33 frames, 18 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 28:6E80-7A5D [v4: bytes 7040-7042, 7044-7055, 7067-7069, 72AF-72FB were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailSession_6F20_ObjAnimData:: ; 28:7040
Data_28_7040::
	sprite_frame_table SpriteFrame_28_7044, SpriteFrame_28_7055
SpriteFrame_28_7044:: ; 28:7044
	sprite_frame 4
	sprite_oam 3, 0, $08, 0
	sprite_oam 3, 8, $0A, 0
	sprite_oam 19, 0, $28, 0
	sprite_oam 19, 8, $2A, 0
SpriteFrame_28_7055:: ; 28:7055
	sprite_frame 4
	sprite_oam 3, 0, $0C, 0
	sprite_oam 3, 8, $0E, 0
	sprite_oam 19, 0, $2C, 0
	sprite_oam 19, 8, $2E, 0
SpriteScript_28_7066:: ; 28:7066
	sprite_anim 2
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
SpriteFrameTable_28_706B:: ; 28:706B
	sprite_frame_table SpriteFrame_28_7071, SpriteFrame_28_7082, SpriteFrame_28_7093
SpriteFrame_28_7071:: ; 28:7071
	sprite_frame 4
	sprite_oam 3, 0, $10, 0
	sprite_oam 3, 8, $12, 0
	sprite_oam 19, 0, $30, 0
	sprite_oam 19, 8, $22, 0
SpriteFrame_28_7082:: ; 28:7082
	sprite_frame 4
	sprite_oam 3, 0, $40, 0
	sprite_oam 3, 8, $42, 0
	sprite_oam 19, 0, $60, 0
	sprite_oam 19, 8, $62, 0
SpriteFrame_28_7093:: ; 28:7093
	sprite_frame 4
	sprite_oam 3, 0, $34, 0
	sprite_oam 3, 8, $36, 0
	sprite_oam 19, 8, $2A, 0
	sprite_oam 19, 0, $60, 0
SpriteScript_28_70A4:: ; 28:70A4
	sprite_anim 3
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 24
SpriteFrameTable_28_70AB:: ; 28:70AB
	sprite_frame_table SpriteFrame_28_70AF, SpriteFrame_28_70C0
SpriteFrame_28_70AF:: ; 28:70AF
	sprite_frame 4
	sprite_oam 3, 0, $08, OAMF_BANK1 | 1
	sprite_oam 3, 8, $0A, OAMF_BANK1 | 1
	sprite_oam 19, 0, $22, OAMF_XFLIP | 1
	sprite_oam 19, 8, $30, OAMF_XFLIP | 1
SpriteFrame_28_70C0:: ; 28:70C0
	sprite_frame 4
	sprite_oam 3, 0, $0C, OAMF_BANK1 | 1
	sprite_oam 3, 8, $0E, OAMF_BANK1 | 1
	sprite_oam 19, 0, $2C, OAMF_BANK1 | 1
	sprite_oam 19, 8, $2E, OAMF_BANK1 | 1
SpriteScript_28_70D1:: ; 28:70D1
	sprite_anim 2
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
SpriteFrameTable_28_70D6:: ; 28:70D6
	sprite_frame_table SpriteFrame_28_70DC, SpriteFrame_28_70ED, SpriteFrame_28_70FE
SpriteFrame_28_70DC:: ; 28:70DC
	sprite_frame 4
	sprite_oam 3, 0, $08, OAMF_BANK1 | 1
	sprite_oam 3, 8, $0A, OAMF_BANK1 | 1
	sprite_oam 19, 8, $30, OAMF_XFLIP | 1
	sprite_oam 19, 0, $22, OAMF_XFLIP | 1
SpriteFrame_28_70ED:: ; 28:70ED
	sprite_frame 4
	sprite_oam 3, 0, $4C, OAMF_BANK1 | 1
	sprite_oam 3, 8, $4E, OAMF_BANK1 | 1
	sprite_oam 19, 8, $60, OAMF_XFLIP | 1
	sprite_oam 19, 0, $62, OAMF_XFLIP | 1
SpriteFrame_28_70FE:: ; 28:70FE
	sprite_frame 4
	sprite_oam 3, 0, $40, OAMF_BANK1 | 1
	sprite_oam 3, 8, $42, OAMF_BANK1 | 1
	sprite_oam 19, 0, $2A, OAMF_XFLIP | 1
	sprite_oam 19, 8, $20, OAMF_XFLIP | 1
SpriteScript_28_710F:: ; 28:710F
	sprite_anim 3
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 24
SpriteFrameTable_28_7116:: ; 28:7116
	sprite_frame_table SpriteFrame_28_7118
SpriteFrame_28_7118:: ; 28:7118
	sprite_frame 4
	sprite_oam 3, 0, $08, OAMF_BANK1 | 1
	sprite_oam 3, 8, $0A, OAMF_BANK1 | 1
	sprite_oam 19, 0, $22, OAMF_XFLIP | 1
	sprite_oam 19, 8, $30, OAMF_XFLIP | 1
SpriteScript_28_7129:: ; 28:7129
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_712C:: ; 28:712C
	sprite_frame_table SpriteFrame_28_712E
SpriteFrame_28_712E:: ; 28:712E
	sprite_frame 2
	sprite_oam -2, 0, $5C, 4
	sprite_oam -2, 8, $5E, 4
SpriteScript_28_7137:: ; 28:7137
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_713A:: ; 28:713A
	sprite_frame_table SpriteFrame_28_7140, SpriteFrame_28_7151, SpriteFrame_28_7162
SpriteFrame_28_7140:: ; 28:7140
	sprite_frame 4
	sprite_oam 3, 0, $40, OAMF_BANK1 | 1
	sprite_oam 3, 8, $42, OAMF_BANK1 | 1
	sprite_oam 19, 0, $2A, OAMF_XFLIP | 1
	sprite_oam 19, 8, $60, OAMF_XFLIP | 1
SpriteFrame_28_7151:: ; 28:7151
	sprite_frame 4
	sprite_oam 3, 0, $44, OAMF_BANK1 | 1
	sprite_oam 3, 8, $46, OAMF_BANK1 | 1
	sprite_oam 19, 8, $64, OAMF_XFLIP | 1
	sprite_oam 19, 0, $66, OAMF_XFLIP | 1
SpriteFrame_28_7162:: ; 28:7162
	sprite_frame 4
	sprite_oam 3, 0, $48, OAMF_BANK1 | 1
	sprite_oam 3, 8, $4A, OAMF_BANK1 | 1
	sprite_oam 19, 8, $68, OAMF_XFLIP | 1
	sprite_oam 19, 0, $6A, OAMF_XFLIP | 1
SpriteScript_28_7173:: ; 28:7173
	sprite_anim 3
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 24
SpriteFrameTable_28_717A:: ; 28:717A
	sprite_frame_table SpriteFrame_28_717C
SpriteFrame_28_717C:: ; 28:717C
	sprite_frame 2
	sprite_oam 0, 4, $5C, OAMF_BANK1 | 5
	sprite_oam 0, 12, $5E, OAMF_BANK1 | 5
SpriteScript_28_7185:: ; 28:7185
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_7188:: ; 28:7188
	sprite_frame_table SpriteFrame_28_718A
SpriteFrame_28_718A:: ; 28:718A
	sprite_frame 3
	sprite_oam 0, 0, $30, OAMF_BANK1 | 5
	sprite_oam 0, 8, $58, OAMF_BANK1 | 5
	sprite_oam 0, 16, $5A, OAMF_BANK1 | 5
SpriteScript_28_7197:: ; 28:7197
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_719A:: ; 28:719A
	sprite_frame_table SpriteFrame_28_719C
SpriteFrame_28_719C:: ; 28:719C
	sprite_frame 3
	sprite_oam 0, 8, $58, OAMF_BANK1 | 5
	sprite_oam 0, 16, $5A, OAMF_BANK1 | 5
	sprite_oam 0, 0, $32, OAMF_BANK1 | 5
SpriteScript_28_71A9:: ; 28:71A9
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_71AC:: ; 28:71AC
	sprite_frame_table SpriteFrame_28_71AE
SpriteFrame_28_71AE:: ; 28:71AE
	sprite_frame 3
	sprite_oam 0, 8, $58, OAMF_BANK1 | 5
	sprite_oam 0, 16, $5A, OAMF_BANK1 | 5
	sprite_oam 0, 0, $34, OAMF_BANK1 | 5
SpriteScript_28_71BB:: ; 28:71BB
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_71BE:: ; 28:71BE
	sprite_frame_table SpriteFrame_28_71C4, SpriteFrame_28_71D5, SpriteFrame_28_71E6
SpriteFrame_28_71C4:: ; 28:71C4
	sprite_frame 4
	sprite_oam 19, 0, $64, 0
	sprite_oam 3, 0, $34, 0
	sprite_oam 3, 8, $36, 0
	sprite_oam 19, 8, $2A, 0
SpriteFrame_28_71D5:: ; 28:71D5
	sprite_frame 4
	sprite_oam 19, 0, $64, 0
	sprite_oam 19, 8, $66, 0
	sprite_oam 3, 0, $44, 0
	sprite_oam 3, 8, $46, 0
SpriteFrame_28_71E6:: ; 28:71E6
	sprite_frame 4
	sprite_oam 3, 0, $48, 0
	sprite_oam 3, 8, $4A, 0
	sprite_oam 19, 0, $68, 0
	sprite_oam 19, 8, $6A, 0
SpriteScript_28_71F7:: ; 28:71F7
	sprite_anim 3
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 24
SpriteFrameTable_28_71FE:: ; 28:71FE
	sprite_frame_table SpriteFrame_28_7202, SpriteFrame_28_721B
SpriteFrame_28_7202:: ; 28:7202
	sprite_frame 6
	sprite_oam -7, -5, $1C, OAMF_XFLIP | 4
	sprite_oam -7, -13, $1E, OAMF_XFLIP | 4
	sprite_oam 19, 0, $64, 0
	sprite_oam 3, 0, $4C, 0
	sprite_oam 3, 8, $4E, 0
	sprite_oam 19, 8, $2A, 0
SpriteFrame_28_721B:: ; 28:721B
	sprite_frame 6
	sprite_oam -8, -5, $1C, OAMF_XFLIP | 4
	sprite_oam -8, -13, $1E, OAMF_XFLIP | 4
	sprite_oam 19, 0, $64, 0
	sprite_oam 19, 8, $2A, 0
	sprite_oam 3, 0, $6C, 0
	sprite_oam 3, 8, $6E, 0
SpriteScript_28_7234:: ; 28:7234
	sprite_anim 2
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
SpriteFrameTable_28_7239:: ; 28:7239
	sprite_frame_table SpriteFrame_28_723D, SpriteFrame_28_7256
SpriteFrame_28_723D:: ; 28:723D
	sprite_frame 6
	sprite_oam -7, 13, $20, OAMF_BANK1 | 4
	sprite_oam -7, 21, $22, OAMF_BANK1 | 4
	sprite_oam 3, 0, $1C, OAMF_BANK1 | 1
	sprite_oam 3, 8, $1E, OAMF_BANK1 | 1
	sprite_oam 19, 0, $2A, OAMF_XFLIP | 1
	sprite_oam 19, 8, $60, OAMF_XFLIP | 1
SpriteFrame_28_7256:: ; 28:7256
	sprite_frame 6
	sprite_oam -8, 14, $20, OAMF_BANK1 | 4
	sprite_oam -8, 22, $22, OAMF_BANK1 | 4
	sprite_oam 3, 0, $18, OAMF_BANK1 | 1
	sprite_oam 3, 8, $1A, OAMF_BANK1 | 1
	sprite_oam 19, 0, $2A, OAMF_XFLIP | 1
	sprite_oam 19, 8, $60, OAMF_XFLIP | 1
SpriteScript_28_726F:: ; 28:726F
	sprite_anim 2
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
SpriteFrameTable_28_7274:: ; 28:7274
	sprite_frame_table SpriteFrame_28_7278, SpriteFrame_28_7291
SpriteFrame_28_7278:: ; 28:7278
	sprite_frame 6
	sprite_oam 3, 0, $14, OAMF_BANK1 | 1
	sprite_oam 3, 8, $16, OAMF_BANK1 | 1
	sprite_oam -8, 11, $24, OAMF_BANK1 | 5
	sprite_oam -3, 21, $26, OAMF_BANK1 | 5
	sprite_oam 19, 0, $2A, OAMF_XFLIP | 1
	sprite_oam 19, 8, $30, OAMF_XFLIP | 1
SpriteFrame_28_7291:: ; 28:7291
	sprite_frame 6
	sprite_oam -7, 10, $24, OAMF_BANK1 | 5
	sprite_oam -4, 20, $26, OAMF_BANK1 | 5
	sprite_oam 3, 0, $28, OAMF_BANK1 | 1
	sprite_oam 3, 8, $2A, OAMF_BANK1 | 1
	sprite_oam 19, 0, $2A, OAMF_XFLIP | 1
	sprite_oam 19, 8, $30, OAMF_XFLIP | 1
SpriteScript_28_72AA:: ; 28:72AA
	sprite_anim 2
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
SpriteFrameTable_28_72AF:: ; 28:72AF
	sprite_frame_table SpriteFrame_28_72B3, SpriteFrame_28_72C4
SpriteFrame_28_72B3:: ; 28:72B3
	sprite_frame 4
	sprite_oam 3, 8, $00, OAMF_XFLIP
	sprite_oam 3, 0, $02, OAMF_XFLIP
	sprite_oam 19, 8, $20, OAMF_XFLIP
	sprite_oam 19, 0, $22, OAMF_XFLIP
SpriteFrame_28_72C4:: ; 28:72C4
	sprite_frame 4
	sprite_oam 3, 8, $04, OAMF_XFLIP
	sprite_oam 3, 0, $06, OAMF_XFLIP
	sprite_oam 19, 8, $24, OAMF_XFLIP
	sprite_oam 19, 0, $26, OAMF_XFLIP
SpriteScript_28_72D5:: ; 28:72D5
	sprite_anim 2
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
SpriteFrameTable_28_72DA:: ; 28:72DA
	sprite_frame_table SpriteFrame_28_72DC
SpriteFrame_28_72DC:: ; 28:72DC
	sprite_frame 2
	sprite_oam 11, 8, $58, OAMF_XFLIP | 2
	sprite_oam 11, 0, $5A, OAMF_XFLIP | 2
SpriteScript_28_72E5:: ; 28:72E5
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_72E8:: ; 28:72E8
	sprite_frame_table SpriteFrame_28_72EC, SpriteFrame_28_72F5
SpriteFrame_28_72EC:: ; 28:72EC
	sprite_frame 2
	sprite_oam 0, 0, $74, 5
	sprite_oam 0, 8, $76, 5
SpriteFrame_28_72F5:: ; 28:72F5
	sprite_frame 0
SpriteScript_28_72F6:: ; 28:72F6
	sprite_anim 2
	sprite_anim_step 0, 12
	sprite_anim_step 1, 12

; ---- words $72FB-$758B (656 bytes) [PROBABLE] 41 rows of 16 bytes = 4 identical 4-byte object-table entries (ptr to frame table, ptr to script); every pointer lands on a frame-table/script start found by the sequential sweep of 6E80-7A5D (28:6E80-7A5D); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs [v4: bytes 732F-7333, 733F-7343, 734F-7353, 737F-7383, 738F-7393, 739F-73A3 ... were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailSession_ObjTable_72FB:: ; 28:72FB
Table_28_72FB::
	sprite_object_entry MailSession_72FB_ObjAnimData, SpriteScript_28_759E ; entry 0
	sprite_object_entry MailSession_72FB_ObjAnimData, SpriteScript_28_759E ; entry 1
	sprite_object_entry MailSession_72FB_ObjAnimData, SpriteScript_28_759E ; entry 2
	sprite_object_entry MailSession_72FB_ObjAnimData, SpriteScript_28_759E ; entry 3
	sprite_object_entry SpriteFrameTable_28_75A1, SpriteScript_28_75B4 ; entry 4
	sprite_object_entry SpriteFrameTable_28_75A1, SpriteScript_28_75B4 ; entry 5
	sprite_object_entry SpriteFrameTable_28_75A1, SpriteScript_28_75B4 ; entry 6
	sprite_object_entry SpriteFrameTable_28_75A1, SpriteScript_28_75B4 ; entry 7
	sprite_object_entry SpriteFrameTable_28_75B7, SpriteScript_28_75DD ; entry 8
	sprite_object_entry SpriteFrameTable_28_75B7, SpriteScript_28_75DD ; entry 9
	sprite_object_entry SpriteFrameTable_28_75B7, SpriteScript_28_75DD ; entry 10
	sprite_object_entry SpriteFrameTable_28_75B7, SpriteScript_28_75DD ; entry 11
MailSession_ObjTable_72FB_Entry12:: ; 28:732B
	sprite_object_entry SpriteFrameTable_28_75E2, SpriteScript_28_7608 ; entry 12
	sprite_object_entry SpriteFrameTable_28_75E2, SpriteScript_28_7608 ; entry 13
	sprite_object_entry SpriteFrameTable_28_75E2, SpriteScript_28_7608 ; entry 14
	sprite_object_entry SpriteFrameTable_28_75E2, SpriteScript_28_7608 ; entry 15
MailSession_ObjTable_72FB_Entry16:: ; 28:733B
	sprite_object_entry SpriteFrameTable_28_760D, SpriteScript_28_7633 ; entry 16
	sprite_object_entry SpriteFrameTable_28_760D, SpriteScript_28_7633 ; entry 17
	sprite_object_entry SpriteFrameTable_28_760D, SpriteScript_28_7633 ; entry 18
	sprite_object_entry SpriteFrameTable_28_760D, SpriteScript_28_7633 ; entry 19
MailSession_ObjTable_72FB_Entry20:: ; 28:734B
	sprite_object_entry SpriteFrameTable_28_7638, SpriteScript_28_7671 ; entry 20
	sprite_object_entry SpriteFrameTable_28_7638, SpriteScript_28_7671 ; entry 21
	sprite_object_entry SpriteFrameTable_28_7638, SpriteScript_28_7671 ; entry 22
	sprite_object_entry SpriteFrameTable_28_7638, SpriteScript_28_7671 ; entry 23
MailSession_ObjTable_72FB_Entry24:: ; 28:735B
	sprite_object_entry SpriteFrameTable_28_7678, SpriteScript_28_76C9 ; entry 24
	sprite_object_entry SpriteFrameTable_28_7678, SpriteScript_28_76C9 ; entry 25
	sprite_object_entry SpriteFrameTable_28_7678, SpriteScript_28_76C9 ; entry 26
	sprite_object_entry SpriteFrameTable_28_7678, SpriteScript_28_76C9 ; entry 27
MailSession_ObjTable_72FB_Entry28:: ; 28:736B
	sprite_object_entry SpriteFrameTable_28_76D0, SpriteScript_28_76EB ; entry 28
	sprite_object_entry SpriteFrameTable_28_76D0, SpriteScript_28_76EB ; entry 29
	sprite_object_entry SpriteFrameTable_28_76D0, SpriteScript_28_76EB ; entry 30
	sprite_object_entry SpriteFrameTable_28_76D0, SpriteScript_28_76EB ; entry 31
MailSession_ObjTable_72FB_Entry32:: ; 28:737B
	sprite_object_entry SpriteFrameTable_28_76EE, SpriteScript_28_773F ; entry 32
	sprite_object_entry SpriteFrameTable_28_76EE, SpriteScript_28_773F ; entry 33
	sprite_object_entry SpriteFrameTable_28_76EE, SpriteScript_28_773F ; entry 34
	sprite_object_entry SpriteFrameTable_28_76EE, SpriteScript_28_773F ; entry 35
MailSession_ObjTable_72FB_Entry36:: ; 28:738B
	sprite_object_entry SpriteFrameTable_28_7746, SpriteScript_28_778C ; entry 36
	sprite_object_entry SpriteFrameTable_28_7746, SpriteScript_28_778C ; entry 37
	sprite_object_entry SpriteFrameTable_28_7746, SpriteScript_28_778C ; entry 38
	sprite_object_entry SpriteFrameTable_28_7746, SpriteScript_28_778C ; entry 39
MailSession_ObjTable_72FB_Entry40:: ; 28:739B
	sprite_object_entry SpriteFrameTable_28_7791, SpriteScript_28_77C7 ; entry 40
	sprite_object_entry SpriteFrameTable_28_7791, SpriteScript_28_77C7 ; entry 41
	sprite_object_entry SpriteFrameTable_28_7791, SpriteScript_28_77C7 ; entry 42
	sprite_object_entry SpriteFrameTable_28_7791, SpriteScript_28_77C7 ; entry 43
MailSession_ObjTable_72FB_Entry44:: ; 28:73AB
	sprite_object_entry SpriteFrameTable_28_77CC, SpriteScript_28_7802 ; entry 44
	sprite_object_entry SpriteFrameTable_28_77CC, SpriteScript_28_7802 ; entry 45
	sprite_object_entry SpriteFrameTable_28_77CC, SpriteScript_28_7802 ; entry 46
	sprite_object_entry SpriteFrameTable_28_77CC, SpriteScript_28_7802 ; entry 47
MailSession_ObjTable_72FB_Entry48:: ; 28:73BB
	sprite_object_entry SpriteFrameTable_28_7807, SpriteScript_28_7812 ; entry 48
	sprite_object_entry SpriteFrameTable_28_7807, SpriteScript_28_7812 ; entry 49
	sprite_object_entry SpriteFrameTable_28_7807, SpriteScript_28_7812 ; entry 50
	sprite_object_entry SpriteFrameTable_28_7807, SpriteScript_28_7812 ; entry 51
MailSession_ObjTable_72FB_Entry52:: ; 28:73CB
	sprite_object_entry SpriteFrameTable_28_7815, SpriteScript_28_7820 ; entry 52
	sprite_object_entry SpriteFrameTable_28_7815, SpriteScript_28_7820 ; entry 53
	sprite_object_entry SpriteFrameTable_28_7815, SpriteScript_28_7820 ; entry 54
	sprite_object_entry SpriteFrameTable_28_7815, SpriteScript_28_7820 ; entry 55
MailSession_ObjTable_72FB_Entry56:: ; 28:73DB
	sprite_object_entry SpriteFrameTable_28_7823, SpriteScript_28_782E ; entry 56
	sprite_object_entry SpriteFrameTable_28_7823, SpriteScript_28_782E ; entry 57
	sprite_object_entry SpriteFrameTable_28_7823, SpriteScript_28_782E ; entry 58
	sprite_object_entry SpriteFrameTable_28_7823, SpriteScript_28_782E ; entry 59
MailSession_ObjTable_72FB_Entry60:: ; 28:73EB
	sprite_object_entry SpriteFrameTable_28_7831, SpriteScript_28_783C ; entry 60
	sprite_object_entry SpriteFrameTable_28_7831, SpriteScript_28_783C ; entry 61
	sprite_object_entry SpriteFrameTable_28_7831, SpriteScript_28_783C ; entry 62
	sprite_object_entry SpriteFrameTable_28_7831, SpriteScript_28_783C ; entry 63
MailSession_ObjTable_72FB_Entry64:: ; 28:73FB
	sprite_object_entry SpriteFrameTable_28_783F, SpriteScript_28_784A ; entry 64
	sprite_object_entry SpriteFrameTable_28_783F, SpriteScript_28_784A ; entry 65
	sprite_object_entry SpriteFrameTable_28_783F, SpriteScript_28_784A ; entry 66
	sprite_object_entry SpriteFrameTable_28_783F, SpriteScript_28_784A ; entry 67
MailSession_ObjTable_72FB_Entry68:: ; 28:740B
	sprite_object_entry SpriteFrameTable_28_784D, SpriteScript_28_7864 ; entry 68
	sprite_object_entry SpriteFrameTable_28_784D, SpriteScript_28_7864 ; entry 69
	sprite_object_entry SpriteFrameTable_28_784D, SpriteScript_28_7864 ; entry 70
	sprite_object_entry SpriteFrameTable_28_784D, SpriteScript_28_7864 ; entry 71
MailSession_ObjTable_72FB_Entry72:: ; 28:741B
	sprite_object_entry SpriteFrameTable_28_7867, SpriteScript_28_787E ; entry 72
	sprite_object_entry SpriteFrameTable_28_7867, SpriteScript_28_787E ; entry 73
	sprite_object_entry SpriteFrameTable_28_7867, SpriteScript_28_787E ; entry 74
	sprite_object_entry SpriteFrameTable_28_7867, SpriteScript_28_787E ; entry 75
MailSession_ObjTable_72FB_Entry76:: ; 28:742B
	sprite_object_entry SpriteFrameTable_28_7881, SpriteScript_28_7898 ; entry 76
	sprite_object_entry SpriteFrameTable_28_7881, SpriteScript_28_7898 ; entry 77
	sprite_object_entry SpriteFrameTable_28_7881, SpriteScript_28_7898 ; entry 78
	sprite_object_entry SpriteFrameTable_28_7881, SpriteScript_28_7898 ; entry 79
MailSession_ObjTable_72FB_Entry80:: ; 28:743B
	sprite_object_entry SpriteFrameTable_28_789B, SpriteScript_28_78B2 ; entry 80
	sprite_object_entry SpriteFrameTable_28_789B, SpriteScript_28_78B2 ; entry 81
	sprite_object_entry SpriteFrameTable_28_789B, SpriteScript_28_78B2 ; entry 82
	sprite_object_entry SpriteFrameTable_28_789B, SpriteScript_28_78B2 ; entry 83
MailSession_ObjTable_72FB_Entry84:: ; 28:744B
	sprite_object_entry SpriteFrameTable_28_78B5, SpriteScript_28_78CC ; entry 84
	sprite_object_entry SpriteFrameTable_28_78B5, SpriteScript_28_78CC ; entry 85
	sprite_object_entry SpriteFrameTable_28_78B5, SpriteScript_28_78CC ; entry 86
	sprite_object_entry SpriteFrameTable_28_78B5, SpriteScript_28_78CC ; entry 87
MailSession_ObjTable_72FB_Entry88:: ; 28:745B
	sprite_object_entry SpriteFrameTable_28_78CF, SpriteScript_28_78E6 ; entry 88
	sprite_object_entry SpriteFrameTable_28_78CF, SpriteScript_28_78E6 ; entry 89
	sprite_object_entry SpriteFrameTable_28_78CF, SpriteScript_28_78E6 ; entry 90
	sprite_object_entry SpriteFrameTable_28_78CF, SpriteScript_28_78E6 ; entry 91
MailSession_ObjTable_72FB_Entry92:: ; 28:746B
	sprite_object_entry SpriteFrameTable_28_78E9, SpriteScript_28_7900 ; entry 92
	sprite_object_entry SpriteFrameTable_28_78E9, SpriteScript_28_7900 ; entry 93
	sprite_object_entry SpriteFrameTable_28_78E9, SpriteScript_28_7900 ; entry 94
	sprite_object_entry SpriteFrameTable_28_78E9, SpriteScript_28_7900 ; entry 95
MailSession_ObjTable_72FB_Entry96:: ; 28:747B
	sprite_object_entry SpriteFrameTable_28_7903, SpriteScript_28_791A ; entry 96
	sprite_object_entry SpriteFrameTable_28_7903, SpriteScript_28_791A ; entry 97
	sprite_object_entry SpriteFrameTable_28_7903, SpriteScript_28_791A ; entry 98
	sprite_object_entry SpriteFrameTable_28_7903, SpriteScript_28_791A ; entry 99
MailSession_ObjTable_72FB_Entry100:: ; 28:748B
	sprite_object_entry SpriteFrameTable_28_791D, SpriteScript_28_7934 ; entry 100
	sprite_object_entry SpriteFrameTable_28_791D, SpriteScript_28_7934 ; entry 101
	sprite_object_entry SpriteFrameTable_28_791D, SpriteScript_28_7934 ; entry 102
	sprite_object_entry SpriteFrameTable_28_791D, SpriteScript_28_7934 ; entry 103
MailSession_ObjTable_72FB_Entry104:: ; 28:749B
	sprite_object_entry SpriteFrameTable_28_7937, SpriteScript_28_794E ; entry 104
	sprite_object_entry SpriteFrameTable_28_7937, SpriteScript_28_794E ; entry 105
	sprite_object_entry SpriteFrameTable_28_7937, SpriteScript_28_794E ; entry 106
	sprite_object_entry SpriteFrameTable_28_7937, SpriteScript_28_794E ; entry 107
MailSession_ObjTable_72FB_Entry108:: ; 28:74AB
	sprite_object_entry SpriteFrameTable_28_7951, SpriteScript_28_7968 ; entry 108
	sprite_object_entry SpriteFrameTable_28_7951, SpriteScript_28_7968 ; entry 109
	sprite_object_entry SpriteFrameTable_28_7951, SpriteScript_28_7968 ; entry 110
	sprite_object_entry SpriteFrameTable_28_7951, SpriteScript_28_7968 ; entry 111
MailSession_ObjTable_72FB_Entry112:: ; 28:74BB
	sprite_object_entry SpriteFrameTable_28_796B, SpriteScript_28_7982 ; entry 112
	sprite_object_entry SpriteFrameTable_28_796B, SpriteScript_28_7982 ; entry 113
	sprite_object_entry SpriteFrameTable_28_796B, SpriteScript_28_7982 ; entry 114
	sprite_object_entry SpriteFrameTable_28_796B, SpriteScript_28_7982 ; entry 115
MailSession_ObjTable_72FB_Entry116:: ; 28:74CB
	sprite_object_entry SpriteFrameTable_28_7985, SpriteScript_28_7994 ; entry 116
	sprite_object_entry SpriteFrameTable_28_7985, SpriteScript_28_7994 ; entry 117
	sprite_object_entry SpriteFrameTable_28_7985, SpriteScript_28_7994 ; entry 118
	sprite_object_entry SpriteFrameTable_28_7985, SpriteScript_28_7994 ; entry 119
MailSession_ObjTable_72FB_Entry120:: ; 28:74DB
	sprite_object_entry SpriteFrameTable_28_7997, SpriteScript_28_79A6 ; entry 120
	sprite_object_entry SpriteFrameTable_28_7997, SpriteScript_28_79A6 ; entry 121
	sprite_object_entry SpriteFrameTable_28_7997, SpriteScript_28_79A6 ; entry 122
	sprite_object_entry SpriteFrameTable_28_7997, SpriteScript_28_79A6 ; entry 123
MailSession_ObjTable_72FB_Entry124:: ; 28:74EB
	sprite_object_entry SpriteFrameTable_28_79A9, SpriteScript_28_79B8 ; entry 124
	sprite_object_entry SpriteFrameTable_28_79A9, SpriteScript_28_79B8 ; entry 125
	sprite_object_entry SpriteFrameTable_28_79A9, SpriteScript_28_79B8 ; entry 126
	sprite_object_entry SpriteFrameTable_28_79A9, SpriteScript_28_79B8 ; entry 127
MailSession_ObjTable_72FB_Entry128:: ; 28:74FB
	sprite_object_entry SpriteFrameTable_28_79BB, SpriteScript_28_79CA ; entry 128
	sprite_object_entry SpriteFrameTable_28_79BB, SpriteScript_28_79CA ; entry 129
	sprite_object_entry SpriteFrameTable_28_79BB, SpriteScript_28_79CA ; entry 130
	sprite_object_entry SpriteFrameTable_28_79BB, SpriteScript_28_79CA ; entry 131
MailSession_ObjTable_72FB_Entry132:: ; 28:750B
	sprite_object_entry SpriteFrameTable_28_79CD, SpriteScript_28_79DC ; entry 132
	sprite_object_entry SpriteFrameTable_28_79CD, SpriteScript_28_79DC ; entry 133
	sprite_object_entry SpriteFrameTable_28_79CD, SpriteScript_28_79DC ; entry 134
	sprite_object_entry SpriteFrameTable_28_79CD, SpriteScript_28_79DC ; entry 135
MailSession_ObjTable_72FB_Entry136:: ; 28:751B
	sprite_object_entry SpriteFrameTable_28_79DF, SpriteScript_28_79EE ; entry 136
	sprite_object_entry SpriteFrameTable_28_79DF, SpriteScript_28_79EE ; entry 137
	sprite_object_entry SpriteFrameTable_28_79DF, SpriteScript_28_79EE ; entry 138
	sprite_object_entry SpriteFrameTable_28_79DF, SpriteScript_28_79EE ; entry 139
MailSession_ObjTable_72FB_Entry140:: ; 28:752B
	sprite_object_entry SpriteFrameTable_28_79F1, SpriteScript_28_7A00 ; entry 140
	sprite_object_entry SpriteFrameTable_28_79F1, SpriteScript_28_7A00 ; entry 141
	sprite_object_entry SpriteFrameTable_28_79F1, SpriteScript_28_7A00 ; entry 142
	sprite_object_entry SpriteFrameTable_28_79F1, SpriteScript_28_7A00 ; entry 143
MailSession_ObjTable_72FB_Entry144:: ; 28:753B
	sprite_object_entry SpriteFrameTable_28_7A03, SpriteScript_28_7A12 ; entry 144
	sprite_object_entry SpriteFrameTable_28_7A03, SpriteScript_28_7A12 ; entry 145
	sprite_object_entry SpriteFrameTable_28_7A03, SpriteScript_28_7A12 ; entry 146
	sprite_object_entry SpriteFrameTable_28_7A03, SpriteScript_28_7A12 ; entry 147
MailSession_ObjTable_72FB_Entry148:: ; 28:754B
	sprite_object_entry SpriteFrameTable_28_7A15, SpriteScript_28_7A24 ; entry 148
	sprite_object_entry SpriteFrameTable_28_7A15, SpriteScript_28_7A24 ; entry 149
	sprite_object_entry SpriteFrameTable_28_7A15, SpriteScript_28_7A24 ; entry 150
	sprite_object_entry SpriteFrameTable_28_7A15, SpriteScript_28_7A24 ; entry 151
MailSession_ObjTable_72FB_Entry152:: ; 28:755B
	sprite_object_entry SpriteFrameTable_28_7A27, SpriteScript_28_7A36 ; entry 152
	sprite_object_entry SpriteFrameTable_28_7A27, SpriteScript_28_7A36 ; entry 153
	sprite_object_entry SpriteFrameTable_28_7A27, SpriteScript_28_7A36 ; entry 154
	sprite_object_entry SpriteFrameTable_28_7A27, SpriteScript_28_7A36 ; entry 155
MailSession_ObjTable_72FB_Entry156:: ; 28:756B
	sprite_object_entry SpriteFrameTable_28_7A39, SpriteScript_28_7A48 ; entry 156
	sprite_object_entry SpriteFrameTable_28_7A39, SpriteScript_28_7A48 ; entry 157
	sprite_object_entry SpriteFrameTable_28_7A39, SpriteScript_28_7A48 ; entry 158
	sprite_object_entry SpriteFrameTable_28_7A39, SpriteScript_28_7A48 ; entry 159
MailSession_ObjTable_72FB_Entry160:: ; 28:757B
	sprite_object_entry SpriteFrameTable_28_7A4B, SpriteScript_28_7A5A ; entry 160
	sprite_object_entry SpriteFrameTable_28_7A4B, SpriteScript_28_7A5A ; entry 161
	sprite_object_entry SpriteFrameTable_28_7A4B, SpriteScript_28_7A5A ; entry 162
	sprite_object_entry SpriteFrameTable_28_7A4B, SpriteScript_28_7A5A ; entry 163

; ---- data $758B-$7A5D (1234 bytes) [PROBABLE] 41 object record(s): 41 frame tables, 53 frames, 41 scripts, tiled exactly (each frame-table word = start of a frame; frames and scripts follow in order); object animation database as consumed by 00:0A82/0AB8 (init_object_from_table): table rows of 4-byte entries (frame-table ptr, script ptr); frame table = words to frames; frame = count then count x (dy,dx,tile,attr) OAM entries; script = count then count x 2-byte pairs; 28:6E80-7A5D [v4: bytes 75E2-7678, 76EE-7823, 783F-784D were CONFIRMED read as data by executed code (pre-classifier mapper class, traces/detail dataaccess); the content class stated here is only PROBABLE]

MailSession_72FB_ObjAnimData:: ; 28:758B
Data_28_758B::
	sprite_frame_table SpriteFrame_28_758D
SpriteFrame_28_758D:: ; 28:758D
	sprite_frame 4
	sprite_oam 42, 64, $10, 0
	sprite_oam 42, 72, $12, 0
	sprite_oam 58, 64, $30, 0
	sprite_oam 58, 72, $22, 0
SpriteScript_28_759E:: ; 28:759E
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_75A1:: ; 28:75A1
	sprite_frame_table SpriteFrame_28_75A3
SpriteFrame_28_75A3:: ; 28:75A3
	sprite_frame 4
	sprite_oam 43, 72, $10, OAMF_XFLIP
	sprite_oam 43, 64, $12, OAMF_XFLIP
	sprite_oam 59, 72, $30, OAMF_XFLIP
	sprite_oam 59, 64, $22, OAMF_XFLIP
SpriteScript_28_75B4:: ; 28:75B4
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_75B7:: ; 28:75B7
	sprite_frame_table SpriteFrame_28_75BB, SpriteFrame_28_75CC
SpriteFrame_28_75BB:: ; 28:75BB
	sprite_frame 4
	sprite_oam 42, 64, $00, 0
	sprite_oam 42, 72, $02, 0
	sprite_oam 58, 64, $20, 0
	sprite_oam 58, 72, $22, 0
SpriteFrame_28_75CC:: ; 28:75CC
	sprite_frame 4
	sprite_oam 42, 64, $04, 0
	sprite_oam 42, 72, $06, 0
	sprite_oam 58, 64, $24, 0
	sprite_oam 58, 72, $26, 0
SpriteScript_28_75DD:: ; 28:75DD
	sprite_anim 2
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
SpriteFrameTable_28_75E2:: ; 28:75E2
	sprite_frame_table SpriteFrame_28_75E6, SpriteFrame_28_75F7
SpriteFrame_28_75E6:: ; 28:75E6
	sprite_frame 4
	sprite_oam 42, 72, $00, OAMF_XFLIP
	sprite_oam 42, 64, $02, OAMF_XFLIP
	sprite_oam 58, 72, $20, OAMF_XFLIP
	sprite_oam 58, 64, $22, OAMF_XFLIP
SpriteFrame_28_75F7:: ; 28:75F7
	sprite_frame 4
	sprite_oam 42, 72, $04, OAMF_XFLIP
	sprite_oam 42, 64, $06, OAMF_XFLIP
	sprite_oam 58, 72, $24, OAMF_XFLIP
	sprite_oam 58, 64, $26, OAMF_XFLIP
SpriteScript_28_7608:: ; 28:7608
	sprite_anim 2
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
SpriteFrameTable_28_760D:: ; 28:760D
	sprite_frame_table SpriteFrame_28_7611, SpriteFrame_28_7622
SpriteFrame_28_7611:: ; 28:7611
	sprite_frame 4
	sprite_oam 43, 64, $08, 0
	sprite_oam 43, 72, $0A, 0
	sprite_oam 59, 64, $28, 0
	sprite_oam 59, 72, $2A, 0
SpriteFrame_28_7622:: ; 28:7622
	sprite_frame 4
	sprite_oam 43, 64, $0C, 0
	sprite_oam 43, 72, $0E, 0
	sprite_oam 59, 64, $2C, 0
	sprite_oam 59, 72, $2E, 0
SpriteScript_28_7633:: ; 28:7633
	sprite_anim 2
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
SpriteFrameTable_28_7638:: ; 28:7638
	sprite_frame_table SpriteFrame_28_763E, SpriteFrame_28_764F, SpriteFrame_28_7660
SpriteFrame_28_763E:: ; 28:763E
	sprite_frame 4
	sprite_oam 43, 64, $10, 0
	sprite_oam 43, 72, $12, 0
	sprite_oam 59, 64, $30, 0
	sprite_oam 59, 72, $22, 0
SpriteFrame_28_764F:: ; 28:764F
	sprite_frame 4
	sprite_oam 43, 64, $40, 0
	sprite_oam 43, 72, $42, 0
	sprite_oam 59, 64, $60, 0
	sprite_oam 59, 72, $62, 0
SpriteFrame_28_7660:: ; 28:7660
	sprite_frame 4
	sprite_oam 43, 64, $34, 0
	sprite_oam 43, 72, $36, 0
	sprite_oam 59, 72, $2A, 0
	sprite_oam 59, 64, $60, 0
SpriteScript_28_7671:: ; 28:7671
	sprite_anim 3
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 24
SpriteFrameTable_28_7678:: ; 28:7678
	sprite_frame_table SpriteFrame_28_767E, SpriteFrame_28_7697, SpriteFrame_28_76B0
SpriteFrame_28_767E:: ; 28:767E
	sprite_frame 6
	sprite_oam 59, 64, $64, 0
	sprite_oam 43, 64, $34, 0
	sprite_oam 43, 72, $36, 0
	sprite_oam 59, 72, $2A, 0
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteFrame_28_7697:: ; 28:7697
	sprite_frame 6
	sprite_oam 59, 62, $64, 0
	sprite_oam 59, 70, $66, 0
	sprite_oam 43, 62, $44, 0
	sprite_oam 43, 70, $46, 0
	sprite_oam 32, 69, $5C, 4
	sprite_oam 32, 77, $5E, 4
SpriteFrame_28_76B0:: ; 28:76B0
	sprite_frame 6
	sprite_oam 43, 61, $48, 0
	sprite_oam 43, 69, $4A, 0
	sprite_oam 59, 61, $68, 0
	sprite_oam 59, 69, $6A, 0
	sprite_oam 32, 61, $5C, 4
	sprite_oam 32, 69, $5E, 4
SpriteScript_28_76C9:: ; 28:76C9
	sprite_anim 3
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 24
SpriteFrameTable_28_76D0:: ; 28:76D0
	sprite_frame_table SpriteFrame_28_76D2
SpriteFrame_28_76D2:: ; 28:76D2
	sprite_frame 6
	sprite_oam 43, 88, $08, OAMF_BANK1 | 1
	sprite_oam 43, 96, $0A, OAMF_BANK1 | 1
	sprite_oam 59, 88, $22, OAMF_XFLIP | 1
	sprite_oam 59, 96, $30, OAMF_XFLIP | 1
	sprite_oam 51, 104, $50, 0
	sprite_oam 51, 112, $52, 0
SpriteScript_28_76EB:: ; 28:76EB
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_76EE:: ; 28:76EE
	sprite_frame_table SpriteFrame_28_76F4, SpriteFrame_28_770D, SpriteFrame_28_7726
SpriteFrame_28_76F4:: ; 28:76F4
	sprite_frame 6
	sprite_oam 43, 88, $08, OAMF_BANK1 | 1
	sprite_oam 43, 96, $0A, OAMF_BANK1 | 1
	sprite_oam 59, 96, $30, OAMF_XFLIP | 1
	sprite_oam 59, 88, $22, OAMF_XFLIP | 1
	sprite_oam 51, 104, $50, 0
	sprite_oam 51, 112, $52, 0
SpriteFrame_28_770D:: ; 28:770D
	sprite_frame 6
	sprite_oam 43, 88, $4C, OAMF_BANK1 | 1
	sprite_oam 43, 96, $4E, OAMF_BANK1 | 1
	sprite_oam 59, 96, $60, OAMF_XFLIP | 1
	sprite_oam 59, 88, $62, OAMF_XFLIP | 1
	sprite_oam 51, 104, $50, 0
	sprite_oam 51, 112, $52, 0
SpriteFrame_28_7726:: ; 28:7726
	sprite_frame 6
	sprite_oam 43, 88, $40, OAMF_BANK1 | 1
	sprite_oam 43, 96, $42, OAMF_BANK1 | 1
	sprite_oam 59, 88, $2A, OAMF_XFLIP | 1
	sprite_oam 59, 96, $20, OAMF_XFLIP | 1
	sprite_oam 51, 104, $50, 0
	sprite_oam 51, 112, $52, 0
SpriteScript_28_773F:: ; 28:773F
	sprite_anim 3
	sprite_anim_step 0, 8
	sprite_anim_step 1, 8
	sprite_anim_step 2, 24
SpriteFrameTable_28_7746:: ; 28:7746
	sprite_frame_table SpriteFrame_28_774A, SpriteFrame_28_776B
SpriteFrame_28_774A:: ; 28:774A
	sprite_frame 8
	sprite_oam 43, 88, $14, OAMF_BANK1 | 1
	sprite_oam 43, 96, $16, OAMF_BANK1 | 1
	sprite_oam 32, 99, $24, OAMF_BANK1 | 5
	sprite_oam 37, 109, $26, OAMF_BANK1 | 5
	sprite_oam 59, 88, $2A, OAMF_XFLIP | 1
	sprite_oam 59, 96, $30, OAMF_XFLIP | 1
	sprite_oam 51, 104, $50, 0
	sprite_oam 51, 112, $52, 0
SpriteFrame_28_776B:: ; 28:776B
	sprite_frame 8
	sprite_oam 33, 98, $24, OAMF_BANK1 | 5
	sprite_oam 36, 108, $26, OAMF_BANK1 | 5
	sprite_oam 43, 88, $28, OAMF_BANK1 | 1
	sprite_oam 43, 96, $2A, OAMF_BANK1 | 1
	sprite_oam 59, 88, $2A, OAMF_XFLIP | 1
	sprite_oam 59, 96, $30, OAMF_XFLIP | 1
	sprite_oam 51, 104, $50, 0
	sprite_oam 51, 112, $52, 0
SpriteScript_28_778C:: ; 28:778C
	sprite_anim 2
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
SpriteFrameTable_28_7791:: ; 28:7791
	sprite_frame_table SpriteFrame_28_7795, SpriteFrame_28_77AE
SpriteFrame_28_7795:: ; 28:7795
	sprite_frame 6
	sprite_oam 42, 96, $68, OAMF_BANK1 | 1
	sprite_oam 42, 104, $6A, OAMF_BANK1 | 1
	sprite_oam 58, 96, $88, OAMF_BANK1 | 1
	sprite_oam 58, 104, $8A, OAMF_BANK1 | 1
	sprite_oam 50, 104, $54, 0
	sprite_oam 50, 112, $56, 0
SpriteFrame_28_77AE:: ; 28:77AE
	sprite_frame 6
	sprite_oam 42, 96, $6C, OAMF_BANK1 | 1
	sprite_oam 42, 104, $6E, OAMF_BANK1 | 1
	sprite_oam 58, 96, $8C, OAMF_BANK1 | 1
	sprite_oam 58, 104, $8E, OAMF_BANK1 | 1
	sprite_oam 50, 104, $7C, 0
	sprite_oam 50, 112, $7E, 0
SpriteScript_28_77C7:: ; 28:77C7
	sprite_anim 2
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
SpriteFrameTable_28_77CC:: ; 28:77CC
	sprite_frame_table SpriteFrame_28_77D0, SpriteFrame_28_77E9
SpriteFrame_28_77D0:: ; 28:77D0
	sprite_frame 6
	sprite_oam 51, 104, $70, 0
	sprite_oam 51, 112, $72, 0
	sprite_oam 43, 88, $64, OAMF_BANK1 | 1
	sprite_oam 43, 96, $66, OAMF_BANK1 | 1
	sprite_oam 59, 96, $20, OAMF_XFLIP | 1
	sprite_oam 59, 88, $22, OAMF_XFLIP | 1
SpriteFrame_28_77E9:: ; 28:77E9
	sprite_frame 6
	sprite_oam 43, 88, $60, OAMF_BANK1 | 1
	sprite_oam 43, 96, $62, OAMF_BANK1 | 1
	sprite_oam 59, 96, $24, OAMF_XFLIP | 1
	sprite_oam 59, 88, $26, OAMF_XFLIP | 1
	sprite_oam 51, 103, $70, 0
	sprite_oam 51, 111, $72, 0
SpriteScript_28_7802:: ; 28:7802
	sprite_anim 2
	sprite_anim_step 0, 10
	sprite_anim_step 1, 10
SpriteFrameTable_28_7807:: ; 28:7807
	sprite_frame_table SpriteFrame_28_7809
SpriteFrame_28_7809:: ; 28:7809
	sprite_frame 2
	sprite_oam 51, 48, $58, 2
	sprite_oam 51, 56, $5A, 2
SpriteScript_28_7812:: ; 28:7812
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_7815:: ; 28:7815
	sprite_frame_table SpriteFrame_28_7817
SpriteFrame_28_7817:: ; 28:7817
	sprite_frame 2
	sprite_oam 50, 56, $58, OAMF_XFLIP | 2
	sprite_oam 50, 48, $5A, OAMF_XFLIP | 2
SpriteScript_28_7820:: ; 28:7820
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_7823:: ; 28:7823
	sprite_frame_table SpriteFrame_28_7825
SpriteFrame_28_7825:: ; 28:7825
	sprite_frame 2
	sprite_oam 11, 48, $78, 2
	sprite_oam 11, 56, $7A, 2
SpriteScript_28_782E:: ; 28:782E
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_7831:: ; 28:7831
	sprite_frame_table SpriteFrame_28_7833
SpriteFrame_28_7833:: ; 28:7833
	sprite_frame 2
	sprite_oam 51, 56, $78, OAMF_XFLIP | 2
	sprite_oam 51, 48, $7A, OAMF_XFLIP | 2
SpriteScript_28_783C:: ; 28:783C
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_783F:: ; 28:783F
	sprite_frame_table SpriteFrame_28_7841
SpriteFrame_28_7841:: ; 28:7841
	sprite_frame 2
	sprite_oam 17, 76, $5C, OAMF_BANK1 | 5
	sprite_oam 17, 84, $5E, OAMF_BANK1 | 5
SpriteScript_28_784A:: ; 28:784A
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_784D:: ; 28:784D
	sprite_frame_table SpriteFrame_28_784F
SpriteFrame_28_784F:: ; 28:784F
	sprite_frame 5
	sprite_oam 18, 72, $30, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_7864:: ; 28:7864
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_7867:: ; 28:7867
	sprite_frame_table SpriteFrame_28_7869
SpriteFrame_28_7869:: ; 28:7869
	sprite_frame 5
	sprite_oam 18, 72, $32, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_787E:: ; 28:787E
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_7881:: ; 28:7881
	sprite_frame_table SpriteFrame_28_7883
SpriteFrame_28_7883:: ; 28:7883
	sprite_frame 5
	sprite_oam 18, 72, $34, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_7898:: ; 28:7898
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_789B:: ; 28:789B
	sprite_frame_table SpriteFrame_28_789D
SpriteFrame_28_789D:: ; 28:789D
	sprite_frame 5
	sprite_oam 18, 72, $36, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_78B2:: ; 28:78B2
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_78B5:: ; 28:78B5
	sprite_frame_table SpriteFrame_28_78B7
SpriteFrame_28_78B7:: ; 28:78B7
	sprite_frame 5
	sprite_oam 18, 72, $38, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_78CC:: ; 28:78CC
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_78CF:: ; 28:78CF
	sprite_frame_table SpriteFrame_28_78D1
SpriteFrame_28_78D1:: ; 28:78D1
	sprite_frame 5
	sprite_oam 18, 72, $3A, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_78E6:: ; 28:78E6
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_78E9:: ; 28:78E9
	sprite_frame_table SpriteFrame_28_78EB
SpriteFrame_28_78EB:: ; 28:78EB
	sprite_frame 5
	sprite_oam 18, 72, $3C, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_7900:: ; 28:7900
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_7903:: ; 28:7903
	sprite_frame_table SpriteFrame_28_7905
SpriteFrame_28_7905:: ; 28:7905
	sprite_frame 5
	sprite_oam 18, 72, $3E, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_791A:: ; 28:791A
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_791D:: ; 28:791D
	sprite_frame_table SpriteFrame_28_791F
SpriteFrame_28_791F:: ; 28:791F
	sprite_frame 5
	sprite_oam 18, 72, $50, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_7934:: ; 28:7934
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_7937:: ; 28:7937
	sprite_frame_table SpriteFrame_28_7939
SpriteFrame_28_7939:: ; 28:7939
	sprite_frame 5
	sprite_oam 18, 72, $52, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_794E:: ; 28:794E
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_7951:: ; 28:7951
	sprite_frame_table SpriteFrame_28_7953
SpriteFrame_28_7953:: ; 28:7953
	sprite_frame 5
	sprite_oam 18, 72, $54, OAMF_BANK1 | 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_7968:: ; 28:7968
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_796B:: ; 28:796B
	sprite_frame_table SpriteFrame_28_796D
SpriteFrame_28_796D:: ; 28:796D
	sprite_frame 5
	sprite_oam 18, 80, $58, OAMF_BANK1 | 5
	sprite_oam 18, 88, $5A, OAMF_BANK1 | 5
	sprite_oam 18, 72, $56, OAMF_BANK1 | 5
	sprite_oam 32, 76, $5C, 4
	sprite_oam 32, 84, $5E, 4
SpriteScript_28_7982:: ; 28:7982
	sprite_anim 1
	sprite_anim_step 0, 4
SpriteFrameTable_28_7985:: ; 28:7985
	sprite_frame_table SpriteFrame_28_7987
SpriteFrame_28_7987:: ; 28:7987
	sprite_frame 3
	sprite_oam 38, 52, $30, OAMF_BANK1 | 5
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
SpriteScript_28_7994:: ; 28:7994
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_7997:: ; 28:7997
	sprite_frame_table SpriteFrame_28_7999
SpriteFrame_28_7999:: ; 28:7999
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $32, OAMF_BANK1 | 5
SpriteScript_28_79A6:: ; 28:79A6
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_79A9:: ; 28:79A9
	sprite_frame_table SpriteFrame_28_79AB
SpriteFrame_28_79AB:: ; 28:79AB
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $34, OAMF_BANK1 | 5
SpriteScript_28_79B8:: ; 28:79B8
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_79BB:: ; 28:79BB
	sprite_frame_table SpriteFrame_28_79BD
SpriteFrame_28_79BD:: ; 28:79BD
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $36, OAMF_BANK1 | 5
SpriteScript_28_79CA:: ; 28:79CA
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_79CD:: ; 28:79CD
	sprite_frame_table SpriteFrame_28_79CF
SpriteFrame_28_79CF:: ; 28:79CF
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $38, OAMF_BANK1 | 5
SpriteScript_28_79DC:: ; 28:79DC
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_79DF:: ; 28:79DF
	sprite_frame_table SpriteFrame_28_79E1
SpriteFrame_28_79E1:: ; 28:79E1
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $3A, OAMF_BANK1 | 5
SpriteScript_28_79EE:: ; 28:79EE
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_79F1:: ; 28:79F1
	sprite_frame_table SpriteFrame_28_79F3
SpriteFrame_28_79F3:: ; 28:79F3
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $3C, OAMF_BANK1 | 5
SpriteScript_28_7A00:: ; 28:7A00
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_7A03:: ; 28:7A03
	sprite_frame_table SpriteFrame_28_7A05
SpriteFrame_28_7A05:: ; 28:7A05
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $3E, OAMF_BANK1 | 5
SpriteScript_28_7A12:: ; 28:7A12
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_7A15:: ; 28:7A15
	sprite_frame_table SpriteFrame_28_7A17
SpriteFrame_28_7A17:: ; 28:7A17
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $50, OAMF_BANK1 | 5
SpriteScript_28_7A24:: ; 28:7A24
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_7A27:: ; 28:7A27
	sprite_frame_table SpriteFrame_28_7A29
SpriteFrame_28_7A29:: ; 28:7A29
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $52, OAMF_BANK1 | 5
SpriteScript_28_7A36:: ; 28:7A36
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_7A39:: ; 28:7A39
	sprite_frame_table SpriteFrame_28_7A3B
SpriteFrame_28_7A3B:: ; 28:7A3B
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $54, OAMF_BANK1 | 5
SpriteScript_28_7A48:: ; 28:7A48
	sprite_anim 1
	sprite_anim_step 0, 8
SpriteFrameTable_28_7A4B:: ; 28:7A4B
	sprite_frame_table SpriteFrame_28_7A4D
SpriteFrame_28_7A4D:: ; 28:7A4D
	sprite_frame 3
	sprite_oam 51, 48, $78, 2
	sprite_oam 51, 56, $7A, 2
	sprite_oam 38, 52, $56, OAMF_BANK1 | 5
SpriteScript_28_7A5A:: ; 28:7A5A
	sprite_anim 1
	sprite_anim_step 0, 8
