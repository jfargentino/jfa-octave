function ShowWindows (N, bN)
% function ShowWindows (N, bN)
%   N windows sizes
%   bN is for the kaiser windows, better results with 4 <= bN <= 9
%   Display many ponderation windows and their power spectral density
%

if (nargin == 0)
    N  = 512;
    bN = 9;
end

if (nargin == 1)
    bN = 9;
end
b = N / bN;

RECT     = ones     (N, 1);
TRIANG   = triang   (N);
HAMMING  = hamming  (N);
HANNING  = hann  (N);
BLACKMAN = blackman (N);
KAISER   = kaiser   (N, b);
BARTLETT = bartlett (N);
FLATTOP  = flattopwin (N);
BLACKMANHARRIS = blackmanharris (N)';
BOHMAN = bohmanwin (N)';
CHEBY = chebwin (N, 0);
GAUSS = gausswin (N);
NUTTALL = nuttallwin (N)';
PARZEN = parzenwin (N)';
TUKEY = tukeywin (N);
BARTHAN = barthannwin (N)';

W = [RECT, TRIANG, HAMMING, BLACKMAN, KAISER, ...
     HANNING, BARTLETT, FLATTOP, BLACKMANHARRIS, ...
     BOHMAN, CHEBY, GAUSS, NUTTALL, ...
     PARZEN, TUKEY, BARTHAN ];

TITRE = ['uniform'; 'triang'; 'hamming'; 'blackman'; 'kaiser'; ...
         'hann'; 'bartlett'; 'flat top'; 'blackman harris'; ...
         'bohman'; 'chebyshev'; 'gauss'; 'nuttall'; ...
         'parzen'; 'tukey'; 'Bartlett Hann'];

if (nargout == 0)
    [NN, M] = size (W);
    %z = zeros (N/2, M);
    %Wz = [z; W; z];
    Wz = W;
    close all;
    for (p = 1:M)
        figure (p);
        subplot (2, 1, 1);
        plot (Wz(:, p));
        title (TITRE(p, :));
        grid on;
        subplot (2, 1, 2);
        Wpsd = 10 * log10 (fold_psd (psd (Wz(:, p))));
        max_str = num2str (max (Wpsd));
        plot (Wpsd);
        title (['Max ', max_str, ' dB']);
        grid on;
    end
end
