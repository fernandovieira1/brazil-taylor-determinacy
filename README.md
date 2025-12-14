# brazil-taylor-determinacy

Análise empírica e teórica sobre se a política monetária brasileira tem satisfeito o **Princípio de Taylor** e garantido **determinacy do equilíbrio** sob o regime de metas para a inflação (1999–2024).

Este repositório contém os materiais de replicação do artigo:

**“Determinacy and Monetary Policy in Brazil: An Empirical Assessment of the Taylor Principle (1999–2024)”**  

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
- Testes de quebras estruturais
- Simulações em Dynare (opcional)
- Código-fonte LaTeX completo do artigo

---

## Estrutura do Repositório

```
bases/ # Bases de dados brutas e processadas
docs/ # Notas, ideias e documentação auxiliar
dynare/ # Modelos NK em Dynare (.mod)
paper/ # Artigo em LaTeX (texto, tabelas, figuras)
python/ # Scripts Python (estimação, testes, utilidades)
R/ # Scripts R (estimação, testes econométricos)
testes/ # Scripts e arquivos de teste (sanity checks)
notebooks/ # Exploração inicial (Jupyter)
```


**Observação:**  
A pasta `testes/` contém apenas código de verificação e experimentação.  
Os resultados reportados no artigo utilizam apenas os scripts finais em `python/`, `R/` e `dynare/`.

---

## Fontes de Dados

Todos os dados utilizados são de acesso público:

- Banco Central do Brasil (SGS): Selic, expectativas de inflação, hiato do produto
- IBGE (SIDRA): IPCA, PIB trimestral
- FGV/IBRE: medidas alternativas de hiato
- Pesquisa Focus: inflação esperada

| Série                      | Código / Fonte | Uso no Artigo     |
| -------------------------- | -------------- | ----------------- |
| Selic – Meta               | SGS 4390       | Regra de Taylor   |
| Selic – Efetiva            | SGS 4189       | Robustez          |
| IPCA                       | IBGE / SIDRA   | Inflação          |
| Expectativas de IPCA (12m) | Focus / BCB    | Regra prospectiva |
| PIB Real                   | IBGE 1620      | Hiato do produto  |
| Hiato do Produto (BCB)     | SGS 3904       | Robustez          |
| IBC-Br                     | SGS 24363      | Proxy mensal      |
| Meta de Inflação           | BCB            | Desvio da meta    |

Scripts de download e tratamento encontram-se em `python/`, `R/` e `notebooks/`.

---

## Metodologia

### 1. Estimação da Regra de Taylor
- Backward-looking
- Forward-looking (CGG)
- Híbrida com suavização da taxa de juros

Técnicas:
- MQO com erros Newey–West
- GMM com instrumentos internos
- Estimação por subsamostras

### 2. Testes de Determinacy

Com base nos parâmetros estimados:

\[
\kappa(\hat\phi_\pi - 1) + (1-\beta)\hat\phi_y > 0
\]

seguindo Bullard & Mitra (2002).

### 3. Quebras Estruturais
- Testes de Bai–Perron
- Datas institucionais relevantes

### 4. Dynare (Opcional)
Simulações do modelo NK sob diferentes regras de política monetária.

---

## Execução do Código

### Python

```bash
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Scripts principais encontram-se em python/.

### R

Scripts econométricos estão em `R/`.

### Dynare

Modelos em `dynare/` (Octave ou MATLAB).

---

### Artigo (LaTeX)

O artigo completo está em:
`paper/main.tex`

---

### Licença

Este projeto é distribuído sob a Licença MIT.
Uso livre com atribuição adequada.