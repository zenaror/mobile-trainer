# Keyboard default-cursor flags and unobserved siblings

> Status: **reference (current)**. Four confirmed roles and two explicit KEEP decisions, independently reconstructed and reviewed before application. Original aliases, bytes and storage limits remain.

## Six decisions

| Original | Decision / alias | Role evidence | Whole storage |
|---|---|---|---|
|55:6EAA Function_55_6EAA|CONFIRMED Kbd_TypeMode2DefaultCursorFlag|Lookup consumed at55:5CBF under [$C2AF]==2, enabling restoration of [$400A+type] to cursor|Code already CONFIRMED|
|55:6EC0 Function_55_6EC0|CONFIRMED Kbd_TypeArgCDefaultCursorFlag|Lookup consumed at55:5CE3; nonzero result followed by saved Kbd_Run argument C test enables the same restoration|Code already CONFIRMED|
|55:6EEC Function_55_6EEC|KEEP neutral; semantic role HYPOTHESIS|Only caller55:5DF8 lies in unentered HYPOTHESIS55:5DF5|Lookup decoder remains PROBABLE|
|55:6EB5 Data_55_6EB5|CONFIRMED Table_Kbd_Mode2DefaultCursorFlag_ByType|Sole indexed consumer6EAA, natural positive and negative branches|PROBABLE:7/11 bytes read|
|55:6ECB Data_55_6ECB|CONFIRMED Table_Kbd_ArgCDefaultCursorFlag_ByType|Sole indexed consumer6EC0, natural argument-C restoration|PROBABLE:10/11 bytes read|
|55:6EF7 Data_55_6EF7|KEEP neutral; semantic role HYPOTHESIS|No natural consumer; separate physical table, despite bytes equaling6EB5|PROBABLE:0/11 bytes read|

The two flag names describe the tested conditions and effect in Kbd_Run. Mode2 means the literal comparison of fixed WRAM[$C2AF] with2; it does not promote the broader meaning or PROBABLE declaration of wKbdMode. Argument C is stored at fixed WRAM[$C2B4] by Kbd_Run entry55:5C8F/5C90, matching the existing CONFIRMED wKbdRunArgC alias. Cursor[$C2B5] and type[$C2AB] are fixed WRAM; no switchable-bank alias inference is involved. No new name says enabled, pressed, accepted, visual keyboard layout, or general mode meaning.

## Encoded contracts and all direct uses

Each routine is exactly11 original bytes, eight instructions: ld hl,table; add a,l; ld l,a; ld a,0; adc a,h; ld h,a; ld a,[hl]; ret. The three original strings are21b56e856f3e008c677ec9,21cb6e856f3e008c677ec9,21f76e856f3e008c677ec9. Input A is an unsigned byte index; A returns the byte at table+A. HL and flags are clobbered, BC/DE unchanged. There is no input bounds test. Only indices0..10 have the documented Boolean table contract; callers select keyboard type0..10, but the routines are not safe bounds-checked APIs for arbitrary A.

All source uses are six definitions, three call operands, three table-base loads. Bank55 original-byte scans find exactly one encoded occurrence of each call and each HL load: calls55:5CBF/5CE3/5DF8, base loads55:6EAA/6EC0/6EEC. There are no extra named instructions, BANK operands, data words or macros for these six labels. audit.json lists every source mention and encoded address. The functions and callers remain in selected bank55; Kbd_Open/Run are entered through the existing farcall bank mechanism. Local predicate lookup has no bank change between HL construction and read. The six physical definitions are distinct and retained as aliases only for the four accepted roles.

The first function's complete eight-instruction walk is1268 hits in25 natural scenarios at every instruction. The second is14425/35 at every instruction. The third has zero at all eight instructions. Its caller55:5DF5 merely decodes to ld a,[type]; call6EEC; or a; jp z,5E5A; jp5F29. No entry is demonstrated and its destination5F29 remains HYPOTHESIS. Sibling periodicity supports its existing PROBABLE decoder classification, not a confirmed semantic role. The historical naming2_fn4 statement that6EF7 selects types5..10 is contradicted by original bytes: it is types6..10. Record the correction here without rewriting the historical note.

## Complete default-cursor paths, pages and bounds

Kbd_Open55:5BA2 stores A as type, B as mode, resets page to0, and initializes cursor from55:4000+type (Table_Kbd_StartCell). It may show immediately for mode2. Kbd_Run stores C, initializes its B-derived argument, and checks type==$0A at55:5CAA/5CAC before either predicate. Fifty of14476 executions take the type-picker route; the remaining14426 reach mode testing. The type-picker path does not use these tables or $400A for type10.

Mode2 dispatch55:5CB4 reaches6EAA1268 times. A nonzero result reaches the default-cell load55:5CC8 and cursor write55:5CD2, then FetchCell55:5CD5 and UpdateCursorSprite55:5CD8:44 hits/9 natural scenarios. A zero result rejoins55:5CE0. Other modes either slide in (mode0) or proceed directly to the next test. The6EC0 flag is tested first; only its nonzero result reads the saved C argument55:5CE9 (11984/22). Nonzero C reaches the type load55:5CEF and default-cell path, cursor write55:5CFC, FetchCell55:5CFF and following sprite update:591/17. The names do not say that the mode2 and C tests are interchangeable.

Both paths use original ROM bank55:$400A+type, the existing Table_Kbd_OkCell, and do not reset wKbdPage. It is ten bytes for types0..9, values34,46,46,58,58,58,58,58,58,58. Kbd_FetchCell55:5F35 dereferences the two-level55:4014 type/page pointer tables and reads the cell word at page+2*cursor. Types6/7/8 have four pages; other ordinary types have one. Original page decoding proves FF82 at the default cell for all19 type/page combinations (7 single-page types plus12 multipage combinations). Exact page/key addresses are in audit.json. Existing key82 path returns7; the names intentionally describe the cursor restoration contract directly. Raw $400A operands remain unchanged in this bounded pass. The table's type10 byte has no valid default-cell partner and is never needed by the shipped early-exit path.

The19 source Kbd_Open sites and13 Kbd_Run sites are all naturally executed; the audit lists the complete static setup context, address and aggregate execution count of each. Ordinary opens set types0 login,1 account mail,2 phone keypad,3 phone comment,4 account password,5 connect dialog,6 mail body,7 profile,8 name/title,9 address; three body-editor opens select10 for the picker. Initial shown opens use B2; connect/mail-body opens use B0; reopens in name/address/title/profile wrappers preserve caller B through their saved state. These forwarded values are not assigned invented defaults. Run C is zero in body/name/title/address loops, wMailScreenMode in profile, the existing field flags in account/phone loops, and C returned by ConnectDialog_ValidatePassword in the connect dialog. That validator starts B=C=0, conditionally sets B1 and C1 based on the fixed validation flow; no external input values are copied. This pass neither broadens those field flags' meanings nor promotes their status.

## Exact storage and unread bytes

Original6EB5..6EC0 is0000000000000101010101. Read indices0/1/2/3/4/8/9 have8/8/3/3/21/6/6 natural scenarios. Unread exact bytes6EBA/6EBB/6EBC/6EBF correspond to types5/6/7/10. Original6ECB..6ED6 is0101010101010000000000. Read indices0..9 have8/8/3/3/21/4/10/11/14/16 scenarios; only6ED5/type10 is unread. Original6EF7..6F02 equals6EB5, but all11 bytes are unread. None of the16 unread bytes is promoted; all three whole11-byte storage headers remain PROBABLE. Four accepted role statuses reflect observed consumer use and do not claim complete storage reads. No sibling table is merged or reused by name, and no code/data boundary or representation changes.
