% -------------------------------------------------------------------------
% NK with DMP labor market (Monacelli, Perotti & Trigari, JME 2010, Sec. 7)
% -------------------------------------------------------------------------

var
    c rk rr w n y k q i lambda r pi mc v g a
    u f gamma theta gamm_g S omega verify
    clog wlog klog ilog ylog thetalog nlog
;

varexo
    va
    vg
    vm
;

parameters
    % structural (monthly)
    beta alpha epsilon delta sigma mu eta rho
    zeta gshare

    % steady-state parameters used by the model
    ass piss rss yss gss thetass fss

    % policy & adjustment
    phi_P phi_I phipi phiy rhoa rhog rhom

    % matching & preferences
    gamm_gbar phi_V nu
;

% ====== Calibration (monthly) ======
beta   = 0.99^(1/3);
alpha  = 0.33;
epsilon= 7.25;
delta  = 0.025/3;
sigma  = 1.0;
mu     = 0.5;
eta    = mu;
rho    = 0.965;

zeta   = 0.9;     // value of leisure / MPL weight
gshare = 0.2;     // G/Y in steady state

piss   = 1;       // inflation target (SS)
ass    = 1;       // TFP in SS
fss    = 0.45;    // job finding prob
thetass= 0.5;     // labor market tightness

// price adjustment cost consistent with Calvo (monthly)
phipi  = 1.5^(1/3);
phiy   = (0.5/4)^(1/3);
phi_I  = 3.24*3;
rhoa   = 0.95^(1/3);
rhog   = 0.90^(1/3);
rhom   = 0.0;
phi_P  = (epsilon-1)*(11/12)/(piss^2*(1-(11/12))*(1-beta*(11/12)));

% ====== Derived SS objects (numbers) ======
gamm_gbar  = fss/(thetass^(1-mu));
rss     = piss/beta;

% -------------------------------------------------------------------------
%                         Nonlinear model
% -------------------------------------------------------------------------
model;
    // Households
    lambda = ((1+(sigma-1)*nu*n)/c)^sigma;
    1 = beta*(lambda(1)/lambda)*r/pi(1);
    1 = beta*(lambda(1)/lambda)*(rk(1)+(1-delta)*q(1))/q;
    k = (1-delta)*k(-1) + (1 - (phi_I/2)*(i/i(-1)-1)^2)*i;
    1 = q*(1 - (phi_I/2)*(i/i(-1)-1)^2 - phi_I*(i/i(-1)-1)*i/i(-1)) + phi_I*beta*(lambda(1)/lambda)*q(1)*(i(1)/i - 1)*(i(1)/i)^2;

    // Firms
    y  = a*k(-1)^alpha * n^(1-alpha);
    alpha*mc*y = rk*k(-1);
    (pi-piss)*pi = beta*(lambda(1)/lambda)*(y(1)/y)*pi(1)*(pi(1)-piss) + (epsilon/phi_P)*(mc - (epsilon-1)/epsilon);

    // Vacancy posting FOC
    n = rho*n(-1) + gamm_g;
    phi_V/gamma = (1-alpha)*mc*y/n - w + beta*rho*phi_V/gamma(1)*(lambda(1)/lambda);

    // Wage bargaining
    w = eta*(1-alpha)*mc*y/n + (1-eta)*sigma*nu*lambda^(-1/sigma) + eta*beta*phi_V*(lambda(1)/lambda)*theta(+1);

    // Resource constraint
    y = c + i + g + phi_V*v + (phi_P/2)*(pi-piss)^2*y;

    // Monetary policy
    r/rss = ((pi/piss)^phipi * (y/y(-1))^phiy)^(1-rhom) * (r(-1)/rss)^rhom * exp(vm);

    // Shocks
    log(a) = (1-rhoa)*log(ass) + rhoa*log(a(-1)) + va;
    g      = (1-rhog)*gss      + rhog*g(-1)      + vg;

    // Labor market identities
    rr    = r/pi(1);
    u     = 1 - n(-1);
    theta = v/u;
    f     = gamm_g/u;
    gamma = gamm_g/v;
    gamm_g   = gamm_gbar * u^mu * v^(1-mu);

    // Surplus & consistency check
    S     = (1-alpha)*mc*y/n - omega + beta*(lambda(1)/lambda)*S(1)*(rho - eta*f(1));
    omega = sigma*nu*lambda^(-1/sigma);
    verify= phi_V/gamma - (1-eta)*S;

    // Logs for IRFs in percentage deviations
    clog     = log(c);
    wlog     = log(w);
    klog     = log(k);
    ilog     = log(i);
    ylog     = log(y);
    thetalog = log(theta);
    nlog     = log(n);
end;

% -------------------------------------------------------------------------
%                         Steady state
% -------------------------------------------------------------------------
steady_state_model;
    % primitives
    pi    = 1;           % em vez de pi = piss; (evita escopo em 4.6.4)
    a     = ass;
    f     = fss;
    theta = thetass;
    n     = f/(1+f-rho);
    u     = 1 - n;
    v     = theta*u;
    gamm_g   = gamm_gbar*u^mu*v^(1-mu);

    rr  = 1/beta;
    r   = pi/beta;
    q   = 1;
    rk  = 1/beta - (1-delta);
    mc  = (epsilon-1)/epsilon;

    % produção
    k   = n*(a*alpha*mc/rk)^(1/(1-alpha));
    y   = a*k^alpha * n^(1-alpha);
    i   = delta*k;
    g   = gshare*y;

    % objetos do mercado de trabalho
    mpl   = (1-alpha)*mc*y/n;
    gamma = gamm_gbar*theta^(-mu);

    % custo de vaga, salário e consumo
    phi_V = ((1-eta)*(1-zeta)*mpl)/((1-beta*rho)/gamma + beta*eta*theta);
    w     = mpl*(eta + (1-eta)*zeta) + eta*beta*phi_V*theta;
    c     = y - i - g - phi_V*v;

    % preferências consistentes com as equações do modelo
    nu     = zeta*mpl / ( sigma*c - zeta*mpl*(sigma-1)*n );
    lambda = ((1+(sigma-1)*nu*n)/c)^sigma;
    omega  = sigma*nu*lambda^(-1/sigma);

    % surplus e verificação conforme o modelo
    S      = ((1-alpha)*mc*y/n - omega) / (1 - beta*(rho - eta*f));
    verify = phi_V/gamma - (1-eta)*S;

    % logs
    clog     = log(c);
    wlog     = log(w);
    klog     = log(k);
    ilog     = log(i);
    ylog     = log(y);
    thetalog = log(theta);
    nlog     = log(n);

    % referências
    yss = y;
    gss = g;
end;

steady;
check;

shocks;
    var va; stderr 0.01;
    var vm; stderr 0.0025;
    var vg; stderr 0.0481;
end;

stoch_simul(order=1, irf=40, pruning, nograph, noprint)
    ylog u clog ilog nlog thetalog wlog pi r rr verify;
