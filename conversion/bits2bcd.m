function val = bits2bcd (bitstream)
%
% function val = bits2bcd (bitstream)
%
% Convert a BCD binary representation from an IRIG signal into its value.
% Only 9 first bits of bitsream are took in account. And bitstream must be
% at least 7 bits length.
%

val = bitstream(1) * 1 + bitstream(2) * 2 ...
        + bitstream(3) * 4  + bitstream(4) * 8;

val = val + bitstream(6) * 10 + bitstream(7) * 20;

if (length (bitstream) > 7)
    val = val + bitstream(8) * 40;
end
if (length (bitstream) > 8)
    val = val + bitstream(9) * 80;
end

%!demo
%! val = 7, bcd2bits (val)', bits2bcd (bcd2bits (val)),
%! val = 23, bcd2bits (val)', bits2bcd (bcd2bits (val)),
%! val = 70, bcd2bits (val)', bits2bcd (bcd2bits (val)),
%! val = 88, bcd2bits (val)', bits2bcd (bcd2bits (val)),

