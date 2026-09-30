; data/html/pages_cdmaone_to_www.asm
; bank 3D, $48D1-$518D (2236 bytes); pinned by layout.link
; HTML store records cdmaone.htm .. www.htm (contains website.htm and www.htm twice)

SECTION "data/html/pages_cdmaone_to_www", ROMX

PUSHC sjis

; ---- text $48D1-$518D (2236 bytes) [CONFIRMED] text: 13 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated) (part of region $4000-$518D)
	db "cdmaone.htm", 0
	dw $0109 ; body length
	db "<HTML><TITLE>ｃｄｍａＯｎｅ</TITLE><B>【しーでぃーえむえーわん】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "でんわきのしゅるいの１つで、<b>ＣＤＭＡ</b>ほうしきのでんわきのことだよ。<br>", $0D, $0A
	db "きいろい<A HREF=\"../di/ma.htm\">モバイルアダプタＧＢ</A>は<b>ｃｄｍａＯｎｅ</b>のでんわきようだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "user.htm", 0
	dw $00CB ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ユーザー</TITLE>", $0D, $0A
	db "<B>【ゆーざー】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "なにかをつかうひとのことを、<B>ユーザー</B>というんだ。<br>", $0D, $0A
	db "このカートリッジのばあいは、このせつめいをみてるきみのことだね。<br>", $0D, $0A
	db $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "website.htm", 0
	dw $016C ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>サイト/ウェブサイト</TITLE>", $0D, $0A
	db "<B>【さいと】<BR>", $0D, $0A
	db "【うぇぶさいと】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/homepage.htm\">ホームページ</A>がはいっている、<A HREF=\"../di/connect.htm\">せつぞく</A>さきにあるコンピュータのことを<B>ウェブサイト</B>というんだけど、さいきんでは、<A HREF=\"../di/homepage.htm\">ホームページ</A>のことをこうよぶことがおおいんだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "www.htm", 0
	dw $01E3 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ＷＷＷ/Ｗｅｂ</TITLE>", $0D, $0A
	db "<B>【ワールドワイドウェブ】<br>", $0D, $0A
	db "【わーるどわいどうぇぶ】<br>", $0D, $0A
	db "【ウェブ】<br>", $0D, $0A
	db "【うぇぶ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>につながっていれば、せかいじゅうのじょうほうを、<A HREF=\"../di/homepage.htm\">ホームページ</A>でみられるよね。<BR>", $0D, $0A
	db "そのしくみのことを、<B>ワールド・ワイド・ウェブ</B>っていうんだ。<BR>", $0D, $0A
	db "せかいじゅうのコンピュータが、クモのす（<B>ウェブ</B>）のようにつながっているからついたなまえだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "website.htm", 0
	dw $016C ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>サイト/ウェブサイト</TITLE>", $0D, $0A
	db "<B>【さいと】<BR>", $0D, $0A
	db "【うぇぶさいと】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/homepage.htm\">ホームページ</A>がはいっている、<A HREF=\"../di/connect.htm\">せつぞく</A>さきにあるコンピュータのことを<B>ウェブサイト</B>というんだけど、さいきんでは、<A HREF=\"../di/homepage.htm\">ホームページ</A>のことをこうよぶことがおおいんだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0

	db "www.htm", 0
	dw $01E3 ; body length
	db "<HTML>", $0D, $0A
	db "<TITLE>ＷＷＷ/Ｗｅｂ</TITLE>", $0D, $0A
	db "<B>【ワールドワイドウェブ】<br>", $0D, $0A
	db "【わーるどわいどうぇぶ】<br>", $0D, $0A
	db "【ウェブ】<br>", $0D, $0A
	db "【うぇぶ】</B>", $0D, $0A
	db "<HR>", $0D, $0A
	db "<A HREF=\"../di/internet.htm\">インターネット</A>につながっていれば、せかいじゅうのじょうほうを、<A HREF=\"../di/homepage.htm\">ホームページ</A>でみられるよね。<BR>", $0D, $0A
	db "そのしくみのことを、<B>ワールド・ワイド・ウェブ</B>っていうんだ。<BR>", $0D, $0A
	db "せかいじゅうのコンピュータが、クモのす（<B>ウェブ</B>）のようにつながっているからついたなまえだよ。", $0D, $0A
	db "</HTML>", $0D, $0A, 0
	db 0

POPC
