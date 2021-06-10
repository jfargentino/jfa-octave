function s = rawread (raw_file_name, chan)

fid = fopen (raw_file_name, 'r');

if (fid == -1)
   s = [];
   return
end

if (nargin < 2)
   chan = 1;
end

s = fread (fid, inf, 'uint16');
fclose (fid);
if (chan > 1)
   sc = zeros (ceil (length (s) / chan), chan);
   for (n = 1:chan)
      sc (:, n) = s (n:chan:end);
   end
   s = sc;
end


