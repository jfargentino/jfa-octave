function [F, P, S_dB, f] = findPeak (s, Fs, thresh, F0, F1)
%
% function [F, P, S_dB, f] = findPeak (s, [Fs, thresh, F0, F1])
%
% To find revelant frequencies in a signal 's'.
%   'Fs'     = sample frequency (2 per default)
%   'thresh' = threshold in dB over which a frequency is considered
%              as revelant (60 dB per default)
%   'F0'     = the frequency above which to look out (0 per default)
%   'F1'     = the maximum frequency (Fs/2 per default)
%
% return:
%   'F'    = the array of revelant frequencies
%   'P'    = the array of revelant powers in dB
%   'S_dB' = the power spectral density of 's' between 'F0' et 'F1'
%   'f'    = the array of all frequencies between 'F0' et 'F1
%
if (nargin < 2)
	Fs = 2;
end

if (nargin < 3)
	thresh = -60;
end

if (nargin < 4)
	F0 = 0;
end

if (nargin < 5)
	F1 = Fs / 2;
end

N    = length (s);
dF   = Fs / N;
S    = psd (s);

n0   = floor (N * F0 / Fs);
n0   = max (n0, 0) + 1;
n1   = ceil (N * F1 / Fs) + 1;
n1   = min (n1, N/2);
% the power spectal density in dB
S_dB = power2dB (S(n0:n1));
%the frequencies array
f    = ((n0:n1)' - 1) * Fs / N;

% index of channel over the threshold
n    = find (S_dB > thresh);
n    = n + n0 - 1;

F = []; % revelant frequencies
P = []; % revelant powers

if (length (n) == 0)
    % psd is under the threshold, return
	return;
end

k = 1;  % nb of peak detected
l = 1;
p = S(n(1));
for (m = 1 : length(n)-1)
    if (n (m+1) - n (m) == 1)
        % frequency channel is contigous
        % so integrate the power
        p = p + S(n(m+1));
    else
        % search the most powerful channel and take it as the frequency
        % this is not true, must be interpolated instead
        [mf, nf] = max (S(n(l:m)));
        F = [F; (nf - 2 + n(l)) * dF];
        P = [P; p];
        p = S(n(m+1));
        l = m + 1;
    end
end
[mf, nf] = max (S(n(l:end)));
F = [F; (nf - 2 + n(l)) * dF]; 
P = [P; p];

%!demo
%!
%! sr = 48000;
%! n  = 5*sr;
%! t  = (0:n-1)' / sr;
%! s  = sin(2*pi*55*t) + 3*sin(2*pi*1000*t) - 2*sin(2*pi*12000*t);
%! [F, P, S_dB, f] = findPeak (s, sr)

