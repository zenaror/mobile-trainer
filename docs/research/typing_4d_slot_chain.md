# Bank4D slot cursor frame/script chain

The existing 27-byte chain at 4D:7968..7983 is CONFIRMED as one four-byte frame-pointer table, two nine-byte OAM frames and one five-byte animation script.

SettingsPhone_SlotMenu_Setup loads HL=wSpriteSlot0 ($DA00) at 67:4E06, DE=$7960 at 4E09, A=$4D at 4E0C and B=$81 at 4E0E, then farcalls Sprite_InitSlot 00:0A82 at 67:4E10.

Sprite_InitSlot selects ROM 4D and WRAM 7, stores the source bank in slot + $0E, and delegates the four-byte entry read to Sprite_LoadObjectEntry 00:0AB8. Its low-byte doubling selects entry 1 for B=$81; this particular bounded input supplies no general object-ID safety guarantee. Entry 1 contains little-endian pointers 7968/797E. Sprite_UpdateAll 00:0956 reselects the stored source bank before Sprite_StepAndDrawSlot 00:0AE8 reads script/frame data.

The frame table contains 796C/7975. Each frame starts with count 2 and contains two dy/dx/tile/attribute tuples: frame 0 uses Y offsets 0, frame 1 uses -1; X offsets 0/8, tile indices 0/1 and OAMF_BANK1. The script starts with count 2 and contains frame/delay pairs 0/30 and 1/5. The reader's count and stride match the existing macros exactly. No name for the displayed glyphs, appearance or broader residency is inferred.
