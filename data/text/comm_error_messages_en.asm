; English communication error messages; original Japanese slots and labels retained.
; [PROBABLE] Static layout only; runtime appearance and translation fidelity unvalidated.
SECTION "English communication error messages", ROMX[$7D96], BANK[$5C]
PUSHC sjis
CommErr_Msg_RegistrationPending_English:: ; 5C:7D96
	db "Your submitted", $0D
	db "registration form has", $0D
	db "not been processed yet.", $0D
	db "Please wait until", $0D
	db "this process has been", $0D
	db "completed.", 0

; [PROBABLE] Static password-character message layout; no new runtime evidence.
CommErr_Msg_NewPasswordBadChars_English:: ; 5C:7E06
	db "There are characters", $0D
	db "in the new password", $0D
	db "that can not be used.", $0D
	db "Please enter 4 to 8", $0D
	db "alphanumeric characters", $0D
	db "for your password.", 0

; [PROBABLE] Static eight-row login-cancellation layout; no new runtime evidence.
CommErr_Msg_LoginIdCancelled_English:: ; 5C:7E84
	db "Your Log-in ID has", $0D
	db "been deleted and", $0D
	db "can no longer be used", $0D
	db "to access the service.", $0D
	db "Please refer to the", $0D
	db "instruction booklet and", $0D
	db "contact KDDI customer", $0D
	db "service.", 0
POPC
