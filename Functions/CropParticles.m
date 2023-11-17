function out_Snew = CropParticles(in_Snew)
%out_Snew = CropParticles(in_Snew)
%
% Adds the following fields to Snew:
% Snew.partMask
% Snew.rawParts
% Snew.cSpecParts
% Snew.OVFParts
%
Snew = in_Snew;

nParticles = max(max(Snew.LabelMat));

% Preallocation
[partMask, rawParts, cSpecParts, OVFParts] = deal(cell(nParticles,1));
% rawParts = cell(nParticles,1);
% cSpecParts = cell(nParticles,1);
% OVFParts = cell(nParticles,1);

for p = 1:nParticles
    currPartMask = zeros(size(Snew.LabelMat));
    currPartMask(Snew.LabelMat == p) = 1;
    
    tempRaw = Snew.spectr .* currPartMask;
    tempCSpec = Snew.RGBCompMap .* currPartMask;
    tempOVF = Snew.ThickMap(:,:,4) .* currPartMask;
    
    tempOVF(isnan(tempOVF)) = 0;
    
    % This finds the nonzero elements (where the particle is) 
    cropRows = sum(currPartMask,2) ~= 0;
    cropCols = sum(currPartMask,1) ~= 0;
%     rawRows = sum(tempRaw,2) ~= 0;
%     rawCols = sum(tempRaw,1) ~= 0;
    
%     CSpecRows = sum(tempCSpec,2) ~= 0;
%     CSpecCols = sum(tempCSpec,1) ~= 0;
%     
%     OVFRows = sum(tempOVF,2) ~= 0;
%     OVFCols = sum(tempOVF,1) ~= 0;
    
    % Crops each particle and places in a cell array with 2 pixels worth of
    % padding.
    partMask{p} = padarray(currPartMask(cropRows, cropCols),[2,2]);
    rawParts{p} = padarray(tempRaw(cropRows, cropCols),[2,2]);
    cSpecParts{p} = padarray(tempCSpec(cropRows, cropCols,:),[2,2,0]);
    OVFParts{p} = padarray(tempOVF(cropRows, cropCols),[2,2]);
    
end

Snew.CroppedParticles.partMask = partMask;
Snew.CroppedParticles.rawParts = rawParts;
Snew.CroppedParticles.cSpecParts = cSpecParts;
Snew.CroppedParticles.OVFParts = OVFParts;

out_Snew = Snew;











end