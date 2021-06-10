function test_ssb_filter (norder)

N_WIN = 7;
WIN = cell (N_WIN, 1);
WIN{1} = 'hamming';
WIN{2} = 'hann';
WIN{3} = 'bartlett';
WIN{4} = 'triang';
WIN{5} = 'gausswin';
WIN{6} = 'barthannwin';
WIN{7} = 'blackman';

N = zeros (32768, N_WIN);
for n = 1:N_WIN
   [b, H(:,n)] = blu_filter (norder, 0, WIN{n});
end

figure
plot (20 * log10 (abs (H(1:1000, :))))
n_str = num2str (norder);
grid on;
legend (WIN)
title (['Ordre ', n_str]);

