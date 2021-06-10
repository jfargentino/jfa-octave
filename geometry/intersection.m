function [Pint, k] = intersection (plane, P0, P1)
%
% function [Pint, k] = intersection (plane, P0, P1)
%
%   Calculate the intersection between a plane (a,b,c,d) and the line wich
% pass through points P0(x0,y0,z0) and P1(x1,y1,z1).
% TODO if P0 == P1
%

[P0, trans0] = adjust_dim (P0);
[P1, trans1] = adjust_dim (P1);
plane = plane (:);

S = sum (P0 .* plane(1:3)) + plane(4);
if (S == 0)
   % P0 is in the plane
   Pint = P0;
   k    = 0;
elseif (sum (P1 .* plane(1:3)) + plane(4) == 0)
   % P1 is in the plane
   Pint = P1;
   k    = 0;
else
   u    = P1 - P0;
   k    = - S / (sum (u .* plane (1:3)));
   Pint = P0 + k * u;
end

if (trans0 + trans1 > 0)
   Pint = Pint';
end

%!demo
%! plane = [0; 0; 1; 1];
%! p0 = [0; 0; +1];
%! p1 = [0; 0; -1];
%! intersection (plane, p0, p1)
