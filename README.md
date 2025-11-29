# brazil-taylor-determinacy

Empirical and theoretical analysis of whether Brazilian monetary policy has satisfied the **Taylor Principle** and delivered **equilibrium determinacy** under the inflation-targeting regime (1999–2024).  
This repository contains all replication materials for the article:

**“Determinacy and Monetary Policy in Brazil: An Empirical Assessment of the Taylor Principle (1999–2024)”**  
by *Fernando Souza de Vieira – FEA-RP/USP*.

---

## Overview

The project evaluates if the Brazilian Central Bank’s response to inflation has been strong enough to ensure a unique and stable equilibrium in the **New Keynesian model**, in line with the conditions of:

- Blanchard & Kahn (1980)
- Taylor (1993, 1999)
- Clarida, Galí & Gertler (2000)
- Bullard & Mitra (2002)

The analysis combines:

- Estimation of Taylor rules (OLS, GMM)
- Determinacy tests using NK theory
- Structural break analysis
- Optional Dynare simulations
- Complete LaTeX source of the article

---

## Repository Structure

Inserir depois


---

## Data Sources

All data used in the project are publicly available:

- Banco Central do Brasil (SGS): Selic, inflation expectations, output gap series
- IBGE: IPCA, quarterly GDP
- FGV/IBRE: alternative measures of the output gap
- Focus Survey: expected inflation (12 months ahead)

The `data/` folder includes raw files and preprocessed versions, as well as scripts that download SGS data automatically.

---

## Methodology

### 1. Taylor Rule Estimation
- Backward-looking
- Forward-looking (CGG)
- Hybrid with interest rate smoothing

Techniques used:
- OLS with Newey–West standard errors
- GMM with internal instruments
- Subsample estimation by BCB presidency

### 2. Determinacy Tests

Using the estimated parameters $(\hat\phi_\pi, \hat\phi_y)$:

\[
\kappa(\hat\phi_\pi - 1) + (1-\beta)\hat\phi_y > 0
\]

as in Bullard–Mitra (2002).

### 3. Structural Breaks
- Bai–Perron multiple breakpoint tests
- Institutional break dates: 2003, 2011, 2016, 2019

### 4. Dynare (Optional)
Simulation of the basic NK model under alternative Taylor rule coefficients.

---

## How to Run the Code

### R or Python environment

Dependencies are listed in:

Inserir depois


### To replicate all results:

git clone https://github.com/fernandosvieira/brazil-taylor-determinacy

cd brazil-taylor-determinacy


Then run:

- `src/main.R` (if using R)
- `src/main.py` (if using Python)
- `dynare/nk_model.mod` (in Octave/MATLAB)

---

## Article Source (LaTeX)

The full article is located in:

paper/main.tex


including all figures, tables, bibliography and appendices (derivations, matrix forms, robustness checks).

---

## Citation

If you use this repository, please cite as:

Vieira, Fernando S. (2025).
brazil-taylor-determinacy: Replication materials for
“Determinacy and Monetary Policy in Brazil”.
GitHub repository.


---

## License

This project is released under the MIT License.  
You are free to use, modify, distribute, and build upon the material, provided that proper credit is given.
