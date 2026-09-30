; data/html/pages_saport_to_tu_error.asm
; bank 3D, $4000-$48D1 (2257 bytes); pinned by layout.link
; HTML store records saport.htm .. tu_error.htm

SECTION "data/html/pages_saport_to_tu_error", ROMX

PUSHC sjis

; ---- text $4000-$48D1 (2257 bytes) [CONFIRMED] text: 13 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated) (part of region $4000-$518D)

String_3D_4000:: ; 3D:4000
	db "saport.htm", 0
	dw $0134 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>サポートセンター</TITLE>", $0D, $0A
	db "<B>【さぽーとせんたー】<br>", $0D, $0A
	db "【モバイルサポートセンター】<br>", $0D, $0A
	db "【もばいるさぽーとせんたー】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/m_sys.htm\">モバイルシステムＧＢ</A>にかんするおといあわせをうけつけているところだよ。<br>", $0D, $0A
	db "くわしくはとりあつかいせつめいしょをよんでね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "saver.htm", 0
	dw $01D2 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>サーバ</TITLE>", $0D, $0A
	db "<B>【さーば】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<B>サーバ</B>はもともと「めしつかい」といういみで、キミのゲームボーイカラーのためにいろいろなしごとをしてくれるコンピュータのことだよ。<br>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>での<A HREF=\"../di/email.htm\">メール</A>のこうかんや、<A HREF=\"../di/homepage.htm\">ホームページ</A>のひょうじ、データの<A HREF=\"../di/download.htm\">ダウンロード</A>などのいろいろなサービスをしてくれてるんだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "security.htm", 0
	dw $00CA ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>セキュリティ</TITLE>", $0D, $0A
	db "<B>【せきゅりてぃ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "みんながあんぜんにあそべるために、コンピュータのなかみや、おくったデータをしらないひとにとられないようにすることだよ。<br>", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "syokitou.htm", 0
	dw $0160 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>初期登録</TITLE>", $0D, $0A
	db "<B>【しょきとうろく】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/m_sys.htm\">モバイルシステムＧＢ</A>をりようするためにひつようなじょうほうを、<A HREF=\"../di/ma.htm\">モバイルアダプタＧＢ</A>にとうろくすることだよ。<br>", $0D, $0A
	db "<A HREF=\"../di/m_tre.htm\">モバイルトレーナー</A>は<B>しょきとうろく</B>をしないとつかうことができないよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "title.htm", 0
	dw $010C ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>タイトル</TITLE>", $0D, $0A
	db "<B>【たいとる】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>の<b>タイトル</b>のことだよ。<br>", $0D, $0A
	db "かきかたにきまりはないけど、ふつうは<A HREF=\"../di/email.htm\">メール</A>のないようがわかるような<B>タイトル</B>をつけるんだ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "translat.htm", 0
	dw $0115 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>送信</TITLE>", $0D, $0A
	db "<B>【そうしん】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/receive.htm\">じゅしん</A>のはんたいでデータをおくることだよ。<BR><A HREF=\"../di/email.htm\">メール</A>をおくることは、", $0D, $0A
	db "「<A HREF=\"../di/email.htm\">メール</A>を<B>そうしん</B>する」っていうんだ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "tu_error.htm", 0
	dw $011F ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>通信エラー</TITLE>", $0D, $0A
	db "<B>【つうしんえらー】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/ma.htm\">モバイルアダプタＧＢ</A>をつかったつうしんがうまくいかないことだよ。<br>", $0D, $0A
	db "<B>つうしんエラー</B>がおきたときには<B>つうしんエラー</B>がめんがひょうじされるから、せつめいをよくよんでね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

POPC
