function hertz = bark2hz(bark)
%
% function hertz = bark2hz( bark )
%
%   BARK2HZ converts Bark values into Hertz.
%
%See HZ2BARK, CRITICAL_BAND.
%

%warning off;
opt = optimset('Display','off');
[R, C] = size (bark);
hertz = zeros(R,C);
for ( r = 1 : R )
    for ( c = 1 : C )
        %f = inline(strcat('hz2bark(x)-',num2str(bark(n))));
        %guess = a_bark2hz(bark(n));
        %hertz(n) = fsolve(f,guess);
        hertz(r, c) = fsolve( inline( strcat( 'hz2bark(x)-',           ...
                                               num2str(bark(r,c)) ) ), ...
                              approximate_bark2hz(bark(r,c)),          ...
                              opt );
    end
end
%warning on;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Fonction approximante necessaire pour l'algo de recherche de%
%la racine de l'equation.%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function hertz = approximate_bark2hz(bark)
hertz = 1960*(bark+0.53)./(26.28-bark);
%!demo
%!
%! bark2hz((0:25)')
%!
