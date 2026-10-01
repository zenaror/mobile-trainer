# Memória do Mobile Trainer no OMM

Este projeto mantém sua memória OMM na pasta `memory/`, versionada junto com o repositório. O OMM guarda descobertas, decisões, dúvidas e passagens de trabalho; o código, os testes e os arquivos originais continuam sendo as fontes para confirmar o que foi implementado.

## Uso rápido

Com o OMM instalado no computador, abra o terminal nesta pasta:

```sh
omm search "texto para procurar"
omm context "assunto da tarefa"
omm remember --kind observation --title "O que foi observado" --content "Descrição curta" --source "docs/arquivo.md" --evidence "docs/arquivo.md: seção relevante"
omm handoff --status in_progress --summary "Onde o trabalho parou" --next "Próxima ação"
```

Se o OMM ainda não estiver instalado, consulte o README do repositório OMM e instale-o uma vez. Não é necessário instalar um servidor ou serviço de busca. A pasta `.omm/` contém apenas um índice local; `omm rebuild` o recria a partir de `memory/`.

## Regras para esta memória

- `AGENTS.md` continua sendo a fonte das regras de trabalho e dos contratos do projeto.
- Guarde no OMM apenas conhecimento que ajude sessões futuras: descobertas, decisões, dúvidas, resultados e handoffs.
- Inclua caminhos para as evidências. Uma busca encontrar uma anotação não transforma hipótese em fato.
- Preserve a ROM original e as regras de reconstrução binária já descritas em `AGENTS.md`.
- Não copie toda a documentação para a memória. Mantenha os documentos existentes e registre no OMM um resumo com links para eles.

