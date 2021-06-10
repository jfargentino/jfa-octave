function a = thorpAbsorption (f_kHz)
%
% function a = thorpAbsorption (f_kHz)
%
% Sound absorption coefficient from Thorp formula,
% used in the Atlantic ocean for frequency below 50kHz.
% TODO is the return in dB/km?
% TODO another Thorp formula founds is:
% AdB/km = 1.0936 * ( 0.1*f2/(1 + f2) + 40*f2/(4100 + f2) )

if (f_kHz > 50)
    warning ('Thorp formula is valid below 50kHz');
end
f2 = f_kHz .* f_kHz;
a  = 0.001 + 0.003*f2 + 0.1094*f2/(1 + f2) + 43.75*f2/(4100 + f2);
