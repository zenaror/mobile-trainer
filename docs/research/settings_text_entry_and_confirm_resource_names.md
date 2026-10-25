# Recursos de entrada de texto e confirmação de configuração

Data: 2026-10-18. Proposta privada de retirada de 17 coaliases `Data_*` já acompanhados
por nomes descritivos. Os cinco ASM preservam todos os cabeçalhos, níveis herdados,
operandos, caminhos e linhas físicas; só a linha de cada alias fica vazia. A unidade
contém 11 fontes de tiles, cinco pares mapa/atributos e uma paleta. São 16
`CONFIRMED` e um `PROBABLE`, sem promoção de confiança. A retirada de um alias não
fecha todas as dúvidas sobre a tela ou sobre outras leituras da região.

## Contratos delimitados

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

The two bank-71 labels above now read `Settings_Candidate2bppFragment_723F` and `Settings_ReadData_UnknownContent_7271`.

## Catálogo, linhas e limites de adoção

A mudança em `gfx/assets.tsv` é exatamente de 19 células da coluna `label`.
IDs/caminhos, tipo, tamanho, owner, banco, endereço, nível e demais campos são
preservados. Os pares mapa/atributos mantêm duas linhas por unidade; o endereço
da linha attrmap é o começo do componente, não o começo do coalias. A paleta
5D e os dois tiles 5E já têm nomes corretos no catálogo e não mudam. O cabeçalho
histórico do catálogo gerado permanece; nenhum exporter foi executado.

## Adendo de escopo: coalias do prefixo AdapterCheck

A chamada continua com C=$40, DE=$9401 e 1.024 B em 4A:6480..6880: 256 B de tiles, 64 B BG, 64 B OBJ, 360 B de tilemap e 280 B de attrmap. A retirada do alias não reduz essa janela nem a torna homogênea ou exclusiva. `Data_4B_70B0` e `Data_4B_7AD0` ficam fora desta decisão e intactos.

A raiz foi refinada para `AdapterCheck_ObjTable`, com seis globais próprios e 11 bytes finais UNKNOWN.

O escopo combinado é 27 movimentos, 72 células ativas e delta previsto de -1 símbolo; os planos/aceites de 27/71 anteriores permanecem históricos e não substituem a revisão e QA deste candidato. Os [contratos e limites de caminhos](adapter_check_and_phone_entry_4a_resource_paths.md) não alegam nova exibição natural, hardware ou cobertura universal.

## Adendo de escopo: cabeçalhos de aviso e recursos 4B

Os KEEP anteriores registram corretamente as decisões dos passes em que foram escritos. Nesta unidade posterior, quatro nomes são substituídos por descrições sustentadas pelo consumidor estático: `Tiles_4B_5B90` → `Notice_HeaderGfxSources10To13` (PROBABLE), `Data_4B_6590` → `Notice_HeaderGfxSources14To15` (mantém CONFIRMED como fonte lida, sem classificar pixels), `Data_4B_70B0` → `Gfx_SettingsPhone_ConfirmScreen_TileSlice9020Vb1` (CONFIRMED) e `Table_4B_76C0` → `SettingsPhone_ConfirmScreen_SlotCellRecords` (PROBABLE). São quatro renomes únicos. `Data_4B_7AD0` e `Data_65_4A81` são retirados apenas como coaliases dos labels descritivos já existentes; os bytes e os consumidores permanecem. Nenhum rótulo, constante ou operando é inferido a partir de semelhança do nome.

`Notice_LoadHeaderGfx` em 65:4A37 lê o cabeçalho 4A81..4AC9 como 24 descritores de três bytes (endereço little-endian e banco), selecionados por `3*A`; a primeira carga solicita 640 bytes para VRAM banco 1 em $9300. O footer separado 4AC9..4AD7 tem sete endereços de 16 bits e usa banco $58 para a carga destinada a $9580. Essa divisão corrige a descrição histórica incorreta de um único registro de 86 bytes com flag/endereço. A leitura estática corrige também o antigo comentário “no loader call found” para 5B90..6590 e “content class unknown” para os dois segmentos 6590/6810; não estabelece seleção natural nem aparência em tela. O bloco de 1280 bytes em 6590 continua como `db`, sem PNG ou ativo novo.

O pedido HDMA que começa em 4B:7090 abrange 7090..7490. A fatia 70B0..73B0 tem 768 bytes e corresponde a VRAM banco 1 $9020..$931F, mas a requisição maior também inclui os 32 bytes anteriores, 64 bytes de paleta e 160 bytes de mapa/atributos. O nome não afirma que o pedido seja exclusivo dessa fatia. Em 76C0..76D0, três registros de quatro bytes selecionados por `SettingsPhone_ConfirmScreen_SlotTilemapTable` são copiados com BC=$0201; os quatro zeros finais em 76CC..76CF seguem sem consumidor ou finalidade demonstrados. A chamada far do loader de mapa começa em 67:53CF; os três operandos `dw` seguem numéricos nesta unidade.

O escopo de caminhos move 21 arquivos sob `gfx/settings/notice_headers_and_phone_confirm_continue_bank4b/`. As 54 células da proposta de caminhos são compostas com três células de `assets.tsv` para labels, totalizando 57 (27 assets, 18 regras PNG e 12 telas). Os outros campos dessas linhas, status, endereços, bytes, imagens e paletas são mantidos. O arquivo `gfx_resource_path_map.tsv` recebe 21 linhas sem reescrever as antigas; o inventário de pixels e o índice GFX acompanham os novos nomes. Os comentários mantêm os prefixos históricos `read as data by executed code` e `3 x 4-byte entries` reconhecidos pela agregação de leftovers, preservando os buckets atuais; não se executa `gfx_export.py` neste candidato. Os modelos HYPOTHESIS dos mapas, os dois nomes `Data_71_723F`/`Data_71_7271` e as janelas mistas permanecem como estavam; esta nota não reivindica exibição natural, correspondência visual nova, hardware nem equivalência de build.
