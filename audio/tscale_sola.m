function y = tscale_sola (signal, alpha, N, Sa)
% TimeScaleSOLA.m
% Authors: U. Zölzer, G. De Poli, P. Dutilleux
% Time Scaling with Synchronized Overlap and Add
%
% Parameters:
%
% analysis hop size     Sa = 256 (default parameter)		
% block length          N  = 2048 (default parameter)
% time scaling factor   0.25 <= alpha <= 2 
% overlap interval      L  = 256*alpha/2
%
%--------------------------------------------------------------------------
% This source code is provided without any warranties as published in 
% DAFX book 2nd edition, copyright Wiley & Sons 2011, available at 
% http://www.dafx.de. It may be used for educational purposes and not 
% for commercial applications without further permission.
%--------------------------------------------------------------------------

DAFx_in		=	signal';

%alpha = 1;      % 0.25 <= alpha <= 2 
% Parameters:
if (nargin < 3)
    N     = 2048;
end
if (nargin < 4)
    % Sa must be less than N
    Sa	  =	N/8;
end

Ss	  = round(Sa*alpha);     
L	    = 128;    % L must be chosen to be less than N-Ss 

% Segmentation into blocks of length N every Sa samples
% leads to M segments
M     =	ceil(length(DAFx_in)/Sa);

DAFx_in(M*Sa+N)=0;
y  =  DAFx_in(1:N);

% **** Main TimeScaleSOLA loop ****
for ni=1:M-1
  grain=DAFx_in(ni*Sa+1:N+ni*Sa);
  XCORRsegment=xcorr(grain(1:L),y(1,ni*Ss:ni*Ss+(L-1)));		
  [xmax(ni),km(ni)]=max(XCORRsegment);

  fadeout=1:(-1/(length(y)-(ni*Ss-(L-1)+km(ni)-1))):0;
  fadein=0:(1/(length(y)-(ni*Ss-(L-1)+km(ni)-1))):1;
  Tail=y(1,(ni*Ss-(L-1))+ ...
           km(ni)-1:length(y)).*fadeout;
  Begin=grain(1:length(fadein)).*fadein;
  Add=Tail+Begin;
  y=[y(1,1:ni*Ss-L+km(ni)-1) ...
           Add grain(length(fadein)+1:N)];
end;
% **** end TimeScaleSOLA loop ****

