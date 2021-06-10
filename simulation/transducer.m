function Y = transducer (X, Sv)
%
% function Y = transducer (X, Sv)
%
% To convert an electrical signal in an acoustic one.
%
% X electrical signal (V)
% Sv transducteur sensibility (dB ref 1 uPa/V at 1 m)
%
% return Y the signal in uPa at 1 m
%
% TODO: rise time and relaxation oscillations
% TODO: transducer could act as filter with Sv function of frequency
%

Y = 10^(Sv/20) * X;
