function dBHz = seaThermalNoise (f)

dBHz = -15 + 20 * log10 (f / 1000);
