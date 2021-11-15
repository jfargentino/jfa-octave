function [idx, as, vs, S] = audiochunk (s, sr, w)
%
% function [idx, as, vs, S] = audiochunk (s, sr, w)
% function [idx, as, vs, S] = audiochunk (audiofile, w)
%
%

% parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    w = 'hann';
    % we want nfft/sr around 8ms
    nfft = (16 * sr) / 1000
else
    if (ischar(w))
        % we want nfft/sr around 8ms
        nfft = (16 * sr) / 1000
    else
        nfft = w;
        w = 'hann';
    end
end
%
% TODO work only on mono
s = mean(s, 2);

% TODO should be previous power of 2
sz = pow2(nextpow2(nfft))
nfft = sz;
% 50% overlap
overlap = nfft/2;

w
N  = length(s);
dt = (nfft - overlap)/sr
df = sr/nfft

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% temporal analysises %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% "as" is instantaneous amplitude of signal s, in Hilbert sense  
% "h" is the hilbert transform, imag(hilbert(s))
[as, h] = shape (s);
z = zeros(nfft-1, 1);

% sliding statistics
% TODO form factor = (s(n) - ms(n)) / sqrt (vs(n)), teager and other E estim
stp = nfft - overlap;
vs = zeros (ceil(N/stp), 1);
mas = vs;
vas = vs;
n0 = 1;
n1 = nfft;
k = 1;
while (n1 <= N)
    vs(k, :) = var(s(n0:n1, :));
    mas(k, :) = mean(as(n0:n1, :));
    vas(k, :) = var(as(n0:n1, :));
    n0 = n0 + stp;
    n1 = n1 + stp;
    k = k + 1;
end

% -> 48kHz/512 => 46.875Hz = then FFT of 2s the bin is the beat ?

% crude segmentation
% TODO experimenting with different thresholds
%thr = max(vas)/100;
%thr = max(vs)/10;
thr = max(mas)/5;
crude_idx = find (mas < thr);
didx = diff(crude_idx);
% all contiguous segments on the head become 1
if (crude_idx(1) == 1)
    k = 1;
    while (didx(k) == 1)
        k++;
    end
    crude_idx = [1; crude_idx(k+1:end)];
    didx = diff(crude_idx);
end
% all contiguous segments on the tail become end
if (crude_idx(end) == length(mas))
    k = length(didx);
    while (didx(k) == 1)
        k--;
    end
    crude_idx = [crude_idx(1:k); length(mas)];
    didx = diff(crude_idx);
end
% search contiguous indexes, brute force, need testing !
% TODO something with find(crude_idx > 1)
k0 = 0;
k1 = 0;
idx = [];
for k = 2 : length(crude_idx)
    if ( crude_idx(k) - crude_idx(k-1) <= 3 )
        if (k0 == 0)
            k0 = k-1;
        end
        k1 = k;
    else
        if (k0 == 0)
            % copy
            idx = [idx, crude_idx(k-1)];
        else
            % fusion
            n0 = crude_idx(k0);
            n1 = crude_idx(k1);
            [foo, nmin] = min (mas (n0:n1));
            k0 = 0;
            idx = [idx, n0 + nmin - 1];
        end
    end
end
crude_idx = idx;

% convert crude indexes into the one in the signal
idx = zeros(size(crude_idx));
for k = 1 : length(idx)
    offset = (crude_idx(k)-1) * stp;
    if (offset + nfft > N)
        [foo, idx(k)] = min (as(offset+1:N));
    else
        [foo, idx(k)] = min (as(offset+1:offset+nfft));
    end
    idx(k) = idx(k) + offset;
end

% short time FFT
S = spectrogram(s, sz, nfft, overlap, w);
% short-time PSD
s_psd = S / sz;
s_psd = (s_psd .* conj(s_psd));
s_psd = s_psd(1:sz/2, :) + s_psd(end:-1:sz/2+1, :);
[R, C] = size (s_psd);

if (nargout == 0)

    %figure
    subplot(2, 1, 1);
    t = ((0:N-1)/sr)';
    plot (t, [s, as]);
    xlim([t(1), t(end)]);
    xticks(t(idx));
    grid on;
    legend ('signal', 'amplitude');
    subplot(2, 1, 2);
    t = ((0:stp:N-1)/sr)';
    plot (t, [mas, sqrt(vas)]);
    xlim([t(1), t(end)]);
    xticks(t(crude_idx));
    grid on;
    legend ('mean amplitude', 'amp std dev');

    %figure
    %cmap = 'jet';
    %cmap = 'hot';
    %colormap (cmap);
    %imagesc(t, [0, sr/2], specimg(s_psd, -60));
    %if (8000 < sr/2)
    %    ylim([0, 8000]);
    %end

    clear as;
    clear vs;
    clear S;
    clear idx;
end
