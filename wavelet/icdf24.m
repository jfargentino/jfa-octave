function y = icdf24 (x, K, edges_correction, scaled)
%
% FIXME reconstruction is not perfect when edges correction is enabled, and
% for K >= n - 1 when lx = 2^n
%

if (nargin < 4)
   scaled = 1;
end
if (nargin < 3)
   edges_correction = 1;
end
if (nargin < 2)
   K = 5;
end

y = x;
[r, c] = size (x);
approx = zeros (r/2, c);
details = approx;

SQRT2 = sqrt (2);
A = 3 / 64;
B = 19 / 64;

for k = K : -1 : 1
   
    ly = length (y) / 2^k;
   
    % rescale
    if (scaled)
        y(1:ly, :) = y(1:ly, :) / SQRT2;
        y(ly+1:2*ly, :) = y(ly+1:2*ly, :) * SQRT2;
    end

    % approximation
    n = 3:ly-1;
    if (edges_correction)
        approx(1, :) = y(1, :) - y(ly+1, :)/2;
        if (ly > 1)
            approx(2, :) = y(2, :) - (y(ly+1, :) + y(ly+2, :))/4;
        end
    else
        approx(1:2, :) = y(1:2, :);
    end
    approx(n, :) = y(n, :) + A*(y(ly+n-2, :) + y(ly+n+1, :))...
                           - B*(y(ly+n-1, :) + y(ly+n, :));
    if (edges_correction)
        if (ly > 2)
            approx(ly, :) = y(ly, :) - (y(2*ly, :) + y(2*ly-1, :))/4;
        end
    else
        approx(ly, :) = y(ly, :);
    end

    % details
    n = 1:ly-1;
    details(n, :) = y(ly+n, :) + (approx(n, :) + approx(n+1, :))/2;
    if (edges_correction)
        details(ly, :) = y(2*ly, :) + approx(ly, :);
    else
        details(ly, :) = y(2*ly, :);
    end

    % resort
    y (1:2:2*ly, :) = approx(1:ly, :);
    y (2:2:2*ly, :) = details(1:ly, :);

end

%!demo
%! n = 15;
%! N = 2^n;
%! K = n-1;
%! scaled = 0;
%! edges_correction = 1;
%! t = (0:(N - 1))';
%! f0 = 0.0001;
%! fend = 0.100;
%! s = chirp (t, f0, t(end), fend) .* gaussian (N, 4 / N);
%! ws = cdf24 (s, K, edges_correction, scaled);
%! iws = icdf24 (ws, K, edges_correction, scaled);
%! plot (s -iws); grid on
