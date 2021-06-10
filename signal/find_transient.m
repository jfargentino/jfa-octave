function [n_begin, n_end, dvar] = find_transient (s, trans_size, threshold)

stp = floor (trans_size / 4);
[lv, rv, N] = sliding_var (s, stp, stp);

% Transient are area with high variance transition slope
dvar        = abs (diff (rv - lv));
m           = max (dvar);
n           = find (dvar >= threshold * m);
N_trans     = N(n);

% Remove last indexes if necessary
while (N_trans(end) + trans_size > length (s))
   N_trans = N_trans(1:end - 1);
end

% Collect contiguous indexes
dn = diff (N_trans);
rn = find (dn >= trans_size) + 1;
n_begin = N_trans(1);
n_end   = [];
for n = 1 : length (rn)
   n_end   = [n_end, N_trans(rn(n) - 1)] + trans_size;
   n_begin = [n_begin, N_trans(rn(n))];
end
n_end = [n_end, N_trans(end) + trans_size];

