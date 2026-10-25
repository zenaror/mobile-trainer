# Caminhos dos recursos AdapterCheck e entrada de telefone no banco 4A

A coleção passa de `gfx/settings/screens_bank4a` para
`gfx/settings/adapter_check_and_phone_entry_bank4a`. O nome reúne os leitores
demonstrados e permanece PROBABLE como descrição agregada; não atribui uso
exclusivo a uma tela. O owner mantém banco 4A, intervalo `5F80..7378`, 5.112 bytes,
os 11 cabeçalhos CONFIRMED e o contêiner PROBABLE dos 80 bytes.

## Recursos ativos e contratos dos basenames

| Arquivo ou stem atual na nova coleção | Intervalo ROM | Contrato e limite |
| --- | --- | --- |
| `adapter_check_vram8000_vb0` | `5F80..6080`, 256 B | HDMA em `67:6385`, C=`10`, VRAM 0:`8000` |
| `adapter_check_vram9000_vb1` | `6080..6480`, 1.024 B | HDMA em `67:6397`, C=`40`, VRAM 1:`9000` |
| `adapter_check_vram9400_vb1_tile_prefix_256` | `6480..6580`, 256 B | Prefixo de tiles da janela mista de 1.024 B em `67:63A9` |
| `adapter_check_bg.pal` | `6580..65C0`, 64 B lógicos | Buffer BG, chamada `67:63BA`; basename já descritivo |
| `adapter_check_obj.pal` | `65C0..6600`, 64 B lógicos | Buffer OBJ, chamada `67:63CB`; basename já descritivo |
| `adapter_check_4a_6600.tilemap/.attrmap` | `6600..68D0`, 720 B | Par 20×18, chamada `67:63DC`; stem já descritivo |
| `phone_keypad_and_comment_vram9000_vb1` | `6920..6D20`, 1.024 B | Cargas completas por PhoneKeypad e PhoneComment em `67:4394/4A09` |
| `phone_keypad_and_comment_vram9400_vb1` | `6D20..7120`, 1.024 B | Cargas completas em `67:43A6/4A1B`; mesmos dois consumidores |
| `phone_keypad_kind0.tilemap/.attrmap` | `7120..71E8`, 200 B | Par 20×5 quando `wPhoneKeypad_Kind == 0`, chamada `67:43CE` |
| `phone_keypad_kind_nonzero.tilemap/.attrmap` | `71E8..72B0`, 200 B | Par 20×5 quando o campo é não zero, chamada `67:43E1` |
| `phone_comment_entry.tilemap/.attrmap` | `72B0..7378`, 200 B | Par 20×5 de PhoneComment, chamada `67:4A3D` |

Cada stem de tiles acompanha os dois arquivos existentes `.2bpp`/`.png`; cada
stem de mapa acompanha `.tilemap`, `.attrmap` e a composição `.screen.png`.
Nenhum PNG foi gerado, renderizado ou editado. Os 15 componentes ativos representam
5.032 bytes lógicos de catálogo e mantêm os mesmos bytes. A estrutura tipada
`68D0..6920`, 80 B, continua diretamente no ASM/macros, sem novo asset ativo.

## Coalias do prefixo e janela mista

O backing continua com 256 B e status CONFIRMED. A carga continua com C=`40`,
DE=`9401` e 1.024 B em `4A:6480..6880`, incluindo 256 B de tiles, 64 B BG,
64 B OBJ, 360 B de tilemap e 280 B de attrmap. A retirada do coalias não torna
essa janela homogênea, não muda seus leitores e não elimina as qualificações.
O [apêndice de revisão do KEEP](settings_text_entry_and_confirm_resource_names.md)
mantém a decisão antiga como história. Os aliases `Data_4B_70B0` e `Data_4B_7AD0`
ficam intactos e fora desta unidade.

## Byte-view legada: localização atual e origem

Os dois arquivos abaixo não são arte ativa nem fonte editável da ROM. Foram
preservados pela [tipagem publicada dos 80 bytes](adapter_check_object_data_80b.md)
e agora mudam somente de caminho, sem alteração de bytes, pixels ou codec legado.

O PNG continua com 40×8 pixels. O nome descreve a byte-view histórica dos dados
de objeto, não um novo formato RAW ou um recurso de tiles ativo. Não há linha
de catálogo, regra PNG ou INCBIN para esses legados. A edição do contêiner
PROBABLE continua no owner ASM: 69 B estruturados e 11 zeros finais UNKNOWN.
Os selos e caminhos das evidências anteriores permanecem literais.

## Modelos, catálogo e navegação

Os quatro names de modelo acompanham o stem do tilemap e o PNG correspondente,
sem aliases automáticos da antiga CLI. Os níveis e números ficam iguais: um
PROBABLE 360/360 e três HYPOTHESIS 76/100, conservando as três células de paleta
vazias. Uma mudança de nome de modelo não resolve suas lacunas visuais.

## Validação e limites

O pacote privado registra BEFORE exato, pins dos 27 movimentos, células por
chave/campo, diff, censo e projeção stdlib dos bytes com a ROM original. Os PNGs
são cópias byte a byte, sem render ou reencode. O produtor não executou helpers,
imports de projeto, testes, make, compilador, emulador, Git, nem trabalhou
no idioma inglês. Não foram copiados REVERSE_ENGINEERING.md ou docs/README.md.
