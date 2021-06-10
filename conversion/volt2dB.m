function dB = volt2dB (A, Ohm)
%
% function dB = volt2dB (A [, Ohm])
%
% To convert 'A' volt level in dB, charged on an
% 'Ohm' Ohm resistor (50 per default).
%
% dBx are a mess, we have following definitions in the audio / radio world:
%     - the nominal line level in professional audio is +4dBu which is
%       a peak amplitude of 1.736V _OR_ a RMS level of 1.228Vrms. So 0dBu
%       is a peak amplitude of 1.095V _OR_ a RMS level of 0.775Vrms, so it is
%       the same that 0dBm (ref 600 Ohm).
%     - the nominale line level in consumer audio is -10dBV which is a peak
%       amplitude of 0.447V _OR_ a RMS level of 0.316Vrms. So 0dBV is a peak
%       amplitude of 1.414V _OR_ a RMS level of 1.000Vrms
%     - the 0dBm (ref 50 Ohm) is given as a RMS level of 0.225Vrms _OR_ a peak
%       amplitude of 0.318Vpeak.
%
%                           0dBV  |  0dBu  |  0dBm  |
%                   Vpeak: 1.414V | 1.095V | 0.318V |
%                   Vrms : 1.000V | 0.775V | 0.225V |
%
%                    0dBV = +2.22dBu = +12.96dBm
%

if (nargin < 2)
    Ohm = 50;
end

dB = power2dB ((A.*A)/2, Ohm);
