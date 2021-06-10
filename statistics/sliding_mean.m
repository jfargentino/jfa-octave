function y = sliding_mean (x, w_sz, stp, zpad)
%
% function y = sliding_mean (x, w_sz, stp, zpad)
%
% Evaluate the sliding mean of vector x on 'w_sz' elements.
%
if (w_sz <= 0)
   y = NaN;
   return
end

if (nargin < 4)
   zpad = 0;
end
if (nargin < 3)
    stp = 1;
end

if (zpad == 0) & (w_sz > length (x))
   y = NaN;
   return
end

[row, col] = size (x);
if (row == 1)
    x = x(:);
    row = col;
    col = 1;
end

if (zpad)
    z = zeros (w_sz-stp, col);
    x = [z; x];
end

if ((stp == 1) && (col == 1))
    % A special case where we can easily use matrix efficiency
    y = cumsum ([sum(x(1:w_sz)); x(w_sz+1:end) - x(1:end-w_sz)]) ./ w_sz;
else
    n0 = 1;
    n1 = w_sz;
    y = zeros (ceil (row/stp), col);
    k = 1;
    % TODO it's too slow, use something with cumsum
    while (n1 <= row)
        y(k, :) = mean(x(n0:n1, :));
        n0 = n0 + stp;
        n1 = n1 + stp;
        k = k + 1;
    end
    y = y (1:k-1, :);
end

%!demo
%! x = (-10:10);
%! sliding_mean (x, 3, 1, 0)
%! sliding_mean (x, 3, 1, 1)
%! sliding_mean (x, 3, 2, 0)
%! sliding_mean (x, 3, 2, 1)
%! sliding_mean (x, 10, 1, 0)
%! sliding_mean (x, 10, 1, 1)
%! sliding_mean (x, 21, 1, 0)
%! sliding_mean (x, 21, 1, 1)

