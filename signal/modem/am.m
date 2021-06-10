function y = am (x, wc, phi)
%
% function y = am (x, wc, phi)
% 
% Modulate signal 'x' in amplitude. 'wc' is the normalized carrier frequency
% (must be < 1). 'phi' is the dephasage in radians, 0 per default (means
% cosine is used as carrying signal).
%

if (nargin < 3)
   phi = 0;
end

k = 1 / wc;

[nrow, ncol] = size (x);
n = (0:nrow - 1)';
if (mod (k, 1) == 0)
   % k is an integer
   % TODO sin or cos per default (phi = 0) ?
   % TODO is it possible to keep a period only to avoid mem mess ?
   % TODO try [+1 +1 -1 -1] and [-1 +1 +1 -1] for cos and sin
   c = repmat (cos (2 * (mod (n, k) + 1) * pi / k + phi), 1, ncol);
else
   c = repmat (cos (2 * pi * n / k + phi), 1, ncol);
end
% modulate
y = c .* x;

