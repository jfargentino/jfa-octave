function [ss, x] = spectral_analysis(s, sr, freq_Hz, w)
%
% function [ss, x] = sumspec(signal, sample_rate, freq_Hz, win)
% function [ss, x] = sumspec(audiofile, freq_Hz, win)
%
% Returns short-term PSD of signal summed over frequencies freq_Hz.
% Signal given as an array and its sampling rate, or the name of an audio
% file. The 2nd output x is the raw short-term FFT.
%

if (ischar(s))
    % between 1 and 3 arg(s)
    if (nargin == 3)
        w = freq_Hz;
        freq_Hz = sr;
    end
    if (nargin == 2)
        if (ischar(sr))
            w = sr;
            freq_Hz = [];
        else
            freq_Hz = sr;
            w = [];
        end
    end
    if (nargin == 1)
        freq_Hz = [];
        w = [];
    end
    [s, sr] = audioread (s);
else
    % between 2 and 4 arg(s)
    if (nargin == 3)
        if (ischar(freq_Hz))
            w = freq_Hz;
            freq_Hz = [];
        else
            w = [];
        end
    end
    if (nargin == 2)
        freq_Hz = [];
        w = [];
    end
end
if (isempty(freq_Hz))
    %freq_scale = (0:1:24.5)';
    %freq_Hz = bark2hz(freq_scale)
    f0 = 55;
    freq_scale = (0:23)'; %TODO
    [fl, fh, fc] = nth_octave_freq (3, freq_scale, f0);
    freq_Hz = fc;
    %freq_Hz = tune([0:3:8*6]', 55, 6);
end
if (isempty(w))
    w = 'hann';
end

% TODO work only on mono
s = mean(s, 2);

% make freq_Hz ascending and be sure last element is sr/2
freq_Hz = [0; freq_Hz(:); sr/2];
freq_Hz = sort (freq_Hz);
n = min (find(freq_Hz >= sr/2));
freq_Hz = freq_Hz(1:n);
n = max (find(freq_Hz <= 0));
freq_Hz = freq_Hz(n:end);

% we want sr/nfft < freq_Hz(1)
sz = pow2(nextpow2(sr/min(diff(freq_Hz)))+1); % TODO
nfft = sz
% 50% overlap
overlap = 3*nfft/4;
% construct freq in Hz for df = f(2)
f = sr*(0:nfft/2-1)'/nfft;
dt = (nfft - overlap)/sr

% short-time PSD
x = spectrogram(s, sz, nfft, overlap, w);
s_psd = x / sz;
s_psd = (s_psd .* conj(s_psd));
s_psd = s_psd(1:sz/2, :) + s_psd(end:-1:sz/2+1, :);

% sum over given freq
% TODO if no bins to sum
[r, c] = size(s_psd);
k = round(freq_Hz/f(2)) + 1;
ss = zeros(length(k)-1, c);
for n = 1:length(k)-1
    ss(n, :) = sum(s_psd(k(n):k(n+1)-1, :), 1);
end

if (nargout == 0)

    % graphical parameters
    % 'viridis' 'cubehelix' 'copper' 'hot' 'gray'
    % IMHO jet is the best for details in low-dynamic area but it can be
    % unintuitive in the relative scale where a hot or copper colormap
    % is more straightforward
    cmap = 'jet';
    %cmap = 'hot';
    disp_raw_psd = 1;

    dt = (nfft - overlap)/sr;
    colormap (cmap);

    if (c > 16384)
        warning ('imagesc drop columns after 16384')
        c = 16384;
    end

    if (disp_raw_psd > 0)
        imagesc([0,(c-1)*dt], [0, f(end)], scaled_dB(s_psd, 60));
        ylabel ('Hz');
        if(f(end) > 8000)
            ylim([0,8000]);
        end
        xlabel ('time (s)');
        xlim([0,(c-1)*dt]);
        colorbar('East')
    else
        % rescale the summed-PSD
        % TODO Y-scale (freq) is not revelant excepting its min and max
        imagesc([0,(c-1)*dt], freq_scale, scaled_dB(ss, 90));
        xlabel ('time (s)');
        xlim([0,(c-1)*dt]);
        colorbar('East')
    end

    title(w);
    clear ss;
    clear x;
end
