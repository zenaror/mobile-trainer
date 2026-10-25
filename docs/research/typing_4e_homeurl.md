# Original bank 4E HomeURL representation

The bounded unit 4E:4904–493B contains 54 printable ASCII bytes followed by one NUL. Its existing CONFIRMED storage status and two labels, String_Browser_HomeUrl and Data_4E_4904, remain unchanged. This change exposes text using four db chunks of 16, 16, 16 and 6 ASCII bytes, with a final zero. PUSHC sjis and POPC isolate the charmap; printable ASCII has its original byte values. No URL content is changed.

Browser_LoadHomePage loads HL with this unit at 4E:48F5, DE with wAttrUrlBuf, then calls CopyString at 4E:48FB.

The callee is fixed ROM 00:14BF: it reads [HL++] and writes [DE++], stopping after copying NUL.

Source line count, both label positions, every instruction, neighboring units, all other 21 unit statuses and all 289 maintained TSV files remain unchanged. No locator remap is needed. Unknown units, incomplete descriptors, the 27-slot table's lack of a universal clamp, and unread data retain their previous confidence. This is a representation correction for already confirmed original-ROM data, with no name or confidence promotion. It makes no English runtime claim and includes no personal source examples.
