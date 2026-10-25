# Redundant labels in `music_16.asm`

At the `3019597c0a58fe2160f819a06b6fc4ef7bd63c3b` Japanese-source snapshot,
the bounded census found 16 generic `Data_05_*` labels in
`audio/music/music_16.asm`. Each was adjacent to an existing `SoundSong16_*`
label at the same bank and address. The generic labels had no other occurrence
in the 347 maintained ASM/INC files included by the census, no tool references,
and no following local-label scope. Only those declarations were retired;
song data, comments, macros, and the 566 physical source lines remain intact.

| Address | Retired label | Retained label |
|---|---|---|
| `05:5174` | `Data_05_5174` | `SoundSong16_Track0` |
| `05:5178` | `Data_05_5178` | `SoundSong16_Track0_Loop` |
| `05:51D9` | `Data_05_51D9` | `SoundSong16_Track0_AfterJump` |
| `05:51DA` | `Data_05_51DA` | `SoundSong16_Track1` |
| `05:51DE` | `Data_05_51DE` | `SoundSong16_Track1_Loop` |
| `05:52D7` | `Data_05_52D7` | `SoundSong16_Track1_AfterJump` |
| `05:52D9` | `Data_05_52D9` | `SoundSong16_Track2` |
| `05:52DD` | `Data_05_52DD` | `SoundSong16_Track2_Loop` |
| `05:53D1` | `Data_05_53D1` | `SoundSong16_Track2_AfterJump` |
| `05:53D2` | `Data_05_53D2` | `SoundSong16_Track3` |
| `05:53D6` | `Data_05_53D6` | `SoundSong16_Track3_Loop` |
| `05:5404` | `Data_05_5404` | `SoundSong16_Track3_Sub1` |
| `05:5434` | `Data_05_5434` | `SoundSong16_Track3_Sub2` |
| `05:5461` | `Data_05_5461` | `SoundSong16_Track3_Sub3` |
| `05:54C8` | `Data_05_54C8` | `SoundSong16_Track3_AfterJump` |
| `05:54C9` | `Data_05_54C9` | `SoundSong16_Header` |

The pinned source-set hash was
`6d29aba65fc6d68696f36ea1e9b9bf8588eb002ba052f162965da8ec757375fa`; the
pre-edit owner hash was
`7edcd3dcb092511402547956eb005a3523e9fdb701dc5d2caabe388499e3b4b8`. The
independent review accepted the exact edit and confirmed the source references,
line count, mapping, and prior symbol addresses. Its receipt is retained at
`REVIEW_MUSIC16.md` (review artifact).

After the edit, `make` reported `RESULT: IDENTICAL` against the original ROM
SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`.
`make sym-check` reported 12,936 labels and 51 constants with all addresses
valid; `make palette-check` reported 162 loads, 116 arrays, two documented
over-reads and zero errors; `make png-check` checked 408 tile sheets, four raw
byte views, 37 font sheets and 95 screen PNGs successfully. This cleanup adds
no new musical or runtime interpretation.
