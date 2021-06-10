function imout = padimg (imin, rmod, cmod)
%
% function imout = padimg (imin, rmod, cmod)
% Pad an image so its number of row is a multiple of rmod, and its number of 
% is a multiple of cmod.
%
% TODO why padarray doen't work as expected
%

imout = imin;
[r, c, d] = size (imout);
rp = mod (r, rmod);
if (rp ~= 0)
   rp = rmod - rp;
   pad = zeros (rp, c, d);
   imout = [imout; pad];
   r = r + rp;
end
cp = mod (c, cmod);
if (cp ~= 0)
   cp = cmod - cp;
   pad = zeros (r, cp, d);
   imout = [imout, pad];
   c = c + cp;
end

