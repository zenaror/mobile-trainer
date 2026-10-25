# Integridade dos metadados de cargas de paleta

Data: 2026-10-18. Proposta privada de uma guarda de resolução em
`tools/palette_reads_check.py`, regressões em `tools/test_palette_reads.py` e
qualificação de dois comentários do Makefile. Nenhum fonte mantido, símbolo,
TSV, asset, idioma ou configuração foi modificado por esta preparação. Não foi
executado checker, teste, build ou emulador. Os resultados abaixo são análise
estática do código e dos dados; a prova fail-old/pass-new e os gates pertencem
à fase posterior do ROOT, depois da revisão independente.

## Defeito e contrato

O checker usa os registros cujo tipo, coluna3 de `gfx/previews/screen_ops.tsv`,
é `palette`. Se o nome da fonte não existe no mapa de símbolos e não é um
literal `$hhhh`, o código anterior executa `continue`. A lista retornada omite
silenciosamente um consumidor declarado. Assim, um retorno0 do checker pode
ocultar uma perda de cobertura após renomeação, mesmo sem bytes alterados.

O caso que revelou a lacuna é a linha física826: consumidor
`SettingsPhone_ChoiceMenu_Setup`, `engine/settings/choice_menu.asm:147`,
`palette`, `Data_4D_5510`, banco4D, `n=64 dest=$D800`. A instrução mantida já
usa `Palette_SettingsPhone_ChoiceMenu_Bg`; os dois nomes ainda são coaliases em
4D:5510, portanto a divergência textual atual não omite um tuple. A futura
retirada/renomeação de `Data_4D_5510`, sem corrigir essa célula por consumidor,
faria o helper antigo devolver161 cargas em vez de162. Este pacote não faz a
renomeação nem a correção do TSV. O estudo e a revisão selados em
`jp-settings-mixed-upload-source-study-20261017` (review artifact) e
`jp-settings-mixed-upload-review-20261017` (review artifact) mantêm a proposta5510 separada.

A guarda proposta troca apenas esse `continue` por
`PaletteMetadataError`, subclasse de `ValueError`, com caminho do TSV, linha
física, label ausente e localizador do consumidor. `main` captura essa exceção
específica, escreve `ERROR palette_reads_check:` em stderr e retorna1 antes de
analisar regiões; não anuncia sucesso de um subconjunto. `with open` fecha o
arquivo no caminho de erro. Nenhuma nova allowlist permite um nome ausente.

A resolução normal conserva a ordem e multiplicidade de `(bank, addr, n)`:
nome conhecido usa o banco/endereço do mapa, ` + $hex` soma o offset e o literal
numérico `$hhhh` usa o banco do registro. Os filtros de comentários, linhas
vazias/curtas e tipos distintos de `palette` permanecem. Formatos malformados
não ganham recuperação ou nova linguagem de expressões. `read_sym`,
`parse_regions`, `merge_loads`, `check` e `REVIEWED_OVERREADS` permanecem
inalterados; não há nova exceção de overread nem mudança do ABI dessas funções.

## Censo finito e fronteira de cobertura

Uma inspeção independente dos dados, sem importar/executar o checker, confirmou
162 linhas resolvidas:139 identificadores simples e23 identificadores com offset,
zero nomes ausentes e zero literais numéricos no corpus atual. Todos os162 tuples
por linha são exatos aos da família aceita, usando seu SYM fresco congelado
`2b84a91d379d973234bf7acf1181027c26bd7dab9c66e07d9bfff446be960323`.
Isso é contexto de coordenadas; não é leitura de build ativo nem execução do
checker proposto. Os branches de resolução das linhas atuais estão preservados
no fonte, e a comparação executada de todos os tuples continua pendente no ROOT.

Há também11 registros de paleta cujo tipo é explicitamente `UNRESOLVED` e cujo
banco não é imediato. Eles continuam excluídos, assim como tiles, mapas e
sequências. Um identificador ausente num registro `palette` não se transforma em
um desses casos dinâmicos: agora produz erro. A guarda cobre a integridade dos
registros resolvíveis fornecidos pelo catálogo, não todas as leituras de paleta
da ROM, tabelas dinâmicas, ponteiros computados, aparência de tela ou hardware.
O número162 descreve este baseline e não é fixado em produção como limite.

Os dois comentários do Makefile e a primeira linha da docstring do checker agora
qualificam a cobertura como cargas de paleta resolvidas registradas em
`screen_ops.tsv`. As receitas/alvos/flags do Makefile são byte a byte mantidos;
`tools/test_palette_reads.py` já pertence a `make test`.

## Regressões propostas, ainda não executadas

Seis métodos novos em uma classe de testes usam apenas TSVs temporários e mapas
mínimos em memória. Os testes anteriores são preservados. Não há dependência de
ROM, build, pacote privado ou arquivo mantido; cada fixture é criada dentro de
`TemporaryDirectory`.

1. Registro real826, precedido por825 comentários, com Data5510 ausente e o
   coalias BG presente: exigir `ValueError` e diagnóstico com linha/label. O
   helper antigo não lança erro, então deve falhar a asserção pelo defeito real.
2. Registro com alias ainda presente e depois célula corrigida a `Palette_*`:
   obter o mesmo `(4D,5510,64)`, mantendo separado o OBJ `(4D,5538,8)`.
3. Nome conhecido com offset, literal numérico, literal+offset e duplicata:
   conservar banco, endereço, bytecount, ordem e multiplicidade. O literal é
   cobertura sintética do formato suportado; há zero exemplos reais atuais.
4. Uma linha válida seguida de nome ausente com offset: erro explícito, sem
   devolver a lista parcial. O helper antigo também deve falhar essa asserção.
5. Registro real `UNRESOLVED/palette`, tiles5510, mapa, sequência, comentário,
   vazio e linha curta: continuam excluídos sem resolver labels fora do domínio.
6. `main` com mapa simulado e registro stale: exigir rc1, stderr útil e nenhuma
   análise de regiões. Com checker antigo a omissão leva a rc0; o teste deve
   falhar por esse comportamento, não por ImportError ou API nova inexistente.

As asserções negativas usam a classebase `ValueError`; o teste não importa nem
menciona `PaletteMetadataError`. Assim o arquivo novo carrega com o helper antigo
para a prova negativa. Somente `ast.parse` foi usado aqui para verificar sintaxe
e preservação estrutural das funções/testes existentes. Isso não confirma que
os testes passaram. O plano operacional posterior está em
`ROOT_TEST_PLAN.md` (review artifact).

O executor também escreveu o estudo5510 precedente; esta preparação não se
apresenta como revisão independente. A proposta permanece privada e depende de
revisão e rebase dos pins atuais antes da adoção pelo ROOT. R4 continua
estacionado e a etapa de idioma não é retomada.
