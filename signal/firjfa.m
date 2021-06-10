function b = firjfa (n, f, m);
%
% function b = firjfa (n, f, m);
%
% n: nb of tap of the FIR filter
% f: frequency band edges, monotonic, 1st element is 0 and last must be 1
%    (half the sampling rate)
% m: frequency response for each frequencies
% TODO spectralize should handle even/odd nb of bins

% construct the frequencies vector
ff = linspace (0, 1 - 1/n, n/2);
nb = length(f);
mm = ones(length(ff), 1);
% for each band edge
for k = 1:nb-1
    % find the index of the nearest frequency beans
    [f0, n0] = min(abs(ff - f(k)));
    [f1, n1] = min(abs(ff - f(k+1)));
    % linear interpolation of the response between the freq edges
    mm(n0:n1) = linspace(m(k), m(k+1), n1 - n0 + 1);
end

% Create the filter (TODO the fftshift)
b = fftshift(real(ifft(spectralize (mm))));

%!demo
%!
%! N = 256;
%! f = [0; 0.45; 0.55; 1];
%! m = [1; 1; 0; 0];
%! b_jfa = firjfa(N, f, m);
%! b_fir2 = fir2(N-1, f, m);
%! s = randn(32*65536, 1);
%! sf = [filter(b_jfa, 1, s), filter(b_fir2, 1, s)];
%! M = 1024;
%! Sf = fold_psd(psdm(sf, 2*M));
%!
%! subplot(2, 1, 1)
%! plot(1:N, b_jfa, 'x', 1:N, b_fir2, 'o');
%! title('low-pass');
%! legend ('firjfa', 'fir2');
%! xlabel('coeffs');
%! grid on;
%! subplot(2, 1, 2)
%! plot((0:M-1)'/M, 10*log10(Sf));
%! xlim([0, (M-1)/M]);
%! grid on;
%! xlabel('freq (norm)');
%! ylabel('dB');
%!

%!demo
%!
%! N = 256;
%! f = [0; 0.25; 0.30; 0.70; 0.75; 1];
%! m = [0; 0; 1; 1; 0; 0];
%! b_jfa = firjfa(N, f, m);
%! b_fir2 = fir2(N-1, f, m);
%! s = randn(32*65536, 1);
%! sf = [filter(b_jfa, 1, s), filter(b_fir2, 1, s)];
%! M = 1024;
%! Sf = fold_psd(psdm(sf, 2*M));
%!
%! subplot(2, 1, 1)
%! plot(1:N, b_jfa, 'x', 1:N, b_fir2, 'o');
%! title('band-pass');
%! legend ('firjfa', 'fir2');
%! xlabel('coeffs');
%! grid on;
%! subplot(2, 1, 2)
%! plot((0:M-1)'/M, 10*log10(Sf));
%! xlim([0, (M-1)/M]);
%! grid on;
%! xlabel('freq (norm)');
%! ylabel('dB');
%! 

%!demo
%!
%! N = 256;
%! f = [0; 0.45; 0.55; 1];
%! m = [0; 0; 1; 1];
%! b_jfa = firjfa(N, f, m);
%! b_fir2 = fir2(N-1, f, m);
%! s = randn(32*65536, 1);
%! sf = [filter(b_jfa, 1, s), filter(b_fir2, 1, s)];
%! M = 1024;
%! Sf = fold_psd(psdm(sf, 2*M));
%!
%! subplot(2, 1, 1)
%! plot(1:N, b_jfa, 'x', 1:N, b_fir2, 'o');
%! title('high-pass');
%! legend ('firjfa', 'fir2');
%! xlabel('coeffs');
%! grid on;
%! subplot(2, 1, 2)
%! plot((0:M-1)'/M, 10*log10(Sf));
%! xlim([0, (M-1)/M]);
%! grid on;
%! xlabel('freq (norm)');
%! ylabel('dB');
%! 

