; data/html/pages_saport_to_tu_error.asm
; bank 3D, $4000-$48D1 (2257 bytes); pinned by layout.link
; Built-in English HTML record stream; record bodies can continue in the adjacent section.

SECTION "data/html/pages_saport_to_tu_error", ROMX

PUSHC sjis

; ---- text $4000-$417A (378 bytes) [CONFIRMED] website.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordWebsiteAlternate:: ; 3D:4000
	db "website.htm", 0
	dw BrowserHtmlStore_RecordWebsiteAlternateBodyEnd - BrowserHtmlStore_RecordWebsiteAlternateBody ; body length, including NUL
BrowserHtmlStore_RecordWebsiteAlternateBody:: ; 3D:400E
	db "<HTML>", $0D, $0A
	db "<TITLE>　Site/website　　 </TITLE>", $0D, $0A
	db "<B>【Site】　<BR>", $0D, $0A
	db "【Web Site】　　</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/homepage.htm\">home page　 </A>is in,　　　　<A HREF=\"../di/connect.htm\">c"
	db "onnect </A>　<br>about the computer in front　 <B>website</B>　I mean, in the end,　　<A"
	db " HREF=\"../di/homepage.htm\"><br>home page　 </A><br>I often call that.　　　　　　　　", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordWebsiteAlternateBodyEnd:: ; 3D:417A

; ---- text $417A-$4367 (493 bytes) [CONFIRMED] www.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordWwwAlternate:: ; 3D:417A
	db "www.htm", 0
	dw BrowserHtmlStore_RecordWwwAlternateBodyEnd - BrowserHtmlStore_RecordWwwAlternateBody ; body length, including NUL
BrowserHtmlStore_RecordWwwAlternateBody:: ; 3D:4184
	db "<HTML>", $0D, $0A
	db "<TITLE>ＷＷＷ/Ｗｅｂ</TITLE>", $0D, $0A
	db "<B>【World Wide Web】　　　<br>", $0D, $0A
	db "【World Wide Web】　　　<br>", $0D, $0A
	db "【web】　 <br>", $0D, $0A
	db "【web】</B><HR>The world's most important information if you are connected to　<A HREF=\""
	db "../di/internet.htm\">the Internet</A>, you can see it at　<A HREF=\"../di/homepage.htm\">ho"
	db "me page</A>. About how it works,　<B>world・wide・web</B>　it's called.<BR>Spider's nest"
	db " (<B>web</B>). The name comes from connection between two, as in all computers in the wo"
	db "rld.　</HTML>", 0
BrowserHtmlStore_RecordWwwAlternateBodyEnd:: ; 3D:4367

; ---- zero $4367-$48D1 (1386 bytes) [CONFIRMED] unused original-page allocation; all indexed English records end at 3D:4367.
	ds $56A, $00

POPC
