function y = karplus_strong (x, dissipation, rnd)
%
% function y = karplus_strong (x, dissipation, rnd)
%
% Simulate the plucking of a guitar string. X is a displacement vector,
% it returns the displacement vector after n simulation round.
%

if (nargin < 3)
    rnd = 1;
end
if (nargin < 2)
    dissipation = 0.996;
end

[r, c] = size(x);
y = zeros(r, rnd*c);
y(:, 1:c) = x;
tmp = x;
for (n = 1:rnd)
    tmp = [tmp(2:end, :); dissipation*mean(tmp(1:2, :))];
    y(:, n*(1:c)) = tmp;
end

%!demo
%! x = [(0:0.01:1)'; (0.99:-0.01:0)'];
%! for (n = 1:1000)
%!    x = karplus_strong(x);
%!    plot (x);
%! end
