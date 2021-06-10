function y = wrap (x, bound)
%
% function y = wrap (x, bound)
% 
% Wrap "x" to be bounded by [-bound, +bound[. bound is pi per default.
%

if (nargin < 2)
    bound = pi;
end

y = x - 2*bound* fix((x + sign(x) * bound)/(2*bound));
