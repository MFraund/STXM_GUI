function TestingBeersLaw(Snew)

Scor = Snew; %Corrected Snew

inorg = 'NaCl';
org = 'sucrose';
Sraw = DirLabelOrgVolFrac(Snew,inorg,org,0); %raw Snew

[opre,opost,ipre,ipost] = PreToPostRatioVolFrac(inorg,org);
naclD = 2.16;
sucD = 1.59;

preim = Scor.spectr(:,:,1);
prevec = preim(Snew.binmap==1);

scthickmaps{1} = Scor.ThickMap(:,:,1);
scthickmaps{2} = Scor.ThickMap(:,:,2);
scthickmaps{3} = Scor.ThickMap(:,:,1)+ Scor.ThickMap(:,:,2);

srthickmaps{1} = Sraw.ThickMap(:,:,1);
srthickmaps{2} = Sraw.ThickMap(:,:,2);
srthickmaps{3} = Sraw.ThickMap(:,:,1)+ Sraw.ThickMap(:,:,2);

for i = 1:3
	scthickvec{i} = scthickmaps{i}(Snew.binmap==1);
	srthickvec{i} = srthickmaps{i}(Snew.binmap==1);
end



figure;
% axh = tight_subplot(1,2,[0.01,0.01],[0.01,0.01],[0.01,0.01]);
% set(axh,'NextPlot','add');
hold on;

% axes(axh(1));
p(1) = plot(prevec,srthickvec{1},'Color',[0.2 ,0.6 ,0.2]);
p(2) = plot(prevec,srthickvec{2},'Color',[0.3 ,0.7 ,0.7]);
p(3) = plot(prevec,srthickvec{3},'Color',[0.5 ,0.5 ,0.5]);

od_linevals = linspace(0,6,40);
odpost_linevals = od_linevals .* opost ./ opre;
inT_linevals = od_linevals./(naclD.*ipre.*100);
orgT_linevals = od_linevals./(sucD.*opre.*100);

plot(od_linevals,inT_linevals,'Color',[0,1,1]);
plot(od_linevals,orgT_linevals,'Color',[0,1,0]);

% axes(axh(2));
% p(4) = plot(prevec,scthickvec{1},'Color','g');
% p(5) = plot(prevec,scthickvec{2},'Color','b');
% p(6) = plot(prevec,scthickvec{3},'Color','k');

set(p,'Marker','.','MarkerSize',4,'LineStyle','none');
set(gca,'XLim',[0,3.2],'YLim',[0,1].*10.^-6,'FontWeight','bold','FontSize',15);
xlabel('Optical Density');
ylabel('Thickness');

legend({'Organic','Inorganic','Total','NaCl_{calc}','sucrose_{calc}'});



end