function f = mfreq (s, Fs)
%
% function f = mfreq (s[, Fs])
%
%    To get the mean frequency of a given signal. The mean frequency is given
% by the power ponderated mean of each spectrum channel.
%
% Inputs:
%     -s: the signal to get the mean frequency.
%     -Fs: [optionnal] the signal sample rate in Hz.
%
% Outputs:
%     -f: the mean frequency of s.
%

n = round (length (s) / 2);
N = (0 : (n - 1))';
S = fft (s);
S = abs (S .* conj (S));
S = S (1:n);
f = sum (N .* S) / sum (S);

if (nargin == 2)
    f = Fs * f / length (s);
end

%!demo
%! Fs = 48000;
%! t  = (0:32767)' / Fs;
%! s  = chirp (t, 1e3, t(end), 10e3, 'linear');
%! f  = mfreq (s, Fs)

%!demo
%! Fs = 48000;
%! t  = (0:32767)' / Fs;
%! s  = chirp (t, 1e3, t(end), 10e3, 'quadratic');
%! f  = mfreq (s, Fs)

%!demo
%! Fs = 48000;
%! t  = (0:32767)' / Fs;
%! s  = chirp (t, 1e3, t(end), 10e3, 'logarithmic');
%! f  = mfreq (s, Fs)

