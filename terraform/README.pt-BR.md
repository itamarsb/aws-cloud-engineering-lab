# Laboratórios Terraform

**Idioma:** [English (principal)](README.md) | **Português (Brasil)**

Este diretório reúne as implementações em **Terraform** relacionadas aos laboratórios manuais da AWS disponíveis neste repositório.

A trilha busca reproduzir as arquiteturas dos laboratórios manuais por meio de **Infraestrutura como Código (IaC)**. Assim, é possível comparar o provisionamento manual ao automatizado, mantendo objetivos de aprendizagem equivalentes.

## Laboratórios disponíveis

| Laboratório | Documentação | Situação |
| --- | --- | --- |
| **Lab 00 — Preparação da estação de trabalho e autenticação AWS** | [Guia em português](00-workstation-and-aws-authentication/README.pt-BR.md) | Preparação local e da autenticação; pode envolver criação de usuário IAM e chaves de acesso |
| **Lab 01 — EC2 e SSM com Terraform** | [Guia em português](01-ec2-and-ssm/README.pt-BR.md) | Arquivos Terraform disponíveis; tutorial detalhado ainda em desenvolvimento |

> [!NOTE]
> O Lab 00 prepara o ambiente. No Lab 01, o roteiro prevê construção, provisionamento, validação e destruição da infraestrutura, mas o tutorial detalhado publicado atualmente cobre apenas a **Etapa 1**, dedicada à estrutura do projeto e às configurações iniciais. A existência dos arquivos `.tf` não comprova que a infraestrutura tenha sido implantada e validada na AWS.

## Conteúdo previsto para os laboratórios

Conforme forem implementados e validados, os laboratórios Terraform devem incluir:

- provisionamento da infraestrutura;
- comandos de validação;
- resultados esperados;
- diagramas de arquitetura;
- considerações sobre custos;
- limpeza automatizada dos recursos;
- verificação após a destruição da infraestrutura;
- lições aprendidas.

## Laboratório manual relacionado

Implementação manual de referência:

[Lab 01 — EC2 e SSM](../labs/01-ec2-and-ssm/README.pt-BR.md)

A implementação Terraform busca reproduzir a mesma arquitetura por meio de Infraestrutura como Código, utilizando recursos com nomes próprios para permitir a comparação sem substituir a infraestrutura manual existente.
