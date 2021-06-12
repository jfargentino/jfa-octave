function [a, h] = shape (s)
%
% function a = shape (s)
%
% Compute the instantaneous envelope of signal s thanks to its hilbert
% transform. h is the hilbert transform imag(hilbert(s)).
%

h = imag(hilbert(s));
s2 = s .* s;
h2 = h .* h;
a = sqrt (s2 + h2);

