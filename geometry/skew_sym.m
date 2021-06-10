function m = skew_sym (u)
%
% function m = skew_sym (u)
% returns the matrix representing the linear application:
%                  v -> u ^ v
% where ^ is the vector product.
%

m = [   0,   -u(3), +u(2); ...
      +u(3),   0,   -u(1); ...
      -u(2), +u(1),   0    ];

%!demo
%!
%! u = randn (3, 1)
%! m = skew_sym (u)
%!
%! v = randn (3, 1);
%! vector_product(u, v) - m*v
%!
