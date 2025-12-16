# %% [markdown]
# # Qual o hiato do produto no Brasil?
# 
# Uma medida extremamente importante para a avaliação econônomica de um país é o Hiato do Produto. Neste post, realizamos uma comparação das diferentes formas de estimação dessa variável não observável utilizando o Python como ferramenta de análise de dados.
# 
# # Introdução
# 
# A macroeconomia nasce da soma de milhões de decisões diárias de indivíduos descentralizados. Tais indivíduos, com necessidades ilimitadas, decidem todos os dias o que produzir, como produzir e como distribuir esse esforço produtivo.
# 
# A variável macroeconômica que representa esse esforço de forma mais completa é o que chamamos de produto interno bruto, ou simplesmente PIB, a soma de todos os bens e serviços finais produzidos por um país ao longo de um determinado período de tempo.
# 
# O PIB é, nesse contexto, uma medida, expressa em valores correntes ou números índices, do quanto um país utilizando recursos escassos, como trabalho e capital, gerou de produção e, consequentemente, de renda em um determinado período.
# 
# Não por outro motivo, a taxa de crescimento do PIB fornece uma boa medida sobre o quão rápido ou devagar um determinado país está se tornando mais desenvolvido.
# 
# De forma a definir o PIB em termos um pouco mais precisos, Considere que o PIB efetivamente observado (de agora em diante chamado de PIB efetivo) possa ser decomposto em duas partes, a saber:\begin{align}Y_{t} = Y^P_{t} + h_{t} \end{align} Onde $Y_{t}$ é o PIB em $t$, $Y^P_{t}$ é a tendência de longo prazo do PIB, chamada de produto potencial e $h_{t}$ é um componente cíclico, chamado de hiato do produto.
# 
# PIB = PIB_LP + Hiato
# 
# **O PIB Potencial, $Y^P_{t}$, a tendência do PIB Efetivo ao longo do tempo, reflete condições estruturais da economia**, como a população em idade ativa, o estoque de capital, qualidade da educação, qualidade das instituições, etc. **O hiato do produto, $h_{t}$, o componente cíclico, por sua vez, reflete questões conjunturais**, como incentivos de política econômica, condições climáticas, choques externos, incertezas políticas, etc.
# 
# **Em outros termos, no curto prazo o PIB Efetivo pode crescer mais ou menos do que o PIB Potencial, aquela tendência. No longo prazo, entretanto, o crescimento da economia está limitado pela disponibilidade de fatores e pela forma como esses fatores são combinados.**
# 
# Isto é, supondo que a estrutura da economia possa ser representada por uma função do tipo Cobb-Douglas, com retornos constantes de escala, temos que: \begin{align} Y_{t} = A_{t} K_{t}^{\alpha_{t}} L_{t}^{1-\alpha_{t}}\end{align} Onde $K_{t}$ e $L_{t}$ são, respectivamente, a quantidade de capital e trabalho, $A_{t}$ mede a eficiência tecnológica ou a produtividade total dos fatores e $\alpha_{t}$, por fim, mede a participação do capital na renda nacional.
# 
# Nesse contexto, $Y_{t}$, a soma de bens e serviços finais produzidos em determinado período de tempo, será dado pela combinação entre uma determinada quantidade de estoque de capital com outra de trabalho, moderada pela tecnologia disponível. Em última instância, portanto, $Y_{t}$ estará limitado pela disponibilidade de fatores de produção e pela forma como esses fatores são combinados a produtividade total dos fatores. Os economistas gostam de chamar essa limitação de produto potencial, ou simplesmente $Y^P_{t}$.
# 
# No curto prazo, a diferença entre $Y_{t}$ e $Y^P_{t}$ será assim dada pelo hiato do produto, $h_{t}$, que, por construção, irá medir o grau de ociosidade da economia.
# 
# Calcular o hiato do produto, entretanto, não é uma tarefa trivial, uma vez que o PIB potencial não é uma variável observável. Precisamos estimar o produto potencial e, depois, calcular o hiato.
# 
# Sendo assim, **há três formas usuais de obter o Hiato do Produto:**
# 
# **- Extração de Tendência do PIB via MQO.**
# 
# **- Filtros Univariados e Multivariados, para extrair a tendência do PIB.**
# 
# **- Função de produção (descrita acima).**
# 
# É importante destacar que nenhum método é perfeito, mas alguns são úteis para o próposito em questão. Sugere-se aqui obter diferentes tipos de Hiato, para realizar uma comparação abrangente, e compreender a incerteza relacionada à essa variável não observável.
# 
# Realizamos a comparação dos seguintes Hiatos do Produto:
# 
# - Tendência Linear (MQO)
# - Tendência Quadrática (MQO)
# - Filtro HP
# - Filtro de Hamilton
# - Hiato estimado pela Instituição Fiscal Independente
# - Hiato estimado pelo Banco Central do Brasil
# 
# Para tanto, construímos o código em Python para criar as medidas de Hiato, exceto da IFI e BCB, que são importados de seus respectivos sites.

# %% [markdown]
# # Bibliotecas

# %%
# !pip install sidrapy --quiet

# %%
# Importa bibliotecas
import pandas as pd
import numpy as np
import statsmodels.api as sm
import statsmodels.formula.api as smf
import sidrapy as sidra
from plotnine import *

# %% [markdown]
# # Dados

# %%
# Importar dados:
# PIB - Preços de mercado - Série encadeada s.a. - Índice (média 1995 = 100)
pib_bruto = sidra.get_table(
                table_code = 1621,
                territorial_level = "1", # alguns argumentos recebem valores padrão
                ibge_territorial_code = "all",
                variable = 'all',
                period = "all",
                classifications = {"11255" : "90707"},
                header = 'n'
                )
pib = (
    pib_bruto
    [['D2C', 'V']]
    .rename(
        columns = {
            "D2C": "data",
            "V": "pib"
            }
            )
     .assign(  # substitui o 5º caracter da coluna data por "-Q" e converte em YYYY-MM-DD
        data = lambda x: pd.PeriodIndex(
            x.data.str.slice_replace(start = 4, stop = 5, repl = "-Q"),
            freq = "Q"
            ).to_timestamp(),
        pib = lambda x: x.pib.astype(float) # converte de texto para numérico
        )
)

# Cria novas colunas auxiliares para o exercício
pib["ln_pib"] = np.log(pib["pib"])  # Transformação logarítmica do PIB
pib["tempo"] = pib.index + 1        # Vetor de 1 até T indicando ordenação tempora das observações

pib.head()

# %% [markdown]
# # Tendência linear

# %%
# Regressão linear do PIB contra o tempo
reg1 = smf.ols(
    formula = "ln_pib ~ tempo",  # especificação do modelo no formato de fórmula
    data = pib  # fonte dos dados
    ).fit() # estima o modelo

# Salva a tendência estimada
potencial_tl = np.exp(reg1.predict()) # extrai os valores estimados e reverte a transformação logarítmica
potencial_tl

# %% [markdown]
# # Tendência quadrática

# %%
# Regressão linear do PIB contra o tempo + tempo^2
reg2 = smf.ols(
    formula = "ln_pib ~ tempo + np.power(tempo, 2)",  # especificação do modelo no formato de fórmula
    data = pib  # fonte dos dados
    ).fit() # estima o modelo

# Salva a tendência estimada
potencial_tq = np.exp(reg2.predict()) # extrai os valores estimados e reverte a transformação logarítmica
potencial_tq

# %% [markdown]
# # Filtro HP

# %%
# Calcula o filtro HP
filtro_hp = sm.tsa.filters.hpfilter(x = pib['ln_pib'], lamb = 1600)

# Salva a tendência calculada
potencial_hp = np.exp(filtro_hp[1]) # posição 1 é a tendência (0=ciclo); reverte a transformação logarítmica
potencial_hp.head()

# %% [markdown]
# # Filtro de Hamilton

# %%
# Regressão linear aplicando a especificação de Hamilton
reg3 = smf.ols(
    formula = "ln_pib ~ ln_pib.shift(8) + ln_pib.shift(9) + ln_pib.shift(10) + ln_pib.shift(11)",  # especificação do modelo no formato de fórmula
    data = pib  # fonte dos dados
    ).fit() # estima o modelo

# Salva a tendência estimada
potencial_h = np.exp(reg3.predict()) # extrai os valores estimados e reverte a transformação logarítmica

# Adiciona 11 NaNs no início da série para corresponder ao tamanho da série do PIB
potencial_h = np.append([np.nan]*11, potencial_h)
potencial_h

# %% [markdown]
# # Hiato IFI
# 
# 

# %%
# Coleta e tratamento do Hiato do Produto da IFI
hiato_ifi = (
    pd.read_excel(
    "https://www12.senado.leg.br/ifi/dados/arquivos/estimativas-do-hiato-do-produto-ifi.xlsx",
    sheet_name = "Hiato do Produto",
    skiprows = 1
    )
    .assign(data = lambda x: pd.to_datetime(x['Trim-Ano']).dt.to_period('Q'),
            IFI = lambda x: x.Hiato.astype(float) * 100)
    .loc[:, ['data', 'IFI']]
  )

hiato_ifi.head()

# %% [markdown]
# # Hiato BCB

# %%
# Coleta e tratamento do Hiato do Produto do BCB
hiato_bcb = (
    pd.read_excel(
    "https://www.bcb.gov.br/content/ri/relatorioinflacao/202509/rpm202509anp.xlsx",
    sheet_name = "Graf 2.2.8",
    skiprows = 8
    )
    .assign(data = lambda x: pd.to_datetime(x['Trimestre']).dt.to_period('Q'),
            BCB = lambda x: x["Cenário de referência"].astype(float))
    .loc[:, ['data', 'BCB']]
    .dropna()
  )

hiato_bcb.head()

# %% [markdown]
# # Calculando o hiato

# %%
# Cálculo do hiato do produto
dados = pib[["data", "pib"]].copy()  # seleciona colunas de interesse
dados["Tendência Linear"] = (dados["pib"] / potencial_tl - 1) * 100    # cria novas colunas com cálculo do hiato
dados["Tendência Quadrática"] = (dados["pib"] / potencial_tq - 1) * 100
dados["Filtro HP"] = (dados["pib"] / potencial_hp - 1) * 100
dados["Filtro de Hamilton"] = (dados["pib"] / potencial_h - 1) * 100
dados['data'] = dados.data.dt.to_period('Q')
dados = pd.merge(dados, hiato_ifi, on='data', how='outer')
dados = pd.merge(dados, hiato_bcb, on='data', how='outer')

# %%
dados = dados.drop(columns = ["pib"])  # remove a coluna da série do PIB
dados_long = dados.melt(    # transforma a tabela pro formato "longo" (mais linhas e menos colunas)
    id_vars = ["data"],  # coluna identificadora das observações (todas as demais serão transformadas)
    value_name = "valor", # nome da coluna que armazenará os nomes das colunas transformadas
    var_name = "variavel" # nome da coluna que armazenará os valores das colunas transformadas
    )
dados_long['data'] = dados_long.data.dt.to_timestamp()
dados_long

# %%
# Cores para gráficos
colors = {'blue': '#282f6b',
          'yellow': '#eace3f',
          'red'   : "#b22200",
          'green': '#224f20',
          'gray': '#666666',
          'green_two' : "#839c56"
          }

# %%
(
    ggplot(dados_long) +
    aes(x='data', y='valor', color='variavel') +
    geom_hline(yintercept=0, linetype="dashed") +
    geom_line(size=1) +
    scale_color_manual(values=list(colors.values())) +
    scale_x_date(date_breaks = "2 years", date_labels = "%Y") +
    theme(legend_position='top',
          figure_size=(14, 7)) +
    labs(
        title="Hiato do Produto - Brasil",
        subtitle="Cálculos do autor a partir do PIB encadeado dessazonalidado (média 1995 = 100)",
        y="%",
        x='',
        color="",
        caption="Elaboração: analisemacro.com.br | Fonte: IBGE, BCB, IFI \n Nota: hiatos medido como a diferença % do PIB efetivo em relação ao potencial."
    )
)

# %% [markdown]
# ## Estatística Descritivas dos Hiatos
# 
# Um ponto a se observar é do que as medidas de Hiato estimadas via Função de Produção (IFI e BCB) são menos voláteis, e possuem médias negativas, comparando-se às medidas de Tendências.
# 
# 

# %%
dados.describe()


