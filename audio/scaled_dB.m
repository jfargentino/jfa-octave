function x_dB = scaled_dB(x, dB_scale)
%
% function y_dB = scaled_dB(x[, dB_scale])
% 
% Returns a grayscaled image of given spectral data x.
% Converts x in dB 1st (with 10*log10), shift its max to 0dB, and clips
% everything below dB_scale (60dB per default).
% Then rescale thus 0dB -> 1 and -dB_scale -> 0.
%
if (nargin < 2)
    dB_scale = 60;
end
x_dB = 10*log10(x);
max_dB = max(max(x_dB));
% shift, max is 0dB
x_dB = x_dB - max_dB;
% clip, nothing under -dB_scale
x_dB( find( x_dB < -dB_scale ) ) = -dB_scale;

if (nargout == 0)
    imagesc(x_dB);
    clear x_dB;
end

