; data/text/registration_prompts.asm
; bank 65, $567F-$5A8D (1038 bytes); pinned by layout.link
; prompt texts and their pointer table

SECTION "data/text/registration_prompts", ROMX

PUSHC sjis

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
	db "ＤＩＯＮモバイルＧＢコー", $0D
	db "ス登録書に書かれている、", $0D
	db "ログインＩＤを入力してく", $0D
	db "ださい。", 0

PromptText_EnterMailAddress:: ; 65:56FB
	db "ＤＩＯＮモバイルＧＢコー", $0D
	db "ス登録書に書かれている、", $0D
	db "メールアドレスを入力して", $0D
	db "ください。", 0

PromptText_EnterPassword:: ; 65:5751
	db "パスワードを入力してくだ", $0D
	db "さい。パスワードは他の人", $0D
	db "に知られないようにご注意", $0D
	db "ください。", 0

PromptText_DoNotUnplug:: ; 65:57A7
	db "モバイルアダプタＧＢや", $0D
	db "電話機を抜いたり、ゲーム", $0D
	db "ボーイの電源スイッチを、", $0D
	db "ＯＦＦにしないでください", 0

PromptText_CheckingRegistration:: ; 65:5809
	db "モバイルアダプタＧＢに登", $0D
	db "録した情報を確認します。", $0D, 0

PromptText_RegistrationVerified:: ; 65:583C
	db "登録情報が正しいことを確", $0D
	db "認しました。初期登録を終", $0D
	db "了します。", 0

PromptText_DeleteWarning:: ; 65:5879
	db "削除した情報は元にもどす", $0D
	db "ことができません。", $0D
	db "ご注意ください。", 0

PromptText_ReRegisterAfterDelete:: ; 65:58B6
	db "登録情報を削除したあとで", $0D
	db "もう一度利用されたいとき", $0D
	db "は、初期登録をしてくださ", $0D
	db "い。", 0

PromptText_SelectMenu:: ; 65:5906
	db "メニューを選んでください", $0D, 0

PromptText_SelectPhoneEntryMethod:: ; 65:5920
	db "電話番号の入力方法を選ん", $0D
	db "でください。", 0

PromptText_PhoneChangeDone:: ; 65:5946
	db "電話番号の変更は正しく終", $0D
	db "了しました。", 0

PromptText_ChangePassword:: ; 65:596C
	db "パスワードを変更します。", 0

PromptText_ViewUsageTime:: ; 65:5985
	db "利用時間を見ます。", 0

PromptText_ViewUsageFee:: ; 65:5998
	db "利用額を見ます。", 0

PromptText_PasswordChangeDone:: ; 65:59A9
	db "パスワード変更は正しく終", $0D
	db "了しました。", 0

PromptText_UsageTimeDone:: ; 65:59CF
	db "ご利用時間の確認を終了し", $0D
	db "ました。", 0

PromptText_UsageFeeDone:: ; 65:59F1
	db "ご利用額の確認を終了しま", $0D
	db "した。", 0

PromptText_CommFailed:: ; 65:5A11
	db "エラーにより通信に失敗し", $0D
	db "ました。", 0

PromptText_CommInterrupted:: ; 65:5A33
	db "通信を中断しました。", $0D, 0

PromptText_PasswordSaveNote:: ; 65:5A49
	db "パスワードの保存について", $0D
	db "のご注意は、取扱説明書を", $0D
	db "お読みください。", $0D, 0

POPC
