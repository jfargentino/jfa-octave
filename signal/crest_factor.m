function [y, m, v] = crest_factor (x, w)
%
% function [y, m, v] = crest_factor (x, w)
%
% y: Crest factor of x on a sliding windows of length w.
% m: sliding mean
% v: sliding variance
%

[R, C] = size(x);
w2 = floor(w / 2);
w  = 2*w2 + 1;
z  = zeros(w2, C);
xp = [z; x; z];

% mean
m = cumsum ([xp(1:w, :); xp(w+1:end, :) - xp(1:end-w, :)]) / w;

c2 = (xp - m) .* (xp - m);

% variance
% TODO why the result is sligtly different from its sliding_fun counterpart ?
v = cumsum ([c2(1:w, :); c2(w+1:end, :) - c2(1:end-w, :)]) ./ (w-1);

% remove pading and recenter (1+w2/2 -> 1)
m = m(w:end, :);
v = v(w:end, :);
c2 = c2(w:end, :);

% crest factor
y = c2 ./ v;

if (nargout == 0)
    plot([x, m, v, y]);
    xlim([1, length(x)]);
    legend('x', 'mean', 'var', 'crest factor');
    grid on;
    clear y;
    clear m;
    clear v;
end

%!demo
%! 
%! N = 4096;
%! w = 127;
%! x = randn(N, 1);
%! tic, [y, m, v] = crest_factor(x, w); toc
%! tic, m2 = sliding_fun(x, w, 'mean'); toc
%! tic, v2 = sliding_fun(x, w, 'var'); toc
%! w2 = floor(w/2);
%! figure
%! m = m(w2+1:end-w2);
%! plot([m, m2, m-m2]);
%! grid on;
%! xlim([1,N-w]);
%! title('sliding mean');
%! legend ('v2', 'sliding_fun', 'diff');
%! figure
%! v = v(w2+1:end-w2);
%! plot([v, v2, v-v2]);
%! grid on;
%! xlim([1,N-w]);
%! title('sliding variance');
%! legend ('v2', 'sliding_fun', 'diff');
%!
