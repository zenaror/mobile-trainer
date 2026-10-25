; data/html/pages_m_sys_to_offline.asm
; bank 3E, $5B9F-$6C4F (4272 bytes); pinned by layout.link
; Built-in English HTML record stream; record bodies can continue in the adjacent section.

SECTION "data/html/pages_m_sys_to_offline", ROMX

PUSHC sjis

; Continuation of ma.htm body from the preceding pinned section.
BrowserHtmlStore_RecordMaBodyContinuation:: ; 3E:5B9F
	db "REF=\"../di/connect.htm\">connect</a>　a Game Boy Color and mobile<BR>phone for online<BR>"
	db "communication.", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordMaBodyEnd:: ; 3E:5C11

; ---- text $5C11-$5CBB (170 bytes) [CONFIRMED] jump.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordJump:: ; 3E:5C11
	db "jump.htm", 0
	dw BrowserHtmlStore_RecordJumpBodyEnd - BrowserHtmlStore_RecordJumpBody ; body length, including NUL
BrowserHtmlStore_RecordJumpBody:: ; 3E:5C1C
	db "<HTML>", $0D, $0A
	db "<TITLE>Jump</TITLE>", $0D, $0A
	db "This is when you follow a　<A HREF=\"../di/link.htm\">link</A>　to another<BR><A HREF=\"../"
	db "di/homepage.htm\">web page</A>.", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordJumpBodyEnd:: ; 3E:5CBB

; ---- text $5CBB-$5DF4 (313 bytes) [CONFIRMED] link.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordLink:: ; 3E:5CBB
	db "link.htm", 0
	dw BrowserHtmlStore_RecordLinkBodyEnd - BrowserHtmlStore_RecordLinkBody ; body length, including NUL
BrowserHtmlStore_RecordLinkBody:: ; 3E:5CC6
	db "<HTML>", $0D, $0A
	db "<TITLE>Link</TITLE>", $0D, $0A
	db "This is a doorway that<BR>connects one　<A HREF=\"../di/homepage.htm\">web page</A><BR>to "
	db "another　<A HREF=\"../di/homepage.htm\">web page</A>.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "If you follow　<B>links</B>,<BR>you might find some<BR>wonderful web pages. But be caref"
	db "ul not to get<BR>lost!", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordLinkBodyEnd:: ; 3E:5DF4

; ---- text $5DF4-$5F52 (350 bytes) [CONFIRMED] mail_sav.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMailSav:: ; 3E:5DF4
	db "mail_sav.htm", 0
	dw BrowserHtmlStore_RecordMailSavBodyEnd - BrowserHtmlStore_RecordMailSavBody ; body length, including NUL
BrowserHtmlStore_RecordMailSavBody:: ; 3E:5E03
	db "<HTML>", $0D, $0A
	db "<TITLE>Email Server</TITLE>", $0D, $0A
	db "<B>【Mail Server】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is a　<A HREF=\"../di/saver.htm\">server</A>　that exchanges　<A HREF=\"../di/email.ht"
	db "m\">emails</A><BR>between Game Boy Color, PC, mobile phones, etc.", $0D, $0A
	db "<br><br>", $0D, $0A
	db "In other words, it's<BR>like an　<A HREF=\"../di/internet.htm\">Internet</A>　post office."
	db "　　", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordMailSavBodyEnd:: ; 3E:5F52

; ---- text $5F52-$60D8 (390 bytes) [CONFIRMED] mente.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMente:: ; 3E:5F52
	db "mente.htm", 0
	dw BrowserHtmlStore_RecordMenteBodyEnd - BrowserHtmlStore_RecordMenteBody ; body length, including NUL
BrowserHtmlStore_RecordMenteBody:: ; 3E:5F5E
	db "<HTML>", $0D, $0A
	db "<TITLE>Maintenance</TITLE>", $0D, $0A
	db "This means checking that a computer or machine is working properly, and<BR>fixing it whe"
	db "n something is wrong.", $0D, $0A
	db "<br><br>", $0D, $0A
	db "When the　<A HREF=\"../di/data_cen.htm\">Mobile Data<BR>Center</A>　or　<A HREF=\"../di/dio"
	db "n.htm\">DION</A>　are<BR>under　<B>maintenance</B>, the<BR><A HREF=\"../di/m_sys.htm\">Mobi"
	db "le System GB</A>　cannot be used.", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordMenteBodyEnd:: ; 3E:60D8

; ---- text $60D8-$61A0 (200 bytes) [CONFIRMED] m_friend.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMFriend:: ; 3E:60D8
	db "m_friend.htm", 0
	dw BrowserHtmlStore_RecordMFriendBodyEnd - BrowserHtmlStore_RecordMFriendBody ; body length, including NUL
BrowserHtmlStore_RecordMFriendBody:: ; 3E:60E7
	db "<HTML>", $0D, $0A
	db "<TITLE>Pen Pal</TITLE>", $0D, $0A
	db "<B>【Mail Friend】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is a friend that<BR>you exchange　<A HREF=\"../di/email.htm\">emails</A><BR>with. Let"
	db "'s make lots of pen pals!", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordMFriendBodyEnd:: ; 3E:61A0

; ---- text $61A0-$6313 (371 bytes) [CONFIRMED] mailsoft.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMailsoft:: ; 3E:61A0
	db "mailsoft.htm", 0
	dw BrowserHtmlStore_RecordMailsoftBodyEnd - BrowserHtmlStore_RecordMailsoftBody ; body length, including NUL
BrowserHtmlStore_RecordMailsoftBody:: ; 3E:61AF
	db "<HTML>", $0D, $0A
	db "<TITLE>Mailer</TITLE>", $0D, $0A
	db "<B>【Email Software】<BR>", $0D, $0A
	db "【Email Program】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is the software you absolutely need to use　<A HREF=\"../di/email.htm\">email</A>. ", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "Using a　<B>mailer</B>, you can <A HREF=\"../di/translat.htm\">send</A>　or　<A HREF=\"../d"
	db "i/receive.htm\">receive</A><br><A HREF=\"../di/email.htm\">email</A>.　　 ", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordMailsoftBodyEnd:: ; 3E:6313

; ---- text $6313-$6461 (334 bytes) [CONFIRMED] marklist.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMarklist:: ; 3E:6313
	db "marklist.htm", 0
	dw BrowserHtmlStore_RecordMarklistBodyEnd - BrowserHtmlStore_RecordMarklistBody ; body length, including NUL
BrowserHtmlStore_RecordMarklistBody:: ; 3E:6322
	db "<HTML>", $0D, $0A
	db "<TITLE>Read Symbols</TITLE>", $0D, $0A
	db "<B>【How to Read Symbols】 </B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "「<B>/</B>」 Slash　　 <BR>", $0D, $0A
	db "「<B>.</B>」 Period　　 <BR>", $0D, $0A
	db "「<B>@</B>」 At Sign　　 <BR>", $0D, $0A
	db "「<B>:</B>」 Colon　<BR>", $0D, $0A
	db "「<B>;</B>」 Semicolon　<BR>", $0D, $0A
	db "「<B>_</B>」 Underscore　　 <BR>", $0D, $0A
	db "「<B>-</B>」 Hyphen　 <BR>", $0D, $0A
	db "「<B>,</B>」 Comma <BR>", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordMarklistBodyEnd:: ; 3E:6461

; ---- text $6461-$651F (190 bytes) [CONFIRMED] mobile.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordMobile:: ; 3E:6461
	db "mobile.htm", 0
	dw BrowserHtmlStore_RecordMobileBodyEnd - BrowserHtmlStore_RecordMobileBody ; body length, including NUL
BrowserHtmlStore_RecordMobileBody:: ; 3E:646E
	db "<HTML>", $0D, $0A
	db "<TITLE>Mobile</TITLE>", $0D, $0A
	db "While this originally<BR>meant 「something that<BR>moves」, it's often used to mean 「co"
	db "mputers and phones that you can use on the go」.", $0D, $0A
	db "</HTML>", 0
BrowserHtmlStore_RecordMobileBodyEnd:: ; 3E:651F

; ---- text $651F-$65F9 (218 bytes) [CONFIRMED] pdc.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordPdc:: ; 3E:651F
	db "pdc.htm", 0
	dw BrowserHtmlStore_RecordPdcBodyEnd - BrowserHtmlStore_RecordPdcBody ; body length, including NUL
BrowserHtmlStore_RecordPdcBody:: ; 3E:6529
	db "<HTML>", $0D, $0A
	db "<TITLE>ＰＤＣ</TITLE>", $0D, $0A
	db "This is a type of phone. Specifically, a type of digital mobile phone.", $0D, $0A
	db "<br>The blue　<A HREF=\"../di/ma.htm\">Mobile Adapter GB</A>　is for　<b>PDC</b>　phones."
	db "　　　 ", $0A, "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordPdcBodyEnd:: ; 3E:65F9

; ---- text $65F9-$66EE (245 bytes) [CONFIRMED] netiquet.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordNetiquet:: ; 3E:65F9
	db "netiquet.htm", 0
	dw BrowserHtmlStore_RecordNetiquetBodyEnd - BrowserHtmlStore_RecordNetiquetBody ; body length, including NUL
BrowserHtmlStore_RecordNetiquetBody:: ; 3E:6608
	db "<HTML>", $0D, $0A
	db "<TITLE>Netiquette</TITLE>", $0D, $0A
	db "This is etiquette on the network－in other words, rules and manners.", $0D, $0A
	db "<BR>", $0D, $0A
	db "Even on the　<A HREF=\"../di/internet.htm\">Internet</A>,<BR>you shouldn't do things that "
	db "upset other people!", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordNetiquetBodyEnd:: ; 3E:66EE

; ---- text $66EE-$68A5 (439 bytes) [CONFIRMED] netsurf.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordNetsurf:: ; 3E:66EE
	db "netsurf.htm", 0
	dw BrowserHtmlStore_RecordNetsurfBodyEnd - BrowserHtmlStore_RecordNetsurfBody ; body length, including NUL
BrowserHtmlStore_RecordNetsurfBody:: ; 3E:66FC
	db "<HTML>", $0D, $0A
	db "<TITLE>Internet Surfing</TITLE>", $0D, $0A
	db "<B>【Net Surfing】<BR>", $0D, $0A
	db "【Web Surfing】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "This is when you browse through many　<A HREF=\"../di/homepage.htm\">web pages</A><BR>one "
	db "after another.　", $0D, $0A
	db "The name comes from the way that moving across<BR>web pages is similar to surfing. ", $0D, $0A
	db "In the sea of<BR>the　<A HREF=\"../di/internet.htm\">Internet</A>, the　<A HREF=\"../di/hom"
	db "epage.htm\">web<BR>pages</A>　are the waves.", $0A, "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordNetsurfBodyEnd:: ; 3E:68A5

; ---- text $68A5-$69AC (263 bytes) [CONFIRMED] nickname.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordNickname:: ; 3E:68A5
	db "nickname.htm", 0
	dw BrowserHtmlStore_RecordNicknameBodyEnd - BrowserHtmlStore_RecordNicknameBody ; body length, including NUL
BrowserHtmlStore_RecordNicknameBody:: ; 3E:68B4
	db "<HTML>", $0D, $0A
	db "<TITLE>Nickname</TITLE>", $0D, $0A
	db "A　<B>nickname</B>　is a pet<BR>name, alias, or term of endearment.<br>", $0D, $0A
	db "You can assign a<BR><B>nickname</B>　in the　<A HREF=\"../di/email.htm\">email</A><BR><A H"
	db "REF=\"../di/add_tyou.htm\">address book</A>.", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordNicknameBodyEnd:: ; 3E:69AC

; ---- text $69AC-$6B51 (421 bytes) [CONFIRMED] ninsyou.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordNinsyou:: ; 3E:69AC
	db "ninsyou.htm", 0
	dw BrowserHtmlStore_RecordNinsyouBodyEnd - BrowserHtmlStore_RecordNinsyouBody ; body length, including NUL
BrowserHtmlStore_RecordNinsyouBody:: ; 3E:69BA
	db "<HTML>", $0D, $0A
	db "<TITLE>Authentication</TITLE>", $0D, $0A
	db "When your　<A HREF=\"../di/loginid.htm\">Login ID</A>　and<BR><A HREF=\"../di/password.htm\""
	db ">password</A>　are verified<BR>by your　<A HREF=\"../di/provider.htm\">Provider</A>, ", $0D, $0A
	db "you<BR>are granted permission<BR>to　<A HREF=\"../di/connect.htm\">connect</A>　to the<BR>"
	db "<A HREF=\"../di/internet.htm\"> Internet</A>.", $0D, $0A
	db "<BR>", $0D, $0A
	db "This is called<BR>「<B>Authentication</B>」.", $0D, $0A
	db "</HTML>", $0D, $0A, 0
BrowserHtmlStore_RecordNinsyouBodyEnd:: ; 3E:6B51

; ---- text $6B51-$6C8F (318 bytes) [CONFIRMED] offline.htm: filename/NUL, length, NUL-terminated English HTML.
BrowserHtmlStore_RecordOffline:: ; 3E:6B51
	db "offline.htm", 0
	dw BrowserHtmlStore_RecordOfflineBodyEnd - BrowserHtmlStore_RecordOfflineBody ; body length, including NUL
BrowserHtmlStore_RecordOfflineBody:: ; 3E:6B5F
	db "<HTML>", $0D, $0A
	db "<TITLE>Offline</TITLE>", $0D, $0A
	db "This is the state of not being connected to　<A HREF=\"../di/internet.htm\">the Internet</"
	db "A>.", $0D, $0A
	db "<BR><BR>", $0D, $0A
	db "To avoid phone charges<BR>when you are slowly<BR>reading a　<A HREF=\"../di/homepage.htm\""
	db ">web page</A>,<BR"
; Body continues at the beginning of the next pinned section.

POPC
