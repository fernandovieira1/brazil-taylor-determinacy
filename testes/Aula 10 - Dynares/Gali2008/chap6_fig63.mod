//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
// J. Galí (2008), Chap 6: A Model with Sticky Wages and Prices//
//                         Section 6.2                         //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                     Declaring variables                     //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

var tild_y n y_n i v a pi_p pi_w rn tild_w w wn Y ;
varexo epsilon_v epsilon_a;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//   Setting parameters      -    See p. 52, 55, 128 and 129   //    
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

parameters alpha  sigma beta phi theta_p theta_w Psi_nya Psi_nwa 
kappa_p kappa_w lambda_p lambda_w rho phi_p phi_w phi_y rho_a rho_v 
epsilon_w epsilon_p;

beta = 0.99;
sigma = 1;
phi = 1;
alpha = 1/3;
epsilon_w = 6;
epsilon_p = 6;
rho = 1/(beta-1);

phi_p = 1.5;
phi_w = 0;
phi_y = 0;
rho_a = 0.9;


theta_p = 2/3;
theta_w = 3/4;
Psi_nya = (1 + phi)/(sigma*(1 - alpha) + phi + alpha);
Psi_nwa = (1 - alpha*Psi_nya)/(1 - alpha);
rho_v = 0.5;


lambda_p = ((1 - theta_p)*(1 - beta*theta_p)/theta_p)*((1 - alpha)/(1 - alpha+alpha*epsilon_p));
lambda_w = ((1 - beta*theta_w)*(1 - theta_w))/(theta_w*(1 + epsilon_w*phi));
kappa_p = lambda_p*alpha/(1 - alpha);
kappa_w = lambda_w*(sigma + phi/(1 - alpha));



//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Setting up the Model                //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

model(linear);
tild_w = w-wn;
wn = Psi_nwa*a;
pi_p = beta*pi_p(+1) + kappa_p*tild_y + lambda_p*(tild_w);
pi_w = beta*pi_w(+1) + kappa_w*tild_y - lambda_w*(tild_w);
w = w(-1) + pi_w - pi_p;

tild_y = Y - y_n;
y_n = Psi_nya*a;
Y = a + (1-alpha)*n;
rn = sigma*Psi_nya*(rho_a - 1)*a;

tild_y = tild_y(+1) - (1/sigma)*(i - pi_p(+1) - rn);
i = rho + phi_p*pi_p + phi_w*pi_w + phi_y*tild_y + v;

v = rho_v*v(-1) + epsilon_v;
a = rho_a*a(-1) + epsilon_a;
end;

check;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Exogenous shocks                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

shocks;
var epsilon_v = 0.0625;
var epsilon_a = 0;
end;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Getting the IRFs                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

stoch_simul(irf=13, nograph, noprint);
