function out_Snew = CropParticles(in_Snew)
%out_Snew = CropParticles(in_Snew)
%
% Checks to see if carbonmaps and OVF have been ran first
% Adds the following fields to Snew:
% Snew.partMask
% Snew.rawParts
% Snew.cSpecParts
% Snew.OVFParts
%

%% Defining Useful Values
Snew = in_Snew;
nParticles = max(max(Snew.LabelMat));

% Preallocation
[partMask, rawParts, cSpecParts, OVFParts, massParts, bigPartMask] = deal(cell(nParticles,1));

%% Input Checking
CarbonMaps_bool = hasfield(Snew, 'RGBCompMap');
OVF_bool = hasfield(Snew, 'ThickMap');
Mass_bool = hasfield(Snew,'MassMap');


%% Cropping Particle Maps
% Crops each particle and places in a cell array with 2 pixels worth of padding.
for p = 1:nParticles
    currPartMask = zeros(size(Snew.LabelMat));
    currPartMask(Snew.LabelMat == p) = 1;
    
    %Individual Particle Masks
    bigPartMask{p} = currPartMask;
    
    % This finds the nonzero elements (where the particle is) 
    cropRows = sum(currPartMask,2) ~= 0;
    cropCols = sum(currPartMask,1) ~= 0;
    %% Binary Particle Mask
    partMask{p} = padarray(currPartMask(cropRows, cropCols),[2,2]);
    
    %% Raw Spectra
    tempRaw = Snew.spectr .* currPartMask;
    rawParts{p} = padarray(tempRaw(cropRows, cropCols,:),[2,2,0]);
    
    %% Cropped RGB Carbon Maps
    if CarbonMaps_bool
        tempCSpec = Snew.RGBCompMap .* currPartMask;
        cSpecParts{p} = padarray(tempCSpec(cropRows, cropCols,:),[2,2,0]);
    end
    
    %% Cropped OVF Map
    if OVF_bool
        tempOVF = Snew.ThickMap(:,:,4) .* currPartMask;
        tempOVF(isnan(tempOVF)) = 0;
        OVFParts{p} = padarray(tempOVF(cropRows, cropCols),[2,2]);
    end
    
    %% Cropped Mass Map
    if Mass_bool
        totalMassMap = Snew.MassMap.org + Snew.MassMap.inorg + Snew.MassMap.soot;
        tempMassMap = totalMassMap .* currPartMask;
        tempMassMap(isnan(tempMassMap)) = 0;
        massParts{p} = padarray(tempMassMap(cropRows, cropCols), [2,2]);
    end
    
end

%% Defining Outputs
Snew.CroppedParticles.bigPartMask = bigPartMask;
Snew.CroppedParticles.partMask = partMask;
Snew.CroppedParticles.rawParts = rawParts;
Snew.CroppedParticles.cSpecParts = cSpecParts;
Snew.CroppedParticles.OVFParts = OVFParts;
Snew.CroppedParticles.massParts = massParts;

out_Snew = Snew;



end