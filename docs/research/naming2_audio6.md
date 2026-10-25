# Structural names for the sound data (audio6): 316 neutral labels of the song and effect streams (ROM unchanged)

## 2. Why these names and why these statuses

* The stream decode is CONFIRMED (every byte of the stream ranges is explained, `docs/research/audio_format.md` sections 3 to 6): the operand of each `$B2` (`sound_jump`) and `$B3` (`sound_call`) is the address of the label, and the macros have the semantics that the driver code demonstrates   (`SoundDrv_ReadNextCommand` `04:459B`, `audio_driver_check.py`).

* PROBABLE stays for: the 86 `AfterJump` rows (their claim is that nothing reaches the address: "absence proves nothing"), the four tracks of song `$19` (it plays in four scenarios but only reads 36 to 94 bytes of each track, never the final jump), `SoundSong19_Track3_Sub1`, `SoundSfx37` and the 11 tables whose loop and after-jump words no code reads.

A `Sub` is a pattern that `sound_call` enters and `sound_ret` leaves, and which the track also plays in line once; a `Loop` is where a track jumps back to at its end.

A name such as `SoundSong14_Track3_Loop` appears at 21 `sound_call` sites (song `$14`, tracks 2 and 3): true (the label is the operand of the track's only `$B2`), but it reads oddly there.

## 3. How the rows were made

`gen_audio_names.py` (a scratch script; the rules above are its whole logic) reads only the source: for each song file the track labels, the header and its `dw` sets (the pointer words may sit after a `Table_` label in bank 05 songs), the `sound_call` / `sound_jump` operands and the labels with an address comment; it numbers the `Sub` labels per track in address order and gives a label with several roles the first of Loop, AfterJump, Sub.

The current source also replaces `Data_05_41D0` with `SoundSong0E_Track3_Continuation`, a 71-byte interior segment whose shared classification span includes the following `sound_end`.
