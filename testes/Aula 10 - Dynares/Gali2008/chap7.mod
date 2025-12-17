//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//  J. Galí (2008), Chap 7: Monetary Police and Open Economy   //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                     Declaring variables                     //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

var pi_h tild_y y y_n a i r_n v y_star pi_star s e p pi dpl;
varexo epsilon_y epsilon_a epsilon_v;

parameters 
    sigma_alpha alpha rho beta kappa_alpha omega phi_pi rho_y phi_y Theta 
    rho_a mu ni Gamma_0 phi Gamma_a Gamma_star sigma eta gamm rho_v;

    beta        = 0.99;
    rho         = 1/(beta-1);
    kappa_alpha = 0.3433;                    
    sigma_alpha = 1;   
    alpha       = 0.4;
    mu          = 1.2;
    ni          = mu + log(1-alpha);
    phi         = 3;
    sigma       = 1;
    gamm        = 1;
    eta         = 1;
    Theta       = (sigma*gamm - 1) + (1-alpha)*(sigma*eta-1); 
    Gamma_0     = (ni-mu)/(sigma_alpha + phi);
    Gamma_a     = (1+phi)/(sigma_alpha+phi);
    Gamma_star  = -((alpha*Theta*sigma_alpha)/(sigma_alpha+phi));
    phi_pi      = 1.5;
    phi_y       = 1.0;                                                     // Warning: changing this value requires change the values at lines 17 and 109 in gen_graph7_fig71.m
    rho_v       = 0.5;
    rho_a       = 0.86;                                                                
    rho_y       = 0.66    
;  

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Setting up the Model                //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

model(linear);
    tild_y      = y-y_n;                                                   // Output gap definition - p. 49
    y           = y_star + sigma_alpha^(-1)*s;                             // SOE output - eq (29) - p. 161
    y_n         = Gamma_0 + Gamma_a*a + Gamma_star*y_star;                 // Natural level of output in open economy - eq. (36) - p. 164
    pi_h        = beta*pi_h(+1) + kappa_alpha*tild_y;                      // Home-NPKC - eq. (37) - p.164
    tild_y      = tild_y(+1) - (1/sigma_alpha)*(i - pi_h(+1)- r_n);        // Home-DIS - eq. (38) - p.165      
    r_n         = rho - sigma_alpha*Gamma_a*(1-rho_a)*a +                           
                   ((alpha*Theta*sigma_alpha*phi)/(sigma_alpha+phi))*
                  (rho_y-1)*y_star;                                        // Natural interest rate -  eq. (39) - p.165      
    
    s-s(-1)     = e-e(-1)+ pi_star - pi_h;                                 // First difference of eq. (16), p. 156, using the fact that pi_star = 0
    pi_star     = 0;                                                       // Implied by the SOE assumption
    pi          = pi_h + alpha*(s-s(-1));                                  // Home CPI inflation - eq (15) - p. 155
    pi          = p - p(-1);
    dpl         = dpl(-1) + pi_h;      
    i           = rho  + phi_pi*pi_h + phi_y*tild_y + v;                   // Some optimal policy based on user's choices for phi_pi and phi_y
    //i           = rho  + phi_pi*pi_h + phi_y*tild_y;                       // DITR Policy rule
    //i           = rho  + phi_pi*pi + phi_y*tild_y;                         // CITR Policy rule
    //e           = 0;                                                     // PEG
    y_star      = rho_y*y_star(-1) + epsilon_y;                            // Non-policy / exgogenous block
    a           = rho_a*a(-1) + epsilon_a;
    v           = rho_v*v(-1) + epsilon_v;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//     Initial guesses for steady-state computation     //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

initval;
    y_n     = Gamma_0;
    y       = Gamma_0;
    tild_y  = 0;
    pi_h    = 0;
    pi      = 0;
    pi_star = 0;    
    e       = 0;
    i       = rho;
    r_n     = rho;
    s       = sigma_alpha*Gamma_0;
    y_star  = 0;
    a       = 0;
    p       = 1;   
    dpl     = 0;
end;

//check;
    

shocks;
    var epsilon_v = 1;
    var epsilon_a; stderr 1;                                               //SD of productivity shock
    var epsilon_y; stderr 2;                                               //SD of world output shock
    var epsilon_a, epsilon_y = 0.3*0.0071*0.0078;
end;

stoch_simul(irf = 21, nograph,  noprint);// pi_h tild_y pi s e i dpl p;
