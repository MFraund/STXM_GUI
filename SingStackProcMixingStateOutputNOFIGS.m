function [S, Snew, Mixing, Particles] = SingStackProcMixingStateOutputNOFIGS(datafolder, varargin)
%% Processing of a single stack or map
%
% [S, Snew, Mixing, Particles] = SingStackProcMixingStateOutputNOFIGS(datafolder, threshlevel, binadjtest, givenbinmap,varargin)
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
% see also LoadStackRawMulti, AlignStack, OdStack, energytest,
% CarbonMapsSuppFigs

%% Input Checking Before Code

%Extracting variable argument input
%% Support for passing parameters to overwrite LoadStackRawMulti
[varargin,givenStruct] = ExtractVararginValue(varargin,'givenStruct',[]);

%% Support for passing parameters to DirLabelOrgVolFrac
[varargin,inorganic] = ExtractVararginValue(varargin,'inorganic','NaCl');
[varargin,organic] = ExtractVararginValue(varargin,'organic','sucrose');

%% Support for passing parameters to OdStack
[varargin,threshMethod] = ExtractVararginValue(varargin,'Thresh Method','adaptive');
[varargin, autoGammaFlag] = ExtractVararginValue(varargin, 'Auto Gamma', 1);
[varargin,gammaLevel] = ExtractVararginValue(varargin,'Gamma Level',2);
[varargin, rmPixelSize] = ExtractVararginValue(varargin, 'Remove Pixel Size', 7);
[varargin, manualIoCheck] = ExtractVararginValue(varargin, 'Manual Io Check', 'no');


%% Support for passing parameters to CarbonMapsSuppFigs

[varargin, spThresh] = ExtractVararginValue(varargin, 'sp2 Threshold', 0.35);
[varargin, inorgThresh] = ExtractVararginValue(varargin, 'Inorganic Threshold', 0.5);
[varargin, carbonLimitSN] = ExtractVararginValue(varargin, 'Carbon SN Limit', 3);
[varargin, sp2LimitSN] = ExtractVararginValue(varargin, 'SP2 SN Limit', 3);
[varargin, preLimitSN] = ExtractVararginValue(varargin, 'Pre-edge SN Limit', 3);
[varargin, prepostLimitSN] = ExtractVararginValue(varargin, 'PrePost SN Limit', 3);
[varargin, givenBinMap] = ExtractVararginValue(varargin,'Bin Map',[]); % Currently unused
[varargin, manualBinmapCheck] = ExtractVararginValue(varargin,'Manual Binmap','no');
[varargin, clearBinmapBorder_bool] = ExtractVararginValue(varargin, 'Clear Binmap Border', true);

%% Loading Stack Info
if isfolder(datafolder)
    cd(datafolder) %% move to raw data folder
elseif isfile(datafolder)
    [currFolder,currFile,currExt] = fileparts(datafolder);
    
    if contains(currExt,'.mat')
        fovname = [currFile(2:end), currExt]; %removing the 'F' in front of saved files
        try
            loadedDataFolder = load(datafolder, 'datafolder');
            datafolder = loadedDataFolder.datafolder;
            cd(datafolder);
            currdir = dir(datafolder);
        catch
            currdir = dir(currFolder);
        end
        
    elseif contains(currExt,'.hdr') | contains(currExt,'.xim')
        containingFolder = fullfile(fileparts(filedirs{j}),'..');
        currdir = dir(containingFolder);
    end
    %cd(fileparts(datafolder));
end
foldstruct = dir; % makes a structure out of all folders

% Load Stack Data unless stack is alraedy given, then short circuit
numobj=length(foldstruct);
if isempty(givenStruct)
	S = LoadStackRawMulti(datafolder); %% load stack data
else
	S = givenStruct; %TODO test if this is the correct use for givenstruct
end

% If energy values were saved but no spectra were collected, make empty array as placeholder
sdim=size(S.spectr);
if ndims(S.spectr) == 3 %catching stacks with only one image (usually aborted stacks)
	if sdim(3)>length(S.eVenergy)
		S.spectr=S.spectr(:,:,1:length(S.eVenergy));
	end
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
%% Stack Alignment
S = AlignStack(S);

%% Optical Density Calculation

if length(S.eVenergy) < 3
    threshMethod = 'map';
elseif length(S.eVenergy) >= 20
    threshMethod = 'O';
end

Snew = OdStack(S,...
    'Auto Gamma', autoGammaFlag,...
    'Gamma Level', gammaLevel,...
    'Thresh Method', threshMethod,...
    'Remove Pixel Size', rmPixelSize,...
    'Manual Io Check', manualIoCheck,...
    'Manual Binmap',manualBinmapCheck,...
    'Clear Binmap Border', clearBinmapBorder_bool...
    );

%% Elemental Maps (CarbonMaps)

Snew = ElementPrePostMaps(Snew, 'Element', 'C');
Snew = ElementPrePostMaps(Snew, 'Element', 'Ca');
Snew = ElementPrePostMaps(Snew, 'Element', 'K');
Snew = ElementPrePostMaps(Snew, 'Element', 'S');
Snew = ElementPrePostMaps(Snew, 'Element', 'N');
Snew = ElementPrePostMaps(Snew, 'Element', 'O');

% Snew = energytest(Snew);

%this is only used if a FOV is analyzed but DOESNT have carbon data (rare
%for us).  If carbon data is present, this is overwritten
% Snew = makinbinmap(Snew);

if Snew.elements.C == 1
    
    Snew = CarbonMapsSuppFigs(Snew,...
        'sp2 Threshold', spThresh,...
        'Inorganic Threshold', inorgThresh,...
        'Remove Pixel Size', rmPixelSize,...
        'Carbon SN Limit', carbonLimitSN,...
        'SP2 SN Limit', sp2LimitSN,...
        'Pre-edge SN Limit',preLimitSN,...
        'PrePost SN Limit', prepostLimitSN...
        );
    
    Snew_noLoD = CarbonMapsSuppFigs(Snew,...
        'sp2 Threshold', spThresh,...
        'Inorganic Threshold', inorgThresh,...
        'Remove Pixel Size', rmPixelSize,...
        'Carbon SN Limit', 0,...
        'SP2 SN Limit', 0,...
        'Pre-edge SN Limit',0,...
        'PrePost SN Limit', 0 ...
        );
    %savedbinmap = givenBinMap; % Currently Unused
    
    Snew = DirLabelOrgVolFrac(Snew,inorganic,organic);
    [Mixing, Particles] = MixingState(Snew,datafolder,filenames);
%     [Snew] = MixingState_CComp(Snew); %updated script to insert at some
%     point
    Snew = CropParticles(Snew);
% 	Particles = ParticlesInfo(Snew);
% 	Mixing = 0;
else
% 	[~, Particles] = MixingState(Snew,datafolder,filenames);
	Mixing = 0;
	Particles = ParticlesInfo(Snew);
	disp([datafolder,' HAS NO CARBON DATA']);
end

% if Snew.elements.S == 1
%     Snew = SulfurMaps(Snew);
% end
% 
% if Snew.elements.K == 1
%     Snew = PotassiumMaps(Snew);
% end
% 
% if Snew.elements.Ca == 1
%     Snew = CalciumMaps(Snew);
% end
% 
% if Snew.elements.N == 1
%     Snew = NitrogenMaps(Snew);
% end
% 
% if Snew.elements.O == 1
%     Snew = OxygenMaps(Snew);
% end

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