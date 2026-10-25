; data/text/registration_prompts.asm
; bank 65, $567F-$5A8D (1038 bytes); pinned by layout.link
; English text and retained unused original allocations; relocated live strings are in registration_english_tail.

SECTION "data/text/registration_prompts", ROMX

PUSHC sjis

; ---- ptrtable $567F-$56A7 (40 bytes) [CONFIRMED] twenty NUL-terminated prompt targets; PromptText_Load copies the selected string to its 98-byte WRAM buffer.
PromptText_Table:: ; 65:567F
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

; ---- text $56A7-$56F4 (77 bytes) [CONFIRMED] NUL-terminated English prompt; $0D line breaks.
PromptText_EnterLoginId:: ; 65:56A7
	db "Please enter the Log-in", $0D
	db "ID from the DION Mobile", $0D
	db "GB Course registration", $0D
	db "form.", 0

; ---- data $56F4-$56FB (7 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "さい。", 0

; ---- text $56FB-$574C (81 bytes) [CONFIRMED] NUL-terminated English prompt; $0D line breaks.
PromptText_EnterMailAddress:: ; 65:56FB
	db "Please enter the email", $0D
	db "address from the DION", $0D
	db "Mobile GB Course", $0D
	db "registration form.", 0

; ---- data $574C-$5751 (5 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "い。", 0

; ---- text $5751-$57A6 (85 bytes) [CONFIRMED] NUL-terminated English prompt; $0D line breaks.
PromptText_EnterPassword:: ; 65:5751
	db "Please enter your", $0D
	db "password. Please do not", $0D
	db "share your password with", $0D
	db "any other person.", 0

; ---- data $57A6-$57A7 (1 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db 0

; ---- text $57A7-$57F8 (81 bytes) [CONFIRMED] NUL-terminated English prompt; $0D line breaks.
PromptText_DoNotUnplug:: ; 65:57A7
	db "Do not disconnect the", $0D
	db "Mobile Adapter GB or", $0D
	db "phone, and do not", $0D
	db "turn off the power.", 0

; ---- data $57F8-$5809 (17 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "しないでください", 0

; ---- data $5809-$583C (51 bytes) [CONFIRMED] unused original allocation; PromptText_CheckingRegistration now labels the live English tail string.
	db "モバイルアダプタＧＢに登", $0D
	db "録した情報を確認します。", $0D, 0

; ---- text $583C-$5876 (58 bytes) [CONFIRMED] NUL-terminated English prompt; $0D line breaks.
PromptText_RegistrationVerified:: ; 65:583C
	db "The registration", $0D
	db "information was", $0D
	db "confirmed to be correct.", 0

; ---- data $5876-$5879 (3 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "。", 0

; ---- data $5879-$58B6 (61 bytes) [CONFIRMED] unused original allocation; PromptText_DeleteWarning now labels the live English tail string.
	db "削除した情報は元にもどす", $0D
	db "ことができません。", $0D
	db "ご注意ください。", 0

; ---- text $58B6-$58F6 (64 bytes) [CONFIRMED] NUL-terminated English prompt; $0D line breaks.
PromptText_ReRegisterAfterDelete:: ; 65:58B6
	db "After deleting, you can", $0D
	db "register again if", $0D
	db "you decide to return.", 0

; ---- data $58F6-$5906 (16 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "してくださ", $0D
	db "い。", 0

; ---- text $5906-$591D (23 bytes) [CONFIRMED] NUL-terminated English prompt; $0D line breaks.
PromptText_SelectMenu:: ; 65:5906
	db "Please choose a menu.", $0D, 0

; ---- data $591D-$5920 (3 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db $A2, $0D, 0

; ---- data $5920-$5946 (38 bytes) [CONFIRMED] unused original allocation; PromptText_SelectPhoneEntryMethod now labels the live English tail string.
	db "電話番号の入力方法を選ん", $0D
	db "でください。", 0

; ---- data $5946-$596C (38 bytes) [CONFIRMED] unused original allocation; PromptText_PhoneChangeDone now labels the live English tail string.
	db "電話番号の変更は正しく終", $0D
	db "了しました。", 0

; ---- data $596C-$5985 (25 bytes) [CONFIRMED] unused original allocation; PromptText_ChangePassword now labels the live English tail string.
	db "パスワードを変更します。", 0

; ---- data $5985-$5998 (19 bytes) [CONFIRMED] unused original allocation; PromptText_ViewUsageTime now labels the live English tail string.
	db "利用時間を見ます。", 0

; ---- data $5998-$59A9 (17 bytes) [CONFIRMED] unused original allocation; PromptText_ViewUsageFee now labels the live English tail string.
	db "利用額を見ます。", 0

; ---- data $59A9-$59CF (38 bytes) [CONFIRMED] unused original allocation; PromptText_PasswordChangeDone now labels the live English tail string.
	db "パスワード変更は正しく終", $0D
	db "了しました。", 0

; ---- data $59CF-$59F1 (34 bytes) [CONFIRMED] unused original allocation; PromptText_UsageTimeDone now labels the live English tail string.
	db "ご利用時間の確認を終了し", $0D
	db "ました。", 0

; ---- data $59F1-$5A11 (32 bytes) [CONFIRMED] unused original allocation; PromptText_UsageFeeDone now labels the live English tail string.
	db "ご利用額の確認を終了しま", $0D
	db "した。", 0

; ---- data $5A11-$5A33 (34 bytes) [CONFIRMED] unused original allocation; PromptText_CommFailed now labels the live English tail string.
	db "エラーにより通信に失敗し", $0D
	db "ました。", 0

; ---- data $5A33-$5A49 (22 bytes) [CONFIRMED] unused original allocation; PromptText_CommInterrupted now labels the live English tail string.
	db "通信を中断しました。", $0D, 0

; ---- data $5A49-$5A8D (68 bytes) [CONFIRMED] unused original allocation; PromptText_PasswordSaveNote now labels the live English tail string.
	db "パスワードの保存について", $0D
	db "のご注意は、取扱説明書を", $0D
	db "お読みください。", $0D, 0

POPC
