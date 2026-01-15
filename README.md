# brazil-taylor-determinacy

Análise empírica e teórica sobre se a política monetária brasileira tem satisfeito o **Princípio de Taylor** e garantido **determinacy do equilíbrio** sob o regime de metas para a inflação (1999–2024).

Este repositório contém os materiais de replicação do artigo:

**“Determinância e Política Monetária no Brasil: Uma Avaliação Empírica do Princípio de Taylor (1999--2024)”**

Fernando Souza de Vieira — *FEA-RP/USP*

Rafaela Dezidério Rocha — *FEA-RP/USP*

---

## Visão Geral

O projeto avalia se a resposta do Banco Central do Brasil à inflação tem sido suficientemente forte para assegurar um equilíbrio único e estável no **modelo Novo Keynesiano**, à luz das condições de determinacy discutidas em:

- Blanchard & Kahn (1980)
- Taylor (1993, 1999)
- Clarida, Galí & Gertler (2000)
- Bullard & Mitra (2002)

A análise combina:

- Estimação empírica de regras de Taylor (MQO, GMM)
- Avaliação analítica das condições de determinacy
- Simulações em Dynare

---

## Estrutura do Repositório

Os arquivos principais estão organizados nas seguintes pastas/diretórios:

```
dados/ # Bases de dados utilizadas
docs/ # Arquivos auxiliares
paper/ # Código Latex, gráficos e tabelas utilizadas
scripts/ # algoritmos utilizados para obter e tratar as bases de dados, modelos econométricos e simulações Dynare
```

---

## Fontes de Dados

Todos os dados utilizados são de acesso público:

- Banco Central do Brasil (SGS): Selic, expectativas de inflação, hiato do produto
- IBGE (SIDRA): IPCA, PIB trimestral
- FGV/IBRE: medidas alternativas de hiato
- Pesquisa Focus: inflação esperada

| Série                     | Código / Fonte | Uso no Artigo     |
| -------------------------- | --------------- | ----------------- |
| Selic – Meta              | SGS 4390        | Regra de Taylor   |
| Selic – Efetiva           | SGS 4189        | Robustez          |
| IPCA                       | IBGE / SIDRA    | Inflação        |
| Expectativas de IPCA (12m) | Focus / BCB     | Regra prospectiva |
| PIB Real                   | IBGE 1620       | Hiato do produto  |
| Hiato do Produto (BCB)     | SGS 3904        | Robustez          |
| IBC-Br                     | SGS 24363       | Proxy mensal      |
| Meta de Inflação         | BCB             | Desvio da meta    |

---

## Metodologia

### 1. Estimação da Regra de Taylor

- Backward-looking (MQO)
- Forward-looking (GMM)
- Híbrida (GMM)

### 2. Testes de Determinacy

Com base nos parâmetros estimados:

\[
\kappa(\hat\phi_\pi - 1) + (1-\beta)\hat\phi_y > 0
\]

seguindo Bullard & Mitra (2002).

### 3. Dynare

Simulações do modelo NK sob diferentes regras de política monetária.

---

## Execução do Código

### Python

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Scripts principais encontram-se em python/.R

Scripts econométricos estão em `R/`.

### Dynare

Modelos em `dynare/` # construídos e executados em Octave, mas compatíveis (*.mod) com MATLAB).

---

### Artigo (LaTeX)

O artigo completo está em:
`paper/main.tex`

O histórico de construção do artigo pode ser consultado via commits.

---

### Licença

Este projeto é distribuído sob a Licença MIT.
Uso livre com atribuição adequada.
