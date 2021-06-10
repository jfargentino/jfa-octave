function [Q, M] = rotate_center (P, n, theta)
%
% function [Q, M] = rotate_center (P, n, theta)
%
% Rotate P of theta radian among the axis colinear to vector n that go through
% the origin.
% The rotation matrix M is built as follow:
%               M = Mxz^-1 * Mz^-1 * Rz * Mz * Mxz
% where:
%    -Mxz is the rotation matrix about z axis that make n vector lying into
%     xz plane (head, yaw, pan)
%    -Mz is the rotation matrix about y axis that make that previous vector
%     lying along the z axis (pitch, tilt)
%    -Rz is the rotation matrix of theta radian around the z axis
%
% these matrices have simple forms, see rotation_xyz.
%

n = n / range (n);
% Direct expression %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%c = cos (theta);
%s = sin (theta);
%n2 = n .* n;
%M = zeros (3, 3);
%
%M(1, 1) = n2(1) + (1 - n2(1))*c;
%M(1, 2) = n(1)*n(2)*(1 - c) - n(3)*s;
%M(1, 3) = n(1)*n(3)*(1 - c) + n(2)*s;
%
%M(2, 1) = n(1)*n(2)*(1 - c) + n(3)*s;
%M(2, 2) = n2(2) + (1 - n2(2))*c;
%M(2, 3) = n(2)*n(3)*(1 - c) - n(1)*s;
%
%M(3, 1) = n(1)*n(3)*(1 - c) - n(2)*s;
%M(3, 2) = n(2)*n(3)*(1 - c) + n(1)*s;
%M(3, 3) = n2(3) + (1 - n2(3))*c;
% TODO any way to make M from rotate_xyz function ? %%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = n * n';
L = skew_sym (n);
M = N + (eye(3) - N)*cos(theta) + L*sin(theta);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[P, adj] = adjust_dim (P);
[dim, np] = size (P);
Q = zeros (dim, np);
for n = 1:np
   Q(:, n) = M * P(:, n);
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
%! %R0 is the -20° rotation along [O P1] of P0
%! R0 = [17.439; -1.238; -15.568]
%! Q0 = rotate_center (P0, P1, -20*pi/180)
%!
%! %R1 is the -50° rotation along [O P0] of P2
%! R1 = [9.259; 34.511; 10.407]
%! Q1 = rotate_center (P2, P0, -50*pi/180)
%!
