function [Sout] = DirLabelOrgVolFrac(Snew,inorganic,organic,varargin)
%% [Sout]=DirLabelOrgVolFrac(Snew,inorganic,organic)
% Calculates organic volume fraction
%
% If inorganic and organic are blank, NaCl and adipic acid are used
% respectively
%
% varargin{1} accepts 1 or 0, chooses to run or skip the "high OD
% correction" segment
%
% Need to run CarbonMaps.m first

%% OUTPUTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sout.VolFrac is a vector of individual particle volume fractions
% Sout.ThickMap is a map of inorganic and inorganic thicknesses as well as a volume fraction map
% Sout.MassMap is a map of masses calculated from the above thicknesses and the assumptions about density

%% To do list:
% 1. handle thick inorganic regions
% 2. Incorporate to DirLabelMapsStruct.m (which feeds the ParticleAnalysis2 app)

%% Define varibles from CarbonMaps
Mask = Snew.binmap;
LabelMat = Snew.LabelMat;

%% Find energies
% pre edge energy
[~,preidx] = ClosestValue(Snew.eVenergy, 278,[260,283],'Error Message', '---Cant find C pre-edge (278 eV)---');

% post edge energy
[~,postidx] = ClosestValue(Snew.eVenergy, 320,[310,330],'Error Message', '---Cant find C post-edge (320 eV)---');

% sp2 absorption
[~,sp2idx] = ClosestValue(Snew.eVenergy, 285.4,[284.5,285.6],'Error Message', '---Cant find sp2 transition energy (285.4 eV)---');

% sp2flag = 1;
% if sp2val < 284.5 || sp2val > 285.6
% 	disp('----Cant find sp2 transition energy (285.4 eV)----');
% 	sp2flag = 0;
% end

% cidx=find(Snew.eVenergy>288 & Snew.eVenergy<289);
% if isempty(cidx)
%     cidx=postidx;
% end

preim=Snew.spectr(:,:,preidx);
postim=Snew.spectr(:,:,postidx);

%% Input checking
if nargin < 3
    inorganic = 'NaCl';
    organic = 'adipic';
end

[varargin, CaCO3_flag] = ExtractVararginValue(varargin,'CaCO3 Flag', 0);
[varargin, highODcorrectionflag] = ExtractVararginValue(varargin,'High OD Correction', 1);

%% Getting mass absorption coefficients
[uorgpre,uorgpost,uinorgpre,uinorgpost]=PreToPostRatioVolFrac(inorganic,organic); %% get calculated cross sections in cm^2/g

%% Density of common compounds
inorglist =     {'(NH4)2SO4','NH4NO3','NaNO3','KNO3','Na2SO4','NaCl','KCl','Fe2O3','CaCO3','ZnO','Pb(NO3)2','Al2Si2O9H4'};
inorgdenslist = {1.77       ,1.72    ,2.26   ,2.11  ,2.66    ,2.16  ,1.98 ,5.24   ,2.71   ,5.61 ,4.53      ,2.60}; % g/cm^3

orglist =       {'adipic','glucose','oxalic','sucrose','tricarboxylic acid','pinonic acid','pinene'};
orgdenslist =   {1.36    ,1.54     ,1.9     ,1.59	  ,1.7				   ,1.1			  ,0.86}; % g/cm^3
orgMWlist =		{146.1412,180.156  ,90.03   ,34.2965  ,176.12			   ,184.235		  ,136.24};
orgCnumlist =	{6       ,6        ,2       ,12		  ,6				   ,10			  ,10}; %number of carbons in given organic

sootDens = 1.8; % g/cm^3
sootMW = 12.01;

%% Picking from above list based on fxn inputs
inorgDens=inorgdenslist{strcmp(inorglist,inorganic)}; %this picks the density coresponding with the inorganic chosen above

orgDens=orgdenslist{strcmp(orglist,organic)}; 
orgMW = orgMWlist{strcmp(orglist,organic)};

orgNc = orgCnumlist{strcmp(orglist,organic)};

%% Helpful substitution -- added 1/9/17
xin=uinorgpost./uinorgpre; % unitless
xorg=uorgpre./uorgpost;

%% Calculating organic thickness
% torg=(postim-xin.*preim)./(uorgpost.*orgDens+xin.*uorgpre.*orgDens); %
% ^^ old def before 1/9/2017 - note sign difference with the following:
torg = (postim-xin.*preim)./(uorgpost.*orgDens-xin.*uorgpre.*orgDens); % in cm
torg(torg<0) = 0; % no negative thicknesses

torg = torg .* (1e6/1e2); % convert to micrometers

%% Calculating inorganic thickness -- updated due to error 1/9/17

if CaCO3_flag == 1
	CaSnew = CalciumMaps(Snew);
	totCa = CaSnew.totCa;
	caco3Dens = inorgdenslist{9};
	
	[~,~,ucapre,ucapost]=PreToPostRatioVolFrac('CaCO3',organic);
	
	tCa = totCa / ((ucapost - ucapre)*caco3Dens);
end

% figure,imagesc(torg),colorbar;
% tinorg=(preim-uorgpre.*((postim-xin.*preim)./(uorgpost+xin.*uorgpre)))./...
%     (uinorgpre.*inorgDens);
tinorg = (preim-xorg.*postim)./(uinorgpre.*inorgDens-xorg.*uinorgpost.*inorgDens);
tinorg(tinorg<0) = 0;

tinorg = tinorg .* (1e6/1e2); % convert to micrometers

%% Thickness calc using matrix multiplication
%normal
A = [...
	uinorgpre*inorgDens,	uorgpre*orgDens;	...
	uinorgpost*inorgDens,	uorgpost*orgDens	];
B = cat(3, preim, postim);
Bnew = permute(B, [3, 1, 2]);
C = pagemtimes(inv(A), Bnew);
tinorg_mat = squeeze(C(1,:,:));
torg_mat = squeeze(C(2,:,:));

% calcium

%% Helpful values
% figure,imagesc(tinorg),colorbar;
% figure,imagesc(volFraction),colorbar
MatSiz=size(LabelMat);
XSiz=Snew.Xvalue/MatSiz(1); % in microns
YSiz=Snew.Yvalue/MatSiz(2);
xdat=[0:XSiz:Snew.Xvalue];
ydat=[0:YSiz:Snew.Yvalue];
pixelsize=mean([XSiz,YSiz]);

%% Correct for thick inorganic regions assuming thickness is that of a cube
ODlim = 1.5;
if highODcorrectionflag == 1
	if sum(preim(preim>ODlim))>0 % if the particle contains thick regions with OD>1.5
		for i=1:max(max(LabelMat)) % loop over each particle
			npix=length(preim(LabelMat==i & preim>ODlim)); %count pixels in ith particle that have OD>1.5
			if npix == 0
				continue
			end
			
			highodim = zeros(size(LabelMat));
			highodim(LabelMat == i) = 1;
			highodim(preim < ODlim) = 0;
			rowvec = sum(highodim,1);
			colvec = sum(highodim,2);
			zerocols = find(rowvec==0);
			zerorows = find(colvec==0);
			
			highodim(zerorows,:) = [];
			highodim(:,zerocols) = [];
			
			[highod_ysize , highod_xsize] = size(highodim);
			
			%this chooses the smallest value.  this will better approximate
			%things like a rectangle, where the height is most likely equal to
			%the shorter side.  sqrt(npix) is still included because for
			%sprawling, fractal regions that are large but contain few pixels,
			%using x or y size would overestimate these regions.
			pixel_thickness = min([highod_ysize, highod_xsize, sqrt(npix)]);
			% 		pixel_thickness = sqrt(npix);
			
			thickness=pixel_thickness.*pixelsize; % calculate inorganic the thickness based on that of a cube (works for big NaCl inclusions) -- thickness in micrometers
			tinorg(LabelMat==i & preim>ODlim)=thickness; % for the ith particle, replace OD>1.5 thicknesses with geometric correction
			
			torg(LabelMat==i & preim>ODlim) = 0;
		end
	end
end
%% Correct for soot containing particles (per-pixel correction)
tsoot=zeros(size(torg));
if ~isnan(sp2idx)
	tsoot = (Snew.sp2 .* Snew.BinCompMap{3})  .*  (orgNc .* torg .* orgDens ./ orgMW)  .*  (sootMW ./ sootDens); % in micrometers -- the orgDens and sootDens are in g/cm^3 but they cancel each other out
	torg(Snew.BinCompMap{3}==1) = (1 - Snew.sp2(Snew.BinCompMap{3}==1)) .* torg(Snew.BinCompMap{3}==1);
end

%% Calculate Organic Volume Fraction
volFraction=torg./(torg+tinorg+tsoot);
volFraction(Mask==0)=0;

%% Calculating Mass Maps from Thickness Maps
MassMap.org = (torg .* XSiz .* YSiz) .* orgDens .* (1e3 ./ 1e2)^3 ; % in micrograms
MassMap.inorg = (tinorg .* XSiz .* YSiz) .* inorgDens .* (1e3 ./ 1e2)^3 ; % in micrograms
MassMap.soot = (tsoot .* XSiz .* YSiz) .* sootDens .* (1e3 ./ 1e2)^3 ; % in micrograms

%% Integrate volume fractions for individual particles
volFrac=zeros(max(max(LabelMat)),1);
MassFrac = zeros(max(max(LabelMat)),1);
for i=1:max(max(LabelMat)) % loop over particles
    sumOrgThick=nansum(torg(LabelMat==i));
    sumInorgThick=nansum(tinorg(LabelMat==i));
	sumSootThick = nansum(tsoot(LabelMat==i));
    volFrac(i)=sumOrgThick./(sumOrgThick+sumInorgThick+sumSootThick);
	
	sumOrgMass=nansum(MassMap.org(LabelMat==i));
    sumInorgMass=nansum(MassMap.inorg(LabelMat==i));
	sumSootMass = nansum(MassMap.soot(LabelMat==i));
    MassFrac(i)=sumOrgMass./(sumOrgMass+sumInorgMass+sumSootMass);
end

%% Prepare outputs
ThickMap(:,:,1) = torg;
ThickMap(:,:,2) = tinorg;
ThickMap(:,:,3) = tsoot;
ThickMap(:,:,4) = volFraction;


Snew.MassFrac = MassFrac;
Snew.ThickMap = ThickMap;
Snew.MassMap = MassMap;
Snew.VolFrac = volFrac;
Snew.OVFassumedorg = organic;
Snew.OVFassumedinorg = inorganic;

Sout=Snew;



end


