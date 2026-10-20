# Coaliases dos oito handlers de teste de bits

Data: 2026-10-18. Proposta privada original de retirar oito labels genéricos
`Label_63_*` já acompanhados por `Font_ValidateSjisCode_TestBit0..7`. O owner
canônico é `engine/text/sjis_validity.asm`; não há arquivo de biblioteca alterado.
Cada linha de alias fica vazia no mesmo lugar. Nomes existentes, tabela,
instruções, destinos, comentários, status e linhas físicas são mantidos.

## Identidade e bytes

| Alias retirado | Nome retido | Intervalo banco63 | Operação |
|---|---|---|---|
| Label_63_403D | Font_ValidateSjisCode_TestBit0 | 403D..4043 | bit0 de C |
| Label_63_4043 | Font_ValidateSjisCode_TestBit1 | 4043..4049 | bit1 de C |
| Label_63_4049 | Font_ValidateSjisCode_TestBit2 | 4049..404F | bit2 de C |
| Label_63_404F | Font_ValidateSjisCode_TestBit3 | 404F..4055 | bit3 de C |
| Label_63_4055 | Font_ValidateSjisCode_TestBit4 | 4055..405B | bit4 de C |
| Label_63_405B | Font_ValidateSjisCode_TestBit5 | 405B..4061 | bit5 de C |
| Label_63_4061 | Font_ValidateSjisCode_TestBit6 | 4061..4067 | bit6 de C |
| Label_63_4067 | Font_ValidateSjisCode_TestBit7 | 4067..406D | bit7 de C |

Cada handler ocupa seis bytes e três instruções: `bit n,c`,
`jr z,Font_ValidateSjisCode_Invalid`, `jr Font_ValidateSjisCode_Valid`.
O índice n determina o opcode CB41+8*n; os deslocamentos relativos foram
calculados a partir dos endereços de instrução, com destino63:4072 para bit
limpo e63:406D para bit definido. No último handler o segundo JR tem deslocamento
zero: continua sendo um salto para Valid, e o opcode não é removido.

As48 bytes63:403D..406D foram comparadas à ROM original por handler. A tabela
`Font_SjisBitJumpTable`/`Table_63_402D`,63:402D..403D, tem oito words little
endian, na ordem403D,4043,4049,404F,4055,405B,4061,4067. As16 bytes da tabela
também conferem com a ROM. Os oito `dw` das linhas49..56 já usam os nomes
retidos: nenhum operando precisa mudar, e o alias neutro da tabela é preservado.

A mecânica de opcode, branch e co-localização é `CONFIRMED`. Os oito nomes já
tinham CONFIRMED no histórico `analysis/naming2/label5_renames_pkgA.tsv`, linhas
27..34; seus relatos de traces e de interpretador são história preservada,
não execuções repetidas neste passe. O comentário CONFIRMED existente sob o
primeiro handler, o cabeçalho CONFIRMED da tabela e todos os demais níveis
permanecem exatamente iguais, sem promoção de significado.

## Contrato das entradas da tabela

O chamador existente salva AF, BC, DE e HL nessa ordem antes do dispatch. Ele
forma o índice de tabela com os três bits baixos do L de entrada (`L & 7`),
lê um byte para C e escolhe um dos oito words do próprio banco63. O dispatch é
`jp hl`, não um farcall separado nem um novo frame de retorno por handler.
Esta proposta não altera esse cálculo nem tenta substituir o endereço imediato
da base de bitmap por um nome novo.

Os tails foram comparados à ROM: Valid63:406D..4072 executa `pop hl/de/bc/af;ret`.
Invalid63:4072..407A restaura os mesmos quatro pares, depois põe HL=$81A1 e
retorna. Nesse caminho BC/DE/AF são os valores salvos; o teste de bit não retorna
seu flagZ porque AF é restaurado. Na saída Valid, HL é o valor salvo; na Invalid,
HL recebe o substituto81A1. O retorno exige a disposição de pilha do chamador e
seu endereço de retorno. Entrada direta com pilha arbitrária não ganha aqui um
ABI seguro nem um novo significado de função pública.

A tabela contém endereços do mesmo banco. A prova não autoriza tratá-la como
ponteiros para banco arbitrário nem afirma restauração universal de mapper,
interrupções ou estado externo. A condição explícita de banco63 e de frame de
pilha do chamador é mantida.

## Censo finito e KEEP

O censo atual de ASM/INC dos seis roots, ram, constantes e topo encontrou24
registros relevantes: oito definições genéricas, oito definições retidas e oito
operandos `dw` retidos. Não há operando ativo dos oito nomes antigos nem label
local no owner. Esvaziar somente as linhas59,66,72,78,84,90,96,102 preserva os
escopos e todas as outras linhas. Nenhuma célula de catálogo/screen_ops ou de
contextos operacionais ramop9/10/11 usa os aliases antigos selecionados. Não há
edição de configuração, metadados ou catálogo nesta proposta; os registros
históricos de nomeação ficam como proveniência.

`data/fonts/sjis_valid_bitmap.asm` permanece fora da mudança:8198 bytes em
63:407A..6080, coalias `Data_63_407A` retido e cabeçalho heurístico `PROBABLE`
que ainda fala em tile data. A leitura mecânica do chamador não promove o tipo,
a finalidade completa desse bitmap nem a correção integral da validação
Shift-JIS. O nome existente Font_ValidateSjisCode não substitui essa prova.
Nenhum byte do bitmap, fonte gráfico, asset ou PNG foi modificado ou renderizado.

O scout residual tinha outros aliases com locais e referências antigas ativas,
além de dez endpoints RET com entrada/finalidade incerta. Eles continuam fora
deste passe. Não se aplica uma retirada automática aos501 coaliases do scout,
nem se confunde label local/dado com função desconhecida. A busca é finita e
literal: não prova ausência universal de ponteiros empacotados, aritmética de
endereços, consumidores externos ou entradas dinâmicas.

## Adoção separada

O saldo isolado previsto é-8 globais e zero nomes novos, locais, constantes ou
endereços. Não se fixa total absoluto de SYM nem parent futuro. A comparação
estática de64 bytes e dos tails não é uma reconstrução completa da ROM; os gates
posteriores e a revisão independente pertencem ao ROOT. A proposta fica queued
depois de5510/Settings17/error10, sem alterar seus pacotes selados.

Não houve adoção, autoaceite, teste, import de helper, checker, compilação,
emulação ou prova de hardware. Apenas scripts próprios de análise estática
leram fonte/dados/ROM. Idioma e R4 continuam suspensos/estacionados. O ROOT deve
compor os docs vigentes em fase própria; README/REVERSE compartilhados não são
copiados neste pacote. Evidência privada: handler/tabela/tails e readset em
`.tmp/jp-sjis-bit-alias8-proposal-20261018/DATA/`.
