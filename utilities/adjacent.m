function index = adjacent (s, d)
% function index = adjacent (s [, d])
%
%    Return an nx2 array where each element of the first column is the begin
% index of adjacent groups found in s, and each element of the second one is
% the end index. We always have:
%    -index (1,1) == 1
%    -index (1, n+1) == index (2, n) + 1
%    -index (end,2) == length (int_vector).
%
%    s(k) and s(k+1) are adjacent if |s(k) - s(k+1)| <= d (1 per default).
%

if (nargin < 2)
   d = 1;
end

s = s (:);
b = find (abs (diff (s)) > d) + 1;
e = b - 1;
index = zeros (length (b) + 1, 2);
index (1, 1)       = 1;
index (2:end, 1)   = b;
index (1:end-1, 2) = e;
index (end, 2)     = length (s);

%!demo
%! v = [1;2;3;4; 6;7; 9; 12;13]
%! adjacent (v)
%! 
%! v = [0.1;0.2; 0.5; 0.8;0.85; 1.40]
%! adjacent (v, 0.2)
%! adjacent (v, 0.5)
%! adjacent (v, 0.8)

