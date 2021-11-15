function [n_trans] = audio_analysis(s, sr)

if (ischar(s))
    [s, sr] = audioread (s);
else
    if (nargin < 2)
        sr = [];
    end
end


w1 = 32768;
step = w1 / 2;
w2 = w1/64;
[R, C] = size(s);
n_trans = [];
n0 = 1;
n1 = w1;
while (n1 < R)
    %n_trans = [n_trans; findtrans(s(n0:n1, :), w2, 10/100, w2/2, 1) + n0 - 1];
    n_trans = [n_trans; audiotrans(s(n0:n1, :), 20/sr, w2/2, 1) + n0 - 1];
    n0 = n0 + step;
    n1 = n0 + w1 - 1;
end
% TODO last chunk
%n_trans = [n_trans; findtrans(s(n0:end, :), w2) + n0 - 1];
n_trans  = sort (n_trans);

% remove too close indexes by keeping where the biggest transition
%k = find (diff(n_trans) > step/2) + 1;
%n_trans  = [n_trans(1); n_trans(k)];

if (nargout == 0)
    if (isempty(sr))
        sr = 1;
    end

    t = (0:R-1)'/sr;
    plot(t, s);
    xticks(t(n_trans));
    xlim([0, t(end)]);
    grid on;
    
    % pulse eval
    n_pulse = diff(n_trans);
    bpm = sort(60 * sr * ones(length(n_pulse), 1) ./ n_pulse);
    median(bpm)
    figure;
    bpm0 = max (min(bpm),  60)
    bpm1 = min (max(bpm), 120)
    %hist(bpm, (bpm1-bpm0)/5)
    plot(bpm)
    if (sr > 1)
        sp = s/8;
        sp(n_trans) = sign(s(n_trans));
        soundsc (sp, sr);
    end

    clear n_trans;
end

