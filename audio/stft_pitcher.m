function y = stft_pitcher (x, k, nfft)
%
% function y = stft_pitcher (x, k, nfft);
%

if (nargin < 3)
    nfft = 1024;
end

[r, c] = size (x);
zpad = mod (r, nfft);
if (zpad > 0)
    zpad = nfft - zpad;
    x = [x; zeros(zpad, c)];
    [r, c] = size (x);
end

n0 = 1;
n1 = nfft;
y = [];
while (n1 <= r)
    y = [ y; fft_pitcher(x(n0:n1, :), k) ];
    n0 = n1 + 1;
    n1 = n1 + nfft;
end


%!demo
%!
%! sr = 44100;
%! x  = randn (sr, 1);
%! nfft = 1024;
%! u = stft_resample(x, 48000/sr, nfft);
%! d = stft_resample(u, sr/48000, nfft);
%! plot([d(1:sr), x]);


