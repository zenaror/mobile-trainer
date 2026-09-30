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
	db "●でパスワードを", $0D, $0A
	db "かいてください。", 0
	db "せつめいしょで　パスワードほぞんについてのちゅういを", $0D, $0A
	db "みてください。ほぞんしますか？", 0
	db "カートリッジに　パスワードを", $0D, $0A
	db "ほぞんしました。", $0D, $0A
	db "●でつうしんをはじめます。", 0
	db "カートリッジに　パスワードが", $0D, $0A
	db "ほぞんされています。", $0D, $0A
	db "●でつうしんをはじめます。", 0
	db "パスワードの　ほぞんをやめます。よろしいですか？", 0

POPC
