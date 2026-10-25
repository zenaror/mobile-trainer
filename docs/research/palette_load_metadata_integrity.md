# Integridade dos metadados de cargas de paleta

## Defeito e contrato

O checker usa os registros cujo tipo, coluna3 de `gfx/previews/screen_ops.tsv`,
é `palette`. Se o nome da fonte não existe no mapa de símbolos e não é um
literal `$hhhh`, o código anterior executa `continue`. A lista retornada omite
silenciosamente um consumidor declarado. Assim, um retorno0 do checker pode
ocultar uma perda de cobertura após renomeação, mesmo sem bytes alterados.

O caso que revelou a lacuna é a linha física826: consumidor `SettingsPhone_ChoiceMenu_Setup`, `engine/settings/choice_menu.asm:147`, `palette`, `Data_4D_5510`, banco4D, `n=64 dest=$D800`.

A guarda proposta troca apenas esse `continue` por `PaletteMetadataError`, subclasse de `ValueError`, com caminho do TSV, linha física, label ausente e localizador do consumidor.

`with open` fecha o arquivo no caminho de erro.

Nenhuma nova allowlist permite um nome ausente.

A resolução normal conserva a ordem e multiplicidade de `(bank, addr, n)`:
nome conhecido usa o banco/endereço do mapa, ` + $hex` soma o offset e o literal
numérico `$hhhh` usa o banco do registro. Os filtros de comentários, linhas
vazias/curtas e tipos distintos de `palette` permanecem. Formatos malformados
não ganham recuperação ou nova linguagem de expressões. `read_sym`,
`parse_regions`, `merge_loads`, `check` e `REVIEWED_OVERREADS` permanecem
inalterados; não há nova exceção de overread nem mudança do ABI dessas funções.

## Censo finito e fronteira de cobertura

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
