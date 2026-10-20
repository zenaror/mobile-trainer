# Coaliases redundantes de recursos básicos das telas de erro

Data: 2026-10-18. Proposta privada original de retirar dez aliases genéricos
`Data_*` em `gfx/error/comm_error_screen.asm` e `gfx/error/no_adapter.asm`.
Os dez nomes descritivos já existem e ficam; os dez cabeçalhos `CONFIRMED`
são herdados sem promoção. A edição deixa vazia cada linha do alias e não
altera linhas físicas, locais, dados, operandos, arquivos de assets ou caminhos.
É uma unidade de recursos de tela, não um censo de funções desconhecidas.

## Identidades e consumidores delimitados

A existência do nome não serve sozinha como prova. Cada recurso foi ligado ao
carregamento literal com banco/argumentos e comparado à ROM original. Os dois
mapas têm índices e atributos contíguos de360+360 bytes; as duas paletas são
32 wordsRGB555/64 bytes; as outras seis fontes são tiles carregados por HDMA.

| Alias retirado → nome retido | Banco e intervalo semiaberto | Bytes | Chamadas e contrato |
|---|---|---:|---|
| `Data_5C_57E6` → `CommErr_Tilemap_CommTimer` | 5C:57E6..5AB6 | 720 | 5C:52B7; BC=$1214 → wScreenTileMap/WRAM7:D000,D400 |
| `Data_5C_5AB6` → `CommErr_Tilemap_Plain` | 5C:5AB6..5D86 | 720 | 5C:52FB, 5C:53AC; BC=$1214 → wScreenTileMap/WRAM7:D000,D400 |
| `Data_5C_5D90` → `CommErr_Gfx_Obj8000` | 5C:5D90..5DB0 | 32 | 5C:5194; C=$02, DE=$8001 → VRAM1:$8000 |
| `Data_5C_5DB0` → `CommErr_Gfx_Obj8100` | 5C:5DB0..5DD0 | 32 | 5C:51A6; C=$02, DE=$8101 → VRAM1:$8100 |
| `Data_5C_5DD0` → `CommErr_Gfx_Bg9000` | 5C:5DD0..61D0 | 1024 | 5C:51B8; C=$40, DE=$9001 → VRAM1:$9000 |
| `Data_5C_61D0` → `CommErr_Gfx_Bg9400` | 5C:61D0..6350 | 384 | 5C:51CA; C=$18, DE=$9401 → VRAM1:$9400 |
| `Data_5C_6350` → `CommErr_Palette_BgTimer` | 5C:6350..6390 | 64 | 5C:52E1; BC=$0040 → wPaletteBufBg/WRAM7:D800 |
| `Data_63_64C0` → `NoAdapter_Gfx_8C00` | 63:64C0..68C0 | 1024 | 63:7389; C=$40, DE=$8C01 → VRAM1:$8C00 |
| `Data_63_68C0` → `NoAdapter_Gfx_9000` | 63:68C0..6CC0 | 1024 | 63:739B; C=$40, DE=$9001 → VRAM1:$9000 |
| `Data_63_7290` → `NoAdapter_Palette_Bg` | 63:7290..72D0 | 64 | 63:73BE; BC=$0040 → wPaletteBufBg/WRAM7:D800 |

O recurso Plain tem dois leitores do mesmo intervalo. O segundo,53AC, está no
ramo `Label_5C_53A1`/`CommErr_FindRecord_NotFound` cujo código mantém anotação
`PROBABLE` e prova forced separada da natural. A comparação estática do vetor
não promove esse ramo, mesmo com o recurso classificado `CONFIRMED`.

Os tilesOBJ de32 bytes atendem aos pares00/01 e10/11 que a animação CommErr usa
nas quatro peças OAM com atributo08/banco1. O setup Timer seleciona a tabela
CommErr_ObjTable com B=$80. Essa relação de índices, destinos e estado do setup
sustenta o papel existente; não é uma captura nova da tela. O nome da paleta
Timer está ligado ao carregamento do próprio TimerVariant, e o restante dos
recursos continua nos respectivos setups de erro/sem adaptador.

`Gfx_StartHDMAWithService` (00:0787) recebe C=$02/$18/$40, dentro do domínio
$01..$80 de blocos de16 bytes. DE&$FFF0 é o destino e Ebit0 o banco VRAM; os
argumentos acima conferem. B=$98/$96/$92 limita a espera quando LCD está ligado
(`$91 <= LY < B`); LCD desligado pula a espera. O helper seleciona o banco pela
região de H, usa HRAM e serviço de quadro. Não se estende o contrato a B/C
arbitrários, reentrância, IRQs ou scratch/trampoline não inicializados.

`Palette_LoadToBuffer` (4F:4000) seleciona WRAM7 e chama CopyBytes via
FarCall_Inline16; BC=$0040 é uma cópia positiva de64 bytes no buffer BG, não uma
escrita direta nos registradores de cor. Os macros RGB emitem words little
endian `(b<<10)|(g<<5)|r`. `Tilemap_CopyRectAndAttr` (00:08EA) copia B=$12
linhas de C=$14 colunas, continua na fonte para os atributos e usa stride de
destino32, com segunda área em DE+$400. FarCall mantém os requisitos existentes
de banco/HRAM/scratch; nenhuma implementação ou estado dessa ABI muda.

## KEEP da mesma família

1. `Data_63_6080`/`NoAdapter_Gfx_8000`:1024 bytes de cabeçalho, primeiro backing64
   até60C0 e backing interior NoAdapter_Gfx_8800 com960 até6480. A carga desde
   6080 lê1024 e a carga desde60C0 também lê1024, até64C0. São views sobrepostos;
   não retirar o alias neste passe básico nem inferir um asset único pelo nome.
2. `Data_63_6480`:64 bytes da cauda do segundo view, sem coalias descritivo.
   Continua neutro, sem propósito novo inventado.
3. `Data_63_6CC0`/`NoAdapter_Gfx_9400`:backing768 até6FC0, pedido HDMA1024 até70C0
   que inclui256 bytes iniciais do mapa. A janela mista fica fora da unidade.
4. `Table_63_7310`/`NoAdapter_ObjTable`:duas entradas de4 bytes, zero na primeira
   e seleção da segunda com B=$81. O nível continua `PROBABLE` e o ABI de objetos
   precisa de unidade própria.
5. `Data_63_7318`/`NoAdapter_ObjAnim`:23 bytes de ponteiros, frames e script,
   `PROBABLE`. Labels internas de frames/scripts são entradas de dados distintas,
   não funções desconhecidas a remover.
6. `Data_5C_5516`/`CommErr_Tilemap_Comm`:mapa720 com carga inteira e leitor interior
   por Tilemap_CopyRectAndAttrPtr. O footer usa HL5656=5516+$140 e40 bytes até567E,
   mais ponteiro explícito de atributos57BE e40 bytes até57E6. Esses views cabem
   na mesma unidade; o nome não é declarado falso e não se afirma overread, mas
   o contrato extra de ponteiro/WRAM é deferido neste passe.
7. `Data_5C_6420`:atributo de peça OAM em5C:6414, mantido por ASSERT de offset12.
   Sem coalias descritivo, permanece neutro e intacto.

## Linhas, metadados e previsão

O levantamento atual dos seis roots reencontrou42 registros literais:20
definições (dez antigas+dez retidas) e22 operandos dos onze carregamentos.
Nenhum alias antigo tem operando ativo fora da definição. Os dois owners GFX
não têm labels locais; deixar suas dez linhas em branco mantém todas as outras
linhas byte a byte, inclusive macros, ASSERTs e os sete KEEP.

Os12 registros de `gfx/assets.tsv` e os onze de `gfx/previews/screen_ops.tsv`
relacionados à unidade já usam os nomes descritivos retidos. Não há alteração
nem SOURCE/BEFORE de TSV neste pacote. Uma rechecagem futura deve confirmar que
isso continua verdadeiro, sem copiar catálogo/screen_ops de um baseline antigo.
Os contextos ramop9/10/11 não tinham referências antigas selecionadas no scout
selado. Config/análises/notas históricas mantêm suas identidades antigas como
proveniência, sem substituição global.

Foram rechecados os hashes atuais dos dois owners GFX, dois consumidores e12
componentes contra o scout selado, além das dez emissões e onze vetores na ROM
original. O SYM fresco congelado GFX20 `2b84a91d...` é só evidência de coordenadas
de coaliases; não é build ativo nem total absoluto de um parent futuro. O saldo
isolado previsto é-10 nomes globais, nenhum novo nome, local, constante ou
endereço. A prova do build completo ainda depende dos gates posteriores do ROOT.

A proposta e a seleção foram preparadas pelo mesmo executor; não há autoaceite
nem revisão cega alegada. Nenhum teste, checker, import de helper, compilador,
exporter, renderização ou emulador foi executado. Apenas scripts próprios de
análise estática leram fonte/dados/ROM. Não há prova natural/hardware nova,
fechamento universal de ponteiros computados/consumidores externos ou eliminação
dos neutros/KEEP. Settings17,5510,guardas e todos os pacotes anteriores continuam
intactos; idioma e R4 não são retomados. ROOT compõe REVERSE/README vigentes em
fase própria, após revisão e rebase, sem importar resumos antigos.
