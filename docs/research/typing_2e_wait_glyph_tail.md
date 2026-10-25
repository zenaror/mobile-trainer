# Current private bank2E bounded header preparation after54

Current private scope11 after guarded bank54 SOURCE4210 (336d28d6): three owners,22 existing comment rows (6/10/6), RE/index append once and six new notes give SOURCE4216. All4205 old files outside scope,348 ASM/inc vectors/LOC,1248 TSVs/289 metadata and147 source.py timestamps must remain exact. No aliases or emitted changes. Entry/purpose HYPOTHESIS; bytes are static evidence, mechanics PROBABLE conditional. Published/actual parent, ROOT/IND adoption, integration, fresh checks, publication and authority NULL. A new private literal37 will run only after own source/readback guards close; expected36rc0 plus ordinal27 historicalschema rc2/exact97B, outcomes currently NULL. No closed battery replay or foreign helper import/execution. Natural69/69/50 are closed historical data,19 missing graphs remain missing; no new capture, full-coverage or unreachable claim. No sampled fields/credentials, semantic Pokemon audit or hardware proof.

2E:11B/7 starts and15B/7 starts. First makes60 calls if every VBlank_Wait returns, not60 frames with LCDoff. Second decrements C2EE once then CALL4FA9/JR4F99RET;18F0 is preserved and differs from33 siblings18F1. Glyph is existing C0A0, not newly loaded space; wrapper restores BCDEHL thenE+=6 withoutcarry, blitter can remap glyph/selectWRAM2/3. Input/stack/trampoline/coordinate/colour prerequisites limit mechanics.

## Historical bounded research, preserved with its original phase

# Pesquisa limitada pós75: 2E:4EB2 / 2E:4F9A

Recomendação: conservar os dois nomes neutros e corrigir futuramente o comentário de 4F9A. O mecanismo dos bytes pode ser descrito como PROBABLE; entrada/finalidade permanecem HYPOTHESIS. Nenhum patch, produtor, captura ou autorização foi criado.

## Derivação antes dos headers

A ROM e o SYM privados foram lidos e guardados antes de consultar os headers. O arquivo ROM-FIRST-FACTS registra esse estágio separado.

| ponto | intervalo | bytes | fluxo |
|---|---|---|---|
| 2E:4EB2 | [4EB2,4EBD) | 11 | B=$3C; pushBC; call0464; popBC; decB; JRNZ4EB4; RET4EBC |
| 2E:4F9A | [4F9A,4FA9) | 15 | A=[C2EE]; cp0; RETZ; decA; [C2EE]=A; call4FA9; JR4F99 |

Ambos são precedidos por RET:4EB1 e4F99. Não há fallthrough normal do código anterior para seus inícios. O salto4FA7 é **18 F0**, deslocamento -16: seu destino é4F99, não4F9A. A posição4F99 também contém RET. Assim, no caminho não zero,4F9A decrementa C2EE uma vez, desenha um glyph uma vez e retorna. Não é um loop atézero.

Cada corpo completo é único na ROM. A varredura raw encontrou2 ocorrências do word B24E e24 de9A4F, nenhuma em banco2E/fixo00. Não há candidato direto call/jp em banco2E/fixo00, JR de banco2E, carga imediata de par BC/DE/HL/SP ou farcall explícito bank2E que estabeleça entrada. A varredura de todas as ASM privadas encontra apenas as duas definições dos nomes; nenhum uso. Matches de outros bancos, dados e sobreposição de opcodes não provam callers. Entradas calculadas/codificadas ou fluxo externo permanecem não excluídos.

## Contrato de retorno, banco e RAM

**4EB2:** B começa em60 e termina0, sob retorno normal de cada chamada. PushBC/popBC em cada iteração preserva C e protege o contador B contra o callee. 00:0464 `VBlank_Wait` preserva AF, testa rLCDC.bit7, usa EI/HALT e espera `wVBlankFlag` ($C2DF) não zero quando LCD ligado, depois limpa o flag. Não chama `Sound_FrameService`. Com LCD desligado pula EI/HALT/espera, limpa o flag e retorna imediatamente. Portanto “60 chamadas ao helper” é preciso; “sempre60 frames/um segundo” não é. Espera com LCD ligado depende de infraestrutura de interrupções viva; o retorno da cadeia depende de pilha válida e de todas as chamadas retornarem. Não há seleção WRAM explícita na cadeia/helper. Interrupções e evolução de frame não foram reexecutadas nem exaustivamente auditadas aqui.

**4F9A:** se C2EE=0, retorna antes do blitter e não muda explicitamente seleção de WRAM. Caso contrário, decrementa o contador uma vez antes de chamar4FA9. Esse wrapper salva BC/DE/HL, prepara HL=$C0A0 e farcall7F:42C3 `Canvas_BlitGlyph`, restaura os três pares e avança somente E em6, com wrap de8bits; D não recebe carry. A seleção ROM2E é restaurada pelo contrato farcall/trampolim inicializado.

O input efetivo do blitter é o glyph já presente no buffer não bancado `$C0A0..$C0B8` (24 bytes/12 linhas), cores B/C apropriadas à tabela de remap (0..3), D=y e E=x com destino válido no canvas. O callee pode remapear o buffer de glyph em lugar, escreve máscaras C0D0/C0D1, seleciona WRAM2 e pode passar a WRAM3 no limiar/wrap das linhas. Não restaura o banco WRAM anterior. HL original do chamador é preservado pelo wrapper, mas não é o glyph usado. Não há carga de ASCIIspace neste candidato: dizer “blank” exige como pré-condição que C0A0 contenha o glyph apropriado. Estado válido de stack/trampolim/cores/coords/buffer é necessário para atribuir o efeito esperado; não foi produzido teste de input arbitrário nem lista completa de clobbers transitivos.

## Confronto dos headers e família

O header atual de4F9A já cita corretamente `jr -> ret at4F99`, mas o chama contraditoriamente “counted loop around ...4FA9”. Essa frase é refutada pelos bytes. Também chama4FA9 de PROBABLE apesar de o corpo atual estar marcadoCONFIRMED e ter710 execuções em7 cenários. Isso não promove a entrada4F9A. O manifest histórico `g3_apps_a_renames.tsv` chama4F9A de11bytes; o intervalo real é15. Manter esse arquivo congelado e registrar a correção em nova nota, sem reescrever histórico.

O prefixo de10bytes `FA EE C2 FE00 C8 3D EA EE C2` aparece34 vezes. Todos têm call seguido deJR. Os33 irmãos usam **18 F1** e voltam ao próprio início;4F9A é o único **18 F0** e pula ao RET anterior. Há27 irmãos com execução natural do prefixo (122.277 observações agregadas); seis outros não têm execução neste corpus. Isso confirma uma família observada de padding contado, mas o membro4F9A difere precisamente na aresta que cria o loop. Não aplicar seu propósito aos bytes divergentes nem “corrigir” F0 paraF1 na reconstrução da ROM. Entrada de4F9A continua HYPOTHESIS.

4EB2 é uma pequena cadeia de chamadas ao helper de espera e não pertence à mesma família estrutural de glyph. Seu corpo único não recebe automaticamente o nome de uma rotina de atraso usada pela aplicação.

## Evidência natural e limites

Guardados e lidos integralmente:69 coverage,69 dataaccess e50 callgraph naturais; forced excluídos. Os19 cenários sem callgraph estão enumerados no ROM-FIRST-FACTS. Zero execução em ambos os intervalos, zero rom_read intersectando esses corpos e zero edge observado nos50 callgraphs para seus inícios. Isso é ausência limitada, não prova de inacessibilidade universal nem de ausência de entradas computadas nos19 sem graph.

Evidência positiva independente:4EB1=34 e4EBD=34,4F06=102,4F99=102,4FA9=710, todos em7 cenários. 0464=726.209 em56 cenários;7F:42C3=529.891 em59. O RET anterior e helpers vivos ajudam a separar a cadeia candidata; não constituem execução dela. Os números dos headers antigos são históricos, não o censo69 atual.

CONFIRMED: observações do corpus aceito e comparação literal dos bytes privados. PROBABLE: contrato estático condicionado descrito acima. HYPOTHESIS: entrada e finalidade dos dois candidatos. Nenhuma promoção de nome, execução sintética, hardware ou natural flow ocorreu.

## Escopo prospectivo, após fechar a fila atual

Prioridade recomendada para legibilidade: corrigir a contradição de4F9A e qualificar LCD/retorno de4EB2, antes de qualquer tentativa de dar propósito aos nomes. Escopo5 proposto: `engine/mail_server/tidy_screen.asm`, `REVERSE_ENGINEERING.md`, `docs/README.md` e duas novas notas futuras `docs/research/typing_2e_wait_glyph_tail.md` / `docs/research/typing_2e_verify_wait_glyph_tail.md`. Nenhuma dessas notas foi criada no fonte.

A mudança deve ficar em comentários/documentação, preservando nomes, bytes18F0, instruções/dados/aliases/RAM/config/manifest congelado. Os33 irmãos são evidência de comparação; não fazem parte do patch. Após75 fechado, ROOT deve escolher base atual, revalidar guards/LOC/escopo e encaminhar revisão independente. Materialização, builds/gates, integração e publicação pertencem às fases próprias; estão todosNULL neste pacote.

## Proveniência

SOURCE6 privado4190 manifest550cb873; ROM2097152 SHA6d802e66; SYM5c83bce5; preseal56492e91. ROM-first registra192 guards; confronto posterior425 (617 registros, com duplicatas entre estágios). Scripts próprios stdlib leem apenas `/tmp` e não importam/rodam helpers estrangeiros. Nenhuma leitura actual, Git, native, captura nova, build, gate, rede. Nenhum conteúdo de amostra pessoal.

Negativo preservado: a primeira versão do parser falhou ao encontrar bank `WRAM` em coverage; não emitiu fatos finais. A versão corrigida exclui explicitamente WRAM/HRAM do censo de endereços ROM. O script falho foi preservado. A primeira procura de fonte emengine/mail não localizou o arquivo; o caminho correto privado éengine/mail_server/tidy_screen.asm. Releitura do confronto após selar ROM-FIRST apenas ajustou seu guard de modo privado644 para444; bytes permaneceram iguais.


## Current private coherent implementation after54

Guarded private SOURCE4210 is preserved outside scope11: three owners/comments22 (6/10/6), RE/index append once and six new notes give SOURCE4216. All348 ASM/inc noncomment vectors and physical LOC,1248 TSVs/289 metadata,147 source.py timestamps, and4205 old outside files remain exact. No alias or emitted changes. Own125 raw bytes/64 CPU starts were sealed before historical reports were reread, with known historical27/2E authorship and current29-header context disclosed. All64 maintained emitters match; farcall inline6B are data. LCDOn7B has no WRAM selection; full27 prefix selects WRAM7 via Gfx082C after temporary saved-shadow restoration. Direct4EEB tail is different. Bank2E60calls is conditional on normal returns, not60frames;15B path has18F0 toRET4F99, not a looping sibling. Bank29 two leaves do not establish the entire742-byte library: selected-bank7BB7 has physical29padding1097B, and waitLY polls require a balanced callee return and may be unbounded. Purpose/entry remain HYPOTHESIS and mechanics PROBABLE with stack/mapping/IRQ/buffer prerequisites.

Historical packets and8596 private guard files were reread as old data, not new natural captures. Corpus69coverage/69data/50graphs remains finite,19missinggraphs unfilled; zero scoped observed rows and computed/raw references do not establish unreachable entries. Forced187/460 bank29 proof stays separate. The corrected ROOT preliminary WRAM7 attribution toLCDOn and historical2E counted-loop wording remain explicit. No sampled fields, hardware, emulator, fresh native capture or semantic asset audit.

One new private literal37 completed36rc0 plus ordinal27rc2/historicalschema exact97B, sole top-levelmake ordinal1. WholeROM IDENTICAL original; wholeSYM15538labels/51constants/MAP and all671 outputs equal private54. D334raw/10912rules exact;5623currentdependencybindings rebind the three owner SHA values with BEFORE4210/AFTER4216 distinct. Six notes receive this explicit documentation-only appendix after37; no code/output changes or rerun. Candidate stable for IND. ROOT/INDadoption, actual/published parent, canonical DOCrebase, actual integration, fresh checks, publication and future authority remain NULL. No actual/Git action.


## Operation alias for the counted wait calls (2026-10-15)

`CallVBlankWait60Times` is a PROBABLE operation alias for `Function_2E_4EB2`. The original 11 bytes are `06 3C C5 CD 64 04 C1 05 20 F8 C9`: initialize B to 60, preserve BC around each call to fixed ROM0 `VBlank_Wait` at 00:0464, decrement B, repeat until zero, then return. The neutral definition stays on its existing physical line, and the local `.loop` remains scoped to that neutral label. This names the operation only; entry and application purpose remain HYPOTHESIS.

Positive family evidence comes from the existing original ROM and natural coverage:

- `27:4691..469B` in `engine/mail/send_receive.asm` has `06 78 C5 CD 4B 04 C1 05 20 F8`. Against the candidate's first ten bytes, only the initial count (120 instead of 60) and call target (00:044B instead of 00:0464) differ. Its five-start push/call/pop/decrement/back-edge loop has the same exact shape and branch displacement. It is inside `MailConnect_Screen`, after a palette fade and LCDC update, before the screen path returns. `traces/coverage_fuzz_browser2.tsv:6124-6132` records initialization once, each loop start 120 times, and the following three starts once. The 044B helper additionally calls `Sound_FrameService`; that effect does not belong to 0464 or this candidate.
- `2A:4056..4066` in `engine/address_book/save_sender_address.asm` has `06 3C C5 CD D1 06 56 09 00 CD 64 04 C1 05 20 F2`. It uses the same count and wait helper but also farcalls `Sprite_UpdateAll` inside each iteration, so its back-edge displacement is F2 instead of F8. The loop follows the successful save-to-slot branch and its display update, and precedes split-screen shutdown and a palette fade. `traces/coverage_mail_inbox.tsv:6756-6763` records initialization and the next instruction after the loop once, and each of its six loop starts 60 times. The sprite update and this consumer context are not effects or a purpose assigned to 2E:4EB2.

These are executed structural relatives, not equivalent complete entries. Their recorded instruction counts establish observations in those historical scenarios; they do not establish natural entry or a caller of 2E:4EB2. The candidate's static contract requires a valid nonaliasing stack, normal returns from every call and no interrupt interference that invalidates the saved counter. BC is protected around each call; ordinary final B is zero and C is preserved. The helper preserves AF, but DEC B changes the final flags. Neither this loop nor 0464 explicitly selects WRAM. Relevant interrupt infrastructure and any transitive interrupt effects remain prerequisites rather than arbitrary-state guarantees.

With LCD disabled, 00:0464 skips EI/HALT/waiting, clears `wVBlankFlag` and returns immediately. With LCD enabled it relies on interrupt progress, waits for the flag and clears it. Therefore the alias promises 60 helper calls conditional on their return, not 60 frames or one second. No new runtime or hardware observation is supplied. Reconstruction equivalence requires the documented build, symbol check and byte comparison against the original ROM; static byte and source correspondence alone do not establish that result.


## One current glyph with an explicit jump to RET4F99 (2026-10-15)

`BlitOneGlyphIfCellsLeft_JumpToRet4F99` is a PROBABLE local-operation alias for `Function_2E_4F9A`, preserving that neutral definition. The alias occupies the formerly blank line534; the neutral label535 and all instruction/locator positions remain. Existing HYPOTHESIS qualifications concern entry, caller and application purpose; the descriptive operation name does not promote them. The earlier neutral-name recommendations remain historical. This operation does not acquire a padding, blank-space or loop purpose.

The immutable2097152-byte original ROM has SHA-256 `6d802e66b54f700aa8c767dd4a3b9df200bae05e07a296fffb16ebf4efc76570`. Physical offset0xB8F9A contains the candidate15 bytes/seven CPU starts in[2E:4F9A,4FA9): `FA EE C2 FE 00 C8 3D EA EE C2 CD A9 4F 18 F0`. The source is `engine/mail_server/tidy_screen.asm:541..547`. With C2EE=0 it returns at4F9F before the wrapper. With C2EE nonzero it decrements and stores once, calls4FA9, then executes JR4FA7=18F0. The branch target is4F99, whose original byte is C9/RET, not4F9A. Normal sequential flow therefore performs at most one wrapper call, not a loop until zero.

### Executed prefix and exact wrapper comparison

The sibling at24:49DD..49EC exclusive (`engine/browser/page_list.asm:1325..1331`) is `FA EE C2 FE 00 C8 3D EA EE C2 CD EC 49 18 F1`. Its first ten bytes match exactly; its CALL goes to24:49EC, whose complete20-byte wrapper is identical to2E:4FA9. Its final18F1 instead returns to49DD, creating the loop absent in the candidate. Existing `analysis/coverage_union.tsv:12483..12489` records12677 hits/9 scenarios at the LOAD/CP/RET-Z starts and11982/9 at DEC/store/CALL/JR. These observations demonstrate the sibling's paths, not candidate entry or a candidate loop.

The complete wrapper bytes at2E:4FA9..4FBD and24:49EC..4A00 are `C5 D5 E5 21 A0 C0 CD D1 06 C3 42 7F E1 D1 C1 3E 06 83 5F C9`. Both have twelve CPU starts; the three inline farcall operand bytes are data. The candidate's helper body is `engine/mail_server/tidy_screen.asm:553..564`. Every start has existing710 hits/7 scenarios in `analysis/coverage_union.tsv:33584..33595`; the exact24 wrapper has12941/9 at every start, lines12490..12501. These are complete-wrapper positives and aggregate helper counts, not temporal attribution of helper executions to4F9A. RET4F99 has102/7 at line33583 from observed surrounding paths; that does not establish the candidate's branch execution.

A preliminary comparison incorrectly supposed that2D:4FFE was also an identical wrapper. Direct original-byte comparison refutes that supposition:2D:4FFE first saves BC/DE/HL, then explicitly sets B2/C0 and calls7F:42CA (`Canvas_BlitGlyphNoRemap`);2E:4FA9 leaves B/C as supplied and calls7F:42C3 (`Canvas_BlitGlyph`, with color remap). The positive exact-wrapper comparison used here is24:49EC. The related2D:4FDB prefix still has18F1 and loops, but neither its forced colors nor its no-remap consumer is inherited by the candidate.

### Conditional return and effects

On the zero path, A=0 and CP0 leaves Z1/N1/H0/C0; BC/DE/HL remain unchanged by the local instructions, with no local counter store or blitter call. This path does not explicitly select WRAM.

On the nonzero path, C2EE is decremented once before the CALL. The wrapper saves BC/DE/HL, sets HL=C0A0 and invokes7F:42C3, then restores those pairs and performs LD A,6; ADD A,E; LD E,A; RET. Under normal nonaliasing execution, the final E and A are(E_initial+6) modulo256, D receives no carry, BC/HL/D retain their saved values, and final flags are those of the8-bit ADD (Z for the sum, N0, H/C for that addition). The result is not a count or Boolean status. JR preserves those flags and reaches RET4F99.

The glyph comes from the already prepared fixed-WRAM bufferC0A0..C0B7 (24 bytes/twelve rows), not from a new ASCII-space load. HL supplied by the caller is saved but is not the glyph pointer used. The blitter can remap that glyph in place, writes C0D0/C0D1 masks, and selects WRAM2 or3 for canvas data without restoring the old WRAM bank. Appropriate B/C colors0..3, D=y/E=x, complete glyph and valid canvas destination are prerequisites. Saying blank-space would require a separately prepared matching glyph and is not supplied by this alias.

The conditional operation assumes coherent ROM2E fetching, initialized farcall/trampoline mapping, a valid ordinary nonaliasing return stack, appropriate buffers/coordinates/colors and no relevant IRQ/mapper interference. Read/modify/write of C2EE and the color-remap operation have no atomicity guarantee. Arbitrary stack/input aliasing or transitive effects are not covered by a universal register/memory ABI. Existing RAM-name confidence is unchanged. There is no new natural execution, caller, rendering or hardware result; entry/caller/application purpose remain HYPOTHESIS. Static source and byte correspondence alone is not reconstruction equivalence.
