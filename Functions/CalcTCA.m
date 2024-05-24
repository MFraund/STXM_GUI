function SnewOut = CalcTCA(SnewIn)
%% Add a per-particle Total Carbon Absorption (TCA) parameter to Snew
%
% SnewOut = CalcTCA(SnewIn)
%
% Inputs:
%----------
% Snew with TotC and LabelMat as a field
%
% Outputs:
%----------
% Snew.TCA - Vector containing the TCA for each particle in Snew
%
% see also CarbonMapsSuppFigs
SnewOut = SnewIn;

fieldNameBoolArr = isfield(SnewIn, {'TotC', 'LabelMat'});

if ~all(fieldNameBoolArr) %Snew doesn't have correct fields
    disp('supplied Snew doesnnt have both LabelMat and TotC fields');
end

labelMat = SnewIn.LabelMat;
totC = SnewIn.TotC;
nPart = max(max(labelMat));

vectorTCA = [];
for n = 1:nPart
    currPartTCA = mean(totC(labelMat == n),'omitnan'); %averages over totC only where the nth particle is
    vectorTCA = [vectorTCA; currPartTCA];
end

SnewOut.TCA = vectorTCA';

end