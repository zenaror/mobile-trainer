; data/html/pages_a_mark_to_download.asm
; bank 3E, $4000-$4D27 (3367 bytes); pinned by layout.link
; HTML store records a_mark.htm .. download.htm

SECTION "data/html/pages_a_mark_to_download", ROMX

PUSHC sjis

; ---- text $4000-$4D27 (3367 bytes) [CONFIRMED] text: 42 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated) (part of region $4000-$75D0)

String_3E_4000:: ; 3E:4000
	db "a_mark.htm", 0
	dw $00BF ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>＠</TITLE>", $0D, $0A
	db "<B>【あっとまーく】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/address.htm\">メールアドレス</A>にかならずはいっているマーク。<BR><B>アットマーク</B>というなまえなんだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "account.htm", 0
	dw $0218 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>アカウント</TITLE>", $0D, $0A
	db "<B>【あかうんと】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>に<A HREF=\"../di/connect.htm\">せつぞく</a>したり、<A HREF=\"../di/email.htm\">メール</A>をつかうためには、<A HREF=\"../di/loginid.htm\">ログインＩＤ</A>や<A HREF=\"../di/password.htm\">パスワード</A>という、こじんのじょうほうがひつようなんだ。<br>", $0D, $0A
	db "この、こじんのじょうほうをまとめて<B>アカウント</B>っていうんだよ。<br>", $0D, $0A
	db "<B>アカウント</B>は、とてもたいせつなじょうほうだから、ぜったいにほかのひとにおしえちゃだめだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "add_tyou.htm", 0
	dw $013A ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>アドレス帳</TITLE>", $0D, $0A
	db "<B>【あどれすちょう】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/address.htm\">メールアドレス</A>のためのじゅうしょろくのようなもので、ともだちの<A HREF=\"../di/address.htm\">メールアドレス</A>をかきのこしておくことができるんだ。<br>", $0D, $0A
	db "とうろくしておくと、なんどもおくるときにべんりだね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "address.htm", 0
	dw $018A ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>メールアドレス</TITLE>", $0D, $0A
	db "<B>【めーるあどれす】</B><br>", $0D, $0A
	db "<B>【アドレス】</B><br>", $0D, $0A
	db "<B>【あどれす】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>の<A HREF=\"../di/atesaki.htm\">あてさき</A>のことだよ。ひとり１つずつかならずあるよ。<BR>", $0D, $0A
	db "<B>aaa@bbb.cc.dd</B><BR>", $0D, $0A
	db "こんなかきかただよ。<BR>", $0D, $0A
	db "ちょっとややこしいけど、ともだちにおしえてあげるときは、まちがえないようにしてね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "atesaki.htm", 0
	dw $00C6 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>宛先</TITLE>", $0D, $0A
	db "<B>【あてさき】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>のおくりさき。<br>", $0D, $0A
	db "つまり、あいての<A HREF=\"../di/address.htm\">メールアドレス</A>のことだね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "browser.htm", 0
	dw $00EE ; body length
	db "<HTML><TITLE>ブラウザ</TITLE><B>【ぶらうざ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/homepage.htm\">ホームページ</A>のデータをみるためのきのうだよ。<BR>", $0D, $0A
	db "このカートリッジでは<A HREF=\"../di/homepage.htm\">ホームページ</A>ってよんでいるんだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "connect.htm", 0
	dw $00F3 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>接続</TITLE>", $0D, $0A
	db "<B>【せつぞく】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "つなげることだよ。<BR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>につなげるときは、「<A HREF=\"../di/internet.htm\">インターネット</A>に<B>せつぞく</B>する」と、いうんだ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "contents.htm", 0
	dw $0113 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>コンテンツ</TITLE>", $0D, $0A
	db "<B>【こんてんつ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "つうしんで<A HREF=\"../di/download.htm\">ダウンロード</A>するデータのことだよ。<br>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>や<A HREF=\"../di/homepage.htm\">ホームページ</A>も<B>コンテンツ</B>の１つなんだ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "data_cen.htm", 0
	dw $016D ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>モバイルセンター</TITLE>", $0D, $0A
	db "<B>【もばいるせんたー】<br>", $0D, $0A
	db "【モバイルデータセンター】<br>", $0D, $0A
	db "【もばいるでーたせんたー】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/m_sys.htm\">モバイルシステムＧＢ</A>せんようのたくさんの<A HREF=\"../di/saver.htm\">サーバ</A>がおいてあるばしょのことだよ。<br>", $0D, $0A
	db "<A HREF=\"../di/m_home.htm\">モバイルホームページ</A>もここにあるんだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "dion.htm", 0
	dw $0100 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ＤＩＯＮ</TITLE>", $0D, $0A
	db "<B>【でぃおん】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "かぶしきがいしゃディーディーアイ（ＫＤＤＩ）がていきょうする<A HREF=\"../di/internet.htm\">インターネット</A>せつぞくサービス（<A HREF=\"../di/provider.htm\">プロバイダ</A>）のことだよ。", $0D, $0A
	db $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "download.htm", 0
	dw $00CB ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ダウンロード</TITLE>", $0D, $0A
	db "<B>【だうんろーど】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>上にあるコンピュータから、じぶんのコンピュータにデータをもってくることだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

POPC
