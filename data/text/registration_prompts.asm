; data/text/registration_prompts.asm
; bank 65, $567F-$5A8D (1038 bytes); pinned by layout.link
; prompt texts and their pointer table

SECTION "data/text/registration_prompts", ROMX

; ---- ptrtable $567F-$56A7 (40 bytes) [PROBABLE] 20 string pointers (56A7 56FB 5751 57A7 5809 583C 5879 58B6 5906 5920 ...5A49), each landing exactly on a string start of the 20 strings of String_65_56A7; read in traces

PromptText_Table:: ; 65:567F
Table_65_567F::
	dw PromptText_EnterLoginId
	dw PromptText_EnterMailAddress
	dw PromptText_EnterPassword
	dw PromptText_DoNotUnplug
	dw PromptText_CheckingRegistration
	dw PromptText_RegistrationVerified
	dw PromptText_DeleteWarning
	dw PromptText_ReRegisterAfterDelete
	dw PromptText_SelectMenu
	dw PromptText_SelectPhoneEntryMethod
	dw PromptText_PhoneChangeDone
	dw PromptText_ChangePassword
	dw PromptText_ViewUsageTime
	dw PromptText_ViewUsageFee
	dw PromptText_PasswordChangeDone
	dw PromptText_UsageTimeDone
	dw PromptText_UsageFeeDone
	dw PromptText_CommFailed
	dw PromptText_CommInterrupted
	dw PromptText_PasswordSaveNote

; ---- text $56A7-$5A8D (998 bytes) [PROBABLE] text: 20 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

PromptText_EnterLoginId:: ; 65:56A7
String_65_56A7::
	db $82, $63, $82, $68, $82, $6E, $82, $6D, $83, $82, $83, $6F, $83, $43, $83, $8B, $82, $66, $82, $61, $83, $52, $81, $5B, $0D, $83, $58, $93, $6F, $98, $5E, $8F, $91 ; "ＤＩＯＮモバイルＧＢコー<$0D>ス登録書"
	db $82, $C9, $8F, $91, $82, $A9, $82, $EA, $82, $C4, $82, $A2, $82, $E9, $81, $41, $0D, $83, $8D, $83, $4F, $83, $43, $83, $93, $82, $68, $82, $63, $82, $F0, $93, $FC ; "に書かれている、<$0D>ログインＩＤを入"
	db $97, $CD, $82, $B5, $82, $C4, $82, $AD, $0D, $82, $BE, $82, $B3, $82, $A2, $81, $42, $00 ; "力してく<$0D>ださい。"

PromptText_EnterMailAddress:: ; 65:56FB
	db $82, $63, $82, $68, $82, $6E, $82, $6D, $83, $82, $83, $6F, $83, $43, $83, $8B, $82, $66, $82, $61, $83, $52, $81, $5B, $0D, $83, $58, $93, $6F, $98, $5E, $8F, $91 ; "ＤＩＯＮモバイルＧＢコー<$0D>ス登録書"
	db $82, $C9, $8F, $91, $82, $A9, $82, $EA, $82, $C4, $82, $A2, $82, $E9, $81, $41, $0D, $83, $81, $81, $5B, $83, $8B, $83, $41, $83, $68, $83, $8C, $83, $58, $82, $F0 ; "に書かれている、<$0D>メールアドレスを"
	db $93, $FC, $97, $CD, $82, $B5, $82, $C4, $0D, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $00 ; "入力して<$0D>ください。"

PromptText_EnterPassword:: ; 65:5751
	db $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $F0, $93, $FC, $97, $CD, $82, $B5, $82, $C4, $82, $AD, $82, $BE, $0D, $82, $B3, $82, $A2, $81, $42, $83, $70 ; "パスワードを入力してくだ<$0D>さい。パ"
	db $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $CD, $91, $BC, $82, $CC, $90, $6C, $0D, $82, $C9, $92, $6D, $82, $E7, $82, $EA, $82, $C8, $82, $A2, $82, $E6, $82, $A4 ; "スワードは他の人<$0D>に知られないよう"
	db $82, $C9, $82, $B2, $92, $8D, $88, $D3, $0D, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $00 ; "にご注意<$0D>ください。"

PromptText_DoNotUnplug:: ; 65:57A7
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $41, $83, $5F, $83, $76, $83, $5E, $82, $66, $82, $61, $82, $E2, $0D, $93, $64, $98, $62, $8B, $40, $82, $F0, $94, $B2 ; "モバイルアダプタＧＢや<$0D>電話機を抜"
	db $82, $A2, $82, $BD, $82, $E8, $81, $41, $83, $51, $81, $5B, $83, $80, $0D, $83, $7B, $81, $5B, $83, $43, $82, $CC, $93, $64, $8C, $B9, $83, $58, $83, $43, $83, $62 ; "いたり、ゲーム<$0D>ボーイの電源スイッ"
	db $83, $60, $82, $F0, $81, $41, $0D, $82, $6E, $82, $65, $82, $65, $82, $C9, $82, $B5, $82, $C8, $82, $A2, $82, $C5, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $00 ; "チを、<$0D>ＯＦＦにしないでください"

PromptText_CheckingRegistration:: ; 65:5809
	db $83, $82, $83, $6F, $83, $43, $83, $8B, $83, $41, $83, $5F, $83, $76, $83, $5E, $82, $66, $82, $61, $82, $C9, $93, $6F, $0D, $98, $5E, $82, $B5, $82, $BD, $8F, $EE ; "モバイルアダプタＧＢに登<$0D>録した情"
	db $95, $F1, $82, $F0, $8A, $6D, $94, $46, $82, $B5, $82, $DC, $82, $B7, $81, $42, $0D, $00 ; "報を確認します。<$0D>"

PromptText_RegistrationVerified:: ; 65:583C
	db $93, $6F, $98, $5E, $8F, $EE, $95, $F1, $82, $AA, $90, $B3, $82, $B5, $82, $A2, $82, $B1, $82, $C6, $82, $F0, $8A, $6D, $0D, $94, $46, $82, $B5, $82, $DC, $82, $B5 ; "登録情報が正しいことを確<$0D>認しまし"
	db $82, $BD, $81, $42, $8F, $89, $8A, $FA, $93, $6F, $98, $5E, $82, $F0, $8F, $49, $0D, $97, $B9, $82, $B5, $82, $DC, $82, $B7, $81, $42, $00 ; "た。初期登録を終<$0D>了します。"

PromptText_DeleteWarning:: ; 65:5879
	db $8D, $ED, $8F, $9C, $82, $B5, $82, $BD, $8F, $EE, $95, $F1, $82, $CD, $8C, $B3, $82, $C9, $82, $E0, $82, $C7, $82, $B7, $0D, $82, $B1, $82, $C6, $82, $AA, $82, $C5 ; "削除した情報は元にもどす<$0D>ことがで"
	db $82, $AB, $82, $DC, $82, $B9, $82, $F1, $81, $42, $0D, $82, $B2, $92, $8D, $88, $D3, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $00 ; "きません。<$0D>ご注意ください。"

PromptText_ReRegisterAfterDelete:: ; 65:58B6
	db $93, $6F, $98, $5E, $8F, $EE, $95, $F1, $82, $F0, $8D, $ED, $8F, $9C, $82, $B5, $82, $BD, $82, $A0, $82, $C6, $82, $C5, $0D, $82, $E0, $82, $A4, $88, $EA, $93, $78 ; "登録情報を削除したあとで<$0D>もう一度"
	db $97, $98, $97, $70, $82, $B3, $82, $EA, $82, $BD, $82, $A2, $82, $C6, $82, $AB, $0D, $82, $CD, $81, $41, $8F, $89, $8A, $FA, $93, $6F, $98, $5E, $82, $F0, $82, $B5 ; "利用されたいとき<$0D>は、初期登録をし"
	db $82, $C4, $82, $AD, $82, $BE, $82, $B3, $0D, $82, $A2, $81, $42, $00 ; "てくださ<$0D>い。"

PromptText_SelectMenu:: ; 65:5906
	db $83, $81, $83, $6A, $83, $85, $81, $5B, $82, $F0, $91, $49, $82, $F1, $82, $C5, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $0D, $00 ; "メニューを選んでください<$0D>"

PromptText_SelectPhoneEntryMethod:: ; 65:5920
	db $93, $64, $98, $62, $94, $D4, $8D, $86, $82, $CC, $93, $FC, $97, $CD, $95, $FB, $96, $40, $82, $F0, $91, $49, $82, $F1, $0D, $82, $C5, $82, $AD, $82, $BE, $82, $B3 ; "電話番号の入力方法を選ん<$0D>でくださ"
	db $82, $A2, $81, $42, $00 ; "い。"

PromptText_PhoneChangeDone:: ; 65:5946
	db $93, $64, $98, $62, $94, $D4, $8D, $86, $82, $CC, $95, $CF, $8D, $58, $82, $CD, $90, $B3, $82, $B5, $82, $AD, $8F, $49, $0D, $97, $B9, $82, $B5, $82, $DC, $82, $B5 ; "電話番号の変更は正しく終<$0D>了しまし"
	db $82, $BD, $81, $42, $00 ; "た。"

PromptText_ChangePassword:: ; 65:596C
	db $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $F0, $95, $CF, $8D, $58, $82, $B5, $82, $DC, $82, $B7, $81, $42, $00 ; "パスワードを変更します。"

PromptText_ViewUsageTime:: ; 65:5985
	db $97, $98, $97, $70, $8E, $9E, $8A, $D4, $82, $F0, $8C, $A9, $82, $DC, $82, $B7, $81, $42, $00 ; "利用時間を見ます。"

PromptText_ViewUsageFee:: ; 65:5998
	db $97, $98, $97, $70, $8A, $7A, $82, $F0, $8C, $A9, $82, $DC, $82, $B7, $81, $42, $00 ; "利用額を見ます。"

PromptText_PasswordChangeDone:: ; 65:59A9
	db $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $95, $CF, $8D, $58, $82, $CD, $90, $B3, $82, $B5, $82, $AD, $8F, $49, $0D, $97, $B9, $82, $B5, $82, $DC, $82, $B5 ; "パスワード変更は正しく終<$0D>了しまし"
	db $82, $BD, $81, $42, $00 ; "た。"

PromptText_UsageTimeDone:: ; 65:59CF
	db $82, $B2, $97, $98, $97, $70, $8E, $9E, $8A, $D4, $82, $CC, $8A, $6D, $94, $46, $82, $F0, $8F, $49, $97, $B9, $82, $B5, $0D, $82, $DC, $82, $B5, $82, $BD, $81, $42, $00 ; "ご利用時間の確認を終了し<$0D>ました。"

PromptText_UsageFeeDone:: ; 65:59F1
	db $82, $B2, $97, $98, $97, $70, $8A, $7A, $82, $CC, $8A, $6D, $94, $46, $82, $F0, $8F, $49, $97, $B9, $82, $B5, $82, $DC, $0D, $82, $B5, $82, $BD, $81, $42, $00 ; "ご利用額の確認を終了しま<$0D>した。"

PromptText_CommFailed:: ; 65:5A11
	db $83, $47, $83, $89, $81, $5B, $82, $C9, $82, $E6, $82, $E8, $92, $CA, $90, $4D, $82, $C9, $8E, $B8, $94, $73, $82, $B5, $0D, $82, $DC, $82, $B5, $82, $BD, $81, $42, $00 ; "エラーにより通信に失敗し<$0D>ました。"

PromptText_CommInterrupted:: ; 65:5A33
	db $92, $CA, $90, $4D, $82, $F0, $92, $86, $92, $66, $82, $B5, $82, $DC, $82, $B5, $82, $BD, $81, $42, $0D, $00 ; "通信を中断しました。<$0D>"

PromptText_PasswordSaveNote:: ; 65:5A49
	db $83, $70, $83, $58, $83, $8F, $81, $5B, $83, $68, $82, $CC, $95, $DB, $91, $B6, $82, $C9, $82, $C2, $82, $A2, $82, $C4, $0D, $82, $CC, $82, $B2, $92, $8D, $88, $D3 ; "パスワードの保存について<$0D>のご注意"
	db $82, $CD, $81, $41, $8E, $E6, $88, $B5, $90, $E0, $96, $BE, $8F, $91, $82, $F0, $0D, $82, $A8, $93, $C7, $82, $DD, $82, $AD, $82, $BE, $82, $B3, $82, $A2, $81, $42, $0D ; "は、取扱説明書を<$0D>お読みください。<$0D>"
	db $00 ; ""
