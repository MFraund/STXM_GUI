%[Mixing,Particles] = MixingState(Snew,filedir,names)
%
%Finding the mixing state of a set of STXM data that has already been run
%through the ParticleAnalysisGUI routine which includes LoadImageRawGui and
%CarbonMaps.
%
%Inputs
%------
%Snew (strucure output by CarbonMaps function)
%filedir string filedirectory found by uigetfile when ParticleAnalysis is is called and LoadFromImage is selected (maps)
%names filenames structure found by uigetfile when ParticleAnalysis is called and LoadFromImage is selected (maps)
%
%Outputs
%-------
%Mixing = Structure of mixing state parameters
%Mixing.TotalCompNum = total number of components present (only works w 3)
%Mixing.Hi = Shannon entropy for each particle given as a vector (1xN)
%Mixing.Ha = Average entropy per particle
%Mixing.Hy = Bulk entropy
%Mixing.Di = Per particle diversity
%Mixing.Da = Average diversity per particle
%Mixing.Dy = Average diversity of bulk
%Mixing.Db = interparticle diversity
%Mixing.MixStateChi = Entropy metric which quantifies the mixing state of a
%                       population.  Goes from 0 (internally mixed, all
%                       particles identically mixed) to 1 (externally mixed
%                       multiple particles, each a single component)
%
%Particles = Structure of particle information
%
%Non-Matlab native function dependencies
%------------
%LoadImageRawGui or LoadImageRawGuiMixingState
%AlignStack is compatible but not strictly dependent
%ODstack
%CarbonMaps
%Stacklabs is compatible but not strictly dependent
%ReadHdrWPixelSize
%
%Code by Matthew WF on 5/19/15
%
%
%Mixing state calculations taken from:
%Riemer, N., & West, M. (2013). Quantifying aerosol mixing state with entropy and diversity measures. Atmospheric Chemistry and Physics, 13(22), 11423-11439.

%maybe I should have a structure instead of a separate line for each calc?
%Thickness.soot etc or something?

function [Mixing,Particles] = MixingState(Snew,~,names)
[~,idx278] = min(abs(Snew.eVenergy-278));
[~,idx320] = min(abs(Snew.eVenergy - 320));
% idx278 = Snew.eVenergy>269.6 & Snew.eVenergy<278.4;
% idx320 = Snew.eVenergy>318 & Snew.eVenergy<321;

s278 = Snew.spectr(:,:,idx278); %spectra at 278, 285, 288.6, and 320 eV respectively
%s285 = Snew.spectr(:,:,2); %not needed here
%s288 = Snew.spectr(:,:,3); %not needed here
s320 = Snew.spectr(:,:,idx320);
carbmask = Snew.BinCompMap{1}; %defining masks for easier use
inorgmask = Snew.BinCompMap{2};
sp2mask = Snew.BinCompMap{3};

%hierarchy of particle types is defined.  If pixel has >40% sp2, it is all
%soot due to high density.  If pixel has lots of inorganics it is all
%inorganics.  What's left over must be organic carbon.
inorgonly = inorgmask .* ~sp2mask;
orgonly = carbmask .* ~inorgmask .* ~sp2mask;



uin278 = 15230; %inorganic component was assumed to be ammonium nitrate.
uin320 = 11460; %!!!!not certain where these values are from!!!!
uorg278 = 1100; %values in cm^2/g
uorg320 = 22500;
%usoot278 = 3095; %never used bc 320eV is better for soot
usoot320 = 29556;

Dsoot = 2; %assumed densities in g/cm^3
Din = 1.77;
Dorg = 1.3;


%thickness calculation from rearrangement of two equations which define the
%optical density (OD) at different energies OD(278) = uin278*D*t + uorg278*D*t 
%where u is the mass absorptivity coefficient, D is the density, 
%and t is the thickness of the sample
%Result in cm
Torg = (s320 - ((uin320./uin278).*s278))./((uorg320 - (uin320.*uorg278./uin278)).*Dorg);
Tin = (s278 - uorg278.*Dorg.*Torg)./(uin278.*Din);
%Tsoot278 = (s278./(usoot278.*Dsoot)); %Tsoot320 is better
Tsoot320 = (s320./(usoot320.*Dsoot));

%Torg = ((Snew.spectr(:,:,4)-((uin320am/uin278am).*Snew.spectr(:,:,1)))/((uorg320am-(uin320am.*uorg278am./uin278am)).*Dorg));
%Tin = (Snew.spectr(:,:,1)-uorg278am.*Dorg.*Torg)./(uin278am.*Din);


maskedTorg = Torg.*orgonly; %separating thickness calcs based on particle types
maskedTin = Tin.*inorgonly;
maskedTsoot = Tsoot320.*sp2mask; %picked 320 over 278eV b/c increased absorption

for i = 1:length(names)
    hdridx = strfind(names{i},'.hdr');
    if ~isempty(hdridx)
        hdrname = names{i};
    end
end

% fclose all
% [~,~,~,~,position] = ReadHdrMulti(strcat(filedir,hdrname)); %x/ystep are in microns
position = Snew.position;
xstep = position.xstep;
ystep = position.ystep;
xstepcm = xstep ./ 10000; %converting to cm
ystepcm = ystep ./ 10000;
pixelarea = ystepcm .* xstepcm;

%adding up all thicknesses on top of each other will give total thickness
%per pixel.  This is multiplied by the pixel dimensions to give volume in
%cm^3

Vorg = sum(sum(maskedTorg)).*pixelarea;  
Vin = sum(sum(maskedTin)).*pixelarea;
Vsoot = sum(sum(maskedTsoot)).*pixelarea;

Morg = Vorg.*Dorg; %total masses of each particle type in entire sample
Minorg = Vin.*Din;
Msoot = Vsoot.*Dsoot;

TotalM = Morg + Minorg + Msoot;

MfracSoot = Msoot ./ TotalM;
MfracInorg = Minorg ./ TotalM;
MfracOrg = Morg ./ TotalM;

Numparticles = max(max(Snew.LabelMat)); %total number of particles found

[row,column] = size(Snew.LabelMat); %row and column length of images, LabelMat chosen arbitrarily

Particles = struct('number', 1:Numparticles); %Defining structure
Particles.partmask = zeros(row,column,Numparticles); %preallocating matricies
Particles.partsootT = Particles.partmask;
Particles.partinorgT = Particles.partmask;
Particles.partorgT = Particles.partmask;
Particles.Numparticles = Numparticles; %putting total number of particles into Particles struct
Particles.area = zeros(1,Numparticles);
Particles.AED = Particles.area;
Particles.NumComp = [];

%looping over number of particles and getting thickness of each component
%AND per particle
for i = 1:Numparticles
    z = zeros(row,column); %temporary matrix
    lindex = Snew.LabelMat == i; %picking out each particle to mess with separately
    z(lindex) = 1; %I DON'T THINK LINDEX IS CORRECT (THIS IS NOT NECESSARY I DON'T THINK)
    Particles.area(1,i) = sum(sum(z)).*pixelarea;
    Particles.partmask(:,:,i) = z;
    Particles.partsootT(:,:,i) = maskedTsoot .* z;
    Particles.partinorgT(:,:,i) = maskedTin .* z;
    Particles.partorgT(:,:,i) = maskedTorg .* z;
    Particles.NumComp(i) = any(any(Particles.partsootT(:,:,i))) + any(any(Particles.partinorgT(:,:,i))) + any(any(Particles.partorgT(:,:,i)));
end
Particles.AED = sqrt(4.*Particles.area./pi())*1000; %converting from cm to um

%masses of each component, a vector of masses indexed by particle number)
Particles.partsootM = permute(sum(sum(Particles.partsootT,1),2) .* pixelarea .* Dsoot,[1,3,2]);
Particles.partinorgM = permute(sum(sum(Particles.partinorgT,1),2) .* pixelarea .* Din,[1,3,2]);
Particles.partorgM = permute(sum(sum(Particles.partorgT,1),2) .* pixelarea .* Dorg,[1,3,2]);

Particles.TotalM = Particles.partsootM + Particles.partinorgM + Particles.partorgM;
Particles.Mfrac = Particles.TotalM ./ TotalM;
Particles.CompMfracSoot = Particles.partsootM ./ Particles.TotalM;
Particles.CompMfracInorg = Particles.partinorgM ./ Particles.TotalM;
Particles.CompMfracOrg = Particles.partorgM ./ Particles.TotalM;

%Mixing State parameters

%Defining total number of components
TotalCompNum = max(max(max(Particles.NumComp)));
Mixing = struct('TotalCompNum',TotalCompNum);

%Calculatin Shannon entropy per particle Hi
temp = zeros(3,Numparticles);
temp(1,:) = -Particles.CompMfracSoot .* log(Particles.CompMfracSoot);
temp(2,:) = -Particles.CompMfracInorg .* log(Particles.CompMfracInorg);
temp(3,:) = -Particles.CompMfracOrg .* log(Particles.CompMfracOrg);
temp(isnan(temp)) = 0;
Mixing.Hi = sum(temp);

%Calculating Shannon entropy for average particle Ha
Mixing.Ha = sum(Particles.Mfrac .* Mixing.Hi);

%Calculating Shannon entropy for bulk population Hy
HySootpart = -MfracSoot .* log(MfracSoot);
HySootpart(isnan(HySootpart)) = 0;
HyInorgpart = -MfracInorg .* log(MfracInorg);
HyInorgpart(isnan(HyInorgpart)) = 0;
HyOrgpart = -MfracOrg .* log(MfracOrg);
HyOrgpart(isnan(HyOrgpart)) = 0;
Mixing.Hy =  HySootpart + HyInorgpart + HyOrgpart;

%Calculating four diversity values: i - per particle diversity, a = average
%diversity, y = bulk population diversity, b = interparticle diversity
Mixing.Di = exp(Mixing.Hi);
Mixing.Da = exp(Mixing.Ha);
Mixing.Dy = exp(Mixing.Hy);
Mixing.Db = Mixing.Dy/Mixing.Da;

%Mixing State Index: 0 is externally mixed and 1 is internally mixed
Mixing.MixStateChi = (Mixing.Da - 1)/(Mixing.Dy - 1);

%assignin('base','Mixing',Mixing)
%assignin('base','Particles',Particles)
end