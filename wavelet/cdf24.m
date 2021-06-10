function y = cdf24 (x, K, edges_correction, scaled)

%
% function y = cdf24 (x, K [, edge_correction, scaled])
%
% Cohen - Daubechies - Feauveau [2, 4] wavelet transform, AKA LeGall [2, 4].
% x must be a column vector or a matrix, then we perform the CDF24 on every
% columns.
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

ly = length (y);

SQRT2 = sqrt (2);
A = 3 / 64;
B = 19 / 64;

for k = 1:K
        
    % Details part: odd samples (MATLAB indexes begin at 1)
    n = 1 : 1 : ly/2 - 1;
    y(2*n, :) = y(2*n, :) - (y(2*n-1, :) + y(2*n+1, :)) / 2;
    if (edges_correction > 0)
        y(ly, :) = y(ly, :) - y(ly - 1, :);
    end
    % C implementation: d = y(2:2:ly) / SQRT2;

    % Approximation part: even samples need the odd ones just processed
    n = 2 : 1 : ly/2 - 2;
    if (edges_correction > 0)
        y(1, :) = y(1, :) + y(2, :)/2;
        if (ly > 3)
            y(3, :) = y(3, :) + (y(2, :) + y(4, :))/4;
        end
    end
    y(2*n+1, :) = y(2*n + 1, :) - A * (y(2*n-2, :) + y(2*n+4, :)) ...
                                + B * (y(2*n, :) + y(2*n+2, :));
    if (edges_correction > 0)
       if (ly > 2)
          y(ly-1, :) = y(ly-1, :) + (y(ly, :) + y(ly-2, :))/4;
       end
    end
    % C implementation: a = y(1:2:ly) * SQRT2;

    % Resort even samples in the first half (approximation part), odd samples
    % in the second halh (details), then details of the previous round.
    % C implementation: y = [ a; d; y(ly + 1 : end) ];
    if (scaled)
        y = [ y(1:2:ly, :) * SQRT2; ...
              y(2:2:ly, :) / SQRT2; ...
              y(ly+1:end, :) ];
    else
        y = [ y(1:2:ly, :); y(2:2:ly, :); y(ly+1:end, :) ];
    end

    % Next round we'll just processed on this round approximation part
    ly = length (y) / 2^k;

end

%!demo
%! n = 14;
%! N = 2^n;
%! K = 5;
%! scaled = 1;
%! edges_correction = 1;
%! t = (0:(N - 1))';
%! f0 = 0.0001;
%! fend = 0.100;
%! s = chirp (t, f0, t(end), fend) .* gaussian (N, 16 / N);
%! ws = cdf24 (s, K, edges_correction, scaled);
%! nk = zeros (1, K + 1);
%! subplot (K + 1, 1, 1);
%! t = 1 : (2^K) : (N-2^K+1);
%! plot (t, ws (1 : (N / 2^K)));
%! nk(1) = N / 2^K;
%! legend ('Approximation');
%! grid on;
%! for k = 1:K
%!    subplot (K + 1, 1, k + 1);
%!    level = K - k + 1;
%!    n0 = N / 2^level + 1;
%!    n1 = N / 2^(level - 1);
%!    nk(k + 1) = n1;
%!    t = (1 + 2^(level - 1)) : 2^level : (N - 2^(level - 1) + 1);
%!    plot (t, ws (n0:n1));
%!    str = sprintf ("Details of level %d", level);
%!    legend (str);
%!    grid on
%! end
%! figure
%! plot (ws);
%! l = length (ws);
%! xlim ([1, l]);
%! grid on
%! tics ('x', nk);
