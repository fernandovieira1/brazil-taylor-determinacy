//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
// J. Galí (2008), Chap 3: The Basic New Keynesian Model//
//                  Section 3.4.2                       //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                Declaring variables                   //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

var pi y m l i;
varexo epsilon_m;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//     Setting parameters     -    See p. 52 and 55     //    
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

parameters beta sigma phi alpha epsilon  eta theta phi_pi phi_y up_theta
Psi_nya lambda kappa rho rho_v rho_a rho_m lambda_a y_n hat_r_n;

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
rho = -log(beta);
rho_v = 0.5;
rho_a = 0.9;
rho_m = 0.5;
lambda_a = 1*inv((1-beta*rho_a)*(sigma*(1-rho_a)+phi_y)+kappa*(phi_pi-rho_a));
//SS values
y_n = 0;
hat_r_n = 0;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Setting up the Model                //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

model(linear);

//(21) NKPC - p. 49
pi = beta*pi(+1)+kappa*y;

//(30) Dynamic IS Equation - p. 49 - changed p.56
(1+sigma*eta)*y = sigma*eta*y(+1) + l + eta*pi(+1) + eta*hat_r_n - y_n; 

//(31) Real balances relation with inflation and money growth
l(-1) = l + pi -m + m(-1);

//(33) AR(1) process for {m} - p.57
m = m(-1) + rho_m*(m(-1)-m(-2)) + epsilon_m;

//(29) money market equilibrium
y - eta*i = l - y_n;

end;
check;

//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Exogenous shocks                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

shocks;
var epsilon_m = 0.0625;
end;


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                  Getting the IRFs                    //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

stoch_simul(irf=15, nograph, noprint);


//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//
//                      Figure 3.3                      //
//%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%//

figure(1); 
clf;
subplot(3,2,1); plot(y_epsilon_m, '-o'); title('Output Gap');
subplot(3,2,2); plot(4*pi_epsilon_m, '-o'); title('Inflation');
subplot(3,2,3); plot(4*i_epsilon_m, '-o'); title('Nominal Rate');
subplot(3,2,4); plot(4*i_epsilon_m(1:end-1)-4*[pi_epsilon_m(2:end)], '-o'); title('Real Rate');
subplot(3,2,5); plot(l_epsilon_m, '-o'); title('Real Balances');
subplot(3,2,6); plot(4*(m_epsilon_m-[0;m_epsilon_m(1:end-1)]), '-o'); title('Money Growth');

