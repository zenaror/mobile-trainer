; data/text/registration_notices.asm
; bank 65, $4C6E-$567F (2577 bytes); pinned by layout.link
; English text and retained unused original allocations; relocated live strings are in registration_english_tail.

SECTION "data/text/registration_notices", ROMX

PUSHC sjis

; ---- text $4C6E-$4CF5 (135 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_RegistrationStart:: ; 65:4C6E
	db "The initial registration", $0D
	db "through DION will now", $0D
	db "be started.", $0D
	db $0D
	db "Note:", $0D
	db "During setup, young", $0D
	db "children should receive", $0D
	db "help from their parents.", 0

; ---- data $4CF5-$4CFA (5 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "い。", 0

; ---- data $4CFA-$4D50 (86 bytes) [CONFIRMED] unused original allocation; NoticeText_HaveManualReady now labels the live English tail string.
	db "モバイルアダプタＧＢの箱", $0D
	db "に入っている取扱説明書や", $0D
	db "登録書をお手元に用意して", $0D
	db "ください。", 0

; ---- text $4D50-$4DD2 (130 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_AgreeToTerms:: ; 65:4D50
	db "Before registering,", $0D
	db "please read and agree", $0D
	db "to the terms of service", $0D
	db "of both KDDI (Network", $0D
	db "Service) and Nintendo", $0D
	db "(Mobile System GB).", 0

; ---- data $4DD2-$4E0D (59 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "に同意の上、登録を", $0D
	db "行なっていただくようお願", $0D
	db "いいたします。", 0

; ---- data $4E0D-$4E88 (123 bytes) [CONFIRMED] unused original allocation; NoticeText_ReadTerms now labels the live English tail string.
	db "約款・規約は、ＤＩＯＮモ", $0D
	db "バイルＧＢコース登録書・", $0D
	db "モバイルアダプタＧＢ取扱", $0D
	db "説明書に書かれていますの", $0D
	db "で必ずお読みください。", 0

; ---- text $4E88-$4ED3 (75 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_RegistrationCancelled:: ; 65:4E88
	db "The registration process", $0D
	db "has been interrupted.", $0D
	db $0D
	db "Please turn off the", $0D
	db "power.", 0

; ---- data $4ED3-$4ED4 (1 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db 0

; ---- data $4ED4-$4F3E (106 bytes) [CONFIRMED] unused original allocation; NoticeText_Welcome now labels the live English tail string.
	db "モバイルシステムＧＢへ", $0D
	db "ようこそ！", $0D
	db $0D
	db "今日からメールや任天堂", $0D
	db "モバイルホームページなど", $0D
	db "がご利用いただけます。", 0

; ---- text $4F3E-$4FAC (110 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_MailRegistrationForm:: ; 65:4F3E
	db "Please submit the", $0D
	db "registration form from", $0D
	db "inside the package", $0D
	db "to KDDI.", $0D
	db $0D
	db "We hope you enjoy the", $0D
	db "Mobile System GB.", 0

; ---- data $4FAC-$4FC1 (21 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "をお楽しみください。", 0

; ---- data $4FC1-$505A (153 bytes) [CONFIRMED] unused original allocation; NoticeText_UsageFeeWarning now labels the live English tail string.
	db "モバイルシステムＧＢの", $0D
	db "サービスを利用される場合", $0D
	db "通話料以外に利用料がかか", $0D
	db "ることがあります。", $0D
	db "くわしくはモバイルアダプ", $0D
	db "タＧＢ取扱説明書をお読み", $0D
	db "ください。", 0

; ---- data $505A-$50EE (148 bytes) [CONFIRMED] unused original allocation; NoticeText_DeleteRegistrationWarning now labels the live English tail string.
	db "モバイルアダプタＧＢと", $0D
	db "モバイルトレーナーに保存", $0D
	db "されているすべての情報を", $0D
	db "削除します。削除する前に", $0D
	db "モバイルトレーナーの取扱", $0D
	db "説明書をお読みください。", 0

; ---- data $50EE-$5157 (105 bytes) [CONFIRMED] unused original allocation; NoticeText_DeleteBeforeDisposal now labels the live English tail string.
	db "モバイルアダプタＧＢを", $0D
	db "他人にゆずったり、貸した", $0D
	db "り、処分するときには、必", $0D
	db "ず登録情報を削除してくだ", $0D
	db "さい。", 0

; ---- text $5157-$5176 (31 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_DeleteCancelled:: ; 65:5157
	db $0D
	db $0D
	db "The process was", $0D
	db "interrupted.", 0

; ---- data $5176-$5179 (3 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "。", 0

; ---- data $5179-$5202 (137 bytes) [CONFIRMED] unused original allocation; NoticeText_DeleteDone now labels the live English tail string.
	db "登録情報を完全に削除しま", $0D
	db "した。", $0D
	db "もう一度利用されたい場合", $0D
	db "は、初期登録をしてくださ", $0D
	db "い。", $0D
	db "ゲームボーイの電源スイッ", $0D
	db "チをＯＦＦにしてください", 0

; ---- text $5202-$528F (141 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_ManualPhoneEntry:: ; 65:5202
	db "Manually enter your", $0D
	db "phone number.", $0D
	db "・ Internet number", $0D
	db "・ Self page number", $0D
	db "・ Phone number comment", $0D
	db "Please ensure your", $0D
	db "phone number is", $0D
	db "correct.", 0

; ---- data $528F-$52A8 (25 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db $E6, $0D
	db "うに確認してください。", 0

; ---- data $52A8-$52CE (38 bytes) [CONFIRMED] unused original allocation; NoticeText_PhoneChangeDone now labels the live English tail string.
	db "電話番号の変更は正しく終", $0D
	db "了しました。", 0

; ---- text $52CE-$52ED (31 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_PhoneChangeCancelled:: ; 65:52CE
	db $0D
	db $0D
	db "The process was", $0D
	db "interrupted.", 0

; ---- data $52ED-$52EE (1 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db 0

; ---- text $52EE-$537C (142 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_PasswordChangeIntro:: ; 65:52EE
	db "Before changing your", $0D
	db "password, please refer", $0D
	db "to the Mobile Trainer", $0D
	db "instruction booklet.", $0D
	db "Please ensure that no", $0D
	db "other people know", $0D
	db "your password.", 0

; ---- data $537C-$5389 (13 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db $D3, "くださ", $0D
	db "い。", 0

; ---- text $5389-$53ED (100 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_PasswordRules:: ; 65:5389
	db "Please enter 4 to 8", $0D
	db "alphanumeric characters", $0D
	db "for your password.", $0D
	db "The password will be", $0D
	db "case-sensitive.", 0

; ---- data $53ED-$5424 (55 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "うアルファ", $0D
	db "ベットには大文字と小文字", $0D
	db "の区別があります。", 0

; ---- text $5424-$5443 (31 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_PasswordChangeCancelled:: ; 65:5424
	db $0D
	db $0D
	db "The process was", $0D
	db "interrupted.", 0

; ---- data $5443-$5446 (3 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "。", 0

; ---- data $5446-$54BA (116 bytes) [CONFIRMED] unused original allocation; NoticeText_PasswordChangeDone now labels the live English tail string.
	db "新しいパスワードは約５分", $0D
	db "後より利用できます。", $0D
	db $0D
	db "新しいパスワードは、必ず", $0D
	db "メモしていただき、大切に", $0D
	db "保管してください。", 0

; ---- data $54BA-$5534 (122 bytes) [CONFIRMED] unused original allocation; NoticeText_UsageTimeIntro now labels the live English tail string.
	db "ＤＩＯＮモバイルＧＢコー", $0D
	db "スの利用時間を見ることが", $0D
	db "できます。", $0D
	db "くわしくはモバイルトレー", $0D
	db "ナーの取扱説明書をお読み", $0D
	db "ください。", 0

; ---- text $5534-$5553 (31 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_UsageTimeCancelled:: ; 65:5534
	db $0D
	db $0D
	db "The process was", $0D
	db "interrupted.", 0

; ---- data $5553-$5558 (5 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "た。", 0

; ---- data $5558-$5602 (170 bytes) [CONFIRMED] unused original allocation; NoticeText_UsageFeeIntro now labels the live English tail string.
	db "モバイルシステムＧＢの", $0D
	db "任天堂コンテンツ利用料の", $0D
	db "一ヶ月ごとの利用額の合計", $0D
	db "と、その明細を見ることが", $0D
	db "できます。", $0D
	db "くわしくはモバイルトレー", $0D
	db "ナーの取扱説明書をお読み", $0D
	db "ください。", 0

; ---- text $5602-$5621 (31 bytes) [CONFIRMED] NUL-terminated English notice; $0D line breaks.
NoticeText_UsageFeeCancelled:: ; 65:5602
	db $0D
	db $0D
	db "The process was", $0D
	db "interrupted.", 0

; ---- data $5621-$5624 (3 bytes) [CONFIRMED] unreferenced original remainder; retained byte for byte.
	db "。", 0

; ---- data $5624-$567F (91 bytes) [CONFIRMED] unused original allocation; NoticeText_ResumeRegistration now labels the live English tail string.
	db "前回の初期登録が正しく終", $0D
	db "了していません。", $0D
	db $0D
	db "Ａボタンを押すと、前回の", $0D
	db "つづきから再開します。", 0

POPC
