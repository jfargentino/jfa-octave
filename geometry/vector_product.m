function w = vector_product (u, v)

w = [ u(2) * v(3) - u(3) * v(2); ...
      u(3) * v(1) - u(1) * v(3); ...
      u(1) * v(2) - u(2) * v(1) ];

% An alternative is
% w = (skew_symmetric (u) * v')';
