function [S, Snew, Mixing, Particles] = SingStackProcMixingStateOutputNOFIGS(datafolder, threshlevel, binadjtest, givenbinmap, varargin)

%[S, Snew, Mixing, Particles] = SingStackProcMixingStateOutputNOFIGS(datafolder, threshlevel, binadjtest, givenbinmap,varargin)

%
%
% This script processes stxm data found in "RawDir" and places it in
% "FinDir". In FinDir, the stack data will be saved in the array Snew.
% INPUT: RawDir - string containing path to raw stxm data
%        FinDir - string containing path to aligned data in OD
%        Name - name of raw stxm data folder to be processed
%        varargin{1} - vector of energies to be removed from stack
% OCT 2009 RCM
%
% Modified 9/24/15 by Matthew Fraund at University of the Pacific
% Modified 9/23/22 by Matthew Fraund again

%% Input Checking Before Code

%Extracting variable argument input
[varargin,inorganic] = ExtractVararginValue(varargin,'inorganic','NaCl');
[varargin,organic] = ExtractVararginValue(varargin,'organic','sucrose');
[varargin,givenStruct] = ExtractVararginValue(varargin,'givenStruct',[]);
[varargin,threshMethod] = ExtractVararginValue(varargin,'Thresh Method','adaptive');

if ~exist('threshlevel','var')
    threshlevel = 2;
end

if ~exist('binadjtest','var')
    binadjtest = 0;
end

if ~exist('givenbinmap','var')
    givenbinmap = 0;
end

%% Loading Stack Info
cd(datafolder) %% move to raw data folder
foldstruct = dir; % makes a structure out of all folders

% Load Stack Data unless stack is alraedy given, then short circuit
numobj=length(foldstruct);
if isempty(givenStruct)
	S = LoadStackRawMulti(pwd); %% load stack data
else
	S = givenStruct; %TODO test if this is the correct use for givenstruct
end


% If energy values were saved but no spectra were collected, make empty array as placeholder
sdim=size(S.spectr);
if sdim(3)>length(S.eVenergy)
	S.spectr=S.spectr(:,:,1:length(S.eVenergy));
end

filenames = cell(1,1);
cnt=1;
for i = 1:numobj %% loops through stack folders in raw data folder
	
	hdridx=strfind(foldstruct(i).name,'.hdr');	%Tests if current item is a .hdr file
	if ~isempty(hdridx)
		S.particle=sprintf('%s',foldstruct(i).name(1:hdridx-1));
		cnt = cnt+1;
	end
	
	ximidx = strfind(foldstruct(i).name,'.xim');
	if ~isempty(ximidx) || ~isempty(hdridx) %if item is relevant to data anlysis, save it to filenames cell
		filenames{cnt} = foldstruct(i).name;
		cnt= cnt+1;
		continue
	end
end

% S = RemoveHorizStreaks_STXM(S);
%% AlignStack
S = AlignStack(S);

%% OdStack
if length(S.eVenergy)<3
% 	Snew=OdStack(S,'map',0,'no',threshlevel);
	Snew=OdStack(S,'map','Auto Gamma','yes', 'imadjust_gamma', threshlevel);
else
% 	Snew=OdStack(S,'adaptive',0,'no',threshlevel);
	disp(threshMethod);
	Snew=OdStack(S,threshMethod, 'Auto Gamma','yes', 'imadjust_gamma', threshlevel);
end

%% Elemental Maps (CarbonMaps)
Snew = energytest(Snew);

%this is only used if a FOV is analyzed but DOESNT have carbon data (rare
%for us).  If carbon data is present, this is overwritten
Snew = makinbinmap(Snew);

if Snew.elements.C == 1
	
	if binadjtest == 1
		Snew = CarbonMapsSuppFigs(Snew,0.35,1,1,'given',givenbinmap);
		savedbinmap = givenbinmap;
	else
		Snew=CarbonMapsSuppFigs(Snew,0.35);
	end
    Snew = DirLabelOrgVolFrac(Snew,inorganic,organic);
%     [Mixing, Particles] = MixingState(Snew,datafolder,filenames);
	Particles = ParticlesInfo(Snew);
	Mixing = 0;
else
% 	[~, Particles] = MixingState(Snew,datafolder,filenames);
	Mixing = 0;
	Particles = ParticlesInfo(Snew);
	disp([datafolder,' HAS NO CARBON DATA']);
end

if Snew.elements.S == 1
    Snew = SulfurMaps(Snew);
end

if Snew.elements.K == 1
    Snew = PotassiumMaps(Snew);
end

if Snew.elements.Ca == 1
    Snew = CalciumMaps(Snew);
end

if Snew.elements.N == 1
    Snew = NitrogenMaps(Snew);
end

if Snew.elements.O == 1
    Snew = OxygenMaps(Snew);
end

if Snew.elements.C == 1 && Snew.elements.N == 1 && Snew.elements.O == 1
    Snew = CNOeleMaps(Snew);
end

%% Version Checking
%%%this is to signify the new version of
%%%SingSTackProcMixingStateOutputNOFIGS has been run, which includes the
%%%above maps data (even if none exists);
mapstest = 1;

%% Saving Data and moving out of folder
save(sprintf('%s%s','../','F',S.particle),'-v7.3');

cd('..');
end