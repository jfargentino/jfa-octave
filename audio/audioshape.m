function y = audioshape (x, w0)
%
% function a = audioshape (s)
%
if(nargin < 2)
    w0 = 100/48000;
end

y = abs(x);
M0 = max(y);
[b, a] = butter (2, w0);
%z = max (filter(b, a, y), y);
z = filter(b, a, y);
M1 = max(z);
y = M0 * z / M1;

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


