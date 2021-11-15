function [idx, m, h] = shapeseg (s, w)

if (nargin < 2)
    w = 256;
end

[a, h] = shape (s);
m = sliding_mean (a, w);

thr = max(m)/10;
idx = find (m < thr);

% remove too close indexes -> it keep the highest idx of each group
% head: if 1st group start at 1, keep 1 as 1st index
% tail: if end if a group keep last as last index
didx = diff(idx);
if ( (idx(1)+w <= 2) && (didx(1) <= w) )
    first_idx = 1;
else
    first_idx = 0;
end
if ( (idx(end)+w >= length(s)-1) && (didx(end) <= w) )
    last_idx = 1;
else
    last_idx = 0;
end
idx = idx(find(didx > w));
if (first_idx == 1)
    idx(1) = 1;
end
if (last_idx == 1)
    idx = [idx; length(s)];
end

if (nargout == 0)
    plot([s, [zeros(w-1, 1); m]]);
    xticks(idx);
    grid on;
    clear idx;
    clear m;
    clear h;
end

