%% here we gonna make some graphs
dbstop if error

%calling dynare
dynare chap5_1
%Saving variables since Dynare will clean memory
save('SwSp.mat', 'y_epsilon_u', 'p_hat_epsilon_u', 'pi_epsilon_u', 'u_epsilon_u');

dynare chap5_2
%saving variables
save('FwSp.mat', 'y_epsilon_u', 'p_hat_epsilon_u', 'pi_epsilon_u');

%loading previews variables
load('SwSp.mat')
y_SwSp      = y_epsilon_u;
p_hat_SwSp  = p_hat_epsilon_u;
pi_SwSp     = pi_epsilon_u;
u_SwSp      = u_epsilon_u;

load('FwSp.mat')
y_FwSp      = y_epsilon_u;
p_hat_FwSp  = p_hat_epsilon_u;
pi_FwSp     = pi_epsilon_u;

%Plotting time!
figure(1);

subplot(2,2,1); plot([0:12], y_SwSp, '-o', [0:12], y_FwSp, '-x'); title('Output Gap'); axis([0 12 -3.5 0.5]);
subplot(2,2,2); plot([0:12], pi_SwSp, '-o', [0:12], pi_FwSp, '-x'); title('Inflation'); axis([0 12 -0.29 0.6]);
subplot(2,2,3); plot([0:12], p_hat_SwSp, '-o', [0:12], p_hat_FwSp, '-x'); title('Price Level'); axis([0 12 -0.1 0.7]);
subplot(2,2,4); plot([0:12], u_SwSp); title('Cost Push Shock'); axis([0 12 -0.2 1]);

