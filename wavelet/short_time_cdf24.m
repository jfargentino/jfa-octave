function wst = short_time_cdf24 (x, K, chunk_sz, chunk_overlap, ...
                                 edges_correction, scaled)

% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (nargin < 2)
    K = 6;
end
if (nargin < 3)
    chunk_sz = 1024;
end
if (mod (chunk_sz, 2^K))
    warning ('%d is not a multiple of 2^%d = %d, using %d instead', ...
             chunk_sz, K, 2^K, chunk_sz - mod (chunk_sz, 2^K))
    chunk_sz = chunk_sz - mod (chunk_sz, 2^K);
end
if (nargin < 4)
    chunk_overlap = 256;
end
if (nargin < 5)
    edges_correction = 1;
end
if (nargin < 6)
    scaled = 1;
end

% process %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wst = [];
lx = length (x);
n0 = 1;
n1 = chunk_sz;
while (n1 <= lx)
    wst  = [wst, cdf24(x(n0:n1), K, edges_correction, scaled)];
    n0 = n1 - chunk_overlap + 1;
    n1 = n0 + chunk_sz - 1;
end

