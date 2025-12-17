//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
// J. Galí (2008), Chap 3: The Basic New Keynesian Model//
//       Section 3.4.2.2 - A Technology Shock           //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                Declaring variables                   //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

var pi y a m dm n l Y i;
varexo epsilon_a epsilon_m;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//     Setting parameters     -    See p. 52 and 55     //    
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

parameters beta sigma phi alpha epsilon  eta theta phi_pi phi_y up_theta
Psi_nya lambda kappa rho rho_v rho_a rho_m lambda_a mu V_ny;

beta = 0.99;
sigma = 1;
phi = 1;
alpha = 1/3;
epsilon = 6;
eta = 4;
theta = 2/3;
phi_pi = 1.5;
phi_y = .5/4;
mu = 1.2;
up_theta = (1-alpha)*inv(1-alpha+alpha*epsilon);
lambda = (1-theta)*(1-beta*theta)*up_theta/theta;
Psi_nya = (1+phi)*inv(sigma*(1-alpha)+phi+alpha);
kappa = lambda*(sigma+(phi+alpha)*inv(1-alpha));
rho = -log(beta);
rho_v = 0.5;
rho_a = 0.9;
rho_m = 0.5;
lambda_a = ((1-beta*rho_a)*(sigma*(1-rho_a)+phi_y)+kappa*(phi_pi-rho_a))^(-1);
V_ny = (1-alpha)*(mu - log(1-alpha))/(sigma*(1-alpha)+phi+alpha);


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Setting up the Model                //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

model(linear);
pi              = beta*pi(+1)+kappa*y;                                     // (21) NKPC - p. 49

(1+sigma*eta)*y = sigma*eta*y(+1) + l + eta*pi(+1) - 
                eta*sigma*Psi_nya*(1-rho_a)*a - Psi_nya*a - V_ny;          // (30) DIS Equation using (19), (23) and (28)

a               = rho_a*a(-1) + epsilon_a;                                 // AR(1) process for {a_t} - p. 54 - (28)

dm              = rho_m*dm(-1) + epsilon_m;                                // (33) AR(1) process for {m} - p.57
dm              = m + m(-1);

l(-1)           = l + pi - dm;                                             // (31) Real balances relation with inflation and money growth

y - eta*i       = l - Psi_nya*a - V_ny;                                    // (29) money market equilibrium
 
Y               = l + eta*i;                                               // An identity to pin down the Output from the money market equilibrium. Just rewrite (29) in terms of the definition of output level. 

(1-alpha)*n     = Y-a;                                                     // Employment - p. 54 

end;


check;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Exogenous shocks                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

shocks;
var epsilon_m = 0.25;
var epsilon_a = 1;
end;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Getting the IRFs                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

stoch_simul(irf=13, noprint, nograph);


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                      Figure 3.3                      //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

figure(1); 
clf;
subplot(4,2,1); plot([0:12], y_epsilon_a, '-o'); title('Output Gap'); axis([0 12 -1 1]);
subplot(4,2,2); plot([0:12], 4*pi_epsilon_a, '-o'); title('Inflation'); axis([0 12 -1 1]);
subplot(4,2,3); plot([0:12],Y_epsilon_a, '-o'); title('Output'); axis([0 12 0 1]);
subplot(4,2,4); plot([0:12],n_epsilon_a, '-o'); title('Employment'); axis([0 12 -2 2]);
subplot(4,2,5); plot([0:12],i_epsilon_a, '-o'); title('Nominal Rate'); axis([0 12 0.00000000000000005 0.0000000000000006]); 
subplot(4,2,6); plot(4*i_epsilon_a(1:end-1)-4*[-pi_epsilon_m(2:end)], '-o'); title('Real Rate'); axis([0 12 -1 1]);
subplot(4,2,7); plot([0:12],4*(m_epsilon_a-[0;m_epsilon_a(1:end-1)]), '-o'); title('Money Growth'); axis([0 12 -1 1]);
subplot(4,2,8); plot([0:12],a_epsilon_a, '-o'); title('a'); axis([0 12 0 1]);

