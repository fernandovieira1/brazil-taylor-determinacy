function plot_tank_irfs(shock)
% Usage:
%   dynare tank_model
%   plot_tank_irfs            % va, vg, vm
%   plot_tank_irfs('vg')      % vg, va, vm

if nargin < 1, shock = 'va'; end
assert(evalin('base','exist(''oo_'',''var'')==1'), 'Run dynare tank_model first.');

% Desired order: requested first, then vg and vm (no duplicates)
base = {'va','vg','vm'};
idx = find(strcmp(shock, base), 1);
if isempty(idx)
    shocks = [{shock}, base];
else
    shocks = [{base{idx}}, base([1:idx-1, idx+1:end])];
end

titles = struct('va','Shock: Technology', ...
                'vg','Shock: Govt Spending)',   ...
                'vm','Shock: Monetary Policy');

close all;
for f = 1:numel(shocks)
    s = shocks{f};
    if isfield(titles, s), ttl = titles.(s); else, ttl = ['Shock: ' upper(s)]; end
    make_figure_for_shock(s, f, ttl);
end
end

% ------------------------- helpers -------------------------
function make_figure_for_shock(shock, fignum, figtitle)
irf = @(v) get_irf(v, shock);

% Agent-specific (logs)
c_opt = irf('c_o_log');   c_rot = irf('c_r_log');
h_opt = irf('h_o_log');   h_rot = irf('h_r_log');

% Aggregates
y_    = irf('y');
pi_   = irf('pi');
r_    = irf('r');
rr_   = irf('rr');                % real rate (exact from .mod)
ilog_ = irf('ilog');              % investment (log)
w_    = irf('wlog');              % optional
q_    = irf('q');                 % optional

% Fallback for rr if missing (shouldn't be, since rr is in stoch_simul)
if isempty(rr_) && ~isempty(r_) && ~isempty(pi_), rr_ = r_ - pi_; end

% Time axis
N = max([numel(y_), numel(c_opt), numel(c_rot), numel(ilog_), numel(rr_)]);
if isempty(N) || N==0
    warning('No IRFs found for shock %s.', shock); 
    return;
end
T = 0:(N-1);

figure(fignum); clf; set(gcf,'Color','w');
sgtitle(figtitle);

% 1) Consumption: OPT vs ROT
subplot(2,4,1);
plot(T, c_opt, '-', T, c_rot, ':', 'LineWidth', 1.4); hold on; yline(0,'k--');
title('Consumption (log)'); xlabel('quarters');
legend({'OPT','ROT'}, 'Location','best'); grid on; hold off;

% 2) Hours: OPT vs ROT
subplot(2,4,2);
plot(T, h_opt, '-', T, h_rot, ':', 'LineWidth', 1.4); hold on; yline(0,'k--');
title('Hours (log)'); xlabel('quarters');
legend({'OPT','ROT'}, 'Location','best'); grid on; hold off;

% 3) Output
subplot(2,4,3);
plot(T, y_, 'LineWidth', 1.4); hold on; yline(0,'k--');
title('Output'); xlabel('quarters'); grid on; hold off;

% 4) Inflation
subplot(2,4,4);
plot(T, pi_, 'LineWidth', 1.4); hold on; yline(0,'k--');
title('Inflation'); xlabel('quarters'); grid on; hold off;

% 5) Nominal rate
subplot(2,4,5);
plot(T, r_, 'LineWidth', 1.4); hold on; yline(0,'k--');
title('Nominal Interest Rate'); xlabel('quarters'); grid on; hold off;

% 6) Real rate
subplot(2,4,6);
plot(T, rr_, 'LineWidth', 1.4); hold on; yline(0,'k--');
title('Real Interest Rate'); xlabel('quarters'); grid on; hold off;

% 7) Investment (log)
subplot(2,4,7);
plot(T, ilog_, 'LineWidth', 1.4); hold on; yline(0,'k--');
title('Investment (log)'); xlabel('quarters'); grid on; hold off;

% 8) q or real wage (log)
subplot(2,4,8);
if ~isempty(q_)
    plot(T, q_, 'LineWidth', 1.4); ttl = 'Tobin''s q';
elseif ~isempty(w_)
    plot(T, w_, 'LineWidth', 1.4); ttl = 'Real Wage (log)';
else
    plot(T, zeros(size(T)), 'LineWidth', 1.4); ttl = '—';
end
hold on; yline(0,'k--'); title(ttl); xlabel('quarters'); grid on; hold off;
end

function v = get_irf(name, shock)
fld = [name '_' shock];
v = [];
if evalin('base','exist(''oo_'',''var'')')
    S = evalin('base','oo_.irfs');
    if isfield(S, fld), v = S.(fld); end
end
% Dynare 4.x sometimes also exports base vars with the same name
if isempty(v)
    if evalin('base', sprintf('exist(''%s'',''var'')', fld))
        v = evalin('base', fld);
    end
end
if ~isempty(v), v = v(:); end
end
