function Snew = energytest(structORvec)

if isstruct(structORvec)
	Snew = structORvec;
	energy = Snew.eVenergy;
elseif isvector(structORvec)
	energy = structORvec;
end

[Snew.elements.S, Snew.elements.C, Snew.elements.K, Snew.elements.Ca, Snew.elements.N, Snew.elements.O] = deal(0);
[Snew.elements.S_bool, Snew.elements.C_bool, Snew.elements.K_bool, Snew.elements.Ca_bool, Snew.elements.N_bool, Snew.elements.O_bool] = deal(false);
[sPreFlag, sPostFlag, cpreflag, cpostflag, kpreflag, kpostflag, capreflag, capostflag, npreflag, npostflag, opreflag, opostflag] = deal(0);

%% Testing for Sulfur
[~,sPreIdx, sPreFlag] = ClosestValue(energy, 160, [150, 170], 'Display Errors', false);
[~,sPostIdx, sPostFlag] = ClosestValue(energy, 190, [180, 200], 'Display Errors', false);

if sPreFlag == 1 && sPostFlag == 1
    Snew.elements.S = 1;
    Snew.elements.S_bool = true;
end

%% Testing for Carbon
[~,cpreidx] = min(abs(energy - 278));
[~,cpostidx] = min(abs(energy - 320));
cpreval = energy(cpreidx);
cpostval = energy(cpostidx);
if cpreval > 277 && cpreval < 283
	cpreflag = 1;
end

if cpostval > 290 && cpostval < 325
	cpostflag = 1;
end

if cpreflag == 1 && cpostflag == 1
    Snew.elements.C = 1;
    Snew.elements.C_bool = true;
end

%% Testing for Potassium  %must add peak positions.  This is not a simple
%%%% pre/post quantification!!!
[~,kpreidx] = min(abs(energy - 294.5));
[~,kpostidx] = min(abs(energy - 303.5));
kpreval = energy(kpreidx);
kpostval = energy(kpostidx);
if kpreval > 293.5 && kpreval < 295.5
	kpreflag = 1;
end

if kpostval > 301.5 && kpostval < 305.5
	kpostflag = 1;
end

if kpreflag == 1 && kpostflag == 1
    Snew.elements.K = 1;
    Snew.elements.K_bool = true;
end

%% Testing for Calcium
[~,capreidx] = min(abs(energy - 347));
[~,capostidx] = min(abs(energy - 352.5));
capreval = energy(capreidx);
capostval = energy(capostidx);
if capreval > 340 && capreval < 350
	capreflag = 1;
end

if capostval > 350 && capostval < 355
	capostflag = 1;
end

if capreflag == 1 && capostflag == 1
    Snew.elements.Ca = 1;
    Snew.elements.Ca_bool = true;
end

%% Testing for Nitrogen
[~,npreidx] = min(abs(energy - 400));
[~,npostidx] = min(abs(energy - 430));
npreval = energy(npreidx);
npostval = energy(npostidx);
if npreval > 380 && npreval < 410
	npreflag = 1;
end

if npostval > 420 && npostval < 450
	npostflag = 1;
end

if npreflag == 1 && npostflag == 1
    Snew.elements.N = 1;
    Snew.elements.N_bool = true;
end

%% Testing for Oxygen
[~,opreidx] = min(abs(energy - 525));
[~,opostidx] = min(abs(energy - 550));
opreval = energy(opreidx);
opostval = energy(opostidx);
if opreval > 510 && opreval < 535
	opreflag = 1;
end

if opostval > 540 && opostval < 560
	opostflag = 1;
end

if opreflag == 1 && opostflag == 1
    Snew.elements.O = 1;
    Snew.elements.O_bool = true;
end





end