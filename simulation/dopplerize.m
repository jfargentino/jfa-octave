function Sdoppler = dopplerize (S, vs, vr, c)

if (nargin < 4)
    c = 1500;
end

% TODO resample is too slow
Sdoppler = fft_resample (S, doppler (1, vs, vr, c));

%!demo
%!
%! Fs = 192e3;
%! F0 = 5e3;
%! F1 = 15e3;
%! n  = 10 * round (Fs / F0);
%! t = (0:n-1)' / Fs;
%! s = chirp (t, F0, t(end), F1, 'linear', -90);
%! vs = +30;
%! vr = -30;
%! c = 1500;
%! sd = dopplerize (s, vs, vr, c);
%! if (length (s) > length (sd))
%!      z = zeros (length (s) - length (sd), 1);
%!      sd = [sd; z];
%! else
%!      z = zeros (length (sd) - length (s), 1);
%!      s = [s; z];
%!      n = length (s);
%!      t = (0:n-1)' / Fs;
%! end
%! figure
%! subplot (2, 1, 1)
%! plot (t, s, t, sd)
%! subplot (2, 1, 2);
%! N = 131072;
%! z = zeros (N-length (s), 1);
%! f = Fs * (-(N/2):(N/2)-1)' / N;
%! plot (f, 10*log10 (fftshift (psd ([s; z]))), ...
%!       f, 10*log10 (fftshift (psd ([sd; z]))))
%! xlim (3 * [-F1, +F1] / 2);
