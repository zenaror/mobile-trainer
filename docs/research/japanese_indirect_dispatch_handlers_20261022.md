# Japanese indirect-dispatch handlers (2026-10-22)

This pass names 23 previously unlabeled instruction destinations in six indirect
dispatch tables in the Japanese source. The tables contain 24 words because the
registration-progress table points to its stored-progress reader twice. Every
table word and every destination was checked against the original ROM and the
current linker's symbol addresses. These are **internal handlers reached by
`JP HL`**, not newly established independent functions or proof of natural
execution.

## Table and handler map

| Owner / table | Original address | Symbolic entries in ROM order | Evidence |
|---|---:|---|---|
| `Kbd_MoveCursor_DirTable` | `55:5FC8` | `.left` `5FD0`, `.right` `5FF4`, `.up` `5FFD`, `.down` `6020` | `Kbd_MoveCursor` supplies the direction index; each handler tests the matching neighbor flags and preserves/updates the cursor accordingly. |
| `Kbd_UpdateSticky_StoreDirTable` | `55:6087` | `.left` `608F`, `.right` `60A0`, `.up` `60B1`, `.down` `60C2` | Each handler applies the two direction-specific neighbor bits and calls the matching sticky column/row store helpers. |
| `Kbd_UpdateSticky_ClearDirTable` | `55:60F1` | `.left` `60F9`, `.right` `610A`, `.up` `611B`, `.down` `612C` | Each handler applies the corresponding direction bits and calls the matching sticky column/row clear helpers. |
| `Registration_DeleteExecute_StateTable` | `68:7C6B` | `.start` `7C71`, `.pollFirstCommand` `7C86`, `.pollSecondCommand` `7CBD` | The three entries initialize the operation and process its first and second command-completion states; the names do not infer Mobile API contracts. |
| `Charset_Iso2022JpStates` | `7E:7D8F` | `.copySingleByte` `7D99`, `.convertDoubleByte` `7DB0`, `.afterEscape` `7DE5`, `.afterEscapeParen` `7E05`, `.afterEscapeDollar` `7E1E` | The dispatcher indexes the table and executes `JP HL`; state bytes and the ESC, `(`, and `$` branches select byte-copy, pair-conversion and escape-state handlers. |
| `Settings_ProgressJumpTable` | `68:48D6` | `Settings_GetRegistrationProgress.readStoredProgress` `4880` (twice), `.returnOne` `48D1`, `.returnZero` `48D4` | `Settings_GetRegistrationProgress` indexes the table after verification/repair; the handlers read/decode saved progress or return the table-selected constant. |

The first five tables use local labels in their own global scope. The progress
handlers occur under `Settings_GetRegistrationProgress`, while the table is a
later global symbol, so its entries use fully qualified local references. This
preserves existing local-label ownership and does not export 23 new global
symbols.

## Original table bytes

The following slices were read directly from `Mobile Trainer (Japan).gbc` using
the banked ROM offset `bank * $4000 + (address - $4000)`:

| Bank:address | Bytes | SHA-256 |
|---|---|---|
| `55:5FC8` | `D0 5F F4 5F FD 5F 20 60` | `7f6b3967c56f31af3a9d5d22dc9aadd10d3c84f94526d6ebf28f07d1e9ae45d9` |
| `55:6087` | `8F 60 A0 60 B1 60 C2 60` | `03f44fb7e7d86afd56f5fa36022acd759aef8df4a088da57e4ba2029c3b33b3e` |
| `55:60F1` | `F9 60 0A 61 1B 61 2C 61` | `9e218022446ef472e0fd7271897d599ae97b649b33e37a3d5075ab4e4a7ee908` |
| `68:7C6B` | `71 7C 86 7C BD 7C` | `0c08a48d2a162e8479edf05accc9c2cefdd8bb62d5af4e5e471287a2f6c65d64` |
| `7E:7D8F` | `99 7D B0 7D E5 7D 05 7E 1E 7E` | `52f3331ca3b3352c35fa36b06a2b5e7cbf6a1ca2ca731641c55402550cd8d2c5` |
| `68:48D6` | `80 48 80 48 D1 48 D4 48` | `490629b9216e373d8818735cf594878c994040867045260aaf0f785f521dadd6` |

## Validation and limits

The source replaces the six numeric `dw` lists with the labels above and adds
the corresponding local labels at the exact existing instruction boundaries.
No opcode, table byte, data extent or execution behavior was intentionally
changed. Validation on this source revision:

- `make`: 2,097,152-byte output, SHA-256
  `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`,
  `RESULT: IDENTICAL` to the original ROM.
- `make sym-check`: 335 source files, 12,200 labels, 51 constants; OK.
- `make palette-check`: 162 loads, 116 arrays, two documented overreads, zero
  errors.
- `git diff --check`: clean.

The static table words and instruction starts are **CONFIRMED**. Natural runtime
selection of every entry, independent function entry, higher-level intent, and
hardware behavior were not established by this pass. Other unresolved generic
names and unclassified spans remain open; this does not close the Japanese ROM
semantic audit.
