//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
// J. Galí (2008), Chap 6: A Model with Sticky Wages and Prices//
//                         Section 6.2                         //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                     Declaring variables                     //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

var pi_p pi_w y w W a Csi1 Csi2 Csi3;
varexo epsilon_a;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//   Setting parameters      -    See p. 52, 55, 128 and 129   //    
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

parameters alpha  sigma beta phi theta_p theta_w Psi_nya Psi_nwa 
kappa_p kappa_w lambda_p lambda_w rho phi_p phi_w phi_y rho_a rho_v 
epsilon_w epsilon_p delta_w_n rn;

beta = 0.99;
sigma = 1;
phi = 1;
alpha = 1/3;
epsilon_w = 6;
epsilon_p = 6;
rho = -log(beta);

phi_p = 1.5;
phi_w = 0;
phi_y = 0;
rho_a = 0.9;

theta_p = 2/3;
theta_w = 3/4;
Psi_nya = (1 + phi)/(sigma*(1 - alpha) + phi + alpha);
Psi_nwa = (1 - alpha*Psi_nya)/(1 - alpha);

lambda_p = ((1 - theta_p)*(1 - beta*theta_p)/theta_p)*((1 - alpha)/(1 - alpha+alpha*epsilon_p));
lambda_w = ((1 - beta*theta_w)*(1 - theta_w))/(theta_w*(1 + epsilon_w*phi));
kappa_p = lambda_p*alpha/(1 - alpha);
kappa_w = lambda_w*(sigma + phi/(1 - alpha));


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Setting up the Model                //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

model(linear);

//(15) - price inflation function
-alpha*lambda_p/(1-alpha)*y + pi_p = beta*pi_p(+1) + lambda_p*(w);

//(17) - wage inflation function
pi_w = beta*pi_w(+1) + kappa_w*y - lambda_w*(w);

//(18) - identity: wage and inflation
w = w(-1) + pi_w - pi_p - (a - a(-1));

W = W(-1) + pi_w - pi_p;

//(27) - OMP1
(sigma+(phi+alpha)/(1-alpha))*y + kappa_p*Csi1 + kappa_w*Csi2 = 0;

//(28) - OMP2
epsilon_p/lambda_p*pi_p - (Csi1 - Csi1(-1)) + Csi3 = 0;

//(29) - OMP3
epsilon_w*(1-alpha)/lambda_w*pi_w - (Csi2 - Csi2(-1)) - Csi3 = 0;

//(30) - OMP4
lambda_p*Csi1 - lambda_w*Csi2 + Csi3 - beta*Csi3(+1) = 0;

//AR(1) for a
a = rho_a*a(-1) + epsilon_a;

end;
check;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Exogenous shocks                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

shocks;
var epsilon_a = 1;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Getting the IRFs                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

stoch_simul(irf=13, noprint, nograph); //y pi_p pi_w W;
