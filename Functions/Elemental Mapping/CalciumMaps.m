function Snew = CalciumMaps(Snew)


energy = Snew.eVenergy;

[~,capreidx] = min(abs(energy - 347));
[~,capostidx] = min(abs(energy - 352.5));

capreval = energy(capreidx);
capostval = energy(capostidx);


if capreval > 340 && capreval < 349
else
    disp('missing Ca pre-edge energy');
end

if capostval > 350 && capostval < 355 %its not reall post, but rather peak values we're looking for here
else
    disp('Missing Ca post-edge energy');
end

totCa = Snew.spectr(:,:,capostidx) - Snew.spectr(:,:,capreidx);

totCa(totCa < 0) = 0;

totCa = totCa .* Snew.binmap;

Snew.totCa = totCa;



end