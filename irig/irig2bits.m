function [bitstream, bitindex] = irig2bits (s)
%
% function [bitstream, bitindex] = irig2bits (s)
%
% Convert a temporal IRIG signal into a bitstream, and return a second array
% with the indexes of each bit into the original signal.
%

speak = irig2peaks (s);
n_high = find (speak == 1);

% convert in bitstream
ndiff = diff (n_high);
ndiff = round (ndiff / min (ndiff)) - 1;
nz_index = find (ndiff);

bitstream = ndiff (nz_index);

zeros_index = find (bitstream == 8);
ones_index = find (bitstream == 5);
sync_index = find (bitstream == 2);
bitstream (zeros_index) = 0;
bitstream (ones_index) = 1;
bitstream (sync_index) = -1; % synchro

ioff = 1;
kk = nz_index(zeros_index) - ioff;
if (length (find (kk <= 0)) > 0)
    warning ('%d 0 index are less or equal to %d', ...
             length (find (kk <= 0)), ioff)
    kk(find (kk <= 0)) = 1;
end
bitindex (zeros_index) = n_high (kk);

ioff = 4;
kk = nz_index(ones_index) - ioff;
if (length (find (kk <= 0)) > 0)
    warning ('%d 1 index are less or equal to %d', ...
             length (find (kk <= 0)), ioff)
    kk(find (kk <= 0)) = 1;
end
bitindex (ones_index) = n_high (kk);

ioff = 7;
kk = nz_index(sync_index) - ioff;
if (length (find (kk <= 0)) > 0)
    warning ('%d sync index are less or equal to %d', ...
             length (find (kk <= 0)), ioff)
    kk(find (kk <= 0)) = 1;
end
bitindex (sync_index) = n_high (kk);

