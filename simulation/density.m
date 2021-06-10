function D = density (T, P, S)
%
% function D = density (T, P, S)
%
%   Programme de calcul de la densite en kg/m^3 a partir de la salinité,
% température et de la pression d'apres MILLERO et POISSON.
%   'T' temperature	en degres celcius (de -2 a 40°)
%   'P'	pression en bars (de 0 a 1000)			
%   'S' salinite en P.S.U. (de 2 a 42)
%

SR=sqrt(abs(S));

% Densité Ro(S,T,P)=Ro(S,T,0)/[1-P/K(S,T,P)] %
% Calcul de la densité de l'eau pure de référence Ro(S,T,0) %
% R1=A (ROw) %
R1=((((6.536332e-9*T-1.120083e-6)*T+1.001685e-4)*T-9.095290e-3)*T+6.793952e-2)*T-28.263737;

% R2=B %
R2=(((5.3875e-9*T-8.2467e-7)*T+7.6438e-5)*T-4.0899e-3)*T+8.24493e-1;

% R3=C %
R3=(-1.6546e-6*T+1.0227e-4)*T-5.72466e-3;

% R4=D %
R4=4.8314e-4;

% Calcul final de RO(S,T,0) %
SIG=(R4*S+R3*SR+R2)*S+R1;

% Volume spécifique à la pression atmosphérique %
R3500=1028.1063;
DR350=28.106331;
V350P=1/R3500;
SVA=-SIG*V350P/(R3500+SIG);
SIGMA=SIG+DR350;
SVAN=SVA*1e8;

% Calcul de K(S,T,P) 'Secant bulk modulus' %
E=(9.1697e-10*T+2.0816e-8)*T-9.9348e-7;
BW=(5.2787e-8*T-6.12293e-6)*T+3.47718e-5;
B=BW+E*S;

D=1.91075e-4;
C=(-1.6078e-6*T-1.0981e-5)*T+2.2838e-3;
AW=((-5.77905e-7*T+1.16092e-4)*T+1.43713e-3)*T-0.1194975;
A=(D*SR+C)*S+AW;

B1=(-5.3009e-4*T+1.6483e-2)*T+7.944e-2;
A1=((-6.1670e-5*T+1.09987e-2)*T-0.603459)*T+54.6746;
KW=(((-5.155288e-5*T+1.360477e-2)*T-2.327105)*T+148.4206)*T-1930.06;
K0=(B1*SR+A1)*S+KW;

DK=(B*P+A)*P+K0;
K35=(5.03217e-5*P+3.359406)*P+21582.27;
GAM=P/K35;
PK=1-GAM;
SVA=SVA*PK+(V350P+SVA)*P*DK/(K35*(K35+DK));

SVAN=SVA*1e8;
V350P=V350P*PK;

DR35P=GAM/V350P;
DVAN=SVA/(V350P*(V350P+SVA));
SIGMA=DR350+DR35P-DVAN;

D=SIGMA+1000;

%!demo
%!
