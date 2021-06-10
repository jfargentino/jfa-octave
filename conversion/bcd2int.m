function n = bcd2int (bcd)
%
% function n = bcd2int (bcd)
% 
% Converts a BCD value into its integer counterpart.
%
n = 0;
base = 10;
n = mod (bcd, 16);
k = find (bcd >= 16);
while (length (k) > 0)
   bcd(k) = floor (bcd(k) / 16);
   n(k) = n(k) + base * mod (bcd(k), 16);
   base = base * base;
   k = find (bcd >= 16);
end
