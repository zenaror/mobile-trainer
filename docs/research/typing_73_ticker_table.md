# Bank 73 ticker pointer pairs — bounded original table

The original table at 73:4001–4009 contains four little-endian pointers:4009,4016,4065 and4072.

`BrowserStart_ShowDescription` supplies HL=4000 and A=73 at 73:62C6 to `Ticker_Start`48:42D4. `ReadByteFar`00:1620 reads the preceding immutable source-bank byte 73 and advances HL to 4001. The ticker adds four times B, then reads a title pointer and a body pointer from that pair. Its bank-aware reads restore the preceding ROM bank; the stored text bank is also 73. NUL-terminated text scans and rendering use those pointer values. The four pointer words and their original bytes remain unchanged.
