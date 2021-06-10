function [x, nb] = laguerre(P, initial_guess, thresh, loop_nb)

if (nargin < 4)
    loop_nb = 100;
end
if (nargin < 3)
    thresh = 1e-9;
end
if (nargin < 2)
    initial_guess = 0;
end

P1st = polyderiv(P);
P2nd = polyderiv(P1st);

x = initial_guess;
nb = 1;
Px = polyval(P, x)
while ((abs(Px) > thresh) && (nb <= loop_nb))
    g = polyval(P1st, x) / Px
    g2 = g * g
    h = g2 - polyval(P2nd, x) / Px
    if (g < 0)
        a = nb / (g - sqrt((nb-1)*(nb*h - g2)))
    else
        a = nb / (g + sqrt((nb-1)*(nb*h - g2)))
    end
    x = x - a
    Px = polyval(P, x)
    nb = nb + 1
end

