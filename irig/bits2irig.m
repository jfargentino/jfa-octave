function s = bits2irig (bits, fs)
%
% function s = bits2irig (bits, fs)
% 
% Convert a bitstream into an amplitude modulated signal as used in IRIG B
% format: carrier of 1kHz, high level is 1 and low level is 0.3.
% 
% bit 0: 2 periods of high level, then 8 periods of low level;
% bit 1: 5 periods of high level, then 5 periods of low level;
% synchro: 8 periods of high level, then 2 periods of low level;
%
% fs is the sampling rate, be aware that it must be divisible by 1000 to get
% a integral number of samples. fs is 96kHz per default.
%

F_IRIG = 1000;

if (nargin < 1)
    bits = -1;
end
if (nargin < 2)
    fs = 96000;
end

t = ((1:floor (fs / F_IRIG))' - 1) / fs;
s0 = sin (2 * pi * F_IRIG * t);
s = [];
for n = 1:length (bits)
    switch (bits(n))
        case 0
        sh = repmat (s0, 2, 1);
        sl = repmat (0.3 * s0, 8, 1);
        case 1
        sh = repmat (s0, 5, 1);
        sl = repmat (0.3 * s0, 5, 1);
        otherwise
        sh = repmat (s0, 8, 1);
        sl = repmat (0.3 * s0, 2, 1);
    end
    s = [s; sh; sl];
end

%!demo
%! fs = 48000;
%! s0 = bits2irig (0, fs);
%! s1 = bits2irig (1, fs);
%! ss = bits2irig (-1, fs);
%! t = 1000 * ((0:length (s0) - 1)') / fs;
%! plot (t, s0, t, s1, t, ss);
%! grid on;
%! xlim ([t(1), t(end)]);
%! xlabel ('time in ms');
%! legend ('bit 0', 'bit 1', 'synchro');
%! s = bits2irig ([-1; 0; 1; 0; 1; 0; 1; 0; 1; -1], fs);
%! t = 1000 * ((0:length (s) - 1)') / fs;
%! figure,
%! plot (t, s);
%! grid on;
%! xlim ([t(1), t(end)]);
%! xlabel ('time in ms');
%! legend ('sync 0 1 0 1 0 1 0 1 sync');

