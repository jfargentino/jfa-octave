function wav2date (wavename)

[s, Fs] = audioread (wavename);
[doy, hour, mn, sec, msec, idx] = irig2time (s);
usec = msec*1e3 - ((idx - 1) / Fs) * 1e6;
while (usec < 0)
    sec = sec - 1;
    usec = usec + 1e6;
end
%printf ('%d %dh%02dmn%02d.%03ds - %f\n', doy, hour, mn, sec, msec, idx / Fs);
printf ('%d %dh%02dmn%02d.%06ds\n', doy, hour, mn, sec, round (usec));
