; data/text/comm_error_messages.asm
; bank 5C, $4000-$5150 (4432 bytes); pinned by layout.link
; error message strings, boot error strings, record table, triple lists, pointer tables

SECTION "data/text/comm_error_messages", ROMX

PUSHC sjis

; ---- text $4000-$4F53 (3923 bytes) [PROBABLE] text: 36 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

CommErr_Msg_AdapterNotPlugged:: ; 5C:4000
String_5C_4000::
	; English UI slot; retain fixed boundaries for following messages.
	db "The Mobile Adapter", $0D, "is no"
	db "t connected", $0D, "properly.", $0D, "Pl"
	db "ease check the", $0D, "manual.", 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
	db 0, 0, 0, 0, 0, 0, 0, 0, 0

CommErr_Msg_DialFailedOrBusy:: ; 5C:4069
	db "電話がうまくかけられない", $0D
	db "か、回線が混んでいるため", $0D
	db "通信できません。　　　　", $0D
	db "しばらく待って通信し直し", $0D
	db "て下さい。くわしくは取扱", $0D
	db "説明書をごらん下さい。", 0

CommErr_Msg_LineBusy:: ; 5C:40FD
	db "回線が混んでいるため通信", $0D
	db "できません。しばらく待っ", $0D
	db "て通信し直して下さい。", 0

CommErr_Msg_AdapterError:: ; 5C:4146
	db "モバイルアダプタのエラー", $0D
	db "です。しばらく待って通信", $0D
	db "し直して下さい。直らない", $0D
	db "場合は、取扱説明書をごら", $0D
	db "んのうえモバイルサポート", $0D
	db "センターへお問い合わせ下", $0D
	db "さい。", 0

CommErr_Msg_GenericCommError:: ; 5C:41E3
	db "通信エラーです。　　　　", $0D
	db "しばらく待って通信し直し", $0D
	db "て下さい。", $0D
	db "直らない場合は、取扱説明", $0D
	db "書をごらんのうえモバイル", $0D
	db "サポートセンターへお問い", $0D
	db "合わせ下さい。", 0

CommErr_Msg_BadPasswordOrLoginId:: ; 5C:427A
	db "パスワードかログインＩＤ", $0D
	db "にまちがいがあります。パ", $0D
	db "スワードをご確認のうえ、", $0D
	db "しばらく待ってから通信し", $0D
	db "直してください。くわしく", $0D
	db "は取扱説明書をごらん下さ", $0D
	db "い。", 0

CommErr_Msg_Disconnected:: ; 5C:4315
	db "通信が切断されました。取", $0D
	db "扱説明書をごらんの上、し", $0D
	db "ばらく待って通信し直して", $0D
	db "ください。", 0

CommErr_Msg_ServerCommError:: ; 5C:436B
	db "サーバの通信エラーです。", $0D
	db "しばらく待って接続し直し", $0D
	db "て下さい。くわしくは取扱", $0D
	db "説明書をごらん下さい。", 0

CommErr_Msg_AdapterRegistrationInvalid:: ; 5C:43CD
	db "モバイルアダプタに登録さ", $0D
	db "れた情報が正しくありませ", $0D
	db "ん。モバイルトレーナーで", $0D
	db "初期登録をして下さい。", 0

CommErr_Msg_ServerBusy:: ; 5C:442F
	db "サーバが混んでいるため接", $0D
	db "続できません。　　　　　", $0D
	db "しばらく待って接続し直し", $0D
	db "て下さい。くわしくは取扱", $0D
	db "説明書をごらん下さい。", 0

CommErr_Msg_BadDestinationAddress:: ; 5C:44AA
	db "あて先メールアドレスにま", $0D
	db "ちがいがあります。正しい", $0D
	db "メールアドレスを入力して", $0D
	db "下さい。", 0

CommErr_Msg_BadOwnMailAddress:: ; 5C:44FE
	db "メールアドレスにまちがい", $0D
	db "があります。　　　　　　", $0D
	db "取扱説明書をごらんの上、", $0D
	db "モバイルトレーナーで初期", $0D
	db "登録をして下さい。", 0

CommErr_Msg_BadPasswordOrServerError:: ; 5C:4575
	db "入力したパスワードにまち", $0D
	db "がいがあるか、サーバのエ", $0D
	db "ラーです。パスワードをご", $0D
	db "確認のうえ、しばらく待っ", $0D
	db "てから通信し直してくださ", $0D
	db "い。", 0

CommErr_Msg_ContentDownloadRetry:: ; 5C:45F7
	db "コンテンツダウンロードが", $0D
	db "できません。しばらく待っ", $0D
	db "て通信し直して下さい。直", $0D
	db "らない場合は、取扱説明書", $0D
	db "をごらんのうえモバイルサ", $0D
	db "ポートセンターへお問い合", $0D
	db "わせ下さい。", 0

CommErr_Msg_Timeout:: ; 5C:469A
	db "タイムアウトにより通信が", $0D
	db "切断されました。通信し直", $0D
	db "して下さい。くわしくは取", $0D
	db "扱説明書をごらん下さい。", 0

CommErr_Msg_FeePaymentOverdue:: ; 5C:46FE
	db "ご利用料金のお支払いが遅", $0D
	db "れた場合には、ご利用がで", $0D
	db "きなくなります。くわしく", $0D
	db "は取扱説明書をごらん下さ", $0D
	db "い。", 0

CommErr_Msg_UnavailableCustomerReason:: ; 5C:4767
	db "お客様の都合により、利用", $0D
	db "できません。くわしくは取", $0D
	db "扱説明書をごらん下さい。", 0

CommErr_Msg_LineBusyOrServerError:: ; 5C:47B2
	db "回線が混んでいるか、サー", $0D
	db "バのエラーのため通信がで", $0D
	db "きません。しばらく待って", $0D
	db "通信し直して下さい。くわ", $0D
	db "しくは取扱説明書をごらん", $0D
	db "下さい。", 0

CommErr_Msg_FeeLimitExceeded:: ; 5C:4838
	db "ご利用料金が上限をこえて", $0D
	db "いるため、今月はご利用で", $0D
	db "きません。くわしくは取扱", $0D
	db "説明書をごらん下さい。", 0

CommErr_Msg_Maintenance:: ; 5C:489A
	db "現在メンテナンス中のため", $0D
	db "利用できません。しばらく", $0D
	db "待っておかけ直し下さい。", $0D
	db "くわしくは取扱説明書をご", $0D
	db "らん下さい。", 0

CommErr_Msg_ContentDownloadFailed:: ; 5C:490B
	db "コンテンツダウンロードが", $0D
	db "できません。くわしくは取", $0D
	db "扱説明書をごらん下さい。", 0

CommErr_Msg_BadLoginId:: ; 5C:4956
	db "ログインＩＤにまちがいが", $0D
	db "あります。取扱説明書をご", $0D
	db "らんの上、ログインＩＤを", $0D
	db "登録し直して下さい。", 0

CommErr_Msg_LoginIdSuspended:: ; 5C:49B6
	db "このログインＩＤは利用中", $0D
	db "断の手続きがされているた", $0D
	db "め、利用できません。　　", $0D
	db "取扱説明書をごらんの上、", $0D
	db "ＤＤＩカスタマサービスセ", $0D
	db "ンターにお問い合わせ下さ", $0D
	db "い。", 0

CommErr_Msg_LoginIdCancelled:: ; 5C:4A51
	db "このログインＩＤは解約さ", $0D
	db "れているため、利用できま", $0D
	db "せん。取扱説明書をごらん", $0D
	db "の上、ＤＤＩカスタマサー", $0D
	db "ビスセンターにお問い合わ", $0D
	db "せ下さい。", 0

CommErr_Msg_LoginIdUnavailable:: ; 5C:4AD9
	db "このログインＩＤは現在利", $0D
	db "利用できません。取扱説明", $0D
	db "書をごらんの上、ＤＤＩカ", $0D
	db "スタマサービスセンターに", $0D
	db "お問い合わせ下さい。", 0

CommErr_Msg_NewPasswordEmpty:: ; 5C:4B52
	db "新しいパスワードが入力さ", $0D
	db "れていません。　　　　　", $0D
	db "アルファベットと数字を組", $0D
	db "み合わせた４～８文字を入", $0D
	db "力して下さい。", 0

CommErr_Msg_NewPasswordLength:: ; 5C:4BC5
	db "新しいパスワードが長すぎ", $0D
	db "るか、短すぎます。　　　", $0D
	db "アルファベットと数字を組", $0D
	db "み合わせた４～８文字を入", $0D
	db "力して下さい。", 0

CommErr_Msg_NewPasswordBadChars:: ; 5C:4C38
	db "この新しいパスワードには", $0D
	db "使用できない文字が入って", $0D
	db "います。アルファベットと", $0D
	db "数字を組み合わせた４～８", $0D
	db "文字を入力して下さい。", 0

CommErr_Msg_NewPasswordNeedsMix:: ; 5C:4CB3
	db "この新しいパスワードはア", $0D
	db "ルファベットだけか、数字", $0D
	db "だけです。　　　　　　　", $0D
	db "アルファベットと数字を組", $0D
	db "み合わせた４～８文字を入", $0D
	db "力して下さい。", 0

CommErr_Msg_NewPasswordSameAsOld:: ; 5C:4D3F
	db "新しいパスワードと古いパ", $0D
	db "スワードが同じです。　　", $0D
	db "もういちどちがうパスワー", $0D
	db "ドをアルファベットと数字", $0D
	db "を組み合わせた４～８文字", $0D
	db "で入力して下さい。", 0

CommErr_Msg_RegistrationPending:: ; 5C:4DCF
	db "登録書の処理が完了してい", $0D
	db "ないようです。処理が完了", $0D
	db "するまでしばらくお待ち下", $0D
	db "さい。", 0

CommErr_Boot_AdapterNotPlugged:: ; 5C:4E21
	db "モバイルアダプタが正しく", $0D
	db "差しこまれていません。", 0

CommErr_Boot_WrongPassword:: ; 5C:4E51
	db "パスワードにまちがいがあ", $0D
	db "ります。正しいパスワード", $0D
	db "を入力して下さい。", 0

CommErr_Boot_AdapterConfigError:: ; 5C:4E96
	db "モバイルアダプタの登録情", $0D
	db "報エラーです。データを初", $0D
	db "期化します。", 0

CommErr_Boot_SaveDataErrorA:: ; 5C:4ED5
	db "カートリッジのセーブデー", $0D
	db "タエラーです。データを初", $0D
	db "期化します。", 0

CommErr_Boot_SaveDataErrorB:: ; 5C:4F14
	db "カートリッジのセーブデー", $0D
	db "タエラーです。データを初", $0D
	db "期化します。", 0

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
	dw $0020

; ---- ptrtable $5146-$5150 (10 bytes) [PROBABLE] little-endian word table, 5 entries, monotone=1.00, 100% of targets on string start/after NUL, targets $4E21..$4F14 [verifier: this is the continuation of the message pointer index space of 5C:5104 (5104 + 2*33 = 5146): the mode-2 record $F0 of the table 5C:4F53 has the list 5C:50F5 = 5 triples with message indices $21..$25 = slots 33-37 = exactly these 5 words]

CommErr_MessagePointers_Boot:: ; 5C:5146
Table_5C_5146::
	dw CommErr_Boot_AdapterNotPlugged
	dw CommErr_Boot_WrongPassword
	dw CommErr_Boot_AdapterConfigError
	dw CommErr_Boot_SaveDataErrorA
	dw CommErr_Boot_SaveDataErrorB

POPC
