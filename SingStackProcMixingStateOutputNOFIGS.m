function [S, Snew, Mixing, Particles] = SingStackProcMixingStateOutputNOFIGS(datafolder, threshlevel, binadjtest, givenbinmap,varargin)

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

%% Input Checking Before Code


if isempty(varargin)
	inorganic = 'NaCl';
	organic = 'sucrose';
elseif length(varargin) == 1
	inorganic = varargin{1};
	organic = 'sucrose';
elseif length(varargin) == 2
	inorganic = varargin{1};
	organic = varargin{2};
elseif length(varargin) == 3
	inorganic = varargin{1};
	organic = varargin{2};
	givenStruct = varargin{3};
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

%% 
% datafolder=RawDir;
cd(datafolder) %% move to raw data folder
foldstruct=dir;
foldstruct = foldstruct(3:end);
% if ~isempty(varargin)
%     badE=varargin{1};
% else
%     badE=[];
% end

ImpTest=0;
cnt=1;
numobj=length(foldstruct);
%     if strcmp(foldstruct(i).name,Name)
%         righti=i;
%         try cd(fullfile(datafolder,foldstruct(i).name)); %% move to data folder
if length(varargin) == 3
	S = givenStruct;
else
	S = LoadStackRawMulti(pwd); %% load stack data
end

sdim=size(S.spectr);
filenames = cell(1,1);
if sdim(3)>length(S.eVenergy)
	S.spectr=S.spectr(:,:,1:length(S.eVenergy));
end

for i = 1:numobj %% loops through stack folders in raw data folder
	bidx=strfind(foldstruct(i).name,'.hdr');
	ximidx = strfind(foldstruct(i).name,'.xim');
	if ~isempty(bidx)
		S.particle=sprintf('%s',foldstruct(i).name(1:bidx-1));
	end
	if ~isempty(ximidx) || ~isempty(bidx)
		filenames{cnt} = foldstruct(i).name;
		cnt= cnt+1;
	end
end
%             S.particle=sprintf('%s',foldstruct.name); %% print particle name
%             S=DeglitchStack(S,badE);
%             filename=sprintf('%s%s%s',P1Dir,'\S',foldstruct(i).name); %% define directory to save file in
%             cd(P1Dir)
%             save(sprintf('%s%s','S',foldstruct(i).name)) %% save stack data in .mat file
%figure,plot(S.eVenergy,squeeze(mean(mean(S.spectr))))


% S = RemoveHorizStreaks_STXM(S);

S=AlignStack(S);


if length(S.eVenergy)<3
	Snew=OdStack(S,'map',0,'no',threshlevel);
else
	Snew=OdStack(S,'O',0,'no',threshlevel);
end
%             cd(FinDir)
ImpTest=1;
%         catch
%
%             cd(datafolder); %% move back to raw data folder
%             %         cd ..
%             disp('wrong path?')
%             cnt=cnt+1;
%         end
%     else
%         continue
%     end
% end


if ImpTest==0
	error('No import performed: Wrong filename or path?');
end
% cd(P1Dir)
% numobj=length(dir);
% for i = 3:numobj %% loops through stack matfiles
%     if strcmp(foldstruct(i).name,Name)
%         foldstruct=dir;
%         load(sprintf('%s',foldstruct(i).name));
%         Snew=AlignStack(S);
%         Snew=OdStack(Snew,'C');
%         S
%         cd(FinDir)
%         save(sprintf('%s%s','F',foldstruct(i).name))
%         cd(P1Dir);
%     else
%         continue
%     end
% end


Snew = energytest(Snew);

%this is only used if a FOV is analyzed but DOESNT have carbon data (rare
%for us).  If carbon data is present, this is overwritten
Snew = makinbinmap(Snew);

%load(sprintf('%s%s','F',S.particle));

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

%%%this is to signify the new version of
%%%SingSTackProcMixingStateOutputNOFIGS has been run, which includes the
%%%above maps data (even if none exists);
mapstest = 1;

save(sprintf('%s%s','../','F',S.particle),'-v7.3');



%STACKLab(Snew)

%This section is only to make and save a bunch of raw spectra to make it
%easier to see witout running scripts every time
mask3d = repmat(Snew.binmap,[1,1,size(Snew.spectr,3)]);
maskedspec = Snew.spectr.*mask3d;

for q = 1:size(Snew.spectr,3)
    tempspec = maskedspec(:,:,q);
    maskedspecmean(q) = mean(nonzeros(tempspec));
end

	






savefigtest = 'no';

if strcmp(savefigtest,'yes')
    specf = figure; 
    plot(Snew.eVenergy,maskedspecmean);
    specname = sprintf('%s%s','RawSpectrum',S.particle);
    currfilename = specname;
    set(gca,'Color','none');
    savefig(gcf,currfilename);
    export_fig(currfilename,'-png','-transparent');
    %     img = getframe(gcf);
    %     imwrite(img.cdata, [currfilename,'.png']);
    saveas(gcf,currfilename,'epsc');
    close(specf);
end




cd('..');
end