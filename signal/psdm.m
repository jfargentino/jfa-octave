function Smean = psdm (s, w, overlap, remove_mean)
%
% function Smean = psdm (s, w, overlap, remove_mean)
%
%    To get the mean of several power spectral densities done on the signal 's'
% at different time.
%    If the signal length is not a multiple of the PSD length, the last samples
% are zero-padded to calculate the last PSD. TODO an option we're taking only
% an integer nb of PSD and the last samples are discarded.
%    'w' is the window to use if it's an array of value, or the number of
% samples to use for each PSD (i.e. the size of the rectangular window to use).
%    'overlap' is the number of overlapping samples between each PSD. None per
% default.
%    If 'remove_mean' is 1, each window remove its own mean before to do the
%PSD. It is disabled by default.
%

[r, c] = size (s);

if (nargin < 4) 
    remove_mean = 0;
end
if (nargin < 3) 
    overlap = 0;
end
if (nargin < 1) 
    w = 1;
end
if (length(w) == 1)
    n = w;
    w = ones (n, 1);
else
    n = length(w);
end

Smean = zeros(n, c);
for (k = 1:c)
    % TODO optionally not zero-pad the last PSD
    s_cut = cut (s(:, k), n, overlap, 1);
    [n, m] = size(s_cut);
    w_cut = repmat(w, 1, m);
    sw = s_cut .* w_cut;
    if (remove_mean > 0)
        sw = sw - repmat(mean(sw), n, 1);
    end
    Sw = psd(sw);
    Smean(:, k) = mean(Sw, 2);
end

