function bits = time2bits (doy, hour, mn, sec)
% 
% function bits = time2bits (doy, hour, mn, sec)
% 
% Convert a date into its bitstream as specified by the IRIG format.
% doy is the day of year from 0 to 365.
%

sbits = bcd2bits (sec);
sbits = sbits (1:end - 1);
mbits = bcd2bits (mn);
hbits = bcd2bits (hour);
if (doy >= 100)
    doy0 = mod (doy, 100);
    doy1 = (doy - doy0) / 100;
else
    doy0 = doy;
    doy1 = 0;
end
d0bits = bcd2bits (doy0);
d1bits = bcd2bits (doy1);

dsec = sec + 60 * mn + 3600 * hour;
dsbits = dec2bin (dsec) - dec2bin (0);
dsbits = dsbits (end:-1:1)';
z2 = zeros (19 - length (dsbits), 1);
dsbits = [dsbits; z2];
dsbits = [dsbits(1:9); -1; dsbits(10:18)];

z     = zeros (9, 1);
bits = [-1; sbits; -1; mbits; -1; hbits; -1; d0bits; -1; d1bits; -1; ...
         z; -1; z; -1; z; -1; dsbits; -1];

