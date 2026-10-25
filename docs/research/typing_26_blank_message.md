# Bank26 blank message: original text and bounded glyph proof

## Exact string and original caller

MailSession_ClearMsg at26:5873..588E is27 bytes /11 instruction starts. It stores2 in hTextTiles_DestBank, loads A=26, BC=D400, DE=D600 and HL=588E, then farcalls48:403E TextTiles_RenderLine. The exact inline bytes are CDD1063E4048. The subsequent call to26:58B7 and all upload code remain unchanged and outside this text-only comment refinement.

ROM0 FarCall at06D1 saves the caller mapping and selects mapped code bank48 through BankSwitch_H/GetBank_H. The renderer keeps source bank26 in hTextTiles_StringBank; ReadByteFar's ROM path at00:1669 temporarily selects26 for each HL++ byte read and restores code bank48. The renderer terminates on the first zero byte, so this string yields20 two-byte codes and reads its NUL, rather than interpreting the blank payload as instruction bytes.

## Selected font record and bank-qualified destination

Font_BlitGlyph8x16 at48:4748 scans the27 descending five-byte records at48:4810..4897, followed by FFFF. Its selected final record at48:4892 is40 81 48 3B 59: key8140, recorded font bank48, pointer593B. The high/low comparison and four shifts select offset0 for code8140. The active mapped bank48 contains the exact16-byte glyph at48:593B..594B, all zero. The192-byte maintained font binary beginning593B matches its original ROM range; this bounded glyph fact does not promote the entire font run or any other record's status.

The glyph copier uses BankSwitch_H for each destination and doubles each of eight source bytes into two adjacent bytes.

Function_26_5106 retains its exact neutral name and current source contract: its field roles and unexecuted20-start branch remain unresolved; no completion/progress name or semantic promotion is introduced.
