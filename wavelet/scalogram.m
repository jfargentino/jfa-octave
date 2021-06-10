function sc = scalogram (ws, K)

[r, c] = size (ws);
% TODO how to handle c > 1 ?

if (nargin < 2)
    K = floor (log2 (r));
end

sc = zeros (r/2, c);
n0 = r/2 + 1;
n1 = r;
sc (:, 1) = abs (ws (n0:n1));
for k = 2:K
    n0 = r/(2^k) + 1;
    n1 = r/(2^(k-1));
    tmp = repmat (ws(n0:n1)', 2^(k-1), 1);
    sc (:, k) = abs (tmp(:));
end

