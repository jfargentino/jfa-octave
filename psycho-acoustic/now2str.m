function str = now2str( f )
%
%function str = now2str
%function str = now2str( f )
%
%   Conversion du flottant 'f' sortie de NOW
%en une chaine de caractere representant la
%date et l'heure. Si 'f' n'est pas precise,
%l'appel de NOW se fait a l'interieur de le
%fonction.
%
%Voir aussi NOW, SEC2HOUR.
%

if( ~nargin )
   f = now;
end
h   = num2str(floor( rem(f,1)*24 ));
mn  = num2str(floor( rem(rem(f,1)*24,1)*60 ));
sec = num2str(floor( rem(rem(rem(f,1)*24,1)*60,1)*60 ));
str = [ datestr(f,1),',',h,'h',mn,'mn',sec,'s' ];