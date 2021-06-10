function dB = seaNoisePower (f0, f1, Vkt)

if (nargin < 3)
	Vkt = 0;
end

F = f0:f1;

dBHz = seaNoisePerSqrtHz (F, Vkt);
uPa = sum (10 .^ (dBHz / 20));
dB  = 20 * log10 (uPa);
