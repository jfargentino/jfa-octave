function Ftx = doppler (F, vs, vr, c)
%
% function Ftx = doppler (F, vs, vr, c)
%
% To evaluates the doppler frequency shift from:
%     - F the emitted frequency
%     - vs the source speed relative to the medium, in m.s-1
%     - vr the receiver speed relative to the medium, in m.s-1 (0 per default)
%     - c the celerity of sound in the medium (1500 per default)
%

if (nargin < 4)
    c = 1500;
end
if (nargin < 3)
    vr = 0;
end

Ftx = F * (c + vr) / (c + vs);
