# Recursos de confirmação de salvamento da senha no banco 5D

Proposta privada de caminhos, 2026-10-18. A migração agrupa o intervalo
`5D:7360..7E70` em `gfx/settings/password_save_confirmation_bank5d.asm`
e na pasta homônima. O nome da coleção é **PROBABLE**, derivado do consumidor
existente `PwSaveConfirm_Setup`; não recupera um nome original nem descreve
todos os recursos necessários à tela.

Os quatro cabeçalhos **CONFIRMED**, quatro labels próprios, endereços, limites,
ordem de emissão e operandos dos leitores permanecem. Não há locais no owner.
O total declarado é 2.832 bytes. A análise é estática: nenhuma compilação,
exportação, renderização ou execução foi feita neste passe. A equivalência de
uma futura integração depende das verificações do mantenedor.

| Origem no banco 5D | Nome de arquivo proposto | Contrato positivo existente |
| --- | --- | --- |
| `7360..7760`, 1.024 B | `password_save_confirm_vram9000_vb1.2bpp` e `.png` | `67:658D`: HL=`7360`, banco=`5D`, DE=`9001`, C=`40` |
| `7760..7B60`, 1.024 B | `password_save_confirm_vram9400_vb1.2bpp` e `.png` | `67:659F`: HL=`7760`, banco=`5D`, DE=`9401`, C=`40` |
| `7B60..7BA0`, 64 B | `pw_save_confirm_bg.pal` (basename mantido) | `67:65C2`: `Palette_LoadToBuffer`, BC=`0040`, destino `wPaletteBufBg` |
| `7BA0..7D08`, 360 B; `7D08..7E70`, 360 B | `password_save_confirm_variant0.tilemap`, `.attrmap` e `.screen.png` | `67:65EA`: `Tilemap_CopyRectAndAttr`, BC=`1214`, banco=`5D`, destino `wScreenTileMap` |

Os dois HDMAs usam `Gfx_StartHDMAWithService` (`00:0787`). O helper toma E bit 0
como banco VRAM e E&`F0` como parte baixa do destino; C conta blocos de 16 bytes.
As duas chamadas literais dão 64×16=1.024 bytes para VRAM banco 1, em `9000` e
`9400`. B=`92` satisfaz o limite de espera documentado nessas chamadas. Não se
atribui uma garantia geral a B/C arbitrários nem exclusividade dos gráficos à
tela. Os quatro vetores de argumentos e FarCall foram conferidos nos bytes da
ROM original, além dos componentes binários e das palavras RGB da paleta.

`PwSaveConfirm_Run` (`67:6536`) armazena o argumento A em
`wPwSaveConfirm_Variant`. Em `67:65D9`, o código lê esse byte; o `jr nz` em
`67:65DD` salta o mapa 5D. Portanto `variant0` é a condição literal provada,
e não a alegação de uma variante universalmente padrão. A alternativa não zero
usa `71:6F6F`, pelo ramo que já permanece **PROBABLE**. A cópia do par usa
18×20=360 bytes por plano, avançando a mesma origem para atributos.

Esse vínculo é explícito em `tools/screen_png.py`: `derive_rows` remove a
extensão do tilemap para formar `name` e acrescenta `.screen.png` para `png`.
`read_screens` indexa pelo nome, e os comandos de import/export selecionam essa
chave. O nome novo é, portanto, também um seletor novo; o antigo não ganha um
alias automático de CLI. A proposta troca conjuntamente a chave e o caminho
do PNG existente, preservando seus bytes. Não é um modelo novo ou um PNG novo.

Ambos os modelos atuais continuam **HYPOTHESIS**, com 252/360 células
resolvidas. Preservam-se modo signed, métricas, evidência e referências externas.
O modelo de `71:6F6F` conserva a identidade, seus arquivos e a célula de paleta
vazia; somente as referências aos dois arquivos de tiles 5D acompanham a mudança.
Os tiles/paletas compartilhados 5F e objetos de confirmação 4A ficam fora desta
unidade. O intervalo depois de `7E70` não recebe interpretação nova.
