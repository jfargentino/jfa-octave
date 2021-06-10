function y = dirty_up_sampling (x, k)

[R, C] = size(x);
z = zeros(((k-1)*R)/2, C);
y = k*real(ifft(fftshift([z; fftshift(fft(x)); z])));

