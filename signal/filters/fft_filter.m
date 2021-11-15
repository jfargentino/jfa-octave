function y = fft_filter (coeff, x, nfft, normalize)
%
% function y = fft_filter (coeff, x, nfft, normalize)
%
% My implementation of MATLAB/OCTAVE fftfilt if normalize == 0, otherwise
% normalize the FFT output thus output signal has the same dynamic.
% TODO Why there's tiny difference with 'fftfilt' octave function? Mine is
% fastest
% TODO windowing
% TODO not sure for the rescaling, maybe sum (coeff) should be took in account?

if (nargin < 4)
    normalize = 0;
end
coeff = coeff (:);
ncoeff = length (coeff);
if (nargin < 3)
    nfft = ncoeff;
end

[r, c] = size (x);
z = mod (r, nfft);
if (z > 0)
    z = nfft - z;
    x = [x; zeros(z, c)];
    [r, c] = size (x);
end
y = zeros (r + ncoeff - 1, c);

n0 = 1;
n1 = nfft;
coeff_fft = fft ([repmat(coeff, 1, c); zeros(nfft-1, c)]);
while (n1 <= r)
    y(n0:(n1+ncoeff-1), :) = y(n0:(n1+ncoeff-1), :) ...
                + ifft (fft ([x(n0:n1, :); zeros(ncoeff-1, c)]) .* coeff_fft);
    n0 = n1 + 1;
    n1 = n1 + nfft;
end

if (normalize > 0)
    y = 2*y(1:r-z, :)/(ncoeff + nfft - 1);
else
    y = y(1:r-z, :);
end
if (isreal (x) && isreal (coeff))
    y = real (y);
end

%!demo
%!
%! sr = 48000;
%! n  = 100*sr;
%! t  = (0:n-1)' / sr;
%! x  = randn (100*sr, 1);
%! %x  = sin (2*pi*440*t);
%! b  = [ +.5, +1, +.5, -.5, +.2, -.2, +.1, -.1, +.05 ];
%! nfft = 512;
%! tic
%! y  = fft_filter (b, x, nfft, 0);
%! toc
%! tic
%! ref  = fftfilt (b, x, nfft);
%! toc
%! plot(y-ref)

