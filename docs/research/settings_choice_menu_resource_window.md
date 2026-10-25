# Janela mista de recursos de SettingsPhone_ChoiceMenu

Data: 2026-10-18. Proposta privada original de substituir o global neutro
`Data_4D_5510` por `Data_SettingsPhone_ChoiceMenu_ResourceWindow768`, mantendo
o coalias `Palette_SettingsPhone_ChoiceMenu_Bg` em4D:5510. O novo nome é uma
interpretação estrutural `PROBABLE`: descreve uma janela de fonte usada pelo menu,
não um novo asset homogêneo nem uma paleta de768 bytes. Não há promoção de nível,
retirada do alias de paleta ou reclassificação dos componentes.

## Componentes e vistas delimitadas

A janela semiaberta4D:5510..5810 tem768 bytes, compostos por:

| Intervalo | Conteúdo declarado | Bytes | Nível herdado |
|---|---|---:|---|
| 5510..5538 | `Palette_SettingsPhone_ChoiceMenu_Bg` | 40 | PROBABLE |
| 5538..5540 | `Palette_SettingsPhone_ChoiceMenu_Obj` | 8 | CONFIRMED |
| 5540..56A8 | índices do mapa20×18 | 360 | CONFIRMED |
| 56A8..5810 | atributos desse mapa20×18 | 360 | CONFIRMED |

Em `engine/settings/choice_menu.asm`, quatro vistas têm argumentos distintos:

| Visto pelo código | Fonte / destino | Comprimento e condição |
|---|---|---|
| HDMA67:4766 | banco4D:5510 → VRAM1:9400 | C=$30 blocos =768; variante não zero |
| Paleta BG67:479A | banco4D:5510 → WRAM7:D800 | BC=$0040 =64; caminho comum |
| Paleta OBJ67:47AB | banco4D:5538 → WRAM7:D840 | BC=$0008 =8; caminho comum |
| Mapa/attr67:471C | banco4D:5540 → WRAM7:D000/D400 | B=$12,C=$14;360+360; ramo variante zero |

O prefixo BG64 contém40 BG +8 OBJ +16 bytes iniciais do mapa. A exceção de
leitura excedente já documentada de24 bytes permanece; não se cria uma paleta
de64 ou768 bytes no catálogo. O pedido HDMA inclui os40+8+360+360 bytes, mesmo
que o mapa em5540 seja também copiado pelo ramo de variante zero. O ramo não
zero posteriormente copia seu outro mapa em5810, fora da janela; isso não muda.
A razão original de transferir paletas/mapa como bytes de tiles continua uma
pergunta aberta. Não inferimos intenção, aparência ou exclusividade desse uso.

## Banco, estado e chamadas

A instrução HDMA recebe DE=$9401, HL=$5510, A=$4D, B=$94 e C=$30.
`Gfx_StartHDMAWithService` (00:0787) seleciona fonte por H, determina bancoVRAM
por E bit0 e destino por DE&$FFF0. C está no domínio1..$80 de blocos de16 bytes;
B=$94 é limite superior da espera com LCD ligado (`$91 <= LY < B`), não o byte
alto de um bytecount `$9430`. Com LCD desligado a espera é pulada. O helper usa
estado HRAM e serviço de quadro. Não estendemos o contrato a outros B/C,
interrupções arbitrárias ou reentrância de scratch compartilhado.

`Palette_LoadToBuffer` (4F:4000) seleciona WRAM7 e chama `CopyBytes` por
`FarCall_Inline16`; as cargas BG/OBJ de64/8 não são escritas diretas na paleta
física. `Tilemap_CopyRectAndAttr` (00:08EA) copia dois retângulos da fonte
contígua, com stride de destino32 e segundo destino DE+$400. FarCall continua
usando trampolineHRAM inicializado, banco e scratch existentes; não se muda
mapper, HRAM, WRAM, restauração, cursor ou tratamento de IRQ.

Foram reencontradas três referências simbólicas à entrada pública: duas em
`SettingsPhone_Run` com A=0/A=1 e uma em `Registration_PhoneMethodMenu` com A=1.
Os três vetores também conferem com a ROM. A entrada67:4631 grava A em
`wChoiceMenu_Variant` e chama Setup; Setup testa zero/não-zero. Isso delimita os
usos resolvidos, sem provar ausência universal de outros chamadores indiretos,
valores de entrada, ponteiros empacotados ou fluxos computados.

## Alterações específicas e metadados

- `gfx/settings/screens_bank4d.asm`: somente a definição da linha56 troca o
  nome. O alias BG na linha55 e todos os cabeçalhos/componentes são mantidos.
- `engine/settings/choice_menu.asm`: somente HL/BANK das linhas126/127 do
  consumidor HDMA usam o novo nome. BG145/146 e OBJ150/151 permanecem Palette_*.
- `gfx/previews/screen_ops.tsv`: duas células da coluna4, identificadas por
  contexto/localizador/tipo/banco/detalhes. A linha823 de upload130 recebe o nome
  da janela; a linha826 da paleta147 recebe o alias BG que a instrução já usa.
  Nenhum outro campo, linha, contador ou tipo é modificado.

`gfx/assets.tsv` já registra o `.pal` BG como paleta40 `PROBABLE` com label `Palette_SettingsPhone_ChoiceMenu_Bg` na linha841.

Uma inspeção dos registros e de um SYM fresco congelado, sem executar checker
ou helper, confirmou igualdade de todos os162 tuples de paleta por linha e
consumidor antes/depois da proposta. O mapa projetado troca apenas a chave
global5510 e a célula826 agora resolve pelo alias BG já existente. A futura
guarda de metadados é um passe separado de ferramentas/docs; sua execução e
aceite não são alegados aqui. As11 paletas explicitamente `UNRESOLVED` continuam
fora do domínio, e nenhuma cobertura total de paletas da ROM é prometida.

## Censo e limites da proposta

Não apareceram imediato `$5510`, expressão explícita alias+offset ou colisão com o nome novo nesse escopo.
