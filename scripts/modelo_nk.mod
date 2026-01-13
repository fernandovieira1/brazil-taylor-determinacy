
// ********************************************
// SIMULAÇÃO NK
// --------------------------------------------
// Determinância e Política Monetária no Brasil: Uma Avaliação Empírica do Princípio de Taylor (1999–2024)
// Fernando V. e Rafaela D.
// ********************************************

// * Modelo com Regra de Taylor Híbrida
// * Ver se o modelo "explode" ou converge (Blanchard-Kahn)

// --- IMPORTANTE ---
// PS: Rafaela, veja se o modelo está ok conforme discutido! Nunca usei Dynare antes e fiz baseado no que li na documentação e em exemplos.
// --- !!!!!!!!!! ---

// ********************************************
// MODELO
// ********************************************

// --------------------------------------------
// 1. Declaração de Variáveis
// --------------------------------------------
var pi      // Inflação
    y       // Hiato do Produto
    i       // Taxa de Juros Nominal
    r_real; // Taxa de Juros Real (apenas para análise)

varexo e_i  // Choque de Política Monetária
       e_pi // Choque de Custo (Oferta)
       e_y; // Choque de Demanda

// --------------------------------------------
// 2. Parâmetros
// --------------------------------------------
parameters beta     // Fator de desconto
           sigma    // Aversão ao risco (inverso da elast. subst. intertemp.)
           kappa    // Inclinação da Curva de Phillips
           phi_pi   // Resposta à Inflação (VER RESULTADO)
           phi_y    // Resposta ao Hiato (VER RESULTADO)
           rho;     // Suavização da taxa de juros (VER RESULTADO)

// --- CALIBRAÇÃO (Baseada em literatura Brasil: e.g., Kanczuk, Tombini) ---
beta  = 0.99;    // Juro real de eq. aprox 4% a.a.
sigma = 1.5;     // Padrão literatura
kappa = 0.08;    // Rigidez de preços (Curva Phillips "flat" típica)

// --- SEUS RESULTADOS ESTIMADOS (GMM HÍBRIDO - Tabela 3, Média Aprox) ---
// Cenário 1: Super-Inercial (Determinante?)
rho    = 0.98;   // Quase raiz unitária
phi_pi = 0.85;   // Abaixo de 1 (Curto Prazo)
phi_y  = 0.05;   // Resposta pequena ao hiato

// --------------------------------------------
// 3. Modelo (Equações Linearizadas)
// --------------------------------------------
model(linear);
    // (1) Curva IS Dinâmica: y = E(y(+1)) - (1/sigma)*(i - E(pi(+1))) + e_y
    y = y(+1) - (1/sigma)*(i - pi(+1)) + e_y;

    // (2) Curva de Phillips NK: pi = beta*E(pi(+1)) + kappa*y + e_pi
    pi = beta*pi(+1) + kappa*y + e_pi;

    // (3) Regra de Taylor Híbrida: i = rho*i(-1) + (1-rho)*(phi_pi*pi + phi_y*y) + e_i
    // OBS: Como sua estimativa foi direta nos coeficientes de curto prazo, a eq é:
    // i = rho*i(-1) + phi_pi*pi + phi_y*y + e_i 
    // (Atenção aqui: Se no paper phi_pi já é o curto prazo, a eq é essa abaixo)
    i = rho*i(-1) + phi_pi*pi + phi_y*y + e_i;

    // (4) Definição Juro Real (Ex-ante)
    r_real = i - pi(+1);
end;

// --------------------------------------------
// 4. Simulação
// --------------------------------------------
// Estado Estacionário (Tudo zero pois é modelo linearizado em desvios)
steady;

// --------------------------------------------
// 5. Configuração dos Choques (Desvios Padrão)
// --------------------------------------------
shocks;
    var e_i = 0.25; // Choque de 0.25 p.p. (25bps) na Selic
    var e_pi = 1.0; // Choque de 1% na inflação
end;

// --------------------------------------------
// 6. Simulação Estocástica (IRFs)
// --------------------------------------------
// periods=0 (apenas IRFs teóricas), irf=20 (20 trimestres/5 anos)
stoch_simul(order=1, irf=20, graph_format=pdf) pi y i;
