function str = sec2hour(s)
%
%function str = sec2hour( s )
%
%   Conversion du nombre de secondes 's' en une
%chaine de caractere 'str' formatee comme suit :
%
%                 h:mn:sec.ms
%
%Voir aussi NOW2STR, NOW.
%

if( s > 1 )
	h   = floor(s/3600);
	s   = s - 3600*h;
	mn  = floor(s/60);
	s   = s - 60*mn;
	se  = floor(s);
	s   = s-se;
   ms  = round(s*1000);
   
   str = [num2str(h),':',num2str(mn),':',num2str(se),'.',num2str(ms)];
   
else
   str = [num2str(1000*s),' ms'];
end

