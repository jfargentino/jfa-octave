function y = fft_resample (x, k)
%
% function y = fft_resample (x, k)
%
% Change sampling frequency of x by k = sr_y / sr_x.
% If k > 1.0 (upsampling), zero-pad the FFT.
% Ik k < 1.0 (downsampling), remove FFT high pads.
%
% TODO check the difference with fft_resample2. This version looks better
% when length is important.
%
[R, C] = size(x);
real_input = isreal(x);
X = fftshift(fft(x));
if (k > 1.0)
    n = round( ((k - 1) * R) / 2 );
    z = zeros( n, C );
    y = [z; X; z];
else
    n = round( ((1 - k) * R) / 2 );
    y = X(n+1:end-n, :);
end
y = k * ifft(fftshift(y));
if (real_input)
    y = real(y);
end

%!demo
%!
%! sr_x = 16000;
%! sr_y = 48000;
%! f0 = 6666;
%! t = [ 0 : 21 ]' / sr_x; 
%! x = sin( 2*pi*f0*t );
%! y = fft_resample (x, sr_y / sr_x);
%! subplot(2, 1, 1);
%! plot ( x );
%! subplot(2, 1, 2);
%! plot ( y );
%!

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

