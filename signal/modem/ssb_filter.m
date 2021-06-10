function [b, h] = ssb_filter (N, Fc, window_type, Fl, Fh, Fs)
%
% function [b, h] = ssb_filter (N, Fc, window_type, Fl, Fh, Fs)
%
% ENTREES:
%     N : ordre du filtre
%     Fc : frequence porteuse: 0 Hz ou 8087 Hz (par defaut)
%     window_type: type de fenetre, 'hamming' par defaut, les fenetres
%                  disponibles sont 'hamming', 'hann', 'bartlett', 'triang',
%                  'gausswin', 'barthannwin', 'blackman', 'blackmanharris',
%                  'nuttallwin' et 'flattopwin'.
%     Fl : frequence de coupure basse, 300 Hz par defaut
%     Fh : frequence de coupure haute, 3 kHz par defaut
%     Fs : frequence d'echantillonage, 48 kHz par defaut.
%
% Si aucune sorties, enregistre la reponse en frequence du filtre et un fichier
% texte contenant les coefficients.
%
% SORTIES:
%     b : coefficients du filtre
%     h : reponse (complexe) en frequence du filtre.
%

% Sampling rate
if (nargin < 6)
   Fs = 48000;
end
% High freq cut
if (nargin < 5)
   Fh = 3000;
end
% Low freq cut
if (nargin < 4)
   Fl = 300;
end
% windowinf function
if (nargin < 3)
   window_type = 'hamming';
end
% Carrying freq
if (nargin < 2)
   Fc = 8087;
end
% Filter order
if (nargin < 1)
   N  = 288;
end

% Shiftf cutting freq if needed
if (Fl < Fc)
   Fl = Fc + Fl;
end
if (Fh < Fc)
   Fh = Fc + Fh;
end

nbits = 16;
dBmin = -20 * log10 (2^nbits);

Wl = Fl * 2 / Fs;
Wh = Fh * 2 / Fs;
% band-pass filter and its responses
b  = fir1 (N, [Wl, Wh], window_type);
[h, f] = freqz (b, 1, 32768, Fs);
m_dB = 20 * log10 (abs(h));
m_dB (find (m_dB <= dBmin)) = dBmin;
p_deg = arg (h) * 180 / pi;

if (nargout ~= 0)
   return
end

N_str = num2str (N);
Fs_str = sprintf ('%.0fkHz', Fs / 1000);
Fl_str = sprintf ('%dHz', Fl);
nl = min (find (f >= Fl));
m_dB_l_str = sprintf ('%.3fdB', m_dB(nl));
Fh_str = sprintf ('%dHz', Fh);
nh = min (find (f >= Fh));
m_dB_h_str = sprintf ('%.3fdB', m_dB(nh));

nl0 = min (find (f >= Fc));
nl1 = min (find (f >= (Fc + 2*(Fl-Fc))));
nl = nl0 : nl1;
nh0 = min (find (f >= (Fc + (Fh - Fc)/2)));
nh1 = min (find (f >= (Fh + (Fh - Fc)/2)));
nh = nh0 : nh1;

plot (f(nl), m_dB(nl));
grid on;
title (['type ', window_type, ', Ordre ', N_str, ', Coupure a ', Fl_str, ...
        ' (', m_dB_l_str, '), Frequence ech ', Fs_str]);
ylim ([dBmin, 0]);
ylabel('dB');
xlabel ('Hz');
filename = sprintf ('%s_%d_%s-%s_passe_haut.eps', window_type, N, Fl_str, ...
                    Fh_str);
print (filename, '-landscape', '-color', '-deps');

plot (f(nh), m_dB(nh));
grid on;
title (['type ', window_type, ', Ordre ', N_str, ', Coupure a ', Fh_str, ...
        ' (', m_dB_h_str, '),  Frequence ech ', Fs_str]);
ylim ([dBmin, 0]);
ylabel('dB');
xlabel ('Hz');
filename = sprintf ('%s_%d_%s-%s_passe_bas.eps', window_type, N, Fl_str, ...
                    Fh_str);
print (filename, '-landscape', '-color', '-deps');

plot (f, m_dB);
grid on;
title (['Type ', window_type, ', Ordre ', N_str]);
ylim ([dBmin, 0]);
ylabel('dB');
xlabel ('Hz');
filename = sprintf ('%s_%d_%s-%s.eps', window_type, N, Fl_str, Fh_str);
print (filename, '-landscape', '-color', '-deps');

close all;

filename = sprintf ('%s_%d_%s-%s.txt', window_type, N, Fl_str, Fh_str);
file = fopen (filename, 'w');
fprintf (file, '%+e\n', b);
fclose (file);

clear b;
clear h;

%!demo
%! FC = 8087;
%! blu_filter (280, 0);
%! blu_filter (280, FC);
%! blu_filter (295, 0, 'hann');
%! blu_filter (295, FC, 'hann');
%! blu_filter (311, 0);
%! blu_filter (311, FC);
%! blu_filter (312, 0);
%! blu_filter (312, FC);
%! blu_filter (500, 0);
%! blu_filter (500, FC);
%! blu_filter (512, 0);
%! blu_filter (512, FC);
