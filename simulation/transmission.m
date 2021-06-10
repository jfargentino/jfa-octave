function [Srx, Nrx, AdB] = transmission (Stx, Fs, trans, hydro, pool, T, S)
%
% function [Srx, Nrx, AdB] = transmission (Stx, Fs, trans, hydro, pool, T, S)
%
%     Simulation of a sea water transmit channel in constraint field of given
% dimensions. The bounds are in concrete except the upper one, which is the
% surface. All bound are perfectly smooth. For now, only reflexions due to
% the bottom and the surface are calculated.
%
% Inputs:
%     -Stx: acoustic signal to transmit.
%     -Fs: Sample rate of the acoustic signal Stx.
%     -trans: 3D coordinates of the emitter.
%     -hydro: 3D coordinates of the receiver.
%     -pool: the transmission environment dimensions.
%     -T: sea-water temperature in °C (supposed homogeneous).
%     -S: sea-water salinity in P.S.U. (supposed homogeneous).
%
% Outputs:
%     -Srx: acoustic signal as it will be received by the receiver, without the
%           the blank offset du to the propagation delay.
%     -Nrx: the nb of offset's samples du to the propagation delay.
%     -Adb: the attenuation (in dB) of the direct wave.
%
% Files needed:
%     -mfreq.m: for the signal mean frequency determination.
%     -simpleAbsorption.m: for the attenuation function of the frequency.
%     -celerity.m: for the sound velocity calculation.
%     -range.m: to calculate distance between 2 given points.
%     -reflexion.m: for the reflexion attenuation on bounds.
%
% TODO:
%     -Reflexion on other bounds.
%     -Temperature (and salinity?) non-homogeneous, thermocline.
%     -Bounds not smooth.
%     -Bounds not only in concrete.
%     -Diffraction effects.
%     -Sea water act as a filter, not simply calculates attenuation at signal's
%      central frequency.
%     - ...
%

% mettre le signal en colonne
Stx = Stx(:);

% impedances acoustiques = vitesse*masse volumique
Cbeton = 4000;
Mbeton = 2200;
Cair   = 340;
Mair   = 1.3;

% attenuation due a la frequence centrale du signal
f   = mfreq (Stx, Fs); % frequence centrale du signal
% FIXME looks like a is in given per km, thus we take 1
% a_f = simpleAbsorption (f / 1000, T);
a_f = 1;

% retard et attenuation du signal direct
Rdirect = range (trans, hydro);
c = celerity (T, (trans(3) + hydro(3))/20, S); % Celerite moyenne sur le trajet direct
Ndirect = round ((Rdirect/c) * Fs); % retard en nb echantillons
Sdirect = Stx / (a_f * Rdirect); % signal attenue
AdB     = 20 * log10 (a_f * Rdirect); % Attenuation en dB
%Mdirect = max (abs (Sdirect))

if (isempty (pool))
   Srx = Sdirect;
   Nrx = Ndirect;
   return;
end

% Reflechi surface, interface eau / air
surface = [0, 0, 1, 0];
[Rsurface, dt, Asurface] = reflected (trans, surface, hydro, T, S, Cair, Mair);
% Retard du reflechie surface
Nsurface = round (dt * Fs);
% Signal reflechi surface
Ssurface = Asurface * Stx / (a_f * Rsurface);
%Msurface = max (abs (Ssurface))

% Reflechi fond, interface eau / beton
if (pool (3) ~= Inf)
   bottom = [0, 0, 1, -pool(3)];
   [Rbottom, dt, Abottom] = reflected (trans, bottom, hydro, T, S, ...
                                       Cbeton, Mbeton);
   % Retard du reflechie surface
   Nbottom = round (dt * Fs);
   % Signal reflechi fond
   Sbottom = Abottom * Stx / (a_f * Rbottom);
   %Mbottom = max (abs (Sbottom))
else
   Nbottom = Nsurface;
   Sbottom = zeros (length (Ssurface), 1);
end

% Somme des signaux direct et reflechis
Nrx      = Ndirect;
Nsurface = Nsurface - Nrx;
Nbottom  = Nbottom  - Nrx;
Nmax     = max (Nsurface, Nbottom);
Omax     = zeros (Nmax, 1);
Osurface = zeros (Nsurface, 1);
Obottom  = zeros (Nbottom, 1);
Psurface = zeros (Nmax - Nsurface, 1);
Pbottom  = zeros (Nmax - Nbottom, 1);
Sdirect  = [Sdirect; Omax];
Ssurface = [Osurface; Ssurface; Psurface];
Sbottom  = [Obottom;   Sbottom;  Pbottom];
Srx      = Sdirect + Ssurface + Sbottom;
