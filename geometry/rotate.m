function [Q, M] = rotate (P, O, n, alpha)
%
% function Q = rotate (P, O, n, alpha)
% Rotate P among the axis of direction n which pass through point O.
%
% Can be checked with http://twist-and-shout.appspot.com/
% 

[P, adj] = adjust_dim (P);
[dim, np] = size (P);
O = repmat (O, 1, np);

% 1st method, translate for the rotation axe to pass through O, rotate and
% translate back
[Qt, Mt] = rotate_center (P - O, n, alpha);
Q = Qt + O;

if (nargout > 1)
    % 2nd method: use homogeneous coordinates ([x; y; z] becomes [x; y; z; 1]),
    % thus we have M = T^-1 * Mt * T where
    % Mt is the "homogeneous" rotation matrix, and T is the translation matrix
    Tp = eye (4);
    Tp(1:3, 4) = -O(:, 1);
    Tn = eye (4);
    Tn(1:3, 4) = +O(:, 1);
    Mt = [Mt, zeros(3, 1); zeros(1, 3), 1];
    M = Tn * Mt * Tp;
    P = [P; ones(1, np)];
    Q = zeros (4, np);
    for n = 1:np
        Q(:, n) = M * P(:, n);
    end
    Q = Q(1:3, :);
end

if (adj)
    Q = Q';
end

%!demo
%!
%! P0 = [12; 2; -20];
%! P1 = [23; 40; 1];
%! P2 = [29; 12; 20];
%!
%! %R0 is the -20° rotation along [PO P1] of P2
%! R0 = [18.436; 13.638; 22.569]
%! [Q0, M] = rotate (P2, P0, P1-P0, -20*pi/180)
%! [Q1, M] = rotate (Q0, P0, P1-P0, +20*pi/180)
%! Q1 - P2

