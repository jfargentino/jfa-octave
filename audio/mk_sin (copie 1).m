function [s, t_sym_s] = mk_sin(F_Hz, win, chan, Fsr_Hz, duration_s)
    
    if (nargin < 5)
        duration_s = 1;
    end
    if (nargin < 4)
        Fsr_Hz = 48000;
    end
    Tsr_s = 1 / Fsr_Hz;
    if (nargin < 3)
        chan = 2;
    end

    if (nargin < 1)
        F_Hz = Fsr_Hz / 8
    end

    if (nargin < 2)
        % one sinus period
        win = ones (round (Fsr_Hz/F_Hz), 1);
    else
        if (ischar(win))
            % window of 15 full sinus periods passed by name 
            n_win = 15*round (Fsr_Hz/F_Hz);
            win = eval(sprintf('%s(%d)', win, n_win));
        else 
            if (length(win) == 1)
                % window length passed ...
                if ((mod(win, 1) == 0) && (win > 8))
                    % ... as nb of ech
                    win = ones (win, 1);
                else
                    % ... as nb of s
                    win = ones (round(win/Tsr_s), 1);
                end
            end
        end
    end
    
    t_sym_s = ( -duration_s/2 : Tsr_s : +duration_s/2 - Tsr_s )';
    nz = length(t_sym_s) - length(win);
    if (mod(nz, 2) == 1)
        nz = floor(nz/2);
        w = [zeros(nz, 1); win; zeros(nz+1, 1)];
    else
        nz = nz/2;
        w = [zeros(nz, 1); win; zeros(nz, 1)];
    end
    s = sin(2*pi*F_Hz * t_sym_s) .* w;
    s = repmat(s, 1, chan);

    if (nargout == 0)
        if (F_Hz > 1000)
            ff = sprintf ('%.1fkHz', F_Hz/1000);
        else
            ff = sprintf ('%.0fHz', F_Hz);
        end
        if (duration_s >= 1)
            tt = sprintf ('%.0fs', duration_s);
        else
            tt = sprintf ('%.0fms', 1000*duration_s);
        end
        name = sprintf ('sin_%s_%s.wav', ff, tt);
        audiowrite(name, 0.95*s, Fsr_Hz, 'BitsPerSample', 24 )
        clear s;
        clear t_sym_s;
    end

endfunction

