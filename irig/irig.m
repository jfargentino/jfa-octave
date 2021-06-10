function [s, b] = irig(doy, hour, mn, sec, duration, fs)

b = time2bits (doy, hour, mn, sec);
for (n = 1:duration)
    sec = sec + 1;
    if (sec >= 60)
        sec = 0;
        mn = mn + 1;
        if (mn >= 60)
            mn = 0;
            hour = hour + 1;
            if (hour >= 24)
                hour = 0;
                doy = doy + 1;
                if (doy >= 365)
                    doy = 0;
                end
            end
        end
    end
    %[doy, hour, mn, sec]
    b = [b; time2bits(doy, hour, mn, sec)];
end

s = bits2irig(b, fs);

