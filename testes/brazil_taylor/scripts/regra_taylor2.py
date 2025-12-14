"""
===========================================================
  MODELO NK BÁSICO + REGRA DE TAYLOR (GALÍ / SOAVE)
  - Análise de determinância via matriz A_T
  - Região de estabilidade em função de (phi_pi, phi_y)
===========================================================

1) Decisões das firmas → NKPC
2) Decisões das famílias → DIS (Equação IS dinâmica)
3) Decisão do Banco Central → Regra de Taylor

Notas Preliminares:
    - Blanchard & Kahn (1980): Focam em expectativas racionais (RE).
    - Bullard & Mitra (2002): Focam em aprendizagem adaptativa (learning).


=============================================================
Mapa mental / Resumo econômico do modelo e do script
=============================================================
MODELO NOVO-KEYNESIANO (NK)
│
├── 1. FIRMAS (NKPC): FORMAÇÃO DE PREÇOS (rigidez Calvo)
│      │
│      ├─ Preços são rígidos → algumas firmas não podem ajustar
│      │
│      ├─ Firmas que ajustam → escolhem preço olhando para margens futuras
│      │
│      ├─ Resultado: preços dependem do futuro
│      │
│      └─ EQUAÇÃO FUNDAMENTAL:
│             π_t = β E_t[π_{t+1}] + κ x_t
│
│         (Inflação = expectativas futuras + pressão de demanda)
│
│
├── 2. FAMÍLIAS (DIS): CONSUMO INTERTEMPORAL (condição de Euler)
│      │
│      ├─ Decisão: consumir hoje OU amanhã?
│      │
│      ├─ Consumo afeta demanda agregada → hiato do produto
│      │
│      ├─ Hiato depende:
│      │     • da atividade esperada no futuro (E_t x_{t+1})
│      │     • do juro real esperado (i_t − E_t π_{t+1})
│      │     • da taxa natural de juros r_t^n
│      │
│      └─ EQUAÇÃO FUNDAMENTAL:
│             x_t = E_t[x_{t+1}]
│                  - (1/σ)(i_t − E_t[π_{t+1}] − r_t^n)
│
│         (Hiato = expectativas futuras − efeito do juro real)
│
│
├── 3. BANCO CENTRAL (TAYLOR): REGRA DE REAÇÃO
│      │
│      ├─ O Banco Central ajusta a taxa nominal de juros i_t
│      │
│      ├─ Responde a:
│      │     • inflação corrente (π_t)
│      │     • hiato (x_t)
│      │     • choques monetários (v_t)
│      │
│      ├─ Para garantir estabilidade:
│      │     φ_π > 1 (Princípio de Taylor)
│      │
│      └─ EQUAÇÃO FUNDAMENTAL:
│             i_t = ρ + φ_π π_t + φ_y x_t + v_t
│
│         (Juros = nível neutro + resposta à inflação + resposta ao hiato)
│
│
├── 4. COMBINAÇÃO DOS 3 BLOCOS
│      │
│      ├─ Substituir Taylor na DIS → elimina i_t
│      ├─ Substituir DIS na NKPC → relaciona π_t e x_t diretamente
│      ├─ Escrever em forma matricial (Soave/Galí):
│      │
│      │         z_t = A_T E_t[z_{t+1}] + B_T u_t
│      │
│      │     onde z_t = (x_t, π_t)'
│      │
│      ├─ A matriz:
│             A_T = Ω[[σ       , 1 − βφ_π],
│                    [σκ      , κ + β(σ+φ_y)]]
│             Ω = 1/(σ + φ_y + φ_π κ)
│
│
└── 5. ESTABILIDADE: BLANCHARD–KAHN
       │
       ├─ z_t e π_t são forward-looking → exigem 2 raízes estáveis
       │
       ├─ Condição de determinância:
       │       |λ_1| < 1 e |λ_2| < 1
       │
       └─ Condição de Bullard–Mitra:
               κ(φ_π - 1) + (1 - β)φ_y > 0

# Famílias

Euler / consumo intertemporal

Oferta de trabalho ou poupança

## Firmas

FOCs

Margens / rigidez / produtividade

## Mercados

Market clearing

Ativos / bens / trabalho

## Dinâmica

Equação de transição

Choques (AR(1))

## Fechamento

Política (Taylor, regra fiscal)

Condição de estabilidade

De forma ainda mais resumida:
* Famílias → Euler
* Firmas → FOCs
* Mercados → Clearing
* Dinâmica → Choques
* Fechamento → Política / estabilidade

=============================================================
Resumo econômico das condições do modelo NK básico
=============================================================

Estrutura teórica (Galí, cap. 3–4; Soave, Aula 5/6):

% (1) A Curva de Phillips Novo-Keynesiana (NKPC) estabelece que a inflação atual depende das:
%  - expectativas futuras de inflação e do 
%  - hiato do produto, 
% refletindo a rigidez dos preços na economia.
 NKPC:  π_t = β E_t[π_{t+1}] + κ x_t
 
% (2) A Equação IS Dinâmica (DIS) relaciona o hiato do produto às:
%  - expectativas de atividade futura e 
%  - taxa real de juros esperada,
% refletindo o comportamento intertemporal do consumo no modelo NK.
% A Equação IS Dinâmica (DIS) vem da condição de Euler do consumidor representativo.
% Ela descreve como o hiato do produto reage ao juro real esperado.
% O hiato atual x_t aumenta quando os agentes esperam mais atividade futura e diminui quando 
% a taxa real de juros está alta.
 DIS :  x_t = E_t[x_{t+1}] - (1/σ) ( i_t - E_t[π_{t+1}] - r_t^n )

% (3) A Regra de Taylor descreve como o Banco Central ajusta a taxa nominal de juros em resposta à:
%  - inflação corrente,
%  - ao hiato do produto, e
%  - a choques de política monetária,
% servindo como regra de reação que ancora expectativas e garante estabilidade macroeconômica.
 Regra de Taylor (backward-looking, com hiato):
   i_t = ρ + φ_π π_t + φ_y x_t + v_t

% (4) O Problema de Blanchard–Kahn (1980) fornece as condições para existência e unicidade
% de equilíbrios em modelos com expectativas racionais. Para que o sistema tenha solução
% única (determinância), o número de autovalores dentro do círculo unitário deve coincidir
% com o número de variáveis forward-looking. No modelo NK básico, x_t e π_t são ambas 
% forward-looking; portanto, é necessário que os dois autovalores de A_T satisfaçam |λ| < 1.
% É um método para determinar se um sistema dinâmico com expectativas racionais possui solução única,
% múltiplas soluções ou nenhuma solução, baseado na comparação entre o número de variáveis 
% forward-looking e o número de autovalores estáveis do sistema.

 Combinação → sistema à la Blanchard–Kahn:

   [ x_t ]   = A_T [ E_t x_{t+1} ]
   [ π_t ]           [ E_t π_{t+1} ]  + B_T (r_t^n - v_t)

 onde (Soave, Aula 5):

   Ω   = 1 / ( σ + φ_y + φ_π κ )

   A_T = Ω * [[ σ        , 1 - β φ_π          ],
              [ σ κ      , κ + β(σ + φ_y)     ]]

% (5) Para que a inflação e o hiato não entrem em espiral instável, a resposta do Banco Central 
% deve ser suficientemente forte — seja em relação à inflação, seja em relação ao hiato.
% A condição de Bullard--Mitra identifica quando o modelo NK básico possui equilíbrio único.
% Ela decorre da exigência de que ambos os autovalores da matriz A_T estejam dentro do círculo unitário.
% A condição é:
% 
%     κ(\phi_π - 1) + (1 - β)\phi_y > 0,
%
% com \phi_π ≥ 0 e \phi_y ≥ 0. 
% 
% Em termos econômicos, essa condição garante que a política monetária reage de forma suficientemente forte
% à inflação (φ_π > 1) e/ou ao hiato do produto, impedindo trajetórias explosivas e indeterminação do equilíbrio.

A condição de Bullard–Mitra para unicidade/local estabilidade é:

   κ (φ_π - 1) + (1 - β) φ_y > 0,  com φ_π ≥ 0, φ_y ≥ 0.

Este script:

  - Separa parâmetros estruturais vs de política
  - Constrói A_T exatamente como acima
  - Calcula autovalores e interpreta economicamente
  - Desenha um mapa de estabilidade em (φ_π, φ_y)
"""

# =============================
# 1. Importação de bibliotecas
# =============================
import numpy as np
import matplotlib.pyplot as plt


# ==============================================
# 2. Parâmetros estruturais da economia (NK)
# ==============================================
def get_structural_params():
    """
    Parâmetros 'profundos' da economia.

    beta  : fator de desconto intertemporal
    kappa : inclinação da NKPC (sensibilidade da inflação ao hiato)
    sigma : elasticidade intertemporal de substituição (EIS)

    Esses parâmetros NÃO são escolhas do Banco Central.
    São propriedades da economia (preferências, fricções, tecnologia).
    """
    beta = 0.99   # típico trimestral
    kappa = 0.1   # valor ilustrativo
    sigma = 1.0   # EIS = 1 (log-utility)

    return beta, kappa, sigma


# ==========================================================
# 3. Parâmetros de política monetária (Regra de Taylor)
# ==========================================================
def get_policy_params():
    """
    Parâmetros de reação do Banco Central:

    phi_pi : quanto os juros sobem quando a inflação sobe 1 p.p.
    phi_y  : quanto os juros reagem ao hiato do produto.

    Estes são 'instrumentos de desenho de regra', não da economia.
    """
    phi_pi = 1.5   # > 1 → Princípio de Taylor
    phi_y  = 0.5   # reação moderada ao hiato

    return phi_pi, phi_y


# ==============================================
# 4. Construção da matriz A_T (Galí / Soave)
# ==============================================
def build_AT(beta, kappa, sigma, phi_pi, phi_y):
    """
    Constrói a matriz A_T do sistema:

      z_t = A_T E_t[z_{t+1}] + ...

    onde z_t = [x_t, π_t]' empilha hiato e inflação.

    Fórmula (Soave, Aula 5):

      Ω   = 1 / (σ + φ_y + φ_π κ)

      A_T = Ω * [[ σ        , 1 - β φ_π          ],
                 [ σ κ      , κ + β(σ + φ_y)     ]]
    """
    Omega = 1.0 / (sigma + phi_y + phi_pi * kappa)

    AT = Omega * np.array([
        [sigma,              1.0 - beta * phi_pi],
        [sigma * kappa,      kappa + beta * (sigma + phi_y)]
    ])

    return AT


# ======================================================
# 5. Análise dos autovalores e determinância (BK)
# ======================================================
def analyze_eigenvalues_AT(AT):
    """
    Calcula autovalores de A_T e interpreta:

    - No problema BK, queremos que o número de autovalores
      dentro do círculo unitário seja igual ao número de
      variáveis 'forward' (aqui, 2: x_t e π_t).

    - Como todas as variáveis aqui são forward, a condição de
      unicidade local é: AMBOS autovalores de A_T têm |λ| < 1.

    Retorna:
      eigvals   : array com autovalores
      is_unique : True se 0 < |λ_i| < 1 para todos i.
    """
    eigvals, _ = np.linalg.eig(AT)

    print("\nAutovalores de A_T:")
    for i, ev in enumerate(eigvals):
        print(f"  λ_{i+1} = {ev:.4f}  |λ_{i+1}| = {abs(ev):.4f}")

    # Critério: todos dentro do círculo unitário
    inside = np.abs(eigvals) < 1.0
    is_unique = bool(np.all(inside))

    if is_unique:
        print("\n=> Todos os autovalores têm módulo < 1.")
        print("   → Sistema BK com equilíbrio único (localmente estável).")
    else:
        print("\n=> Algum autovalor tem módulo ≥ 1.")
        print("   → Risco de indeterminação (múltiplos equilíbrios) ou não existência.")

    return eigvals, is_unique


# ======================================================
# 6. Mapa de estabilidade em função de (φ_π, φ_y)
# ======================================================
def plot_stability_region(beta, kappa, sigma,
                          phi_pi_range=(0.0, 3.0),
                          phi_y_range=(0.0, 2.0),
                          num_points_pi=100,
                          num_points_y=80):
    """
    Gera um gráfico mostrando, para cada par (φ_π, φ_y),
    se a matriz A_T gera autovalores dentro ou fora
    do círculo unitário.

    Passos econômicos:
      - Para cada (φ_π, φ_y), montamos A_T.
      - Calculamos autovalores.
      - Se max |λ| < 1 → região de equilíbrio único (determinância BK).
      - Se max |λ| ≥ 1 → indeterminação/instabilidade.

    Também desenhamos a reta de Bullard–Mitra:

       κ (φ_π - 1) + (1 - β) φ_y = 0

    que é a fronteira analítica de determinância (com φ_π, φ_y ≥ 0).
    """
    # Grades de φ_π e φ_y
    phi_pi_vals = np.linspace(phi_pi_range[0], phi_pi_range[1], num_points_pi)
    phi_y_vals  = np.linspace(phi_y_range[0],  phi_y_range[1],  num_points_y)

    # Matriz com o máximo módulo de autovalores para cada par
    max_abs_eig = np.zeros((num_points_y, num_points_pi))

    for iy, phi_y in enumerate(phi_y_vals):
        for ix, phi_pi in enumerate(phi_pi_vals):
            AT = build_AT(beta, kappa, sigma, phi_pi, phi_y)
            eigvals, _ = np.linalg.eig(AT)
            max_abs_eig[iy, ix] = np.max(np.abs(eigvals))

    # Região estável: max |λ| < 1
    stable_region = (max_abs_eig < 1.0)

    # Figura
    plt.figure(figsize=(8, 6))

    # Heatmap binário: estável (1) vs. instável (0)
    plt.imshow(stable_region,
               extent=(phi_pi_range[0], phi_pi_range[1],
                       phi_y_range[0], phi_y_range[1]),
               origin="lower",
               aspect="auto")

    plt.colorbar(label="1 = determinante, 0 = indeterminante")

    # Reta de Bullard–Mitra: κ(φ_π - 1) + (1-β) φ_y = 0
    phi_pi_line = np.linspace(phi_pi_range[0], phi_pi_range[1], 200)
    # Evitar divisão por zero se (1-β) = 0 (não é o caso típico)
    if (1.0 - beta) > 0:
        phi_y_line = -kappa * (phi_pi_line - 1.0) / (1.0 - beta)
        plt.plot(phi_pi_line, phi_y_line)

    plt.xlabel(r"$\phi_\pi$  (resposta à inflação)")
    plt.ylabel(r"$\phi_y$   (resposta ao hiato)")
    plt.title("Região de determinância do modelo NK (A_T)")

    plt.tight_layout()
    plt.show()


# ===========================================
# 7. MAIN: rodar análises
# ===========================================
if __name__ == "__main__":
    # --------------------------
    # 7.1. Parâmetros do modelo
    # --------------------------
    beta, kappa, sigma = get_structural_params()
    phi_pi, phi_y = get_policy_params()

    print("===========================================")
    print(" Parâmetros estruturais (economia)")
    print("===========================================")
    print(f"β       = {beta}")
    print(f"κ (kappa) = {kappa}")
    print(f"σ       = {sigma}")

    print("\n===========================================")
    print(" Parâmetros de política (Regra de Taylor)")
    print("===========================================")
    print(f"φ_π     = {phi_pi}")
    print(f"φ_y     = {phi_y}")

    # --------------------------
    # 7.2. Matriz A_T e autovalores
    # --------------------------
    AT = build_AT(beta, kappa, sigma, phi_pi, phi_y)

    print("\nMatriz A_T (Galí/Soave):")
    print(AT)

    eigvals, is_unique = analyze_eigenvalues_AT(AT)

    # --------------------------
    # 7.3. Região de estabilidade em (φ_π, φ_y)
    # --------------------------
    print("\nGerando mapa de estabilidade em função de (φ_π, φ_y)...")
    plot_stability_region(beta, kappa, sigma,
                          phi_pi_range=(0.0, 3.0),
                          phi_y_range=(0.0, 2.0))


# ============================================================
# INTERPRETAÇÃO ECONÔMICA DOS RESULTADOS
# ============================================================

# -------------------------------
# 1. Parâmetros estruturais
# -------------------------------
# β = 0.99:
#     Forte peso no futuro → economia altamente forward-looking.
#
# κ = 0.1:
#     Curva de Phillips plana → inflação reage pouco ao hiato.
#     Isso torna a estabilização mais difícil: o BC precisa reagir mais.
#
# σ = 1.0:
#     Elasticidade intertemporal igual a 1 (log-utility).
#     Juro real afeta consumo de maneira proporcional.

# -------------------------------
# 2. Parâmetros da Regra de Taylor
# -------------------------------
# φ_π = 1.5:
#     Satisfaz o Princípio de Taylor (φ_π > 1).
#     Política suficientemente agressiva contra inflação.
#
# φ_y = 0.5:
#     Reação moderada ao hiato → contribui para estabilidade marginal.

# -------------------------------
# 3. Matriz A_T (dinâmica forward-looking)
# -------------------------------
# A_T mostra como (x_t, π_t) dependem das expectativas futuras.
#
# Elementos principais:
#  - A_T[0,0] = 0.606:
#       O hiato atual depende ~60% do hiato esperado no futuro.
#
#  - A_T[0,1] = -0.294:
#       Inflação futura maior → hiato atual menor (via juro real esperado).
#
#  - A_T[1,0] = 0.061:
#       Inflação futura reage muito pouco ao hiato futuro (κ baixo).
#
#  - A_T[1,1] = 0.961:
#       Inflação atual depende fortemente da inflação esperada → forward-looking forte.

# -------------------------------
# 4. Autovalores e Blanchard–Kahn
# -------------------------------
# Autovalores:
#    λ1 = 0.6667      |λ1| < 1
#    λ2 = 0.9000      |λ2| < 1
#
# Como ambas as raízes estão dentro do círculo unitário:
#
#   → Sistema cumpre Blanchard–Kahn
#   → Existe equilíbrio único (determinância)
#   → A economia converge após choques (estabilidade local)
#
# Em termos econômicos:
#   - A política monetária é forte o suficiente para ancorar expectativas.
#   - Não há trajetórias explosivas.
#   - Não há múltiplos equilíbrios (indeterminação).

# -------------------------------
# 5. Mapa de estabilidade (φ_π, φ_y)
# -------------------------------
# A região amarela no gráfico representa valores que geram determinância
# (ambos autovalores < 1). A região escura representa indeterminação.
#
# A linha azul é a fronteira analítica de Bullard–Mitra:
#     κ(φ_π - 1) + (1 - β)φ_y = 0
#
#   - Acima da linha → equilíbrio único
#   - Abaixo da linha → indeterminação
#
# Com φ_π = 1.5 e φ_y = 0.5, o ponto está claramente na região estável.
#
# Conclusão:
#   A combinação de parâmetros escolhida (φ_π, φ_y) garante que a política
#   monetária estabiliza a inflação e o hiato mesmo com curva de Phillips plana.
#
# ============================================================
