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
        F_Hz = Fsr_Hz / 8;
    end

    if (nargin < 2)
        % one sinus period
        n_win = round (Fsr_Hz/F_Hz);
        win = 'ones';
    else
        if (ischar(win))
            % window of 15 full sinus periods passed by name 
            n_win = 15*round (Fsr_Hz/F_Hz);
        else 
            if (length(win) == 1)
                % window length passed ...
                if ((mod(win, 1) == 0) && (win > 8))
                    % ... as nb of ech
                    n_win = win;
                else
                    % ... as nb of s
                    n_win = round(win/Tsr_s);
                end
                win = 'ones';
            else
                % FIXME explicit window
                n_win = length(win);
                winwin = repmat(win, 1, length(F_Hz));
                win = 'ones'
            end
        end
    end
    
    t_sym_s = ( -duration_s/2 : Tsr_s : +duration_s/2 - Tsr_s )';
    nz = length(t_sym_s) - n_win(1);
    w = eval(sprintf('%s(%d)', win, n_win(1)));
    if (mod(nz, 2) == 1)
        nz = floor(nz/2);
        w = [zeros(nz, 1); w; zeros(nz+1, 1)];
    else
        nz = nz/2;
        w = [zeros(nz, 1); w; zeros(nz, 1)];
    end
    s = sin(2*pi*F_Hz(1) * t_sym_s) .* w;
    for k = 2:length(F_Hz)
        nz = length(t_sym_s) - n_win(k);
        w = eval(sprintf('%s(%d)', win, n_win(k)));
        if (mod(nz, 2) == 1)
            nz = floor(nz/2);
            w = [zeros(nz, 1); w; zeros(nz+1, 1)];
        else
            nz = nz/2;
            w = [zeros(nz, 1); w; zeros(nz, 1)];
        end
        s = [s; sin(2*pi*F_Hz(k) * t_sym_s) .* w;];
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
        name = sprintf ('sin_%s_%s.wav', ff, tt);
        audiowrite(name, 0.95*s, Fsr_Hz, 'BitsPerSample', 24 )
        clear s;
        clear t_sym_s;
    end

endfunction

