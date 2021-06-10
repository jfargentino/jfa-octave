function [fl, fh, fc] = nth_octave_freq (n, k, f0)

if (nargin < 3)
    f0 = 1e3;
end
if (nargin < 2)
    k = 0;
end
if (nargin < 1)
    n = 3;
end

fc = power (2, k/n) * f0;

fh = sqrt (2.^(k/n) .* 2.^((k+1)/n)) * f0;
%   = sqrt (2^((2*k+1)/n)) * f0;
%   = (2^k) * sqrt (1/n) * f0; 

fl = sqrt (2.^((k-1)/n) .* 2.^(k/n)) * f0;
%   = sqrt (2^((2*k-1)/n)) * f0;
%   = (2^k) * sqrt (1/n) * f0; 
