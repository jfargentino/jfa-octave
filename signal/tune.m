function f_Hz = tune (n, f0_Hz, Ntune)

if (nargin < 3)
    Ntune = 12;
end

if (nargin < 2)
    f0_Hz = 32.70; % C (do)
end

f_Hz = f0_Hz * power(2, n / Ntune);

%!demo
%!
%! n    = 0:95;
%! f_Hz = tune(reshape(n, 12, 8))
%! r_Hz = [ 32.70, 65.41, 130.81, 261.63, 523.25, 1046.50, 2093.00, 4186.01;...
%!          34.65, 69.30, 138.59, 277.18, 554.37, 1108.73, 2217.46, 4434.92;...
%!          36.71, 73.42, 146.83, 293.66, 587.33, 1174.66, 2349.32, 4698.64;...
%!          38.89, 77.78, 155.56, 311.13, 622.25, 1244.51, 2489.02, 4978.03;...
%!          41.20, 82.41, 164.81, 329.63, 659.26, 1318.51, 2637.02, 5274.04;...
%!          43.65, 87.31, 174.61, 349.23, 698.46, 1396.91, 2793.83, 5587.65;...
%!          46.25, 92.50, 185.00, 369.99, 739.99, 1479.98, 2959.96, 5919.91;...
%!          49.00, 98.00, 196.00, 392.00, 783.99, 1567.98, 3135.96, 6271.93;...
%!          51.91, 103.83, 207.65, 415.30, 830.61, 1661.22, 3322.44, 6644.88;...
%!          55.00, 110.00, 220.00, 440.00, 880.00, 1760.00, 3520.00, 7040.00;...
%!          58.27, 116.54, 233.08, 466.16, 932.33, 1864.66, 3729.31, 7458.62;...
%!          61.74, 123.47, 246.94, 493.88, 987.77, 1975.53, 3951.07, 7902.13 ];
%! f_Hz - r_Hz

%!demo
%!
%! n    = -9:86;
%! f_Hz = tune(reshape(n, 12, 8), 55) % starting from A
%! r_Hz = [ 32.70, 65.41, 130.81, 261.63, 523.25, 1046.50, 2093.00, 4186.01;...
%!          34.65, 69.30, 138.59, 277.18, 554.37, 1108.73, 2217.46, 4434.92;...
%!          36.71, 73.42, 146.83, 293.66, 587.33, 1174.66, 2349.32, 4698.64;...
%!          38.89, 77.78, 155.56, 311.13, 622.25, 1244.51, 2489.02, 4978.03;...
%!          41.20, 82.41, 164.81, 329.63, 659.26, 1318.51, 2637.02, 5274.04;...
%!          43.65, 87.31, 174.61, 349.23, 698.46, 1396.91, 2793.83, 5587.65;...
%!          46.25, 92.50, 185.00, 369.99, 739.99, 1479.98, 2959.96, 5919.91;...
%!          49.00, 98.00, 196.00, 392.00, 783.99, 1567.98, 3135.96, 6271.93;...
%!          51.91, 103.83, 207.65, 415.30, 830.61, 1661.22, 3322.44, 6644.88;...
%!          55.00, 110.00, 220.00, 440.00, 880.00, 1760.00, 3520.00, 7040.00;...
%!          58.27, 116.54, 233.08, 466.16, 932.33, 1864.66, 3729.31, 7458.62;...
%!          61.74, 123.47, 246.94, 493.88, 987.77, 1975.53, 3951.07, 7902.13 ];
%! f_Hz - r_Hz

%!demo
%!
%! n    = [0:1, 1.5:3.5, 4:5];
%! f_Hz = tune(n', 440, 6)
%! a = 440;
%! b = 493.88; % no #
%! c = 523.25;
%! d = 587.33;
%! e = 659.26; % no #
%! f = 698.46;
%! g = 783.99;
%! f_Hz - [a b c d e f g]'
