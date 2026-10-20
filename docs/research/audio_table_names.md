# Nine audio-table aliases: retained identities and limits

This bounded pass retires nine generic aliases already colocated with existing table
names. It introduces no proper name and does not identify nine new executable entries.
The five audio owners match the source hashes of the earlier scout and were unchanged
by Q3. The base is the current captured owner hashes; the coordinator reports the
published parent acec66a9be1b349e8e4a9d92c7768cf714f3fec9 plus adopted Q3, pending
publication. That report is not replaced by an inferred new Git revision.

The position relationship is CONFIRMED by adjacent definitions and retained historical
linked symbols. Table layouts and code consumers were rechecked statically here.
This preserves the original evidence levels: dispatch/query tables remain PROBABLE;
the resource layouts retain their CONFIRMED evidence and per-field qualifications.
The song table's source header remains PROBABLE, while audio_format.md records prior
CONFIRMED evidence for its eight-byte record layout. Neither is silently promoted.

## Four lookup and dispatch tables

Table_SoundDrv_SfxTrackPtrs (04:449B) contains four words: D040, D07C, D0B8, D0F4.
They select the first four $3C-byte track records, the SFX group. GetPlayingId uses
base4499+2*A only for A=1..4, checks the selected record's bit7 and reads its word+6.
A=0 takes the music-query path and A>=5 selects BC=0 before gateway exit. Index 0 is
not a fifth table entry. The query stub has no demonstrated natural caller. The static table role does
not establish one or make banked WRAM independent of the selected bank.

Table_SoundDrv_ParamHandlers (04:44A3) has seven pointers; SetTrackParamCore rejects
A>=7 and tail-dispatches through JumpTable. Its parameter stub has no demonstrated
natural caller. Individual field roles and synthetic demonstrations remain as documented.
Table_SoundDrv_Commands (04:46E8) has 31 pointers for B1..CF, after notes>=D0 and wait
cases have branched separately. Table_SoundDrv_ExtCommands (04:4726) has 12 pointers;
CmdExtended rejects subcommands>=0C. Neither table name proves every handler's natural
execution, safe arbitrary byte streams or an ordinary independent-entry stack frame.
Existing running-status and note-off hazards remain unchanged.

## Five resource tables

Table_SoundDrv_Durations (04:5044) has 49 bytes of sequencer tick counts. Wait uses
opcode-80, with zero-wait bypass; ordinary notes use opcode-CF, held notes separate.
Table_SoundDrv_NoteFreq (04:5075) has 120 period16/step8 records. NoteToIndex subtracts
24h and clamps to 0..119 before a 3*index lookup. An injected direct lookup does not
inherit that clamp. These are pitch-setting records, with no new frequency or timing
experiment claimed.

Table_SoundDrv_Instruments (04:51DD) has 112 six-byte records. GetInstrumentPtr computes
51DD+6*index; normal instrument selection and per-note mode use this layout. Existing
data uses pitches 24h..2Fh for the per-note end records; arbitrary pitch/index values
are not proved safe. The existing note's distinctions between natural evidence,
synthetic demonstrations and PROBABLE field cases remain in force.
Table_SoundDrv_WavePatterns (04:547D) has 10 packed 16-byte patterns. The wave path
computes 547D+16*pattern and copies 16 bytes to FF30..FF3F. This role does not establish
safe arbitrary instrument classes, APU access timing, IRQ ownership or hardware behavior.

Table_SoundDrv_Songs (04:551D) has 70 eight-byte records, for ordinary ids 1..46h and 59
distinct stream headers. Eleven additional records reuse song1. The loader computes
5515+8*BC and reads header address/bank, priority, flags and track count. Its own guard
checks B=0 and C<47h but not C!=0; PlaySfx/PlayMusic handle BC=0 before calling it. Do not
generalize ordinary-ID behavior to direct injected BC=0, rejected entries or arbitrary
record values. Extra stream-header pointer sets and after-jump tails retain their
existing unused/static qualifications (audio_format.md section3.2).

All these readers require the expected ROM04 mapping and the known gateway's WRAM1
context, coherent shadows and visible noncorrupting stack. A prior caller invariant,
name or trace corpus does not establish arbitrary injected-entry, interrupt or mapper
safety. No RAM equate, record layout, handler operand or instruction changes here.

## Current references and historical evidence

Nine alias definition lines become blank lines. There are no active operands using
these nine generic names, no qualified references and no locals under their scopes.
Eight old-name comment occurrences occupy seven lines in audio/engine.asm. Six lines
now use Table_SoundDrv_ParamHandlers while retaining their targets/index evidence;
the shared table comment uses exact 04:44A3/46E8/4726 addresses. All seven edited comments
fit 100 columns with tabs counted as 4, and surrounding evidence/terminators stay intact.

Only four optional replay proof/context references change, in ramop10_manual.tsv
rows 304..307 column 9: the source identity at 04:449B follows its retained table name.
Their file/line/address/evidence fields stay fixed. Physical rows are preserved, so
there is no source-line remap. Frozen config and historical rename/coverage receipts
are not rewritten. The two unrelated generic handler targets in command tables remain
part of their own pending cohort; this pass does not invent replacement semantics.

The retained historical symbol input and Q3's sealed predicted map agree on all nine
positions. Removing these aliases predicts a delta of -9 only, with every remaining
name/address pair preserved: Q3 prediction 14921 ->14912. This is a prediction, not a
current linked result. No live build or log was read. The coordinator must independently
review, rebase if another pass is adopted, build and compare to the original before
claiming byte identity. English remains suspended. No native gate ran in this proposal.

## Old/current position map

| Old alias | Retained identity | Bank:address |
|---|---|---|
| `Data_04_449B` | `Table_SoundDrv_SfxTrackPtrs` | 04:449B |
| `Table_04_44A3` | `Table_SoundDrv_ParamHandlers` | 04:44A3 |
| `Table_04_46E8` | `Table_SoundDrv_Commands` | 04:46E8 |
| `Table_04_4726` | `Table_SoundDrv_ExtCommands` | 04:4726 |
| `Data_04_5044` | `Table_SoundDrv_Durations` | 04:5044 |
| `Data_04_5075` | `Table_SoundDrv_NoteFreq` | 04:5075 |
| `Data_04_51DD` | `Table_SoundDrv_Instruments` | 04:51DD |
| `Data_04_547D` | `Table_SoundDrv_WavePatterns` | 04:547D |
| `Data_04_551D` | `Table_SoundDrv_Songs` | 04:551D |

## Errata de contexto físico: CTX17 (2026-10-17)

O primeiro PRIVATE31 revelou quatro skips Audio9 no ordinal29, apesar de RC0:
288 already/12 skipped, contra292/8 de Q3. A revisão anterior conferiu a coluna
alterada, mas não a comparação física exata. `ctx` usa linhas806/807/808;
a properalias está em805 e806 foi preservada vazia. Rows304..307 de ramop10
devem portanto ter vazio no primeiro componente ctx, sem mudar proof, operand,
bank, proposed text, disposition ou linha807. Os outros dois componentes ficam
intactos. A tool não procura a linha não vazia anterior.

O inventário completo das tabelas9/10/11 encontrou também13 contextos LIB
introduzidos pelo passe Function516:8 em ramop10 e5 em ramop11. CTX17 corrige
17 células (13LIB+4Audio) pela mesma operação. CTX12 anterior é uma proposta
parcial preservada, não reparo completo. O censo é594manual=156+300+138;
há um ctx opcional vazio em ramop10, preservado. Previsões dos ordinais28/29/30:
156 already/0 skipped;300 already/0 skipped;138 already/0 skipped, respectivamente.
São previsões estáticas, pendentes da nova bateria ROOT e guardas de log literal.
Não mudam norm/loose/guards, fonte ASM, mapas, bytes ou nomes. O aceite v1 fica
limitado ao protocolo que conferiu e não autoriza adoção com a regressão de replay.
