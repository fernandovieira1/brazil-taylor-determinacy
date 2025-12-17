function plot_nk_dmp(shock)

% Usage:
%   dynare nk_env_dmp
%   plot_envnk_irfs              % va, vg, vm
%   plot_envnk_irfs('vg')        % vg, va, vm

if nargin < 1, shock = 'va'; end
assert(evalin('base','exist(''oo_'',''var'')==1'), 'Run dynare nk_env_dmp first.');

base = {'va','vg','vm'};
idx  = find(strcmp(shock, base), 1);
if isempty(idx), shocks = [{shock}, base];
else, shocks = [{base{idx}}, base([1:idx-1, idx+1:end])];
end

titles = struct('va','Shock: Technology', ...
                'vg','Shock: Govt Spending',  ...
                'vm','Shock: Monetary Policy');

close all;
for f = 1:numel(shocks)
    s = shocks{f};
    if isfield(titles,s), ttl = titles.(s); else, ttl = ['Shock: ' upper(s)]; end
    make_figure_for_shock(s, f, ttl);
end
end

% ------------------------- helpers -------------------------
function make_figure_for_shock(shock, fignum, figtitle)
irf = @(v) get_irf(v, shock);

% Core series
y_    = irf('ylog');
c_    = irf('clog');
i_    = irf('ilog');
n_    = irf('nlog');
u_    = irf('u');
theta_= irf('thetalog');
w_    = irf('wlog');
pi_   = irf('pi');
r_    = irf('r');
rr_   = irf('rr');
ver_  = irf('verify');

% Time axis
N = max(cellfun(@numel, {y_,c_,i_,n_,u_,theta_,w_,pi_,r_,rr_}));
if isempty(N) || N==0
    warning('No IRFs found for shock %s.', shock); return;
end
T = 0:(N-1);

figure(fignum); clf; set(gcf,'Color','w'); sgtitle(figtitle);

subplot(3,3,1); plot(T,y_,'LineWidth',1.4); hold on; yline(0,'k--'); title('Output (log)'); xlabel('quarters'); grid on;
subplot(3,3,2); plot(T,c_,'LineWidth',1.4); hold on; yline(0,'k--'); title('Consumption (log)'); xlabel('quarters'); grid on;
subplot(3,3,3); plot(T,i_,'LineWidth',1.4); hold on; yline(0,'k--'); title('Investment (log)'); xlabel('quarters'); grid on;

subplot(3,3,4); plot(T,n_,'LineWidth',1.4); hold on; yline(0,'k--'); title('Employment (log)'); xlabel('quarters'); grid on;
subplot(3,3,5); plot(T,u_,'LineWidth',1.4); hold on; yline(0,'k--'); title('Unemployment'); xlabel('quarters'); grid on;
subplot(3,3,6); plot(T,theta_,'LineWidth',1.4); hold on; yline(0,'k--'); title('Tightness (log)'); xlabel('quarters'); grid on;

subplot(3,3,7); plot(T,w_,'LineWidth',1.4); hold on; yline(0,'k--'); title('Real Wage (log)'); xlabel('quarters'); grid on;
subplot(3,3,8); plot(T,pi_,'LineWidth',1.4); hold on; yline(0,'k--'); title('Inflation'); xlabel('quarters'); grid on;

subplot(3,3,9);
plot(T,r_,'-', 'LineWidth',1.2); hold on;
plot(T,rr_,'--','LineWidth',1.2); yline(0,'k--');
title('Rates: nominal (—) & real (--)'); xlabel('quarters'); grid on;
legend({'r','rr'},'Location','best');

if ~isempty(ver_) && any(abs(ver_)>1e-10)
    fprintf('Warning: verify equation deviation (max abs) = %.3e\n', max(abs(ver_)));
end
end

function v = get_irf(name, shock)
fld = [name '_' shock];
v = [];
if evalin('base','exist(''oo_'',''var'')')
    S = evalin('base','oo_.irfs');
    if isfield(S, fld), v = S.(fld); end
end
if isempty(v)
    if evalin('base', sprintf('exist(''%s'',''var'')', fld))
        v = evalin('base', fld);
    end
end
if ~isempty(v), v = v(:); end
end
