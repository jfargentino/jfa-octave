function ret = array2ihex (filename, x, word_size, offset)
% TODO test with other word size
% TODO more than 1 word per line

if (nargin < 4)
   offset = 0;
end
if (nargin < 3)
   word_size = 4;
end

file = fopen (filename, 'w');
if (file == -1)
   ret = -1;
   return;
end

ret = 0;
x = x(:);
b = zeros (word_size, 1);
k = 1;
offset = 0;

for k = 1:length (x);
    if (x(k) < 0)
        y = 0xFFFFFFFF + x(k) + 1;
    else
        y = x(k);
    end
    b = [ bitshift(bitand(y, 0xFF000000), -24), ...
          bitshift(bitand(y, 0x00FF0000), -16), ...
          bitshift(bitand(y, 0x0000FF00), -8), ...
          bitand(y, 0x000000FF) ];
    ret = ret + fprintf (file, ':%02X%04X00', word_size, offset);
    for n = 1:word_size
        ret = ret + fprintf (file, '%02X', b(n));
    end
    checksum = word_size ...
                     + bitand (offset, 0x00FF) ...
                     + bitshift (bitand(offset, 0xFF00), - 8) ...
                     + sum (b);
    checksum = bitand (0x100 - bitand (checksum, 0xFF), 0xFF);
    ret = ret + fprintf (file, '%02X\n', checksum);
    offset = offset + 1;
end

ret = ret + fprintf (file, ':00000001FF\n');
fclose (file);

