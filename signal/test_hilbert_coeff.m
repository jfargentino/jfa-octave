function test_hilbert_coeff (s, n, nz)

wintype = [ 'none'; ...
            'hamming'; ...
            'hann'; ...
            'cosine'; ...
            'lanczos'; ...
            'triangular'; ...
            'bartlett'; ...
            'bartlett-hann'; ...
            'nuttall'; ...
            'blackman'; ...
            'blackman-harris'; ...
            'blackman-nuttall'; ...
            'flat-top'; ...
            'tukey 0.25'; ...
            'tukey 0.50'; ...
            'tukey 0.75'; ...
            'gaussian 3'; ...
            'gaussian 4'; ...
            'gaussian 5'; ...
            'kaiser 8'; ...
            'kaiser 16'; ...
            'kaiser 32' ];

wintype_nb = 22;

%%% create temporal windows
for (k = 1 : 13)
    w(:, k) = mkwin (2*n + 1, wintype(k, :));
end
w(:, 14) = mkwin (2*n + 1, wintype(14, :), 0.25);
w(:, 15) = mkwin (2*n + 1, wintype(15, :), 0.50);
w(:, 16) = mkwin (2*n + 1, wintype(16, :), 0.75);
w(:, 17) = mkwin (2*n + 1, wintype(17, :), 3);
w(:, 18) = mkwin (2*n + 1, wintype(18, :), 4);
w(:, 19) = mkwin (2*n + 1, wintype(19, :), 5);
w(:, 20) = mkwin (2*n + 1, wintype(20, :), 8);
w(:, 21) = mkwin (2*n + 1, wintype(21, :), 16);
w(:, 22) = mkwin (2*n + 1, wintype(22, :), 32);

%%% windowing hilbert FIR coefficients
h = repmat (hilbert_coeff (n, nz), 1, wintype_nb) .* w;

%%% Reference, for comparison
sh_ref = imag (hilbert (s));

%%% zero pad to compensate FIR delay
z = zeros (2*n+1, 1);
ss = [s; z];

%%% FIR based hilbert transforms
sh = zeros (length (ss), 22);
for (k = 1:22)
    sh(:, k) = filter (h(:, k), 1, ss);
end
% cut result
sh = sh(n+1:end - n - 1, :);
% error
sh_err = abs (repmat (sh_ref, 1, 22) - sh);
max_err = max (sh_err);
mean_err = mean (sh_err);
sum_err = sum (sh_err);
stddev_err = sqrt (var (sh_err));

for (k = 1 : 22)
    printf ('%s: max %6.3e, mean %6.3e, sum %6.3e, dev %6.3e\n', ...
            wintype(k, :), max_err(k), mean_err (k), sum_err (k), ...
            stddev_err (k));
end

[val, k] = min (max_err);
printf ('min of maximum error: %6.3e for %s\n', val, wintype(k, :));
figure
subplot (2, 1, 1)
plot ([sh_ref, sh(:, k)])
grid on
subplot (2, 1, 2)
plot (sh_err(:, k))
grid on

[val, k] = min (mean_err);
printf ('min of mean error   : %6.3e for %s\n', val, wintype(k, :));
figure
subplot (2, 1, 1)
plot ([sh_ref, sh(:, k)])
grid on
subplot (2, 1, 2)
plot (sh_err(:, k))
grid on

[val, k] = min (sum_err);
printf ('min of sum error    : %6.3e for %s\n', val, wintype(k, :));
figure
subplot (2, 1, 1)
plot ([sh_ref, sh(:, k)])
grid on
subplot (2, 1, 2)
plot (sh_err(:, k))
grid on

[val, k] = min (stddev_err);
printf ('min of std dev error: %6.3e for %s\n', val, wintype(k, :));
figure
subplot (2, 1, 1)
plot ([sh_ref, sh(:, k)])
grid on
subplot (2, 1, 2)
plot (sh_err(:, k))
grid on

%for (k = 1 : 22)
%    figure
%    subplot (2, 1, 1)
%    plot ([sh_ref, sh(:, k)])
%    str = sprintf ('type %s, max: %.3g, mean %.3g, sum %.3g, dev %.3g', ...
%                   wintype(k, :), max_err(k), mean_err (k), sum_err (k), ...
%                   stddev_err (k));
%    grid on
%    subplot (2, 1, 2)
%    plot (sh_err(:, k))
%    title (str);
%    grid on
%end

%!demo
%! sr = 192e3;
%! %n = 16;
%! %f = 16e3;
%! %t = (0:round(n*sr/f)-1)' / sr;
%! %s = sin (2*pi*f*t);
%! t = (0:1535)' / sr;
%! %s = hann (length (t)) .* chirp (t, 27e3, t(end), 29e3);
%! s = chirp (t, 27e3, t(end), 29e3);
%! z = zeros (length (t), 1);
%! s = [z; s; z];
%! test_hilbert_coeff (s, 64, 0);
