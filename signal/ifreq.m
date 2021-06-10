function [f, x_anal] = ifreq (x)
%
% Returns the instantaneous normalized frequency of given signal by
% differanciating the phase of its analytic representation.
%
[r, c] = size (x);
x_anal = hilbert (x);
f = [zeros(1, c); diff(unwrap (angle (x_anal))) / (2*pi)];

%!demo
%!
%! fsr = 192e3;
%! ns  = 16384;
%! nz  =  8192;
%! t   = (0:(ns - 1))' / fsr;
%! f0  = 32e3;
%! s   = chirp (t, f0/2, t(end), 2*f0);
%! a = 1; b = 1; c = 1;
%! npz = 4096;
%! pz  = zeros (npz, 1);
%! s   = [a*sin(2*pi*f0*t/2); pz; pz] ...
%!     + [pz; b*sin(2*pi*f0*t); pz] ...
%!     + [pz; pz; c*sin(2*pi*1.5*f0*t);];
%!
%! mean_sz = 128;
%! var_sz = 128;
%! x = [zeros(nz, 1); s; zeros(nz, 1)] + 0.5 * randn (2*nz + 2*npz + ns, 1);
%! tic
%! if (mean_sz > 1)
%!     f = fsr * sliding_mean (ifreq (x), mean_sz);
%! else
%!     f = fsr * ifreq (x);
%! end
%! %f = sliding_mfreq (x, mean_sz, 1, fsr);
%! toc
%! t = (0:2*nz+ns-1)' / fsr;
%! subplot (2, 1, 1)
%! plot (f);
%! subplot (2, 1, 2)
%! plot (sliding_var (diff (f), var_sz))

% TODO variance of differential of instantaneous frequencies could be a good
%      confidence indicator 
% TODO it looks like high freq are more disturbed by low freq than low by high
% TODO if using sliding mean or var, window size should be choosed from
%      instantaneous freq
