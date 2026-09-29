# ROM identification

| field | value |
|---|---|
| file | `baserom.gbc` |
| size | 2097152 bytes (0x200000), 128 banks of 16 KiB |
| SHA-256 | `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570` |
| SHA-1 | `ecc0579edeaf9eccd722d605cc288cd023c8576a` |
| MD5 | `aef9b41fbc898a58fd2aaaeabc2787e9` |
| entry point (0x100) | `00 c3 78 02` |
| Nintendo logo | valid |
| title bytes (0x134-0x143) | `4d 2d 54 52 41 49 4e 45 52 00 00 42 39 41 4a c0` |
| title (ASCII) | `M-TRAINER` |
| manufacturer code (0x13F-0x142) | `B9AJ` |
| CGB flag (0x143) | 0xC0 (CGB only) |
| new licensee (0x144-145) | `01` |
| SGB flag (0x146) | 0x00 |
| cartridge type (0x147) | 0x1B MBC5+RAM+BATTERY |
| ROM size code (0x148) | 0x06 -> 2048 KiB, 128 banks |
| RAM size code (0x149) | 0x03 -> 32 KiB (4 banks) |
| destination (0x14A) | 0x00 (Japan) |
| old licensee (0x14B) | 0x33 |
| mask ROM version (0x14C) | 0x00 |
| header checksum (0x14D) | stored 0xDA / computed 0xDA (OK) |
| global checksum (0x14E-F) | stored 0x5AC8 / computed 0x5AC8 (OK) |
