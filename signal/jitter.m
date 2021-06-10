function [y, n, y0] = jitter(x, jitter_rate, downsampling_rate)

[ru, c] = size(x);
nd = (1:downsampling_rate:ru)';
[rd, cc] = size(nd);
n = repmat(nd, 1, c);
y = zeros(rd, c);
y0 = y;
for k = 1:c
    nn = nd + round(jitter_rate*randn(rd, 1));
    nn(1)  = 1;
    nn(rd) = rd;
    n(:,k) = nn;
    y0(:,k) = x(nd,k);
    y(:,k)  = x(nn,k);
end

%!demo
%! fs0 = 12000;
%! dsr = 16;
%! f1 = 110;
%! t1 = (0:dsr*fs0-1)'/(dsr*fs0);
%! s1 = sin(2*pi   *f1*t1);
%! s2 = sin(2*pi* 4*f1*t1);
%! s3 = sin(2*pi*16*f1*t1);
%! x  = [ s1, s2, s3 ];
%! 
%! jit   = 2
%! [y,n,z] = jitter(x, jit, dsr);
%! X = fold_psd(psdm(y-z, 1024));
%! plot(10 * log10(X))

%!demo
%! fs0 = 12000;
%! dsr = 16;
%! x = randn(dsr*fs0, 1);
%! 
%! jit   = 2
%! [y,n,z] = jitter(x, jit, dsr);
%! Y = fold_psd(psdm(y, 1024));
%! Z = fold_psd(psdm(z, 1024));
%! D = fold_psd(psdm(y-z, 1024));
%! plot(10 * log10(D))
%!

