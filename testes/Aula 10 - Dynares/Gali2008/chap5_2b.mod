//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
// J. Galí (2008), Chap 5: Monetary Policy Tradeoffs    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                Declaring variables                   //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

var y u p_hat pi;                                 
// Note: we used y instead of x to denote the output gap//

varexo epsilon_u;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//Setting parameters - See chap3.mod and Galí's chap. 5 //    
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

parameters beta sigma phi alpha epsilon  eta theta  phi_y up_theta
lambda kappa rho rho_u rho_a  phi_p alpha_x delta del a;

alpha_x=0.0200;
beta = 0.99;
sigma = 1;
phi = 1;
alpha = 1/3;
epsilon = 6;
eta = 4;
theta = 2/3;
phi_y = .5/4;
up_theta = (1-alpha)*inv(1-alpha+alpha*epsilon);
lambda = (1-theta)*(1-beta*theta)*up_theta/theta;
kappa = lambda*(sigma+(phi+alpha)*inv(1-alpha));
rho = 1/beta-1;
rho_u = 0.8;
rho_a = 0.9;
phi_p=(1-rho_u)*((kappa*sigma)/(alpha_x))+rho_u;
a=alpha_x/(alpha_x*(1+beta)+kappa^2);
delta=(1-sqrt(1-4*beta*a^2))/(2*a*beta);
del= delta/(1-beta*delta*rho_u);

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Setting up the Model                //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

model(linear);

// NKPC - p. 97 - (2)
//pi = beta*pi(+1)+kappa*y + u;

// Dynamic IS Equation - p. 97 - (4)
y = y(+1)-(1/sigma)*(-(p_hat(+1)-p_hat)+phi_p*p_hat + 
((1-delta)*(1-(sigma*kappa)/alpha_x)*rho_u*((delta/(1-delta))*u)));

// AR(1) exogenous component of i - p. 97 -  (3)
u = rho_u*u(-1) + epsilon_u; 

// Price equation - pag 104 - (15)
p_hat - p_hat(-1) = beta*(p_hat(+1)-p_hat) + kappa*y + u ;

// NKPC - p. 97 - (2)
pi = beta*pi(+1)+kappa*y + u;
end;
check;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Exogenous shocks                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

shocks;
var epsilon_u = 1;
end;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Getting the IRFs                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

stoch_simul(irf=13, noprint, nograph) y, pi, p_hat,u ;



