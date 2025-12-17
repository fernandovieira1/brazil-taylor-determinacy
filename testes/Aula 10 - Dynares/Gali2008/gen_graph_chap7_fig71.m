%% here we gonna make some graphs
dbstop if error

%Calling dynare - User's choice for optimal monetary policy
dynare chap7
%saving variables
save('opt.mat', 'pi_h_epsilon_a', 'tild_y_epsilon_a', 'pi_epsilon_a', ...
    's_epsilon_a', 'e_epsilon_a', 'i_epsilon_a', 'dpl_epsilon_a', 'p_epsilon_a');

%from user's policy to DITR
%changing param in chap7
fin = fopen('chap7.mod');
fout = fopen('output.m', 'w');
%from
findstr1 = ['i           = rho  + phi_pi*pi_h + phi_y*tild_y + v;'];
findstr2 = ['//i           = rho  + phi_pi*pi_h + phi_y*tild_y;'];
findstr3 = ['phi_y       = 1.0'];
%to
replacestr1 = ['//i           = rho  + phi_pi*pi_h + phi_y*tild_y + v;'];
replacestr2 = ['i           = rho  + phi_pi*pi_h + phi_y*tild_y;'];
replacestr3 = ['phi_y       = 0.0'];
%loop to do it
while ~feof(fin)
    s = fgetl(fin);
    s = strrep(s, findstr1, replacestr1);
    s = strrep(s, findstr2, replacestr2);
    s = strrep(s, findstr3, replacestr3);
    fprintf(fout,'%s\n',s);
end
%done
fclose(fin);
fclose(fout);
%By the power of Grayskull...
movefile('output.m', 'chap7.mod');

dynare chap7
%saving variables
save('ditr.mat', 'pi_h_epsilon_a', 'tild_y_epsilon_a', 'pi_epsilon_a', ...
    's_epsilon_a', 'e_epsilon_a', 'i_epsilon_a', 'dpl_epsilon_a', 'p_epsilon_a');



%from DITR to CITR
%changing param in chap7
fin = fopen('chap7.mod');
fout = fopen('output.m', 'w');
%from
findstr1 = ['i           = rho  + phi_pi*pi_h + phi_y*tild_y;'];
findstr2 = ['//i           = rho  + phi_pi*pi + phi_y*tild_y;'];
%to
replacestr1 = ['//i           = rho  + phi_pi*pi_h + phi_y*tild_y;'];
replacestr2 = ['i           = rho  + phi_pi*pi + phi_y*tild_y;'];
%loop to do it
while ~feof(fin)
    s = fgetl(fin);
    s = strrep(s, findstr1, replacestr1);
    s = strrep(s, findstr2, replacestr2);
    fprintf(fout,'%s\n',s);
end
%done
fclose(fin);
fclose(fout);
%By the power of Grayskull...
movefile('output.m', 'chap7.mod');

dynare chap7
%saving variables
save('citr.mat', 'pi_h_epsilon_a', 'tild_y_epsilon_a', 'pi_epsilon_a', ...
    's_epsilon_a', 'e_epsilon_a', 'i_epsilon_a', 'dpl_epsilon_a', 'p_epsilon_a');
%from CITR to PEG
%changing param in chap7
fin = fopen('chap7.mod');
fout = fopen('output.m', 'w');
%from
findstr1 = ['i           = rho  + phi_pi*pi + phi_y*tild_y;'];
findstr2 = ['//e           = 0;'];
%to
replacestr1 = ['//i           = rho  + phi_pi*pi + phi_y*tild_y;'];
replacestr2 = ['e           = 0;'];
%loop to do it
while ~feof(fin)
    s = fgetl(fin);
    s = strrep(s, findstr1, replacestr1);
    s = strrep(s, findstr2, replacestr2);
    fprintf(fout,'%s\n',s);
end
%done
fclose(fin);
fclose(fout);
%By the power of Grayskull...
movefile('output.m', 'chap7.mod')

dynare chap7
%saving variables
save('peg.mat', 'pi_h_epsilon_a', 'tild_y_epsilon_a', 'pi_epsilon_a', ...
    's_epsilon_a', 'e_epsilon_a', 'i_epsilon_a', 'dpl_epsilon_a', 'p_epsilon_a');

%%from PEG to opt again
%changing param in chap7
fin = fopen('chap7.mod')
fout = fopen('output.m', 'w')
%from
findstr1 = ['e           = 0;'];
findstr2 = ['//i           = rho  + phi_pi*pi_h + phi_y*tild_y + v;'];
findstr3 = ['phi_y       = 0.0'];
%to
replacestr1 = ['//e           = 0;'];
replacestr2 = ['i           = rho  + phi_pi*pi_h + phi_y*tild_y + v;'];
replacestr3 = ['phi_y       = 1.0'];
%loop to do it
while ~feof(fin)
    s = fgetl(fin);
    s = strrep(s, findstr1, replacestr1);
    s = strrep(s, findstr2, replacestr2);
    s = strrep(s, findstr3, replacestr3);
    fprintf(fout,'%s\n',s);
end
%done
fclose(fin)
fclose(fout)
%By the power of Grayskull...
movefile('output.m', 'chap7.mod')


%Plotting pi_h tild_y pi s e i dpl p;
%loading previews variables
load('opt.mat')
pi_h_opt    = pi_h_epsilon_a;
y_opt       = tild_y_epsilon_a;
pi_opt      = pi_epsilon_a;
s_opt       = s_epsilon_a;
e_opt       = e_epsilon_a;
i_opt       = i_epsilon_a;
dpl_opt     = dpl_epsilon_a;
p_opt       = p_epsilon_a;


load('ditr.mat')
pi_h_ditr   = pi_h_epsilon_a;
y_ditr      = tild_y_epsilon_a;
pi_ditr     = pi_epsilon_a;
s_ditr      = s_epsilon_a;
e_ditr      = e_epsilon_a;
i_ditr      = i_epsilon_a;
dpl_ditr    = dpl_epsilon_a;
p_ditr      = p_epsilon_a;


load('citr.mat')
pi_h_citr   = pi_h_epsilon_a;
y_citr      = tild_y_epsilon_a;
pi_citr     = pi_epsilon_a;
s_citr      = s_epsilon_a;
e_citr      = e_epsilon_a;
i_citr      = i_epsilon_a;
dpl_citr    = dpl_epsilon_a;
p_citr      = p_epsilon_a;

load('peg.mat')
pi_h_peg    = pi_h_epsilon_a;
y_peg       = tild_y_epsilon_a;
pi_peg      = pi_epsilon_a;
s_peg       = s_epsilon_a;
e_peg       = e_epsilon_a;
i_peg       = i_epsilon_a;
dpl_peg     = dpl_epsilon_a;
p_peg       = p_epsilon_a;



%making graph

subplot(4,2,1); plot([0:20], pi_h_opt, '-',[0:20], pi_h_ditr, ':', [0:20], pi_h_citr, '-x', [0:20], pi_h_peg, '-o'); title('Domestic Inflation'); axis([0 20 -0.4 0.4]);
subplot(4,2,2); plot([0:20], y_opt, '-', [0:20], y_ditr, ':', [0:20], y_citr, '-x', [0:20], y_peg, '-o'); title('Output Gap'); axis([0 20 -1 0.5]);
subplot(4,2,3); plot([0:20], pi_opt, '-', [0:20], pi_ditr, ':', [0:20], pi_citr, '-x', [0:20], pi_peg, '-o'); title('CPI Inflation'); axis([0 20 -0.4 0.4]);
subplot(4,2,4); plot([0:20], s_opt, '-', [0:20], s_ditr, ':', [0:20], s_citr, '-x', [0:20], s_peg, '-o'); title('Terms Of Trade'); axis([0 20 0 1]);
subplot(4,2,5); plot([0:20], e_opt, '-', [0:20], e_ditr, ':', [0:20], e_citr, '-x', [0:20], e_peg, '-o'); title('Nominal Exchange Rate'); axis([0 20 -2 1]);
subplot(4,2,6); plot([0:20], i_opt, '-', [0:20], i_ditr, ':', [0:20], i_citr, '-x', [0:20], i_peg, '-o'); title('Nominal Interest Rate'); axis([0 20 -0.3 0.1]);
subplot(4,2,7); plot([0:20], dpl_opt, '-', [0:20], dpl_ditr, ':', [0:20], dpl_citr, '-x', [0:20], dpl_peg, '-o'); title('Domestic Price Level'); axis([0 20 -1.5 0.5]);
subplot(4,2,8); plot([0:20], p_opt, '-', [0:20], p_ditr, ':', [0:20], p_citr, '-x', [0:20], p_peg, '-o'); title('CPI Level'); axis([0 20 -1.5 0.5]);
legend({'OPT','DITR','CITR','PEG'}, 'Location','best');

