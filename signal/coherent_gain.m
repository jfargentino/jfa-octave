function g = coherent_gain (w)
%
% function g = coherent_gain (w)
%
% return the window coherent gain of window 'w' defined as 
%
%  g = mean (w) / max (w);
%
g = mean (w, 1) ./ max (w);

