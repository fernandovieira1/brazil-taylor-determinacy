%%
clear all; clc;
 
%% INSTRUCTIONS: Press F5 or type 'gali_run' on Command Window and
%% select the desired figure. 
% Tested on Matlab 2009b + Dynare 4.2.1 and Matlab 2013 + Dynare 4.3.3



galifigure.rule = menu('Select a reproducing figure:','Figure 3.1', ...
   'Figure 3.2',  'Figure 3.3', 'Figure 3.4', 'Figure 5.1',         ...
   'Figure 5.2', 'Figure 6.3', 'Figure 6.4', 'Figure 7.1', 'Exit');   

if      galifigure.rule == 1
        dynare chap3_fig31   
        gali_run     
elseif  galifigure.rule == 2
        dynare chap3_fig32
        gali_run
elseif  galifigure.rule == 3
        dynare chap3_fig33
        gali_run
elseif  galifigure.rule == 4
        dynare chap3_fig34        
        gali_run
elseif  galifigure.rule == 5
        gen_graph_chap5_fig51
        gali_run
elseif  galifigure.rule == 6
        gen_graph_chap5_fig52
        gali_run
elseif  galifigure.rule == 7
        gen_graph_chap6_fig63              
        gali_run
elseif  galifigure.rule == 8
        gen_graph_chap6_fig64       
        gali_run
elseif  galifigure.rule == 9
        gen_graph_chap7_fig71  
        gali_run
end