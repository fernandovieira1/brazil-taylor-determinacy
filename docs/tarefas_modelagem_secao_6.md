# Seção 6 (código) / Codificar e Rodar modelos (Python)

> **Objetivo deste checklist**: executar (e não esquecer) cada etapa do pipeline empírico, em ordem compatível com a Seção 5, com **subpassos operacionais de código**.

---

## 0) Setup do projeto e convenções *(Seção 5 — abertura; Subsec. 5.3)*

- [X] Definir nomes:
  - [X] `selic` → `i_t`
  - [X] `ipca12` → `pi_t`
  - [X] `pib` / `ln_pib`
  - [X] `gap_*` (HP, Hamilton, TL, TQ, IFI, BCB)
  - [X] `focus_ipca` → proxy de `E_t pi_{t+1}`

---

## 1) Importação e padronização dos dados *(Subsec. 5.1 Bases de Dados)*

### 1.1 Importar séries brutas

- [X] Selic (SGS/BCB):
  - [X] baixar série (meta COPOM)
  - [X] padronizar nome: `selic`
- [X] Inflação (SGS/BCB ou IBGE):
  - [X] baixar IPCA mensal e/ou IPCA 12m
  - [X] padronizar nome: `ipca` e/ou `ipca12`
- [X] Expectativas (Focus):
  - [X] baixar série de expectativa IPCA (mediana)
  - [X] filtrar indicador `"IPCA"`
  - [X] padronizar nome: `focus_ipca`
- [X] PIB trimestral (SIDRA 1621):
  - [X] coletar índice encadeado (média 1999 = 100)
  - [X] padronizar nome: `pib`

### 1.2 Limpeza de tipos e datas

- [X] Converter datas para `datetime`:
  - [X] `df["data"] = pd.to_datetime(df["data"])` ou `to_period("Q")`
- [X] Converter valores para `float`:
  - [X] `df["valor"] = df["valor"].astype(float)`
- [X] Ordenar e filtrar amostra:
  - [X] `df = df.sort_values("data")`
  - [X] `df = df[(df.data >= start) & (df.data <= end)]`

### 1.3 Construir dataframe master (grade trimestral)

- [X] Criar grade trimestral:

  - [X] `grid = pd.period_range(start=start, end=end, freq="Q").to_timestamp()`
- [X] Inicializar `df_master = pd.DataFrame({"data": grid})`
- [X] Fazer merges (left join) das séries:

  - [X] Selic
  - [X] IPCA / IPCA12
  - [X] Focus
  - [X] PIB
- [X] Checar NA e interseção temporal:

  - [ ] `df_master.isna().sum()`
  - [ ] cortar amostra comum (se necessário)
- [X] Salvar base processada:

  - [X] `/dados/processed/master_trimestral.parquet`

---

## 2) Construção das variáveis *(Subsec. 5.2 Variáveis; Subsec. 5.3 Tratamento)*

### 2.1 Inflação e expectativas

- [X] Definir inflação usada nas regressões:
  - [X] `pi_t = ipca12` (preferência do texto)
- [X] Definir expectativa (proxy):
  - [X] `Epi_t1 = focus_ipca` (com regra temporal clara)
- [X] **Checagem temporal crítica**:
  - [X] garantir que expectativa usada em `t` estava disponível **antes** da decisão em `t`
  - [X] se Focus diário/mensal: definir agregação trimestral (ver item 3.1)

### 2.2 PIB e log

- [ ] Criar `ln_pib`:
  - [ ] `df_master["ln_pib"] = np.log(df_master["pib"])`
- [ ] Criar `tempo`:
  - [ ] `df_master["tempo"] = np.arange(1, len(df_master)+1)`

---

## 3) Tratamento das séries *(Subsec. 5.3 Tratamento das Séries)*

### 3.1 Converter séries não trimestrais para trimestre (se aplicável)

- [ ] Se IPCA mensal:
  - [ ] escolher regra: média trimestral **ou** último mês do trimestre
  - [ ] implementar: `resample("Q").mean()` ou `resample("Q").last()`
- [ ] Se Focus diário/mensal:
  - [ ] escolher regra: média trimestral **ou** último dado do trimestre
  - [ ] implementar agregação
- [ ] Registrar (no log) qual regra foi usada:
  - [ ] salvar `/outputs/logs/agregacao_trimestral.txt`

### 3.2 Ajuste sazonal (atividade)

- [ ] Confirmar se PIB/SIDRA já está s.a.
  - [ ] se não: aplicar X-13-ARIMA-SEATS (ou manter conforme texto/apêndice)
- [ ] Salvar série s.a. (se aplicável)

### 3.3 Testes de estacionariedade (ADF/KPSS)

- [ ] Rodar ADF em:
  - [ ] `selic`, `pi_t`, `gap_*`
- [ ] Rodar KPSS em:
  - [ ] `selic`, `pi_t`, `gap_*`
- [ ] Salvar resultados:
  - [ ] `/outputs/tabelas/testes_raiz_unitaria.csv`

---

## 4) Construção do hiato do produto *(Subsec. 5.3 — filtragem + robustez do hiato)*

> **Output obrigatório**: `df_hiatos` (wide) + `df_hiatos_long` (long) + gráfico comparativo.

### 4.1 Tendência linear (TL)

- [ ] Estimar OLS:
  - [ ] `reg_tl = smf.ols("ln_pib ~ tempo", data=df_master).fit()`
- [ ] Extrair potencial e hiato:
  - [ ] `pot_tl = np.exp(reg_tl.predict())`
  - [ ] `gap_tl = (df_master["pib"]/pot_tl - 1)*100`

### 4.2 Tendência quadrática (TQ)

- [ ] Estimar OLS:
  - [ ] `reg_tq = smf.ols("ln_pib ~ tempo + I(tempo**2)", data=df_master).fit()`
- [ ] Extrair potencial e hiato:
  - [ ] `pot_tq = np.exp(reg_tq.predict())`
  - [ ] `gap_tq = (df_master["pib"]/pot_tq - 1)*100`

### 4.3 Filtro HP (λ=1600)

- [ ] Aplicar HP em `ln_pib`:
  - [ ] `cycle, trend = sm.tsa.filters.hpfilter(df_master["ln_pib"], lamb=1600)`
- [ ] Potencial e hiato:
  - [ ] `pot_hp = np.exp(trend)`
  - [ ] `gap_hp = (df_master["pib"]/pot_hp - 1)*100`

### 4.4 Filtro de Hamilton (lags 8–11)

- [ ] Estimar OLS:
  - [ ] `reg_h = smf.ols("ln_pib ~ ln_pib.shift(8)+ln_pib.shift(9)+ln_pib.shift(10)+ln_pib.shift(11)", data=df_master).fit()`
- [ ] Extrair potencial e alinhar série:
  - [ ] `pot_h = np.exp(reg_h.predict())`
  - [ ] alinhar (NaNs iniciais coerentes)
- [ ] Hiato:
  - [ ] `gap_h = (df_master["pib"]/pot_h - 1)*100`

### 4.5 Hiatos institucionais (IFI e BCB)

- [ ] IFI:
  - [ ] baixar Excel
  - [ ] padronizar trimestre (`to_period("Q")`)
  - [ ] converter para `%` se necessário
- [ ] BCB:
  - [ ] baixar Excel do RPM (atenção: URL muda por edição)
  - [ ] padronizar trimestre
- [ ] Merge com base trimestral

### 4.6 Consolidar `df_hiatos`

- [ ] Criar `df_hiatos` com colunas:
  - [ ] `data`, `gap_tl`, `gap_tq`, `gap_hp`, `gap_h`, `gap_ifi`, `gap_bcb`
- [ ] Criar `df_hiatos_long = melt(...)`
- [ ] Salvar:
  - [ ] `/dados/processed/hiatos.parquet`
  - [ ] `/dados/processed/hiatos_long.parquet`

### 4.7 Gráfico comparativo do hiato

- [ ] Plotar todas as medidas + linha zero
- [ ] Exportar:
  - [ ] `/outputs/graficos/hiato_produto.png`

---

## 5) Dataset final para estimação *(Subsec. 5.3 → 5.4)*

- [ ] Montar `df_est` = `df_master` + `df_hiatos`
- [ ] Criar colunas defasadas:
  - [ ] `i_l1 = selic.shift(1)`
  - [ ] `i_l2 = selic.shift(2)`
  - [ ] `pi_l1 = pi_t.shift(1)` etc.
  - [ ] `gap_l1 = gap.shift(1)` etc.
- [ ] Criar colunas lead (para forward-looking, se necessário):
  - [ ] `gap_lead1 = gap.shift(-1)` (se você usar \(E_t \tilde y_{t+1}\) via proxy)
- [ ] Remover linhas com NA induzidas por shift/lead:
  - [ ] `df_est = df_est.dropna(subset=[...])`
- [ ] Salvar:
  - [ ] `/dados/processed/df_est.parquet`

---

## 6) Especificação econométrica: regras estimadas *(Subsec. 5.4)*

> Execute **um loop por medida de hiato** (HP, Hamilton, TL, TQ, IFI, BCB) para robustez.

### 6.1 Loop de robustez por hiato

- [ ] `for gap_col in ["gap_hp","gap_h","gap_tl","gap_tq","gap_ifi","gap_bcb"]:`
  - [ ] definir `gap = df_est[gap_col]`
  - [ ] rodar 6.2, 6.3, 6.4
  - [ ] salvar outputs com sufixo do hiato (ex.: `_hp`, `_h`, etc.)

### 6.2 Regra backward-looking (MQO) *(Subsubsec. 5.4.1)*

- [ ] Especificar regressão:
  - [ ] `i_t ~ const + i_{t-1} + pi_t + gap_t`
- [ ] Estimar OLS:
  - [ ] `ols = sm.OLS(y, X).fit(cov_type="HAC", cov_kwds={"maxlags":?})`
- [ ] Guardar:
  - [ ] coeficientes `beta0..beta3`
  - [ ] matriz de covariância robusta
  - [ ] resíduos e métricas de ajuste
- [ ] Exportar tabela:
  - [ ] `/outputs/tabelas/ols_backward_<gap>.csv`

### 6.3 Regra forward-looking (GMM) *(Subsubsec. 5.4.2 + 5.5.2)*

- [ ] Definir variável expectativa:
  - [ ] `Epi = focus_ipca` (no trimestre)
- [ ] Definir proxy do hiato esperado:
  - [ ] `Egap = gap.shift(-1)` **ou** outra proxy definida no texto
- [ ] Definir matriz de instrumentos `Z_t`:
  - [ ] `1, i_{t-1}, i_{t-2}, pi_{t-1}, pi_{t-2}, gap_{t-1}, gap_{t-2}, ICBr_{t-1}, ...`
- [ ] Implementar GMM:
  - [ ] definir função de momentos `g(theta) = Z * residual(theta)`
  - [ ] estimar (1-step/2-step) conforme seu pacote/rotina
- [ ] Rodar teste J de Hansen
- [ ] Exportar:
  - [ ] `/outputs/tabelas/gmm_forward_<gap>.csv`
  - [ ] `/outputs/tabelas/jtest_forward_<gap>.csv`

### 6.4 Regra híbrida (GMM) *(Subsubsec. 5.4.3 + 5.5.2)*

- [ ] Especificar:
  - [ ] `i_t ~ const + i_{t-1} + pi_t + Epi_{t+1} + gap_t`
- [ ] Instrumentos: mesmo esqueleto do forward (ajustar conforme necessidade)
- [ ] Estimar GMM + teste J
- [ ] Exportar:
  - [ ] `/outputs/tabelas/gmm_hibrida_<gap>.csv`
  - [ ] `/outputs/tabelas/jtest_hibrida_<gap>.csv`

---

## 7) Estratégia de estimação (diagnósticos) *(Subsec. 5.5.1–5.5.2)*

### 7.1 OLS: checagens mínimas

- [ ] Verificar autocorrelação dos resíduos (opcional)
- [ ] Confirmar HAC/Newey-West aplicado

### 7.2 GMM: checagens mínimas

- [ ] Confirmar rank/variação dos instrumentos
- [ ] Verificar J-test (p-valor razoável)
- [ ] Logar outputs:
  - [ ] `/outputs/logs/gmm_diag_<gap>.txt`

---

## 8) Cálculo de parâmetros de longo prazo + Método Delta *(Subsubsec. 5.5.3)*

> **Input**: coeficientes estimados + matriz de covariância dos coeficientes “curtos”.

### 8.1 Mapear curto → longo prazo

- [ ] Para cada especificação, calcular:
  - [ ] `rho = coef(i_{t-1})`
  - [ ] `phi_pi = coef(pi)/ (1-rho)` (ou soma no híbrido)
  - [ ] `phi_y = coef(gap)/ (1-rho)`
- [ ] Guardar em tabela “estrutural”:
  - [ ] `/outputs/tabelas/phi_longrun_<modelo>_<gap>.csv`

### 8.2 Método Delta (erros-padrão de φ)

- [ ] Definir transformação `h(b)`:
  - [ ] exemplo: `phi_pi(b) = b2/(1-b1)`
- [ ] Calcular jacobiana `J = ∂h/∂b`
- [ ] Obter `Var(phi) = J Var(b) J'`
- [ ] Extrair `se(phi_pi)`, `se(phi_y)`
- [ ] Exportar:
  - [ ] `/outputs/tabelas/delta_<modelo>_<gap>.csv`

---

## 9) Testes: Taylor e Bullard–Mitra *(Subsubsec. 5.5.3)*

### 9.1 Wald unilateral para Taylor

- [ ] Formular hipótese:
  - [ ] `H0: phi_pi <= 1`, `H1: phi_pi > 1`
- [ ] Calcular estatística de Wald usando `phi_pi` e `se(phi_pi)`
- [ ] Registrar p-valor unilateral
- [ ] Exportar:
  - [ ] `/outputs/tabelas/wald_taylor_<modelo>_<gap>.csv`

### 9.2 Condição de Bullard–Mitra

- [ ] Fixar parâmetros calibrados:
  - [ ] `beta = 0.985` (ou o que estiver no texto)
  - [ ] `kappa = 0.05` (ou o que estiver no texto)
- [ ] Calcular:
  - [ ] `bm = kappa*(phi_pi - 1) + (1-beta)*phi_y`
- [ ] Classificar:
  - [ ] `determinante = (bm > 0)`
- [ ] Exportar:
  - [ ] `/outputs/tabelas/bullard_mitra_<modelo>_<gap>.csv`

---

## 10) Quebras estruturais e regimes *(Subsubsec. 5.5.4)*

### 10.1 Bai–Perron (quebras endógenas)

- [ ] Definir série/modelo alvo para quebra:
  - [ ] coeficientes ao longo do tempo **ou** regressão em janelas/rolling
- [ ] Rodar Bai–Perron (pacote apropriado)
- [ ] Extrair datas de quebra e ICs
- [ ] Exportar:
  - [ ] `/outputs/tabelas/quebras_bai_perron.csv`
  - [ ] `/outputs/graficos/quebras_visual.png`

### 10.2 Reestimar por subperíodos

- [ ] Definir subamostras:
  - [ ] por presidências do BCB **e/ou** por quebras endógenas
- [ ] Para cada subamostra:
  - [ ] repetir etapas 6 → 9 (estimação → delta → Wald → BM)
- [ ] Consolidar tabela final:
  - [ ] `/outputs/tabelas/resumo_regimes.csv`

---

## 11) Consolidação final para a Seção 6 (Resultados)

- [ ] Montar tabela “principal” (por modelo e hiato):
  - [ ] coeficientes curtos
  - [ ] φ de longo prazo + SE (Delta)
  - [ ] Wald (Taylor) + p-valor
  - [ ] Bullard–Mitra (valor e classificação)
  - [ ] J-test (GMM)
- [ ] Exportar:
  - [ ] `/outputs/tabelas/tabela_principal_resultados.xlsx` (ou `.csv`)
- [ ] Gerar gráficos essenciais:
  - [ ] série de juros, inflação, expectativas, produto (Seção 4 já cobre)
  - [ ] hiatos comparativos (já feito)
  - [ ] visual de determinância por regime (heatmap/quadros)
- [ ] Garantir reprodutibilidade:
  - [ ] salvar `requirements.txt`/`pip freeze`
  - [ ] salvar seed (se aplicável)
  - [ ] salvar logs de execução

---

## 12) (Se entrar) Simulações NK calibradas *(Objetivo específico (iv) citado na abertura da Seção 5)*

- [ ] Calibrar parâmetros NK conforme seção teórica:
  - [ ] `beta`, `kappa`, `sigma`, etc.
- [ ] Inserir regra estimada (ρ, φπ, φy)
- [ ] Simular dinâmica (IRFs) e checar estabilidade
- [ ] Exportar:
  - [ ] `/outputs/graficos/irf_*.png`
  - [ ] `/outputs/tabelas/irf_sumario.csv`

---

# Checklist rápido de integridade (antes de escrever a Seção 6)

- [ ] As datas estão consistentes (trimestre) em **todas** as variáveis?
- [ ] A expectativa do Focus está alinhada com o timing institucional (antes do Copom)?
- [ ] O hiato foi testado em **múltiplas** medidas e os resultados são robustos?
- [ ] O GMM passou no J-test (ou você interpretou corretamente quando não passou)?
- [ ] Você reportou φπ e φy **de longo prazo** (e não só coeficientes curtos)?
- [ ] O teste de Wald e Bullard–Mitra estão separados conceitualmente (nota/explicação)?
- [ ] Quebras estruturais/regimes foram testados (ou justificados se não)?
