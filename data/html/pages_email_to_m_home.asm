; data/html/pages_email_to_m_home.asm
; bank 3E, $4D27-$5B9F (3704 bytes); pinned by layout.link
; HTML store records email.htm .. m_home.htm

SECTION "data/html/pages_email_to_m_home", ROMX

PUSHC sjis

; ---- text $4D27-$5B9F (3704 bytes) [CONFIRMED] text: 42 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated) (part of region $4000-$75D0)
	db "email.htm", 0
	dw $011C ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>メール</TITLE>", $0D, $0A
	db "<B>【めーる】<br></B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "コンピュータネットワークでやりとりされる、きってもふうとうもいらないてがみのこと。<BR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>のせかいでは、<B>メール</B>をおくってからとうちゃくするのも、いっしゅんだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "facemark.htm", 0
	dw $01C8 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>フェイスマーク</TITLE>", $0D, $0A
	db "<B>【ふぇいすまーく】<BR>", $0D, $0A
	db "【かおもじ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "もじやきごうをつかって、いろんなひょうじょうをつくるんだ。<A HREF=\"../di/email.htm\">メール</A>など、もじだけだとなんとなくきもちがつたわりにくい、そんなときにつかおうね。<BR>", $0D, $0A
	db "<HR>", $0D, $0A
	db "　こんにちは <br>", $0D, $0A
	db "　<B>（＾ｏ＾）／</B><BR>", $0D, $0A
	db "　え～ん　　 <br>", $0D, $0A
	db "　<B>（ＴＯＴ）</B><BR>", $0D, $0A
	db "　おどろき <br>", $0D, $0A
	db "　<B>（＊＿＊）”</B><BR>", $0D, $0A
	db "<HR>", $0D, $0A
	db "ちょっとついてるとたのしいよね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "gbcorse.htm", 0
	dw $018A ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>DIONモバイルGBコース</TITLE>", $0D, $0A
	db "<B>【でぃおんもばいるじーびーこーす】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/dion.htm\">ＤＩＯＮ</A>の<A HREF=\"../di/m_sys.htm\">モバイルシステムＧＢ</A>せんようのコースだよ。<br>", $0D, $0A
	db "<A HREF=\"../di/m_tre.htm\">モバイルトレーナー</A>は、<B>ＤＩＯＮモバイルＧＢコース</B>をけいやくしなければつかえないよ。<br>", $0D, $0A
	db "くわしくはとりあつかいせつめいしょをよんでね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "hensin.htm", 0
	dw $00FE ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>返信</TITLE>", $0D, $0A
	db "<B>【へんしん】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "うけとった<A HREF=\"../di/email.htm\">メール</A>のへんじをかくことだよ。<BR>", $0D, $0A
	db "あいての<A HREF=\"../di/address.htm\">メールアドレス</A>がじどうてきににゅうりょくされるので、てまがはぶけるよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "homepage.htm", 0
	dw $0114 ; body length
	db "<HTML><TITLE>ホームページ</TITLE><B>【ほーむぺーじ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>で、えやもじをつかっていろんなじょうほうを、おくっているばしょのこと。<BR>", $0D, $0A
	db "このカートリッジの<b>ホームページ</b>きのうをつかうと、みることができるんだ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "internet.htm", 0
	dw $014E ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>インターネット</TITLE>", $0D, $0A
	db "<B>【いんたーねっと】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "せかいじゅうのコンピュータがつながってできているネットワークのことだよ。<BR>", $0D, $0A
	db "<A HREF=\"../di/ma.htm\">モバイルアダプタＧＢ</A>をつかえば、キミのゲームボーイカラーも<B>インターネット</B>に<A HREF=\"../di/connect.htm\">せつぞく</a>できるようになるんだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "jump.htm", 0
	dw $00AE ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ジャンプ</TITLE>", $0D, $0A
	db "<B>【じゃんぷ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/link.htm\">リンク</A>さきの<A HREF=\"../di/homepage.htm\">ホームページ</A>にいくことだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "link.htm", 0
	dw $0152 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>リンク</TITLE>", $0D, $0A
	db "<B>【りんく】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/homepage.htm\">ホームページ</A>から、ほかの<A HREF=\"../di/homepage.htm\">ホームページ</A>につながっているいりぐちだよ。<BR>", $0D, $0A
	db "<B>リンク</B>をたどっていくと、すてきな<A HREF=\"../di/homepage.htm\">ホームページ</A>にであえるかも。でも、まいごにならないようにね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "loginid.htm", 0
	dw $01D0 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ログインＩＤ</TITLE>", $0D, $0A
	db "<B>【ろぐいんあいでぃー】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/gbcorse.htm\">ＤＩＯＮモバイルＧＢコース</A>で<A HREF=\"../di/internet.htm\">インターネット</A>に<A HREF=\"../di/connect.htm\">せつぞく</A>するときのばんごうのことだよ。<br>", $0D, $0A
	db "<A HREF=\"../di/m_tre.htm\">モバイルトレーナー</A>は、<A HREF=\"../di/ma.htm\">モバイルアダプタＧＢ</A>に<b>ログインＩＤ</B>を<A HREF=\"../di/syokitou.htm\">しょきとうろく</A>しないとつかえないよ。", $0D, $0A
	db $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "m_friend.htm", 0
	dw $00AF ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>メルとも</TITLE>", $0D, $0A
	db "<B>【めるとも】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>をおくりあうともだちのことだよ。いっぱい<B>メルとも</B>つくろうね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "m_home.htm", 0
	dw $0197 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>モバイルホームページ</TITLE>", $0D, $0A
	db "<B>【もばいるほーむぺーじ】<br>", $0D, $0A
	db "【にんてんどうモバイルホームページ】<br>", $0D, $0A
	db "【にんてんどうもばいるほーむぺーじ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/m_tre.htm\">モバイルトレーナー</A>でみることのできる、にんてんどうの<A HREF=\"../di/homepage.htm\">ホームページ</A>のことだよ。<br>", $0D, $0A
	db "ゲームのじょうほうやにんてんどうからのおしらせなんかがかいてあるからみてみてね。", $0D, $0A
	db $0D, $0A
	db "</HTML>", $0D, $0A, 0

POPC
