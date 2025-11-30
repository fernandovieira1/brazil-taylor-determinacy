# brazil-taylor-determinacy

Análise empírica e teórica sobre se a política monetária brasileira tem satisfeito o **Princípio de Taylor** e garantido **determinacy do equilíbrio** sob o regime de metas para a inflação (1999–2024).  
Este repositório contém todos os materiais de replicação para o artigo:

**“Determinacy and Monetary Policy in Brazil: An Empirical Assessment of the Taylor Principle (1999–2024)”**  
por *Fernando Souza de Vieira – FEA-RP/USP*.

---

## Visão Geral

O projeto avalia se a resposta do Banco Central do Brasil à inflação tem sido forte o suficiente para assegurar um equilíbrio único e estável no **modelo Novo Keynesiano**, em linha com as condições de:

- Blanchard & Kahn (1980)
- Taylor (1993, 1999)
- Clarida, Galí & Gertler (2000)
- Bullard & Mitra (2002)

A análise combina:

- Estimação de regras de Taylor (MQO, GMM)
- Testes de determinacy usando teoria NK
- Análise de quebras estruturais
- Simulações em Dynare (opcional)
- Código-fonte LaTeX completo do artigo

---

## Estrutura do Repositório
```
data/                # Dados brutos e processados
notebooks/           # Exploração e estimativas interativas (Jupyter)
src/                 # Código-fonte
  brazil_taylor/     # Pacote Python principal
    __init__.py
    model.py         # Stub inicial para regra de Taylor / determinacy
requirements.txt     # Dependências Python
LICENSE
README.md
```

---

## Fontes de Dados

Todos os dados utilizados no projeto são de acesso público:

- Banco Central do Brasil (SGS): Selic, expectativas de inflação, séries de hiato do produto
- IBGE: IPCA, PIB trimestral
- FGV/IBRE: medidas alternativas de hiato do produto
- Focus (Pesquisa Focus): inflação esperada (12 meses à frente)

| Série                           | Código SGS / Tabela | Fonte        | Uso no Artigo                            | Periodicidade Padrão                     |
| ------------------------------- | ------------------- | ------------ | ---------------------------------------- | ---------------------------------------- |
| Selic – Meta                    | 4390                | BCB / SGS    | Juros na regra de Taylor (i_t)           | Mensal                                   |
| Selic – Efetiva                 | 4189                | BCB / SGS    | Alternativa para i_t                     | Mensal                                   |
| IPCA – Variação Mensal          | IBGE 1737 433 (bcb)          | IBGE / SIDRA | Inflação (π_t)                           | Mensal                                   |
| Expectativas de IPCA – 12 meses | — (API Focus)       | BCB / Focus  | Inflação esperada (E_t π_{t+1})          | Diária (agregado para mensal/trimestral) |
| PIB Real – Contas Trimestrais   | IBGE 1620           | IBGE / SIDRA | Hiato do produto (base para y_t)         | Trimestral                               |
| Hiato do Produto (modelo BCB)   | 3904                | BCB / SGS    | Hiato do produto (ŷ_t)                   | Trimestral                               |
| Taxa de Juros Natural           | 13758               | BCB / SGS    | r_t^n na IS dinâmica (opcional)          | Trimestral                               |
| IBC-Br (atividade econômica)    | 24363               | BCB / SGS    | Proxy mensal do PIB (robustez)           | Mensal                                   |
| Meta de Inflação                | —                   | BCB          | Construção da variável "inflação x meta" | Anual                                    |
| Banda de Tolerância da Meta     | —                   | BCB          | Robustez / controles                     | Anual                                    |


A pasta `data/` inclui arquivos brutos e versões processadas, além de scripts que baixam dados SGS automaticamente.

---

## Metodologia

### 1. Estimação da Regra de Taylor
- Retrospectiva (backward-looking)
- Prospectiva (forward-looking, CGG)
- Híbrida com suavização da taxa de juros

Técnicas utilizadas:
- MQO com erros-padrão Newey–West
- GMM com instrumentos internos
- Estimação por subsamplos (presidências do BCB)

### 2. Testes de Determinacy

Usando os parâmetros estimados $(\hat\phi_\pi, \hat\phi_y)$:

\[
\kappa(\hat\phi_\pi - 1) + (1-\beta)\hat\phi_y > 0
\]

como em Bullard–Mitra (2002).

### 3. Quebras Estruturais
- Testes de múltiplos pontos de quebra (Bai–Perron)
- Datas institucionais: 2003, 2011, 2016, 2019

### 4. Dynare (Opcional)
Simulação do modelo NK básico sob coeficientes alternativos da regra de Taylor.

---

## Como Executar o Código

### Ambiente R ou Python

As dependências estão listadas em:
`requirements.txt`

### Criando ambiente Python (venv)

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
pip install -r requirements.txt
python -m ipykernel install --user --name brazil-taylor --display-name "Python (brazil-taylor)"
```

### Teste rápido

```bash
python -c "from src.brazil_taylor.model import TaylorRuleModel; import pandas as pd; m=TaylorRuleModel(pd.DataFrame()); print(m.determinacy_condition())"
```

Resultado esperado: `(True, valor)` indicando condição fictícia de determinacy.

### Para replicar todos os resultados:

```bash
git clone https://github.com/fernandosvieira/brazil-taylor-determinacy
cd brazil-taylor-determinacy
```

Em seguida execute:

- `src/main.R` (R)
- `src/main.py` (Python)
- `dynare/nk_model.mod` (Octave/MATLAB)

---

## Fonte do Artigo (LaTeX)

O artigo completo está localizado em:

`paper/main.tex`

incluindo todas as figuras, tabelas, bibliografia e apêndices (derivações, formas matriciais, testes de robustez).

---

## Citação

Se você utilizar este repositório, cite como:

Vieira, Fernando S. (2025).
brazil-taylor-determinacy: Materiais de replicação para
“Determinacy and Monetary Policy in Brazil”.
Repositório GitHub.

```
@misc{vieira2025brazil,
  author = {Fernando Souza de Vieira},
  title = {Determinacy and Monetary Policy in Brazil: Replication Materials},
  year = {2025},
  howpublished = {GitHub repository},
  url = {https://github.com/fernandosvieira/brazil-taylor-determinacy}
}
```

---

## Licença

Este projeto é distribuído sob a Licença MIT.  
Você é livre para usar, modificar, distribuir e desenvolver sobre o material, desde que seja dado o devido crédito.
