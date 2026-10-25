# Redundant labels in `music_19.asm`

At the `67990eb249100de35fa6894de6f6542182a767e8` Japanese-source snapshot,
the bounded census found 14 generic `Data_05_*` labels in
`audio/music/music_19.asm`. Each was adjacent to an existing `SoundSong19_*`
label at the same bank and address. The aliases had no other occurrence in
the 347 maintained ASM/INC files included by the census, no tool references,
and no dependent local labels. Only those declarations were retired; the
455-line owner and decoded stream declarations remain unchanged.

| Address | Retired label | Retained label |
|---|---|---|
| `05:5B06` | `Data_05_5B06` | `SoundSong19_Track0` |
| `05:5B0A` | `Data_05_5B0A` | `SoundSong19_Track0_Loop` |
| `05:5B6C` | `Data_05_5B6C` | `SoundSong19_Track0_AfterJump` |
| `05:5B6D` | `Data_05_5B6D` | `SoundSong19_Track1` |
| `05:5B71` | `Data_05_5B71` | `SoundSong19_Track1_Loop` |
| `05:5C4B` | `Data_05_5C4B` | `SoundSong19_Track1_AfterJump` |
| `05:5C4C` | `Data_05_5C4C` | `SoundSong19_Track2` |
| `05:5C50` | `Data_05_5C50` | `SoundSong19_Track2_Loop` |
| `05:5D13` | `Data_05_5D13` | `SoundSong19_Track2_AfterJump` |
| `05:5D14` | `Data_05_5D14` | `SoundSong19_Track3` |
| `05:5D18` | `Data_05_5D18` | `SoundSong19_Track3_Loop` |
| `05:5D4E` | `Data_05_5D4E` | `SoundSong19_Track3_Sub1` |
| `05:5DB4` | `Data_05_5DB4` | `SoundSong19_Track3_AfterJump` |
| `05:5DB5` | `Data_05_5DB5` | `SoundSong19_Header` |

The pinned source-set hash was
`10d17be69d6ed15b7d9fda2b4969adf4633d311807550030f15eb580a3de02b9`; the
owner hash matched the reviewed pre-edit snapshot
`55f6f552f2c2c121f31d184b23589ebb977365172d377378b6bb8e830d32588f`. The
independent review accepted all 14 retirements and checked the full owner,
including local-label spellings without `::`. Its receipt is retained at
`REVIEW_MUSIC19.md` (review artifact).

No musical or runtime interpretation was added by this name cleanup.
