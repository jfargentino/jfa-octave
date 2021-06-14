function [s_crest, s_var, s_amp, s_hil] = temporal_analysis (s, sr, w_sz)
%
% function [s_crest, s_var, s_amp, s_hil] = temporal_analysis (s, sr[, w_sz])
% function [s_crest, s_var, s_amp, s_hil] = temporal_analysis (audiofile[, w_sz])
%
% Signal given as an array and its sampling rate, or the name of an audio
% file readable by audioread.
%
% w_sz is the nb of samples to use for the sliding window, by default this is
% a power of 2 +1 around 10ms.
%
% s_crest: crest-factor (see crest_factor)
% s_var  : sliding variance
% s_amp  : instantaneous amplitude in Hilbert meaning
% s_hil  : Hilbert transform, imag(hilbert(s))
%
if (ischar(s))
    % between 1 and 2 arg(s)
    if (nargin == 2)
        w_sz = sr;
    end
    if (nargin == 1)
        w_sz = [];
    end
    [s, sr] = audioread (s);
else
    % between 2 and 3 arg(s)
    if (nargin == 2)
        w_sz = [];
    end
end
if (isempty(w_sz))
    % we want w_sz/sr around 8ms %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    w_sz = round(0.016 * sr);
    sz = pow2(nextpow2(w_sz)-1)
    w_sz = sz + 1;
end

if (1)
[N, chan]  = size(s);
w_sz
dt = w_sz/sr
df = sr/w_sz
end

% "s_amp" is instantaneous amplitude of signal s, in Hilbert sense  
% "s_hil" is the hilbert transform, imag(hilbert(s))
[s_amp, s_hil] = shape (s);
[s_crest, s_mean, s_var] = crest_factor (s, w_sz);

if (nargout == 0)
    t = (0:N-1)'/sr;

    figure
    subplot(2, 1, 1);
    plot (t, [s, s_hil, s_amp, sqrt(s_var)]);
    xlim([t(1), t(end)]);
    grid on;
    legend ('signal', 'hilbert', 'amplitude', 'std dev');

    subplot(2, 1, 2);
    plot(t, sqrt(s_crest));
    xlim([t(1), t(end)]);
    grid on;
    legend ('crest factor');
    
    clear s_var;
    clear s_crest;
    clear s_amp;
    clear s_hil;
end

