function x = crosscorr (s, r, pad)
%
% function x = crosscorr (s, r, [pad])
%
% Compute the real cross correlation between s and r. MATLAB / OCTAVE are using
% FFT to compute it. Another difference is the length of the result:
%    - length (s) + length (r) - 1 for mine when padding
%    - length (s) for mine when no padding
%    - 2*length (s) - 1 for xcorr (if length (s) > length (r)
%

if ((nargin < 2) || (length (r) == 1))
    pad = r;
    r = s;
else
    if (nargin < 3)
        pad = 1;
    end
end

N = length (s);
K = length (r);

if (N < K)
    cr = s;
    cs = conj (r);
    N = K;
    K = length (s);
else
    cr = conj (r);
    cs = s;
end

if (pad > 0)
    x = zeros (N + K - 1, 1);
    for n = N+1:K+N-1
        x(n) = sum (cs(n-K+1:N) .* cr(1:K+N-n));
    end
else
    x = zeros (N, 1);
end

for n = 1:K-1
    x(n) = sum (cs(1:n) .* cr(K-n+1:K));
end
for n = K:N
    x(n) = sum (cs(n-K+1:n) .* cr);
end

if (pad > 0)
    for n = N+1:K+N-1
        x(n) = sum (cs(n-K+1:N) .* cr(1:K+N-n));
    end
end

%!demo
%! Fs = 192e3;
%! r = 32;
%! F0 = Fs / r;
%! l = 10 * r;
%! t = (0:l-1)' / Fs;
%! r = exp (2*pi*F0*t*sqrt (-1));
%! lz = 1000;
%! z = zeros (lz, 1);
%! s = [z; r; z];
%! %s = s + randn (length (s), 1);
%! pad = 1;
%!
%! c = crosscorr (s, r, pad);
%! x = xcorr (s, r);
%!
%! offset = length (s) - length (r) + 1;
%! if (pad > 0)
%!      xend = 2*length (s) - 1;
%! else
%!      xend = 2*length (s) - length (r);
%! end
%!
%! rc = real (c);
%! ic = imag (c);
%! rx = real (x);
%! ix = imag (x);
%!
%! figure
%! subplot (3, 1, 1);
%! plot ([rc, rx(offset : xend)]);
%! subplot (3, 1, 2);
%! plot ([ic, ix(offset : xend)]);
%! subplot (3, 1, 3);
%! plot (abs (c - x (offset : xend)));
