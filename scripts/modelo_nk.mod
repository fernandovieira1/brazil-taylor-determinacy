
// ********************************************
// SIMULAÇÃO NK
// --------------------------------------------
// Determinância e Política Monetária no Brasil: Uma Avaliação Empírica do Princípio de Taylor (1999–2024)
// Fernando V. e Rafaela D.
// ********************************************

// * Modelo com Regra de Taylor Híbrida
// * Ver se o modelo "explode" ou converge (Blanchard-Kahn)

// --- IMPORTANTE ---
// PS: Rafaela, veja se o script está ok! Nunca usei Dynare antes e fiz baseado no que li na documentação e em exemplos.
// --- !!!!!!!!!! ---

// **********************************************************************************************************
// **********************************************************************************************************

// ............................................
// --- MODELO 1 ---
// rho, phi_pi, phi_y com valores baseados na literatura
// ............................................

// **********************************************************************************************************
// **********************************************************************************************************

// ********************************************
// MODELO
// ********************************************

// --------------------------------------------
// 1. Declaração de Variáveis
// --------------------------------------------

// Variáveis Endógenas
// Equações do Modelo:
var pi      // Inflação
    y       // Hiato do Produto
    i       // Taxa de Juros Nominal
    r_real; // Taxa de Juros Real (apenas para análise)

// Variáveis Exógenas (Choques)
varexo e_i  // Choque de Política Monetária
       e_pi // Choque de Custo (Oferta)
       e_y; // Choque de Demanda

// --------------------------------------------
// 2. Parâmetros
// --------------------------------------------

// Modelo NK Básico com Regra de Taylor Híbrida
parameters beta     // Fator de desconto
           sigma    // Aversão ao risco (inverso da elast. subst. intertemp.)
           kappa    // Inclinação da Curva de Phillips
           
           // (RESULTADOS MODELO HÍBRIDO - Tabela 3)
           phi_pi   // Resposta à Inflação
                    // 1 BCB gap ($\tilde y_{t-1}$)      :  0.8367 
                    // 2 BCB gap ($\tilde y_{t-2}$)      :  0.9166
                    // 3 Hamilton gap ($\tilde y_{t-1}$) :  0.7359
                    // 4 Hamilton gap ($\tilde y_{t-2}$) :  0.7643
                    // 5 HP gap ($\tilde y_{t-1}$)       :  0.7341 
                    // 6 HP gap ($\tilde y_{t-2}$)       :  0.7843
                    // 7 IFI gap ($\tilde y_{t-1}$)      :  0.7851
                    // 8 IFI gap ($\tilde y_{t-2}$)      :  0.8383
                    // OBS: Todos abaixo de 1 (Curto Prazo)
                    // Média geral: 0.7994
           
           // (RESULTADOS MODELO HÍBRIDO - Tabela 3)
           phi_y    // Resposta ao Hiato
                    // 1 BCB gap ($\tilde y_{t-1}$)      : -0.1222  
                    // 2 BCB gap ($\tilde y_{t-2}$)      : -0.2594
                    // 3 Hamilton gap ($\tilde y_{t-1}$) :  0.0495
                    // 4 Hamilton gap ($\tilde y_{t-2}$) :  0.0214
                    // 5 HP gap ($\tilde y_{t-1}$)       :  0.0719
                    // 6 HP gap ($\tilde y_{t-2}$)       : -0.0074
                    // 7 IFI gap ($\tilde y_{t-1}$)      : -0.0274
                    // 8 IFI gap ($\tilde y_{t-2}$)      : -0.1218
                    // OBS: Pequenas respostas ao hiato
                    // Média geral: -0.0494
           
           // (RESULTADOS MODELO HÍBRIDO - Tabela 3)
           rho;     // Suavização da taxa de juros
                    // 1 BCB gap ($\tilde y_{t-1}$)      :  1.0031 
                    // 2 BCB gap ($\tilde y_{t-2}$)      :  1.0394
                    // 3 Hamilton gap ($\tilde y_{t-1}$) :  0.9595
                    // 4 Hamilton gap ($\tilde y_{t-2}$) :  0.9700
                    // 5 HP gap ($\tilde y_{t-1}$)       :  0.9704
                    // 6 HP gap ($\tilde y_{t-2}$)       :  0.9817
                    // 7 IFI gap ($\tilde y_{t-1}$)      :  0.9861
                    // 8 IFI gap ($\tilde y_{t-2}$)      :  1.0139
                    // OBS: Quase raiz unitária
                    // Média geral: 0.9905

// --- CALIBRAÇÃO (Baseada em literatura Brasil: Kanczuk, Tombini) ---
beta  = 0.99;    // Juro real de eq. aprox 4% a.a.
sigma = 1.5;     // Padrão literatura
kappa = 0.08;    // Rigidez de preços (Curva Phillips "flat" típica)

// --- RESULTADOS GMM HÍBRIDO (arbitrário) ---
// Cenário 1: Super-Inercial (Determinante?)
rho    = 0.98;   // Quase raiz unitária
phi_pi = 0.85;   // Abaixo de 1 (Curto Prazo)
phi_y  = 0.05;   // Resposta pequena ao hiato

// --------------------------------------------
// 3. Modelo (Equações Linearizadas)
// --------------------------------------------

// y(+1) e pi(+1) significam expectativas racionais (valores esperados do próximo período).

model(linear);
    
    // --------------------------------------------
    // (I) Curva IS Dinâmica: y = E(y(+1)) - (1/sigma)*(i - E(pi(+1))) + e_y
    // --------------------------------------------
    // Equação IS: consumo/hiato respondem à taxa de juros real ex-ante.

    y = y(+1) - (1/sigma)*(i - pi(+1)) + e_y;


    // --------------------------------------------
    // (II) Curva de Phillips NK: pi = beta*E(pi(+1)) + kappa*y + e_pi
    // --------------------------------------------
    // NKPC: inflação responde ao hiato e às expectativas futuras.
    
    pi = beta*pi(+1) + kappa*y + e_pi;

    // --------------------------------------------
    // (III) Regra de Taylor Híbrida: i = rho*i(-1) + (1-rho)*(phi_pi*pi + phi_y*y) + e_i
    // --------------------------------------------
    // Regra de Taylor híbrida com suavização
    // rho*i(-1): suavização (super-inércia).
    // phi_pi*pi: resposta contemporânea à inflação.
    // phi_y*y: resposta ao hiato.
    // e_i: choque de política.
    // OBS: Como nossa estimativa foi direta nos coeficientes de curto prazo, a eq é:
    
    i = rho*i(-1) + phi_pi*pi + phi_y*y + e_i;

    // Pelo que entendi, o modelo pega essas três equações, forma a matriz de transição e verifica se existe um equilíbrio racional que fecha o sistema (Blanchard–Kahn). Se sim, o modelo é estável/determinante. Se não, explode (é indeterminante). Seria isso??

    // --------------------------------------------
    // (IV) Definição Juro Real (ex-ante)
    // --------------------------------------------

    r_real = i - pi(+1);
end;

// --------------------------------------------
// 4. Simulação
// --------------------------------------------
// Estado Estacionário (Tudo zero pois é modelo linearizado em desvios)
// Como o modelo está linearizado em torno de um estado estacionário com inflação e hiato zero, o steady state é trivial: pi = y = i = r_real = 0.
steady;

// --------------------------------------------
// 5. Configuração dos Choques (Desvios Padrão)
// --------------------------------------------
shocks;
    var e_i = 0.25; // Choque 0.25 p.p. na Selic
    var e_pi = 1.0; // Choque 1% na inflação
end;

// --------------------------------------------
// 6. Simulação Estocástica (IRFs)
// --------------------------------------------
// periods=0 (apenas IRFs teóricas), irf=20 (20 trimestres/5 anos)
stoch_simul(order=1, irf=20, graph_format=pdf) pi y i;


// ----------------------------------------------------------
// Como interpretar os gráficos de IRF gerados pelo Dynare
// ----------------------------------------------------------
// - O eixo horizontal é o tempo (trimestres, 1 a 20).
// - O eixo vertical mostra o desvio em relação ao steady state
//   (em unidades das próprias variáveis).
//
// Para o choque de inflação (arquivo modelo_nk_IRF_e_pi.pdf):
//   * pi: desvia no primeiro período e depois converge lentamente para 0.
//   * i : se eleva e retorna de forma gradual, refletindo a inércia alta.
//   * y : cai (aperto monetário contrai a demanda) e volta ao equilíbrio.
//
// O ponto crucial é se todas as curvas convergem suavemente para zero,
// o que indica graficamente que o equilíbrio é único e estável
// (condições de Blanchard–Kahn satisfeitas).
// Isso mostra que uma política super-inercial (p. ex.: rho ≈ 0.98 e
// phi_pi < 1) ainda assim consegue estabilizar inflação e hiato
// ao longo do tempo via persistência da taxa de juros.
// ----------------------------------------------------------