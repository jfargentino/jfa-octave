function p_psi = bar2psi (p_bar)
%
% function p_psi = bar2psi (p_bar)
%
% Converts pressure in bar into P.S.I. with:
%         1 P.S.I == 14.503774 bar
%
p_psi = 14.503774 * p_bar;
