function Psym = symmetrical (plane, P)
%
% function Psym = symmetrical (plane, P)
%
%   Calculate symmetrical cordinates of P per plane (a,b,c,d).
%

[P, trans] = adjust_dim (P);
plane = plane (:);
[dim, np] = size (P);

[Pproj, k] = projected (plane, P);
plane      = repmat (plane (1:dim), 1, np);
k          = repmat (k, dim, 1);
Psym       = P + 2*k .* plane;

if (trans == 1)
   Psym = Psym';
end

%!demo
%! plane = [0, 0, 1, 0];
%! P0 = [1; 1; 1];
%! P1 = [1; -1; 2];
%! symmetrical (plane, [P0, P1])

