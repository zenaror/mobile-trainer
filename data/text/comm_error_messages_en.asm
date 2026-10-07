; English registration-pending error message; original Japanese slot and labels retained.
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
POPC
