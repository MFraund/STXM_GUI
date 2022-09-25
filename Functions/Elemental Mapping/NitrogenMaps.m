function Snew = NitrogenMaps(Snew)


energy = Snew.eVenergy;

[~,npreidx] = min(abs(energy - 400));
[~,npostidx] = min(abs(energy - 430));

npreval = energy(npreidx);
npostval = energy(npostidx);


if npreval > 380 && npreval < 410
else
    disp('missing N pre-edge energy');
end

if npostval > 420 && npostval < 450
else
    disp('Missing N post-edge energy');
end

totN = Snew.spectr(:,:,npostidx) - Snew.spectr(:,:,npreidx);

totN(totN < 0) = 0;

totN = totN .* Snew.binmap;

Snew.totN = totN;



end