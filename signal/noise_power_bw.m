function npb = noise_power_bw (w)

W = fold_psd (psd (w));
npb = sum (W, 1) ./ max (W);

