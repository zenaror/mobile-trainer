; data/text/registration_notices.asm
; bank 65, $4C6E-$567F (2577 bytes); pinned by layout.link
; notice page texts and page table

SECTION "data/text/registration_notices", ROMX

PUSHC sjis

; ---- text $4C6E-$567F (2577 bytes) [PROBABLE] text: 24 string(s) of analysis/strings.tsv (Shift-JIS/ASCII, NUL terminated)

NoticeText_RegistrationStart:: ; 65:4C6E
	db "ＤＩＯＮへの初期登録", $0D
	db "（しょきとうろく）をはじ", $0D
	db "めます。", $0D
	db $0D
	db "おねがい：", $0D
	db "小さいお子さまは、かなら", $0D
	db "ずおうちの人といっしょに", $0D
	db "とうろくしてください。", 0

NoticeText_HaveManualReady:: ; 65:4CFA
	db "モバイルアダプタＧＢの箱", $0D
	db "に入っている取扱説明書や", $0D
	db "登録書をお手元に用意して", $0D
	db "ください。", 0

NoticeText_AgreeToTerms:: ; 65:4D50
	db "モバイルシステムＧＢを利", $0D
	db "用されるためにはＫＤＤI", $0D
	db "「総合オープン通信網サー", $0D
	db "ビス契約約款」任天堂「モ", $0D
	db "バイルシステムＧＢご利用", $0D
	db "規約」に同意の上、登録を", $0D
	db "行なっていただくようお願", $0D
	db "いいたします。", 0

NoticeText_ReadTerms:: ; 65:4E0D
	db "約款・規約は、ＤＩＯＮモ", $0D
	db "バイルＧＢコース登録書・", $0D
	db "モバイルアダプタＧＢ取扱", $0D
	db "説明書に書かれていますの", $0D
	db "で必ずお読みください。", 0

NoticeText_RegistrationCancelled:: ; 65:4E88
	db "初期登録を中止しました。", $0D
	db $0D
	db "ゲームボーイの電源スイッ", $0D
	db "チをＯＦＦにしてください", 0

NoticeText_Welcome:: ; 65:4ED4
	db "モバイルシステムＧＢへ", $0D
	db "ようこそ！", $0D
	db $0D
	db "今日からメールや任天堂", $0D
	db "モバイルホームページなど", $0D
	db "がご利用いただけます。", 0

NoticeText_MailRegistrationForm:: ; 65:4F3E
	db "箱に入っている「登録書」", $0D
	db "を記入して、封筒に入れて", $0D
	db "ＫＤＤＩに郵送してくださ", $0D
	db "い。", $0D
	db $0D
	db "それではモバイルシステム", $0D
	db "ＧＢをお楽しみください。", 0

NoticeText_UsageFeeWarning:: ; 65:4FC1
	db "モバイルシステムＧＢの", $0D
	db "サービスを利用される場合", $0D
	db "通話料以外に利用料がかか", $0D
	db "ることがあります。", $0D
	db "くわしくはモバイルアダプ", $0D
	db "タＧＢ取扱説明書をお読み", $0D
	db "ください。", 0

NoticeText_DeleteRegistrationWarning:: ; 65:505A
	db "モバイルアダプタＧＢと", $0D
	db "モバイルトレーナーに保存", $0D
	db "されているすべての情報を", $0D
	db "削除します。削除する前に", $0D
	db "モバイルトレーナーの取扱", $0D
	db "説明書をお読みください。", 0

NoticeText_DeleteBeforeDisposal:: ; 65:50EE
	db "モバイルアダプタＧＢを", $0D
	db "他人にゆずったり、貸した", $0D
	db "り、処分するときには、必", $0D
	db "ず登録情報を削除してくだ", $0D
	db "さい。", 0

NoticeText_DeleteCancelled:: ; 65:5157
	db $0D
	db $0D
	db "登録情報の削除を中止しま", $0D
	db "した。", 0

NoticeText_DeleteDone:: ; 65:5179
	db "登録情報を完全に削除しま", $0D
	db "した。", $0D
	db "もう一度利用されたい場合", $0D
	db "は、初期登録をしてくださ", $0D
	db "い。", $0D
	db "ゲームボーイの電源スイッ", $0D
	db "チをＯＦＦにしてください", 0

NoticeText_ManualPhoneEntry:: ; 65:5202
	db "電話番号を手動で入力しま", $0D
	db "す。", $0D
	db "・インターネット電話番号", $0D
	db "・セルフページ電話番号", $0D
	db "・電話番号コメント", $0D
	db "を入力してください。", $0D
	db "電話番号は間違いのないよ", $0D
	db "うに確認してください。", 0

NoticeText_PhoneChangeDone:: ; 65:52A8
	db "電話番号の変更は正しく終", $0D
	db "了しました。", 0

NoticeText_PhoneChangeCancelled:: ; 65:52CE
	db $0D
	db $0D
	db "電話番号変更を中止しまし", $0D
	db "た。", 0

NoticeText_PasswordChangeIntro:: ; 65:52EE
	db "パスワードを変更します。", $0D
	db "パスワード変更を行う前に", $0D
	db "モバイルトレーナーの取扱", $0D
	db "説明書をお読みください。", $0D
	db "パスワードは他の人に知ら", $0D
	db "れないようにご注意くださ", $0D
	db "い。", 0

NoticeText_PasswordRules:: ; 65:5389
	db "パスワードはアルファベッ", $0D
	db "トと数字を組み合わせて、", $0D
	db "４～８文字の間で入力して", $0D
	db "ください。", $0D
	db "パスワードで使うアルファ", $0D
	db "ベットには大文字と小文字", $0D
	db "の区別があります。", 0

NoticeText_PasswordChangeCancelled:: ; 65:5424
	db $0D
	db $0D
	db "パスワード変更を中止しま", $0D
	db "した。", 0

NoticeText_PasswordChangeDone:: ; 65:5446
	db "新しいパスワードは約５分", $0D
	db "後より利用できます。", $0D
	db $0D
	db "新しいパスワードは、必ず", $0D
	db "メモしていただき、大切に", $0D
	db "保管してください。", 0

NoticeText_UsageTimeIntro:: ; 65:54BA
	db "ＤＩＯＮモバイルＧＢコー", $0D
	db "スの利用時間を見ることが", $0D
	db "できます。", $0D
	db "くわしくはモバイルトレー", $0D
	db "ナーの取扱説明書をお読み", $0D
	db "ください。", 0

NoticeText_UsageTimeCancelled:: ; 65:5534
	db $0D
	db $0D
	db "ご利用時間の確認を中止し", $0D
	db "ました。", 0

NoticeText_UsageFeeIntro:: ; 65:5558
	db "モバイルシステムＧＢの", $0D
	db "任天堂コンテンツ利用料の", $0D
	db "一ヶ月ごとの利用額の合計", $0D
	db "と、その明細を見ることが", $0D
	db "できます。", $0D
	db "くわしくはモバイルトレー", $0D
	db "ナーの取扱説明書をお読み", $0D
	db "ください。", 0

NoticeText_UsageFeeCancelled:: ; 65:5602
	db $0D
	db $0D
	db "ご利用額の確認を中止しま", $0D
	db "した。", 0

NoticeText_ResumeRegistration:: ; 65:5624
	db "前回の初期登録が正しく終", $0D
	db "了していません。", $0D
	db $0D
	db "Ａボタンを押すと、前回の", $0D
	db "つづきから再開します。", 0

POPC
