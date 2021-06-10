function p = point_of (equ)

% Le plan est donné par son equation a*x + b*y + c*z + d = 0
% un vecteur normal n est alors [a, b, c]
n  = equ (1:3);
% Recherche d'un point repondant a l'equation
nz = find (n);
if (length (nz) == 0)
   p = [];
else
   [r, c] = size (n);
   p = ones (r, c);
   p(nz(1)) = -(sum (n) - n(nz(1)) + equ(4)) / n(nz(1));
end

%!demo
%! equ = [1, 0, 0, 0]'; p = point_of (equ), sum (equ(1:3).*p)-equ(4)
%! equ = [0, 1, 0, 0]'; p = point_of (equ), sum (equ(1:3).*p)-equ(4)
%! equ = [0, 0, 1, 0]'; p = point_of (equ), sum (equ(1:3).*p)-equ(4)

