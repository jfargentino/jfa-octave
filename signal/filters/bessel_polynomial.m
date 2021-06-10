function Cn = bessel_polynomial (n)

Cn = zeros (1, n + 1);
Cn (1) = 1;
Cn (2) = 1;
for m = 3 : (n+1)
   Cn(m) = Cn(m - 1) * 2 * (n - m + 2) / ((m-1) * (2*n - m + 2));
end
Cn = Cn (end:-1:1);
