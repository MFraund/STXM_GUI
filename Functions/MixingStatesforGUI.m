function [ Dataset ] = MixingStatesforGUI( filedirs, threshlevel, binadjtest, givenbinmap,varargin)
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

if isempty(varargin)
	inorganic = 'NaCl';
	organic = 'sucrose';
elseif length(varargin) == 1
	inorganic = varargin{1};
	organic = 'sucrose';
elseif length(varargin) == 2
	inorganic = varargin{1};
	organic = varargin{2};
end

if exist('threshlevel','var') == 0
    threshlevel = 2;
end

if exist('binadjtest','var') == 0
    binadjtest = 0;
end

if exist('givenbinmap','var') == 0
    givenbinmap = 0;
end


ldirs = length(filedirs);
dirnames = cell(ldirs,1);
emptycell = cell(ldirs,1);
for i = 1:ldirs
    [~,dirnames{i},~] = fileparts(filedirs{i});
    dirnames{i} = ['FOV' dirnames{i}];
    idx = strfind(dirnames{i},'-'); %cell2struct doesn't like hyphens
    dirnames{i}(idx) = '_';
end

Dataset = cell2struct(emptycell,dirnames,1);
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
%     tempfilenames = ls; %listing out file names
%     cnt = 1;
% 	hdrcnt = 0;
%     for j = 1:size(tempfilenames,1) %looping through each file name and picking out .hdr and .xim files ONLY
%         %(this allows for lots of other crap in the folder) and then building
%         %the FileNames cell array
%         if any(strfind(strtrim(tempfilenames(j,:)),'.hdr'))==1
%             FileNames{1,cnt} = strtrim(tempfilenames(j,:));    %i'm not sure how to preallocate here without another if loop, might not be faster
%             cnt = cnt + 1;
%             hdrcnt = hdrcnt +1;
%         elseif any(strfind(strtrim(tempfilenames(j,:)),'.xim'))==1
%             FileNames{1,cnt} = strtrim(tempfilenames(j,:));
%             cnt = cnt + 1;
%         end
% 	end

	[S,Snew,Mixing,Particles] = SingStackProcMixingStateOutputNOFIGS(tempfiledir, threshlevel, binadjtest, givenbinmap,inorganic,organic);

	Dataset.(dirnames{i}).S = S;
	Dataset.(dirnames{i}).Snew = Snew;
	Dataset.(dirnames{i}).Mixing = Mixing;
	Dataset.(dirnames{i}).Particles = Particles;
	Dataset.(dirnames{i}).Directory = filedirs{i};
%     MixingOverview(1,i).DataSet = tempfiledir;
%     MixingOverview(1,i).Mixing = Mixing;
%     MixingOverview(1,i).Mixing.Numparticles = length(Mixing.Di);
	if Mixing == 0
		
	else
		tempDa(i) = Dataset.(dirnames{i}).Mixing.Da;
		tempDy(i) = Dataset.(dirnames{i}).Mixing.Dy;
		tempDb(i) = Dataset.(dirnames{i}).Mixing.Db;
		tempCHI(i) = Dataset.(dirnames{i}).Mixing.MixStateChi;
	end
    waitbar(i/ldirs);
%     ParticlesOverview(1,i).Particles = Particles;
end

if Mixing == 0
	
else
	DaStats = SimpleStats(tempDa);
	DyStats = SimpleStats(tempDy);
	DbStats = SimpleStats(tempDb);
	ChiStats = SimpleStats(tempCHI);
	
	MixStateStats = struct('DaStats',DaStats,'DyStats',DyStats,'DbStats',DbStats,'ChiStats',ChiStats);
	
	Dataset.MixStateStats = MixStateStats;
end

totalmfrac = extractingmfracGUI(Dataset);
Dataset.totalmfrac = totalmfrac;
% Dataset.ParticlesOverview = ParticlesOverview;
% Dataset.MixingOverview = MixingOverview;

close(hwait);

% assignin('base','MixingOverview',MixingOverview);
% assignin('base','MixStateStats',MixStateStats);
% assignin('base','ParticlesOverview',ParticlesOverview);

end

