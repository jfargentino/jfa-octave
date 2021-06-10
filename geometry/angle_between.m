function alpha = angle_between (u, v)
%
% function alpha = angle_between (u, v)
%
% Return the angle between given vectors 'u' and 'v'
%
alpha = atan2 (range (vector_product (u, v)), sum (u .* v));

%!demo
%!
%! angle_between ([1; 0; 0], [0; 1; 0])
%! angle_between ([0; 1; 0], [0; 1; 0])
%! angle_between ([0; 0; 1], [0; 1; 0])
%!
