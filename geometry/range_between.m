function r = range_between (A, B)
%
%function r = range_between (A [, B])
%
%   Calcul de la distance (si deux arguments) ou de la norme euclidienne
% (si un seul argument).
%

if (nargin == 1)
   [A, trans] = adjust_dim (A);
   %r = sqrt (sum (A .* A, 1));
   r = sqrt (dot (A, A));
else
   tmp = A - B;
   [tmp, trans] = adjust_dim (tmp);
   r = sqrt (dot (tmp, tmp));
end
if (trans)
   r = r';
end

%!demo
%! a = [1, 1, 1];
%! range (a)
%! b = [2; 2; 2];
%! p = [a', b];
%! range (p)
