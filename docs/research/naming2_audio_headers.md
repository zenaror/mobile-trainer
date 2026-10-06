# Readable audio header pointer rows (ROM unchanged)

> Status: **reference (current)**. Formatting only: 42 overlong `dw` rows in 22 music files. No names, labels, pointer order, values or evidence levels change.

## Result

The current census has 48 `dw` lines over 160 columns in the maintained source. Forty-two belong to music header pointer groups: 40 rows of four operands and two rows of three operands (`music_0a` and `music_1c` AfterJump rows). Each becomes two `dw` lines of at most two operands. The existing whole-group comment moves immediately above those lines, retaining its exact wording. Replacement lines fit 100 columns (tabs count four); no overlong audio `dw` remains. Six non-audio rows are outside this pass.

The private executor checked the ordered vector, comment and canonical statement stream for every row/file. A fresh independent skeptic rederived all 42 rows and the entire changed-file set, forced reassembly of all 22 sources, and compared the complete symbol maps. Original and rebuilt ROM SHA-256 is `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`; make reports SHA-256 OK and RESULT: IDENTICAL, sym-check passes.

## Record integrity

The reviewer independently read all 46 naming2 artifacts (4,970 nonempty, noncomment lines across six file/line schemas). No record refers to a modified music file by source line. Three layout artifacts mention the files by section/address only, and remain unchanged. No line-record remap is needed. Labels and bytes keep their original addresses despite the new physical source lines.

No new semantic or natural-execution claim is made. Historical generated region comments calling some audio content unknown/false code are unchanged; their interpretation is already corrected by `audio_format.md` and the audio6 notes. Moving the existing pointer-group comments does not promote those descriptions. No PPU or hardware validation.

Main integration passes make/compare (original SHA-256 OK, RESULT: IDENTICAL), sym-check, PNG/palette/graphics, invariants and the full suite: 37 entries, 36 rc=0; only the inherited obsolete ramop7 record-format exception remains (rc=2). The coordinator checked all 22 integrated files against the reviewed private result byte for byte.
