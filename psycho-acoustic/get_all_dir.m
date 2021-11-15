function subdir = get_all_dir(directory)
%
%fonction cell_subdir = get_all_dir( directory )
%
%   Retourne un tableau de cellules contenant les noms des
%sous repertoires contenus dans le repertoire 'directory'.
%
%
%Voir aussi ANALYSE_HARM, ANALYSE_PERT, ANALYSE_PERT_HARM,
%           GET_ALL_FILES.
%
if ( ~nargin )
   directory = '.';
end

command	= ['sdir=dir(''',directory,''');'];
eval(command);
m = 1;
for( n=1:length(sdir) )
   if( sdir(n).isdir )
      tmp{m} = sdir(n).name;
      m = m+1;
   end%if
end%for

if( m>3 )
   subdir      = cell(1,m-3);
   [subdir{:}] = deal(tmp{3:m-1});
else
   subdir = {};
   return
end
