function Snew_out = SpectraProcessing(Snew_in)

Snew = Snew_in;


[particleSpec, orgSpec, ovfSpec, energy] = deal(cell(0));
[normPartSpec, normOrgSpec, normOVFSpec] = deal(cell(0));

nPart = max(max(Snew.LabelMat));

Snew = CropParticles(Snew);
specmask = Snew.spectr .* Snew.binmap;

for p = 1:nPart
    
    
    currPartMask = zeros(size(Snew.binmap));
    currPartMask(Snew.LabelMat==p) = 1;
    
    
    specPartMask = specmask .* currPartMask;
    specPartMask(isinf(specPartMask)) = NaN;
    
    for k = 1:size(specPartMask,3)
        specPartMask(:,:,k) = medfilt2(specPartMask(:,:,k));
    end
    
    ovfPartMask = specPartMask .* Snew.ThickMap(:,:,4);
    orgPartMask = specPartMask .* Snew.BinCompMap{1} .* ~Snew.BinCompMap{2}; % organic component minus inorganic component gives organic only pixels
    % 		specPartMask = removeoutlier_IQRtest(specPartMask(:));
    currPartSpec = squeeze(mean(mean(specPartMask,2,'omitnan'),1,'omitnan'));
    currOrgSpec = squeeze(mean(mean(orgPartMask,2,'omitnan'),1,'omitnan'));
    currOVFspec = squeeze(mean(mean(ovfPartMask,2,'omitnan'),1,'omitnan'));
    
    currPartSpec = currPartSpec - min(currPartSpec); %making sure values are only positive
    currOrgSpec = currOrgSpec - min(currOrgSpec);
    currOVFSpec = currOVFspec - min(currOVFspec);
    % 		currPartSpec = mean(specPartMask(:),'omitnan');
    particleSpec = [particleSpec; currPartSpec];
    orgSpec = [orgSpec; currOrgSpec];
    ovfSpec = [ovfSpec; currOVFspec];
    
    currEnergy = Snew.eVenergy;
    energy = [energy; currEnergy];
    
    %Will be many copies of the same path, but will preserve particle identification for later
    inputds = [currEnergy, currPartSpec];
    inputOrgDs = [currEnergy, currOrgSpec];
    inputOVFDs = [currEnergy, currOVFSpec];
    
    [~, normPart] = norm2poly_MF(6, inputds, 3, [260, 284, 300, 385]);
    [~, normOrg] = norm2poly_MF(6, inputOrgDs, 3, [260, 284, 300, 385]);
    [~, normOVF] = norm2poly_MF(6, inputOVFDs, 3, [260, 284, 300, 385]);
    % 		normPartSpec = [normPartSpec; STXMfit(currEnergy, currPartSpec)];
    normPartSpec = [normPartSpec; normPart'];
    normOrgSpec = [normOrgSpec; normOrg'];
    normOVFSpec = [normOVFSpec; normOVF'];
        
end

Snew.partEnergy = energy;
Snew.normPartSpec = normPartSpec;
Snew.normOrgSpec = normOrgSpec;
Snew.normOVFSpec = normOVFSpec;

Snew_out = Snew;

end