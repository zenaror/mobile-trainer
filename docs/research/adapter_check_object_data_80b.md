# AdapterCheck: estrutura de 80 bytes e retenção da antiga byte-view

Proposta privada de tipagem, 2026-10-18. `4A:68D0..6920` deixa de ser apresentado
como uma folha de tiles ativa: o fonte passa a descrever os mesmos 80 bytes com
macros de objeto, lista de frames, registros e script. O nome raiz é refinado de
`AdapterCheck_ObjTableAndAnimData` para `AdapterCheck_ObjTable`, no mesmo endereço
`4A:68D0`. O status **PROBABLE** permanece. Os 11 bytes finais continuam com
finalidade **UNKNOWN**; não são declarados padding ou unused.

O cabeçalho anterior usava uma heurística de coerência 2bpp. O nome de objeto e
o leitor positivo contradizem a classificação como tile art; essa contradição
já aparece em naming2_verify_data2b:E1 e no item 476 de image_text_inventory.
Essas notas históricas ficam preservadas. A correção atual muda a representação
e a classificação ativa, sem atribuir uma aparência visual à estrutura.

## Consumidor e limites

`AdapterCheck_DrawScreen` passa HL=`wSpriteSlot0`, DE=`68D0`, A=`4A`, B=`81` a
`Sprite_InitSlot` no FarCall de `67:63EC`. O vetor original é:

```text
21 00 DA 11 D0 68 3E 4A 06 81 CD D1 06 82 0A 00
```

O helper `00:0A82` seleciona o banco e o slot WRAM 7; `00:0AB8` escolhe
`DE+4*(B&$3F)`. B=`81` seleciona a entrada 1. A entrada 0 é nula e não é um
consumidor positivo; não existem quatro entradas demonstradas nesse contêiner.

| Componente | Intervalo exclusivo | Tamanho |
| --- | --- | ---: |
| Entrada 0 nula e entrada 1 = (`68D8`, `690C`) | 68D0..68D8 | 8 B |
| Lista de quatro ponteiros | 68D8..68E0 | 8 B |
| Frame com contagem 2 | 68E0..68E9 | 9 B |
| Frame com contagem 2 | 68E9..68F2 | 9 B |
| Frame com contagem 6 | 68F2..690B | 25 B |
| Frame com contagem 0 | 690B..690C | 1 B |
| Script: `(0,20),(1,20),(2,20),(3,20)` | 690C..6915 | 9 B |
| Zeros, finalidade UNKNOWN | 6915..6920 | 11 B |

São 69 bytes de estruturas mais 11 bytes desconhecidos. A lista `68D8..68DF`
não corresponde às entradas 2 e 3: seus quatro words apontam para `68E0`,
`68E9`, `68F2` e `690B`. As macros usadas já existem em
`constants/sprite_macros.inc`; nenhuma função de ferramenta ou formato genérico
novo é introduzido.

Os seis novos nomes próprios são `AdapterCheck_Anim1Frames`,
`AdapterCheck_Anim1Frame0..3` e `AdapterCheck_Anim1Script`. Anim1 corresponde à
entrada 1 demonstrada. A tabela agora termina em `68D8` (8 B); a lista termina
no primeiro frame, `68E0` (8 B); os registros têm 9/9/25/1 B. O script tem 9 B,
seguido pelos 11 bytes UNKNOWN até `6920`. O checker pode emitir uma nota
chamando esses zeros de “padding”; esse termo do checker não é adotado como
finalidade provada. Não se adiciona um label que atribua papel à cauda.

Esse refinamento do antigo nome agregado evita que uma raiz chamada
ObjTableAndAnimData fique artificialmente limitada aos 8 bytes da tabela após
inserir os nomes globais dos filhos. Os dois operandos DE/BANK de
`engine/settings/adapter_check.asm` acompanham o nome novo, com o mesmo endereço
e banco. STYLE exige globais para alvos usados em DW/expressões: a alternativa
de seis locais foi considerada e não adotada. A tentativa com nomes globais de
papel coordenado também foi preservada e substituída antes da selagem final.
Não há mudança de helper para contornar um guard; os novos nomes e limites
correspondem aos contratos existentes de ObjTable/Anim1Frames/Frame/Script.

Mapa da raiz histórica: `AdapterCheck_ObjTableAndAnimData` →
`AdapterCheck_ObjTable`, ambos em `4A:68D0`. O novo nome descreve a tabela de
8 B; o cabeçalho de 80 B continua a documentar a coleção de estruturas e a
cauda desconhecida. `tools/data_consumers` e `analysis/naming2/data2_renames` são
especificações históricas do passe que atribuía quatro entradas; permanecem
com E1 como errata. Os registros/PNG antigos de `gfx/previews` conservam o nome
da captura histórica, vinculado aqui pelo endereço: não se renomeia nem regenera
uma captura para acompanhar um símbolo mantido. Não se promete reproduzir a
velha ferramenta de atribuição contra o namespace atual, nem se reabre o
trabalho de idioma.

`Data_4A_68D0` era coalias no mesmo endereço e sua linha vira uma linha em
branco. A busca finita no fonte mantido não encontrou operandos ativos do nome
antigo nem locais no owner; a única célula de metadado atual que o usava era a
linha do catálogo agora retirada. A previsão isolada é +5 símbolos: seis papéis
novos menos esse alias. Não se presume o total SYM ou um parent futuro.

## Arquivos legados preservados

| Arquivo mantido no mesmo path | Bytes | SHA-256 |
| --- | ---: | --- |
| `gfx/settings/screens_bank4a/tiles_68d0.2bpp` | 80 | `fd7e2e1950b98b4f5ac150a61f9c6db23cd927af6d184796aca47bc550ace9e3` |
| `gfx/settings/screens_bank4a/tiles_68d0.png` | 184 | `dddf77fb6f1836a56a58a8eff7b50cd8afcff4c8bc9ff0da549ebe3ebb964783` |

O binário é uma cópia dos 80 bytes originais. O PNG 40×8, indexed 8, com paleta
white/170/85/black, conserva os mesmos bytes codificados; a leitura stdlib da
byte-view reconstitui o binário. Isso não o torna arte de tiles. Nenhum dos
dois arquivos é apagado, renomeado ou editado; são referências legadas, fora do
circuito ativo de fonte editável da região. Para editar a estrutura mantida,
o ponto de edição passa a ser o ASM/macros, com os limites originais.

A linha de 80 B sai de `gfx/assets.tsv`, sua regra sai de `gfx/png_rules.tsv` e
as duas entradas correspondentes saem de `gfx/png.mk`. Deixar uma linha de
catálogo sem INCBIN seria inválido, pois gfx_export exige uma utilização por
linha. Os checkers atuais percorrem catálogo/regras/INCBIN; não exigem apagar
todo arquivo físico que ficou fora do catálogo. A regra genérica make para
2bpp ainda pode ser solicitada manualmente, mas o arquivo legado deixa de ser
uma dependência normal que alimenta esta região da ROM.

O delta ativo é -1 asset/-80 bytes lógicos de catálogo, -1 regra e -1 fonte PNG
de tiles; o número de arquivos físicos e os bytes da ROM permanecem. O RAW
explícito do banco 42 não muda e nenhum registro RAW novo é criado. Os
contadores dos índices são ajustados como catálogo ativo, sem alegação de
cobertura de todo byte da ROM. Na tabela “Still db”, o parser conta só a nova
cauda literal de 11 bytes, agrupada pelo label do contêiner de objeto; não
conta os 69 bytes de macros. Essa categoria automática não identifica a
finalidade dos 11 bytes desconhecidos.

Os demais recursos do banco 4A, em particular a janela mista de 1.024 bytes
que parte de `6480`, permanecem. Os quatro modelos de tela e seus nomes/PNGs
não mudam: um PROBABLE 360/360 e três HYPOTHESIS 76/100, com as três células
de paleta vazias. A estrutura de 80 B não era usada como tile source por nenhum
desses modelos. Capturas, config, geradores e evidências históricas não são
reescritos. O estudo anterior de 27 movimentos/75 células é um snapshot anterior
a este reparo e precisa ser rederivado se ROOT autorizar depois uma migração
de caminhos do banco 4A.

O template textual EDIT_SECTION de `tools/gfx_export.py` e seu espelho neste
índice passam a dizer “All tile blocks in the active catalogue”. Essa única
troca de texto evita prometer que todo arquivo físico 2bpp é uma fonte ativa;
funções, AST de código, receitas e dependências da ferramenta permanecem iguais.

## Evidência e validação

O pacote privado contém OWN anterior à edição, BEFORE exato, pins de retenção
e comparação stdlib da emissão de 80 B e dos endereços internos com a ROM
original. É projeção estática, não um receipt de build. PROBABLE permanece
PROBABLE; mapper/WRAM 7/slots, máscaras, hooks, IRQ e reentrada conservam os
limites do motor. Não se prova exibição natural, hardware ou ausência universal
de outros usos.

Nenhum helper, teste, build, emulador, export ou render foi executado neste passe.
Só ROOT, após revisão independente e composição no parent real, pode integrar
e executar as verificações autorizadas para confirmar a ROM e o delta real SYM.


## Localização atual e proveniência após a migração 4A (2026-10-18)

A [tipagem dos 80 bytes foi publicada](https://github.com/zenaror/mobile-trainer/commit/0c02c5369e47597f022df0663a2749acb3bfb12c). A descrição anterior registra os paths retidos naquele passe; não é uma promessa de conservar esses paths em migrações posteriores.

Os arquivos legados atuais são `gfx/settings/adapter_check_and_phone_entry_bank4a/legacy_byteviews/adapter_check_object_data_4a_68d0.2bpp` (80 B) e `gfx/settings/adapter_check_and_phone_entry_bank4a/legacy_byteviews/adapter_check_object_data_4a_68d0.png` (PNG 40×8, 184 B). Os bytes, pixels e hashes são os mesmos dos caminhos históricos `gfx/settings/screens_bank4a/tiles_68d0.2bpp` e `gfx/settings/screens_bank4a/tiles_68d0.png`. Eles ficam fora do catálogo e das regras ativas; a região PROBABLE em 4A:68D0 é editada em ASM/macros, e seus 11 zeros finais continuam UNKNOWN.

O owner atual é `gfx/settings/adapter_check_and_phone_entry_bank4a.asm`. A raiz e seus seis nomes globais próprios mantêm os mesmos endereços, níveis e bytes. Os arquivos legados são referências preservadas, sem INCBIN, linha de catálogo ou regra PNG ativa para a região. O [mapa de paths](gfx_resource_path_map.tsv) e a [nota da migração](adapter_check_and_phone_entry_4a_resource_paths.md) ligam os nomes antigos aos atuais. A proposta de caminhos não altera os selos ou capturas da tipagem e não constitui um novo resultado natural ou de hardware.

## Releitura dos relatórios de dados no checkpoint japonês `d69ebc14`

Os 70 relatórios salvos `traces/detail/*/dataaccess.tsv` foram pareados com os 70 relatórios de cobertura; o digest agregado dos inputs é `b9ebe5fbf81b30d7782425f645df7f0c503436e1f972e5045b9669b74bd3dc27`. Sessenta e nove relatórios registram leituras de dados cobrindo os 65 bytes da entrada 1, lista de frames, quatro frames e script em `4A:68D4..6915`. Nenhum reporta leitura da entrada nula `68D0..68D4` ou dos 11 zeros em `6915..6920`. Os bytes finais permanecem `00` na ROM original. O hook registra leituras de dados ROM e exclui instruction fetch; esta é uma releitura do corpus salvo, não uma nova execução do emulador. A finalidade dos zeros continua UNKNOWN; o resultado não prova padding, não-uso global, aparência visual ou seleção universal. A reprodução está em `jp-adapter-check-tail-audit-20261023` (review artifact).
