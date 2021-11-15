function n = audiotrans(x, w0, n_min)

% TODO w0 = 100Hz -> step = ??
sr = 44100;
if (nargin < 2)
    w0 = 20/sr
end
if (nargin < 2)
    %n_min = floor ((1 / w0) / 2);
    n_min = floor (1 / w0);
end
y = audioshape(x, w0);
dy = diff(y);
thr = max(abs(dy))/10;
n_rises = find(dy > +thr) + 1;
% peaks starting
n = [n_rises(1); n_rises(find(diff(n_rises) > n_min)+1)];

if (nargout == 0)
    yy = max(abs(x)) * y / max(abs(y));
    plot([x, yy]);
    xlim([1, length(x)])
    xticks(n);
    grid on;
    clear n;
    clear y;
end

