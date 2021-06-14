function y_dB = specimg(x, dB_scale)
%
% function y_dB = specimg(x[, dB_scale])
% 
% Returns a grayscaled image of given spectral data x.
% Converts x in dB 1st (with 10*log10), shift its max to 0dB, and clips
% everything below dB_scale (60dB per default).
% Then rescale thus 0dB -> 255 and -dB_scale -> 0, and values are 'uint8'.
%
if (nargin < 2)
    dB_scale = 60;
end
x_dB = 10*log10(x);
max_dB = max(max(x_dB));
% shift, max is 0dB
x_dB = x_dB - max_dB;
% clip, nothing under -dB_scale
x_dB(find (x_dB < -dB_scale)) = -dB_scale;

% x_dB between dB_scale and 0, rescale it between 0 and 255
y_dB =  uint8(round (255 * (x_dB + dB_scale) / dB_scale));

if (nargout == 0)
    image(y_dB);
    clear y_dB;
end

