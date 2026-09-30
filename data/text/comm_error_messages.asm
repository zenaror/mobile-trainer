; data/text/comm_error_messages.asm
; bank 5C, $4000-$5150 (4432 bytes); pinned by layout.link
; error message strings, boot error strings, record table, triple lists, pointer tables

SECTION "data/text/comm_error_messages", ROMX

; ---- text $4000-$4F53 (3923 bytes) [PROBABLE] text: 36 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

CommErr_Msg_AdapterNotPlugged:: ; 5C:4000
String_5C_4000::
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $41, $83, $5F, $83, $76, $83, $5E, $82, $AA, $90, $B3, $82, $B5, $82, $AD, $0D, $8D, $B7, $82, $B5, $82, $B1, $82, $DC ; "モバイルアダプタが正しく<$0D>差しこま"
	db $82, $EA, $82, $C4, $82, $A2, $82, $DC, $82, $B9, $82, $F1, $81, $42, $81, $40, $0D, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7 ; "れていません。　<$0D>取扱説明書をごら"
	db $82, $F1, $82, $CC, $8F, $E3, $81, $41, $0D, $82, $B5, $82, $C1, $82, $A9, $82, $E8, $82, $C6, $8D, $B7, $82, $B5, $82, $B1, $82, $F1, $82, $C5, $89, $BA, $82, $B3, $0D ; "んの上、<$0D>しっかりと差しこんで下さ<$0D>"
	db $82, $A2, $81, $42, $00 ; "い。"

CommErr_Msg_DialFailedOrBusy:: ; 5C:4069
	db $93, $64, $98, $62, $82, $AA, $82, $A4, $82, $DC, $82, $AD, $82, $A9, $82, $AF, $82, $E7, $82, $EA, $82, $C8, $82, $A2, $0D, $82, $A9, $81, $41, $89, $F1, $90, $FC ; "電話がうまくかけられない<$0D>か、回線"
	db $82, $AA, $8D, $AC, $82, $F1, $82, $C5, $82, $A2, $82, $E9, $82, $BD, $82, $DF, $0D, $92, $CA, $90, $4D, $82, $C5, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $81, $42 ; "が混んでいるため<$0D>通信できません。"
	db $81, $40, $81, $40, $81, $40, $81, $40, $0D, $82, $B5, $82, $CE, $82, $E7, $82, $AD, $91, $D2, $82, $C1, $82, $C4, $92, $CA, $90, $4D, $82, $B5, $92, $BC, $82, $B5, $0D ; "　　　　<$0D>しばらく待って通信し直し<$0D>"
	db $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $82, $AD, $82, $ED, $82, $B5, $82, $AD, $82, $CD, $8E, $E6, $88, $B5, $0D, $90, $E0, $96, $BE, $8F, $91, $82, $F0 ; "て下さい。くわしくは取扱<$0D>説明書を"
	db $82, $B2, $82, $E7, $82, $F1, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "ごらん下さい。"

CommErr_Msg_LineBusy:: ; 5C:40FD
	db $89, $F1, $90, $FC, $82, $AA, $8D, $AC, $82, $F1, $82, $C5, $82, $A2, $82, $E9, $82, $BD, $82, $DF, $92, $CA, $90, $4D, $0D, $82, $C5, $82, $AB, $82, $DC, $82, $B9 ; "回線が混んでいるため通信<$0D>できませ"
	db $82, $F1, $81, $42, $82, $B5, $82, $CE, $82, $E7, $82, $AD, $91, $D2, $82, $C1, $0D, $82, $C4, $92, $CA, $90, $4D, $82, $B5, $92, $BC, $82, $B5, $82, $C4, $89, $BA ; "ん。しばらく待っ<$0D>て通信し直して下"
	db $82, $B3, $82, $A2, $81, $42, $00 ; "さい。"

CommErr_Msg_AdapterError:: ; 5C:4146
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $41, $83, $5F, $83, $76, $83, $5E, $82, $CC, $83, $47, $83, $89, $81, $5B, $0D, $82, $C5, $82, $B7, $81, $42, $82, $B5 ; "モバイルアダプタのエラー<$0D>です。し"
	db $82, $CE, $82, $E7, $82, $AD, $91, $D2, $82, $C1, $82, $C4, $92, $CA, $90, $4D, $0D, $82, $B5, $92, $BC, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42 ; "ばらく待って通信<$0D>し直して下さい。"
	db $92, $BC, $82, $E7, $82, $C8, $82, $A2, $0D, $8F, $EA, $8D, $87, $82, $CD, $81, $41, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $0D ; "直らない<$0D>場合は、取扱説明書をごら<$0D>"
	db $82, $F1, $82, $CC, $82, $A4, $82, $A6, $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $54, $83, $7C, $81, $5B, $83, $67, $0D, $83, $5A, $83, $93, $83, $5E, $81, $5B ; "んのうえモバイルサポート<$0D>センター"
	db $82, $D6, $82, $A8, $96, $E2, $82, $A2, $8D, $87, $82, $ED, $82, $B9, $89, $BA, $0D, $82, $B3, $82, $A2, $81, $42, $00 ; "へお問い合わせ下<$0D>さい。"

CommErr_Msg_GenericCommError:: ; 5C:41E3
	db $92, $CA, $90, $4D, $83, $47, $83, $89, $81, $5B, $82, $C5, $82, $B7, $81, $42, $81, $40, $81, $40, $81, $40, $81, $40, $0D, $82, $B5, $82, $CE, $82, $E7, $82, $AD ; "通信エラーです。　　　　<$0D>しばらく"
	db $91, $D2, $82, $C1, $82, $C4, $92, $CA, $90, $4D, $82, $B5, $92, $BC, $82, $B5, $0D, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $0D, $92, $BC, $82, $E7, $82, $C8 ; "待って通信し直し<$0D>て下さい。<$0D>直らな"
	db $82, $A2, $8F, $EA, $8D, $87, $82, $CD, $81, $41, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $0D, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $82, $CC, $82, $A4 ; "い場合は、取扱説明<$0D>書をごらんのう"
	db $82, $A6, $83, $82, $83, $6F, $83, $43, $83, $8B, $0D, $83, $54, $83, $7C, $81, $5B, $83, $67, $83, $5A, $83, $93, $83, $5E, $81, $5B, $82, $D6, $82, $A8, $96, $E2 ; "えモバイル<$0D>サポートセンターへお問"
	db $82, $A2, $0D, $8D, $87, $82, $ED, $82, $B9, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "い<$0D>合わせ下さい。"

CommErr_Msg_BadPasswordOrLoginId:: ; 5C:427A
	db $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $A9, $83, $8D, $83, $4F, $83, $43, $83, $93, $82, $68, $82, $63, $0D, $82, $C9, $82, $DC, $82, $BF, $82, $AA ; "パスワードかログインＩＤ<$0D>にまちが"
	db $82, $A2, $82, $AA, $82, $A0, $82, $E8, $82, $DC, $82, $B7, $81, $42, $83, $70, $0D, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $F0, $82, $B2, $8A, $6D, $94, $46 ; "いがあります。パ<$0D>スワードをご確認"
	db $82, $CC, $82, $A4, $82, $A6, $81, $41, $0D, $82, $B5, $82, $CE, $82, $E7, $82, $AD, $91, $D2, $82, $C1, $82, $C4, $82, $A9, $82, $E7, $92, $CA, $90, $4D, $82, $B5, $0D ; "のうえ、<$0D>しばらく待ってから通信し<$0D>"
	db $92, $BC, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $82, $AD, $82, $ED, $82, $B5, $82, $AD, $0D, $82, $CD, $8E, $E6, $88, $B5, $90, $E0 ; "直してください。くわしく<$0D>は取扱説"
	db $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $89, $BA, $82, $B3, $0D, $82, $A2, $81, $42, $00 ; "明書をごらん下さ<$0D>い。"

CommErr_Msg_Disconnected:: ; 5C:4315
	db $92, $CA, $90, $4D, $82, $AA, $90, $D8, $92, $66, $82, $B3, $82, $EA, $82, $DC, $82, $B5, $82, $BD, $81, $42, $8E, $E6, $0D, $88, $B5, $90, $E0, $96, $BE, $8F, $91 ; "通信が切断されました。取<$0D>扱説明書"
	db $82, $F0, $82, $B2, $82, $E7, $82, $F1, $82, $CC, $8F, $E3, $81, $41, $82, $B5, $0D, $82, $CE, $82, $E7, $82, $AD, $91, $D2, $82, $C1, $82, $C4, $92, $CA, $90, $4D ; "をごらんの上、し<$0D>ばらく待って通信"
	db $82, $B5, $92, $BC, $82, $B5, $82, $C4, $0D, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $00 ; "し直して<$0D>ください。"

CommErr_Msg_ServerCommError:: ; 5C:436B
	db $83, $54, $81, $5B, $83, $6F, $82, $CC, $92, $CA, $90, $4D, $83, $47, $83, $89, $81, $5B, $82, $C5, $82, $B7, $81, $42, $0D, $82, $B5, $82, $CE, $82, $E7, $82, $AD ; "サーバの通信エラーです。<$0D>しばらく"
	db $91, $D2, $82, $C1, $82, $C4, $90, $DA, $91, $B1, $82, $B5, $92, $BC, $82, $B5, $0D, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $82, $AD, $82, $ED, $82, $B5 ; "待って接続し直し<$0D>て下さい。くわし"
	db $82, $AD, $82, $CD, $8E, $E6, $88, $B5, $0D, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "くは取扱<$0D>説明書をごらん下さい。"

CommErr_Msg_AdapterRegistrationInvalid:: ; 5C:43CD
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $41, $83, $5F, $83, $76, $83, $5E, $82, $C9, $93, $6F, $98, $5E, $82, $B3, $0D, $82, $EA, $82, $BD, $8F, $EE, $95, $F1 ; "モバイルアダプタに登録さ<$0D>れた情報"
	db $82, $AA, $90, $B3, $82, $B5, $82, $AD, $82, $A0, $82, $E8, $82, $DC, $82, $B9, $0D, $82, $F1, $81, $42, $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $67, $83, $8C ; "が正しくありませ<$0D>ん。モバイルトレ"
	db $81, $5B, $83, $69, $81, $5B, $82, $C5, $0D, $8F, $89, $8A, $FA, $93, $6F, $98, $5E, $82, $F0, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "ーナーで<$0D>初期登録をして下さい。"

CommErr_Msg_ServerBusy:: ; 5C:442F
	db $83, $54, $81, $5B, $83, $6F, $82, $AA, $8D, $AC, $82, $F1, $82, $C5, $82, $A2, $82, $E9, $82, $BD, $82, $DF, $90, $DA, $0D, $91, $B1, $82, $C5, $82, $AB, $82, $DC ; "サーバが混んでいるため接<$0D>続できま"
	db $82, $B9, $82, $F1, $81, $42, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $0D, $82, $B5, $82, $CE, $82, $E7, $82, $AD, $91, $D2, $82, $C1, $82, $C4, $90, $DA ; "せん。　　　　　<$0D>しばらく待って接"
	db $91, $B1, $82, $B5, $92, $BC, $82, $B5, $0D, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $82, $AD, $82, $ED, $82, $B5, $82, $AD, $82, $CD, $8E, $E6, $88, $B5, $0D ; "続し直し<$0D>て下さい。くわしくは取扱<$0D>"
	db $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "説明書をごらん下さい。"

CommErr_Msg_BadDestinationAddress:: ; 5C:44AA
	db $82, $A0, $82, $C4, $90, $E6, $83, $81, $81, $5B, $83, $8B, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $C9, $82, $DC, $0D, $82, $BF, $82, $AA, $82, $A2, $82, $AA ; "あて先メールアドレスにま<$0D>ちがいが"
	db $82, $A0, $82, $E8, $82, $DC, $82, $B7, $81, $42, $90, $B3, $82, $B5, $82, $A2, $0D, $83, $81, $81, $5B, $83, $8B, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0 ; "あります。正しい<$0D>メールアドレスを"
	db $93, $FC, $97, $CD, $82, $B5, $82, $C4, $0D, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "入力して<$0D>下さい。"

CommErr_Msg_BadOwnMailAddress:: ; 5C:44FE
	db $83, $81, $81, $5B, $83, $8B, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $C9, $82, $DC, $82, $BF, $82, $AA, $82, $A2, $0D, $82, $AA, $82, $A0, $82, $E8, $82, $DC ; "メールアドレスにまちがい<$0D>がありま"
	db $82, $B7, $81, $42, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $0D, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7 ; "す。　　　　　　<$0D>取扱説明書をごら"
	db $82, $F1, $82, $CC, $8F, $E3, $81, $41, $0D, $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $67, $83, $8C, $81, $5B, $83, $69, $81, $5B, $82, $C5, $8F, $89, $8A, $FA, $0D ; "んの上、<$0D>モバイルトレーナーで初期<$0D>"
	db $93, $6F, $98, $5E, $82, $F0, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "登録をして下さい。"

CommErr_Msg_BadPasswordOrServerError:: ; 5C:4575
	db $93, $FC, $97, $CD, $82, $B5, $82, $BD, $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $C9, $82, $DC, $82, $BF, $0D, $82, $AA, $82, $A2, $82, $AA, $82, $A0 ; "入力したパスワードにまち<$0D>がいがあ"
	db $82, $E9, $82, $A9, $81, $41, $83, $54, $81, $5B, $83, $6F, $82, $CC, $83, $47, $0D, $83, $89, $81, $5B, $82, $C5, $82, $B7, $81, $42, $83, $70, $83, $58, $83, $8F ; "るか、サーバのエ<$0D>ラーです。パスワ"
	db $81, $5B, $83, $68, $82, $F0, $82, $B2, $0D, $8A, $6D, $94, $46, $82, $CC, $82, $A4, $82, $A6, $81, $41, $82, $B5, $82, $CE, $82, $E7, $82, $AD, $91, $D2, $82, $C1, $0D ; "ードをご<$0D>確認のうえ、しばらく待っ<$0D>"
	db $82, $C4, $82, $A9, $82, $E7, $92, $CA, $90, $4D, $82, $B5, $92, $BC, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $82, $B3, $0D, $82, $A2, $81, $42, $00 ; "てから通信し直してくださ<$0D>い。"

CommErr_Msg_ContentDownloadRetry:: ; 5C:45F7
	db $83, $52, $83, $93, $83, $65, $83, $93, $83, $63, $83, $5F, $83, $45, $83, $93, $83, $8D, $81, $5B, $83, $68, $82, $AA, $0D, $82, $C5, $82, $AB, $82, $DC, $82, $B9 ; "コンテンツダウンロードが<$0D>できませ"
	db $82, $F1, $81, $42, $82, $B5, $82, $CE, $82, $E7, $82, $AD, $91, $D2, $82, $C1, $0D, $82, $C4, $92, $CA, $90, $4D, $82, $B5, $92, $BC, $82, $B5, $82, $C4, $89, $BA ; "ん。しばらく待っ<$0D>て通信し直して下"
	db $82, $B3, $82, $A2, $81, $42, $92, $BC, $0D, $82, $E7, $82, $C8, $82, $A2, $8F, $EA, $8D, $87, $82, $CD, $81, $41, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $0D ; "さい。直<$0D>らない場合は、取扱説明書<$0D>"
	db $82, $F0, $82, $B2, $82, $E7, $82, $F1, $82, $CC, $82, $A4, $82, $A6, $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $54, $0D, $83, $7C, $81, $5B, $83, $67, $83, $5A ; "をごらんのうえモバイルサ<$0D>ポートセ"
	db $83, $93, $83, $5E, $81, $5B, $82, $D6, $82, $A8, $96, $E2, $82, $A2, $8D, $87, $0D, $82, $ED, $82, $B9, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "ンターへお問い合<$0D>わせ下さい。"

CommErr_Msg_Timeout:: ; 5C:469A
	db $83, $5E, $83, $43, $83, $80, $83, $41, $83, $45, $83, $67, $82, $C9, $82, $E6, $82, $E8, $92, $CA, $90, $4D, $82, $AA, $0D, $90, $D8, $92, $66, $82, $B3, $82, $EA ; "タイムアウトにより通信が<$0D>切断され"
	db $82, $DC, $82, $B5, $82, $BD, $81, $42, $92, $CA, $90, $4D, $82, $B5, $92, $BC, $0D, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $82, $AD, $82, $ED ; "ました。通信し直<$0D>して下さい。くわ"
	db $82, $B5, $82, $AD, $82, $CD, $8E, $E6, $0D, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "しくは取<$0D>扱説明書をごらん下さい。"

CommErr_Msg_FeePaymentOverdue:: ; 5C:46FE
	db $82, $B2, $97, $98, $97, $70, $97, $BF, $8B, $E0, $82, $CC, $82, $A8, $8E, $78, $95, $A5, $82, $A2, $82, $AA, $92, $78, $0D, $82, $EA, $82, $BD, $8F, $EA, $8D, $87 ; "ご利用料金のお支払いが遅<$0D>れた場合"
	db $82, $C9, $82, $CD, $81, $41, $82, $B2, $97, $98, $97, $70, $82, $AA, $82, $C5, $0D, $82, $AB, $82, $C8, $82, $AD, $82, $C8, $82, $E8, $82, $DC, $82, $B7, $81, $42 ; "には、ご利用がで<$0D>きなくなります。"
	db $82, $AD, $82, $ED, $82, $B5, $82, $AD, $0D, $82, $CD, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $89, $BA, $82, $B3, $0D ; "くわしく<$0D>は取扱説明書をごらん下さ<$0D>"
	db $82, $A2, $81, $42, $00 ; "い。"

CommErr_Msg_UnavailableCustomerReason:: ; 5C:4767
	db $82, $A8, $8B, $71, $97, $6C, $82, $CC, $93, $73, $8D, $87, $82, $C9, $82, $E6, $82, $E8, $81, $41, $97, $98, $97, $70, $0D, $82, $C5, $82, $AB, $82, $DC, $82, $B9 ; "お客様の都合により、利用<$0D>できませ"
	db $82, $F1, $81, $42, $82, $AD, $82, $ED, $82, $B5, $82, $AD, $82, $CD, $8E, $E6, $0D, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1 ; "ん。くわしくは取<$0D>扱説明書をごらん"
	db $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "下さい。"

CommErr_Msg_LineBusyOrServerError:: ; 5C:47B2
	db $89, $F1, $90, $FC, $82, $AA, $8D, $AC, $82, $F1, $82, $C5, $82, $A2, $82, $E9, $82, $A9, $81, $41, $83, $54, $81, $5B, $0D, $83, $6F, $82, $CC, $83, $47, $83, $89 ; "回線が混んでいるか、サー<$0D>バのエラ"
	db $81, $5B, $82, $CC, $82, $BD, $82, $DF, $92, $CA, $90, $4D, $82, $AA, $82, $C5, $0D, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $81, $42, $82, $B5, $82, $CE, $82, $E7 ; "ーのため通信がで<$0D>きません。しばら"
	db $82, $AD, $91, $D2, $82, $C1, $82, $C4, $0D, $92, $CA, $90, $4D, $82, $B5, $92, $BC, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $82, $AD, $82, $ED, $0D ; "く待って<$0D>通信し直して下さい。くわ<$0D>"
	db $82, $B5, $82, $AD, $82, $CD, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $0D, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "しくは取扱説明書をごらん<$0D>下さい。"

CommErr_Msg_FeeLimitExceeded:: ; 5C:4838
	db $82, $B2, $97, $98, $97, $70, $97, $BF, $8B, $E0, $82, $AA, $8F, $E3, $8C, $C0, $82, $F0, $82, $B1, $82, $A6, $82, $C4, $0D, $82, $A2, $82, $E9, $82, $BD, $82, $DF ; "ご利用料金が上限をこえて<$0D>いるため"
	db $81, $41, $8D, $A1, $8C, $8E, $82, $CD, $82, $B2, $97, $98, $97, $70, $82, $C5, $0D, $82, $AB, $82, $DC, $82, $B9, $82, $F1, $81, $42, $82, $AD, $82, $ED, $82, $B5 ; "、今月はご利用で<$0D>きません。くわし"
	db $82, $AD, $82, $CD, $8E, $E6, $88, $B5, $0D, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "くは取扱<$0D>説明書をごらん下さい。"

CommErr_Msg_Maintenance:: ; 5C:489A
	db $8C, $BB, $8D, $DD, $83, $81, $83, $93, $83, $65, $83, $69, $83, $93, $83, $58, $92, $86, $82, $CC, $82, $BD, $82, $DF, $0D, $97, $98, $97, $70, $82, $C5, $82, $AB ; "現在メンテナンス中のため<$0D>利用でき"
	db $82, $DC, $82, $B9, $82, $F1, $81, $42, $82, $B5, $82, $CE, $82, $E7, $82, $AD, $0D, $91, $D2, $82, $C1, $82, $C4, $82, $A8, $82, $A9, $82, $AF, $92, $BC, $82, $B5 ; "ません。しばらく<$0D>待っておかけ直し"
	db $89, $BA, $82, $B3, $82, $A2, $81, $42, $0D, $82, $AD, $82, $ED, $82, $B5, $82, $AD, $82, $CD, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $0D ; "下さい。<$0D>くわしくは取扱説明書をご<$0D>"
	db $82, $E7, $82, $F1, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "らん下さい。"

CommErr_Msg_ContentDownloadFailed:: ; 5C:490B
	db $83, $52, $83, $93, $83, $65, $83, $93, $83, $63, $83, $5F, $83, $45, $83, $93, $83, $8D, $81, $5B, $83, $68, $82, $AA, $0D, $82, $C5, $82, $AB, $82, $DC, $82, $B9 ; "コンテンツダウンロードが<$0D>できませ"
	db $82, $F1, $81, $42, $82, $AD, $82, $ED, $82, $B5, $82, $AD, $82, $CD, $8E, $E6, $0D, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1 ; "ん。くわしくは取<$0D>扱説明書をごらん"
	db $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "下さい。"

CommErr_Msg_BadLoginId:: ; 5C:4956
	db $83, $8D, $83, $4F, $83, $43, $83, $93, $82, $68, $82, $63, $82, $C9, $82, $DC, $82, $BF, $82, $AA, $82, $A2, $82, $AA, $0D, $82, $A0, $82, $E8, $82, $DC, $82, $B7 ; "ログインＩＤにまちがいが<$0D>あります"
	db $81, $42, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $0D, $82, $E7, $82, $F1, $82, $CC, $8F, $E3, $81, $41, $83, $8D, $83, $4F, $83, $43 ; "。取扱説明書をご<$0D>らんの上、ログイ"
	db $83, $93, $82, $68, $82, $63, $82, $F0, $0D, $93, $6F, $98, $5E, $82, $B5, $92, $BC, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "ンＩＤを<$0D>登録し直して下さい。"

CommErr_Msg_LoginIdSuspended:: ; 5C:49B6
	db $82, $B1, $82, $CC, $83, $8D, $83, $4F, $83, $43, $83, $93, $82, $68, $82, $63, $82, $CD, $97, $98, $97, $70, $92, $86, $0D, $92, $66, $82, $CC, $8E, $E8, $91, $B1 ; "このログインＩＤは利用中<$0D>断の手続"
	db $82, $AB, $82, $AA, $82, $B3, $82, $EA, $82, $C4, $82, $A2, $82, $E9, $82, $BD, $0D, $82, $DF, $81, $41, $97, $98, $97, $70, $82, $C5, $82, $AB, $82, $DC, $82, $B9 ; "きがされているた<$0D>め、利用できませ"
	db $82, $F1, $81, $42, $81, $40, $81, $40, $0D, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $82, $CC, $8F, $E3, $81, $41, $0D ; "ん。　　<$0D>取扱説明書をごらんの上、<$0D>"
	db $82, $63, $82, $63, $82, $68, $83, $4A, $83, $58, $83, $5E, $83, $7D, $83, $54, $81, $5B, $83, $72, $83, $58, $83, $5A, $0D, $83, $93, $83, $5E, $81, $5B, $82, $C9 ; "ＤＤＩカスタマサービスセ<$0D>ンターに"
	db $82, $A8, $96, $E2, $82, $A2, $8D, $87, $82, $ED, $82, $B9, $89, $BA, $82, $B3, $0D, $82, $A2, $81, $42, $00 ; "お問い合わせ下さ<$0D>い。"

CommErr_Msg_LoginIdCancelled:: ; 5C:4A51
	db $82, $B1, $82, $CC, $83, $8D, $83, $4F, $83, $43, $83, $93, $82, $68, $82, $63, $82, $CD, $89, $F0, $96, $F1, $82, $B3, $0D, $82, $EA, $82, $C4, $82, $A2, $82, $E9 ; "このログインＩＤは解約さ<$0D>れている"
	db $82, $BD, $82, $DF, $81, $41, $97, $98, $97, $70, $82, $C5, $82, $AB, $82, $DC, $0D, $82, $B9, $82, $F1, $81, $42, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91 ; "ため、利用できま<$0D>せん。取扱説明書"
	db $82, $F0, $82, $B2, $82, $E7, $82, $F1, $0D, $82, $CC, $8F, $E3, $81, $41, $82, $63, $82, $63, $82, $68, $83, $4A, $83, $58, $83, $5E, $83, $7D, $83, $54, $81, $5B, $0D ; "をごらん<$0D>の上、ＤＤＩカスタマサー<$0D>"
	db $83, $72, $83, $58, $83, $5A, $83, $93, $83, $5E, $81, $5B, $82, $C9, $82, $A8, $96, $E2, $82, $A2, $8D, $87, $82, $ED, $0D, $82, $B9, $89, $BA, $82, $B3, $82, $A2 ; "ビスセンターにお問い合わ<$0D>せ下さい"
	db $81, $42, $00 ; "。"

CommErr_Msg_LoginIdUnavailable:: ; 5C:4AD9
	db $82, $B1, $82, $CC, $83, $8D, $83, $4F, $83, $43, $83, $93, $82, $68, $82, $63, $82, $CD, $8C, $BB, $8D, $DD, $97, $98, $0D, $97, $98, $97, $70, $82, $C5, $82, $AB ; "このログインＩＤは現在利<$0D>利用でき"
	db $82, $DC, $82, $B9, $82, $F1, $81, $42, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $0D, $8F, $91, $82, $F0, $82, $B2, $82, $E7, $82, $F1, $82, $CC, $8F, $E3, $81, $41 ; "ません。取扱説明<$0D>書をごらんの上、"
	db $82, $63, $82, $63, $82, $68, $83, $4A, $0D, $83, $58, $83, $5E, $83, $7D, $83, $54, $81, $5B, $83, $72, $83, $58, $83, $5A, $83, $93, $83, $5E, $81, $5B, $82, $C9, $0D ; "ＤＤＩカ<$0D>スタマサービスセンターに<$0D>"
	db $82, $A8, $96, $E2, $82, $A2, $8D, $87, $82, $ED, $82, $B9, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "お問い合わせ下さい。"

CommErr_Msg_NewPasswordEmpty:: ; 5C:4B52
	db $90, $56, $82, $B5, $82, $A2, $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $AA, $93, $FC, $97, $CD, $82, $B3, $0D, $82, $EA, $82, $C4, $82, $A2, $82, $DC ; "新しいパスワードが入力さ<$0D>れていま"
	db $82, $B9, $82, $F1, $81, $42, $81, $40, $81, $40, $81, $40, $81, $40, $81, $40, $0D, $83, $41, $83, $8B, $83, $74, $83, $40, $83, $78, $83, $62, $83, $67, $82, $C6 ; "せん。　　　　　<$0D>アルファベットと"
	db $90, $94, $8E, $9A, $82, $F0, $91, $67, $0D, $82, $DD, $8D, $87, $82, $ED, $82, $B9, $82, $BD, $82, $53, $81, $60, $82, $57, $95, $B6, $8E, $9A, $82, $F0, $93, $FC, $0D ; "数字を組<$0D>み合わせた４～８文字を入<$0D>"
	db $97, $CD, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "力して下さい。"

CommErr_Msg_NewPasswordLength:: ; 5C:4BC5
	db $90, $56, $82, $B5, $82, $A2, $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $AA, $92, $B7, $82, $B7, $82, $AC, $0D, $82, $E9, $82, $A9, $81, $41, $92, $5A ; "新しいパスワードが長すぎ<$0D>るか、短"
	db $82, $B7, $82, $AC, $82, $DC, $82, $B7, $81, $42, $81, $40, $81, $40, $81, $40, $0D, $83, $41, $83, $8B, $83, $74, $83, $40, $83, $78, $83, $62, $83, $67, $82, $C6 ; "すぎます。　　　<$0D>アルファベットと"
	db $90, $94, $8E, $9A, $82, $F0, $91, $67, $0D, $82, $DD, $8D, $87, $82, $ED, $82, $B9, $82, $BD, $82, $53, $81, $60, $82, $57, $95, $B6, $8E, $9A, $82, $F0, $93, $FC, $0D ; "数字を組<$0D>み合わせた４～８文字を入<$0D>"
	db $97, $CD, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "力して下さい。"

CommErr_Msg_NewPasswordBadChars:: ; 5C:4C38
	db $82, $B1, $82, $CC, $90, $56, $82, $B5, $82, $A2, $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $C9, $82, $CD, $0D, $8E, $67, $97, $70, $82, $C5, $82, $AB ; "この新しいパスワードには<$0D>使用でき"
	db $82, $C8, $82, $A2, $95, $B6, $8E, $9A, $82, $AA, $93, $FC, $82, $C1, $82, $C4, $0D, $82, $A2, $82, $DC, $82, $B7, $81, $42, $83, $41, $83, $8B, $83, $74, $83, $40 ; "ない文字が入って<$0D>います。アルファ"
	db $83, $78, $83, $62, $83, $67, $82, $C6, $0D, $90, $94, $8E, $9A, $82, $F0, $91, $67, $82, $DD, $8D, $87, $82, $ED, $82, $B9, $82, $BD, $82, $53, $81, $60, $82, $57, $0D ; "ベットと<$0D>数字を組み合わせた４～８<$0D>"
	db $95, $B6, $8E, $9A, $82, $F0, $93, $FC, $97, $CD, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "文字を入力して下さい。"

CommErr_Msg_NewPasswordNeedsMix:: ; 5C:4CB3
	db $82, $B1, $82, $CC, $90, $56, $82, $B5, $82, $A2, $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $CD, $83, $41, $0D, $83, $8B, $83, $74, $83, $40, $83, $78 ; "この新しいパスワードはア<$0D>ルファベ"
	db $83, $62, $83, $67, $82, $BE, $82, $AF, $82, $A9, $81, $41, $90, $94, $8E, $9A, $0D, $82, $BE, $82, $AF, $82, $C5, $82, $B7, $81, $42, $81, $40, $81, $40, $81, $40 ; "ットだけか、数字<$0D>だけです。　　　"
	db $81, $40, $81, $40, $81, $40, $81, $40, $0D, $83, $41, $83, $8B, $83, $74, $83, $40, $83, $78, $83, $62, $83, $67, $82, $C6, $90, $94, $8E, $9A, $82, $F0, $91, $67, $0D ; "　　　　<$0D>アルファベットと数字を組<$0D>"
	db $82, $DD, $8D, $87, $82, $ED, $82, $B9, $82, $BD, $82, $53, $81, $60, $82, $57, $95, $B6, $8E, $9A, $82, $F0, $93, $FC, $0D, $97, $CD, $82, $B5, $82, $C4, $89, $BA ; "み合わせた４～８文字を入<$0D>力して下"
	db $82, $B3, $82, $A2, $81, $42, $00 ; "さい。"

CommErr_Msg_NewPasswordSameAsOld:: ; 5C:4D3F
	db $90, $56, $82, $B5, $82, $A2, $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $C6, $8C, $C3, $82, $A2, $83, $70, $0D, $83, $58, $83, $8F, $81, $5B, $83, $68 ; "新しいパスワードと古いパ<$0D>スワード"
	db $82, $AA, $93, $AF, $82, $B6, $82, $C5, $82, $B7, $81, $42, $81, $40, $81, $40, $0D, $82, $E0, $82, $A4, $82, $A2, $82, $BF, $82, $C7, $82, $BF, $82, $AA, $82, $A4 ; "が同じです。　　<$0D>もういちどちがう"
	db $83, $70, $83, $58, $83, $8F, $81, $5B, $0D, $83, $68, $82, $F0, $83, $41, $83, $8B, $83, $74, $83, $40, $83, $78, $83, $62, $83, $67, $82, $C6, $90, $94, $8E, $9A, $0D ; "パスワー<$0D>ドをアルファベットと数字<$0D>"
	db $82, $F0, $91, $67, $82, $DD, $8D, $87, $82, $ED, $82, $B9, $82, $BD, $82, $53, $81, $60, $82, $57, $95, $B6, $8E, $9A, $0D, $82, $C5, $93, $FC, $97, $CD, $82, $B5 ; "を組み合わせた４～８文字<$0D>で入力し"
	db $82, $C4, $89, $BA, $82, $B3, $82, $A2, $81, $42, $00 ; "て下さい。"

CommErr_Msg_RegistrationPending:: ; 5C:4DCF
	db $93, $6F, $98, $5E, $8F, $91, $82, $CC, $8F, $88, $97, $9D, $82, $AA, $8A, $AE, $97, $B9, $82, $B5, $82, $C4, $82, $A2, $0D, $82, $C8, $82, $A2, $82, $E6, $82, $A4 ; "登録書の処理が完了してい<$0D>ないよう"
	db $82, $C5, $82, $B7, $81, $42, $8F, $88, $97, $9D, $82, $AA, $8A, $AE, $97, $B9, $0D, $82, $B7, $82, $E9, $82, $DC, $82, $C5, $82, $B5, $82, $CE, $82, $E7, $82, $AD ; "です。処理が完了<$0D>するまでしばらく"
	db $82, $A8, $91, $D2, $82, $BF, $89, $BA, $0D, $82, $B3, $82, $A2, $81, $42, $00 ; "お待ち下<$0D>さい。"

CommErr_Boot_AdapterNotPlugged:: ; 5C:4E21
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $41, $83, $5F, $83, $76, $83, $5E, $82, $AA, $90, $B3, $82, $B5, $82, $AD, $0D, $8D, $B7, $82, $B5, $82, $B1, $82, $DC ; "モバイルアダプタが正しく<$0D>差しこま"
	db $82, $EA, $82, $C4, $82, $A2, $82, $DC, $82, $B9, $82, $F1, $81, $42, $00 ; "れていません。"

CommErr_Boot_WrongPassword:: ; 5C:4E51
	db $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $C9, $82, $DC, $82, $BF, $82, $AA, $82, $A2, $82, $AA, $82, $A0, $0D, $82, $E8, $82, $DC, $82, $B7, $81, $42 ; "パスワードにまちがいがあ<$0D>ります。"
	db $90, $B3, $82, $B5, $82, $A2, $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $0D, $82, $F0, $93, $FC, $97, $CD, $82, $B5, $82, $C4, $89, $BA, $82, $B3, $82, $A2 ; "正しいパスワード<$0D>を入力して下さい"
	db $81, $42, $00 ; "。"

CommErr_Boot_AdapterConfigError:: ; 5C:4E96
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $41, $83, $5F, $83, $76, $83, $5E, $82, $CC, $93, $6F, $98, $5E, $8F, $EE, $0D, $95, $F1, $83, $47, $83, $89, $81, $5B ; "モバイルアダプタの登録情<$0D>報エラー"
	db $82, $C5, $82, $B7, $81, $42, $83, $66, $81, $5B, $83, $5E, $82, $F0, $8F, $89, $0D, $8A, $FA, $89, $BB, $82, $B5, $82, $DC, $82, $B7, $81, $42, $00 ; "です。データを初<$0D>期化します。"

CommErr_Boot_SaveDataErrorA:: ; 5C:4ED5
	db $83, $4A, $81, $5B, $83, $67, $83, $8A, $83, $62, $83, $57, $82, $CC, $83, $5A, $81, $5B, $83, $75, $83, $66, $81, $5B, $0D, $83, $5E, $83, $47, $83, $89, $81, $5B ; "カートリッジのセーブデー<$0D>タエラー"
	db $82, $C5, $82, $B7, $81, $42, $83, $66, $81, $5B, $83, $5E, $82, $F0, $8F, $89, $0D, $8A, $FA, $89, $BB, $82, $B5, $82, $DC, $82, $B7, $81, $42, $00 ; "です。データを初<$0D>期化します。"

CommErr_Boot_SaveDataErrorB:: ; 5C:4F14
	db $83, $4A, $81, $5B, $83, $67, $83, $8A, $83, $62, $83, $57, $82, $CC, $83, $5A, $81, $5B, $83, $75, $83, $66, $81, $5B, $0D, $83, $5E, $83, $47, $83, $89, $81, $5B ; "カートリッジのセーブデー<$0D>タエラー"
	db $82, $C5, $82, $B7, $81, $42, $83, $66, $81, $5B, $83, $5E, $82, $F0, $8F, $89, $0D, $8A, $FA, $89, $BB, $82, $B5, $82, $DC, $82, $B7, $81, $42, $00 ; "です。データを初<$0D>期化します。"

; ---- data $4F53-$4FA8 (85 bytes) [CONFIRMED] 21 records of 4 bytes [id ; mode ; dw list pointer] terminated by $FF at 4FA7 (ids 10-17, 20-26, 30-33, 40, F0), searched linearly by the executed code at 5C:527A-5289 (ld hl,$4F53 ; ld a,[hli] ; cp $FF ; cp b ; inc hl x3 ; jr), b = [C196]; mode = second byte (dec a ; jr nz at 528B-528D: mode 1 takes the path at 5C:528F, any other mode the path at 5C:52EF (each loads a different tilemap first)), dw = list of triples read at 5C:5302-531C; the id/mode/pointer bytes are read data (dataaccess, 3/18 scenarios) and every pointer lands exactly on a list start

CommErr_RecordTable:: ; 5C:4F53
Table_5C_4F53::
	db $10, $01, $A8, $4F, $11, $01, $AE, $4F, $12, $01, $B4, $4F, $13, $01, $BA, $4F
	db $14, $01, $C0, $4F, $15, $01, $C6, $4F, $16, $01, $D5, $4F, $17, $01, $DB, $4F
	db $20, $01, $E1, $4F, $21, $01, $E7, $4F, $22, $01, $ED, $4F, $23, $01, $F3, $4F
	db $24, $01, $F9, $4F, $25, $01, $FF, $4F, $26, $01, $05, $50, $30, $01, $0B, $50
	db $31, $01, $3E, $50, $32, $01, $4D, $50, $33, $01, $80, $50, $40, $01, $B9, $50
	db $F0, $02, $F5, $50, $FF

; ---- data $4FA8-$4FAE (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_10:: ; 5C:4FA8
Data_5C_4FA8::
	db $00, $00, $01, $FF, $FF, $01

; ---- data $4FAE-$4FB4 (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_11:: ; 5C:4FAE
Data_5C_4FAE::
	db $00, $00, $02, $FF, $FF, $02

; ---- data $4FB4-$4FBA (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_12:: ; 5C:4FB4
Data_5C_4FB4::
	db $00, $00, $03, $FF, $FF, $03

; ---- data $4FBA-$4FC0 (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_13:: ; 5C:4FBA
Data_5C_4FBA::
	db $00, $00, $02, $FF, $FF, $02

; ---- data $4FC0-$4FC6 (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_14:: ; 5C:4FC0
Data_5C_4FC0::
	db $00, $00, $09, $FF, $FF, $09

; ---- data $4FC6-$4FD5 (15 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_15:: ; 5C:4FC6
Data_5C_4FC6::
	db $00, $00, $04, $00, $01, $04, $00, $02, $04, $00, $03, $03, $FF, $FF, $04

; ---- data $4FD5-$4FDB (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_16:: ; 5C:4FD5
Data_5C_4FD5::
	db $00, $00, $05, $FF, $FF, $05

; ---- data $4FDB-$4FE1 (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_17:: ; 5C:4FDB
Data_5C_4FDB::
	db $00, $00, $05, $FF, $FF, $05

; ---- data $4FE1-$4FE7 (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_20:: ; 5C:4FE1
Data_5C_4FE1::
	db $00, $00, $05, $FF, $FF, $05

; ---- data $4FE7-$4FED (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_21:: ; 5C:4FE7
Data_5C_4FE7::
	db $00, $00, $05, $FF, $FF, $05

; ---- data $4FED-$4FF3 (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_22:: ; 5C:4FED
Data_5C_4FED::
	db $00, $00, $06, $FF, $FF, $06

; ---- data $4FF3-$4FF9 (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_23:: ; 5C:4FF3
Data_5C_4FF3::
	db $00, $00, $07, $FF, $FF, $07

; ---- data $4FF9-$4FFF (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_24:: ; 5C:4FF9
Data_5C_4FF9::
	db $00, $00, $12, $FF, $FF, $12

; ---- data $4FFF-$5005 (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_25:: ; 5C:4FFF
Data_5C_4FFF::
	db $00, $00, $09, $FF, $FF, $09

; ---- data $5005-$500B (6 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_26:: ; 5C:5005
Data_5C_5005::
	db $00, $00, $0F, $FF, $FF, $0F

; ---- data $500B-$503E (51 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_30:: ; 5C:500B
Data_5C_500B::
	db $00, $00, $05, $02, $21, $12, $04, $21, $12, $04, $50, $0B, $04, $51, $12, $04
	db $52, $12, $05, $00, $05, $05, $01, $05, $05, $02, $05, $05, $03, $05, $05, $04
	db $05, $05, $50, $0B, $05, $51, $0B, $05, $52, $12, $05, $53, $0B, $05, $54, $12
	db $FF, $FF, $12

; ---- data $503E-$504D (15 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_31:: ; 5C:503E
Data_5C_503E::
	db $00, $00, $05, $00, $02, $0C, $00, $03, $0D, $00, $04, $05, $FF, $FF, $12

; ---- data $504D-$5080 (51 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_32:: ; 5C:504D
Data_5C_504D::
	db $03, $00, $05, $03, $01, $05, $03, $02, $05, $04, $00, $05, $04, $01, $05, $04
	db $03, $0E, $04, $04, $0E, $04, $05, $05, $04, $06, $05, $04, $07, $05, $04, $08
	db $0F, $05, $00, $08, $05, $01, $05, $05, $02, $08, $05, $03, $0A, $05, $04, $08
	db $FF, $FF, $08

; ---- data $5080-$50B9 (57 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_33:: ; 5C:5080
Data_5C_5080::
	db $01, $01, $10, $01, $02, $11, $01, $03, $13, $01, $04, $15, $01, $05, $15, $01
	db $06, $14, $02, $01, $1F, $02, $02, $05, $02, $03, $15, $02, $04, $05, $02, $05
	db $08, $02, $06, $15, $02, $99, $11, $03, $01, $08, $04, $01, $08, $04, $02, $08
	db $04, $03, $08, $04, $04, $08, $FF, $FF, $08

; ---- data $50B9-$50F5 (60 bytes) [PROBABLE] list of 3-byte triples [d ; e ; message index] ended by the default triple [$FF ; $FF ; index]: searched at 5C:5302-531C for d=[C197], e=[C198] (cp d ; jr nz ; ld a,[hl] ; cp e ; step 3), the index selects the string pointer in the table 5C:5104 (ld hl,$5104 ; add a,a); pointed to by the record table 5C:4F53, the 20 lists tile 4FA8-50F5 exactly

CommErr_Triples_40:: ; 5C:50B9
Data_5C_50B9::
	db $00, $10, $15, $00, $20, $16, $00, $21, $16, $00, $30, $17, $00, $31, $18, $00
	db $32, $18, $00, $40, $0D, $00, $41, $0D, $00, $42, $0D, $00, $43, $0D, $00, $44
	db $0D, $00, $50, $19, $10, $01, $1A, $10, $02, $1B, $10, $03, $1C, $10, $04, $1D
	db $10, $05, $1E, $80, $00, $14, $90, $00, $08, $FF, $FF, $08

; ---- data $50F5-$5104 (15 bytes) [PROBABLE] 5 triples [00 00 21][00 10 22][01 00 23][01 10 24][01 11 25]: list of the mode-2 record (id $F0) of the table 5C:4F53 (pointer 50F5), same triple format without a $FF terminator; ends at the message-pointer table 5C:5104

CommErr_Triples_F0:: ; 5C:50F5
Data_5C_50F5::
	db $00, $00, $21, $00, $10, $22, $01, $00, $23, $01, $10, $24, $01, $11, $25

; ---- ptrtable $5104-$5144 (64 bytes) [PROBABLE] 32 x dw string pointers (slots 0-31; the same index space continues through slot 32 = 5C:5144 and slots 33-37 = the table 5C:5146, see there) indexed by the message index from the lists (ld hl,$5104 ; add a,a ; add a,l ... ld a,[hli] ; ld h,[hl] ; ld l,a at 5C:5320-532C); entry 0 is $0000 (null, kept numeric), entries 1-31 = 4000..4DCF strings (100% of targets on string starts)

CommErr_MessagePointers:: ; 5C:5104
Table_5C_5104::
	dw $0000
	dw CommErr_Msg_AdapterNotPlugged
	dw CommErr_Msg_DialFailedOrBusy
	dw CommErr_Msg_LineBusy
	dw CommErr_Msg_AdapterError
	dw CommErr_Msg_GenericCommError
	dw CommErr_Msg_BadPasswordOrLoginId
	dw CommErr_Msg_Disconnected
	dw CommErr_Msg_ServerCommError
	dw CommErr_Msg_AdapterRegistrationInvalid
	dw CommErr_Msg_ServerBusy
	dw CommErr_Msg_BadDestinationAddress
	dw CommErr_Msg_BadOwnMailAddress
	dw CommErr_Msg_BadPasswordOrServerError
	dw CommErr_Msg_ContentDownloadRetry
	dw CommErr_Msg_Timeout
	dw CommErr_Msg_FeePaymentOverdue
	dw CommErr_Msg_UnavailableCustomerReason
	dw CommErr_Msg_LineBusyOrServerError
	dw CommErr_Msg_FeeLimitExceeded
	dw CommErr_Msg_Maintenance
	dw CommErr_Msg_ContentDownloadFailed
	dw CommErr_Msg_BadLoginId
	dw CommErr_Msg_LoginIdSuspended
	dw CommErr_Msg_LoginIdCancelled
	dw CommErr_Msg_LoginIdUnavailable
	dw CommErr_Msg_NewPasswordEmpty
	dw CommErr_Msg_NewPasswordLength
	dw CommErr_Msg_NewPasswordBadChars
	dw CommErr_Msg_NewPasswordNeedsMix
	dw CommErr_Msg_NewPasswordSameAsOld
	dw CommErr_Msg_RegistrationPending

; ---- words $5144-$5146 (2 bytes) [PROBABLE] slot 32 of the message-pointer index space (5C:5104 + 2*32 = 5144): the word $0020 is not a string pointer (below $4000) and no triple list selects index 32 (verifier: the lists of the records 5C:4F53 use indices 1-31 and, for the mode-2 record $F0 at 50F5, 33-37); meaning of the value $0020 unknown

Data_5C_5144:: ; 5C:5144
	dw Rst_20

; ---- ptrtable $5146-$5150 (10 bytes) [PROBABLE] little-endian word table, 5 entries, monotone=1.00, 100% of targets on string start/after NUL, targets $4E21..$4F14 [verifier: this is the continuation of the message pointer index space of 5C:5104 (5104 + 2*33 = 5146): the mode-2 record $F0 of the table 5C:4F53 has the list 5C:50F5 = 5 triples with message indices $21..$25 = slots 33-37 = exactly these 5 words]

CommErr_MessagePointers_Boot:: ; 5C:5146
Table_5C_5146::
	dw CommErr_Boot_AdapterNotPlugged
	dw CommErr_Boot_WrongPassword
	dw CommErr_Boot_AdapterConfigError
	dw CommErr_Boot_SaveDataErrorA
	dw CommErr_Boot_SaveDataErrorB
