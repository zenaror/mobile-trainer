# ConnIcon: aliases estruturais PROBABLE e duas correções do cabeçalho

Proposta privada, 2026-10-18. Esta unidade retira quarenta coaliases genéricos
de `gfx/comm/connection_icon.asm`, preservando os nomes próprios já existentes:
uma paleta, uma tabela de objetos, seis listas de frames, 26 registros de frame e
seis scripts. O intervalo é `69:4760..4C46`, 1.254 bytes. Cada definição antiga
vira uma linha em branco na mesma posição; nenhum nome semântico novo é criado.
Os quarenta cabeçalhos dessas estruturas continuam **PROBABLE**.

O baseline lido já tem em branco os dois aliases CONFIRMED dos tiles retirados
na unidade anterior. As duas regiões CONFIRMED, seus arquivos e leitores ficam
intactos. Os 14 bytes de `Data_69_4152` também ficam intactos, com o nome neutro e
o cabeçalho heurístico PROBABLE: nem zeros nem a ausência de um consumidor
positivo neste estudo demonstram padding, inutilidade ou um papel gráfico.

A derivação própria foi selada antes da consulta ao estudo peer. Houve exposição
prévia à unidade ConnIcon2, aos resumos ROOT e à conclusão de um spot-check do
ABI; não se alega revisão cega. Fonte atual, macros e bytes originais foram
reconferidos. Nenhum helper do projeto, teste, build, emulador, render ou export
foi executado, e nenhum output ativo foi lido.

## Leitores e estrutura

`ConnIcon_LoadGraphics_Request1` (`69:4118`) chama `Palette_LoadToBuffer` em
`69:4147`: A=`69`, HL=`4760`, BC=`0018`, DE=`D860`. As 12 palavras RGB555 do
arquivo `conn_icon_palettes.pal` correspondem aos 24 bytes originais
`69:4760..4778`. O destino é `wPaletteBufObj+$20`, três paletas OBJ a partir da
posição 4 no buffer WRAM7; isto não prova cores ou imagem exibidas naturalmente.
Request2 usa outros recursos no banco51 e não pertence a esta coorte.

`ConnIcon_StartSprite` (`4E:604C`) guarda o estado A, aponta HL ao slot8
(`W7:DA80`), DE a `ConnIcon_ObjTable` (`69:4778`) e passa A=`69` a
`Sprite_InitSlot`, com B preservado nesse caminho. O vetor de argumentos/FarCall
em `4E:6057` confere com a ROM. Os seis setups literais no chamador69 usam os
pares (estado, B) `(1,1)`, `(2,2)`, `(2,6)`, `(4,4)`, `(5,5)`, `(5,5)`; seus bytes
também foram conferidos. Não se afirma que todos os índices de0 a6 tenham caller
resolvido. Entry0 duplica entry1; entry3 tem estrutura interna válida, mas nenhum
dos seis setups literais seleciona0 ou3. Isso não prova ausência de outros usos.

`Sprite_InitSlot` (`00:0A82`) seleciona o banco ROM recebido em A, zera os16bytes
do slot em WRAM7, guarda o banco no slot+E e passa B em A ao leitor de entrada.
Em `Sprite_LoadObjectEntry` (`00:0AB8..0AE8`), a leitura concreta corrige dois
fatos do cabeçalho antigo da tabela:

- O endereço é `DE+4*(B&$3F)`. O código faz AND `$7F`, mas os dois ADDs de8bits
  descartam carry antes de somar ao endereço. Isso não é um bounds check: a
  tabela ConnIcon tem sete entradas, não64 entradas garantidas.
- Word0 é guardado no slot+2/3; word1, o ponteiro do script, no slot+6/7. Depois
  script+1/+2 inicializam frame/delay em slot+4/+5. Slot+8 é o índice do script,
  +9/+A são máscaras OR/AND inicializadas em00/FF; o id original vai para+F.

O corpo de48bytes do leitor confere com a ROM original. A derivação factual
desses campos não promove os cabeçalhos PROBABLE dos dados nem reclassifica o
comentário geral HYPOTHESIS de layout presente no motor. Bit7 do id afeta a
política posterior de fim/loop e não aumenta a extensão desta tabela.

Os sete pares da tabela apontam para seis pares distintos lista/script no mesmo
banco. Todas as arestas terminam nos limites declarados: lista é uma sequência
de palavras sem contador, frame é `1+4*n` bytes e script é `1+2*n` bytes. As
macros foram lidas, e uma transcrição stdlib finita reconstruiu os43blocos e os
2.804bytes do owner para comparação direta com a ROM. Isso é comparação dos
componentes deste owner, não reconstrução/validação da ROM inteira.

`Sprite_UpdateAll` seleciona o banco registrado antes de processar o slot.
`Sprite_StepAndDrawSlot` lê os pares frame/delay e os registros OAM; o caminho
de desenho soma Y+16/X+8 módulo256 e aplica as máscaras de atributo do slot.
Mapper, WRAM7, scratch/FarCall, hooks que trocam bancos, IRQ e reentrada continuam
condições do motor existente, não uma ABI universal ou uma nova garantia de
concorrência. Não se atribui identidade visual, glifo ou êxito natural da tela.

## Limites preservados

As listas incluem `ConnIcon_Anim1Frame4..7` e `ConnIcon_Anim2Frame4`, mas os
scripts associados não selecionam esses cinco índices. Sua associação estrutural
permanece PROBABLE; o fato finito não significa que os registros sejam inutilizados.
`ConnIcon_Anim3Script` conserva o byte final00 em `69:4A04`, e
`ConnIcon_ObjAnimData` conserva010004 em `69:4BA8..4BAB`. As finalidades dessas
caudas continuam desconhecidas. Nenhum byte, contagem, ponteiro ou operando muda.

No corpus de fonte/metadados declarado pelo pacote privado, não há operandos
ativos dos40nomes antigos nem locais dependentes deles. As12referências de
comentário ao nome antigo da tabela passam para `ConnIcon_ObjTable`; o restante
das notas históricas e dos qualificadores fica. Catálogo e screen_ops já usam
os nomes próprios; não precisam de edição. Configuração, geradores e evidências
históricas permanecem congelados.

O owner mantém562linhas. Seus83globais passam a43 nesta projeção local:
42nomes próprios e o neutro KEEP. O delta de símbolos previsto é somente-40 sobre
o parent que ROOT conferir futuramente; não há total publicado futuro presumido.
Não mudam caminhos, assets, paletas, PNGs, macros, catálogo ou idiomas. Somente
uma integração posterior, com revisão e verificações ROOT, poderá confirmar
equivalência do build e o delta real de símbolos.
