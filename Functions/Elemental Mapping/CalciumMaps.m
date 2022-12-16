function Snew = CalciumMaps(Snew, binmap)


%% Input checking
if nargin == 1
	binmap = Snew.binmap;
end

%% Determining closest energy value
energy = Snew.eVenergy;

[~, capreidx] = ClosestValue(energy, 347, [340, 349],'Error Message','Missing Ca pre-edge energy');
[~, capostidx] = ClosestValue(energy, 352.5, [350, 355],'Error Message','Missing Ca post-edge energy');

%% Simple Ca map definition
totCa = Snew.spectr(:,:,capostidx) - Snew.spectr(:,:,capreidx);

totCa(totCa < 0) = 0;

totCa = totCa .* binmap;

Snew.totCa = totCa;



end