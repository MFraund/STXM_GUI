function Snew = SulfurMaps(Snew)

%the post edge location changes drastically with oxidation state.  A
%post-edge of 190 eV probably only works well with Sulfate

energy = Snew.eVenergy;

[~,spreidx] = min(abs(energy - 160));
[~,spostidx] = min(abs(energy - 190));

spreval = energy(spreidx);
spostval = energy(spostidx);


if spreval > 150 && spreval < 170
else
    disp('missing S pre-edge energy');
end

if spostval > 180 && spostval < 200
else
    disp('Missing S post-edge energy');
end

totS = Snew.spectr(:,:,spostidx) - Snew.spectr(:,:,spreidx);

totS(totS < 0) = 0;

totS = totS .* Snew.binmap;

Snew.totS = totS;



end