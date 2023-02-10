function sw = windowing(s, n)

[r, c] = size(s);
if ( nargin < 2 )
    n = round(r / 16);
end

attack = blackman(2*n);
release = attack(n+1:end);
attack =attack(1:n);
if ( c > 1 )
    attack = repmat(attack, 1, c);
    release = repmat(release, 1, c);
end
sw = s;
sw(1:n, :) = attack .* s(1:n, :);
sw(end-n+1:end, :) = release .* s(end-n+1:end, :);

