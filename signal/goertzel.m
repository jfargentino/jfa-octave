function y = goertzel (x, f_norm, win, step)

[row, col] = size (x);
if (nargin < 3)
    win = row;
end

if (length (win) > 1)
    sz = length (win);
else
    sz = win;
    win = ones (sz, col);
end

if (nargin < 4)
    step = sz;
end

if (col == 1)
    col = length (f_norm);
end
%TODO big alloc
y = zeros (ceil (row / step), col);

% f_norm is f / sampling rate
w = 2.0 * cos (2*pi*f_norm);

n0 = 1;
n1 = n0 + sz - 1;
k = 1;
while (n1 <= row)
    % one goertzel
    last = 0;
    penu = 0;
    for (kk = 0 : (sz - 1))
        s = win(kk+1, :) .* x(n0+kk, :) + w .* last - penu;
        penu = last;
        last = s;
    end
    y(k, :) = 4 * (last.*last + penu.*penu - w.*last.*penu) / (sz * sz);
    % if you want the result as real and imaginary part, use:
    % y(k) = last - penu * cos (2*pi*f_norm) + i * (penu * sin (2*pi*f_norm))
    n0 = n0 + step;
    n1 = n0 + sz - 1;
    k = k + 1;
end
%TODO reshape
y = y(1:(k-1), :);

%!demo
%!
%! fsr = 192e3;
%! ns  = 16384;
%! nz  =  8192;
%! t   = (0:(ns - 1))' / fsr;
%! f0  = 32e3;
%! s   = chirp (t, f0/2, t(end), 2*f0);
%!
%! x = [zeros(nz, 1); s; zeros(nz, 1)] + 0.5 * randn (2*nz + ns, 1);
%! p = goertzel (x, 0:0.005:0.5, hamming (2048), 256);
%!
%! f = [0; fsr/2];
%! t = [0; (ns + 2*nz - 1)/fsr];
%! imagesc (f, t, 10*log10(p));
%! colorbar
%! xlabel ('frequency (Hz)');
%! ylabel ('time (s)');
%!

