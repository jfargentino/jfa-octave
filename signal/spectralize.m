function S = spectralize (Sabs, mid)
%
% function S = spectralize (Sabs [, mid])
% 
% To construct the spectrum 'S' of a pure real signal
% from the absolute value of it's spectrum's positive
% frequencies part 'Sabs'.
% 'mid' (0 per default) correspond to the -Fs/2 channel
% value.
%

sqrt2 = sqrt (2);
X = abs (Sabs (:));
if (nargin < 2)
    Xrev  = flipud (X);
    Xeven = [X; +Xrev] / sqrt2;
    Xodd  = [X; -Xrev] / sqrt2;
else
    %Xrev  = flipud (X(2:end));
    Xrev  = flipud (X(1:end-1));
    Xeven = [X; mid*sqrt2; +Xrev] / sqrt2;
    Xodd  = [X; 0        ; -Xrev] / sqrt2;
end
S     = Xeven + i*Xodd;

%!demo
%! Sabs = [1:1024, 1023:-1:0]';
%! S = spectralize (Sabs);
%! N = 0 : 2*length (Sabs) - 1;
%! plot (N, real (S), N, imag (S))

