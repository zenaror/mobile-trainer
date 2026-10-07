# Bank26 blank message: original text and bounded glyph proof

This original-JP unit is based on published a368dabbc7ffb4abdae493764d9a2a4ce2d3b437, after original bank25 was published in3707dd6 and the separate documentation follow-up. Only two existing comments at engine/mail/mail_session_screen.asm:1117/1118 change. Physical bytes, both aliases, source line count and raw db representation remain exact. This refines the existing CONFIRMED data block to a CONFIRMED bounded text interpretation; it is not a new byte or symbol representation.

## Exact string and original caller

ROM26:$588E..$58B7 is41 bytes: twenty repetitions of81 40 (Shift-JIS full-width space, U+3000), followed by NUL at$58B6. The original SHA-256 of this bounded unit is81b4a89099a3e90b502b4b1560f4af45c6d655bf1c01bec8572a32005b437176. MailSession_Msg_Blank and Data_26_588E retain their existing addresses and names. All three literal db lines are preserved.

MailSession_ClearMsg at26:5873..588E is27 bytes /11 instruction starts. It stores2 in hTextTiles_DestBank, loads A=26, BC=D400, DE=D600 and HL=588E, then farcalls48:403E TextTiles_RenderLine. The exact inline bytes are CDD1063E4048. The subsequent call to26:58B7 and all upload code remain unchanged and outside this text-only comment refinement.

ROM0 FarCall at06D1 saves the caller mapping and selects mapped code bank48 through BankSwitch_H/GetBank_H. The renderer keeps source bank26 in hTextTiles_StringBank; ReadByteFar's ROM path at00:1669 temporarily selects26 for each HL++ byte read and restores code bank48. The renderer terminates on the first zero byte, so this string yields20 two-byte codes and reads its NUL, rather than interpreting the blank payload as instruction bytes.

## Selected font record and bank-qualified destination

Font_BlitGlyph8x16 at48:4748 scans the27 descending five-byte records at48:4810..4897, followed by FFFF. Its selected final record at48:4892 is40 81 48 3B 59: key8140, recorded font bank48, pointer593B. The high/low comparison and four shifts select offset0 for code8140. The active mapped bank48 contains the exact16-byte glyph at48:593B..594B, all zero. The192-byte maintained font binary beginning593B matches its original ROM range; this bounded glyph fact does not promote the entire font run or any other record's status.

The glyph copier uses BankSwitch_H for each destination and doubles each of eight source bytes into two adjacent bytes. With both destination-bank arguments2, its first half writes16 zero bytes at WRAM2:D400 and its second half writes16 at WRAM2:D600. The renderer advances each pointer by16 per glyph. Supplementary static arithmetic for all20 glyphs therefore covers320 zero bytes in D400..D540 and320 in D600..D740. This is a static blit/dataflow fact, not a new emulator execution, observation of displayed pixels, PPU timing or hardware behavior. No arbitrary text, glyph selector or destination safety guarantee is inferred.

## Natural evidence and limits

The existing69 original coverage/dataaccess pairs show all41 string bytes read in the same15 scenarios, with no additional partial-only scenario. All11 caller starts share that same whole-scenario set, with60 observed entries in total:

fuzz_browser, fuzz_mailfull, mail_errors, mail_receive, mail_receive_many, mail_receive_var, mail_send, mail_timeout, monkey_camp_allfull, monkey_camp_full, monkey_camp_reg, monkey_camp_reg2, monkey_camp_rich, time_warnings, tutorial_profile.

All16 selected glyph bytes are read in55 aggregate scenarios; this broader font usage is not causally tied to a particular blank-message invocation. Coexistence of code, string and glyph within a scenario is not timestamp-linked call evidence or observation of entry register values. The original caller's register/bank arguments and copy contract are established separately from the ROM/source.

No new natural scenario, forced trace, runtime/synthetic confidence promotion, English layout, visual or physical hardware result is claimed. Neighboring messages, upload logic and other bank26 data keep their existing statuses. Function_26_5106 retains its exact neutral name and current source contract: its field roles and unexecuted20-start branch remain unresolved; no completion/progress name or semantic promotion is introduced. This unit does not establish whole-bank semantic closure. Frozen generator configuration, charmap, font assets and metadata remain unchanged; no regeneration or graphics export occurs.
