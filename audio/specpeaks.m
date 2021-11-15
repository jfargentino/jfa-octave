function p = specpeaks (s, RATE_MIN, alpha, psum)
%
% function p = specpeaks (s, RATE_MIN, alpha)
%
% find revelant peaks in s, alpha <= 1 looks better when many peaks
% 
if (nargin < 4)
    psum = 0;
end
if (nargin < 3)
    %alpha = 1.25;
    alpha = 0;
end
if (nargin < 2)
    RATE_MIN = 1;
end

% local maximas, we can not looking for 0, but for positive to negative
p = zeros(length(s), 1);
%p = min(s) * ones(length(s), 1);

rs = binrate(s);
if (alpha <= 1)
    % TODO looks like some peaks still missing
    rs = binrate([0; cumsum(rs)], 1);
end

NONE       = 0;
ASCENDING  = 1;
PEAK       = 2;
DESCENDING = 3;
state = NONE;

prate = 0;
nrate = 0;
bottom = 0;
k_peak = 0;
k = 1;
K = length(rs);
while (k < K)
    if (state == NONE)
        if (rs(k) > 0)
            prate = 1;
            state = ASCENDING;
            if (k > 1)
                bottom = s(k-1);
            else
                bottom = s(1);
            end
        end
    elseif (state == ASCENDING)
        if (rs(k) >= 0)
            prate = prate + 1;
        else
            % peak candidate
            %if ((prate >= RATE_MIN) && (s(k) >= alpha*bottom))
            if (prate >= RATE_MIN)
                nrate = 1;
                state = DESCENDING;
                k_peak = k;
            else
                state = NONE;
            end
        end
    elseif (state == DESCENDING)
        if (rs(k) <= 0)
            nrate = nrate + 1;
        else
            bottom = (bottom + s(k)) / 2;
            if ((nrate >= RATE_MIN) && (s(k_peak) >= alpha*bottom))
                % peak confirmed
                if (psum > 0)
                    % TODO choosing the integration depth with psum
                    k0 = k_peak - prate;
                    if (k0 < 1)
                        k0 = 1;
                    end
                    k1 = k_peak + nrate;
                    if (k1 > K)
                        k1 = K;
                    end
                    p(k_peak) = sum(s(k0:k1));
                else
                    p(k_peak) = s(k_peak);
                end
            end
            state = NONE;
        end
    end
    k = k + 1;
end

if (nargout == 0)
    %figure
    if (alpha <= 1)
        plot (1:length(s), 10*log10(s), ...
              1:length(s), 10*log10(p), '+')
    else
        plot (1:length(s), 10*log10(s), ...
              1:length(s), [0; cumsum(rs)], ...
              1:length(s), 10*log10(p), '+')
    end
    grid on
end

