function dB = power2dB (p, Ohm)
%
% function dB = power2dB (p [, Ohm])
%
% To convert 'p' Watt (variance of a voltage signal)
% in dB, charged on an 'Ohm' Ohm resistor (50 per default).
%

if (nargin < 2)
	Ohm = 50;
end

dB = 10 * log10 (p / Ohm);
