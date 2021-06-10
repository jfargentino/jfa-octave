function [Padj, trans] = adjust_dim (P)
% function [Padj, trans] = adjust_dim (P)
%  A point is a three elements in one COLUMN!
%

[r, c] = size (P);
if (r ~= 3)
   Padj = P';
   trans = 1;
else
   Padj = P;
   trans = 0;
end

%!demo
%! P = [1, 2, 3];
%! [P, t] = adjust_dim (P)
%! P = [1; 2; 3];
%! [P, t] = adjust_dim (P)


