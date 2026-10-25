; data/html/pages_email_to_m_home.asm
; bank 3E, $4D27-$5B9F (3704 bytes); pinned by layout.link
; Built-in English HTML record stream; record bodies can continue in the adjacent section.

SECTION "data/html/pages_email_to_m_home", ROMX

PUSHC sjis

; Continuation of gbcorse.htm body from the preceding pinned section.
BrowserHtmlStore_RecordGbcorseBodyContinuation:: ; 3E:4D27
	db "bed to the　<B>DION Mobile GB<BR>Course</B>, you cannot use<BR><A HREF=\"../di/m_tre.htm\""
	db ">Mobile Trainer</A>.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "For more information,<BR>please read the manual.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordGbcorseBodyEnd:: ; 3E:4DD9

; ---- text $4DD9-$4ECC (243 bytes) [CONFIRMED] download.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordDownload:: ; 3E:4DD9
	db "download.htm", 0
	dw BrowserHtmlStore_RecordDownloadBodyEnd - BrowserHtmlStore_RecordDownloadBody ; body length, including NUL
BrowserHtmlStore_RecordDownloadBody:: ; 3E:4DE8
	db "<HTML>", $0D, $0A
	db "<TITLE>Download</TITLE>", $0D, $0A
	db "This is the process of<BR>taking data from a<BR>computer on the<BR><A HREF=\"../di/intern"
	db "et.htm\">Internet</A>　and bringing<BR>it to your own computer.　　　　　　　　　　　　　"
	db "　　　 ", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordDownloadBodyEnd:: ; 3E:4ECC

; ---- text $4ECC-$4FFA (302 bytes) [CONFIRMED] email.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordEmail:: ; 3E:4ECC
	db "email.htm", 0
	dw BrowserHtmlStore_RecordEmailBodyEnd - BrowserHtmlStore_RecordEmailBody ; body length, including NUL
BrowserHtmlStore_RecordEmailBody:: ; 3E:4ED8
	db "<HTML>", $0D, $0A
	db "<TITLE>Email </TITLE>", $0D, $0A
	db "<B>【Mail】　<br></B><HR>", $0D, $0A
	db "This is a kind of letter exchanged via computer<BR>networks that doesn't<BR>even need a "
	db "stamp or an envelope.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "On　<A HREF=\"../di/internet.htm\">the Internet</A>, after you send an email, it<BR>arrive"
	db "s instantly! ", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordEmailBodyEnd:: ; 3E:4FFA

; ---- text $4FFA-$5145 (331 bytes) [CONFIRMED] internet.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordInternet:: ; 3E:4FFA
	db "internet.htm", 0
	dw BrowserHtmlStore_RecordInternetBodyEnd - BrowserHtmlStore_RecordInternetBody ; body length, including NUL
BrowserHtmlStore_RecordInternetBody:: ; 3E:5009
	db "<HTML>", $0D, $0A
	db "<TITLE>Internet　</TITLE>", $0D, $0A
	db "<B>【The Internet】　</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "It's the network that<BR>connects computers all<BR>around the world.", $0D, $0A
	db "<BR><BR>If you use the　<A HREF=\"../di/ma.htm\">Mobile<BR>Adapter GB</A>,　your Game<BR>B"
	db "oy Color can also<BR><A HREF=\"../di/connect.htm\">connect</a>　to　<B>Internet</B>!</HTML"
	db ">", 0
BrowserHtmlStore_RecordInternetBodyEnd:: ; 3E:5145

; ---- text $5145-$5310 (459 bytes) [CONFIRMED] facemark.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordFacemark:: ; 3E:5145
	db "facemark.htm", 0
	dw BrowserHtmlStore_RecordFacemarkBodyEnd - BrowserHtmlStore_RecordFacemarkBody ; body length, including NUL
BrowserHtmlStore_RecordFacemarkBody:: ; 3E:5154
	db "<HTML>", $0D, $0A
	db "<TITLE>Emoticon</TITLE>", $0D, $0A
	db "<B>【Kaomoji】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "Using letters and<br>symbols, you can make<br>different facial<br>expressions. It's usef"
	db "ul in　<A HREF=\"../di/email.htm\">email</A>　because it's hard to convey feelings with ju"
	db "st text.", $0D, $0A
	db "<HR>", $0D, $0A
	db "　Hello<br> ", $0D, $0A
	db "　<B>（＾ｏ＾）／</B><BR>", $0D, $0A
	db "　Crying　　　　<br>", $0D, $0A
	db "　<B>（ＴＯＴ）</B><BR>", $0D, $0A
	db "　Surprise <br>", $0D, $0A
	db "　<B>（＊＿＊）”</B><BR>", $0D, $0A
	db "<HR>", $0D, $0A
	db "It's fun to add them<br>sometimes, right?　　", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordFacemarkBodyEnd:: ; 3E:5310

; ---- text $5310-$5427 (279 bytes) [CONFIRMED] hensin.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordHensin:: ; 3E:5310
	db "hensin.htm", 0
	dw BrowserHtmlStore_RecordHensinBodyEnd - BrowserHtmlStore_RecordHensinBody ; body length, including NUL
BrowserHtmlStore_RecordHensinBody:: ; 3E:531D
	db "<HTML>", $0D, $0A
	db "<TITLE>Reply</TITLE>", $0D, $0A
	db "This is a response to a received　<A HREF=\"../di/email.htm\">email</A>.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "The recipient's　<A HREF=\"../di/address.htm\">email<BR>address</A>　is already<BR>filled "
	db "in, which spares you the effort!　　　　　　　 　　　 ", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordHensinBodyEnd:: ; 3E:5427

; ---- text $5427-$5612 (491 bytes) [CONFIRMED] loginid.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordLoginid:: ; 3E:5427
	db "loginid.htm", 0
	dw BrowserHtmlStore_RecordLoginidBodyEnd - BrowserHtmlStore_RecordLoginidBody ; body length, including NUL
BrowserHtmlStore_RecordLoginidBody:: ; 3E:5435
	db "<HTML>", $0D, $0A
	db "<TITLE>Login ID</TITLE>", $0D, $0A
	db "<B>【Log-in ID】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is the number that you use to　<A HREF=\"../di/connect.htm\">connect</A>　to the　<A "
	db "HREF=\"../di/internet.htm\">Internet</A>　via the　<A HREF=\"../di/gbcorse.htm\">DION Mobile"
	db " GB Course</A>.", $0D, $0A
	db "<BR>", $0D, $0A
	db "If you do not　<A HREF=\"../di/syokitou.htm\">register</A><BR>your　<B>Login ID</B>　on yo"
	db "ur<BR><A HREF=\"../di/ma.htm\">Mobile Adapter GB</A>, you<BR>cannot use　<A HREF=\"../di/m_"
	db "tre.htm\">Mobile<BR>Trainer</A>.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordLoginidBodyEnd:: ; 3E:5612

; ---- text $5612-$5757 (325 bytes) [CONFIRMED] homepage.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordHomepage:: ; 3E:5612
	db "homepage.htm", 0
	dw BrowserHtmlStore_RecordHomepageBodyEnd - BrowserHtmlStore_RecordHomepageBody ; body length, including NUL
BrowserHtmlStore_RecordHomepageBody:: ; 3E:5621
	db "<HTML>", $0D, $0A
	db "<TITLE>Web Page</TITLE>", $0D, $0A
	db "<B>【Home Page】</B><HR>", $0D, $0A
	db "This is a place on the　<A HREF=\"../di/internet.htm\">internet</A>　that sends all kinds "
	db "of information<BR>using pictures and text.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "When you use the Home<BR>Page feature on this<BR>cartridge, you can view all of this inf"
	db "ormation.", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordHomepageBodyEnd:: ; 3E:5757

; ---- text $5757-$58B6 (351 bytes) [CONFIRMED] m_home.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMHome:: ; 3E:5757
	db "m_home.htm", 0
	dw BrowserHtmlStore_RecordMHomeBodyEnd - BrowserHtmlStore_RecordMHomeBody ; body length, including NUL
BrowserHtmlStore_RecordMHomeBody:: ; 3E:5764
	db "<HTML>", $0D, $0A
	db "<TITLE>Mobile Homepage</TITLE>", $0D, $0A
	db "<B>【Nintendo Mobile Homepage】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is the　<A HREF=\"../di/homepage.htm\">web page</A><BR>you can view using<BR><A HREF="
	db "\"../di/m_tre.htm\">Mobile Trainer</A>.　", $0D, $0A
	db "<br><br>", $0D, $0A
	db "Game information and<BR>announcements from<BR>Nintendo are posted on<BR>the site, so ple"
	db "ase take a look!", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordMHomeBodyEnd:: ; 3E:58B6

; ---- text $58B6-$5A5E (424 bytes) [CONFIRMED] m_sys.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMSys:: ; 3E:58B6
	db "m_sys.htm", 0
	dw BrowserHtmlStore_RecordMSysBodyEnd - BrowserHtmlStore_RecordMSysBody ; body length, including NUL
BrowserHtmlStore_RecordMSysBody:: ; 3E:58C2
	db "<HTML>", $0D, $0A
	db "<TITLE>Mobile System GB　　</TITLE>", $0D, $0A
	db "<B>【Mobile System】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "It's the system where,<BR>by using the　<A HREF=\"../di/ma.htm\">Mobile<BR>Adapter GB</A>,"
	db " a Game Boy<BR>Color and a mobile phone connect to　<A HREF=\"../di/internet.htm\">Interne"
	db "t</A>.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "When you use the Mobile System GB, you can<BR>experience a variety of<BR><A HREF=\"../di/"
	db "contents.htm\">content</A>.　　　　　　　 ", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordMSysBodyEnd:: ; 3E:5A5E

; ---- text $5A5E-$5B47 (233 bytes) [CONFIRMED] m_tre.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMTre:: ; 3E:5A5E
	db "m_tre.htm", 0
	dw BrowserHtmlStore_RecordMTreBodyEnd - BrowserHtmlStore_RecordMTreBody ; body length, including NUL
BrowserHtmlStore_RecordMTreBody:: ; 3E:5A6A
	db "<HTML>", $0D, $0A
	db "<TITLE>Mobile Trainer</TITLE>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is the cartridge<BR>you are using now!　　 ", $0D, $0A
	db "<br><br>", $0D, $0A
	db "You can send　<A HREF=\"../di/email.htm\">email</A>　and read　<A HREF=\"../di/homepage.htm"
	db "\">web pages</A>.", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordMTreBodyEnd:: ; 3E:5B47

; ---- text $5B47-$5C11 (202 bytes) [CONFIRMED] ma.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMa:: ; 3E:5B47
	db "ma.htm", 0
	dw BrowserHtmlStore_RecordMaBodyEnd - BrowserHtmlStore_RecordMaBody ; body length, including NUL
BrowserHtmlStore_RecordMaBody:: ; 3E:5B50
	db "<HTML>", $0D, $0A
	db "<TITLE>Mobile Adapter GB</TITLE>", $0D, $0A
	db "This is the thing you<BR>use to　<A H"
; Body continues at the beginning of the next pinned section.

POPC
