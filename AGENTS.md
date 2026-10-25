# Mobile Trainer — instruções para agentes

## O projeto

Engenharia reversa da ROM **Mobile Trainer (Japan)**, o aplicativo de configuração do Mobile Adapter GB para Game Boy Color.
O objetivo é um código-fonte RGBDS legível que reconstrói a ROM original **byte a byte**. É uma reconstrução, não uma reescrita.

## Regras que valem sempre

- A ROM original nunca é alterada nem vai para o Git. Ela fica na raiz como `Mobile Trainer (Japan).gbc`; o hash está em `roms.sha256`.
- Depois de mudar o fonte, rode `make` e `make sym-check`. O resultado precisa ser `SHA-256 OK` e, com a ROM presente, `RESULT: IDENTICAL`.
  Só diga que algo é equivalente depois dessa comparação.
- Use os níveis `CONFIRMED`, `PROBABLE` e `HYPOTHESIS`. Sem evidência, mantenha nomes neutros (`Function_<banco>_<endereço>`,
  `Data_...`, `wRam_XXXX`) e registre a hipótese. Não esconda contradições: documente e corrija.
- Considere o banco selecionado ao interpretar um endereço. Não trate todo byte como código. Confira o que o Ghidra ou outra ferramenta disser.
- O fonte na raiz (`home/`, `engine/`, `data/`, `gfx/`, `audio/`, `lib/`) é mantido à mão. O gerador `tools/gen_asm.py` e as tabelas
  `config/` estão congelados como histórico: não rode `make regen`.
- Faça commits pequenos e coerentes. Commit e push só quando o Operador pedir ou já tiver combinado para a tarefa. Não reescreva histórico publicado.

- Não acrescente automaticamente trailers `Co-authored-by` de Claude/Anthropic ou de outras ferramentas de IA aos commits. Preserve autores, coautores humanos e créditos legítimos existentes; o uso de IA é informado no README.

## Onde encontrar

- Como compilar: `README.md` e `INSTALL.md`. Convenções do código: `STYLE.md`.
- Estado atual e perguntas em aberto: `REVERSE_ENGINEERING.md`. Índice das notas de pesquisa: `docs/README.md`.
  O mapa de responsabilidades da base comum está em `docs/README.md`, na seção "Project responsibilities"; preserve as fontes RGBDS na raiz.
- Regras completas de engenharia reversa (o texto integral que antes ficava neste arquivo): `docs/REVERSE_ENGINEERING_RULES.md`.
  Leia antes de um trabalho de análise.
- Editar imagens: `docs/EDITING_IMAGES.md`. Tradução de idioma: `docs/TRANSLATION.md` (só começa quando o Operador pedir).

## Documentação pública

- Descreva comportamento, formatos, endereços e limites da ROM de forma objetiva.
- Use o código e as ferramentas distribuídas pelo projeto como referências reproduzíveis.
- Não publique cronologias de execução, protocolos internos de revisão, recibos de tarefas ou dependências de artefatos privados.

## Continuidade e revisão

- Comece pelo estado atual do checkout, pelos documentos de referência e pelas evidências verificáveis. Notas históricas não substituem a revisão do código e do build.
- Mantenha detalhes pessoais, configurações locais, registros privados de continuidade e caminhos específicos de uma máquina fora dos arquivos versionados.
- Preserve decisões, hipóteses e resultados com origem e nível de evidência. Não grave senhas, tokens ou chaves.
- Para trabalhos paralelos, defina escopos disjuntos e integre as alterações de forma centralizada; não sobrescreva trabalho de outra sessão.

## Cleanup e retenção

Use a raiz do checkout ativo como diretório de trabalho e confirme `git rev-parse --show-toplevel` antes de escrever. Material de apoio local e temporários ficam em `.tmp/`, ignorada pelo Git, em subpastas próprias. Estar nesse diretório não autoriza exclusão automática. Caminhos locais e configurações pessoais não devem aparecer na documentação pública.

Ao fechar tarefa, checkpoint ou pausa, classifique os artefatos da própria tarefa e confira se algum processo ou revisão ainda depende deles. Arquivo ignorado ou não rastreado não é automaticamente descartável. Não remova trabalho de outra sessão, caminhos de origem incerta ou arquivos usados por operações ativas.

- `build/` e `mobile_trainer.gbc` são saídas reproduzíveis de `make`; `build/en/` também contém a visão de fontes, o cache e as saídas de `make english`. Preserve os outputs enquanto forem referência de comparação, revisão ou release aceita. Antes de limpar, conserve em armazenamento durável os comandos, ambiente, hashes, resultados, falhas e arquivos mínimos necessários para reproduzir e conferir o passe.
- Logs, relatórios e resultados intermediários em diretórios privados são temporários apenas depois dessa conferência. `/tmp` não é armazenamento permanente: preserve as evidências necessárias no material de apoio durável com origem e hashes registrados. Retenha falhas não explicadas e propostas pendentes até seu fechamento; depois remova duplicatas comprovadas da própria tarefa. Não use prazo universal nem exclusão por idade.
- ROM original, cópias de referência, ZIP do Operador, saves, fixtures, evidências de console/hardware, releases aceitas e backups/mapas da reescrita Git continuam protegidos enquanto necessários. Fontes e assets editáveis, inclusive PNGs e seus binários, paletas e mapas mantidos no Git, não são resíduos de build.

O `make clean` existente (igual a `make tidy`), com os valores padrão, remove somente `mobile_trainer.gbc` e `build/`, incluindo o cache inglês. Inspecione primeiro com `make -n clean` e confira o checkout, os caminhos reais, links e qualquer override de `ROM`, `BUILD` ou `RM`; um override pode mudar o alcance. Use esse comando somente depois de fechar as operações e preservar as referências necessárias. Para outros temporários, prefira uma lista explícita de arquivos conhecidos da própria tarefa, com inspeção antes da remoção. Não use `git clean -xfd`, globs amplos ou limpeza global.

Registre no relatório de encerramento o que foi removido, o que foi preservado e onde, e as pendências de origem ou retenção duvidosa; informe quantidade/tamanho quando a medição for simples. Não execute novos testes apenas para cleanup e não faça `make regen`.
