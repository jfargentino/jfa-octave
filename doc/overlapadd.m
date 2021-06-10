y = overlapadd (x, h)

L = length (h);
M = 2*L - 1;
[r, c] = size (x);
y = zeros (r + L - 1, c);
H = repmat (fft(h(:), M), 1, c);
n = 1;
while (n <= r - L)
    y(n:n+M-1, :) = ifft (fft(x(n:n+L-1, :),M) .* H);
    n = n + L;
end

