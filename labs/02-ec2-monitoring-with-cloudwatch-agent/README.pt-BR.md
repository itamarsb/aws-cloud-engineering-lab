# Lab 02 — Monitoramento moderno de EC2 com Amazon CloudWatch Agent

**Idioma:** [English (principal)](README.md) | **Português (Brasil)**


## Objetivos de aprendizagem

Ao concluir este laboratório, será possível:

- Reutilizar uma instância EC2 existente
- Instalar o Amazon CloudWatch Agent
- Configurar o agente por meio de um arquivo JSON
- Coletar métricas de memória
- Coletar métricas de disco
- Enviar métricas personalizadas ao Amazon CloudWatch
- Criar um dashboard no CloudWatch
- Validar as métricas coletadas

## Serviços AWS

```text
| Serviço             | Finalidade                               |
| ------------------- | ------------------------------------- |
| Amazon EC2          | Máquina virtual Linux                 |
| AWS Systems Manager | Acesso seguro ao shell (Session Manager) |
| Amazon CloudWatch   | Métricas e dashboard                 |
| IAM                 | Permissões para o CloudWatch Agent      |
```


---

## Arquitetura

```mermaid
flowchart TB

    USER["Engenheiro / Participante do laboratório"]

    subgraph AWS["Nuvem AWS"]

        SSM["AWS Systems Manager<br>Session Manager"]

        IAM["Função IAM do EC2<br>AmazonSSMManagedInstanceCore<br>CloudWatchAgentServerPolicy"]

        subgraph EC2["Instância Amazon EC2 - Ubuntu Server"]

            OS["Sistema operacional Linux"]

            SYSTEM_METRICS["Métricas do sistema operacional<br>CPU, memória e disco"]

            CONFIG["Configuração do CloudWatch Agent<br>config.json"]

            AGENT["Amazon CloudWatch Agent"]

            OS --> SYSTEM_METRICS
            SYSTEM_METRICS -->|"Coletadas por"| AGENT
            CONFIG -->|"Define métricas e intervalos"| AGENT
        end

        subgraph CW["Amazon CloudWatch"]

            NAMESPACE["Namespace de métricas personalizadas<br>CWAgent"]

            METRICS["Métricas do CloudWatch<br>CPU, memória e disco"]

            DASHBOARD["Dashboard do CloudWatch<br>Visualização das métricas"]

            NAMESPACE --> METRICS
            METRICS --> DASHBOARD
        end

        SSM -->|"Acesso seguro sem SSH de entrada"| OS
        IAM -.->|"Concede permissões"| AGENT
        AGENT -->|"Publica métricas personalizadas via HTTPS"| NAMESPACE
    end

    USER -->|"Inicia uma sessão do Session Manager"| SSM
    USER -->|"Visualiza as métricas coletadas"| DASHBOARD
```

*Figura 1 — Arquitetura do Lab 02. A instância EC2 é acessada com segurança pelo AWS Systems Manager Session Manager. O CloudWatch Agent coleta métricas do sistema operacional conforme a configuração do arquivo `config.json` e as publica no namespace `CWAgent` do Amazon CloudWatch.*


---

### Tempo estimado

```text
25–30 minutos
```

---

### Custo estimado
```text
Elegível ao Free Tier

t2.micro

Métricas personalizadas do CloudWatch
≈ alguns centavos durante o laboratório
```

---


## Pré-requisitos

Antes de iniciar este laboratório, é necessário ter concluído:

- ✅ Lab 01 — EC2 com Session Manager
- Uma instância EC2 com Ubuntu já criada
- Uma função IAM com a política:

```text
AmazonSSMManagedInstanceCore
```
e também com:
```text
CloudWatchAgentServerPolicy
```

A instância utilizada é a mesma criada no Lab 01.


### Políticas IAM necessárias

| Política | Finalidade |
|---------|----------|
| AmazonSSMManagedInstanceCore | Permite o acesso pelo Session Manager |
| CloudWatchAgentServerPolicy | Permite ao CloudWatch Agent publicar métricas e logs |


### Antes

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_18.jpg)

Apenas uma política estava anexada.

❌ A política `CloudWatchAgentServerPolicy` estava ausente.

---

### Depois

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_19.jpg)

Ambas as políticas foram anexadas.

✅ Pronto para continuar.

---

## Etapa 1 — Iniciar a instância EC2

Inicie a instância EC2 criada durante o Lab 01.

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_01.jpg)

Em seguida:

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_02.jpg)

Estado esperado:

```text
Running
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_03.jpg)

---

## Etapa 2 — Conectar pelo Session Manager

```text
EC2

↓

Instance

↓

Connect

↓

Session Manager

↓

Connect
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_04.jpg)



---

## Etapa 3 — Atualizar o Ubuntu

Execute:

```text
sudo apt update
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_05.jpg)


---

## Etapa 4 — Baixar o CloudWatch Agent

Em vez de tentar instalar o agente pelo `apt`, utilize o pacote oficial da AWS, conforme o procedimento documentado para o Ubuntu:

```text
cd /tmp

wget https://amazoncloudwatch-agent.s3.amazonaws.com/ubuntu/amd64/latest/amazon-cloudwatch-agent.deb
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_06.jpg)

Verifique o arquivo baixado:

```text
ls -lh amazon-cloudwatch-agent.deb
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_07.jpg)


---

## Etapa 5 — Instalar o agente

Execute:

```text
sudo dpkg -i amazon-cloudwatch-agent.deb
```

Saída esperada:

```text
Setting up amazon-cloudwatch-agent...
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_08.jpg)





---

## Etapa 6 — Criar o arquivo de configuração

Crie manualmente o diretório de configuração:

```text
sudo mkdir -p /opt/aws/amazon-cloudwatch-agent/etc
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_09.jpg)


Abra o editor:
```text
sudo nano /opt/aws/amazon-cloudwatch-agent/etc/config.json
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_10.jpg)


Insira o conteúdo JSON abaixo:

```JSON
{
  "agent": {
    "metrics_collection_interval": 60,
    "run_as_user": "root"
  },
  "metrics": {
    "append_dimensions": {
      "InstanceId": "${aws:InstanceId}"
    },
    "metrics_collected": {
      "mem": {
        "measurement": [
          "mem_used_percent"
        ]
      },
      "disk": {
        "measurement": [
          "used_percent"
        ],
        "resources": [
          "/"
        ]
      }
    }
  }
}
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_11.jpg)


Salve o arquivo:

```text
CTRL + O

ENTER

CTRL + X
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_12.jpg)



---

## Etapa 7 — Iniciar o agente

Execute:

```text
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a fetch-config \
-m ec2 \
-c file:/opt/aws/amazon-cloudwatch-agent/etc/config.json \
-s
```


![Lab02](screenshots/Lab02_Clipboard_07-21-2026_14.jpg)




---

## Etapa 8 — Verificar o status do agente

Execute:

```text
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
-a status
```

Saída esperada:

```text
{
  "status":"running"
}
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_15.jpg)



---

## Etapa 9 — Verificar as métricas

No console AWS, acesse:

```text
CloudWatch

↓

Metrics

↓

Classic metrics

↓

CWAgent
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_21.jpg)

Verifique as métricas:

```text
mem_used_percent

disk_used_percent
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_22.jpg)

Em seguida:

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_23.jpg)


---


## Etapa 10 — Criar o dashboard

No console AWS, acesse:

```text
CloudWatch

↓

Dashboards

↓

Create Dashboard
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_24.jpg)


Nome sugerido:

```text
EC2_Monitoring_Dashboard
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_25.jpg)


Na tela atual, mantenha as opções:

- Fonte de dados: CloudWatch (já selecionada)
- Tipo de dados: Metrics (já selecionado)
- Tipo de widget: Line (já selecionado)

Clique em:

```text
Next
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_26.jpg)

Selecione:

```text
EC2
```

Escolha a categoria:

```text
Per-Instance Metrics
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_27.jpg)


### Widget 1 — Utilização da CPU (%)

Na lista de métricas, procure por:

```text
CPUUtilization
```

Marque a caixa de seleção correspondente à instância (`lab01-ec2-ssm`).

O gráfico deverá aparecer imediatamente na parte superior da tela.

Depois, clique em:

```text
Create widget
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_28.jpg)


### Widget 2 — Utilização da memória (%)

Depois de criar o primeiro widget:

1. Clique novamente no botão **+** do dashboard.

2. Selecione **Metrics**.

3. Clique em **CWAgent**.

A tela deverá exibir duas categorias (indicadas pelo número "2" ao lado de CWAgent).

Selecione a segunda categoria.

Procure por:

```text
mem_used_percent
```

Selecione:

```text
Create widget
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_29.jpg)


### Widget 3 — Utilização do disco (%)

Repita o procedimento:

```text
+
↓
Metrics
↓
CWAgent
```

Selecione a outra categoria.

Procure por:

```text
disk_used_percent
```

Selecione a métrica referente ao disco principal (`/`).

Selecione:

```text
Create widget
```

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_30.jpg)


### Resultado final

![Lab02](screenshots/Lab02_Clipboard_07-21-2026_31.jpg)


---



> [!TIP]
> **Lição aprendida**
>
> Durante a execução deste laboratório, o CloudWatch Agent foi instalado com sucesso, mas nenhuma métrica apareceu no CloudWatch.
>
> A causa identificada foi a ausência de uma política IAM:
>
> - CloudWatchAgentServerPolicy
>
> Após anexar essa política à função IAM da instância EC2, o agente começou a publicar as métricas.




---
---

## Considerações para ambientes de produção

Para simplificar o procedimento, a aplicação de etiquetas (*tags*) aos recursos foi intencionalmente omitida neste laboratório.

Em ambientes de produção, recomenda-se aplicar etiquetas aos recursos AWS para apoiar:
- Alocação de custos
- Governança
- Identificação dos responsáveis pelos recursos
- Automação
- Conformidade
