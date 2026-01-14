function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(0, 1);
end
[T_order, T] = modelo_nk2.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(4, 1);
    residual(1) = (y(6)) - (y(10)-1/params(2)*(y(7)-y(9))+x(3));
    residual(2) = (y(5)) - (y(9)*params(1)+y(6)*params(3)+x(2));
    residual(3) = (y(7)) - (params(6)*y(3)+y(5)*params(4)+y(6)*params(5)+x(1));
    residual(4) = (y(8)) - (y(7)-y(9));
end
