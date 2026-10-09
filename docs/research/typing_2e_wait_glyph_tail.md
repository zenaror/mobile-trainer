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

SOURCE6 privado4190 manifest550cb873; ROM2097152 SHA6d802e66; SYM5c83bce5; preseal56492e91. ROM-first registra192 guards; confronto posterior425 (617 registros, com duplicatas entre estágios). Scripts próprios stdlib leem apenas `/tmp` e não importam/rodam helpers estrangeiros. Nenhuma leitura actual, Git, native, captura nova, build, gate, rede ou OMM. Nenhum conteúdo de amostra pessoal.

Negativo preservado: a primeira versão do parser falhou ao encontrar bank `WRAM` em coverage; não emitiu fatos finais. A versão corrigida exclui explicitamente WRAM/HRAM do censo de endereços ROM. O script falho foi preservado. A primeira procura de fonte emengine/mail não localizou o arquivo; o caminho correto privado éengine/mail_server/tidy_screen.asm. Releitura do confronto após selar ROM-FIRST apenas ajustou seu guard de modo privado644 para444; bytes permaneceram iguais.


## Current private coherent implementation after54

Guarded private SOURCE4210 is preserved outside scope11: three owners/comments22 (6/10/6), RE/index append once and six new notes give SOURCE4216. All348 ASM/inc noncomment vectors and physical LOC,1248 TSVs/289 metadata,147 source.py timestamps, and4205 old outside files remain exact. No alias or emitted changes. Own125 raw bytes/64 CPU starts were sealed before historical reports were reread, with known historical27/2E authorship and current29-header context disclosed. All64 maintained emitters match; farcall inline6B are data. LCDOn7B has no WRAM selection; full27 prefix selects WRAM7 via Gfx082C after temporary saved-shadow restoration. Direct4EEB tail is different. Bank2E60calls is conditional on normal returns, not60frames;15B path has18F0 toRET4F99, not a looping sibling. Bank29 two leaves do not establish the entire742-byte library: selected-bank7BB7 has physical29padding1097B, and waitLY polls require a balanced callee return and may be unbounded. Purpose/entry remain HYPOTHESIS and mechanics PROBABLE with stack/mapping/IRQ/buffer prerequisites.

Historical packets and8596 private guard files were reread as old data, not new natural captures. Corpus69coverage/69data/50graphs remains finite,19missinggraphs unfilled; zero scoped observed rows and computed/raw references do not establish unreachable entries. Forced187/460 bank29 proof stays separate. The corrected ROOT preliminary WRAM7 attribution toLCDOn and historical2E counted-loop wording remain explicit. No sampled fields, hardware, emulator, fresh native capture or semantic asset audit.

One new private literal37 completed36rc0 plus ordinal27rc2/historicalschema exact97B, sole top-levelmake ordinal1. WholeROM IDENTICAL original; wholeSYM15538labels/51constants/MAP and all671 outputs equal private54. D334raw/10912rules exact;5623currentdependencybindings rebind the three owner SHA values with BEFORE4210/AFTER4216 distinct. Six notes receive this explicit documentation-only appendix after37; no code/output changes or rerun. Candidate stable for IND. ROOT/INDadoption, actual/published parent, canonical DOCrebase, actual integration, fresh checks, publication and future authority remain NULL. No actual/Git/OMM action.
