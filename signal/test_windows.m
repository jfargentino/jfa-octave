Fs = 96000;
F0 = 1000;
N  = 65536;
dn = 16;
A  = 1;

% Signal and noise definition
N0 = round (N * F0 / Fs);
t = (0:(N-1))' / Fs;
f = (0:(N-1))' * Fs / N;
s = A * sin (2*pi*F0*t);
vs = var (s);
r = A * randn (N, 1);
vr = var (r);

win_type = ['uniform'; 'Hamming'; 'Hann'; 'Tukey'; 'cosine'; ...
            'Lanczos'; 'Bartlett'; 'Triangular'; 'Gauss'; 'Bartlett-Hann'; ...
            'Blackman'; 'Kaiser'; 'Nuttall'; 'Blackman-Harris'; ...
            'Blackman-Nuttall'; 'flat top'];

wn = 16;
w = zeros (N, wn);
% High-resolution windows
w(:,  1) = ones (N, 1);                 % uniform
w(:,  2) = hamming (N);                 % hamming
w(:,  3) = hann (N);                    % hann
w(:,  4) = tukeywin (N, 0.5);           % tukey
w(:,  5) = sin (pi*(0:N-1)'/(N-1));     % cosine
w(:,  6) = sinc (2*(0:N-1)'/(N-1) - 1); % Lanczos
w(:,  7) = bartlett (N);                % bartlett
w(:,  8) = triang (N);                  % triangular
w(:,  9) = gausswin (N, 3);             % gaussian
w(:, 10) = barthannwin (N)';            % bartlett-hann
w(:, 11) = blackman (N);                % blackman
w(:, 12) = kaiser (N, 8);               % kaiser
% Low-resolution windows
w(:, 13) = nuttallwin (N)';             % nuttal
w(:, 14) = blackmanharris (N)';         % blackman-harris
w(:, 15) = blackmannuttall (N);         % blackman-nuttall
w(:, 16) = flattopwin (N);              % flat top
% windows normalization factors
nf = win_norm_factor (w);
% Windows PSD
W = fold_psd (psd (w));
mW = max (W);
% Windows coherent gains
cg = coherent_gain (w);
% Windows noise power banwidth
npb = noise_power_bw (w);

file = fopen ('windows.csv', 'w');

% Windows parameters
fprintf (file, '# WINDOW \t');
fprintf (file, 'MAX PSD\t(dB);\t')
fprintf (file, 'COHERENT GAIN\t(dB);\t');
fprintf (file, 'NOISE POWER BW\t(dB);\t');
fprintf (file, 'NOMALIZATION FACTOR\t(dB);\t');
fprintf (file, '\n');
for k = 1:wn
   fprintf (file, '%s \t', win_type(k, :));
   fprintf (file, '%f \t%f;\t', max (mW(k)), 10 * log10 (mW(k)));
   fprintf (file, '%f \t%f;\t', cg(k), 20 * log10 (cg(k)));
   fprintf (file, '%f \t%f;\t', npb(k), 10 * log10 (npb(k)));
   fprintf (file, '%f \t%f;\t', nf(k), 10 * log10 (nf(k)));
   fprintf (file, '\n');
end

fprintf (file, '\n# WINDOW \t')
fprintf (file, 'SUM ON %d CENTRAL SIGNAL PSD BINS\t(dB);\t', 2*dn + 1);
fprintf (file, 'WINDOWED SIGNAL VARIANCE\t(dB);\t');
fprintf (file, 'SIGNAL VARIANCE RATIO\t(dB);\t');
fprintf (file, '\n');
for k = 1:wn
   % Signal Power Spectral Density
   S = fold_psd (psd (w(:, k) .* s));
   % Windowed signal variance
   vws = var (w(:, k) .* s);
   % record
   fprintf (file, '%s \t', win_type(k, :));
   % Signal characteristics
   fprintf (file, '%f \t%f;\t', ...
            sum (S (N0-dn:N0+dn)), ...
            10 * log10 (sum (S (N0-dn:N0+dn))));
   fprintf (file, '%f \t%f;\t', vws, 10 * log10 (vws));
   fprintf (file, '%f \t%f;\t', vws / vs, 10 * log10 (vws) - 10 * log10 (vs));
   fprintf (file, '\n');
end

fprintf (file, '\n# WINDOW \t')
fprintf (file, 'SUM OFF NOISE PSD\t(dB);\t');
fprintf (file, 'WINDOWED NOISE VARIANCE\t(dB);\t');
fprintf (file, 'NOISE VARIANCE RATIO\t(dB);\t');
fprintf (file, '\n');
for k = 1:wn
   % Noise Power Spectral Density
   R = fold_psd (psd (w(:, k) .* r));
   % Windowed noise variance
   vwr = var (w(:, k) .* r);
   % record
   fprintf (file, '%s \t', win_type(k, :));
   % Noise characteristics
   fprintf (file, '%f \t%f;\t', sum (R), 10 * log10 (sum (R)));
   fprintf (file, '%f \t%f;\t', vwr, 10 * log10 (vwr));
   fprintf (file, '%f \t%f;\t', vwr / vr, ...
           10 * log10 (vwr) - 10 * log10 (vr));
   fprintf (file, '\n');
end

fclose (file);

for k = 1:wn
   figure
   S = fold_psd (psd (s .* w(:, k)));
   plot (f(N0-dn:N0+dn), 10 * log10 (S (N0-dn:N0+dn)))
   title (win_type(k, :));
   xlabel ('Hz');
   ylabel ('dB');
   grid on
end
