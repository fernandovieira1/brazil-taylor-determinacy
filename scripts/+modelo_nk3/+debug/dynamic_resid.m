function [lhs, rhs] = dynamic_resid(y, x, params, steady_state)
T = NaN(0, 1);
lhs = NaN(4, 1);
rhs = NaN(4, 1);
lhs(1) = y(6);
rhs(1) = y(10)-1/params(2)*(y(7)-y(9))+x(3);
lhs(2) = y(5);
rhs(2) = y(9)*params(1)+y(6)*params(3)+x(2);
lhs(3) = y(7);
rhs(3) = params(6)*y(3)+y(5)*params(4)+y(6)*params(5)+x(1);
lhs(4) = y(8);
rhs(4) = y(7)-y(9);
end
