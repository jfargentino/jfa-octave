function [Pproj, k] = projected (plane, P)
%
% function [Pproj, k] = projected (plane, P)
%
%    Calculate the orthogonal projected coordinates of point P(x,y,z) on a
% plane (a,b,c,d). Plane is defined as points (x,y,z) wich verify:
%                        a*x + b*y + c*z + d == 0
%

[P, trans] = adjust_dim (P);
plane = plane (:);

% Now for sure nb of columns is the number of points
[dim, np] = size (P);

plane = plane / range (plane (1:3));
rplane = repmat (plane, 1, np);
k     = - sum (rplane (1:3, :).* P, 1) - rplane (4, :);
k     = repmat (k, 3, 1);
Pproj = P + k .* rplane (1:3, :);
k     = k (1, :); 

if (trans)
   Pproj = Pproj';
end

%!demo
%! plane = [0; 0; 1; 0];
%! p = [1; 1; 1];
%! [proj; k] = projected (plane, p)

