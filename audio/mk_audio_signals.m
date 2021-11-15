function [F_Hz, t_sym_s] = mk_audio_signals(Fsr_Hz)
    
    if (nargin == 0)
        Fsr_Hz = 48000;
    end
   
    % frequencies
    NF     = 24;
    F_Hz   = flipud((Fsr_Hz/2)*ones(NF,1)./power(sqrt(2),0:NF-1)')

    % temporal support
    Np = 128;
    duration_s = Np / F_Hz(1);
    Tsr_s = 1 / Fsr_Hz;
    t_sym_s = ( -duration_s/2 : Tsr_s : +duration_s/2 - Tsr_s )';
    t_s = ( 0 : 1 / Fsr_Hz : +duration_s - Tsr_s )';
    delay_s = [ 1e-3; 3e-3; 10e-3; 30e-3; 100e-3 ];
    delay_sample = round(delay_s * Fsr_Hz);

    % TODO pink noises
    s = randn(size(t_s));
    s = windowing(s / max(abs(s)));
    wav2x24( 'white_noise', s, Fsr_Hz );

    % chirps TODO phase does not works ?
    %s = windowing(chirp(t_s, F_Hz(1), t_s(end), F_Hz(end), 'linear'));
    %s = chirp(t_s, F_Hz(1), t_s(end), F_Hz(end), 'linear', pi/2);
    %wav2x24( 'chirp_lin', s, Fsr_Hz );
    s = chirp(t_s, F_Hz(1), t_s(end), F_Hz(end), 'logarithmic', pi/2);
    s = windowing(chirp(t_s, F_Hz(1), t_s(end), F_Hz(end), 'logarithmic'));
    wav2x24( 'chirp_log', s, Fsr_Hz );

    % sinuses, sawtoothes, square
    for k = 1:NF
        f = F_Hz(k);
        s = sin(2*pi*f*t_s);
        wav2x24( sprintf('sin_%.0fHz', f), windowing(s), Fsr_Hz );
        s(find(s >  0)) = +1;
        s(find(s <= 0)) = -1;
        wav2x24( sprintf('square_%.0fHz', f), windowing(s), Fsr_Hz );
        s = sawtooth(f*t_s);
        wav2x24( sprintf('saw_%.0fHz', f), windowing(s), Fsr_Hz);
    end

    % sincard
    s = [];
    for k = NF:-1:8
        tt = ( -1/(2*F_Hz(1)) : Tsr_s : +1/(2*F_Hz(1)) - Tsr_s )';
        ss = sinc(2*F_Hz(k)*tt);
        s = [s;ss];
    end
    wav2x24( 'sinc', s, Fsr_Hz );

endfunction

function sw = windowing(s, n)
    [r, c] = size(s);
    if ( nargin < 2 )
        n = round(r / 16);
    end
    attack = blackman(2*n);
    release = attack(n+1:end);
    attack =attack(1:n);
    if ( c > 1 )
        attack = repmat(attack, 1, c);
        release = repmat(release, 1, c);
    end
    sw = s;
    sw(1:n, :) = attack .* s(1:n, :);
    sw(end-n+1:end, :) = release .* s(end-n+1:end, :);
endfunction

function wav2x24(name, s, Fsr)
    delay_s = [ 1e-3; 3e-3; 10e-3; 30e-3; 100e-3 ];
    delay_sample = round(delay_s * Fsr);
    for k = 1:length(delay_s)
        w2x24(sprintf('%s_%.0fms', name, 1000*delay_s(k)), s, Fsr, ...
              delay_sample(k));
    end
    w2x24(name, s, Fsr, 1);
endfunction

function w2x24(name, s, Fsr, n)
    if (nargin < 4)
       n = 1;
    end
    wav24( name, [s, [s(n:end); s(1:n-1)]], Fsr )
endfunction

function wav24(name, s, Fsr)
    %audiowrite( [name, '_fs.wav'], s, Fsr, 'BitsPerSample', 24 )
    audiowrite( [name, '.wav'], 0.90*s, Fsr, 'BitsPerSample', 24 )
    %audiowrite( [name, '_6dB.wav'], s/2, Fsr, 'BitsPerSample', 24 )
    %audiowrite( [name, '_20dB.wav'], s/10, Fsr, 'BitsPerSample', 24 )
endfunction

