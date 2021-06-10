function test_noises ()
% test_noises.m

N  = 65536;
Fs = 96000;
F  = 10000;
Wc = 2 * F / Fs;
Rp = 0.01;
Rs = 3;
As = 96;
f  = Fs * (0:(N/2-1)) / N;

gaussian_noise    = randn (1, N);
gaussian_variance = var (gaussian_noise);
fig = 1;
figure  (fig);
histfit (gaussian_noise);
title   ('Histogramm of the full band noise'),

%%% Butter
fig = 2;
[b_butter, a_butter] = butter (4, Wc);
butter_noise         = filter (b_butter, a_butter, gaussian_noise);
butter_variance      = var (butter_noise);
butter_psd           = 10 * log (psd (butter_noise));
figure (fig);
plot   (f, butter_psd (1:N/2));
grid   ('on')
title  ('PSD of a butterworth filtered noise');
xlabel ('frequencies in Hz');
ylabel ('dB');
figure (fig + 1);
histfit (butter_noise);
title   ('Histogramm of the butterwoth filtered noise')
disp   ('BUTTERWORTH'),
disp   ('variance of noise filtered with butterwoth:'),
disp   (butter_variance),
disp   ('Variances rate:'),
disp   (butter_variance / gaussian_variance),
disp   ('Pass band rate:'),
disp   (Wc),
disp   ('');

%%% Cheby1
fig = fig + 2;
[b_cheby1, a_cheby1] = cheby1 (4, Rp, Wc);
cheby1_noise         = filter (b_cheby1, a_cheby1, gaussian_noise);
cheby1_variance      = var (cheby1_noise);
cheby1_psd           = 10 * log (psd (cheby1_noise));
figure (fig);
plot   (f, cheby1_psd (1:N/2));
grid   ('on')
title  ('PSD of a cheby1 filtered noise');
xlabel ('frequencies in Hz');
ylabel ('dB');
figure (fig + 1);
histfit (cheby1_noise);
title   ('Histogramm of the cheby1 filtered noise')
disp   ('CHEBY 1')
disp   ('variance of noise filtered with cheby1:'),
disp   (cheby1_variance),
disp   ('Variances rate:'),
disp   (cheby1_variance / gaussian_variance),
disp   ('Pass band rate:'),
disp   (Wc),
disp   (''),

%%% Cheby2
%fig = fig + 2;
%[b_cheby2, a_cheby2] = cheby2 (4, Rs, Wc);
%cheby2_noise         = filter (b_cheby2, a_cheby2, gaussian_noise);
%cheby2_variance      = var (cheby2_noise);
%cheby2_psd           = 10 * log (psd (cheby2_noise));
%figure (fig);
%plot   (f, cheby2_psd (1:N/2));
%grid   ('on')
%title  ('PSD of a cheby2 filtered noise');
%xlabel ('frequencies in Hz');
%ylabel ('dB');
%disp   ('variance of noise filtered with cheby2:'),
%disp   (cheby2_variance),
%disp   ('Variances rate:'),
%disp   (cheby2_variance / gaussian_variance),
%disp   ('Pass band rate:'),
%disp   (Wc),
%figure (fig + 1);
%histfit (cheby2_noise);
%title   ('Histogramm of the cheby2 filtered noise')

%%% Ellip
fig = fig + 2;
[b_ellip, a_ellip ] = ellip  (4, Rp, As, Wc);
ellip_noise         = filter (b_ellip, a_ellip, gaussian_noise);
ellip_variance      = var (ellip_noise);
ellip_psd           = 10 * log (psd (ellip_noise));
figure (fig);
plot   (f, ellip_psd (1:N/2));
grid   ('on')
title  ('PSD of a ellip filtered noise');
xlabel ('frequencies in Hz');
ylabel ('dB');
figure (fig + 1);
histfit (ellip_noise);
title   ('Histogramm of the ellip filtered noise')
disp   ('ELLIP'),
disp   ('variance of noise filtered with ellip:'),
disp   (ellip_variance),
disp   ('Variances rate:'),
disp   (ellip_variance / gaussian_variance),
disp   ('Pass band rate:'),
disp   (Wc),
disp   (''),
