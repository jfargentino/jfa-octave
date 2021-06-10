function s_cut = cut (s, n, overlap, padlast)

% TODO Doesn't work when length (s) = n !!!

if (nargin < 4)
   padlast = 0;
end
if (nargin < 3)
   overlap = 0;
end

if (overlap >= n)
   s_cut = [];
   return;
end

% make s a column
s = s (:);

N = length (s);
if N <= n
   s_cut = s;
   return;
end

chunk = floor ((N - overlap) / (n - overlap));
remain = n - N + (chunk * n - (chunk - 1) * overlap);
if ((padlast > 0) && (remain > 0))
   z = zeros (remain, 1);
   s = [s; z];
   chunk = chunk + 1;
end
s_cut = zeros (n, chunk);
for k = 1:chunk
   s_cut (:, k) = s ((((k - 1)*n + 1):k*n) - (k - 1) * overlap);
   % if you want to remove linear part of signal by chunk
   %s_cut (:, k) = ldetrend (s ((((k - 1)*n + 1):k*n) - (k - 1) * overlap));
end

