# Original mail-library argument templates

> Status: **reference (current)**. Five bounded role aliases are confirmed, one physical copy remains neutral. Existing PROBABLE storage classifications are preserved.

## Six decisions

|Original unit|Accepted alias / decision|Natural direct load|Whole storage|
|---|---|---|---|
|54:4FC3-4FCB,8 bytes|CONFIRMED Data_Pop3Retr_ParseBodyArgs|4D4F,33 hits/6 scenarios|PROBABLE preserved|
|54:4FCB-4FD2,7 bytes|CONFIRMED Data_Pop3Retr_DecodeFromHeaderArgs|4D73,33/6|PROBABLE preserved|
|54:4C44-4C47,3 bytes|CONFIRMED Data_MailScan_InputPrefix|5124,262/16|PROBABLE preserved|
|54:4C35-4C3D,8 bytes|KEEP Data_54_4C35; downstream role HYPOTHESIS|4A35,34/7|PROBABLE preserved|
|54:4C3D-4C44,7 bytes|CONFIRMED Data_Pop3Top_DecodeHeaderArgs|4A44,34/7;4BEF,45/14|PROBABLE preserved|
|54:475A-4764,10 bytes|CONFIRMED Data_Smtp_HeaderComposeArgs|4593,15/6|PROBABLE preserved|

All43 original bytes have natural ROM-read evidence, with no unread byte. The exact six intervals are independently sized by fixed CopyBytes BC arguments8/7/3/8/7/10 and original source definitions. Neighboring strings, padding, code and unresolved SMTP4764..4770 remain outside scope. CONFIRMED role names arise from demonstrated consumers; all existing whole-storage PROBABLE headers are conservatively preserved. Their exact fully-read scope is eligible for a separately reviewed storage-status change, but this pass makes none. Equal contents at different physical addresses retain separate aliases and roles.

## All source uses, encoded banks and contracts

There are13 source mentions: six definitions and seven HL operands. The only cross-file operand is4C44, defined in pop3_top.asm but consumed by Mail_ScanAndCheckGameMail in pop3_retr.asm. All original bank54 patterns21c34f,21cb4f,21444c,21354c,213d4c,215a47 reproduce the exact seven load sites listed above. The original source definitions and instructions, ROM bytes, `analysis/coverage_union.tsv` and existing `traces/detail/*/dataaccess.tsv` evidence account for source references, exact unit bytes, per-byte read coverage and copy/dispatch/header-build counts. There are no BANK operands, extra data words, graphics macros or asset rows using these labels.

CopyBytes00:050C copies BC bytes from bank54 HL to fixed WRAM C240, increasing HL/DE and exhausting BC. FarCall to its bank0 home target calls BankSwitch_H with A0, which returns without changing the selected ROM bank; this preserves source bank54 during copying. FarCall restores the caller bank afterward. The seven CopyBytes sites4D55/4D79/512A/4A3B/4A4A/4BF5/459C have the same respective natural counts as their loads. C240 is fixed WRAM and does not depend on the caller's SVBK.

The application selects WRAM5 before Mail_DispatchFar so its D000 work area is correctly scoped; this does not promote any existing wMail_* overlay alias's broader semantic status. Mail_DispatchFar00:0247 saves selector A at W5 D002, explicitly selects ROM0F, calls Mail_Dispatch0F:4247, restores the previous ROM bank54, and returns the stored result A. Mail_Dispatch indexes the original13-word table0F:4169 by selector*2. Relevant entries are1=ScanHeaders426D,2=CheckGameMail4340,4=ParseBody44D5,6=GetDecodedHeader4BC0,8=ComposeNext4E66. Each path has a literal valid selector; this does not claim arbitrary-selector bounds safety.

## RETR eight-byte ParseBody arguments

Original4FC3 is03 02 A0 03 00 B0 00 08. It encodes three input bytes [SRAM bank3,addressA002] followed by five output bytes [bank3,addressB000,capacity0800]. The exact8-byte copy4D55 is followed by A4/DE=C240 dispatch4D66,33/6. Mail_LoadArgs4565 copies the initial six bytes into work input/output locations; ParseBody then consumes the two capacity bytes and duplicates the initial capacity into its output stream. Its success path also writes result status through the supplied output address. Complete8-byte unit, including the capacity tail, is accounted for; no split label or graphics interpretation.

Library ParseBody and LoadArgs each execute33/6, matching this application path. Original source supports output SRAM3:B000 with capacity2048. Neither the copied descriptor nor HDMA is a graphics operation. The library's internal alternative/error paths keep their existing classifications; naming this argument object does not promote every downstream branch.

## RETR and TOP seven-byte decoded-header arguments

Original4FCB and4C3D both contain00 03 02 A0 03 80 C4. GetDecodedHeader reads [header index0][input bank3,addressA002][output bank field3,addressC480]. C480 is fixed WRAM, not an SRAM address: setting the output SRAM bank to3 does not make C480 SRAM. The selector uses Mail_FindHeader, unfolds and decodes encoded words, copies to the supplied output pointer, and returns length HL/result A. Existing side-path classifications remain unchanged.

RETR4FCB is copied4D79 and dispatched A6 at4D8A,33/6; its immutable ROM template has initial header ID00 (From). Data_Pop3Retr_DecodeFromHeaderArgs names that immutable template, not every later use of its mutable C240 copy. After decoding From, the caller writes header ID05 into C240 at54:4DD5/4DD7 and invokes selector6 again for Subject; the remaining copied argument fields are reused. TOP4C3D has two uses. The first is copied4A4A and dispatched4A5B,34/7, also From. The second is copied4BF5, then C240 is overwritten with0B before selector6 dispatch4C0B,45/14. Header keyword table0F:4183 entry11 points to ROM/source0F:4200, literal `X-GAME-CODE:`; the caller compares the decoded bytes to its fixed game-code string. The TOP name therefore describes shared decoded-header arguments and does not falsely say From-only. Physical duplicates are preserved rather than globally merged. Aggregate GetDecodedHeader entry280/16 includes other header calls; per-site counts above establish these exact consumers.

## Three-byte scan/check prefix and dynamic tail

Original4C44 is03 02 A0, representing SRAM3:A002. At512A its three-byte copy executes262/16. The caller then reads the first two bytes of sNetWorkPage into C243/C244 and dispatches selector1 at5146,262/16. ScanHeaders explicitly loads bank/address/count from those five bytes and scans the input data. The copied unit is only the immutable first three bytes; dynamic count is not part of its ROM boundary.

On scan success, selector2 at515F runs260/16 using the same first three bytes. CheckGameMail reads that bank/address prefix to find the game-code header. Both consumers establish the role shared by this one physical prefix. Names do not claim a full five-byte argument object or combine the prefix with the neighboring unrelated bytes4C47 onward.

## TOP eight-byte temporary copy: KEEP and contradiction

Original4C35 equals4FC3's eight bytes, but the actual use differs. It is copied4A3B,34/7, to C240; immediately4C3D's seven bytes are copied4A4A to the same C240. There is no selector4 call between those copies. The first seven bytes from4C35 are overwritten before the selector6 consumer; only its eighth byte08 remains atC247, outside selector6's seven-byte argument. Copying all eight proves data reads, not a ParseBody argument role in this path.

KEEP is preferable to inferring a shared global ParseBody-template name merely from equal bytes, historical comments or the containing TOP routine. The current header states the temporary/overwritten fact, and the worklist stops calling this a known graphical asset. No explanation for retaining that copy is invented.

## SMTP ten-byte compose seed and all content units

Original475A is03 00 A1 00 0F 00 00 80 C4 00. The first five bytes describe SRAM3:A100 output with capacity0F00,3840 bytes. The next four are one mutable compose-item record [length00,bank00,pointerC480], followed by a00 item-list terminator. No omitted tail, padding merger or zero promotion.

Smtp_StartMailFrom copies all10 bytes459C,15/6, and calls Mail_BuildHeaderField45A9 with C1/B6. That helper46E8 selects W5 and invokes selector8 through Mail_DispatchFar. ComposeInit4EED loads the first five output bytes and saves a pointer to the remainder. FetchComposeItem4F3D consumes four-byte items until length0. Initial length0 produces the fixed B6 header without a variable item; later Smtp_MeasureField writes measured length into C245 for address/subject fields using the existing C480 pointer. Other fixed headers set the length back to0. The final list byte atC249 terminates after the one item. Smtp uses B0/3/5/7/8/0A for later fields and mutates output pointer/free-capacity bytes after each emitted field.

HeaderBuild, ComposeNext, ComposeInit and FetchComposeItem each run105/6 across these field invocations. Existing source directly reads/writes C241:C242 and C243:C244, and the composer consumes the item-length/pointer tail; the role is a reusable header-compose argument seed, not SMTP network command bytes or tile data. C480 is fixed WRAM input, despite the supplied SRAM-bank field00. Existing RAM alias meanings/confidence remain unchanged; no new alias is created for C240.
