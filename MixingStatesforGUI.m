function [ Dataset_out ] = MixingStatesforGUI( filedirs, varargin)
%MIXINGSTATESFORGUI [ MixingOverview,MixStateStats,ParticlesOverview ] = MixingStatesforGUI( filedirs )
%Determination of simple statistics about mixing state and mass fractions
%Code by Matthew Fraund 5/19/15 @ University of the Pacific

%Input
%======================
%filedirs is a struct of directories to be analyzed
%Snewflag decides if extra information about S,Snew etc is provided

%Output
%======================
%Dataset.MixStateStats						= Statistics about mixing state
%Dataset.totalmfrac							= mass fraction info
%Dataset.(filenameoffolder).S				= Info about each dir chosen
%   "            "         .Snew
%   "            "         .Mixing
%   "            "         .Particles
%   "            "         .filedirs(i)


%MixingOverview, MixStateStats, ParticlesOverview are all structs

%non-matlab function dependencies
%--------------------------------
%uipickfiles (internet)
%LoadImageRawMixingStateOutputNOFIGS (file by RCM modified by MWF)
%SingStackProcMixingStateOutputNOFIGS
%extractingmfrac (file by MWF)

%% Input Checking
[varargin,inorganic] = ExtractVararginValue(varargin,'inorganic','NaCl');
[varargin,organic] = ExtractVararginValue(varargin,'organic','sucrose');
[varargin,givenStruct] = ExtractVararginValue(varargin,'givenStruct',[]);
[varargin,threshMethod] = ExtractVararginValue(varargin,'Thresh Method','adaptive');
[varargin,gammaLevel] = ExtractVararginValue(varargin,'Gamma Level',2);
[varargin,binAdjTest] = ExtractVararginValue(varargin,'Bin Adjust Flag',0);
[varargin,givenBinMap] = ExtractVararginValue(varargin,'Bin Map',0);


%% Looping over Directories to pull out folder names
ldirs = length(filedirs);
dirnames = cell(ldirs,1);
emptycell = cell(ldirs,1);
for i = 1:ldirs
    [~,dirnames{i},~] = fileparts(filedirs{i});
    dirnames{i} = ['FOV' dirnames{i}];
    idx = strfind(dirnames{i},'-'); %cell2struct doesn't like hyphens
    dirnames{i}(idx) = '_';
end

%% Preallocating
Dataset_out = cell2struct(emptycell,dirnames,1);
ParticlesOverview = zeros(1,ldirs);
MixingOverview = zeros(1,ldirs);

%%%%%%%%%%%cell2struct!!!!!!!!!!!!!!

% MixingOverview = struct('DataSet',cell(ldirs,1));
% ParticlesOverview = struct('DataSet',cell(ldirs,1));
% SnewOverview = struct('DataSet',cell(ldirs,1));
tempDa = zeros(1,length(filedirs));
tempDy = zeros(1,length(filedirs));
tempDb = zeros(1,length(filedirs));
tempCHI = zeros(1,length(filedirs));


%% Looping over each folder/file to run
if any(exist('sillystring','file'))
	hwait = waitbar(0,sillystring);
else
	hwait = waitbar(0,'plz w8');
end

for i = 1:ldirs %looping through each selected directory
	if ispc()
		tempfiledir = strcat(filedirs{i},'\');
	elseif ismac()
		tempfiledir = strcat(filedirs{i},'/'); 
	end
    cd(filedirs{i}); %moving to each directory
	
	[S,Snew,Mixing,Particles] = SingStackProcMixingStateOutputNOFIGS(tempfiledir,...
		'Gamma Level', gammaLevel,...
		'Bin Adjust Flag', binAdjTest,...
		'Bin Map', givenBinMap,...
		'inorganic',inorganic,...
		'organic',organic,...
		'Thresh Method',threshMethod...
		);

	Dataset_out.(dirnames{i}).S = S;
	Dataset_out.(dirnames{i}).Snew = Snew;
	Dataset_out.(dirnames{i}).Mixing = Mixing;
	Dataset_out.(dirnames{i}).Particles = Particles;
	Dataset_out.(dirnames{i}).Directory = filedirs{i};
%     MixingOverview(1,i).DataSet = tempfiledir;
%     MixingOverview(1,i).Mixing = Mixing;
%     MixingOverview(1,i).Mixing.Numparticles = length(Mixing.Di);
	if Mixing == 0
		
	else
		tempDa(i) = Dataset_out.(dirnames{i}).Mixing.Da;
		tempDy(i) = Dataset_out.(dirnames{i}).Mixing.Dy;
		tempDb(i) = Dataset_out.(dirnames{i}).Mixing.Db;
		tempCHI(i) = Dataset_out.(dirnames{i}).Mixing.MixStateChi;
	end
    waitbar(i/ldirs);
%     ParticlesOverview(1,i).Particles = Particles;
end

%% Compiling mixing state statistics
if Mixing == 0
	
else
	DaStats = SimpleStats(tempDa);
	DyStats = SimpleStats(tempDy);
	DbStats = SimpleStats(tempDb);
	ChiStats = SimpleStats(tempCHI);
	
	MixStateStats = struct('DaStats',DaStats,'DyStats',DyStats,'DbStats',DbStats,'ChiStats',ChiStats);
	
	Dataset_out.MixStateStats = MixStateStats;
end

% totalmfrac = extractingmfracGUI(Dataset_out);
% Dataset_out.totalmfrac = totalmfrac;
% Dataset.ParticlesOverview = ParticlesOverview;
% Dataset.MixingOverview = MixingOverview;

close(hwait);


end

