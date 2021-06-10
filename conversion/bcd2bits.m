function bits = bcd2bits (val)
%
% function bits = bcd2bits (val)
%
% Convert val into its BCD binary representation used by the IRIG format
% This representation takes 9 bits:
%               | 0 | 1 | 2 | 3 | 4 | 5 | 6 | 7 | 8 | 
%               | 1 | 2 | 4 | 8 | - | 10| 20| 40| 80|
% val must be strictly less than 100
% Returns a 9 elements row with bits value.
%

y = val;
bits = zeros (9, 1);
if (y >= 80)
    bits(9) = 1;
    y = y - 80;
end
if (y >= 40)
    bits(8) = 1;
    y = y - 40;
end
if (y >= 20)
    bits(7) = 1;
    y = y - 20;
end
if (y >= 10)
    bits(6) = 1;
    y = y - 10;
end
if (y >= 8)
    bits(4) = 1;
    y = y - 8;
end
if (y >= 4)
    bits(3) = 1;
    y = y - 4;
end
if (y >= 2)
    bits(2) = 1;
    y = y - 2;
end
if (y >= 1)
    bits(1) = 1;
    y = y - 1;
end
if (y > 0)
    % TODO
end

%!demo
%! val = 5, bcd2bits (val)', bits2bcd (bcd2bits (val)),
%! val = 15, bcd2bits (val)', bits2bcd (bcd2bits (val)),
%! val = 59, bcd2bits (val)', bits2bcd (bcd2bits (val)),
%! val = 99, bcd2bits (val)', bits2bcd (bcd2bits (val)),

