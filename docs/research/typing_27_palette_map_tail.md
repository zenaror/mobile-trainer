# Current private bank27 bounded header preparation after54

Current private scope11 after guarded bank54 SOURCE4210 (336d28d6): three owners,22 existing comment rows (6/10/6), RE/index append once and six new notes give SOURCE4216. All4205 old files outside scope,348 ASM/inc vectors/LOC,1248 TSVs/289 metadata and147 source.py timestamps must remain exact. No aliases or emitted changes. Entry/purpose HYPOTHESIS; bytes are static evidence, mechanics PROBABLE conditional. Published/actual parent, ROOT/IND adoption, integration, fresh checks, publication and authority NULL. A new private literal37 will run only after own source/readback guards close; expected36rc0 plus ordinal27 historicalschema rc2/exact97B, outcomes currently NULL. No closed battery replay or foreign helper import/execution. Natural69/69/50 are closed historical data,19 missing graphs remain missing; no new capture, full-coverage or unreachable claim. No sampled fields/credentials, semantic Pokemon audit or hardware proof.

27:43+10 bytes/19+3 CPU starts; two3-byte farcall inline regions separate. Full prefix ultimately leaves WRAM7 because00:082C follows saved-shadow restoration. Direct4EEB tail only LCDOn/BC0/RET, without WRAM selection. Incoming A is overwritten by7; buffers are prerequisites, not constructed. JP4EBD enters tail and skips4EC0. Helper/family execution does not prove these entries. ROOT preliminary wording wrongly attributed WRAM7 toLCDOn; corrected before any source edit.

## Historical bounded research, preserved with its original phase

# Pesquisa limitada após a fila 75: 27:4EC0 / 27:4EEB

Resultado: conservar `Function_27_4EC0` e `Label_27_4EEB`. O mecanismo é PROBABLE por bytes e contratos dos helpers; a entrada e o papel de aplicação permanecem HYPOTHESIS. A pesquisa privada não implementa alterações nem autoriza execução/publicação.

## Fronteiras e referências

A ROM fixa demonstra uma cadeia de 53 bytes, `[27:4EC0,27:4EF5)`: prólogo de 19 bytes até 4ED3, continuação de 24 até 4EEB, final de 10 até 4EF5. O `ret` em 4EF4 separa a cadeia do início independente em 4EF5. O decodificador próprio limitado produz 22 operações lógicas, contando cada farcall como uma operação e seus três bytes inline como dados; isso não deve ser confundido com os contadores históricos que decodificam esses dados como instruções.

`27:4EBD` contém `C3 EB 4E`, único candidato direto confirmado pelo fonte para 4EEB. Esse salto pula fisicamente 4EC0; não é entrada para 4EC0. O final também segue o `call 00:082C` em 4EE8 por continuação normal. Varredura de todas as ASM privadas encontra somente definição de 4EC0, definição de 4EEB e o salto citado. Na ROM inteira, o word C0 4E tem 41 ocorrências e 31 precedentes com forma call/jp; nenhuma ocorrência está no banco27 ou fixo00. EB 4E ocorre uma vez, como operando do salto 4EBD. Nenhuma forma farcall `CD D1 06 target bank27`, carga imediata de par BC/DE/HL/SP ou JR de banco27 aponta para os candidatos. Matches de outros bancos e bytes sobrepostos não são callers de banco27 por si só.

Isso não exclui endereços calculados, tabelas codificadas, mudanças de banco/trampolim ou entradas externas. Callgraph não registra necessariamente cada salto absoluto ou fallthrough; sua ausência não prova inacessibilidade.

## Contrato estático de banco, memória e LCD

1. 4EC0 salva A em `hScratchA` ($FFF2), salva o espelho `hWRAMBank` ($FF8D) na pilha e escreve 7 no espelho e em rSVBK. A recarga intermediária do A original é sobrescrita por `ld a,7`; não atribuir ao input A uma escolha de tela demonstrada.
2. 4ECD chama `VBlank_WaitStartDI` 00:047A, depois prepara HL=$D800. O helper espera VBlank no caminho LCD ligado, com EI/HALT/DI, e pode atender áudio quando acorda tarde. Com LCD desligado pula a espera; não afirmar que sempre espera ou que sempre retorna com IME0 nesse caminho.
3. 4ED3 chama por farcall `Palette_UploadBuffer` 4F:404B: oito paletas BG (64 bytes de W7:$D800) e oito OBJ (64 de W7:$D840), por BCPS/OCPS. EI e `Sound_FrameService` seguem o upload. O farcall usa o trampolim inicializado e restaura a seleção ROM do chamador conforme contrato; os dados inline não são executados.
4. 4EDF..4EE3 restauram temporariamente o espelho antigo e rSVBK a partir do AF empilhado. Em 4EE6 A é recarregado de rLCDC; 4EE8 chama `Gfx_UploadBgMapBuffers` 00:082C. Esse helper força novamente espelho/rSVBK=7 e não desfaz essa seleção: transfere $240 bytes (18 linhas), não 1KiB completo, de W7:$D000 para VRAM0 e W7:$D400 para VRAM1, escolhendo mapa $9800/$9C00 pelo bit3 do LCDC recebido. Inclui espera de frame/HDMA e EI+serviço de áudio. `Sound_FrameService` conserva BC/DE/HL e restaura rSVBK a partir do espelho salvo; sua seleção temporária W1 não muda o espelho. Portanto o fluxo normal não promete retorno ao banco WRAM anterior: seleção final visível W7.
5. 4EEB chama `LCDOn` 00:05B6, que apenas seta rLCDC.bit7. Em 4EF1 BC=0, e 4EF4 retorna. Entrada direta no final não faz o upload nem a seleção W7: seu contrato limitado é LCD on/BC0/ret e depende de uma pilha de retorno válida e do trampolim. Não herda automaticamente os pré-requisitos do prólogo.

Pré-requisitos da cadeia completa: mapeamento de ROM27 coerente com espelhos de banco, trampolim farcall válido, pilha normal, buffers W7 já preparados e infraestrutura de interrupção/frame/HDMA válida. A cadeia não constrói esses buffers. Os helpers também alteram estado de frame/áudio; isto não é uma lista exaustiva de clobbers transitivos ou um teste de efeitos no hardware.

## Família e contrapontos

O prefixo completo de 43 bytes ocorre exatamente em 26:52AC, 27:4D06, 27:4DE3, 27:4EC0, 2B:54C9, 2C:74FD e 2D:4BD5. O prólogo de 19 bytes aparece em 25 pontos; isso identifica uma família de upload, sem provar uma finalidade única. As posições não rotuladas são offsets em regiões existentes; os símbolos precedentes registrados no JSON não inventam entradas novas. Nenhum dos sete prefixos foi executado neste corpus.

O `jp 27:4D31` em 4D03 pula o prólogo 4D06. A posição 4D31 teve 252 execuções em25 cenários, mas o final vivo ajusta WY, ativa outros bits LCDC, espera VBlank e faz fade; não é um twin do final de 10 bytes em 4EEB, que ocorre somente uma vez na ROM. Execução do final vivo ou dos helpers não confirma 4EC0/4EEB.

Refutações:

- “4EC0 desenha temporizadores/grandes dígitos”: a cadeia de 53 bytes não lê C2D4..C2D7 e termina antes de 4EF5. As leituras e formatação do bloco seguinte não atravessam o ret. O domínio de comunicação/tempo é contexto das regiões vizinhas, não papel provado deste ponto.
- “restaura o banco de WRAM anterior ao retornar”: restauração é temporária e 082C seleciona7 depois.
- “4EEB é equivalente ao final vivo de MailConnect_InitScreen”: os finais são diferentes; só a operação LCDOn e retorno BC0 são compartilhados.
- “dead/unreachable”: a ausência é limitada a este censo e não demonstra ausência universal de entradas calculadas.

## Corpus natural e confiança

Foram relidos por inteiro e comparados aos guards do preseal:69 arquivos coverage,69 dataaccess e50 callgraph naturais. Arquivos forced foram excluídos. Os19 cenários sem callgraph estão enumerados no JSON. Nenhuma instrução de `[4EC0,4EF5)` foi executada; nenhum `rom_read` intersectou esse intervalo; nenhum edge dos50 callgraphs entrou em4EC0 ou4EEB. Também zeraram4EBD,4D06,4D4E,4D81 e4EF5. Os helpers têm evidência positiva independente:082C=28.570,05B6=13.809 e4F:404B=254.453 execuções, cada um em68 cenários. Esses números descrevem somente o corpus aceito, sem replay novo e sem promover a cadeia candidata.

CONFIRMED: observações literais do corpus aceito e bytes medidos na cópia ROM guardada, com a distinção de que não são execução destes candidatos. PROBABLE: mecanismo estático e efeito composto sob os contratos citados. HYPOTHESIS: entrada de4EC0, entrada natural de4EEB e finalidade de aplicação. Nomes neutros preservados.

## Proposta concreta após75, sem implementação

Próximo escopo recomendado: fechamento documental destes dois pontos, com comentários limitados à cadeia53 e final10, sem renomes/aliases/instruções/dados/RAM novos. Uma ASM: `engine/mail/send_receive.asm`; documentação canônica: `REVERSE_ENGINEERING.md` e `docs/README.md`; duas notas futuras propostas: `docs/research/typing_27_palette_map_tail.md` e `docs/research/typing_27_verify_palette_map_tail.md` (scope5). Nenhum arquivo dessas notas foi criado no fonte.

Reformular os comentários existentes em4EC0/4ED3 e documentar4EEB para explicitar W7 final, fronteiraRET e entradaHYP; um verificador independente deve confrontar os guards ROM/SYM/corpus, esse contrato e o fonte atualizado após75. Preservar todos os labels atuais, arrays/formatters a partir4EF5, helperimplementations e tabelas históricas congeladas. Não expandir o patch para os seis irmãos ou aceitar a família como autorização de nomes.

Antes de qualquer materialização: fila75 fechada, ROOT seleciona nova base atual e scope finito, verificação independente, orçamento/LOC e timestamps privados/actual aferidos novamente; builds/gates e publicação dependem das fases e aprovações próprias. Não há configuração, produtor, lançamento, build, integração ou publicação autorizados por esta pesquisa. Todos os campos de ações futuras permanecem NULL.

## Proveniência e limites

Fontes: SOURCE6 privado4190 (manifest550cb873); ROM privada2097152 bytes SHA6d802e66; SYM privado5c83bce5; preseal56492e91. O JSON registra548 verificações de guardsFG6 dos inputs lidos, incluindo corpus e ASM privadas. Apenas código de auditoria próprio stdlib foi executado sobre dados privados. Nenhum helper importado/executado, nenhuma leitura actual, captura nova, Git, rede, native, build ou gate. Não contém dados pessoais de amostra.

Negativos preservados no JSON e no script inicial falho: hipótese inicial de69 callgraphs rejeitada por assert (há50); tentativas de caminhos de dataaccess/farcall/frame inexistentes corrigidas; resultados RG/nota históricos truncados não sustentam completude. As conclusões numéricas vêm da leitura guardada integral.


## Current private coherent implementation after54

Guarded private SOURCE4210 is preserved outside scope11: three owners/comments22 (6/10/6), RE/index append once and six new notes give SOURCE4216. All348 ASM/inc noncomment vectors and physical LOC,1248 TSVs/289 metadata,147 source.py timestamps, and4205 old outside files remain exact. No alias or emitted changes. Own125 raw bytes/64 CPU starts were sealed before historical reports were reread, with known historical27/2E authorship and current29-header context disclosed. All64 maintained emitters match; farcall inline6B are data. LCDOn7B has no WRAM selection; full27 prefix selects WRAM7 via Gfx082C after temporary saved-shadow restoration. Direct4EEB tail is different. Bank2E60calls is conditional on normal returns, not60frames;15B path has18F0 toRET4F99, not a looping sibling. Bank29 two leaves do not establish the entire742-byte library: selected-bank7BB7 has physical29padding1097B, and waitLY polls require a balanced callee return and may be unbounded. Purpose/entry remain HYPOTHESIS and mechanics PROBABLE with stack/mapping/IRQ/buffer prerequisites.

Historical packets and8596 private guard files were reread as old data, not new natural captures. Corpus69coverage/69data/50graphs remains finite,19missinggraphs unfilled; zero scoped observed rows and computed/raw references do not establish unreachable entries. Forced187/460 bank29 proof stays separate. The corrected ROOT preliminary WRAM7 attribution toLCDOn and historical2E counted-loop wording remain explicit. No sampled fields, hardware, emulator, fresh native capture or semantic asset audit.

One new private literal37 completed36rc0 plus ordinal27rc2/historicalschema exact97B, sole top-levelmake ordinal1. WholeROM IDENTICAL original; wholeSYM15538labels/51constants/MAP and all671 outputs equal private54. D334raw/10912rules exact;5623currentdependencybindings rebind the three owner SHA values with BEFORE4210/AFTER4216 distinct. Six notes receive this explicit documentation-only appendix after37; no code/output changes or rerun. Candidate stable for IND. ROOT/INDadoption, actual/published parent, canonical DOCrebase, actual integration, fresh checks, publication and future authority remain NULL. No actual/Git/OMM action.
