; data/html/pages_m_sys_to_offline.asm
; bank 3E, $5B9F-$6C4F (4272 bytes); pinned by layout.link
; HTML store records m_sys.htm .. offline.htm

SECTION "data/html/pages_m_sys_to_offline", ROMX

PUSHC sjis

; ---- text $5B9F-$6C4F (4272 bytes) [CONFIRMED] text: 42 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated) (part of region $4000-$75D0)
	db "m_sys.htm", 0
	dw $01C0 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>モバイルシステムＧＢ</TITLE>", $0D, $0A
	db "<B>【もばいるしすてむじーびー】<br>", $0D, $0A
	db "【モバイルシステム】<br>", $0D, $0A
	db "【もばいるしすてむ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "ゲームボーイカラーとでんわきを<A HREF=\"../di/ma.htm\">モバイルアダプタＧＢ</A>でせつぞくして<A HREF=\"../di/internet.htm\">インターネット</A>とつうしんするしくみのことだよ。<br>", $0D, $0A
	db "<B>モバイルシステムＧＢ</B>をつかうと、いろいろな<A HREF=\"../di/contents.htm\">コンテンツ</A>をりようすることができるよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "m_tre.htm", 0
	dw $0107 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>モバイルトレーナー</TITLE>", $0D, $0A
	db "<B>【もばいるとれーなー】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "キミがいまつかっている、カートリッジのことだよ。<br>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>こうかんや、<A HREF=\"../di/homepage.htm\">ホームページ</A>をみることができるよ。", $0D, $0A
	db $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "ma.htm", 0
	dw $00D6 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>モバイルアダプタＧＢ</TITLE>", $0D, $0A
	db "<B>【もばいるあだぷたじーびー】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "ゲームボーイカラーとでんわきを<A HREF=\"../di/connect.htm\">せつぞく</a>してつうしんをするためのアダプタのことだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "mail_sav.htm", 0
	dw $0155 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>メールサーバ</TITLE>", $0D, $0A
	db "<B>【めーるさーば】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "ゲームボーイカラーやパソコン、けいたいでんわなどのあいだで、<A HREF=\"../di/email.htm\">メール</A>をこうかんしてくれる<A HREF=\"../di/saver.htm\">サーバ</A>のことだよ。<br>", $0D, $0A
	db "つまり、<A HREF=\"../di/internet.htm\">インターネット</A>のゆうびんきょくみたいなものなんだ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "mailsoft.htm", 0
	dw $0168 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>メーラー</TITLE>", $0D, $0A
	db "<B>【めーらー】<BR>", $0D, $0A
	db "【メールソフト】<BR>", $0D, $0A
	db "【めーるそふと】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>をつかうために、かならずひつようなソフトのこと。<BR>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>の<A HREF=\"../di/translat.htm\">そうしん</A>や<A HREF=\"../di/receive.htm\">じゅしん</A>は、<B>メーラー</B>からするんだ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "marklist.htm", 0
	dw $013E ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>記号の読み方</TITLE>", $0D, $0A
	db "<B>【きごうのよみかた】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "「<B>/</B>」 スラッシュ<BR>", $0D, $0A
	db "「<B>.</B>」 ピリオド、ドット<BR>", $0D, $0A
	db "「<B>@</B>」 アットマーク<BR>", $0D, $0A
	db "「<B>:</B>」 コロン <BR>", $0D, $0A
	db "「<B>;</B>」 セミコロン <BR>", $0D, $0A
	db "「<B>_</B>」 アンダーバー <BR>", $0D, $0A
	db "「<B>-</B>」 ハイフン <BR>", $0D, $0A
	db "「<B>,</B>」 コンマ<BR>", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "mente.htm", 0
	dw $0189 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>メンテナンス</TITLE>", $0D, $0A
	db "<B>【めんてなんす】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "コンピュータやきかいが、ちゃんとうごいているかけんさしたり、おかしいときにしゅうりすることだよ。<br>", $0D, $0A
	db "<A HREF=\"../di/data_cen.htm\">モバイルデータセンター</A>や<A HREF=\"../di/dion.htm\">ＤＩＯＮ</A>が<B>メンテナンス</B>をしているときは、<A HREF=\"../di/m_sys.htm\">モバイルシステムＧＢ</A>をつかうことができないよ。", $0D, $0A
	db $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "mobile.htm", 0
	dw $00C0 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>モバイル</TITLE>", $0D, $0A
	db "<B>【もばいる】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "もともと「いどうする」といういみなんだけど、「コンピュータやでんわきをもちあるいてつかう」といういみでよくつかわれるよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "netiquet.htm", 0
	dw $00F3 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ネチケット</TITLE>", $0D, $0A
	db "<B>【ねちけっと】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "ネットワークじょうでのエチケット、つまり、ルールやマナーのことだよ。<BR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>でも、ひとのいやがることをしちゃダメだからね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "netsurf.htm", 0
	dw $0163 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ネットサーフィン</TITLE>", $0D, $0A
	db "<B>【ねっとさーふぃん】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "いろんな<A HREF=\"../di/homepage.htm\">ホームページ</A>をつぎつぎとみてまわること。<A HREF=\"../di/internet.htm\">インターネット</A>のうみで、<A HREF=\"../di/homepage.htm\">ホームページ</A>というなみをサーフィンのように、つぎつぎとわたりあるくことからこうよばれているんだ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "nickname.htm", 0
	dw $010D ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ニックネーム</TITLE>", $0D, $0A
	db "<B>【にっくねーむ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<B>ニックネーム</B>はあだなやあいしょうのことだよ。<br>", $0D, $0A
	db "<A HREF=\"../di/email.htm\">メール</A>にある<A HREF=\"../di/add_tyou.htm\">アドレスちょう</A>で、<B>ニックネーム</B>をつけられるんだ。", $0D, $0A
	db $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "ninsyou.htm", 0
	dw $017E ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>認証</TITLE>", $0D, $0A
	db "<B>【にんしょう】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/loginid.htm\">ログインＩＤ</A>や<A HREF=\"../di/password.htm\">パスワード</A>を<A HREF=\"../di/provider.htm\">プロバイダ</A>がかくにんして、<A HREF=\"../di/internet.htm\">インターネット</A>への<A HREF=\"../di/connect.htm\">せつぞく</A>をきょかすることを<BR>", $0D, $0A
	db "「<B>にんしょう</B>する」<BR>", $0D, $0A
	db "というんだ。<BR>", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "offline.htm", 0
	dw $013F ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>オフライン</TITLE>", $0D, $0A
	db "<B>【おふらいん】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>につながっていないじょうたいのことだよ。<br>", $0D, $0A
	db "でんわりょうきんがいらないので、ゆっくりと<A HREF=\"../di/homepage.htm\">ホームページ</A>をみたいときは<B>オフライン</B>にしてから、みるようにしようね。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

POPC
