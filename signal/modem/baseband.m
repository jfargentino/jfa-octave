function [y, yi, yq] = baseband (x, fc, fsr, fdev)

[row, col] = size (x);
order = 2;

if (nargin < 4)
    fdev = 0.001;
end

t = repmat ((0:(row-1))' / fsr, 1, col);
if (length (fc) == 1)
    if (fdev > 1)
        % TODO doesn't it make sense to cut > fc ?
        [b, a] = butter (order, 2*fdev / fsr);
    else
        [b, a] = butter (order, 2*fdev*fc / fsr);
    end
    yq = filter (b, a, x .* sin (2*pi*fc*t));
    yi = filter (b, a, x .* cos (2*pi*fc*t));
else
    yq = zeros (row, length (fc));
    yi = zeros (row, length (fc));
    if (length (fdev) == 1)
        fdev = fdev * ones (size (fc));
    end
    if (max (fdev) < 1)
        % relative frequencies cut
        fdev = fdev .* fc;
    end
    for (k = 1:length (fc))
        [b, a] = butter (order, 2*fdev(k) / fsr);
        yq(:, k) = filter (b, a, x .* sin (2*pi*fc(k)*t));
        yi(:, k) = filter (b, a, x .* cos (2*pi*fc(k)*t));
    end
end
y = 2 * sqrt (yi.*yi + yq.*yq);

%!demo
%!
%! fsr = 192e3;
%! ns  = 8192;
%! nz  =  8192;
%! t   = (0:(ns - 1))' / fsr;
%! f0  = 32e3;
%! %s   = chirp (t, f0/2, t(end), 2*f0);
%! s   = [sin(2*pi*0.9*f0*t); 0.33*sin(2*pi*f0*t); sin(2*pi*1.1*f0*t)];
%! %s   = sin(2*pi*0.50*f0*t) + 0.33*sin(2*pi*f0*t) + sin(2*pi*1.5*f0*t);
%!
%! x = [zeros(nz, 1); s; zeros(nz, 1)] + 0.50 * randn (2*nz + length(s), 1);
%! y = baseband (x, f0, fsr, 0.01);
%!
%! t = (0:(length(s) + 2*nz - 1))'/fsr;
%! plot (t, x, t, y)
%! %plot (t, y)
%! xlim([t(1) t(end)])
%! set (gca, 'Xtick', [t(nz), t(nz + ns), t(nz + 2*ns), t(nz + 3*ns)]);
%! grid on
