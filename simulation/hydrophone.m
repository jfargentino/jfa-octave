function Y = hydrophone (X, Sh)
%
% function Y = hydrophone (X, Sh)
%
% To convert an acoustic signal in an electrical one.
%
% X acoustic signal (uPa)
% Sh hydrophone sensibility (dB ref 1 Veff/uPa)
%
% return Y the signal in V
% TODO: hydrophone could act as filter with Sh function of frequency

Y = 10^(Sh/20) * X;
