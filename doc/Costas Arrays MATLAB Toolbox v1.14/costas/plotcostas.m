function plotcostas(arrays)
%plotcostas(arrays) generates plots of Costas arrays

%	Generates a plot of the Costas arrays which are entered.
%	The zero axis is taken to be the top of the plot.
%   If more than one array is entered then then are plotted side by side.
%
%	Examples
%   --------
%		plotcostas([1 2])
%       % Plot is  0 1
%                  1 0
%
%		plotcostas([1 3 4 2;1 2 4 3])
%       % Plot is 1 0 0 0    1 0 0 0
%                 0 0 0 1    0 1 0 0
%                 0 1 0 0    0 0 0 1
%                 0 0 1 0    0 0 1 0

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

if min(arrays(:)) < 1
    arrays = arrays - min(arrays(:)) +1;
end
marray = max([max(arrays(:)) size(arrays,2)]); 
num=size(arrays,1);
x=ceil(sqrt(num));
for i=1:num
    out=arrays(i,:);
    if num~=1
        subplot(x,x,i)
    end
    plot(1:length(out),marray-out+1,'o'); grid
    set(gca,'XTick',.5+(0:length(out)),'Xlim',.5+[0 length(out)])
    set(gca,'YTick',.5+(0:marray),'Ylim',.5+[0 marray])
    set(gca,'GridLineStyle','-');
    set(gca,'XTickLabel',[],'YTickLabel',[])
    %title([num2str(length(out)) '-by-' num2str(length(out)) ' Costas array no. ' num2str(i)]);
    set(get(gca,'Children'),'MarkerFaceColor','k')
    oldunits = get(gca,'Units');
    set(gca,'Units','Pixels');
    p=get(gca,'Position');
    set(get(gca,'Children'),'MarkerSize',p(3)/max(length(out),marray)/2);
    %set(gca,'LineWidth',1);
    set(gca,'Units',oldunits);
end