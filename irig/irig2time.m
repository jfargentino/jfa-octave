function [doy, hour, mn, sec, msec, idx] = irig2time (s)
% 
% function [doy, hour, mn, sec, msec, idx] = irig2time (s)
%
% Return the first timestamp found in an IRIG B signal. If the signal does not
% begin on a plain second, we count the number of synchro that occurs before
% it to remove it from the returned date. And we return the index at wich the
% first synchro occurs, then along with the signal sample rate we can fine tune
% the first sample value.
%
% TODO verify that there's enough synchro in the signal to get a timestamp
%
[b, n] = irig2bits (s);
nsync = find (b == -1);
% plain second is 2 consecutive syncho (-1)
nms = nsync (min (find (diff (nsync) == 1))) + 1;
if (isempty (nms))
    % take the first synchro
    % TODO there we're hopping that the fisrt synchro is the plain sec
    nms = nsync(1);
end
% seconds value
nval = nms + 1 : nms + 8;
sec = bits2bcd (b(nval));
% minutes value
nval = nms + 10 : nms + 17;
mn = bits2bcd (b(nval));
% hours value
nval = nms + 20 : nms + 26;
hour = bits2bcd (b(nval));
% days value
nval = nms + 30 : nms + 38;
doy = bits2bcd (b(nval));
nval = nms + 40 : nms + 48;
doy = 100 * bits2bcd (b(nval)) + doy;

% msec complement
msec = 10 * (nms - 1);
if (msec > 0)
    sec = sec - 1;
    msec = 1000 - msec;
end
idx = n(1);
