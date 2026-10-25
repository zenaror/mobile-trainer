; data/text/registration_english_tail.asm
; bank 65, $77B8-$8000 (2120 bytes); fixed section placement
; Referenced English notice and prompt strings; all stored bytes belong to a selected NUL-terminated target.

SECTION "data/text/registration_english_tail", ROMX[$77B8], BANK[$65]

PUSHC sjis

; ---- text $77B8-$780B (83 bytes) [CONFIRMED] English prompt index $13; $0D line breaks and final NUL.
PromptText_PasswordSaveNote:: ; 65:77B8
	db "Please read the", $0D
	db "precautions regarding", $0D
	db "saving passwords in", $0D
	db "the instruction booklet.", 0

; ---- text $780B-$782C (33 bytes) [CONFIRMED] English prompt index $12; $0D line breaks and final NUL.
PromptText_CommInterrupted:: ; 65:780B
	db "The connection was", $0D
	db "interrupted.", $0D, 0

; ---- text $782C-$7857 (43 bytes) [CONFIRMED] English prompt index $11; $0D line breaks and final NUL.
PromptText_CommFailed:: ; 65:782C
	db "The connection has", $0D
	db "failed due to an error.", 0

; ---- text $7857-$787F (40 bytes) [CONFIRMED] English prompt index $10; $0D line breaks and final NUL.
PromptText_UsageFeeDone:: ; 65:7857
	db "The process was", $0D
	db "completed successfully.", 0

; ---- text $787F-$78A7 (40 bytes) [CONFIRMED] English prompt index $0F; $0D line breaks and final NUL.
PromptText_UsageTimeDone:: ; 65:787F
	db "The process was", $0D
	db "completed successfully.", 0

; ---- text $78A7-$78CE (39 bytes) [CONFIRMED] English prompt index $0E; $0D line breaks and final NUL.
PromptText_PasswordChangeDone:: ; 65:78A7
	db "The password was", $0D
	db "updated successfully.", 0

; ---- text $78CE-$78E9 (27 bytes) [CONFIRMED] English prompt index $0D; $0D line breaks and final NUL.
PromptText_ViewUsageFee:: ; 65:78CE
	db "View your current", $0D
	db "balance.", 0

; ---- text $78E9-$7908 (31 bytes) [CONFIRMED] English prompt index $0C; $0D line breaks and final NUL.
PromptText_ViewUsageTime:: ; 65:78E9
	db "View the amount of", $0D
	db "time spent.", 0

; ---- text $7908-$792B (35 bytes) [CONFIRMED] English prompt index $0B; $0D line breaks and final NUL.
PromptText_ChangePassword:: ; 65:7908
	db "Your password will now", $0D
	db "be changed.", 0

; ---- text $792B-$7956 (43 bytes) [CONFIRMED] English prompt index $0A; $0D line breaks and final NUL.
PromptText_PhoneChangeDone:: ; 65:792B
	db "The phone number was", $0D
	db "updated successfully.", 0

; ---- text $7956-$798E (56 bytes) [CONFIRMED] English prompt index $09; $0D line breaks and final NUL.
PromptText_SelectPhoneEntryMethod:: ; 65:7956
	db "Choose your preferred", $0D
	db "way of entering the", $0D
	db "phone number.", 0

; ---- text $798E-$79CC (62 bytes) [CONFIRMED] English prompt index $06; $0D line breaks and final NUL.
PromptText_DeleteWarning:: ; 65:798E
	db "Please be careful as", $0D
	db "deleted information", $0D
	db "can not be restored.", 0

; ---- text $79CC-$7A12 (70 bytes) [CONFIRMED] English prompt index $04; $0D line breaks and final NUL.
PromptText_CheckingRegistration:: ; 65:79CC
	db "Confirm the information", $0D
	db "that was registered in", $0D
	db "the Mobile Adapter GB.", 0

; ---- text $7A12-$7A74 (98 bytes) [CONFIRMED] English notice index $17; $0D line breaks and final NUL.
NoticeText_ResumeRegistration:: ; 65:7A12
	db "The last registration", $0D
	db "process has not been", $0D
	db "finished yet.", $0D
	db $0D
	db "Press A to continue", $0D
	db "where you left off.", 0

; ---- text $7A74-$7B26 (178 bytes) [CONFIRMED] English notice index $15; $0D line breaks and final NUL.
NoticeText_UsageFeeIntro:: ; 65:7A74
	db "You will be billed once", $0D
	db "a month for Nintendo", $0D
	db "content consumed through", $0D
	db "Mobile System GB. This", $0D
	db "will let you view your", $0D
	db "current balance. More", $0D
	db "information in the", $0D
	db "instruction booklet.", 0

; ---- text $7B26-$7BBA (148 bytes) [CONFIRMED] English notice index $13; $0D line breaks and final NUL.
NoticeText_UsageTimeIntro:: ; 65:7B26
	db "This will let you check", $0D
	db "the amount of time spent", $0D
	db "on your DION Mobile", $0D
	db "GB Course plan.", $0D
	db "For more information,", $0D
	db "please refer to the", $0D
	db "instruction booklet.", 0

; ---- text $7BBA-$7C39 (127 bytes) [CONFIRMED] English notice index $12; $0D line breaks and final NUL.
NoticeText_PasswordChangeDone:: ; 65:7BBA
	db "Your password change", $0D
	db "will take effect in", $0D
	db "about five minutes.", $0D
	db "Please write down your", $0D
	db "new password and store", $0D
	db "it in a safe place.", 0

; ---- text $7C39-$7C64 (43 bytes) [CONFIRMED] English notice index $0D; $0D line breaks and final NUL.
NoticeText_PhoneChangeDone:: ; 65:7C39
	db "The phone number was", $0D
	db "updated successfully.", 0

; ---- text $7C64-$7CF0 (140 bytes) [CONFIRMED] English notice index $0B; $0D line breaks and final NUL.
NoticeText_DeleteDone:: ; 65:7C64
	db "All registration", $0D
	db "information was erased.", $0D
	db "If you want to use the", $0D
	db "device again, please", $0D
	db "register again.", $0D
	db "You can now safely", $0D
	db "turn off the power.", 0

; ---- text $7CF0-$7D70 (128 bytes) [CONFIRMED] English notice index $09; $0D line breaks and final NUL.
NoticeText_DeleteBeforeDisposal:: ; 65:7CF0
	db "Be sure to erase the", $0D
	db "registration information", $0D
	db "if your Mobile Adapter", $0D
	db "GB is going to be", $0D
	db "disposed of, or given", $0D
	db "to another person.", 0

; ---- text $7D70-$7E0D (157 bytes) [CONFIRMED] English notice index $08; $0D line breaks and final NUL.
NoticeText_DeleteRegistrationWarning:: ; 65:7D70
	db "This will erase all", $0D
	db "information stored on", $0D
	db "your Mobile Adapter GB", $0D
	db "and Mobile Trainer", $0D
	db "cartridge.", $0D
	db "Before you continue,", $0D
	db "please refer to the", $0D
	db "instruction booklet.", 0

; ---- text $7E0D-$7EA8 (155 bytes) [CONFIRMED] English notice index $07; $0D line breaks and final NUL.
NoticeText_UsageFeeWarning:: ; 65:7E0D
	db "While using the Mobile", $0D
	db "System GB service,", $0D
	db "calling charges and", $0D
	db "communication fees", $0D
	db "may occur.", $0D
	db "For more information,", $0D
	db "please refer to the", $0D
	db "instruction booklet.", 0

; ---- text $7EA8-$7F14 (108 bytes) [CONFIRMED] English notice index $05; $0D line breaks and final NUL.
NoticeText_Welcome:: ; 65:7EA8
	db "Welcome to the Mobile", $0D
	db "System GB!", $0D
	db $0D
	db "From today, you can", $0D
	db "receive email and access", $0D
	db "Nintendo's Mobile Home", $0D
	db "Page.", 0

; ---- text $7F14-$7FA3 (143 bytes) [CONFIRMED] English notice index $03; $0D line breaks and final NUL.
NoticeText_ReadTerms:: ; 65:7F14
	db "Please also read the", $0D
	db "terms and conditions", $0D
	db "listed in the DION", $0D
	db "Mobile GB Course", $0D
	db "registration form and", $0D
	db "the Mobile Adapter GB", $0D
	db "instruction booklet.", 0

; ---- text $7FA3-$8000 (93 bytes) [CONFIRMED] English notice index $01; $0D line breaks and final NUL.
NoticeText_HaveManualReady:: ; 65:7FA3
	db "Please keep the", $0D
	db "instruction booklet and", $0D
	db "the registration form", $0D
	db "from inside the package", $0D
	db "handy.", 0

ASSERT @ == $8000, "English registration text must end at the bank boundary"
POPC
