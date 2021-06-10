function v = thermal_noise (r, t, df)
%
% function v = thermal_noise (r, t, df)
%
% Return the voltage variance on a resistor due to the thermal (Johnson
% - Nyquist) noise. Take the root square of the result to have a V value.
%
%     - r is the resistor value in Ohm (1 per default);
%     - t is the temperature in °C (20 per default);
%     - df is the bandwidth in Hz (1 per default).
%

Kb = 1.3806e-23; % Boltzmann constant in J.K^-1

if (nargin < 3)
    df = 1;
end
if (nargin < 2)
    t = 20;
end
if (nargin < 1)
    r = 1;
end


% convert °C in K
tk = t + 273.15;

v = 4 * Kb * tk * r * df;

