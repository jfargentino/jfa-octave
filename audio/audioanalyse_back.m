function [synth, s_synth, formant] = audioanalyse (s, sr, w)
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
s = mean(s, 2);

% we want nfft/sr around 8ms %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nfft = (8 * sr) / 1000
% TODO should be previous power of 2
sz = pow2(nextpow2(nfft))
nfft = sz;
% 50% overlap
overlap = nfft/2;

N  = length(s);
dt = (nfft - overlap)/sr
df = sr/nfft

% temporal analysises %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "as" is instantaneous amplitude of signal s, in Hilbert sense  
% "h" is the hilbert transform, imag(hilbert(s))
[as, h] = shape (s);
z = zeros(nfft-1, 1);
%as = [z; as];

% sliding statistics
n0 = 1;
n1 = nfft;
vs = zeros (N, 1);
ps = vs;
k = nfft/2;
while (n1 <= N)
    vs(k, :) = var(s(n0:n1, :));
    n0 = n0 + 1;
    n1 = n1 + 1;
    k = k + 1;
end
% TODO form factor = (s(n) - ms(n)) / sqrt (vs(n))
% crude beat detection on vs, for sr 44.1kHz, var every 1024 samples,
% 2s -> FFT of 128 var
n_bpm = 128;
BPM = [];
length(BPM)
for k = 1 : n_bpm : length (vs)-n_bpm
    x = fold_psd (psd(vs(k:k+n_bpm-1)));
    x(1) = 0;
    [foo, y] = max (x);
    BPM = [BPM; y];
end
length(BPM)
bpm = 60*sr*(0:n_bpm-1)'/(n_bpm*nfft);
find (BPM == 0)
BPM = bpm(BPM);
figure
plot(BPM)
grid on
figure

% short time FFT
s_orig = spectrogram(s, sz, nfft, overlap, w);
% short-time PSD
s_psd = s_orig / sz;
s_psd = (s_psd .* conj(s_psd));
s_psd = s_psd(1:sz/2, :) + s_psd(end:-1:sz/2+1, :);
[R, C] = size (s_psd);

% for each spectrum, returns its revelant peaks
s_peak = zeros(R, C);
for k = 1:C
    s_peak(:, k) = specpeaks(s_psd(:, k), 2, 0);
end
% for every non-0 cell, copy the 3x3 elements centered on it
% TODO specpeaks returns the neighborhood matrix then just .*
%formant = zeros(R, C);
%for nr = 2 : R-1
%    for nc = 2 : C-1
%        if (s_peak(nr, nc) > 0)
%            formant(nr-1:nr+1, nc-1:nc+1) = s_psd(nr-1:nr+1, nc-1:nc+1);
%        end
%    end
%end
formant = s_peak;

% image processing -> rescale PSD between 0 and 255
dB_min = -40;
s_dB =  specimg(s_psd, dB_min);
%[x_dB, thr] = edge (s_dB, "Canny");
%x_dB = rangefilt (s_dB);
%y_dB = entropyfilt (s_dB);

% now reconstruct the spectrum from the formant
s_synth = zeros(size(s_orig));
for nr = 1 : R
    for nc = 1 : C
        if (formant(nr, nc) > 0)
            s_synth(nr, nc) = s_orig(nr, nc);
            s_synth(2*R-nr+1, nc) = s_orig(2*R-nr+1, nc);
        end
    end
end
% then synthetise the signal from short-term FFTs
synth = ispectrogram(s_synth, sz, nfft, overlap, w);
synth = real (synth(1:length(s), :));

if (nargout == 0)

    % graphical parameters
    % 'viridis' 'cubehelix' 'copper' 'hot' 'gray'
    % IMHO jet is the best for details in low-dynamic area but it can be
    % unintuitive in the relative scale where a hot or copper colormap
    % is more straightforward
    cmap = 'jet';
    %cmap = 'hot';

    figure
    plot ([s, as, sqrt(vs)]);
    grid on;
    legend ('signal', 'amplitude', 'std dev');


    figure
    colormap (cmap);

    subplot (3, 1, 1);
    imagesc([0,(C-1)*dt], [0, sr/2], s_dB);
    if (8000 < sr/2)
        ylim([0, 8000]);
    end

    subplot (3, 1, 2);
    %imagesc([0,(C-1)*dt], [0, sr/2], x_dB);
    formant(find(formant == 0)) = min(min(s_psd));
    y =  specimg(formant, dB_min);
    %imagesc([0,(C-1)*dt], [0, sr/2], 10*log10(formant));
    %imagesc([0,(C-1)*dt], [0, sr/2], rangefilt(y));
    imagesc([0,(C-1)*dt], [0, sr/2], y);
    if (8000 < sr/2)
        ylim([0, 8000]);
    end

    subplot (3, 1, 3);
    %
    %y = s_synth / sz;
    %y = (y .* conj(y));
    %y = y(1:sz/2, :) + y(end:-1:sz/2+1, :);
    %y = specimg(y, dB_min);
    %imagesc([0,(C-1)*dt], [0, sr/2], y);
    %if (8000 < sr/2)
    %    ylim([0, 8000]);
    %end
    t = ((0:length(s)-1)/sr)';
    plot (t, [s, synth]);
    xlim([0, t(end)]);
    legend ('original', 'synth');
    xlabel ('time (s)');
    grid on


    clear synth;
    clear s_synth;
    clear formant;

end
