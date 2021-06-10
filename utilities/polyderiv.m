function Q = polyderiv(P)

Q = ((length(P)-1):-1:1) .* P(1:end-1);
