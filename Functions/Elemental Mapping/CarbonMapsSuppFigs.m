function Snew = CarbonMapsSuppFigs(Snew, varargin)
%% Determines component maps over the carbon K-edge 
%
% Snew = CarbonMapsSuppFigs(Snew, varargin)
%
% Input
%   Snew is the stack structure produced using functions OdStack.m and
%   AlignStack.m or any bastardization of those
%  Name-Value Pairs
% sp2 Threshold (0.35)
% Manual Binmap (no)
% Output__________________________________________________________________
% Snew.TotC is the post edge minus the pre edge image
% Snew.sp2 is the sp2 map
% Snew.SootEccentricity, MajorAxisLength, MinorAxisLength are vectors with the parameters of best fit elipse around soot inclusion
% Snew.ConvexArea is a vector of areas convex hull around soot inclusion
% Snew.SootArea is a vector of areas for each soot inclusion
% Snew.LabelMat is a matrix with particle numbers at each pixel of corresponding particle. Particle numbering goes from left to right (see MATLAB documentation on bwlabel.m) 
% Snew.PartLabel is a cell array of strings containing particle classification labels for each particle: OC, OCIN, OCBC, OCBCIN...
% Snew.PartSN is a matrix of particle serial numbers having the format YY-MM-DD-StackNumber-ParticleNumber
% Snew.BinMap matrix containing zeros where there are no particles and ones where particles have been identified
% Snew.Size is a vector of area equivalent diameters for each particle
% Snew.CompSize is a matrix of sizes for different componets OC BC etc (columns) for all particles (rows)
% Snew.PartDirs is a cell array of directories where data file is found (these should all be the same).
% Snew.RGBCompMap RGB matrices for different components (BC=red=RGBCompMap(:,:,1) ,OC=green=RGBCompMap(:,:,2),Inorganic Dominant=blue=RGBCompMap(:,:,3))
% Snew.Maps(:,:,1) is a carbon map
% Snew.Maps(:,:,2) is a pre/post ratio map
% Snew.Maps(:,:,3) is a sp2 carbon map
% Snew.BinCompMap is a cell array of binary component maps ={carb,prepost,sp2}
% Snew.CompSize=[OCArea,InArea,ECArea,TotalParticleArea]
% RCM, UOP, 2013; update RCM 7/6/2016

energy=Snew.eVenergy;
stack=Snew.spectr;
subdim=ceil(sqrt(length(energy)));

% if nargin < 2
%     manualbinmapcheck = 'no';
%     varargin = {};
% elseif nargin < 3
%     manualbinmapcheck = 'no';
% end

test=energy(energy<319 & energy>277);
if length(Snew.eVenergy)<2
    beep
    disp('too few images for this mapping routine');
    return
elseif isempty(test)
    beep
    disp('this is not the carbon edge')
    return
end

%% Input Checking
[varargin, spThresh] = ExtractVararginValue(varargin, 'sp2 Threshold', 0.35);
[varargin, inorgThresh] = ExtractVararginValue(varargin, 'Inorganic Threshold', 0.5);
[varargin, rmPixelSize] = ExtractVararginValue(varargin, 'Remove Pixel Size', 7);

[varargin, carbonLimitSN] = ExtractVararginValue(varargin, 'Carbon SN Limit', 3);
[varargin, sp2LimitSN] = ExtractVararginValue(varargin, 'SP2 SN Limit', 3);
[varargin, preLimitSN] = ExtractVararginValue(varargin, 'Pre-edge SN Limit', 3);
[varargin, prepostLimitSN] = ExtractVararginValue(varargin, 'PrePost SN Limit', 3);

[varargin, manualBinmapCheck] = ExtractVararginValue(varargin, 'Manual Binmap', 'no');
[varargin, givenBinmap] = ExtractVararginValue(varargin, 'Binmap', []);

% [varargin, rootdir] = ExtractVararginValue(varargin, 'Root Directory', 0.35);
% [varargin, sample] = ExtractVararginValue(varargin, 'Sample', 0.35);
% [varargin, figsav] = ExtractVararginValue(varargin, 'Save Figures', 0);
% [varargin, nofig] = ExtractVararginValue(varargin, 'Plot Figures', 0)

SNlimit = 0;

if spThresh>1
    %disp('sp2 threshold input as percent, dividing by 100 for diffmaps');
    spThresh=spThresh/100;
end


%% Finding relevant energy indicies
[~,preidx] = ClosestValue(energy, 278, [277, 283], 'Error Message', 'missing pre-edge energy');
[~,sp2idx] = ClosestValue(energy, 285.4, [284.5, 285.6], 'Error Message', 'missing sp2 energy');
[~,carboxidx] = ClosestValue(energy, 288.6, [288, 289], 'Error Message', 'missing carbox energy');
[~,postidx] = ClosestValue(energy, 320, [310, 330], 'Error Message', 'missing post-edge energy');

pre = stack(:,:,preidx);
sp2im = stack(:,:,sp2idx);
carboxim = stack(:,:,carboxidx);
post = stack(:,:,postidx);

% This background subtraction is a good first step but isn't mature enough as is, plus it takes a long time
% pre = FindingTotGradAngle(pre);
% sp2im = FindingTotGradAngle(sp2im);
% carboxim = FindingTotGradAngle(carboxim);
% post = FindingTotGradAngle(post);

pre(pre<0) = 0;
sp2im(sp2im<0) = 0;
carboxim(carboxim<0) = 0;
post(post<0) = 0;

binmap = Snew.binmap;
LabelMat = Snew.LabelMat;

%%% Assign Particle Serial Numbers and directories
% NumPart=max(max(LabelMat));
% PartZero=str2double(strcat(Snew.particle(5:end),'0000'));
% PartSN=[1:NumPart]+PartZero;
% dirstr=pwd;
% PartDir=strcat(dirstr);
% PartDirs=cell(NumPart,2);
% PartDirs(:,1)={PartDir};
% SearchString=strcat('*F',Snew.particle,'*.mat');
% FName=dir(SearchString);
% PartDirs(:,2)={FName(1).name};

%% Carbon Map %%%%%%%%%%%%%%%%%%%%%%%%%  Carbon Map %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
carb=post-pre;
errcarb = sqrt(Snew.errOD(:,:,postidx).^2 + Snew.errOD(:,:,preidx).^2);

carb1=carb;                  % taking STD of regions not having particles
noise = carb1(Snew.mask==1);
thresh = std(noise).*carbonLimitSN; %trying this with LOQ (10xS/N) instead of LOD (3xS/N)
carb1(carb1<thresh) = 0;
% carb1(carb1<0)=0; % removes regions having negative total carbon

carb1=carb1.*binmap;
carb1 = imgaussfilt(carb1);
Snew.TotC=carb1;

% Per-particle TCA
Snew = CalcTCA(Snew); % adds Snew.TCA

carbmask=carb1;
carbmask(carbmask>0)=1;
carbmask = bwareaopen(carbmask,3, 8);
carbmask=medfilt2(carbmask);

%% Inorganic Map %%%%%%%%%%%%%%%%%%%%%%%%   Inorganic Map %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% pre=stack(:,:,preidx);
% Noise=std(pre(Snew.mask==1));
% pre(pre<0) = 0; %no negative optical densitites
% pre(pre<3.*Noise) = 0;

% post = stack(:,:,postidx);
% Noise_post = std(post(Snew.mask==1));
% post(post<0) = 0; %no negative optical densities
% post(post<3.*Noise_post) = 0;

prepost = pre./post;
errprepost = sqrt((Snew.errOD(:,:,preidx)./post).^2 + ((pre.* Snew.errOD(:,:,postidx)./post.^2)).^2); %calculus based (derivative) error propagation formula applied here
prepost(isinf(prepost)) = 0;
prepost(isnan(prepost)) = 0;

noise_pre = std(pre(Snew.mask==1));
premask = pre;
premask(pre < preLimitSN.*noise_pre) = 0;
premask = medfilt2(premask,[3,3]);
premask(premask>0) = 1;


prepost = medfilt2(prepost,[3,3]);
% prepost = removeoutlier_IQRtest(prepost,1.5);

% Determining Noise Level
noise_prepost = std(prepost(Snew.mask == 1));

prepost = prepost .* binmap;

prepost(prepost < prepostLimitSN.*noise_prepost) = 0;

%%%Thresholding inorganics vs organics according to Moffet 2010.  0.5 is
%%%the value for KCl and works in general.  NaCl threshold would be ~1
%%%instead and NH4SO4 is 0.85
% inorgthresh = inorgThresh; %0.5
Snew.inorgThresh = inorgThresh;
prepost(prepost<inorgThresh)=0;

prepostmask=prepost;
prepostmask = medfilt2(prepost,[3,3]);
prepostmask(prepostmask>0)=1;
prepostmask = bwareaopen(prepostmask,11, 8); %removing small particles
prepostmask = prepostmask .* premask;
%% SP2 Map %%%%%%%%%%%%%%%%%%%%%%%% SP2 Map %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% HOPG(285.25)=0.8656; HOPG(310)=0.4512;
if ~isempty(sp2idx)
    %sp2img = stack(:,:,sp2idx);
    doublecarb=sp2im-pre; % make sp2 map by subtracting preedge
    errdoublecarb = sqrt(Snew.errOD(:,:,sp2idx).^2 + Snew.errOD(:,:,preidx).^2);   
    doubCarbNois=std(doublecarb(Snew.mask==1)); % calculate the noise of the sp2 peak by
    
    doublecarb1=doublecarb;
    doublecarb1(doublecarb1<3*doubCarbNois)=0; % removes regions with sp2 less than 3x S/N
    spmask=doublecarb1.*binmap;
    spmask(spmask>0)=1;                  % make binary sp2 mask
    
    doublecarb2=(doublecarb1./carb1) .* (0.4512/0.8656) .*spmask;
    sp2NoThresh=doublecarb2;
    sp2NoThresh(sp2NoThresh<0)=NaN;
    sp2NoThresh(sp2NoThresh>1)=1;
    Snew.sp2=sp2NoThresh;
   
	rawsp2 =(doublecarb1./carb1)  .*  (0.4512/0.8656);
	rawsp2(isinf(rawsp2)) = 0;
    rawsp2(isnan(rawsp2)) = 0;
    sp2=(doublecarb1./carb1)  .*  (0.4512/0.8656).*spmask; % calculate %sp2 of masked images
    errsp2 = (0.4512./0.8656).*sqrt((errdoublecarb./carb1).^2 + ((doublecarb.*errcarb./carb1.^2).^2));
    sp2(isinf(sp2)) = 0;
    sp2(isnan(sp2)) = 0;
       
	sp2(sp2 < 0) = 0;
	
    sp2 = removeoutlier_IQRtest(sp2); %removing very large numbers
    sp2frac = sp2;
    
    sp2noise = std(rawsp2(Snew.mask==1));
    sp2 = sp2 .* binmap;
%     sp2(sp2 < sp2LimitSN.*sp2noise) = 0; %should be < SNLimit
    sp2(sp2<spThresh)=0;                                                     % threshold everythin less than 40% sp2
    
    finSp2mask=sp2;
    finSp2mask = medfilt2(finSp2mask);
    finSp2mask(finSp2mask>0)=1;
    finSp2mask = bwareaopen(finSp2mask,8, 8);
    
    %ImStruct=regionprops(bw,'Eccentricity','MajorAxisLength','MinorAxisLength','ConvexHull');
    ImStruct=regionprops(finSp2mask,'Eccentricity','MajorAxisLength','MinorAxisLength','ConvexArea','Area');
    Ecc = reshape([ImStruct.Eccentricity],size(ImStruct));
    Maj=reshape([ImStruct.MajorAxisLength],size(ImStruct));
    Min=reshape([ImStruct.MinorAxisLength],size(ImStruct));
    %ImStruct.ConvexArea
    %ImStruct.Area
    Cvex=reshape([ImStruct.ConvexArea],size(ImStruct));
    Area=reshape([ImStruct.Area],size(ImStruct));
    Snew.SootEccentricity=Ecc;
    Snew.SootMajorAxisLength=Maj;
    Snew.SootMinorAxisLength=Min;
    Snew.SootConvexArea=Cvex;
    Snew.SootArea=Area;
else
    sp2=zeros(size(binmap));
    finSp2mask=zeros(size(binmap));
    doublecarb=zeros(size(binmap));
end

%% Combine maps, 
BinCompMap{1}=carbmask;
BinCompMap{2}=prepostmask;
BinCompMap{3}=finSp2mask;
%%% This first loop creates masks for the individual components over the
%%% entire field of view. Each component is then defined as a colored
%%% component for visualization.
ColorVec=[...
	0,170,0;...
	0,255,255;...
	255,0,0;...
	255,170,0;...
	255,255,255]; %%% rgb colors of the different components

MatSiz=size(LabelMat);
RgbMat=zeros([MatSiz,3]);
RedMat=zeros(MatSiz);
GreMat=zeros(MatSiz);
BluMat=zeros(MatSiz);

[l,m]=find(LabelMat>0);
labidx=sub2ind(MatSiz,l,m);
cnt=1;
for i=1:length(BinCompMap)%i=[1,2,3] %% loop over chemical components
    [j,k]=find(BinCompMap{cnt}>0); %% find index of >0 components
    if ~isempty(j) || ~isempty(k)  %% this conditional defines a color for the component areas (if it exists)
        linidx=sub2ind(size(BinCompMap{cnt}),j,k); %% change to linear index
        rejidx=setdiff(linidx,labidx); %% find componets that overlap with particles
        BinCompMap{cnt}(rejidx)=0; %% set regions that dont overlap to zero
        linidx=sub2ind(size(BinCompMap{cnt}),find(BinCompMap{cnt}>0)); %% get linear index of regions having nonzero values
        RedMat(linidx)=ColorVec(cnt,1); %% define the color for the ith component
        GreMat(linidx)=ColorVec(cnt,2);
        BluMat(linidx)=ColorVec(cnt,3);
        trmat=zeros(size(RedMat));
        tgmat=zeros(size(RedMat));
        tbmat=zeros(size(RedMat));
        trmat(linidx)=ColorVec(cnt,1);
        tgmat(linidx)=ColorVec(cnt,2);
        tbmat(linidx)=ColorVec(cnt,3);
        ccmap{cnt}(:,:,1)=trmat;
        ccmap{cnt}(:,:,2)=tgmat;
        ccmap{cnt}(:,:,3)=tbmat;
        clear trmat tgmat tbmat
    else
        ccmap{cnt}=zeros(MatSiz(1),MatSiz(2),3);
    end
    cnt=cnt+1;  %% this counter keeps track of the indivdual components.
    clear j k linidx GrayImage Thresh Mask rejidx;
end
clear l m
%%% This second loop assigns labels over individual particles defined
%%% previously in Diffmaps.m
NumPart=max(max(LabelMat));
% LabelStr={'OC','In','K','EC'};
LabelStr={'OC','In','EC'};

CompSize=zeros(NumPart,length(LabelStr)+1);
PartLabel={};
for i=1:NumPart  %% Loop over particles defined in Diffmaps.m
    PartLabel{i}='';
    linidx1 = 0;
    for j=1:length(LabelStr)  %% Loop over chemical components
        [a1,b1]=find(LabelMat==i);  %% get particle i
        [a2,b2]=find(BinCompMap{j}>0); %% get component j
        if ~isempty([a1,b1]) && ~isempty([a2,b2])
            linidx1=sub2ind(size(LabelMat),a1,b1); %% Linear index for particle
            linidx2=sub2ind(size(BinCompMap{j}),a2,b2); %% Linear index for component
            IdxCom=intersect(linidx1,linidx2); %% find common indices
            if length(IdxCom)>3%0.05*length(linidx1) %% if component makes up greater than 2% of the pixels of the particle...
                    PartLabel{i}=strcat(PartLabel{i},LabelStr{j}); %% give label of component.
                    CompSize(i,j)=length(IdxCom); %% number of pixels in the component.
            end
        end
    end
    if isempty(PartLabel{i})
        PartLabel{i}='NoID'; %% Particles identified by Otsu's mehod here but not in Particle map script
    end
    CompSize(i,j+1)=length(linidx1);  %% number of pixels in the particle
    clear linidx1 linidx2 IdxCom a1 b1 a2 b2;
end
if isempty(PartLabel)
    PartLabel='NoID';
else
    PartLabel=PartLabel;
end

%%Define outputs
Snew.PartLabel=PartLabel;
% Snew.PartSN = PartSN';
XSiz=Snew.Xvalue/MatSiz(1);
YSiz=Snew.Yvalue/MatSiz(2);
CompSize=CompSize.*(XSiz*YSiz); %% Area of components in um^2
Snew.CompSize=CompSize;

RgbMat(:,:,1)=RedMat;
RgbMat(:,:,2)=GreMat;
RgbMat(:,:,3)=BluMat;
Snew.RGBCompMap=RgbMat;
for i=1:length(BinCompMap)
    temp{i}=BinCompMap{i};
    temp{i}(temp{i}>1)=1;
end
xdat=[0:XSiz:Snew.Xvalue];
ydat=[0:YSiz:Snew.Yvalue];

xysiz=size(carb1);
Snew.Maps=zeros(xysiz(1),xysiz(2),3);
Snew.Maps(:,:,1)=carb1;
Snew.Maps(:,:,2)=prepost;
Snew.Maps(:,:,3)=sp2;
Snew.sp2frac = sp2frac;

Snew.errcarb = errcarb;
Snew.errprepost = errprepost;
Snew.errsp2 = errsp2;

Snew.BinCompMap=temp;

