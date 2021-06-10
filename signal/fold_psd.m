function Sfold = fold_psd (S)

N = ceil (length (S) / 2);
Sfold = S (1:N, :) + S (end:-1:N+1, :);

