function [x, Fs, t0, t1] = sacread (name, endianness)
%
% function [x, Fs, t0, t1] = sacread (name, endianness)
%
% To read a "Seismic Analysis Code" file
% TODO Maybe other header fields could be useful to get?
% REF: -http://seismolab.gso.uri.edu/%7Esavage/sac/sac_format.html
%      -http://www.iris.edu/manuals/sac/SAC_Manuals/FileFormatPt1.html
%
if nargin < 2
   endianness = 'ieee-le';
end

fid = fopen (name, 'rb', endianness);
if fid == -1
   % Try to append '.sac' at the end of the name
   fid = fopen ([name, '.sac'], 'rb', endianness);
end

if fid == -1
   error ('can not open file %s\n', name);
   x = []; 
   Fs = [];
   t0 = [];
   t1 = [];
   return
end

hdr_f = fread (fid, 70, 'float32');
hdr_n = fread (fid, 15, 'int32');
hdr_i = fread (fid, 20, 'int32');
hdr_l = fread (fid, 5, 'int32');
hdr_k = fread (fid, [8 24], 'char');

x = fread (fid, hdr_n(10), 'float32');
Fs = 1 / hdr_f (1);
t0 = hdr_f (6);
t1 = hdr_f (7);

