function [n, v, y] = findtrans(x, w, ratio, dist_min, crude)
%
% function n = findtrans(x, w, ratio, dist_min, crude)
%
% Returns index where transients are found in x.
% The instantaneous amplitude of 'x' is done. A sliding variance of length 'w'
% is done where we're looking for the higher 'ratio' samples only.
% We remove indexes closer than 'dist_min'.
%
% x: input signal
% w: slinding variance window length, 511, per default
% ratio: ratioage of the population for the threshold, 5% per default
% dist_min: distance between indexes so they are contiguous, w per default
% crude: replace shape(x) by abs(x) if > 0, 0 per default
% n: transients indexes
% v: sliding variance
% y: instantaneous amplitude as returned by shape.m
%
[R, C] = size(x);

if (nargin < 2)
    % looks good for 44100kHz
    w = 511;
end
if (nargin < 3)
    ratio = 5/100;
end
if (nargin < 4)
    %dist_min = round(w/2);
    dist_min = w;
end
if (nargin < 5)
    crude = 0;
end

% Results with instantaneous amplitude are better
if (crude > 0)
    y = abs(x);
else
    %y = shape(x);
    y = audioshape(x);
end
[cf, m, v] = crest_factor (y, w);
% m is the signal envelope
% automatic thresholding by searching for the level such that less than k%
% of the population belong to a peak
sv = sort(v);
thr = sv(R-floor(ratio*R));
n = find(v > thr);
% remove too close indexes. TODO maybe on the sorted ones ?
k = find (diff(n) > dist_min) + 1;
n  = [n(1); n(k)];

if (nargout == 0)
    vv = max(abs(x)) * v / max(abs(v));
    plot([x, vv]);
    xlim([1, length(m)])
    xticks(n);
    grid on;
    clear n;
    clear v;
    clear y;
end

