function [n, v] = histogram (s)

s = s(:);

v = repmat (NaN, length (s), 1);
n = zeros (length (s), 1);
l = 1;
n_NaN = 0;
n_pInf = 0;
n_nInf = 0;
for (k = 1: length (s))
   if (isnan (s (k)))
      n_NaN = n_NaN + 1;
   elseif (isinf (s (k)))
      if (s (k) > 0)
         n_pInf = n_pInf + 1;
      else
         n_nInf = n_nInf + 1;
      end
   elseif (length (find (v == s (k))) < 1)
      v (l) = s (k);
      n (l) = length (find (s == s (k)));
      l = l + 1;
   end
end

% Cut arrays
v = v (1:l-1);
n = n (1:l-1);

% Sort
[v, index] = sort (v);
n = n(index);

% Add -Inf
if (n_pInf > 0)
   v = [-Inf; v];
   n = [n_nInf; n];
end

% Add +Inf
if (n_pInf > 0)
   v = [v; +Inf];
   n = [n; n_pInf];
end

% Add NaN
if (n_NaN > 0)
   v = [v; NaN];
   n = [n; n_NaN];
end


%!demo
%! s = [1; 2; -Inf; 3; 2; Inf; 5; 1; 6; 1; Inf; 6; NaN; -1]
%! [n, v] = histogram (s)
