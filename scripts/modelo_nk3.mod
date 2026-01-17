// ********************************************
// SIMULAÇÃO NK - CENÁRIO CONTRAFACTUAL
// --------------------------------------------
// Determinância e Política Monetária no Brasil: Uma Avaliação Empírica do Princípio de Taylor (1999–2024)
// Fernando V. e Rafaela D.
// ********************************************

// * Objetivo: Testar se a regra estimada seria estável SEM o componente de suavização.
// * Expectativa: Falha de Convergência (Indeterminação)

// **********************************************************************************************************
// **********************************************************************************************************

// ............................................
// --- MODELO 3---
// * Contrafactual "Sem Inércia"
// ............................................

// **********************************************************************************************************
// **********************************************************************************************************

// --------------------------------------------
// 1. Declaração de Variáveis
// --------------------------------------------
var pi      // Inflação
    y       // Hiato do Produto
    i       // Taxa de Juros Nominal
    r_real; // Taxa de Juros Real

varexo e_i  // Choque de Política Monetária
       e_pi // Choque de Custo (Oferta)
       e_y; // Choque de Demanda

// --------------------------------------------
// 2. Parâmetros
// --------------------------------------------

parameters beta     // Fator de desconto
           sigma    // Aversão ao risco
           kappa    // Inclinação da Curva de Phillips
           phi_pi   // Resposta à Inflação
           phi_y    // Resposta ao Hiato
           rho;     // Suavização da taxa de juros

// --- CALIBRAÇÃO ESTRUTURAL (Mesma do Modelo Base) ---
beta  = 0.99;    
sigma = 1.5;     
kappa = 0.08;    

// --- PARAMETRIZAÇÃO CONTRAFACTUAL ---
// Mantemos a resposta de curto prazo estimada, mas removemos a inércia.

rho    = 0.00;    // AQUI ESTÁ O TESTE: Inércia desligada.
phi_pi = 0.7994;  // Média estimada (Tabela 3) - Mantida constante.
phi_y  = -0.0494; // Média estimada (Tabela 3) - Mantida constante.

// --------------------------------------------
// 3. Modelo (Linear)
// --------------------------------------------
model(linear);
    // (I) Curva IS Dinâmica
    y = y(+1) - (1/sigma)*(i - pi(+1)) + e_y;

    // (II) Curva de Phillips NK
    pi = beta*pi(+1) + kappa*y + e_pi;

    // (III) Regra de Taylor Híbrida (Agora sem inércia pois rho=0)
    i = rho*i(-1) + phi_pi*pi + phi_y*y + e_i;

    // (IV) Juro Real
    r_real = i - pi(+1);
end;

// --------------------------------------------
// 4. Steady State & Choques
// --------------------------------------------
steady;

shocks;
    var e_i = 0.25; 
    var e_pi = 1.0; 
end;

// --------------------------------------------
// 5. Simulação
// --------------------------------------------
// Se der erro de Blanchard-Kahn aqui, a hipótese do paper está confirmada.
stoch_simul(order=1, irf=20, graph_format=pdf) pi y i;


// -------------------------------------------------------------------
// RESULTADO DO EXERCÍCIO CONTRAFACTUAL (SEM INÉRCIA)
// -------------------------------------------------------------------
// Ao rodar este modelo com rho = 0.00 e phi_pi = 0.7994 (estimado),
// o Dynare retornou o seguinte erro:
//
// "error: Blanchard & Kahn conditions are not satisfied: indeterminacy."
//
// INTERPRETAÇÃO PARA O PAPER:
// Este resultado confirma a hipótese de que a estabilidade do regime
// de metas no Brasil (determinância) depende CRITICAMENTE da inércia
// (suavização da taxa de juros).
// Sem a inércia, a resposta contemporânea estimada (phi_pi < 1) seria
// insuficiente para ancorar as expectativas, levando a múltiplos
// equilíbrios (indeterminação).
// -------------------------------------------------------------------
