function h = hilbert_coeff (n, z)
%
% function h = hilbert_coeff (n, [z])
%
%    To get the 2*n+1 Hilbert FIR coefficient, if z is given, its the nb of
% extremum frenquency beans to zeroing, a value of 0 (default) means that the
% 1st and the last beans are zero'ed, if a negative z is given, use sinc 
% formula.
% 
%    After a few tests, it looks like the best frequency cutting shape is a
% rectangular one (I've tested against several standard windowing functions)
% and it is more or less the same result that directly using the sinc
% coefficients. __BUT__, due to the giganormous difference between reference
% and some FIR results with some non-rectangular frequencies shapes, I think
% it should exist some correction coefficients based on the window energy...
%
%    Is there any benefits to cut extremum frequencies? A quick look says that
% error increase (bad), but higher coefficients decrease (good?). More over,
% it looks like, "flat" windows give the best results (gaussian 3, tukey 0.75, 
% none, lanczos ???), depending on nb of coefficients, signal, z...
%
%    At least it looks like getting coefficients from the sinc formula gives
% roughly result as good as the one with the "ifft (fft)" method.
% 

if (nargin < 2)
    z = 0;
end
w = ones (n, 1);
if (z > 0)
    w(1:z) = 0;
    w(end-z+1:end) = 0;
end
if (z < 0)
    h = (2/pi) * sin (pi*(-n:n)'/2).^2 ./ [-n:-1,1,1:n]';
else
    w = [w; 0; w];
    h = - real (fftshift (ifft (-i * sign (-n:n)' .* w)));
end

%!demo
%! %%%%% Signal definition %%%%%
%! sr = 192e3;
%! n = 1024;
%! f = sr / 3;
%! t = (0:round(n*sr/f)-1)' / sr;
%! %s = sin (2*pi*f*t);
%! s = chirp (t, 1e3, t(end), f, 'quadratic');
%! s = [zeros(256, 1); s; zeros(256, 1)];
%!
%! %%%%% Reference calculation %%%%%
%! nh = 64;
%! sh_ref = imag (hilbert (s));
%! sh_ref = [zeros(nh, 1); sh_ref];
%!
%! %%%%% FIR for Hilbert %%%%%
%! zero_nb = 0;
%! for (k = 0:zero_nb)
%!     h(:, k+1) = hilbert_coeff (nh, k);
%!     sh_fir(:, k+1) = filter (h(:, k+1), 1, [s; zeros(nh, 1)]);
%! end
%! %%%%% sinc coeff 
%! h(:, zero_nb + 2) = (2/pi) * sin (pi*(-nh:nh)'/2).^2 ./ [-nh:-1,1,1:nh]';
%! sh_fir(:, zero_nb + 2) = filter (h(:, zero_nb + 2), 1, [s; zeros(nh, 1)]);
%! %%%%% temporal shift
%! %sh_fir = sh_fir(nh + 1 : end, :);
%!
%! figure
%! subplot (3, 1, 1);
%! plot (0:nh, abs (h(nh+1:end, :)));
%! grid on
%! xlim ([0, +nh])
%! legend ('no 0 bean', '1 0 bean', '2 0 bean', '3 0 bean', 'sinc');
%! subplot (3, 1, 2);
%! nend = length (sh_ref) - nh;
%! plot ([sh_ref, sh_fir])
%! grid on;
%! xlim ([1, nend])
%! legend ('fft', 'fir, no 0 bean', 'fir, 1 0 bean', ...
%!         'fir, 2 0 bean', 'fir, 3 0 bean', 'fir, sinc');
%! subplot (3, 1, 3);
%! h_err = abs (repmat (sh_ref, 1, zero_nb + 2) - sh_fir);
%! h_err_sum = sum (h_err) / length (nend)
%! h_err_max = max (h_err)
%! h_err_mean = mean (h_err)
%! h_err_stddev = sqrt (var (h_err))
%! plot (h_err)
%! grid on
%! xlim ([1, nend])
%! str = sprintf ('%d coeff, f0 = %.1fkHz, sr = %.1fkHz', ...
%!                2*nh + 1, f/1000, sr/1000);
%! title (str)
%! legend ('fir, no 0 bean', 'fir, 1 0 bean', ...
%!         'fir, 2 0 bean', 'fir, 3 0 bean', 'fir, sinc');
%!

