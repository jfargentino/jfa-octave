function z = mandelbrot (k, x, y, n)

%http://www.goudaforever.com/public/Fractales/Entrees/2010/8/8_Voyages_en_Orient.html

stp = 1024;

if (nargin < 4)
    n = 2;
end
if (nargin < 3)
    y = linspace (-1.0, +1.0, stp);
end
if (nargin < 2)
    x = linspace (-1.5, +0.5, stp);
end
if (nargin < 1)
    k = 32;
end

x = sort (x(:))';
y = sort (y(:));

c = repmat(x, length(y), 1) + i*repmat(y, 1, length(x));
z = zeros (size (c));

for kk = 1 : k
    nn = find (abs (z) <= 2);
    z(nn) = z(nn).^n + c(nn);
end

if (nargout == 0)
    % TODO smooth coloring
    imagesc (x, y, exp (-abs (z)));
    %mesh (x, y, exp (-abs (z)));
    %surf (x, y, exp (-abs (z)));
    xlim ([min(x), max(x)])
    ylim ([min(y), max(y)])
    title (sprintf('Zn+1 = Zn^%f + C, %d iterations', n, k));
    colorbar;
    clear z;
end

%!demo
%! stp = 2048;
%! x = linspace (-1.5, +0.5, stp);
%! y = linspace (-1.0, +1.0, stp);
%! k = 128;
%! figure, mandelbrot (k, x, y, 2);

%!demo
%! stp = 512;
%! x = linspace (-2, +2, stp);
%! y = linspace (-2, +2, stp);
%! k = 16;
%! for n = 2 : 0.01 : 3
%!      mandelbrot (k, x, y, n); drawnow
%! end

%!demo
%! stp = 1024;
%! k = 32;
%! zf = 0.75;
%! nb  = 32;
%! xc = -1.495; xr = 0.1; yc = 0.0; yr = 0.5;
%! for n = 1 : nb
%!      xr = xr * zf; yr = yr *zf;
%!      x = linspace (xc-xr, xc+xr, stp);
%!      y = linspace (yc-yr, yc+yr, stp);
%!      mandelbrot (round (k/zf), x, y, 2); drawnow
%! end

%!demo
%! stp = 1024;
%! k = 32;
%! zf = 0.75;
%! nb  = 32;
%! %xc = -1.495; xr = 0.1; yc = 0.0; yr = 0.5;
%! xc = 1.643721971153e-3; xr = 0.1; yc = 8.22467633298876e-1; yr = 0.5;
%! x = zeros (stp, nb);
%! y = zeros (stp, nb);
%! z = exp(-abs (mandelbrot (zf, x(:, 1), y(:, 1), 2)));
%! for n = 2 : nb
%!      xr = xr * zf; yr = yr *zf;
%!      x(:, n) = linspace (xc-xr, xc+xr, stp);
%!      y(:, n) = linspace (yc-yr, yc+yr, stp);
%!      k       = round (k / zf);
%!      ztmp    = exp(-abs (mandelbrot (k, x(:, n), y(:, n), 2)));
%!      z       = cat (3, z, ztmp);
%! end
%! for n = 1 : nb
%!      imagesc (x(:, n), y(:, n), z(:, :, n));
%!      drawnow
%! end

