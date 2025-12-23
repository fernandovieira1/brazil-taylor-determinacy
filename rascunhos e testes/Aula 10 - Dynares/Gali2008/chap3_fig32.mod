//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
// J. Galí (2008), Chap 3: The Basic New Keynesian Model//
//                  Section 3.4.1                       //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                Declaring variables                   //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

var pi y r_n i v a Y m n;
varexo epsilon_v epsilon_a;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//     Setting parameters     -    See p. 52 and 55     //    
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

parameters beta sigma phi alpha epsilon  eta theta phi_pi phi_y up_theta
Psi_nya lambda kappa rho rho_v rho_a lambda_v lambda_a;

beta = 0.99;
sigma = 1;
phi = 1;
alpha = 1/3;
epsilon = 6;
eta = 4;
theta = 2/3;
phi_pi = 1.5;
phi_y = .5/4;
up_theta = (1-alpha)*inv(1-alpha+alpha*epsilon);
lambda = (1-theta)*(1-beta*theta)*up_theta/theta;
Psi_nya = (1+phi)*inv(sigma*(1-alpha)+phi+alpha);
kappa = lambda*(sigma+(phi+alpha)*inv(1-alpha));
rho = 1/beta-1;
rho_v = 0.5;
rho_a = 0.9;
lambda_v = 1*inv((1-beta*rho_v)*(sigma*(1-rho_v)+phi_y)+kappa*(phi_pi-rho_v));
lambda_a = 1*inv((1-beta*rho_a)*(sigma*(1-rho_a)+phi_y)+kappa*(phi_pi-rho_a));

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Setting up the Model                //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

model(linear);

// NKPC - p. 49 - (21)
pi = beta*pi(+1)+kappa*y;

// Dynamic IS Equation - p. 49 - (22)
y = y(+1)-(1/sigma)*(i-pi(+1)-r_n); 

// Natural rate of interest - p. 49 - (23)
r_n = rho + sigma*Psi_nya*(a(+1)-a); 

// Interest Rate Rule - p. 50 - (25)
i = rho + phi_pi*pi + phi_y*y + v;

// AR(1) exogenous component of i - p. 50 -  section 3.4.1.1
v = rho_v*v(-1) + epsilon_v; 

// AR(1) process for {a_t} - p. 54 - (28)
a = rho_a*a(-1) + epsilon_a; 

//Output - p. 54
Y = Psi_nya*(1-sigma*(1-rho_a)*(1-beta*rho_a)*lambda_a)*a; 

// Employment - p. 54
n = (((Psi_nya-1)-sigma*Psi_nya*(1-rho_a)*(1-beta*rho_a)*lambda_a)*a/(1-alpha)); 

//Ad hoc Money Demand
m = y-eta*i; 


end;


check;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Exogenous shocks                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

shocks;
var epsilon_v = 0.0625;
var epsilon_a = 1;
end;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Getting the IRFs                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

stoch_simul(irf=15, nograph, noprint);

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                      Figure 3.1                      //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

figure(1); 
clf;
subplot(4,2,1); plot(y_epsilon_a, '-o'); title('Output Gap');
subplot(4,2,2); plot(4*pi_epsilon_a, '-o'); title('Inflation');
subplot(4,2,3); plot(Y_epsilon_a, '-o'); title('Output');
subplot(4,2,4); plot(n_epsilon_a, '-o'); title('Employment');
subplot(4,2,5); plot(4*i_epsilon_a, '-o'); title('Nominal Rate');
subplot(4,2,6); plot(4*r_n_epsilon_a, '-o'); title('Real Rate');
subplot(4,2,7); plot(4*(m_epsilon_a-[0;m_epsilon_a(1:end-1)]), '-o'); title('Money Growth');
subplot(4,2,8); plot(a_epsilon_a, '-o'); title('a'); axis([0 12 0 1.1]);

