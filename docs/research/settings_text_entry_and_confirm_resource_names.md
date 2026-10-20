# Recursos de entrada de texto e confirmação de configuração

Data: 2026-10-18. Proposta privada de retirada de 17 coaliases `Data_*` já acompanhados
por nomes descritivos. Os cinco ASM preservam todos os cabeçalhos, níveis herdados,
operandos, caminhos e linhas físicas; só a linha de cada alias fica vazia. A unidade
contém 11 fontes de tiles, cinco pares mapa/atributos e uma paleta. São 16
`CONFIRMED` e um `PROBABLE`, sem promoção de confiança. A retirada de um alias não
fecha todas as dúvidas sobre a tela ou sobre outras leituras da região.

## Contratos delimitados

Intervalos abaixo são semiabertos. Os nomes já existiam antes desta proposta.
A classe e o uso são verificados pelos consumidores e seus argumentos, não pela
mera existência do nome. Endereços de chamada incluem o `call FarCall` e seus
três bytes inline; `A` seleciona o banco da fonte, enquanto o banco do helper é
independente. Os 17 intervalos de recurso e as 25 sequências consumidoras foram
comparados estaticamente aos bytes da ROM original; isto não é um novo build,
execução natural, renderização nem teste de hardware.

| Alias retirado → nome retido | Intervalo / bytes | Contrato observado | Nível herdado |
|---|---|---|---|
| `Data_4A_5F80` → `Gfx_AdapterCheck_Tiles8000` | 4A:5F80..6080 / 256 | HDMA C=$10, DE=$8000; VRAM0:$8000; 1 chamada(s) | CONFIRMED |
| `Data_4A_6080` → `Gfx_AdapterCheck_Tiles9000Vb1` | 4A:6080..6480 / 1024 | HDMA C=$40, DE=$9001; VRAM1:$9000; 1 chamada(s) | CONFIRMED |
| `Data_4A_6920` → `Gfx_PhoneKeypadAndComment_Tiles9000Vb1` | 4A:6920..6D20 / 1024 | HDMA C=$40, DE=$9001; VRAM1:$9000; 2 chamada(s) | CONFIRMED |
| `Data_4A_6D20` → `Gfx_PhoneKeypadAndComment_Tiles9400Vb1` | 4A:6D20..7120 / 1024 | HDMA C=$40, DE=$9401; VRAM1:$9400; 2 chamada(s) | CONFIRMED |
| `Data_4A_7120` → `Tilemap_PhoneKeypad_4A_7120` | 4A:7120..71E8 / 200 | B=$05, C=$14; mapa seguido de atributos → WRAM7:D000/D400 | CONFIRMED |
| `Data_4A_71E8` → `Tilemap_PhoneKeypad_4A_71E8` | 4A:71E8..72B0 / 200 | B=$05, C=$14; mapa seguido de atributos → WRAM7:D000/D400 | CONFIRMED |
| `Data_4A_72B0` → `Tilemap_PhoneComment` | 4A:72B0..7378 / 200 | B=$05, C=$14; mapa seguido de atributos → WRAM7:D000/D400 | CONFIRMED |
| `Data_4B_6A90` → `Gfx_SettingsPhone_ConfirmScreen_Tiles8800Vb1` | 4B:6A90..6E90 / 1024 | HDMA C=$40, DE=$8801; VRAM1:$8800; 1 chamada(s) | CONFIRMED |
| `Data_4B_6E90` → `Gfx_SettingsPhone_ConfirmScreen_Tiles8C00Vb1` | 4B:6E90..70B0 / 544 | HDMA C=$22, DE=$8C01; VRAM1:$8C00; 1 chamada(s) | CONFIRMED |
| `Data_4B_76D0` → `Gfx_SettingsPhone_ContinuePrompt_Tiles9000Vb1` | 4B:76D0..7AD0 / 1024 | HDMA C=$40, DE=$9001; VRAM1:$9000; 1 chamada(s) | CONFIRMED |
| `Data_5D_7360` → `Gfx_PwSaveConfirm_Tiles9000Vb1` | 5D:7360..7760 / 1024 | HDMA C=$40, DE=$9001; VRAM1:$9000; 1 chamada(s) | CONFIRMED |
| `Data_5D_7760` → `Gfx_PwSaveConfirm_Tiles9400Vb1` | 5D:7760..7B60 / 1024 | HDMA C=$40, DE=$9401; VRAM1:$9400; 1 chamada(s) | CONFIRMED |
| `Data_5D_7B60` → `Palette_PwSaveConfirm_Bg` | 5D:7B60..7BA0 / 64 | BC=$0040 → WRAM7:D800..D840; 32 palavras RGB555 | CONFIRMED |
| `Data_5D_7BA0` → `Tilemap_PwSaveConfirm_5D_7BA0` | 5D:7BA0..7E70 / 720 | B=$12, C=$14; mapa seguido de atributos → WRAM7:D000/D400 | CONFIRMED |
| `Data_5E_4000` → `Gfx_SharedTextEntry_Vram8800Vb1` | 5E:4000..4400 / 1024 | HDMA C=$40, DE=$8801; VRAM1:$8800; 4 chamada(s) | CONFIRMED |
| `Data_5E_4400` → `Gfx_SharedTextEntry_Vram8C00Vb1` | 5E:4400..4800 / 1024 | HDMA C=$40, DE=$8C01; VRAM1:$8C00; 4 chamada(s) | CONFIRMED |
| `Data_71_6F6F` → `Tilemap_PwSaveConfirm_71_6F6F` | 71:6F6F..723F / 720 | B=$12, C=$14; mapa seguido de atributos → WRAM7:D000/D400 | PROBABLE |

`Gfx_StartHDMAWithService` (00:0787) escreve `rHDMA5=C-1`; neste conjunto
C é $10, $22 ou $40, dentro do domínio $01..$80 de blocos de 16 bytes. Todos os
inícios são alinhados a 16. `DE & $FFF0` determina o destino e `DE & 1` o banco
VRAM; os sufixos dos nomes concordam com esses argumentos. B=$92, $95 ou $97
é o limite superior da espera quando LCD está ligado (`$91 <= LY < B`); LCD
desligado pula a espera. O helper troca o banco pela região de H, usa estado
HRAM e pode chamar serviço de quadro. O contrato não promete reentrância, estado
arbitrário de interrupções/trampoline nem transferência para B/C fora do domínio.

`Tilemap_CopyRectAndAttr` (00:08EA) recebe B linhas e C colunas positivas e
copia o segundo retângulo da continuação de HL, para DE+$400, com stride de
destino 32 e WRAM7 selecionada. Três pares 20×5 usam 100+100 bytes; os dois
pares 20×18 usam 360+360. `Palette_LoadToBuffer` (4F:4000) seleciona WRAM7 e
chama `CopyBytes` via `FarCall_Inline16`; BC=$0040 corresponde a 64 bytes no
buffer BG, não a uma escrita direta nos registradores de paleta. A inclusão
`.pal` de 32 macros RGB emite words `(b<<10)|(g<<5)|r`, little endian, iguais
à fatia original.

## Chamadas literais e compartilhamento

| Recurso | Chamada(s) e contexto |
|---|---|
| `Gfx_AdapterCheck_Tiles8000` | 67:6385 `AdapterCheck_DrawScreen` |
| `Gfx_AdapterCheck_Tiles9000Vb1` | 67:6397 `AdapterCheck_DrawScreen` |
| `Gfx_PhoneKeypadAndComment_Tiles9000Vb1` | 67:4A09 `PhoneComment_KeyboardSetup`; 67:4394 `PhoneKeypad_Setup` |
| `Gfx_PhoneKeypadAndComment_Tiles9400Vb1` | 67:4A1B `PhoneComment_KeyboardSetup`; 67:43A6 `PhoneKeypad_Setup` |
| `Tilemap_PhoneKeypad_4A_7120` | 67:43CE `PhoneKeypad_Setup` |
| `Tilemap_PhoneKeypad_4A_71E8` | 67:43E1 `PhoneKeypad_Setup` |
| `Tilemap_PhoneComment` | 67:4A3D `PhoneComment_KeyboardSetup` |
| `Gfx_SettingsPhone_ConfirmScreen_Tiles8800Vb1` | 67:514E `SettingsPhone_ConfirmScreen_Setup` |
| `Gfx_SettingsPhone_ConfirmScreen_Tiles8C00Vb1` | 67:5160 `SettingsPhone_ConfirmScreen_Setup` |
| `Gfx_SettingsPhone_ContinuePrompt_Tiles9000Vb1` | 67:574D `SettingsPhone_ContinuePrompt_Setup` |
| `Gfx_PwSaveConfirm_Tiles9000Vb1` | 67:658D `PwSaveConfirm_Setup` |
| `Gfx_PwSaveConfirm_Tiles9400Vb1` | 67:659F `PwSaveConfirm_Setup` |
| `Palette_PwSaveConfirm_Bg` | 67:65C2 `PwSaveConfirm_Setup` |
| `Tilemap_PwSaveConfirm_5D_7BA0` | 67:65EA `PwSaveConfirm_Setup` |
| `Gfx_SharedTextEntry_Vram8800Vb1` | 68:5351 `Account_LoginIdEntry_Setup`; 68:5804 `Account_MailAddressEntry_Setup`; 67:49E5 `PhoneComment_KeyboardSetup`; 67:4370 `PhoneKeypad_Setup` |
| `Gfx_SharedTextEntry_Vram8C00Vb1` | 68:5363 `Account_LoginIdEntry_Setup`; 68:5816 `Account_MailAddressEntry_Setup`; 67:49F7 `PhoneComment_KeyboardSetup`; 67:4382 `PhoneKeypad_Setup` |
| `Tilemap_PwSaveConfirm_71_6F6F` | 67:65FD `PwSaveConfirm_Setup` |

Os dois recursos 5E:4000/4400 são compartilhados: há quatro contextos completos
para cada um (`PhoneKeypad_Setup`, `PhoneComment_KeyboardSetup`,
`Account_LoginIdEntry_Setup`, `Account_MailAddressEntry_Setup`). Cada chamada
seleciona banco 5E, C=$40 e DE=$8801/$8C01, lendo exatamente 1024 bytes. O nome
`SharedTextEntry` abrange os quatro domínios; não atribui uso exclusivo a telefone
nem deduz conteúdo visual só de uma transferência. A nota
[naming2_neutral_5e.md](naming2_neutral_5e.md) já documenta esses leitores;
a observação anterior em `naming2_data2.md` é histórica.

O ramo 67:65F2..6603 que lê `Tilemap_PwSaveConfirm_71_6F6F` continua
`PROBABLE`. Sua geometria, banco e sequência de bytes são verificáveis no fonte
e na ROM, mas o cabeçalho registra ausência de execução nas 64 situações
históricas citadas. Esta proposta não transforma a comparação estática em prova
de execução nem estabelece a aparência da variante.

## KEEP e leituras que cruzam fronteiras

- `screens_bank4d.asm` inteiro e Data_4D_5510 ficam fora desta unidade; o estudo
  separado da janela mista não autoriza sua retirada aqui.
- `Data_4A_6480` fica: backing de 256 bytes, mas HDMA de 1024 atravessa tiles,
  64 bytes BG, 64 bytes OBJ e 640 bytes de mapa. `Data_4B_7AD0` também fica:
  backing de 512 bytes e pedido de 768 inclui 64 bytes BG e 192 bytes de mapa.
- A fonte imediata 4B:7090 solicita 1024 bytes até $7490. Ela inclui 32 bytes
  finais da unidade selecionada 6E90..70B0, 768 bytes neutros 70B0..73B0,
  64 bytes de paleta e 160 bytes de mapa. A unidade selecionada 6E90 permanece
  com 544 bytes e uma carga completa de $22 blocos em $8C00; seu nome descreve
  essa carga demonstrada, sem prometer destino exclusivo para cada byte. A
  leitura interior crua e `Data_4B_70B0` continuam intactas.
- `Data_4A_68D0`/`AdapterCheck_ObjTableAndAnimData` fica separado: a classificação
  heurística de tiles no cabeçalho não resolve seu ABI de objeto/animação.
  Os scripts/animações 71:6F44/6F69/6F6A e os seis recursos sem nome descritivo
  (`Tiles_4B_5B90`, `Data_4B_6590`, `Data_4B_70B0`, `Table_4B_76C0`,
  `Data_71_723F`, `Data_71_7271`) também ficam.

## Catálogo, linhas e limites de adoção

A mudança em `gfx/assets.tsv` é exatamente de 19 células da coluna `label`.
IDs/caminhos, tipo, tamanho, owner, banco, endereço, nível e demais campos são
preservados. Os pares mapa/atributos mantêm duas linhas por unidade; o endereço
da linha attrmap é o começo do componente, não o começo do coalias. A paleta
5D e os dois tiles 5E já têm nomes corretos no catálogo e não mudam. O cabeçalho
histórico do catálogo gerado permanece; nenhum exporter foi executado.

As definições antigas têm zero operandos ativos literais nos seis roots; os nomes
retidos já são usados pelos 25 consumidores. Não há locais nos cinco owners.
Os 84 registros literais são 34 definições e 50 operandos; nenhum código de
consumidor muda. As 25 linhas operacionais de `screen_ops.tsv` já usam os nomes
retidos; não há célula antiga selecionada em ramop9/10/11. Tabelas `config/` e
notas históricas não são reescritas. Isto é uma busca finita de referências
literais, não uma prova universal de inexistência de ponteiros computados ou
outros consumidores; as leituras cruzadas conhecidas são mantidas acima.

A previsão isolada é somente -17 nomes globais: nenhum nome novo, local,
constante ou endereço muda. O SYM fresco congelado do passe109d serve para
conferir as duas identidades no mesmo banco/endereço; não fixa o parent nem uma
contagem absoluta de um futuro passe combinado. ROOT deve reaplicar as 19
edições por chave/célula no catálogo então atual, conferir os BEFORE dos cinco
ASM e compor os docs atuais, sem copiar um catálogo ou resumo antigo por inteiro.
A proposta fica queued; revisão independente e gates futuros do ROOT são
separados. Não há aceite próprio, adoção, equivalência de build nem retomada de
idioma ou instrumentação R4.

Evidência privada durável: `.tmp/jp-settings17-proposal-20261018/DATA/` contém
`RESOURCE_ROM_PROOF.json`, `CONSUMER_ROM_PROOF.json`, `ACTIVE_REFERENCE_PROOF.json`,
`METADATA_REFERENCE_SURVEY.json`, `CATALOG_CELL_EDIT_PLAN.json`, `ASSETS_HELD.json`,
`SYMBOL_DELTA.json` e readset com hashes. O scout precedente permanece selado em
`.tmp/jp-settings-resources-next-scout-20261017/`.


## Adendo de escopo: coalias do prefixo AdapterCheck (2026-10-18)

O KEEP anterior permanece como registro do escopo daquele passe. Nesta unidade de caminhos, `Data_4A_6480` é aposentado como grafia redundante de `Gfx_AdapterCheck_Tiles9400Vb1`, ambos em 4A:6480. A definição vira uma linha vazia e somente a célula label do asset de 256 B passa a usar o nome próprio; não há operandos antigos ou locais dependentes no censo finito do parent. A confiança CONFIRMED do prefixo e os bytes/pixels permanecem.

A chamada continua com C=$40, DE=$9401 e 1.024 B em 4A:6480..6880: 256 B de tiles, 64 B BG, 64 B OBJ, 360 B de tilemap e 280 B de attrmap. A retirada do alias não reduz essa janela nem a torna homogênea ou exclusiva. `Data_4B_70B0` e `Data_4B_7AD0` ficam fora desta decisão e intactos.

O outro KEEP histórico, `Data_4A_68D0`/`AdapterCheck_ObjTableAndAnimData`, foi resolvido na [tipagem publicada dos 80 bytes](https://github.com/zenaror/mobile-trainer/commit/0c02c5369e47597f022df0663a2749acb3bfb12c), descrita na [nota de estrutura e proveniência](adapter_check_object_data_80b.md). A raiz foi refinada para `AdapterCheck_ObjTable`, com seis globais próprios e 11 bytes finais UNKNOWN. Este adendo de caminhos retira apenas o alias de 6480; não repete o delta de símbolos daquele passe.

O escopo combinado é 27 movimentos, 72 células ativas e delta previsto de -1 símbolo; os planos/aceites de 27/71 anteriores permanecem históricos e não substituem a revisão e QA deste candidato. Os [contratos e limites de caminhos](adapter_check_and_phone_entry_4a_resource_paths.md) não alegam nova exibição natural, hardware ou cobertura universal.
