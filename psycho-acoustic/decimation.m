function [ppsd, rpsd] = decimation( original, tones_psd, FS, nb, tbw, TNMR )
%
%function out_psd = decimation( original, tones_psd, FS )
%
%   DECIMATION permet d'eliminer la plupart des composantes tonales
%contenues dans la DSP 'tones_psd' grace a des criteres psycho-acoustiques
%comme le masquage. Il est necessaire de fournir egalement la DSP complete 
%du signal par l'intermediaire de 'original' puisque 'tones_psd' n'est que
%la DSP de la partie tonale du signal. 'FS' est la frequence d'echantillonnage
%et 'out_psd' est la DSP de la partie tonale du signal apres decimation.
%
%
%function out_psd = decimation( original, tones_psd, FS, nb )
%
%   Si on veut, on peut garder plus de 20 composantes tonales grace a 'nb'.
%Une valeur de 'nb' a zero signifie que l'on gardera toute les composeantes,
%mais on effectue tout de meme le traitement de decimation.
%
%
%function out_psd = decimation( original, tones_psd, FS, nb, tbw )
%
%	On peut preciser la largeur de la fenetre de decimation en bark grace
%a 'tbw', par defaut c'est 1 bark.
%
%
%function out_psd = decimation( original, tones_psd, FS, nb, tbw, TNMR )
%
%	On peut egalement specifier le coefficient a partir duquel on estime
%qu'un ton est masque par le bruit de la bande critique environnante.
%Par defaut 'TNMR' est a 5dB.
%
%
%REMARQUES: Pour ameliorer la synthese d'environement sonore, c'est a cette
%           fonction qu'il faut apporter des ameliorations.
%
%Voir aussi GET_ALL_TONES, CRITICAL_LIMITS, GET_PERTINENTS.
%

%%%%%%%%%%%% A AMELIORER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %
nn = 7;%le nb de voisins de la frequence que l'on met a 0 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%
Fmin = 20;%
%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% on recupere les arguments %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch( nargin )
 	case 3,
   nb   = 20;
   tbw  = .5;
   TNMR = 3.16227766016838; % 5dB=10^(5/10)
      
   case 4,
   tbw  = .5;
   TNMR = 3.16227766016838; % 5dB=10^(5/10)
      
 	case 5,
   TNMR = 3.16227766016838; % 5dB=10^(5/10)
      
	case 6,
   if( TNMR )
   	TNMR = 10^(TNMR/10);
   end
   
   otherwise,
   disp('Error, invalid number of argument.')
   return   
end% switch( nargin )

if( ( tbw < 0 ) | ( tbw > 25 ) )
   tbw = 1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N     = length(tones_psd);
indx  = find(tones_psd);
ppsd  = zeros(N,1);
rpsd  = original;
incr  = FS/(2*N);
tmpsd = original./threshold(0:incr:(N-1)*incr);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% processus de decimation %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%pour toutes les raies de la dsp des tons...
for( n=1:length(indx) )
   
   %calcul de la bande critique d'une largeur de 'bw' bark
   %autour de la frequence de la raie...
   f       = incr*(indx(n)-1);
   [fd fu] = critical_band( f, tbw );
   if( fu > FS/2 )
      fu = FS/2;
   end% ( fu > FS/2 )
   
   if( (fd==f)&(fu==f) )
      kd = indx(n);
      ku = kd;
   else   
   	kd = floor(fd/incr)+1;
      ku = round(fu/incr);
   end% if( (fd==f)&(fu==f) )
   
   % si le ton n'est pas masque par le bruit...
   if( kd~=ku )
      average = (sum(tmpsd(kd:ku))-tmpsd(indx(n)))/(ku-kd);
   else
      average = 0;%original(kd);
   end% if( kd~=ku )
   
   if( tmpsd(indx(n)) >= TNMR*average )
   	%si la raie consideree est la plus
   	%grande de sa bande critique...
   	[v in]  = max(tmpsd(kd:ku));
   	in      = in + kd - 1;
   	if( in == indx(n) )
         ppsd(indx(n))   = tones_psd(indx(n));
         voisinage       = indx(n)-nn:indx(n)+nn;
         rpsd(voisinage) = average;
      end% if( v == indx(n) )   
   end% if( original(indx(n)) > TNMR*average )
   
end% for( n=1:length(indx) )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% selection des nb partiels les plus pertinents %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( ~nb )
   return
else%( nb~=0 )
   Imin       = round(Fmin/incr);
   %on trie les partiels ponderes par le seuil d'audition
   [tmp indx] = sort(ppsd./threshold(incr*(0:N-1)));
   indx       = flipud(indx);
	nb         = min(nb,length(find(ppsd)));
   indx       = indx(1:nb);
   tmp        = ppsd(indx);
   ppsd       = full(sparse(indx,1,tmp,N,1,nb));
end%if( ~nb )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
