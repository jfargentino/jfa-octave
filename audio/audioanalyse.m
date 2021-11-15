function [s_stft, s_var, s_amp] = audioanalyse (s, sr, w)
%
% function [ss, s_psd] = sumspec(signal, sample_rate, win)
% function [ss, s_psd] = sumspec(audiofile, win)
%
% Returns short-term PSD of signal summed over frequencies freq_Hz.
% Signal given as an array and its sampling rate, or the name of an audio
% file.
%
% s_psd is the raw short-term PSD.
%
if (ischar(s))
    % between 1 and 2 arg(s)
    if (nargin == 2)
        w = sr;
    end
    if (nargin == 1)
        w = [];
    end
    [s, sr] = audioread (s);
else
    % between 2 and 3 arg(s)
    if (nargin == 2)
        w = [];
    end
end
if (isempty(w))
    w = 'flattopwin';
    w = 'blackmanharris';
    w = 'hamming';
    w = 'blackman';
    w = 'hann';
end

% work only on mono
%s = mean(s, 2);

% we want nfft/sr around 8ms %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sr
nfft = round(0.016 * sr)
% TODO should be previous power of 2
sz = pow2(nextpow2(nfft))
nfft = sz;
% 50% overlap
overlap = nfft/2;

[N, chan]  = size(s)
dt = (nfft - overlap)/sr
df = sr/nfft

% temporal analysises %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "s_amp" is instantaneous amplitude of signal s, in Hilbert sense  
% "s_hilbert" is the hilbert transform, imag(hilbert(s))
[s_amp, s_hilbert] = shape (s);
z = zeros(nfft-1, 1);
%as = [z; as];

% sliding variance
% TODO crest-factor
n0 = 1;
n1 = nfft;
s_var = zeros (N, chan);
c_crest = s_var;
k = nfft/2;
while (n1 <= N)
    s_var(k, :) = var(s(n0:n1, :));
    ss = s(n0:n1, :) - mean(s(n0:n1, :));
    s_crest(k, :) = ss .* ss ./ s_var(k, :);
    n0 = n0 + 1;
    n1 = n1 + 1;
    k = k + 1;
end

% short time FFT %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
s_stft = spectrogram(s, sz, nfft, overlap, w);
% short-time PSD
s_psd = s_stft / sz;
s_psd = (s_psd .* conj(s_psd));
s_psd = s_psd(1:sz/2, :) + s_psd(end:-1:sz/2+1, :);
[R, C] = size (s_psd);

if (nargout == 0)

    figure
    plot ([s, s_hilbert, s_amp, sqrt(s_var)]);
    grid on;
    legend ('signal', 'hilbert', 'amplitude', 'std dev');


    figure
    cmap = 'jet';
    colormap (cmap);
    dB_min = -40;
    s_dB =  specimg(s_psd, dB_min);
    imagesc([0,(C-1)*dt], [0, sr/2], s_dB);
    if (8000 < sr/2)
        ylim([0, 8000]);
    end

    clear s_stft;
    clear s_var;
    clear s_amp;
    clear s_hilbert;
end
