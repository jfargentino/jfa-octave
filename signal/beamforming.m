function y = beamforming (x, d, w)

% TODO if length of delays (and or weights) < x nb of column

[L, N] = size (x);

if (nargin < 3)
   w = ones (1, N);
end

% Delays and Weights in one line vector
d = round (d (:)');
w = w (:)';

% delay min and delay max
dmin = min (d);
dmax = max (d);





