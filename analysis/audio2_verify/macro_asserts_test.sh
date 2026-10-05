#!/bin/sh
# V2.5: which misuses of the sound macros does the assembler refuse?  Assembles one-line test sources with the project flags (-P includes.asm).
# Run from the repository root.  Output: one line per case: expected behaviour and the assembler's verdict (rc 0 = accepted).
T=build/macrotest
run() {  # run "label" "source lines"
  printf 'SECTION "t", ROM0\n%s\n' "$2" > $T/t.asm
  if rgbasm -Weverything -P includes.asm -I . -o $T/t.o $T/t.asm >$T/out.txt 2>&1; then v=ACCEPTED; else v=REFUSED; fi
  printf '%-58s %s\n' "$1" "$v"
}
run "sound_wait 3 (table value)"                         "sound_wait 3"
run "sound_wait 25 (not in the duration table)"          "sound_wait 25"
run "sound_rs sound_wait 3 (opcode < \$BE)"              "sound_rs sound_wait 3"
run "sound_rs sound_note 3, \$40 (opcode >= \$BE)"       "sound_rs sound_note 3, \$40"
run "sound_rs sound_rs sound_note 3 (nested)"            "sound_rs sound_rs sound_note 3"
run "sound_note 25 (duration not in table)"              "sound_note 25, \$40"
run "sound_note 3, \$10 (pitch operand < \$24: driver reads it as a VOLUME byte)" "sound_note 3, \$10"
run "sound_note 3, \$40, \$25 (volume operand >= \$20: driver reads it as pitch/adjust)" "sound_note 3, \$40, \$25"
run "sound_note 3, \$80 (operand with bit 7: driver reads it as an opcode)" "sound_note 3, \$80"
run "sound_note_off \$10 (below \$24: not taken as a pitch byte by the driver)" "sound_note_off \$10"
run "sound_instr_pulse2 4, 0, \$FB, \$7F, \$3C (duty 4)"  "sound_instr_pulse2 4, 0, \$FB, \$7F, \$3C"
run "sound_instr_wave 48, ... (class past \$3F)"          "sound_instr_wave 48, 0, \$FB, \$7F, \$3C"
run "sound_instr_wave 10, ... (pattern 10 does not exist: only 0-9)" "sound_instr_wave 10, 0, \$FB, \$7F, \$3C"
run "sound_note_freq \$800, 1 (12-bit period)"            "sound_note_freq \$800, 1"
run "sound_stream_header 1 (wrong arg count)"             "sound_stream_header 1"
run "sound_loop with 1 arg"                               "sound_loop 3"
run "sound_pan \$90 (operand >= \$80, documented range 0-\$7F)" "sound_pan \$90"
run "sound_pitch_bend \$90 (>= \$80: formula 2v-\$80 no longer holds)" "sound_pitch_bend \$90"
