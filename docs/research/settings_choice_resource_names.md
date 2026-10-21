# Nomes de recursos do menu de escolha de telefone — 2026-10-17

Esta proposta privada retira sete coalíases numéricos redundantes de
`gfx/settings/screens_bank4d.asm`. Os nomes descritivos já existem e seus
consumidores usam esses nomes. As sete definições `Data_4D_*` viram linhas vazias
nas mesmas posições físicas; os nomes descritivos, sete headers `CONFIRMED`,
instruções, operandos, comentários, assets, caminhos e metadados permanecem.
O owner não contém labels locais. A seleção e os limites vêm do scout privado
`jp-next-resource-cohort-scout-20261017`; isto é uma proposta, não um resultado
novo de link, compilação ou execução natural.

## Sete unidades já nomeadas

| Alias a retirar | Nome descritivo existente | Intervalo de fonte (fim exclusivo) | Bytes | Consumidor literal |
|---|---|---|---:|---|
| `Data_4D_4000` | `Gfx_SettingsPhone_ChoiceMenu_Tiles8000Vb1` | 4D:4000–4200 | 512 | DE=$8001, B=$95, C=$20; `Gfx_StartHDMAWithService` |
| `Data_4D_4510` | `Gfx_SettingsPhone_ChoiceMenu_Tiles8C00Vb1_4D_4510` | 4D:4510–4610 | 256 | DE=$8C01, B=$97, C=$10; `Gfx_StartHDMAWithService` |
| `Data_4D_4610` | `Gfx_SettingsPhone_ChoiceMenu_Tiles9000Vb1_4D_4610` | 4D:4610–4A10 | 1024 | DE=$9001, B=$92, C=$40; `Gfx_StartHDMAWithService` |
| `Data_4D_4A10` | `Gfx_SettingsPhone_ChoiceMenu_Tiles9400Vb1` | 4D:4A10–4D10 | 768 | DE=$9401, B=$94, C=$30; `Gfx_StartHDMAWithService` |
| `Data_4D_5010` | `Gfx_SettingsPhone_ChoiceMenu_Tiles8C00Vb1_4D_5010` | 4D:5010–5110 | 256 | DE=$8C01, B=$97, C=$10; `Gfx_StartHDMAWithService` |
| `Data_4D_5110` | `Gfx_SettingsPhone_ChoiceMenu_Tiles9000Vb1_4D_5110` | 4D:5110–5510 | 1024 | DE=$9001, B=$92, C=$40; `Gfx_StartHDMAWithService` |
| `Data_4D_5810` | `Tilemap_SettingsPhone_ChoiceMenu` | 4D:5810–5AE0 | 720 | BC=$1214, DE=wScreenTileMap; `Tilemap_CopyRectAndAttr` |

Todos os consumidores positivos selecionados estão em
`engine/settings/choice_menu.asm`, dentro de `SettingsPhone_ChoiceMenu_Setup`.
Cada ponteiro descritivo usa também `BANK(nome)`; o mapa frozen coloca ambos os
nomes em banco 4D no mesmo endereço. Os seis uploads HDMA usam blocos de 16 bytes:
C=$20/$10/$40/$30/$10/$40 correspondem a 512/256/1024/768/256/1024 bytes.
DE bit 0 seleciona VRAM bank 1 e DE&$FFF0 determina o destino. O helper original
`Gfx_StartHDMAWithService` exige C=$01..$80; com LCD ligado, espera $91<=LY<B e
executa serviço de frame. O estado de bancos, scratch, trampoline/farcall, IRQ e
contexto do chamador continuam condicionais. Nenhuma imunidade a IRQ, segurança
geral, aparência ou exclusividade de destino é inferida pelos nomes.

O par em 4D:5810 é passado a `Tilemap_CopyRectAndAttr` com BC=$1214: 18 linhas
por 20 colunas, 360 índices seguidos de 360 atributos. O helper seleciona ROM pelo
banco A/ponteiro HL e WRAM 7 a partir do destino, com stride 32 entre linhas.
As duas backings existentes têm 360 bytes cada. Não se altera esse ABI.

## KEEP e leituras que cruzam limites

`Data_4D_5510` permanece, assim como seu coalíase
`Palette_SettingsPhone_ChoiceMenu_Bg`. Os operandos HDMA usam intencionalmente
`Data_4D_5510`: a janela de C=$30/768 bytes em 5510..5810 contém 40 bytes da
paleta BG, oito da paleta OBJ adjacente e 720 do par tilemap/atributos.
Separadamente, `Palette_LoadToBuffer` lê BC=$40/64 bytes começando em 5510:
40 BG + 8 OBJ + os primeiros 16 bytes do mapa. O limite semântico BG de 40 bytes
é por adjacência e permanece `PROBABLE`. A paleta OBJ em 5538 tem oito bytes.
Uma substituição global do nome neutro pelo nome da paleta descreveria mal o
consumidor misto. Esse KEEP está registrado em `naming2_retype1.md`,
`naming2_data2.md` e `naming2_neutral_code.md` e não é dívida a resolver por esta
retirada de coalíases.

`Data_4D_4200` e `Data_4D_4D10` também ficam neutros. O upload imediato iniciado
em 4110 lê 1024 bytes: 240 do final da unidade 4000..4200 e 784 de 4200..4510.
O iniciado em 4C10 lê 1024 bytes: 256 do final de 4A10..4D10 e 768 de
4D10..5010. Assim, os nomes de tiles já existentes não significam que todo
consumidor da backing use um único destino VRAM. Nenhum label novo é criado no
interior, nenhum bloco é alargado e os operandos imediatos permanecem.

As quatro unidades de escolha `Tilemap_4D_5AE0/5B6C/5BF8/5C84`, seus nomes
`Entry0..3`, o loader indexado e as tabelas/frames/scripts de objetos ficaram fora
desta coorte histórica. O checkpoint de 2026-10-20 aplicou `Entry0..3` como os
nomes ativos e renomeou os oito arquivos tilemap/attrmap correspondentes; a
evidência e os limites constam em `typing_4d_choice_maps.md` e na seção japonesa
global de `REVERSE_ENGINEERING.md`. Não se amplia sua prova para cursores
corrompidos ou outros recursos. O menu de slots e todos os grupos não selecionados
permanecem.

## Metadados, base e previsão

A varredura finita dos seis roots ASM encontra os sete nomes antigos apenas nas
sete definições selecionadas. Os nomes descritivos resolvem os consumidores HL e
BANK. Os sete registros históricos em `data2_renames.tsv`, oito registros de assets
e sete de operações de tela mantêm suas linhas e células; os consumidores não
mudam de linha. As tabelas manuais ramop9/10/11 não contêm esses identificadores.
Os assets e seus PNGs existentes foram apenas conferidos por hash, sem render,
export/import ou alteração. As evidências de execução citadas nos headers são
herdadas; nenhum novo cenário foi executado para esta proposta.

O ROOT informou MAIN700f como estado atual. Esta preparação fixa o hash do owner
observado, sem consultar Git e sem atestar um futuro commit ou o SYM completo de
700f. Para um mapa isolado explícito, usa-se o SYM FRESH congelado do commit
109d57ac523294e7acccf7e3af36e15e1dff9c2f: 14870 entradas, incluindo 51 constantes.
Retirar só estes sete globais desse mapa prevê 14863, sem alterar os valores
sobreviventes. O delta próprio é -7; isto não é um resultado novo de link.

A coorte GFX20 pendente é disjunta nos owners e aliases. Somente se o ROOT partir
daquele mesmo conjunto de 14870 e aplicar GFX20(-20) e settings7(-7), sem outro
delta, a conta combinada será 14843. Não existe mapa combinado futuro emitido ou
SYM final alegado aqui. O ROOT deve rebater a previsão no pai realmente aceito,
após GFX20, e validar separadamente. Nenhuma cópia de REVERSE_ENGINEERING.md ou
docs/README.md é fornecida. Retirar aliases redundantes não fecha todas as
unidades desconhecidas. Esta proposta não altera idiomas, não retoma R4 e não
traz build, emulador, publicação, hardware ou prova de propósito natural.


## Base de integração ROOT

O parent de fontes é `972071a41a601d5a0e0540a6bd745f4c36aeeec8`. O mapa
PRIVATE GFX20 já fechado e aceito contém14850 nomes, incluindo51 constantes;
seu SYM tem SHA-256 `2b84a91d379d973234bf7acf1181027c26bd7dab9c66e07d9bfff446be960323`.
Retirar somente estes sete aliases prevê14843 nomes, incluindo as mesmas51
constantes. A previsão isolada anterior14863 é histórica e não deve ser
aplicada ao parent que já inclui GFX20. Esta é uma previsão estática;
link, comparação integral e publicação desta coorte ainda são gates separados.

## Follow-up no fonte atual — 2026-10-21

No checkpoint posterior, as duas unidades antes mantidas como `Data_4D_4200`
e `Data_4D_4D10` receberam nomes `TileSlice` que preservam o limite do
conhecimento: fazem parte dos uploads de 1 KiB iniciados em `4D:4110` e
`4D:4C10`, sem serem rotuladas como unidades independentes. Três trechos
análogos do menu de slots também receberam nomes `TileSlice` conforme os
destinos VRAM dos uploads que os cobrem. Isso qualifica a origem da janela,
sem ampliar os intervalos nem atribuir outros consumidores.

Foram retirados os oito aliases exatos `Data_4D_5D18`, `Data_4D_5D50`,
`Data_4D_5D70`, `Data_4D_6170`, `Data_4D_6870`, `Data_4D_6D70`,
`Data_4D_7470` e `Data_4D_7968`, mais `Table_4D_5D10` e
`Table_4D_7960`, sob os nomes descritivos co-localizados. O mapa `.sym`
confirmou endereços iguais; a busca em fontes e ferramentas ativas não achou
outros consumidores. As seis células de catálogo dos aliases gráficos agora
apontam para os símbolos descritivos. O passe está documentado em
`generic_data_name_audit_20261020.md`; os gates mostram equivalência byte a
byte e a validade do mapa de símbolos.
