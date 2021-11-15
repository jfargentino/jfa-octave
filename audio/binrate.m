function rx = binrate (x, raw)

if (nargin < 2)
    raw = 0;
end

dx = diff(x);
rx = dx;
rx(find(dx > 0)) = +1;
rx(find(dx < 0)) = -1;

% remove 'false' 0s, solve corner cases 1st (1st or last are 0)
k = 1;
K = length(dx);
while ((k < K-1) && (rx(k) == 0))
    k ++;
end
rx(1:k) = rx(k+1);
k = K;
while ((k > 2) && (rx(k) == 0))
    k --;
end
rx(k:end) = rx(k-1);

n0 = find(rx == 0);
if (length(n0) == length(rx))
    return;
end

if ( (raw < 1) && ~ isempty(n0) )
    rx(n0) = (rx(n0-1) + rx(n0+1)) / 2;
end

if (nargout == 0)
    plot (1:length(x), 10*log10(x), ...
          1:length(x), 10*[rx; 0]);
    grid on
    clear rx;
end

