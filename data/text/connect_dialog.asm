; data/text/connect_dialog.asm
; bank 56, $4000-$418A (394 bytes); pinned by layout.link
; six strings of the connect dialog

SECTION "data/text/connect_dialog", ROMX

PUSHC sjis

; ---- text $4000-$418A (394 bytes) [CONFIRMED] text: 6 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

String_ConnectDialog_Messages:: ; 56:4000
String_56_4000::
	db "つうわりょうと　せつぞくりょうがかかります。", $0D, $0A
	db "　　　　よろしいですか？", 0
String_ConnectDialog_PasswordEntryPrompt:: ; 56:4047
String_56_4047::
	db "●でパスワードを", $0D, $0A
	db "かいてください。", 0
String_ConnectDialog_SavePasswordConfirm:: ; 56:406A
String_56_406A::
	db "せつめいしょで　パスワードほぞんについてのちゅういを", $0D, $0A
	db "みてください。ほぞんしますか？", 0
String_ConnectDialog_PasswordSavedNotice:: ; 56:40BF
String_56_40BF::
	db "カートリッジに　パスワードを", $0D, $0A
	db "ほぞんしました。", $0D, $0A
	db "●でつうしんをはじめます。", 0
String_ConnectDialog_StoredPasswordNotice:: ; 56:410A
String_56_410A::
	db "カートリッジに　パスワードが", $0D, $0A
	db "ほぞんされています。", $0D, $0A
	db "●でつうしんをはじめます。", 0
String_ConnectDialog_CancelPasswordStorageConfirm:: ; 56:4159
String_56_4159::
	db "パスワードの　ほぞんをやめます。よろしいですか？", 0

POPC
