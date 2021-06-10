function [fl, fh] = third_octave_freq (k, f0)

if (nargin < 2)
    f0 = 1e3;
end

fc = power (2, k/3) * f0;

fh = sqrt (2^(k/3) * 2^((k+1)/3)) * f0;
%   = sqrt (2^((2*k+1)/3)) * f0;
%   = (2^k) * sqrt (1/3) * f0; 

fl = sqrt (2^((k-1)/3) * 2^(k/3)) * f0;
%   = sqrt (2^((2*k-1)/3)) * f0;
%   = (2^k) * sqrt (1/3) * f0; 
