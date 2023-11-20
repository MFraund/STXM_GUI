function S=OdStack(structin, varargin)
%function S=OdStack(structin, method, plotflag,     manualiocheck,         imgadjust_gamma)
%                   struct    'O'      0 or 1     'no' or 'yes'   default = 2
%Automated STXM raw data to optical density (OD) conversion.
%Particle regions are detected by a constant threshold condition or by using Otsu's thresholding algorithm.
%Particle-free image zones are used to calculate the normalization intensity Izero
%by averaging the intensity data over the particle-free zones.
%R.C. Moffet, T.R. Henn February 2009
%
%Manual Io selection option added by Matthew Fraund (2016)
%
%Inputs
%------
%structin       aligned raw data stack structure array (typically the output of the
%               FTAlignStack.m script).
%method         string defining the thresholding method:    -'O' thresholding using Otsu's method
%                                                           -'C' thresholding using a constant value
%                                                                (98.5% of maximal intensity)
%															
%plotflag		1 or 0 which controls the plotting of figures
%manualiocheck	string deciding whether to manually select Io region(yes/no)
%
%Outputs
%-------
%S              structure array containing the OD converted STXM data

%Making third input (plotflag) optional, defaulting to no figure

%% Extracting varargin variables and input checking
% if nargin == 1
% 	method = 'O';
% end

[varargin, autoGamma_bool] = ExtractVararginValue(varargin, 'Auto Gamma', true);
[varargin, gammaLevel] = ExtractVararginValue(varargin, 'Gamma Level', 2);
[varargin, threshMethod] = ExtractVararginValue(varargin, 'Thresh Method', 'Adaptive');

[varargin, rmPixelSize] = ExtractVararginValue(varargin, 'Remove Pixel Size', 7);

[varargin, manualIoCheck] = ExtractVararginValue(varargin, 'Manual Io Check', 'no');
[varargin, plotflag] = ExtractVararginValue(varargin, 'plotflag', 0);

[varargin, manualBinmapCheck] = ExtractVararginValue(varargin, 'Manual Binmap', 'no');
[varargin, givenBinmap] = ExtractVararginValue(varargin, 'Binmap', []);
[varargin, clearBinmapBorder_bool] = ExtractVararginValue(varargin, 'Clear Binmap Border', true);

% create temporary variables
stack=structin.spectr;
eVlength=length(structin.eVenergy);

% construct the output struct
S=structin;
clear S.spectr;
S.spectr=zeros(size(structin.spectr,1),size(structin.spectr,2),size(structin.spectr,3));

% calculate imagesc limits
xAxislabel=[0,S.Xvalue];
yAxislabel=[0,S.Yvalue];


%% Background Subtraction

imagebuffer=mean(stack,3);  %% Use average of all images in stack
grayim=mat2gray(imagebuffer); %% Turn into a greyscale with vals [0 1]
grayim = abs(1-grayim); % Make sure particles are "bright" regions, close to 1

% Structuring element then tophat filter using SE
se = strel('disk', 30);
topim = imtophat(grayim, se);

% Gamma adjust
[grayim, gammaLevel] = determineParticleGamma(topim, 'Auto Gamma', autoGamma_bool, 'Gamma Level', gammaLevel, 'Remove Pixel Size', rmPixelSize);

% Median filtering to get rid of noise
grayim = medfilt2(grayim);

%% Thresholding method
if strcmpi(threshMethod,'C')==1 % Constant thresholding (rarely used)
    tempMask=zeros(size(grayim));
    tempMask(grayim>=0.85)=1; % Detect particle free image regions
    
elseif strcmpi(threshMethod,'O')==1 % Basic Otsu's method
    Thresh=graythresh(grayim); %% Otsu thresholding
    tempMask=im2bw(grayim,Thresh); %% Give binary image
    
elseif strcmpi(threshMethod,'map')==1 % Thresholding for maps
    Thresh=graythresh(grayim); %% Otsu thresholding
    tempMask=im2bw(grayim,Thresh); %% Give binary image
    
elseif strcmpi(threshMethod,'adaptive') == 1 % Adaptive thresholding
    T_ad = adaptthresh(grayim,0.01,'Statistic','mean','ForegroundPolarity','bright');
	tempMask = imbinarize(grayim,T_ad);
	%mask = bwareaopen(mask, rmPixelSize, 8);
	
else % Thresholding method not defined
    disp('Error! No thresholding method defined! Input structure not converted!')
    return
end

se2 = strel('disk', 5);
maskIzero = imdilate(tempMask,se2);
%TODO - use bwareaopen on all outputs to thresholding
% binmap = bwareaopen(tempMask, rmPixelSize, 8);
S.mask = ~maskIzero;
S.gamma = gammaLevel;

%% Determing Binmap
if strcmpi(manualBinmapCheck,'yes') | manualBinmapCheck == 1
    rawbinmap = tempMask;
    rawbinmap = bwareaopen(rawbinmap, rmPixelSize, 8);
    templabelmat = bwlabel(rawbinmap,8);
    
    meanfig = figure;
    imagesc(imagebuffer);
    movegui(meanfig,'west');
    
    binfig = figure;
    imagesc(rawbinmap);
    colormap('gray');
    movegui(binfig,'east');
    
    title('Pick Particles to Remove, Right Click on Last Point');
    [xlist, ylist] = getpts(binfig);
    
    close(binfig);
    close(meanfig);
    
    for i = 1:length(xlist)
        currpartlabel = templabelmat(round(ylist(i)),round(xlist(i)));
        templabelmat(templabelmat == currpartlabel) = 0;
    end
    
    binmap = templabelmat;
    binmap(templabelmat > 0) = 1;
    
    %binmap = bwareaopen(binmap, rmPixelSize, 8);
    
elseif strcmpi(manualBinmapCheck,'given')
    binmap = givenBinmap;
    if isempty(binmap) | binmap == 0
        Stemp = makinbinmap(Snew);
        binmap = Stemp.binmap;
    end
else
    binmap = tempMask;
    binmap = bwareaopen(binmap, rmPixelSize, 8);
end

if clearBinmapBorder_bool
    binmap = imclearborder(binmap,8);
end

%Define Label Matrix
LabelMat=bwlabel(binmap,8);


S.LabelMat = LabelMat;
S.NumParticles = max(max(LabelMat));
S.binmap = binmap;
S = ParticleSize(S);


%% Izero extraction

%%%%% this section replaced with an optional input
%If you get annoyed with this prompt, uncomment the manualiocheck line and comment
%the line with "inputdlg" line. 
% manualiocheck = 'no';
% manualiocheck = inputdlg('Do you want to manually define an Io region? (Cancel continues with automatic method)','Manual Io Check',1,{'yes'});

if strcmpi(manualIoCheck,'yes') == 1
    avgstackfig = figure('Name','Define an Io region','NumberTitle','off');
    imagesc(imagebuffer);
    colormap gray;
    
    manualrect = getrect(avgstackfig);
    close(avgstackfig);
    
    cliprowstart = round(manualrect(2));
    cliprowend = round(cliprowstart + manualrect(4));
    clipcolstart = round(manualrect(1));
    clipcolend = round(clipcolstart + manualrect(3));
    manualIomatrix = imagebuffer((cliprowstart):(cliprowend),(clipcolstart):(clipcolend));
    
    Izero = zeros(eVlength,2);
    stdIzero = zeros(eVlength,2);
    errIzero = zeros(eVlength,2);
    
    Izero(:,1)=S.eVenergy;
    stdIzero(:,1) = S.eVenergy;
    errIzero(:,1) = S.eVenergy;
    
    for cnt=1:eVlength
        buffer=stack((cliprowstart):(cliprowend),(clipcolstart):(clipcolend),cnt); %This selects the region selected previously for energy "cnt"
        Izero(cnt,2)=mean(mean(buffer));
        stdIzero(cnt,2) = std(std(buffer));
        numIzero = numel(buffer);
        errIzero(cnt,2) = 1.96 .* stdIzero(cnt,2) ./ sqrt(numIzero); %1.96 comes from t-distribution with an alpha level of 0.05
        clear buffer
    end

elseif strcmpi(manualIoCheck,'given') == 1  %%%this part was considered but is extra work and was put on the back burner
    
else
    Izero=zeros(eVlength,2);
    stdIzero = zeros(eVlength,2);
    errIzero = zeros(eVlength,2);
    
    Izero(:,1)=S.eVenergy;
    stdIzero(:,1) = S.eVenergy;
    errIzero(:,1) = S.eVenergy;
    
    % loop over energy range of stack, calculate average vor each energy -> return_spec
    for cnt=1:eVlength
        buffer=stack(:,:,cnt);
        Izero(cnt,2)=mean(buffer(maskIzero==1));
        stdIzero(cnt,2) = std(buffer(maskIzero==1));
        numIzero = sum(sum(maskIzero));
        errIzero(cnt,2) = 1.96 .* stdIzero(cnt,2) ./ sqrt(numIzero); %1.96 comes from t-distribution with an alpha level of 0.05
        clear buffer
    end
end

S.Izero=Izero;
S.stdIzero = stdIzero;
S.errIzero = errIzero;

%% OD Calculation - Conversion from Intensity to Optical Density
S.errOD = zeros(size(S.spectr));

for k=1:eVlength
    S.spectr(:,:,k)= -log(stack(:,:,k)/Izero(k,2)); 
    S.errOD(:,:,k) = (errIzero(k,2)) .* sqrt((1./stack(:,:,k).^2) + (1./Izero(k,2).^2));
end

%% Plot results
if plotflag==1
    figure
    subplot(2,2,1)
    imagesc(xAxislabel,yAxislabel,imagebuffer)
    axis image
    colorbar
    title('Raw Intensity Stack Mean')
    colormap gray
    xlabel('X-Position (µm)','FontSize',11,'FontWeight','normal')
    ylabel('Y-Position (µm)','FontSize',11,'FontWeight','normal')
    
    subplot(2,2,2)
    imagesc(xAxislabel,yAxislabel,mean(S.spectr,3));
    axis image
    colorbar
    colormap gray
    title('Optical Density Stack Mean')
    xlabel('X-Position (µm)','FontSize',11,'FontWeight','normal')
    ylabel('Y-Position (µm)','FontSize',11,'FontWeight','normal')
    
    
    subplot(2,2,3)
    imagesc(xAxislabel,yAxislabel,maskIzero)
    colorbar
    axis image
    title('Izero Region Mask')
    xlabel('X-Position (µm)','FontSize',11,'FontWeight','normal')
    ylabel('Y-Position (µm)','FontSize',11,'FontWeight','normal')
    
    subplot(2,2,4)
    plot(Izero(:,1),Izero(:,2))
    title('Izero')
    xlabel('Photon energy (eV)','FontSize',11,'FontWeight','normal')
    ylabel('Raw Counts','FontSize',11,'FontWeight','normal')
    
    if length(S.eVenergy)>1
        xlim([min(S.eVenergy),max(S.eVenergy)])
        ylim([0.9*min(S.Izero(:,2)),(max(S.Izero(:,2))+0.1*min(Izero(:,2)))])
    end
end
return