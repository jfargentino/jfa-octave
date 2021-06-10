% Verify peak height, width and integral, function of bandwidth
fsr = 192e3;
f0  = 12e3;
n0  = round (10 * fsr / f0);
nz  = 4*n0;
t   = (0:n0-1)' / fsr;
s   = sin (2*pi*f0*t);

x  = [zeros(nz, 1); s; zeros(nz, 1)];
bw = (fsr / n0) * (0.05:0.05:2);
y  = baseband (x, f0 * ones(size(bw)), fsr, bw);
[v_peak, n_peak] = max (y);

figure
subplot (2, 2, 1)
imagesc (bw/1e3, 1e3*[0 length(x)-1]/fsr, y);
xlabel ('bandwidth (kHz)');
ylabel ('time (ms)');

subplot (2, 2, 2)
plot (1e3*(0:length(x)-1)'/fsr, y);
xlabel ('time (ms)');
set (gca, 'Xtick', 1e3*[nz, nz + n0]/fsr);
grid on

subplot (2, 2, 3)
plot (bw/1e3, v_peak);
xlim([bw(1) bw(end)]/1e3);
set (gca, 'Xtick', bw/1e3);
xlabel ('bandwidth (kHz)');
ylabel ('peak maximum value');
grid on

subplot (2, 2, 4)
plot (bw/1e3, fsr ./ (1e3*(n_peak - nz)));
xlim([bw(1) bw(end)]/1e3);
set (gca, 'Xtick', bw/1e3);
xlabel ('bandwidth (kHz)');
ylabel ('1 / peak delay (kHz)');
grid on

