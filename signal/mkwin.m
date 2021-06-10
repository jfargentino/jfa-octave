function [w, coeff] = mkwin (type, n, winarg)

if (ischar (n))
    tmp = n;
    n = type;
    type = tmp;
end

if (strncmpi (type, 'none', 4) || strncmpi (type, 'uni', 3))
    w = ones (n, 1);
elseif (strncmpi (type, 'rect', 4))
    w = ones (n, 1);
    if (nargin < 3)
        winarg = 1;
    end
    w(1 : winarg) = 0;
    w(n - winarg + 1: n) = 0;
elseif (strncmpi (type, 'hamming', 4))
    w = hamming (n);
elseif (strncmpi (type, 'hann', 4))
    w = hann (n);
elseif (strncmpi (type, 'tukey', 5))
    if (nargin < 3)
        winarg = 0.5;
    end
    if ((winarg < 0) || (winarg > 1))
        error ('argument for %s window must be in interval [%d %d]', ...
               type, 0, 1);
    end
    w = tukeywin (n, winarg);
elseif (strncmpi (type, 'sin', 3) || strncmpi (type, 'cos', 3))
    w = sin (pi*(0:n-1)'/(n-1));
elseif (strncmpi (type, 'lanczos', 7) || strncmpi (type, 'sinc', 4))
    w = sinc (2*(0:n-1)'/(n-1) - 1);
elseif (strncmpi (type, 'bartlett', 8))
    w = bartlett (n);
elseif (strncmpi (type, 'triang', 6))
    w = triang (n);
elseif (strncmpi (type, 'gauss', 5))
    if (nargin < 3)
        winarg = 3;
    end
    w = gausswin (n, winarg);
elseif (strncmpi (type, 'barthann', 8)) ...
                || (strncmpi (type, 'bartlett-hann', 13)) ...
                || (strncmpi (type, 'bartletthann', 12))
    w = barthannwin (n)';
elseif (strncmpi (type, 'blackman', 7))
    w = blackman (n);
elseif (strncmpi (type, 'kaiser', 6))
    if (nargin < 3)
        winarg = 8;
    end
    w = kaiser (n, winarg);
elseif (strncmpi (type, 'nuttall', 7))
    w = nuttallwin (n);
elseif (strncmpi (type, 'blackman-harris', 15) ...
                || strncmpi (type, 'blackmanharris', 14))
    w = blackmanharris (n);
elseif (strncmpi (type, 'blackman-nuttall', 16) ...
                || strncmpi (type, 'blackmannuttall', 15))
    w = blackmannuttal (n);
elseif (strncmpi (type, 'flat', 4))
    w = flattopwin (n);
else
    error ('window type %s unknown', type);
end

%coeff = sum (w) / length (w);
coeff = sum (w .* w) / length (w);

%!demo
%! n  = 256;
%! n0 = n / 4;
%! wn = 10;
%! h  = zeros (n, wn);
%! c  = zeros (wn, 1);
%! w  = ['rect'; ...
%!       'hann'; ...
%!       'tukey'; ...
%!       'lanczos'; ...
%!       'bartlett-hann'; ...
%!       'gauss'; ...
%!       'kaiser'; ...
%!       'nuttall'; ...
%!       'blackman-nuttall'; ...
%!       'flattop'];
%! for (k=1:wn)
%!      [h(:, k), c(k)] = mkwin (n, w(k, :));
%!      w(k, :), c(k), c(k)*c(k)
%! end
%! figure
%! subplot (2, 1, 1);
%! plot (h);
%! xlim ([1, n]);
%! ylim ([-0.2, +1.2]);
%! legend (w);
%! grid on;
%! subplot (2, 1, 2);
%! H = abs (fftshift (fft (h)));
%! plot (-n0:+n0, 20*log (H(n/2-n0:n/2+n0, :)));
%! xlim ([-n0, +n0]);
%! ylim ([-300, +100]);
%! legend (w);
%! grid on;
%! 
%! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! w_black = zeros (n, 3);
%! w_black(:, 1) = mkwin (n, 'blackman');
%! w_black(:, 2) = mkwin (n, 'blackman-harris');
%! w_black(:, 3) = mkwin (n, 'blackman-nuttall');
%! figure;
%! subplot (2, 1, 1);
%! plot (-n/2:n/2 - 1, w_black);
%! xlim ([-n/2,n/2 - 1]);
%! ylim ([-0.2, +1.2]);
%! legend ('blackman', 'blackman-harris', 'blackman-nuttall');
%! grid on;
%! subplot (2, 1, 2);
%! W = abs (fftshift (fft (w_black)));
%! plot (-n0:+n0, 20*log (W(n/2-n0:n/2+n0, :)));
%! xlim ([-n0, +n0]);
%! ylim ([-300, +100]);
%! grid on;
%! legend ('blackman', 'blackman-harris', 'blackman-nuttall');
%! 
%! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! w_triang = zeros (n, 3);
%! w_triang(:, 1) = mkwin (n, 'triangle');
%! w_triang(:, 2) = mkwin (n, 'bartlett');
%! w_triang(:, 3) = mkwin (n, 'bartlett-hann');
%! figure;
%! subplot (2, 1, 1);
%! plot (-n/2:n/2 - 1, w_triang);
%! xlim ([-n/2,n/2 - 1]);
%! ylim ([-0.2, +1.2]);
%! legend ('triangular', 'blartlett', 'bartlett-hann');
%! grid on;
%! subplot (2, 1, 2);
%! W = abs (fftshift (fft (w_triang)));
%! plot (-n0:+n0, 20*log (W(n/2-n0:n/2+n0, :)));
%! xlim ([-n0, +n0]);
%! ylim ([-300, +100]);
%! grid on;
%! legend ('triangular', 'blartlett', 'bartlett-hann');
%!
%! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! w_sin = zeros (n, 2);
%! w_sin(:, 1) = mkwin (n, 'cosine');
%! w_sin(:, 2) = mkwin (n, 'lanczos');
%! figure;
%! subplot (2, 1, 1);
%! plot (-n/2:n/2 - 1, w_sin);
%! xlim ([-n/2,n/2 - 1]);
%! ylim ([-0.2, +1.2]);
%! legend ('cosine', 'lanczos');
%! grid on;
%! subplot (2, 1, 2);
%! W = abs (fftshift (fft (w_sin)));
%! plot (-n0:+n0, 20*log (W(n/2-n0:n/2+n0, :)));
%! xlim ([-n0, +n0]);
%! ylim ([-300, +100]);
%! grid on;
%! legend ('cosine', 'lanczos');
%!
%! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! w_ha = zeros (n, 2);
%! w_ha(:, 1) = mkwin (n, 'hamming');
%! w_ha(:, 2) = mkwin (n, 'hann');
%! figure;
%! subplot (2, 1, 1);
%! plot (-n/2:n/2 - 1, w_ha);
%! xlim ([-n/2,n/2 - 1]);
%! ylim ([-0.2, +1.2]);
%! legend ('hamming', 'hann');
%! grid on;
%! subplot (2, 1, 2);
%! W = abs (fftshift (fft (w_ha)));
%! plot (-n0:+n0, 20*log (W(n/2-n0:n/2+n0, :)));
%! xlim ([-n0, +n0]);
%! ylim ([-300, +100]);
%! grid on;
%! legend ('hamming', 'hann');
%!
%! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! w_tukey = zeros (n, 3);
%! w_tukey(:, 1) = mkwin (n, 'tukey', 0.25);
%! w_tukey(:, 2) = mkwin (n, 'tukey', 0.5);
%! w_tukey(:, 3) = mkwin (n, 'tukey', 0.75);
%! figure;
%! subplot (2, 1, 1);
%! plot (-n/2:n/2 - 1, w_tukey);
%! xlim ([-n/2,n/2 - 1]);
%! ylim ([-0.2, +1.2]);
%! legend ('tukey 0.25', 'tukey 0.5', 'tukey 0.75');
%! grid on;
%! subplot (2, 1, 2);
%! W = abs (fftshift (fft (w_tukey)));
%! plot (-n0:+n0, 20*log (W(n/2-n0:n/2+n0, :)));
%! xlim ([-n0, +n0]);
%! ylim ([-300, +100]);
%! grid on;
%! legend ('tukey 0.25', 'tukey 0.5', 'tukey 0.75');
%!
%! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! w_gauss = zeros (n, 3);
%! w_gauss(:, 1) = mkwin (n, 'gauss', 3);
%! w_gauss(:, 2) = mkwin (n, 'gauss', 4);
%! w_gauss(:, 3) = mkwin (n, 'gauss', 5);
%! figure;
%! subplot (2, 1, 1);
%! plot (-n/2:n/2 - 1, w_gauss);
%! xlim ([-n/2,n/2 - 1]);
%! ylim ([-0.2, +1.2]);
%! legend ('gaussian 3', 'gaussian 4', 'gaussian 5');
%! grid on;
%! subplot (2, 1, 2);
%! W = abs (fftshift (fft (w_gauss)));
%! plot (-n0:+n0, 20*log (W(n/2-n0:n/2+n0, :)));
%! xlim ([-n0, +n0]);
%! ylim ([-300, +100]);
%! grid on;
%! legend ('gaussian 3', 'gaussian 4', 'gaussian 5');
%!
%! %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! w_kaiser = zeros (n, 3);
%! w_kaiser(:, 1) = mkwin (n, 'kaiser', 8);
%! w_kaiser(:, 2) = mkwin (n, 'kaiser', 16);
%! w_kaiser(:, 3) = mkwin (n, 'kaiser', 32);
%! figure;
%! subplot (2, 1, 1);
%! plot (-n/2:n/2 - 1, w_kaiser);
%! xlim ([-n/2,n/2 - 1]);
%! ylim ([-0.2, +1.2]);
%! legend ('kaiser 8', 'kaiser 16', 'kaiser 32');
%! grid on;
%! subplot (2, 1, 2);
%! W = abs (fftshift (fft (w_kaiser)));
%! plot (-n0:+n0, 20*log (W(n/2-n0:n/2+n0, :)));
%! xlim ([-n0, +n0]);
%! ylim ([-300, +100]);
%! grid on;
%! legend ('kaiser 8', 'kaiser 16', 'kaiser 32');
