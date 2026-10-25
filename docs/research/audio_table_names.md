# Nine audio-table aliases: retained identities and limits

The song table's source header remains PROBABLE, while audio_format.md records prior CONFIRMED evidence for its eight-byte record layout.

## Four lookup and dispatch tables

Table_SoundDrv_SfxTrackPtrs (04:449B) contains four words: D040, D07C, D0B8, D0F4.

They select the first four $3C-byte track records, the SFX group.

## Five resource tables

Table_SoundDrv_Instruments (04:51DD) has 112 six-byte records. GetInstrumentPtr computes
51DD+6*index; normal instrument selection and per-note mode use this layout. Existing
data uses pitches 24h..2Fh for the per-note end records; arbitrary pitch/index values
are not proved safe. The existing note's distinctions between natural evidence,
synthetic demonstrations and PROBABLE field cases remain in force.
Table_SoundDrv_WavePatterns (04:547D) has 10 packed 16-byte patterns. The wave path
computes 547D+16*pattern and copies 16 bytes to FF30..FF3F. This role does not establish
safe arbitrary instrument classes, APU access timing, IRQ ownership or hardware behavior.

Table_SoundDrv_Songs (04:551D) has 70 eight-byte records, for ordinary ids 1..46h and 59
distinct stream headers. Eleven additional records reuse song1. The loader computes
5515+8*BC and reads header address/bank, priority, flags and track count. Its own guard
checks B=0 and C<47h but not C!=0; PlaySfx/PlayMusic handle BC=0 before calling it. Do not
generalize ordinary-ID behavior to direct injected BC=0, rejected entries or arbitrary
record values. Extra stream-header pointer sets and after-jump tails retain their
existing unused/static qualifications (audio_format.md section3.2).

## Old/current position map

| Old alias | Retained identity | Bank:address |
|---|---|---|
| `Data_04_449B` | `Table_SoundDrv_SfxTrackPtrs` | 04:449B |
| `Table_04_44A3` | `Table_SoundDrv_ParamHandlers` | 04:44A3 |
| `Table_04_46E8` | `Table_SoundDrv_Commands` | 04:46E8 |
| `Table_04_4726` | `Table_SoundDrv_ExtCommands` | 04:4726 |
| `Data_04_5044` | `Table_SoundDrv_Durations` | 04:5044 |
| `Data_04_5075` | `Table_SoundDrv_NoteFreq` | 04:5075 |
| `Data_04_51DD` | `Table_SoundDrv_Instruments` | 04:51DD |
| `Data_04_547D` | `Table_SoundDrv_WavePatterns` | 04:547D |
| `Data_04_551D` | `Table_SoundDrv_Songs` | 04:551D |
