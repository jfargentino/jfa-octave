function [xf, k, cf] = sort_outliers (x, win_len, thresh)

    if (nargin < 2)
        win_len = 60
    end
    if (nargin < 3)
        thresh = 2 * sqrt(2);
        % thresh = 3;
    end

    cf = crest_factor(x, win_len);
    k = find(abs(cf) < thresh) + win_len - 1;
    xf = x(k);
    k = find(abs(cf) >= thresh) + win_len - 1;
    
endfunction
