function [s, t_sym_s] = mk_sinc(F_Hz, chan, Fsr_Hz, duration_s)
    
    if (nargin < 4)
        duration_s = 1;
    end
    if (nargin < 3)
        Fsr_Hz = 48000;
    end
    if (nargin < 2)
        chan = 2;
    end
    if (nargin < 1)
        F_Hz = Fsr_Hz / 8;
    end
   
    Tsr_s = 1 / Fsr_Hz;
    t_sym_s = ( -duration_s/2 : Tsr_s : +duration_s/2 - Tsr_s )';
    s = sinc(2*F_Hz(1) * t_sym_s);
    for k = 2:length(F_Hz)
        s = [s; sinc(2*F_Hz(k) * t_sym_s)];
    end
    s = repmat(s, 1, chan);

    if (nargout == 0)
        if (min(F_Hz) > 1000)
            f0 = sprintf ('%.1fkHz', min(F_Hz)/1000);
        else
            f0 = sprintf ('%.0fHz', min(F_Hz));
        end
        if (length(F_Hz) == 1)
            ff = f0;
        else
            if (max(F_Hz) > 1000)
                f1 = sprintf ('%.1fkHz', max(F_Hz)/1000);
            else
                f1 = sprintf ('%.0fHz', max(F_Hz));
            end
            ff = sprintf ('%s_to_%s', f0, f1);
        end
        if (duration_s >= 1)
            tt = sprintf ('%.0fs', duration_s);
        else
            tt = sprintf ('%.0fms', 1000*duration_s);
        end
        name = sprintf ('sinc_%s_%s.wav', ff, tt);
        audiowrite(name, 0.95*s, Fsr_Hz, 'BitsPerSample', 24 )
        clear s;
        clear t_sym_s;
    end

endfunction

