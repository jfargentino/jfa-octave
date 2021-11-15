function y = fft_resample2 (x, rate)
% TODO round(x_length * rate) can be != y_length
% TODO see fft_interp, looks identical

% Naive implementation
%X      = fftshift (fft (x));
%[r, c] = size (x);
%pad    = zeros ((irate - 1) * r, c);
%xi     = real (ifft (fftshift ([pad; X; pad])));

[r, c] = size (x);
is_real_input = isreal (x);
X = fft (x);
if (rate > 1)
    z = zeros (round ((rate - 1) * r), c);
    if (mod (r, 2) ~= 0)
        Y = [ X(1:(r+1)/2, :); ...
              z; ...
              X((r+1)/2 + 1:end, :) ];
    else
        Y = [ X(1:r/2, :); X(r/2 + 1, :)/2; ...
              z(1:end-1, :); ...
              X(r/2 + 1, :)/2; X(r/2 + 2:end, :)];
    end
else
    n = round ((1 - rate) * r);
    if (mod (r, 2) ~= 0)
        if (mod (n, 2) ~= 0)
            Y = [ X(1:(r-1)/2 - (n-1)/2, :); X((r-1)/2 + 2 + (n+1)/2:end, :) ];
        else
            Y = [ X(1:(r-1)/2 - n/2 + 1, :); X((r-1)/2 + 2 + n/2:end, :) ];
        end
    else
        if (mod (n, 2) ~= 0)
            Y = [ X(1:r/2 - (n-1)/2 - 1, :); ...
                  X(r/2 - (n-1)/2, : ) + X(r/2 + 2 + (n-1)/2, :); ...
                  X(r/2 + 2 + (n-1)/2 + 1:end, :) ];
        else
            Y = [ X(1:r/2 - n/2 - 1, :); ...
                  X(r/2 - n/2, : ) + X(r/2 + 2 + n/2, :); ...
                  X(r/2 + 2 + n/2 + 1:end, :) ];
        end
    end
end
y = ifft (rate * Y);
%sum (abs (imag (y)))
if (is_real_input == 1)
    y = real (y);
end

%!demo
%!
%! Fs_up    = 192e3;
%! F0       = 10e3;
%! n        = 5 * round (Fs_up / F0);
%! t_up     = (0:n-1)' / Fs_up;
%! s_up     = sin (2*pi*F0*t_up);
%! Fs_down  = 24e3;
%! rate     = Fs_up / Fs_down;
%! s_down   = s_up(1:rate:end);
%! t_down   = (0:size(s_down, 1) - 1)' / Fs_down;
%! s_interp = fft_resample2 (s_down, rate);
%! t_interp = (0:length(s_interp)-1) / Fs_up;
%!
%! plot (t_up, s_up, t_down, s_down, 'x', t_interp, s_interp, 'o');
%! grid on;
%! legend ('up sampled', 'sampled just above 2*fmax', 'previous interpolated');
%!

%!demo
%!
%! sr_x = 44100;
%! sr_y = 48000;
%! x = randn (sr_x, 1);
%! u = fft_resample2 (x, sr_y / sr_x);
%! length(u)
%! d = fft_resample2 (u, sr_x / sr_y);
%! plot ( (d-x) / max(abs(x)) )
%!
