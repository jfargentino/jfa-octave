function [ss, s_psd] = sumspec(s, sr, freq_Hz)
%
% function [ss, s_psd] = sumspec(s, sr, freq_Hz)
%
% Returns short-term PSD of s summed for frequencies  freq_Hz.
%
% Signal given as an array and its sampling rate, or the name of an audio
% file.
%
% s_psd is the raw short-term PSD.
%
if (ischar(s))
    if (nargin >= 2)
        freq_Hz = sr;
    else
        freq_Hz = [];
    end
    [s, sr] = audioread (s);
else
    if (nargin < 3)
        freq_Hz = [];
    end
end
if (isempty(freq_Hz))
    freq_Hz = bark2hz((0:1/3:24.5)');
    %freq_Hz = tune([0:.5:8*6]', 440/16, 6);
    %freq_Hz = tune([0:3:8*6]', 55, 6);
end

% work only on mono
s = mean(s, 2);

% make freq_Hz ascending and be sure last element is sr/2
freq_Hz = [0; freq_Hz(:); sr/2];
freq_Hz = sort (freq_Hz);
n = min (find(freq_Hz >= sr/2));
freq_Hz = freq_Hz(1:n);
n = max (find(freq_Hz <= 0));
freq_Hz = freq_Hz(n:end);

% we want sr/nfft < freq_Hz(1)
%sz = pow2(nextpow2(sr/freq_Hz(1)));
sz = pow2(nextpow2(sr/min(diff(freq_Hz))));
nfft = sz;
% 50% overlap
overlap = nfft/2;
% construct freq in Hz for df = f(2)
f = sr*(0:nfft/2-1)'/nfft;

% short-time PSD
w = 'flattopwin';
w = 'blackmanharris';
s_psd = spectrogram(s, sz, nfft, overlap, w) / sz;
s_psd = (s_psd .* conj(s_psd));
s_psd = 2*s_psd(1:sz/2, :);

% sum over given freq
[r, c] = size(s_psd);
k = round(freq_Hz/f(2)) + 1;
ss = zeros(length(k)-1, c);
for n = 1:length(k)-1
    ss(n, :) = sum(s_psd(k(n):k(n+1)-1, :), 1);
end

if (nargout == 0)
    dt = (nfft - overlap)/sr;
    colormap( 'hot' );
    %imagesc([0,(c-1)*dt], [0, (r-1)*f(2)], 10*log10(s_psd));
    %imagesc([0,(c-1)*dt], f, 10*log10(s_psd));
    % normalize each PSD
    %m = max (ss, [], 1);
    %for n = 1:c;
    %    ss(:,n) = ss(:,n)/m(n);
    %end
    imagesc([0,(c-1)*dt], freq_Hz, 10*log10(ss));
    soundsc(s, sr);
    clear ss;
    clear s_psd;
end
