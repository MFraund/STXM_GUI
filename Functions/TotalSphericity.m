function  Sout = TotalSphericity(Snew)

Sout = Snew;

totalthicknessmap = Snew.ThickMap(:,:,1) + Snew.ThickMap(:,:,2) + Snew.ThickMap(:,:,3);
currpartthicknessmap = zeros(size(totalthicknessmap));

for i = 1:max(max(Snew.LabelMat))
    
    currpartthicknessmap = totalthicknessmap(Snew.LabelMat == i);
    currpartthickness = max(max(currpartthicknessmap));
    ParticleSphericity(i) = (currpartthickness)./(Snew.Size(i));
    poo=1;%boop
    
    
end

Sout.ParticleSphericity = ParticleSphericity;


SphericityMap = zeros(size(Snew.LabelMat));

for k = 1:max(max(Snew.LabelMat))
    SphericityMap(Snew.LabelMat == k) = Sout.ParticleSphericity(k);
end

asoptest = zeros(size(Snew.LabelMat));
asoptest(SphericityMap >= 0.8) = 1;
smallsphericityidx = SphericityMap > 0 & SphericityMap < 0.8;
asoptest(smallsphericityidx) = 0.1;

% sphericityfig = figure;
% set(sphericityfig,'Units','normalized','Position',[0.15,0.15,0.6,0.5]);
% axh = tight_subplot(1,2,[0.01,0.02],[0.01,0.05],[0.01,0.01]);
% 
% axes(axh(1));
% imagesc(SphericityMap,[0,1]);
% % colorbar;
% title('Particle Sphericity');
% 
% axes(axh(2));
% % subplot(1,2,2)
% imagesc(asoptest,[0,1]);
% colorbar;
% title('Yellow means > 0.8 sphericity');
% 
% for j = 1:2
%    set(axh(j),'XTick',[],'YTick',[]);
% end



end