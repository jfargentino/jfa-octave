function [alpha, beta, l] = arceau (h, a, b)

%
% function [alpha, beta, l] = arceau (h, a, b)
%
%     _ _ _ _ _ _ P
%    /          /|
%                
%  /_ _ _ _ _ /  |
%  |         |    
%                |h
%  |         |    
%                |
%  |         |    
%                |
%  |         |  /
%               b
% 0|_ _ _ _ _|/
%       a
%
%

O = [0, 0, 0];
P = [a, b, h];
x = [1, 0, 0];
y = [0, 1, 0];
z = [0, 0, 1];
l = range_between(O, P);
alpha = angle_between(P-O, O-z);
beta  = angle_between(P, P+y);
