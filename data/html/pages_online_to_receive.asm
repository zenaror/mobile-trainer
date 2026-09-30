; data/html/pages_online_to_receive.asm
; bank 3E, $6C4F-$75D0 (2433 bytes); pinned by layout.link
; HTML store records online.htm .. receive.htm

SECTION "data/html/pages_online_to_receive", ROMX

PUSHC sjis

; ---- text $6C4F-$75D0 (2433 bytes) [CONFIRMED] text: 42 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated) (part of region $4000-$75D0)
	db "online.htm", 0
	dw $018C ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>オンライン</TITLE>", $0D, $0A
	db "<B>【おんらいん】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/offline.htm\">オフライン</A>のはんたいで、<A HREF=\"../di/internet.htm\">インターネット</A>につながっているじょうたいだよ。<BR>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>を<A HREF=\"../di/translat.htm\">そうしん</A>したり、<A HREF=\"../di/homepage.htm\">ホームページ</A>をみているときは<B>オンライン</B>になるんだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "pagelist.htm", 0
	dw $011E ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ページリスト</TITLE>", $0D, $0A
	db "<B>【ぺーじりすと】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<b>ページリスト</b>には、おきにいりの<A HREF=\"../di/homepage.htm\">ホームページ</A>のあるばしょをセーブしておくことができるんだ。<BR>", $0D, $0A
	db "セーブしたページをえらぶだけで、そのページをみることができるんだよ。<br>", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "password.htm", 0
	dw $012E ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>パスワード</TITLE>", $0D, $0A
	db "<B>【ぱすわーど】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/security.htm\">セキュリティ</A>の１つで、これがないと<A HREF=\"../di/homepage.htm\">ホームページ</A>も<A HREF=\"../di/email.htm\">メール</A>もできないよ。<BR>", $0D, $0A
	db "だいじなじょうほうだからほかのひとにおしえちゃダメだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "phs.htm", 0
	dw $00F1 ; body length
	db "<HTML><TITLE>ＰＨＳ</TITLE><B>【ぴーえっちえす】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "でんわきのしゅるいの１つで、<b>ＰＨＳ</b>ほうしきのでんわきのことだよ。<br>", $0D, $0A
	db "あかいろの<A HREF=\"../di/ma.htm\">モバイルアダプタＧＢ</A>は<b>ＰＨＳ</b>のでんわきようだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "pdc.htm", 0
	dw $00F4 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ＰＤＣ</TITLE>", $0D, $0A
	db "<B>【ぴーでぃーしー】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "でんわきのしゅるいの１つで、デジタルほうしきのけいたいでんわきのこと。<br>", $0D, $0A
	db "あおいろの<A HREF=\"../di/ma.htm\">モバイルアダプタＧＢ</A>は<b>ＰＤＣ</b>のでんわきようだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "provider.htm", 0
	dw $023B ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>プロバイダ／ＩＳＰ</TITLE>", $0D, $0A
	db "<B>【ぷろばいだ】<br>", $0D, $0A
	db "【あいえすぴー】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>につなげてくれる、かいしゃのことだよ。たとえば、でんきをつかえるようにするには、でんりょくがいしゃ、すいどうをつかえるようにするには、すいどうきょくとけいやくするよね。<BR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>につなげるには、<B>プロバイダ</B>とけいやくするんだ。", $0D, $0A
	db "<b>ＩＳＰ</b>はインターネットサービスプロバイダ（<b>Ｉ</b>ｎｔｅｒｎｅｔ　<b>Ｓ</b>ｅｒｖｉｃｅｓ　<b>Ｐ</b>ｒｏｖｉｄｅｒ）のことなんだよ。", $0D, $0A
	db $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "receive.htm", 0
	dw $012C ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>受信</TITLE>", $0D, $0A
	db "<B>【じゅしん】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>でデータをうけとることだよ。<BR>", $0D, $0A
	db "ともだちがだした<A HREF=\"../di/email.htm\">メール</A>をうけとることは、<br>", $0D, $0A
	db "「<A HREF=\"../di/email.htm\">メール</A>を<B>じゅしん</B>する」っていうんだ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0
	db 0

POPC
