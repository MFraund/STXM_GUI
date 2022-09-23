function Snew = PotassiumMaps(Snew)

%must add peak positions.  This is not a simple
% pre/post quantification!!!
energy = Snew.eVenergy;

[~,kpreidx] = min(abs(energy - 294.5));
[~,kpostidx] = min(abs(energy - 303.5));

kpreval = energy(kpreidx);
kpostval = energy(kpostidx);


if kpreval > 293.5 && kpreval < 295.5
else
    disp('missing K pre-edge energy');
end

if kpostval > 301.5 && kpostval < 305.5
else
    disp('Missing K post-edge energy');
end

totK = Snew.spectr(:,:,kpostidx) - Snew.spectr(:,:,kpreidx);

totK(totK < 0) = 0;

totK = totK .* Snew.binmap;

Snew.totK = totK;



end