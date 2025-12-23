%% here we gonna make some graphs
dbstop if error

%calling dynare
dynare chap6_fig63
%saving variables
save('SwSp.mat', 'tild_y_epsilon_v', 'pi_p_epsilon_v', 'pi_w_epsilon_v', 'tild_w_epsilon_v');

%from: sticky wages and prices to: sticky wages, flex prices
%changing param in chap6
fin = fopen('chap6_fig63.mod')
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
movefile('output.m', 'chap6_fig63.mod')

dynare chap6_fig63
%saving variables
save('FwSp.mat', 'tild_y_epsilon_v', 'pi_p_epsilon_v', 'pi_w_epsilon_v', 'tild_w_epsilon_v');

%from: sticky wages, flex prices to: sticky prices, flex wages 
%changing param in chap6
fin = fopen('chap6_fig63.mod')
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
movefile('output.m', 'chap6_fig63.mod')

dynare chap6_fig63

%loading previews variables
y_SwFp = tild_y_epsilon_v;
pi_p_SwFp = pi_p_epsilon_v;
pi_w_SwFp = pi_w_epsilon_v;
w_SwFp = tild_w_epsilon_v;

load('FwSp.mat')
y_FwSp = tild_y_epsilon_v;
pi_p_FwSp = pi_p_epsilon_v;
pi_w_FwSp = pi_w_epsilon_v;
w_FwSp = tild_w_epsilon_v;

load('SwSp.mat')
y_SwSp = tild_y_epsilon_v;
pi_p_SwSp = pi_p_epsilon_v;
pi_w_SwSp = pi_w_epsilon_v;
w_SwSp = tild_w_epsilon_v;

%making graph
figure(1);
subplot(2,2,1); plot([0:12], y_SwSp, '-', [0:12], y_FwSp, '-.', [0:12], y_SwFp, '--'); title('Output Gap'); axis([0 12 -0.5 0.2]);
subplot(2,2,2); plot([0:12], 4*pi_p_SwSp, '-', [0:12], 4*pi_p_FwSp, '-.', [0:12], 4*pi_p_SwFp, '--'); title('Price Inflation'); axis([0 12 -0.8 0.2]);
subplot(2,2,3); plot([0:12], 4*pi_w_SwSp, '-', [0:12], 4*pi_w_FwSp, '-.', [0:12], 4*pi_w_SwFp, '--'); title('Wage Inflation'); axis([0 12 -4 2]);
subplot(2,2,4); plot([0:12],w_SwSp, '-');hold all;plot([0:12],w_FwSp, '-.');plot([0:12],w_SwFp, '--');hold off; title('Real Wage'); axis([0 12 -0.8 0.2]);

%from: sticky prices, flex wages to: sticky pries and wages
%changing param in chap6
fin = fopen('chap6_fig63.mod')
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
movefile('output.m', 'chap6_fig63.mod')