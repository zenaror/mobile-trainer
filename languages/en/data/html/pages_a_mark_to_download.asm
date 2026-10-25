; data/html/pages_a_mark_to_download.asm
; bank 3E, $4000-$4D27 (3367 bytes); pinned by layout.link
; Built-in English HTML record stream; record bodies can continue in the adjacent section.

SECTION "data/html/pages_a_mark_to_download", ROMX

PUSHC sjis

; ---- text $4000-$4128 (296 bytes) [CONFIRMED] contents.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordContents:: ; 3E:4000
	db "contents.htm", 0
	dw BrowserHtmlStore_RecordContentsBodyEnd - BrowserHtmlStore_RecordContentsBody ; body length, including NUL
BrowserHtmlStore_RecordContentsBody:: ; 3E:400F
	db "<HTML>", $0D, $0A
	db "<TITLE>Content</TITLE>", $0D, $0A
	db "This is the data that <BR>you　<A HREF=\"../di/download.htm\">download</A>　over a<BR>conn"
	db "ection.", $0D, $0A
	db "<BR>", $0D, $0A
	db "For example,　<A HREF=\"../di/email.htm\">email</A>　and<BR><A HREF=\"../di/homepage.htm\">w"
	db "eb pages</A>　are types of<BR><B>content</B>!　 ", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordContentsBodyEnd:: ; 3E:4128

; ---- text $4128-$4326 (510 bytes) [CONFIRMED] account.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordAccount:: ; 3E:4128
	db "account.htm", 0
	dw BrowserHtmlStore_RecordAccountBodyEnd - BrowserHtmlStore_RecordAccountBody ; body length, including NUL
BrowserHtmlStore_RecordAccountBody:: ; 3E:4136
	db "<HTML><TITLE>Account</TITLE>", $0D, $0A
	db "In order to　<A HREF=\"../di/connect.htm\">connect</A><BR>to the　<A HREF=\"../di/internet."
	db "htm\">internet</A>, use<br><A HREF=\"../di/email.htm\">email</a>,　etc., you need<br>person"
	db "al information<br>such as　<A HREF=\"../di/loginid.htm\">Log-in ID</a>　and<br><A HREF=\".."
	db "/di/password.htm\">password</a>.", $0D, $0A
	db "<br><br>All this info combined<BR>is called an　<B>account</B>.", $0D, $0A
	db "<br><br>Accounts contain very<br>important information,<br>so never share them with<br>a"
	db "nyone.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordAccountBodyEnd:: ; 3E:4326

; ---- text $4326-$44A0 (378 bytes) [CONFIRMED] address.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordAddress:: ; 3E:4326
	db "address.htm", 0
	dw BrowserHtmlStore_RecordAddressBodyEnd - BrowserHtmlStore_RecordAddressBody ; body length, including NUL
BrowserHtmlStore_RecordAddressBody:: ; 3E:4334
	db "<HTML>", $0D, $0A
	db "<TITLE>Email Address</TITLE>", $0D, $0A
	db "<B>【Address】 </B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is the　<A HREF=\"../di/atesaki.htm\">destination</A>of an　<A HREF=\"../di/email.htm\""
	db ">email</A>. ", $0D, $0A
	db "<BR><BR>Everyone has only one.<BR>It looks like this:<BR><B>aaa@bbb.cc.dd</B>", $0D, $0A
	db "<BR><BR>It's a bit complicated, so when you share it<BR>with your friends, try<br>not to"
	db " mess it up.　　　　", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordAddressBodyEnd:: ; 3E:44A0

; ---- text $44A0-$45A5 (261 bytes) [CONFIRMED] add_tyou.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordAddTyou:: ; 3E:44A0
	db "add_tyou.htm", 0
	dw BrowserHtmlStore_RecordAddTyouBodyEnd - BrowserHtmlStore_RecordAddTyouBody ; body length, including NUL
BrowserHtmlStore_RecordAddTyouBody:: ; 3E:44AF
	db "<HTML>", $0D, $0A
	db "<TITLE>Address Book</TITLE>", $0D, $0A
	db "It's like a directory,<BR>but for your friends'<BR><A HREF=\"../di/address.htm\">email add"
	db "resses</A>.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "Once email addresses are registered, it's really easy to email the same<BR>people!　　　"
	db $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordAddTyouBodyEnd:: ; 3E:45A5

; ---- text $45A5-$46EF (330 bytes) [CONFIRMED] data_cen.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordDataCen:: ; 3E:45A5
	db "data_cen.htm", 0
	dw BrowserHtmlStore_RecordDataCenBodyEnd - BrowserHtmlStore_RecordDataCenBody ; body length, including NUL
BrowserHtmlStore_RecordDataCenBody:: ; 3E:45B4
	db "<HTML>", $0D, $0A
	db "<TITLE>Mobile Center　 </TITLE>", $0D, $0A
	db "<B>【Mobile Data center】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is the place<br>where lots of　<A HREF=\"../di/saver.htm\">servers</A>　for the　<A H"
	db "REF=\"../di/m_sys.htm\">Mobile System<BR>GB</A>　are kept.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "The　<A HREF=\"../di/m_home.htm\">Mobile Homepage</A><br>is also here! ", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordDataCenBodyEnd:: ; 3E:46EF

; ---- text $46EF-$47BB (204 bytes) [CONFIRMED] atesaki.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordAtesaki:: ; 3E:46EF
	db "atesaki.htm", 0
	dw BrowserHtmlStore_RecordAtesakiBodyEnd - BrowserHtmlStore_RecordAtesakiBody ; body length, including NUL
BrowserHtmlStore_RecordAtesakiBody:: ; 3E:46FD
	db "<HTML>", $0D, $0A
	db "<TITLE>Destination</TITLE>", $0D, $0A
	db "This is the place where an　<A HREF=\"../di/email.htm\">email</A>　arrives－in<BR>other wo"
	db "rds, the　<A HREF=\"../di/address.htm\">email address</A>.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordAtesakiBodyEnd:: ; 3E:47BB

; ---- text $47BB-$4874 (185 bytes) [CONFIRMED] a_mark.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordAmark:: ; 3E:47BB
	db "a_mark.htm", 0
	dw BrowserHtmlStore_RecordAmarkBodyEnd - BrowserHtmlStore_RecordAmarkBody ; body length, including NUL
BrowserHtmlStore_RecordAmarkBody:: ; 3E:47C8
	db "<HTML>", $0D, $0A
	db "<TITLE>＠</TITLE>", $0D, $0A
	db "<B>【At Sign】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is the name for the symbol that is always<BR>used in an　<A HREF=\"../di/address.htm"
	db "\">email<BR>address</A>.</HTML>", 0
BrowserHtmlStore_RecordAmarkBodyEnd:: ; 3E:4874

; ---- text $4874-$496F (251 bytes) [CONFIRMED] pagelist.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordPagelist:: ; 3E:4874
	db "pagelist.htm", 0
	dw BrowserHtmlStore_RecordPagelistBodyEnd - BrowserHtmlStore_RecordPagelistBody ; body length, including NUL
BrowserHtmlStore_RecordPagelistBody:: ; 3E:4883
	db "<HTML>", $0D, $0A
	db "<TITLE>Bookmarks</TITLE>", $0D, $0A
	db "<HR>", $0D, $0A
	db "The　<b>Bookmarks</b>　is the<BR>place where you can save your favorite　<A HREF=\"../di/"
	db "homepage.htm\">web pages</A>for later.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "If you select a saved<BR>page, you can view it!", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordPagelistBodyEnd:: ; 3E:496F

; ---- text $496F-$4A74 (261 bytes) [CONFIRMED] browser.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordBrowser:: ; 3E:496F
	db "browser.htm", 0
	dw BrowserHtmlStore_RecordBrowserBodyEnd - BrowserHtmlStore_RecordBrowserBody ; body length, including NUL
BrowserHtmlStore_RecordBrowserBody:: ; 3E:497D
	db "<HTML><TITLE>Browser</TITLE>", $0D, $0A
	db "This is the tool that<BR>lets you view　<A HREF=\"../di/homepage.htm\">web page</A><BR>dat"
	db "a.", $0D, $0A
	db "<br>", $0D, $0A
	db "In this game, the<br>browser is called　<A HREF=\"../di/homepage.htm\">Home Page</A>.　　"
	db "　　　　　　　　　　　", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordBrowserBodyEnd:: ; 3E:4A74

; ---- text $4A74-$4B3B (199 bytes) [CONFIRMED] dion.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordDion:: ; 3E:4A74
	db "dion.htm", 0
	dw BrowserHtmlStore_RecordDionBodyEnd - BrowserHtmlStore_RecordDionBody ; body length, including NUL
BrowserHtmlStore_RecordDionBody:: ; 3E:4A7F
	db "<HTML>", $0D, $0A
	db "<TITLE>ＤＩＯＮ</TITLE>", $0D, $0A
	db "<B>【Ｄｉｏｎ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is an internet<BR>connection service (AKA<BR><A HREF=\"../di/provider.htm\">Provider<"
	db "/A>) by DDI Corp.<BR>(KDDI).", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordDionBodyEnd:: ; 3E:4B3B

; ---- text $4B3B-$4C0A (207 bytes) [CONFIRMED] connect.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordConnect:: ; 3E:4B3B
	db "connect.htm", 0
	dw BrowserHtmlStore_RecordConnectBodyEnd - BrowserHtmlStore_RecordConnectBody ; body length, including NUL
BrowserHtmlStore_RecordConnectBody:: ; 3E:4B49
	db "<HTML>", $0D, $0A
	db "<TITLE>Connection</TITLE><B>【Connect】</B><HR>", $0D, $0A
	db "It means to link up!<BR>", $0D, $0A
	db "When you go online, you are　<B>connecting</B>　to the<BR><A HREF=\"../di/internet.htm\">I"
	db "nternet</A>.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordConnectBodyEnd:: ; 3E:4C0A

; ---- text $4C0A-$4DD9 (463 bytes) [CONFIRMED] gbcorse.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordGbcorse:: ; 3E:4C0A
	db "gbcorse.htm", 0
	dw BrowserHtmlStore_RecordGbcorseBodyEnd - BrowserHtmlStore_RecordGbcorseBody ; body length, including NUL
BrowserHtmlStore_RecordGbcorseBody:: ; 3E:4C18
	db "<HTML>", $0D, $0A
	db "<TITLE>DION Moba GB Course</TITLE>", $0A, "<B>【DION Mobile GB Course】<BR>【Mobile GB Course】<"
	db "/B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is　<A HREF=\"../di/dion.htm\">DION's</A><BR>subscription plan for<BR>using the　<A H"
	db "REF=\"../di/m_sys.htm\">Mobile System GB</A>.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "If you aren't subscri"
; Body continues at the beginning of the next pinned section.

POPC
