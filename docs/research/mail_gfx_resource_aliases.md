# Mail screen resource alias contracts —2026-10-17

The 64-byte interval `2D:5E80–5EC0` is now named `Gfx_MailBody_HDMALoadZeroFill`.

`MailBody_SetupScreen` starts an HDMA from `2D:5AC0`, with `C=$40` (1024 bytes), to VRAM bank 1 at `$9300`; the bytes at `5E80–5EC0` are its final 64 zero-filled bytes.

`MailBody_ReloadTiles` starts a 768-byte transfer at `2D:5CC0` to VRAM bank 1 at `$9500`, which also crosses the same zero-fill before continuing into `Gfx_MailBody_Tiles2`.

`home/gfx_upload.asm:7–28` confirms the helper's 16-byte block unit and destination-bank handling.

The former phrase “neutral KEEP unit” remains correct for **unknown tile semantics**, while the exact source/transfer identity is now named. The tilemap is copied separately at `2D:5FC0`; no evidence in this bounded chain associates the zero-fill with a displayed tile or sprite. No PNG or asset-catalog entry is created for these bytes.

The body5AC0 resource is960B; the setup site requests64 blocks/1024B and therefore also reads64 adjacent inline zero bytes. Other sites request60blocks/960B or32blocks/512B. The second reload slice starts at5CC0 (+200h), uses C=$30 (48 blocks/768B), and ends at5FC0:448B of the main960B backing,64 adjacent neutral zero bytes, then256B of Gfx_MailBody_Tiles2. The independently maintained5E80 neutral inline unit remains neutral. The address7E20 palette backing is64B, while the selected setup copy requests48B only; no full-palette usage claim follows. Other selected HDMA transfers use C in1..80,16-byte blocks, destination Ebit0 for VRAM bank and DE&FFF0 destination. Tilemap helpers consume18x20 map bytes and18x20 attributes. Palette helpers stage bounded BC bytes into WRAM7 buffers; this is not itself a direct hardware palette write.

Banked helpers select ROM by H/A; far calls depend on the initialized HRAM trampoline and preserved mapper state. LCD-on HDMA waits require91<=LY<B; service variants call frame service. Shared scratch, WRAM7, IRQ/waits and caller context remain conditional; retirement supplies no general ABI, IRQ immunity, persistence, natural caller or display guarantee. Grid headers retain their forced-only/non-natural caveat. Body/Address resource confidence and viewer mixed CONFIRMED/PROBABLE headers remain exactly as inherited.

## Finite old-to-current map

| Old alias | Maintained identity | Bank:interval | Bytes | Held status |
|---|---|---|---:|---|
| `Data_2D_5AC0` | `Gfx_MailBody_Tiles` | 2D:5AC0–5E80 | 960 | PROBABLE |
| `Data_2D_5FC0` | `Tilemap_MailBody` | 2D:5FC0–6290 | 720 | CONFIRMED |
| `Data_2D_6290` | `Palette_MailBody_Bg` | 2D:6290–62D0 | 64 | PROBABLE |
| `Data_2D_62D0` | `Gfx_MailBody_ObjTiles` | 2D:62D0–6570 | 672 | PROBABLE |
| `Data_2D_6570` | `Palette_MailBody_Obj` | 2D:6570–65B0 | 64 | CONFIRMED |
| `Data_2D_7120` | `Gfx_MailAddr_Tiles` | 2D:7120–7520 | 1024 | CONFIRMED |
| `Data_2D_7B50` | `Tilemap_MailAddr` | 2D:7B50–7E20 | 720 | CONFIRMED |
| `Data_2D_7E20` | `Palette_MailAddr_Bg` | 2D:7E20–7E60 | 64 | PROBABLE |
| `Data_2B_59C0` | `Gfx_MailGrid_Tiles9000Vb1` | 2B:59C0–5DC0 | 1024 | PROBABLE |
| `Data_2B_5DC0` | `Gfx_MailGrid_Tiles9400Vb1` | 2B:5DC0–5FF0 | 560 | PROBABLE |
| `Data_2B_5FF0` | `Data_MailGrid_TilemapAttr` | 2B:5FF0–62C0 | 720 | PROBABLE |
| `Data_2B_62C0` | `Palette_MailGrid_Bg` | 2B:62C0–6300 | 64 | PROBABLE |
| `Data_2B_6300` | `Gfx_MailGrid_Tiles8000` | 2B:6300–63F0 | 240 | PROBABLE |
| `Palette_2B_63F0` | `Palette_MailGrid_Obj` | 2B:63F0–6430 | 64 | PROBABLE |
| `Tiles_2B_6DD0` | `Gfx_MailView_Tiles9000Vb1` | 2B:6DD0–71D0 | 1024 | CONFIRMED |
| `Tiles_2B_71D0` | `Gfx_MailView_Tiles9400Vb1` | 2B:71D0–73D0 | 512 | PROBABLE |
| `Data_2B_73D0` | `Data_MailView_TilemapAttr` | 2B:73D0–76A0 | 720 | CONFIRMED |
| `Palette_2B_76A0` | `Palette_MailView_Bg` | 2B:76A0–76E0 | 64 | PROBABLE |
| `Tiles_2B_76E0` | `Gfx_MailView_Tiles8000` | 2B:76E0–7860 | 384 | PROBABLE |
| `Palette_2B_7860` | `Palette_MailView_Obj` | 2B:7860–78A0 | 64 | PROBABLE |

Some repeated load patterns occur twice inside one source global scope. The evidence lists both exact ROM matches rather than inventing a unique source-line-to-PC assignment; each matching pattern has the same resource, bank, extent and helper.

No stale copy of REVERSE_ENGINEERING.md is supplied.

Its 528 bytes (`2D:7940–7B50`) are **CONFIRMED** as the tail of an OBJ-tile HDMA load from `2D:7880`, ending at VRAM0 `$82D0`.
