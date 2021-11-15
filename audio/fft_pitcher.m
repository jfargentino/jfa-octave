function y = fft_pitcher (x, k)
%
% function y = fft_pitcher (x, k)
%
% Change pitch frequency of x by k.
%
% TODO how to use resample on the signal to avoid 0 or removing data ?
%
[R, C] = size(x);
real_input = isreal(x);

%y = fft_resample(x, k);
%X = fftshift (fft(y));

if (k > 1.0)
    %n = round( ((k - 1) * R) / 2 );
    %X = X(n+1:end-n, :);
    % OK FOR LENGTH AND PITCH BUT PADDING IN THE OUTPUT %%%%%%%%%%%%%%%%%%%%%%%
    % Zero-pad x thus its new length will interpolize its spectrum
    n = round( ((k - 1) * R) / 2 );
    y = [zeros(n, C); x; zeros(n, C)];
    X = fftshift (fft(y));
    % remove high pads to retrieve the same length as original
    X = X(n+1:end-n, :);
else
    %n = round( ((1 - k) * R) / 2 );
    %X = [zeros(n, C); X; zeros(n, C)];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    n = round( ((1 - k) * R) / 2 );
    y = x(n+1:end-n, :);
    X = fftshift (fft(y));
    X = [zeros(n, C); X; zeros(n, C)];
end
y = ifft(fftshift(X)) / k;
if (real_input)
    y = real(y);
end

%!demo
%!
%! sr_x = 44100;
%! sr_y = 48000;
%! x = randn (sr_x, 1);
%! u = fft_resample (x, sr_y / sr_x);
%! d = fft_resample (u, sr_x / sr_y);
%! plot ( (d-x) / max(abs(x)) )
%!

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
%! s_interp = fft_resample (s_down, rate);
%! t_interp = (0:length(s_interp)-1) / Fs_up;
%!
%! plot (t_up, s_up, t_down, s_down, 'x', t_interp, s_interp, 'o');
%! grid on;
%! legend ('up sampled', 'sampled just above 2*fmax', 'previous interpolated');
%!

