; data/html/pages_online_to_receive.asm
; bank 3E, $6C4F-$7FCD (4990 bytes); pinned by layout.link
; Built-in English HTML record stream; record bodies can continue in the adjacent section.

SECTION "data/html/pages_online_to_receive", ROMX

PUSHC sjis

; Continuation of offline.htm body from the preceding pinned section.
BrowserHtmlStore_RecordOfflineBodyContinuation:: ; 3E:6C4F
	db ">make sure to switch to<BR>viewing　<B>offline</B>! ", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordOfflineBodyEnd:: ; 3E:6C8F

; ---- text $6C8F-$6E2A (411 bytes) [CONFIRMED] online.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordOnline:: ; 3E:6C8F
	db "online.htm", 0
	dw BrowserHtmlStore_RecordOnlineBodyEnd - BrowserHtmlStore_RecordOnlineBody ; body length, including NUL
BrowserHtmlStore_RecordOnlineBody:: ; 3E:6C9C
	db "<HTML>", $0D, $0A
	db "<TITLE>Online</TITLE>", $0D, $0A
	db "As opposed to　<A HREF=\"../di/offline.htm\">offline</A>, this is the state of<BR>being co"
	db "nnected to the　<A HREF=\"../di/internet.htm\">Internet</A>.　", $0D, $0A
	db "<BR>", $0D, $0A
	db "When you are　<A HREF=\"../di/translat.htm\">sending</A><BR>an　<A HREF=\"../di/email.htm\">"
	db "email</A>　or looking at a　<A HREF=\"../di/homepage.htm\">web page</A>, you are<BR><B>onl"
	db "ine</B>.　　　　　　　 ", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordOnlineBodyEnd:: ; 3E:6E2A

; ---- text $6E2A-$6F89 (351 bytes) [CONFIRMED] password.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordPassword:: ; 3E:6E2A
	db "password.htm", 0
	dw BrowserHtmlStore_RecordPasswordBodyEnd - BrowserHtmlStore_RecordPasswordBody ; body length, including NUL
BrowserHtmlStore_RecordPasswordBody:: ; 3E:6E39
	db "<HTML>", $0D, $0A
	db "<TITLE>Password</TITLE>", $0D, $0A
	db "This is a type of<BR><A HREF=\"../di/security.htm\">security</A>. ", $0D, $0A
	db "Without it,<BR>you can't access the<BR><A HREF=\"../di/homepage.htm\">home page</A>　or se"
	db "nd<BR><A HREF=\"../di/email.htm\">email</A>.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "Because it's important<BR>information, make sure<BR>not to share it with<BR>anyone!", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordPasswordBodyEnd:: ; 3E:6F89

; ---- text $6F89-$704F (198 bytes) [CONFIRMED] phs.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordPhs:: ; 3E:6F89
	db "phs.htm", 0
	dw BrowserHtmlStore_RecordPhsBodyEnd - BrowserHtmlStore_RecordPhsBody ; body length, including NUL
BrowserHtmlStore_RecordPhsBody:: ; 3E:6F93
	db "<HTML><TITLE>ＰＨＳ</TITLE>", $0D, $0A
	db "This is a type of phone that uses the　<b>PHS</b>　system.", $0D, $0A
	db "<br>", $0D, $0A
	db "The red　<A HREF=\"../di/ma.htm\">Mobile Adapter GB</A>　is for　<B>PHS</B>　phones. ", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordPhsBodyEnd:: ; 3E:704F

; ---- text $704F-$72D4 (645 bytes) [CONFIRMED] provider.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordProvider:: ; 3E:704F
	db "provider.htm", 0
	dw BrowserHtmlStore_RecordProviderBodyEnd - BrowserHtmlStore_RecordProviderBody ; body length, including NUL
BrowserHtmlStore_RecordProviderBody:: ; 3E:705E
	db "<HTML>", $0D, $0A
	db "<TITLE>Provider/ISP</TITLE>", $0D, $0A
	db "<B>【Provider】<br>", $0D, $0A
	db "【ＩＳＰ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is the company that connects you to the<BR><A HREF=\"../di/internet.htm\">Internet</A"
	db ">. ", $0D, $0A
	db "For example,<BR>to use electricity, you sign a contract with an electric company. ", $0D, $0A
	db "To use the water supply, you<BR>sign a contract with the water utility.", $0D, $0A
	db "<BR>", $0D, $0A
	db "To connect to the<BR><A HREF=\"../di/internet.htm\">Internet</A>, you sign a<BR>contract w"
	db "ith a<BR><B>Provider</B>. ", $0D, $0A
	db "An　<b>ＩＳＰ</b>　is an Internet Service<BR>Provider（<b>I</b>nternet<BR><b>S</b>ervice"
	db "　<b>P</b>rovider）.　　　　　　　　　　　　　　　　　　　　　　　　　　　　　", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordProviderBodyEnd:: ; 3E:72D4

; ---- text $72D4-$7421 (333 bytes) [CONFIRMED] receive.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordReceive:: ; 3E:72D4
	db "receive.htm", 0
	dw BrowserHtmlStore_RecordReceiveBodyEnd - BrowserHtmlStore_RecordReceiveBody ; body length, including NUL
BrowserHtmlStore_RecordReceiveBody:: ; 3E:72E2
	db "<HTML><TITLE>Receive</TITLE>", $0D, $0A
	db "This is when you receive data over　<A HREF=\"../di/internet.htm\">the internet</A>.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "When your friend sends<BR>an　<A HREF=\"../di/email.htm\">email</A>　and it<BR>arrives in "
	db "your mailbox, it's called 「<B>receiving</B><BR>an 　<A HREF=\"../di/email.htm\">email</A>"
	db "」.　　", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordReceiveBodyEnd:: ; 3E:7421

; ---- text $7421-$74B9 (152 bytes) [CONFIRMED] security.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordSecurity:: ; 3E:7421
	db "security.htm", 0
	dw BrowserHtmlStore_RecordSecurityBodyEnd - BrowserHtmlStore_RecordSecurityBody ; body length, including NUL
BrowserHtmlStore_RecordSecurityBody:: ; 3E:7430
	db "<HTML>", $0D, $0A
	db "<TITLE>Security</TITLE>", $0D, $0A
	db "This is about keeping<BR>personal data safe from others so everyone can<BR>play online s"
	db "afely.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordSecurityBodyEnd:: ; 3E:74B9

; ---- text $74B9-$75FF (326 bytes) [CONFIRMED] syokitou.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordSyokitou:: ; 3E:74B9
	db "syokitou.htm", 0
	dw BrowserHtmlStore_RecordSyokitouBodyEnd - BrowserHtmlStore_RecordSyokitouBody ; body length, including NUL
BrowserHtmlStore_RecordSyokitouBody:: ; 3E:74C8
	db "<HTML>", $0D, $0A
	db "<TITLE>Registration </TITLE>", $0D, $0A
	db "In order to use the<BR><A HREF=\"../di/m_sys.htm\">Mobile System GB</A>, you<BR>must regis"
	db "ter your<BR><A HREF=\"../di/ma.htm\">Mobile Adapter GB</A>. ", $0D, $0A
	db "You<BR>can't use　<A HREF=\"../di/m_tre.htm\">Mobile<BR>Trainer</A>　without<BR>completing"
	db " initial<BR>registration.　", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordSyokitouBodyEnd:: ; 3E:75FF

; ---- text $75FF-$771C (285 bytes) [CONFIRMED] tu_error.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordTuError:: ; 3E:75FF
	db "tu_error.htm", 0
	dw BrowserHtmlStore_RecordTuErrorBodyEnd - BrowserHtmlStore_RecordTuErrorBody ; body length, including NUL
BrowserHtmlStore_RecordTuErrorBody:: ; 3E:760E
	db "<HTML>", $0D, $0A
	db "<TITLE>Comm. Error</TITLE>", $0D, $0A
	db "<B>【Communication Error】 </B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is when the　<A HREF=\"../di/ma.htm\">Mobile Adapter GB</A>　fails to<BR>connect.<br>"
	db $0D, $0A
	db "When it happens, an<br>error screen will be<br>displayed, so please<br>read it carefully"
	db ".      ", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordTuErrorBodyEnd:: ; 3E:771C

; ---- text $771C-$7821 (261 bytes) [CONFIRMED] saport.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordSaport:: ; 3E:771C
	db "saport.htm", 0
	dw BrowserHtmlStore_RecordSaportBodyEnd - BrowserHtmlStore_RecordSaportBody ; body length, including NUL
BrowserHtmlStore_RecordSaportBody:: ; 3E:7729
	db "<HTML>", $0D, $0A
	db "<TITLE>Support Center</TITLE>", $0D, $0A
	db "<B>【Mobile Support Center】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is the place that<BR>handles inquiries for<BR>the　<A HREF=\"../di/m_sys.htm\">Mobile"
	db " System GB</A>.", $0D, $0A
	db "<BR>", $0D, $0A
	db "For details, please read the instruction manual.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordSaportBodyEnd:: ; 3E:7821

; ---- text $7821-$79A8 (391 bytes) [CONFIRMED] saver.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordSaver:: ; 3E:7821
	db "saver.htm", 0
	dw BrowserHtmlStore_RecordSaverBodyEnd - BrowserHtmlStore_RecordSaverBody ; body length, including NUL
BrowserHtmlStore_RecordSaverBody:: ; 3E:782D
	db "<HTML>", $0D, $0A
	db "<TITLE>Server</TITLE>", $0D, $0A
	db "A　<B>server</B>　is a computer that provides content<BR>for your Game Boy Color.", $0D, $0A
	db "<BR>", $0D, $0A
	db "Servers host various<BR>services such as　<A HREF=\"../di/email.htm\">email</A><BR>exchang"
	db "e,　<A HREF=\"../di/homepage.htm\">webpage</A>　hosting and　<A HREF=\"../di/internet.htm\">"
	db " Internet</A>　data<BR><A HREF=\"../di/download.htm\">downloads</A>.　　　 ", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordSaverBodyEnd:: ; 3E:79A8

; ---- text $79A8-$7A83 (219 bytes) [CONFIRMED] title.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordTitle:: ; 3E:79A8
	db "title.htm", 0
	dw BrowserHtmlStore_RecordTitleBodyEnd - BrowserHtmlStore_RecordTitleBody ; body length, including NUL
BrowserHtmlStore_RecordTitleBody:: ; 3E:79B4
	db "<HTML>", $0D, $0A
	db "<TITLE>Title</TITLE>", $0D, $0A
	db "This is about　<A HREF=\"../di/email.htm\">email</A><BR><b>titles</b>. ", $0D, $0A
	db "There are no<BR>rules for writing a<BR>title, but it usually<BR>reflects the email's<BR>"
	db "content.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordTitleBodyEnd:: ; 3E:7A83

; ---- text $7A83-$7B6B (232 bytes) [CONFIRMED] translat.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordTranslat:: ; 3E:7A83
	db "translat.htm", 0
	dw BrowserHtmlStore_RecordTranslatBodyEnd - BrowserHtmlStore_RecordTranslatBody ; body length, including NUL
BrowserHtmlStore_RecordTranslatBody:: ; 3E:7A92
	db "<HTML>", $0D, $0A
	db "<TITLE>Send</TITLE>", $0D, $0A
	db "Sending is the opposite of　<A HREF=\"../di/receive.htm\">receiving</A>. To send <br>an　<"
	db "A HREF=\"../di/email.htm\">email</A>　means to <br>deliver or transmit it <br>to someone."
	db "　 ", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordTranslatBodyEnd:: ; 3E:7B6B

; ---- text $7B6B-$7C56 (235 bytes) [CONFIRMED] cdmaone.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordCdmaone:: ; 3E:7B6B
	db "cdmaone.htm", 0
	dw BrowserHtmlStore_RecordCdmaoneBodyEnd - BrowserHtmlStore_RecordCdmaoneBody ; body length, including NUL
BrowserHtmlStore_RecordCdmaoneBody:: ; 3E:7B79
	db "<HTML><TITLE>ｃｄｍａＯｎｅ</TITLE>", $0D, $0A
	db "<b>cdmaOne</b>　is a type of <br>mobile phone that uses <br>CDMA technology.", $0D, $0A
	db "<br>The yellow　<A HREF=\"../di/ma.htm\">Mobile<BR>Adapter GB</A>　is for　<b>cdmaOne</b>"
	db "　phones.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordCdmaoneBodyEnd:: ; 3E:7C56

; ---- text $7C56-$7CE9 (147 bytes) [CONFIRMED] user.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordUser:: ; 3E:7C56
	db "user.htm", 0
	dw BrowserHtmlStore_RecordUserBodyEnd - BrowserHtmlStore_RecordUserBody ; body length, including NUL
BrowserHtmlStore_RecordUserBody:: ; 3E:7C61
	db "<HTML>", $0D, $0A
	db "<TITLE>User</TITLE>", $0D, $0A
	db "A　<B>user</B>　is a person who uses something.　　<br>", $0D, $0A
	db "For this cartridge, <br>you're the user!", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordUserBodyEnd:: ; 3E:7CE9

; ---- text $7CE9-$7DEB (258 bytes) [CONFIRMED] website.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordWebsite:: ; 3E:7CE9
	db "website.htm", 0
	dw BrowserHtmlStore_RecordWebsiteBodyEnd - BrowserHtmlStore_RecordWebsiteBody ; body length, including NUL
BrowserHtmlStore_RecordWebsiteBody:: ; 3E:7CF7
	db "<HTML>", $0D, $0A
	db "<TITLE>Site/Website</TITLE>", $0D, $0A
	db "<B>【Site】<BR>", $0D, $0A
	db "【Web Site】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "A　<B>website</B>　is a <br>computer that hosts a<br><A HREF=\"../di/homepage.htm\">web pa"
	db "ge</A>. As of <br>recently, websites are <br>often called web pages.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordWebsiteBodyEnd:: ; 3E:7DEB

; ---- text $7DEB-$7FCD (482 bytes) [CONFIRMED] www.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordWww:: ; 3E:7DEB
	db "www.htm", 0
	dw BrowserHtmlStore_RecordWwwBodyEnd - BrowserHtmlStore_RecordWwwBody ; body length, including NUL
BrowserHtmlStore_RecordWwwBody:: ; 3E:7DF5
	db "<HTML>", $0D, $0A
	db "<TITLE>ＷＷＷ/Ｗｅｂ</TITLE>", $0D, $0A
	db "<B>【World Wide Web】　　　<br>", $0D, $0A
	db "【The Web】</B><HR>If you are connected to<br><A HREF=\"../di/internet.htm\">the Internet<"
	db "/A>, you can<BR>read information from<BR>all around the world on<br><A HREF=\"../di/homep"
	db "age.htm\">web pages</A>. <br><br>", $0D, $0A
	db "This system is called<BR>the　<B>world・wide・web</B>.<br><br>", $0D, $0A
	db "The name comes the idea that computers around<br>the world are linked<br>together like a"
	db " spider's nest (<B>web</B>). ", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordWwwBodyEnd:: ; 3E:7FCD

POPC
