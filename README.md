# HR Attrition – Análise de Recursos Humanos (IBM HR)

Projeto de grupo do curso **AiDAPT – Data Analytics** (Cegid Academy): análise de *attrition* (saída de colaboradores) sobre o dataset **IBM HR**, com exploração em R, base de dados em SQL Server e dashboard em Power BI.

**Grupo 3 · AiDAPT 04**

<!-- Adicionar aqui uma captura do dashboard, por exemplo:
![Dashboard](imagens/dashboard.png) -->

## Perguntas de negócio

O dashboard foi construído para responder a quatro perguntas de RH:

1. **Sabemos porque é que as pessoas saem?**
2. **E a satisfação dos que ficaram?**
3. **Quem se irá reformar nos próximos 5 anos?**
4. **Estamos perto dos 50-50 na igualdade de género?**

A apresentação final está em [`Apresentacao_VA_03.pdf`](Apresentacao_VA_03.pdf).

## Dados

- **IBM HR:** 1 470 colaboradores e 35 variáveis (`Excel/IBM_HR.csv`). 237 colaboradores saíram e 1 233 ficaram.
- **Inquérito de satisfação:** 1 233 colaboradores, com cinco indicadores numa escala de 1 a 4 (ambiente, envolvimento, satisfação no trabalho, relações e equilíbrio trabalho-vida), em dois períodos de medição: baseline de maio e uma medição posterior (`Excel/SurveyPingPongTable.csv`).

## Principais conclusões

- A saída associa-se a **horas extra** e a **salários mais baixos**. Quem sai tende a ganhar menos e a fazer mais horas extra do que quem fica, dentro de cada função.
- As funções com mais *attrition* são **Sales Representative**, **Laboratory Technician** e **Human Resources**. A rotatividade parece resultar de uma combinação de fatores, sobretudo compensação e sobrecarga de trabalho, e não da função em si.
- Quem sai tem, em média, **menos anos na empresa** e **menos anos com o gestor atual**; os colaboradores **solteiros** saem mais do que casados e divorciados.
- O **género não é um fator determinante** da saída. A retenção de mulheres é forte, sobretudo em R&D, mas HR e cargos de chefia em Sales perdem mulheres de forma desproporcionada.

**Recomendações:** reforçar o acompanhamento nos primeiros 24 meses, rever a política de horas extra nos cargos mais críticos e iniciar um plano de sucessão para a posição de Manager em risco.

Nota: estas conclusões vêm da análise exploratória e do dashboard. Indicam associações, não causas.

## Como está construído

1. **Exploração em R** (`R/projetoHR_Grupo3.ipynb`): estatísticas descritivas, distribuição de salários, idade e antiguidade, e comparação entre quem sai e quem fica por função, horas extra, género, estado civil e distância a casa.
2. **Base de dados em SQL Server** (`SQL/`): modelo relacional normalizado, com tabelas de lookup, chaves primárias e estrangeiras e restrições (`CHECK`).
3. **Modelo em estrela no Power BI** (`PBI/`): tabelas de factos (`FactEmployee`, `FactSatisfaction`), dimensões (`DimEmployee`, `DimEducation`, `DimSurvey`, `DimCalendar`, entre outras), medidas DAX e dicionários de colunas, medidas e relações.

## Estrutura do repositório

```text
├── Apresentacao_VA_03.pdf
├── Excel/                     # dados de origem (IBM HR e inquérito)
├── R/                         # exploração dos dados em R
├── SQL/                       # criação e preenchimento da base de dados
└── PBI/                       # relatório Power BI (.pbix)
```

## Como reproduzir

### Base de dados (SQL Server)

1. Criar uma base de dados chamada `PBI` e importar `Excel/IBM_HR.csv` como tabela `Ibm_HR` (*Tasks → Import Flat File*). Alterar `Attrition` e `OverTime` para `nvarchar(5)` e não definir chave primária.
2. Executar os scripts por esta ordem:

| Script | O que faz |
|---|---|
| `01CriacaoTabelas.sql` | Cria as tabelas e as restrições |
| `02InserirValoresKaggle.sql` | Preenche as tabelas de lookup (por exemplo, níveis de educação) |
| `03InsertNasTabelas.sql` | Distribui os dados de `Ibm_HR` pelas tabelas do modelo |
| `04InserirValoresSurvery.sql` | Carrega os dois períodos do inquérito de satisfação |
| `05ConsultasNegocio.sql` | Consultas de negócio: perfil da empresa, risco de *attrition*, risco de reforma |

### Dashboard

Abrir `PBI/Projeto IBM HR - Grupo 03 AIDAPT04.pbix` no **Power BI Desktop**. O relatório usa visuais personalizados (por exemplo, Inforiver e Tornado Chart), que podem pedir instalação.

## Ferramentas

Power BI · DAX · SQL Server (T-SQL) · R · Excel
