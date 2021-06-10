function y = fxcorr (x, h)
%
% function y = fxcorr (x, h): cross-correlation between x and h using the FFT.  
%

Ly = length (x) + length (h) - 1;
% Find smallest power of 2 that is > Ly
[f,p] = log2 (Ly);
% Check if n is an exact power of 2.
if ((~isempty(f)) && (f == 0.5))
    p = p-1;
end
Ly2 = pow2 (p);

X   = fft (x, Ly2);
H   = fft (flipud (h), Ly2);
Y   = X .* H;

y   = real (fft (conj (Y))) / Ly2;
y   = y (1:1:Ly);


%!demo
%! t = (0:43999)'/44000;
%! s = sin (2*pi*1000*t);
%! tic;
%! x1 = xcorr (s, s);
%! t1 = toc
%! tic;
%! x2 = fxcorr (s, s);
%! t2 = toc
%! plot (0:length (x1) - 1, x1, 0:length (x2) - 1, x2)
%! grid on
%! var (x1 - x2)
%! mean (x1 - x2)

