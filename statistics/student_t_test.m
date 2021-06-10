function [t, p] = student_t_test (x, y)

mx  = mean(x);
xc = x - mx;
lx  = length(x);

my  = mean(y);
yc = y - my;
ly  = length(y);

df = lx + ly - 2;

sd = sqrt ((1/lx + 1/ly) * (sum (xc.*xc) + sum(yc.*yc)) / df);
t  = (mx - my) / sd;
a  = 1/2;
b  = df/(df + t*t);
p  = betacdf (df/2, a, b) * exp (gammaln(a) + gammaln(b) - gammaln(a+b));
%p  = betainc (df/2, a, b) * beta (a, b);

