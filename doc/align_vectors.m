function Q = align_vectors(u, v)

% Q = align_vectors(u, v)
%
% DESC:
% Align the vectors u and v via a Householder reflector Q
%
% AUTHOR
% Marco Zuliani - zuliani@ece.ucsb.edu
%
% VERSION:
% 1.0
%
% INPUT:
% u             = source vector
% v             = destination vector
%
% OUTPUT:
% Q             = unitary matrix such that Q*u \prop v

N = length(u);

u = u/norm(u);
v = v/norm(v);
x = v-u;
Q = eye(N) - 2*x*x'/(x'*x);

return