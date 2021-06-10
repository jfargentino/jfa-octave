function [Q, M] = rotate_xyz (P, roll, pitch, yaw)
%
% function [Q, M] = rotate_xyz (P, roll, pitch, yaw)
%
% Rotate P of roll radian among x axis, then pitch (tilt) radians among y axis
% and yaw (pan, head) radians among z axis. M is the rotation matrix, given
% by M = Myaw * Mpitch * Mroll.
%

% Rotation matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% among X roll (roulis)
m_roll = [ 1,    0,         0; ...
           0, +cos(roll), -sin(roll); ...
           0, +sin(roll), +cos(roll) ];

% among Y pitch (tangage)
m_pitch = [ +cos(pitch), 0, +sin(pitch); ...
                 0,      1,      0; ...
            -sin(pitch), 0, +cos(pitch) ];

% among Z yaw (lacet)
m_yaw = [ +cos(yaw), -sin(yaw), 0; ...
          +sin(yaw), +cos(yaw), 0; ...
             0     ,     0    , 1 ];

M = m_yaw * m_pitch * m_roll;

% Rotation matrix %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% All at once
%M = zeros (3, 3);
%
%M(1,1) = + cos(pitch)*cos(yaw);
%M(2,1) = + cos(pitch)*sin(yaw);
%M(3,1) = - sin(pitch);
%
%M(1,2) = + sin(pitch)*sin(roll)*cos(yaw) - cos(roll)*sin(yaw);
%M(2,2) = + sin(pitch)*sin(roll)*sin(yaw) + cos(roll)*cos(yaw);
%M(3,2) = + cos(pitch)*sin(roll);
%
%M(1,3) = + sin(roll)*sin(yaw) + sin(pitch)*cos(roll)*cos(yaw);
%M(2,3) = + sin(pitch)*cos(roll)*sin(yaw) - sin(roll)*cos(yaw);
%M(3,3) = + cos(pitch)*cos(roll);

[P, adj] = adjust_dim (P);

[dim, np] = size (P);
Q = zeros (dim, np);
for n = 1:np
   Q(:, n) = M * P(:, n);
end

% no loop but twice memory needs
%M = repmat (M, 1, c);
%Q = M * P;
%Q = Q(1:3, :);

if (adj)
    Q = Q';
end

