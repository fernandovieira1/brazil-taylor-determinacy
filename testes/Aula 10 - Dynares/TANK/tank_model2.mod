% -------------------------------------------------------------------------
% TANK model (Two-Agent New Keynesian) 
% Calibration from Gali et al. (JEEA, 2007).
% -------------------------------------------------------------------------

% ----------------------- Endogenous variables ----------------------------
var
    c rk rr w h y k q i lambda r pi mc g a
    c_r c_o h_r h_o t_r t_o d
    clog wlog hlog klog ilog c_r_log c_o_log h_r_log h_o_log
;

% ----------------------- Exogenous shocks --------------------------------
varexo
    va   % technology
    vg   % government spending
    vm   % monetary policy
;

% ----------------------- Parameters --------------------------------------
parameters
    beta alpha delta sigma phi epsilon eta
    gss ass piss rss phi_I phi_P phipi phiy
    rhoa rhog rhom phig phid t_oss t_rss dss
    kappaL calvo
;

% === Structural parameters (quarterly) ===
beta   = 0.99;       % discount factor
alpha  = 1/3;        % capital share
epsilon= 6;          % elasticity of substitution
delta  = 0.025;      % depreciation
sigma  = 1;          % CRRA
phi    = 0.5;        % inverse Frisch elasticity
eta    = 0.5;        % fraction of ROT households
gss    = 0.2;        % government share in steady state output
piss   = 1;          % inflation target (steady state)
rss    = 1/beta;     % nominal rate in steady state (pi*rr)
calvo  = 0.75;       % Calvo price stickiness

% === Investment adj. cost & policy rule ===
phi_I  = 2.48;       % investment adjustment cost
phipi  = 1.5;        % Taylor rule response to inflation
phiy   = 0.0;        % Taylor rule response to output
rhoa   = 0.9;        % TFP persistence
rhog   = 0.9;        % G persistence
rhom   = 0.0;        % interest-rate smoothing
phig   = 0.1;        % taxes react to g
phid   = 0.33;       % taxes react to debt

% === Price adj. cost similar to the Calvo Phillips curve ===
phi_P = (epsilon-1)*calvo/(piss^2*(1-calvo)*(1-beta*calvo));

% === Derived steady-state objects used as parameters ===
ass    = 1 / ( (alpha*((epsilon-1)/epsilon)/(1/beta-(1-delta)))^alpha * (1/3)^(1-alpha) );
kappaL = ((1-alpha)*((epsilon-1)/epsilon)/(1/3)) / ( (1/3)^phi * (1 - delta*(alpha*((epsilon-1)/epsilon)/(1/beta-(1-delta))) - gss)^sigma );
t_rss  = (1-alpha)*((epsilon-1)/epsilon) - (1 - delta*(alpha*((epsilon-1)/epsilon)/(1/beta-(1-delta))) - gss);
dss    = 4;
t_oss  = ( gss + (1/beta - 1)*dss - eta*t_rss )/(1 - eta);

% ----------------------- Nonlinear model ---------------------------------
model;
    % Households
    lambda = c_o^(-sigma);
    1 = beta*(lambda(1)/lambda)*r/pi(1);
    1 = beta*(lambda(1)/lambda)*( rk(1) + (1-delta)*q(1) )/q;
    kappaL*h_o^phi = w*lambda;
    kappaL*h_r^phi = w*c_r^(-sigma);
    k = (1-delta)*k(-1) + (1 - (phi_I/2)*(i/i(-1)-1)^2)*i;
    1 = q*( 1 - (phi_I/2)*(i/i(-1)-1)^2 - phi_I*(i/i(-1)-1)*i/i(-1) ) + phi_I*beta*(lambda(1)/lambda)*q(1)*(i(1)/i - 1)*(i(1)/i)^2;

    % Firms
    y  = a*k(-1)^alpha*h^(1-alpha);
    (1-alpha)*mc*y = w*h;
    alpha*mc*y     = rk*k(-1);
    (pi - steady_state(pi))*pi = beta*(lambda(1)/lambda)*(y(1)/y)*pi(1)*(pi(1)-steady_state(pi)) + (epsilon/phi_P)*(mc - (epsilon-1)/epsilon);

    % Aggregation & market clearing
    y = c + i + g + (phi_P/2)*(pi - piss)^2*y;
    c = (1-eta)*c_o + eta*c_r;
    h = (1-eta)*h_o + eta*h_r;
    c_r = w*h_r - t_r;

    % Policy and fiscal
    r/rss = ( (pi/steady_state(pi))^phipi * (y)^phiy )^(1-rhom) * (r(-1)/rss)^rhom * exp(vm);
    t_r - t_rss = phig*(g - gss) + phid*(d(-1) - dss);
    t_o - t_oss = phig*(g - gss) + phid*(d(-1) - dss);
    g + (r(-1)/pi)*d(-1) = (1-eta)*t_o + eta*t_r + d;

    % Shocks
    log(a) = (1-rhoa)*log(ass) + rhoa*log(a(-1)) + va;
    g      = (1-rhog)*gss + rhog*g(-1) + vg;

    % Aux variables (include rr explicitly)
    rr       = r/pi(1);
    clog     = log(c);
    wlog     = log(w);
    hlog     = log(h);
    klog     = log(k);
    ilog     = log(i);
    c_r_log  = log(c_r);
    c_o_log  = log(c_o);
    h_r_log  = log(h_r);
    h_o_log  = log(h_o);
end;

% ----------------------- Steady state ------------------------------------
steady_state_model;
    pi = 1;
    y  = 1;
    h  = 1/3;
    rr = 1/beta;
    r  = piss/beta;
    q  = 1;
    rk = 1/beta - (1-delta);
    mc = (epsilon-1)/epsilon;
    k  = alpha*mc*y / rk;
    w  = (1-alpha)*mc*y/h;
    i  = delta*k;
    g  = gss;
    a  = ass;
    c  = y - i - g;

    c_r = c;  c_o = c;
    t_r = t_rss;  t_o = t_oss;
    h_o = h;  h_r = h;
    d   = dss;

    lambda  = c^(-sigma);
    clog    = log(c);   wlog = log(w);   hlog = log(h);
    klog    = log(k);   ilog = log(i);
    c_r_log = log(c_r); c_o_log = log(c_o);
    h_r_log = log(h_r); h_o_log = log(h_o);
end;

steady;
check;

% ----------------------- Shocks ------------------------------------------
shocks;
    var va; stderr 0.01;
    var vg; stderr 0.01;
    var vm; stderr 0.0025;
end;

% ----------------------- IRFs (no Dynare graphs) -------------------------
stoch_simul(order=1, irf=40, nograph, noprint) y clog ilog hlog klog wlog q pi r rr c_r_log c_o_log h_r_log h_o_log;
