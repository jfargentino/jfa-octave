function y = fft_filter (coeff, x, nfft)

% TODO Why there's tiny difference with 'fftfilt' octave function? Mine is
% fastest
% TODO windowing
% TODO not sure for the rescaling, maybe sum (coeff) should be took in account?

coeff = coeff (:);
ncoeff = length (coeff);
if (nargin < 3)
    nfft = ncoeff;
end

[r, c] = size (x);
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
% TODO the last chunk

y = 2*y(1:r, :)/(ncoeff + nfft - 1);
if (isreal (x) && isreal (coeff))
    y = real (y);
end

