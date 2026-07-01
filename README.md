# 🛰️ Interface para Processamento Automatizado de Dados GNSS e Análise por PCA

Este projeto consiste no desenvolvimento de uma **interface gráfica em MATLAB** destinada à automatização do processamento de dados GNSS utilizados em estudos ionosféricos.

A aplicação foi desenvolvida para simplificar todas as etapas do processamento, desde a seleção dos arquivos até a geração das análises por **Análise de Componentes Principais (PCA)**, eliminando a necessidade de executar diversos scripts manualmente.

O objetivo principal é tornar o processamento mais rápido, organizado e acessível, permitindo que pesquisadores realizem análises de **Distúrbios Ionosféricos Propagantes (TIDs)** de forma totalmente automatizada.

---

# 🚀 Funcionalidades

## 📂 Importação dos Dados

- Seleção automática dos arquivos GNSS
- Leitura de arquivos `.CMN`
- Leitura de arquivos mensais de TEC
- Organização automática dos dados

---

## 📊 Processamento dos Dados

- Seleção do satélite (PRN)
- Aplicação do filtro de elevação
- Ajuste exponencial do STEC
- Remoção da tendência ionosférica
- Aplicação de média móvel
- Extração dos resíduos (TIDs)

---

## 🌍 Normalização do TEC

- Leitura dos arquivos mensais de VTEC
- Cálculo do TEC médio mensal
- Normalização automática

```text
ΔTEC = VTEC − TEC Médio
```

- Construção automática da matriz de entrada para PCA

---

## 📈 Análise por PCA

- Cálculo automático da PCA
- Geração dos Componentes Principais (PCs)
- Cálculo das EOFs
- Variância explicada
- Seleção automática dos modos principais

---

## 🗺️ Visualização dos Resultados

- Séries temporais
- Gráficos dos PCs
- Mapas interpolados
- Distribuição espacial das EOFs
- Comparação entre dias calmos e dias perturbados

---

## 💾 Exportação

- Salvamento automático das matrizes
- Exportação das figuras
- Exportação dos resultados da PCA
- Organização dos arquivos em diretórios específicos

---

# 🏗️ Fluxo do Sistema

```text
          Arquivos GNSS
         (.CMN / TEC)
               │
               ▼
      Seleção dos Arquivos
               │
               ▼
       Tratamento dos Dados
               │
               ▼
      Processamento do STEC
               │
               ▼
      Normalização do VTEC
               │
               ▼
     Construção da Matriz
      (Estações × Tempo)
               │
               ▼
             PCA
               │
        ┌──────┴──────┐
        ▼             ▼
      EOFs           PCs
        │             │
        └──────┬──────┘
               ▼
     Interpolação Espacial
               │
               ▼
       Geração dos Mapas
               │
               ▼
      Exportação dos Resultados
```

---

# 🔧 Tecnologias Utilizadas

## Linguagem

- MATLAB

## Interface Gráfica

- MATLAB App Designer

## Processamento dos Dados

- Leitura de arquivos GNSS
- Ajuste exponencial
- Média móvel
- Normalização do TEC

## Estatística

- Análise de Componentes Principais (PCA)
- Matriz de Covariância
- Autovalores
- Autovetores
- EOFs

## Visualização

- MATLAB Mapping Toolbox
- Griddata
- Contourf
- Plotagem de séries temporais

---

# 📂 Estrutura do Projeto

```text
Interface_PCA_GNSS
│
├── app
│   ├── Interface.mlapp
│
├── processamento
│   ├── leitura_cmn.m
│   ├── normalizacao_tec.m
│   ├── processamento_stec.m
│   ├── pca_analysis.m
│   ├── interpolacao.m
│   └── funcoes_auxiliares.m
│
├── dados
│   ├── CMN
│   ├── TEC
│   └── Resultados
│
├── figuras
│
└── README.md
```

---

# 📊 Etapas Automatizadas

A interface realiza automaticamente as seguintes etapas:

- Importação dos arquivos
- Leitura dos dados
- Tratamento de valores inválidos
- Processamento do STEC
- Normalização do TEC
- Construção da matriz para PCA
- Cálculo da PCA
- Geração dos PCs
- Geração das EOFs
- Interpolação espacial
- Plotagem dos gráficos
- Exportação dos resultados

---

# 📸 Resultados Gerados

A aplicação gera automaticamente:

- Matrizes normalizadas
- Componentes Principais (PCs)
- EOFs
- Variância explicada
- Séries temporais
- Mapas interpolados
- Figuras em alta resolução
- Arquivos prontos para análise científica

---

# 🎯 Objetivos

- Automatizar o processamento de dados GNSS.
- Reduzir o tempo necessário para preparação dos dados.
- Padronizar todas as etapas do processamento.
- Minimizar erros manuais durante as análises.
- Facilitar estudos de perturbações ionosféricas utilizando PCA.

---

# 👩‍💻 Autora

**Laura Trigo**

Projeto de Iniciação Científica desenvolvido durante a graduação em **Engenharia da Computação**, com foco na automação do processamento de dados GNSS para estudos ionosféricos.

---

# 📜 Licença

Este projeto possui fins **acadêmicos e científicos**.
