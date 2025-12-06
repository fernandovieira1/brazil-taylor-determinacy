"""
===========================================================
  MODELO NOVO-KEYNESIANO SIMPLIFICADO + REGRA DE TAYLOR
  (Notação inspirada em Galí, 2015)
===========================================================

Objetivo:
---------
Permitir que você:
  1) escolha parâmetros (β, κ, σ, φ_π, φ_x);
  2) veja a matriz de transição do sistema (π_t, x_t);
  3) calcule autovalores e tenha uma noção de "estabilidade";
  4) simule a resposta da inflação e do hiato a um choque de juros.

Estrutura do modelo (linearizada, determinística, perfect foresight):
---------------------------------------------------------------------
1) Curva de Phillips NK:
   π_t = β π_{t+1} + κ x_t

2) Equação IS dinâmica:
   x_t = x_{t+1} - (1/σ) ( i_t - π_{t+1} - r_t^n )

   Aqui vamos supor r_t^n = 0 para simplificar.

3) Regra de Taylor (sem suavização, π* = 0, r^n = 0):
   i_t = φ_π π_t + φ_x x_t + ε_t^i

   Obs: isso é equivalente à forma de Galí com desvios em relação à meta,
   tomando π* = 0 e r^n = 0 por simplicidade.

A ideia é combinar (1), (2) e (3) para obter uma dinâmica
do tipo:

   [π_{t+1}]   = A11 π_t + A12 x_t + B1 ε_t^i
   [x_{t+1}]     A21 π_t + A22 x_t + B2 ε_t^i

Ou seja:
   y_{t+1} = A y_t + B ε_t^i,
   onde y_t = [π_t, x_t]'.

Você poderá:
-----------
- Mexer nos parâmetros (especialmente φ_π) e ver:
    * autovalores de A;
    * trajetória de π_t, x_t e i_t após um choque de juros.
"""

# =============================
# 1. Importação de bibliotecas
# =============================
import numpy as np
import matplotlib.pyplot as plt


# ======================================
# 2. Função para construir o sistema NK
# ======================================
def build_nk_system(beta=0.99, kappa=0.1, sigma=1.0,
                    phi_pi=1.5, phi_x=0.5):
    """
    Constrói a matriz de transição A e o vetor de impacto B
    para o sistema (π_{t+1}, x_{t+1}) = A (π_t, x_t) + B ε_t^i.

    Parâmetros:
    -----------
    beta  : fator de desconto (0 < β < 1)
    kappa : parâmetro de sensibilidade da inflação ao hiato
    sigma : aversão ao risco / elasticidade intertemporal de substituição
    phi_pi: resposta da taxa de juros à inflação na Regra de Taylor
    phi_x : resposta da taxa de juros ao hiato na Regra de Taylor

    Retorna:
    --------
    A : matriz 2x2 de transição
    B : vetor 2x1 (coluna) de impacto do choque de política monetária
    """
    # -------------------------------
    # 2.1 Derivação passo a passo
    # -------------------------------
    # NKPC: π_t = β π_{t+1} + κ x_t
    #  => β π_{t+1} = π_t - κ x_t
    #  => π_{t+1} = (1/β) π_t - (κ/β) x_t

    # Regra de Taylor (sem meta explícita, sem r^n, sem suavização):
    # i_t = φ_π π_t + φ_x x_t + ε_t^i

    # IS: x_t = x_{t+1} - (1/σ) (i_t - π_{t+1} - r_t^n)
    # Com r_t^n = 0:
    # x_t = x_{t+1} - (1/σ) (i_t - π_{t+1})
    #  => x_{t+1} = x_t + (1/σ) (i_t - π_{t+1})

    # Substituir i_t e π_{t+1} em x_{t+1}:
    # x_{t+1} = x_t + (1/σ)[ (φ_π π_t + φ_x x_t + ε_t^i)
    #                         - ( (1/β) π_t - (κ/β) x_t ) ]

    # Vamos organizar isso de forma algébrica via numpy.

    # Coeficientes da expressão de π_{t+1} em função de (π_t, x_t):
    a11 = 1.0 / beta       # coeficiente de π_t
    a12 = -kappa / beta    # coeficiente de x_t

    # Agora para x_{t+1}:
    # Dentro do colchete:
    # (φ_π π_t + φ_x x_t + ε_t^i) - ( (1/β) π_t - (κ/β) x_t )
    # = (φ_π - 1/β) π_t + (φ_x + κ/β) x_t + ε_t^i

    # Então:
    # x_{t+1} = x_t + (1/σ) * [ (φ_π - 1/β) π_t + (φ_x + κ/β) x_t + ε_t^i ]

    a21 = (1.0 / sigma) * (phi_pi - 1.0 / beta)  # coef. de π_t
    a22 = 1.0 + (1.0 / sigma) * (phi_x + kappa / beta)  # coef. de x_t
    b1 = 0.0                                    # choque não entra diretamente em π_{t+1}
    b2 = 1.0 / sigma                            # coeficiente do choque em x_{t+1}

    # Matriz de transição A e vetor B:
    A = np.array([[a11, a12],
                  [a21, a22]])

    B = np.array([[b1],
                  [b2]])

    return A, B


# ===========================================
# 3. Função para analisar autovalores de A
# ===========================================
def analyze_stability(A):
    """
    Analisa os autovalores da matriz A.

    Interpretação (sob nossa simplificação):
    ---------------------------------------
    - Se todos os autovalores têm módulo < 1, o sistema (π_t, x_t)
      tende a convergir de volta ao equilíbrio após um choque.
      (Dinâmica estável no sentido usual de sistemas lineares.)

    - Se algum autovalor tem módulo > 1, o sistema tende a divergir.
      (Sinais de instabilidade/indeterminação na intuição NK.)

    OBS: No modelo NK completo com expectativas racionais e
         condição de Blanchard-Kahn, a lógica é mais sutil.
         Aqui estamos usando uma aproximação determinística
         para ganhar intuição.
    """
    eigvals, eigvecs = np.linalg.eig(A)

    print("Autovalores de A:")
    for i, ev in enumerate(eigvals):
        print(f"  λ_{i+1} = {ev:.4f}  |λ_{i+1}| = {abs(ev):.4f}")

    # Critério simples de estabilidade:
    stable = np.all(np.abs(eigvals) < 1.0)
    if stable:
        print("\n=> TODOS os autovalores têm módulo < 1.")
        print("   Nesta versão simplificada, isso indica dinâmica estável.")
    else:
        print("\n=> ALGUM autovalor tem módulo ≥ 1.")
        print("   Sinal de dinâmica explosiva/instável nesta aproximação.\n")

    return eigvals


# ================================================
# 4. Função para simular resposta a um choque
# ================================================
def simulate_irf(A, B, phi_pi, phi_x,
                 T=40, shock_size=0.01):
    """
    Simula a resposta de π_t, x_t e i_t a um choque de política monetária
    de tamanho 'shock_size' na data t=0.

    Parâmetros:
    -----------
    A, B       : matrizes do sistema
    phi_pi     : coeficiente da Regra de Taylor
    phi_x      : coeficiente da Regra de Taylor
    T          : horizonte de simulação (número de períodos)
    shock_size : tamanho do choque ε_0^i (por exemplo, 0.01 = 1 p.p.)

    Retorna:
    --------
    pi_path : trajetória de π_t
    x_path  : trajetória de x_t
    i_path  : trajetória de i_t
    """
    # Vetores para guardar as trajetórias
    pi_path = np.zeros(T)
    x_path = np.zeros(T)
    i_path = np.zeros(T)

    # Estado inicial: π_0 = 0, x_0 = 0 (equilíbrio)
    pi_t = 0.0
    x_t = 0.0

    for t in range(T):
        # Choque de política monetária apenas no primeiro período
        if t == 0:
            eps_t = shock_size
        else:
            eps_t = 0.0

        # Regra de Taylor: i_t = φ_π π_t + φ_x x_t + ε_t
        i_t = phi_pi * pi_t + phi_x * x_t + eps_t

        # Guardar valores
        pi_path[t] = pi_t
        x_path[t] = x_t
        i_path[t] = i_t

        # Próximo período:
        # y_{t+1} = A y_t + B ε_t^i
        y_t = np.array([[pi_t],
                        [x_t]])
        y_next = A @ y_t + B * eps_t

        pi_t = float(y_next[0, 0])
        x_t  = float(y_next[1, 0])

    return pi_path, x_path, i_path


# ===========================================
# 5. Função para plotar as trajetórias
# ===========================================
def plot_irf(pi_path, x_path, i_path, dt=1.0):
    """
    Plota as trajetórias de π_t, x_t e i_t.

    dt: tamanho do período (por exemplo, 1 trimestre = 1).
    """
    T = len(pi_path)
    t_grid = np.arange(T) * dt

    fig, axs = plt.subplots(3, 1, figsize=(8, 10), sharex=True)

    axs[0].plot(t_grid, pi_path)
    axs[0].axhline(0, linestyle='--')
    axs[0].set_ylabel("Inflação (π_t)")
    axs[0].set_title("Resposta à um choque de política monetária")

    axs[1].plot(t_grid, x_path)
    axs[1].axhline(0, linestyle='--')
    axs[1].set_ylabel("Hiato do produto (x_t)")

    axs[2].plot(t_grid, i_path)
    axs[2].axhline(0, linestyle='--')
    axs[2].set_ylabel("Juros nominais (i_t)")
    axs[2].set_xlabel("Tempo (períodos)")

    plt.tight_layout()
    plt.show()


# ===========================================
# 6. "Main": aqui você configura e roda tudo
# ===========================================
if __name__ == "__main__":
    # ----------------------------------------------------
    # 6.1 Escolha os parâmetros do modelo (mude à vontade)
    # ----------------------------------------------------
    beta  = 0.99   # Fator de desconto (~0.99 por trimestre é padrão)
    kappa = 0.1    # Sensibilidade da inflação ao hiato
    sigma = 1.0    # Elasticidade intertemporal (ou aversão ao risco)
    phi_pi = 1.5   # Resposta dos juros à inflação  (REGRA DE TAYLOR)
    phi_x  = 0.5   # Resposta dos juros ao hiato

    # Tamanho do choque de juros (por ex. 0.01 = 1 p.p.)
    shock_size = 0.01

    # Horizonte de simulação (número de períodos)
    T = 40

    print("===========================================")
    print(" Parâmetros do modelo")
    print("===========================================")
    print(f"β       = {beta}")
    print(f"κ (kappa) = {kappa}")
    print(f"σ       = {sigma}")
    print(f"φ_π     = {phi_pi}")
    print(f"φ_x     = {phi_x}")
    print(f"Choque de juros (ε_0) = {shock_size}")
    print("")

    # -----------------------------------------
    # 6.2 Construir sistema e analisar A
    # -----------------------------------------
    A, B = build_nk_system(beta=beta, kappa=kappa, sigma=sigma,
                           phi_pi=phi_pi, phi_x=phi_x)

    print("Matriz de transição A (para [π_{t+1}, x_{t+1}]):")
    print(A)
    print("\nVetor de impacto B (choque de política monetária):")
    print(B)
    print("\nAnálise de estabilidade (autovalores de A):")
    eigvals = analyze_stability(A)

    # -----------------------------------------
    # 6.3 Simular resposta a um choque de juros
    # -----------------------------------------
    pi_path, x_path, i_path = simulate_irf(
        A, B, phi_pi, phi_x,
        T=T, shock_size=shock_size
    )

    print("\nAlgumas estatísticas rápidas da simulação:")
    print(f"Máxima inflação (π_t): {pi_path.max():.4f}")
    print(f"Mínima inflação (π_t): {pi_path.min():.4f}")
    print(f"Máximo hiato (x_t):    {x_path.max():.4f}")
    print(f"Mínimo hiato (x_t):    {x_path.min():.4f}")
    print(f"Máximo i_t:            {i_path.max():.4f}")
    print(f"Mínimo i_t:            {i_path.min():.4f}")

    # -----------------------------------------
    # 6.4 Plotar IRFs
    # -----------------------------------------
    plot_irf(pi_path, x_path, i_path)
