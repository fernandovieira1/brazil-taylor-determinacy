%% here we gonna make some graphs
dbstop if error

%calling dynare
dynare chap6_fig64
%saving variables
save('SwSp.mat', 'y_epsilon_a', 'pi_p_epsilon_a', 'pi_w_epsilon_a', 'W_epsilon_a');

%from: sticky wages and prices to: sticky wages, flex prices
%changing param in chap6
fin = fopen('chap6_fig64.mod')
fout = fopen('output.m', 'w')
%from
findstr1 = ['theta_w = 3/4;'];
%to
replacestr1 = ['theta_w = 0.0000001;'];

%loop to do it
while ~feof(fin)
    s = fgetl(fin);
    s = strrep(s, findstr1, replacestr1);
    fprintf(fout,'%s\n',s);
end
%done
fclose(fin)
fclose(fout)
%By the power of Grayskull...
movefile('output.m', 'chap6_fig64.mod')

dynare chap6_fig64
%saving variables
save('FwSp.mat', 'y_epsilon_a', 'pi_p_epsilon_a', 'pi_w_epsilon_a', 'W_epsilon_a');

%from: sticky wages, flex prices to: sticky prices, flex wages 
%changing param in chap6
fin = fopen('chap6_fig64.mod')
fout = fopen('output.m', 'w')
%from
findstr1 = ['theta_w = 0.0000001;'];
findstr2 = ['theta_p = 2/3;'];

%to
replacestr1 = ['theta_w = 3/4;'];
replacestr2 = ['theta_p = 0.0000001;'];

%loop to do it
while ~feof(fin)
    s = fgetl(fin);
    s = strrep(s, findstr1, replacestr1);
    s = strrep(s, findstr2, replacestr2);
    fprintf(fout,'%s\n',s);
end
%done
fclose(fin)
fclose(fout)
%By the power of Grayskull...
movefile('output.m', 'chap6_fig64.mod')

dynare chap6_fig64

%loading previews variables
y_SwFp = y_epsilon_a;
pi_p_SwFp = pi_p_epsilon_a;
pi_w_SwFp = pi_w_epsilon_a;
w_SwFp = W_epsilon_a;

load('FwSp.mat')
y_FwSp = y_epsilon_a;
pi_p_FwSp = pi_p_epsilon_a;
pi_w_FwSp = pi_w_epsilon_a;
w_FwSp = W_epsilon_a;

load('SwSp.mat')
y_SwSp = y_epsilon_a;
pi_p_SwSp = pi_p_epsilon_a;
pi_w_SwSp = pi_w_epsilon_a;
w_SwSp = W_epsilon_a;

%making graph
figure(1);
subplot(2,2,1); plot([0:12], y_SwSp, '-', [0:12], y_FwSp, '-.', [0:12], y_SwFp, '--'); title('Output Gap'); axis([0 12 -0.005 0.02]);
subplot(2,2,2); plot([0:12], 4*pi_p_SwSp, '-', [0:12], 4*pi_p_FwSp, '-.', [0:12], 4*pi_p_SwFp, '--'); title('Price Inflation'); axis([0 12 -4 1]);
subplot(2,2,3); plot([0:12], 4*pi_w_SwSp, '-', [0:12], 4*pi_w_FwSp, '-.', [0:12], 4*pi_w_SwFp, '--'); title('Wage Inflation'); axis([0 12 -1 4]);
subplot(2,2,4); plot([0:12],w_SwSp, '-');hold all;plot([0:12],w_FwSp, '-.');plot([0:12],w_SwFp, '--');hold off; title('Real Wage'); axis([0 12 0 1]);

%from: sticky prices, flex wages to: sticky pries and wages
%changing param in chap6
fin = fopen('chap6_fig64.mod')
fout = fopen('output.m', 'w')
%from
findstr2 = ['theta_p = 0.0000001;'];

%to
replacestr2 = ['theta_p = 2/3;'];

%loop to do it
while ~feof(fin)
    s = fgetl(fin);
    s = strrep(s, findstr2, replacestr2);
    fprintf(fout,'%s\n',s);
end
%done
fclose(fin)
fclose(fout)
%dont let my children see this, hundred lines of worst code ever
movefile('output.m', 'chap6_fig64.mod')