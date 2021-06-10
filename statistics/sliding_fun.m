function y = sliding_fun (x, w_sz, fun, stp)
% TODO optilize it, build the input matrix then call once the fun

if (nargin < 4)
    stp = 1;
end
if (nargin < 3)
    fun = 'var';
end

n0 = 1;
n1 = w_sz;
[row, col] = size (x);
y = zeros (ceil (row/stp), col);
k = 1;
TRY_STR = ['y(k, :) = ', fun, '(x(n0:n1, :));'];
while (n1 <= row)
    eval (TRY_STR);
    n0 = n0 + stp;
    n1 = n1 + stp;
    k = k + 1;
end
y = y (1:k-1, :);
