function Snew = OxygenMaps(Snew)


energy = Snew.eVenergy;

[~,opreidx] = min(abs(energy - 525));
[~,opostidx] = min(abs(energy - 550));

opreval = energy(opreidx);
opostval = energy(opostidx);


if opreval > 510 && opreval < 535
else
    disp('missing O pre-edge energy');
end

if opostval > 540 && opostval < 560
else
    disp('Missing O post-edge energy');
end

totO = Snew.spectr(:,:,opostidx) - Snew.spectr(:,:,opreidx);

totO(totO < 0) = 0;

totO = totO .* Snew.binmap;

Snew.totO = totO;



end