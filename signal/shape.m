function [a, h] = shape (s)
%
% function a = shape (s)
%
% Compute the instantaneous envelope of signal s thanks to its hilbert
% transform. h is the hilbert transform given by OCTAVE imag(hilbert(s)).
%

% 10 time slower implementation
%h = imag(hilbert(s));
%s2 = s .* s;
%h2 = h .* h;
%a = sqrt (s2 + h2);

h = hilbert(s);
a = sqrt(h .* conj(h));
h = imag(h);

%!demo
%!
%! x = randn(32*1024,1);
%!
%! tic
%! h = hilbert(x);
%! a1 = sqrt(h .* conj(h));
%! toc
%!
%! tic
%! h = imag(hilbert(x));
%! a2 = sqrt (x.*x + h.*h);
%! plot(a1-a2)
%! toc


