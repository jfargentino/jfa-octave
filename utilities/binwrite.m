function binwrite (x, filename, precision)

if nargin < 3
   precision = 'int32';
end

f = fopen (filename, 'w');
if (f ~= -1)
   fwrite (f, x(:), precision);
   fclose (f);
else
   warning ('Can not open file %s', filename)
end

