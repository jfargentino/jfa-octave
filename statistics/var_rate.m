function rate = var_rate (x, sz, stp, side)

if (nargin < 4)
    side = 0;
end
if (nargin < 3)
    stp = 1;
end

[row, col] = size (x);
rate = zeros (ceil (row/stp), col);
nleft0 = 1;

% left side
if (side > 0)
    nleft1 = 2;
    k = 3;
    nright0 = 4;
    nright1 = 4 + sz;
    while (nleft1 < sz)
        rate(k) = var (x(nright0:nright1)) / var (x(nleft0:nleft1));
        k = k + 1;
        nleft1 = nleft1 + stp;
        nright0 = nright0 + stp;
        nright1 = nright1 + stp;
    end
else
    k = sz + 1;
    nleft1 = sz;
    nright0 = sz + 2;
    nright1 = 2*sz + 2;
end

% middle
while (nright1 <= row)
    rate(k) = var (x(nright0:nright1)) / var (x(nleft0:nleft1));
    k = k + 1;
    nleft0 = nleft0 + stp;
    nleft1 = nleft1 + stp;
    nright0 = nright0 + stp;
    nright1 = nright1 + stp;
end

% right side
if (side > 0)
    k = k - 1;
    nleft0 = nleft0 - stp;
    nleft1 = nleft1 - stp;
    nright0 = nright0 - stp;
    nright1 = row;
    while (nright0 < row - 1)
        rate(k) = var (x(nright0:nright1)) / var (x(nleft0:nleft1));
        k = k + 1;
        nleft0 = nleft0 + stp;
        nleft1 = nleft1 + stp;
        nright0 = nright0 + stp;
    end
end

%!demo
%!
%! x = [randn(1000, 1); 2*randn(48, 1); randn(1000, 1)];
%! rate = var_rate (x, 48, 1, 0);
%! [rate_max, k] = max (rate)
%! plot ([x, rate])
%! xlim ([1, 2048])
%! grid on
