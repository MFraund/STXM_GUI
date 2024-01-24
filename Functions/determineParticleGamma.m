function [grayimOut, bestGamma] = determineParticleGamma(grayimIn,varargin)
%% [grayimOut, bestGamma] = particleGamma(GrayimIn)
%
% This function determines the best gamma value to use when finding an intensity threshold
% by varying gamma and monitoring "particle" number.  At super low gamma, there will be
% only 1 particle (whole image) then slowly there will be too many particles (noise counted
% as particles, until a proper gamma is reached where the actual particles are revealed.

%% Input Checking

%ensuring image in is grayscale
im = mat2gray(grayimIn);

%% Variable Extracting
[varargin, verboseFlag] = ExtractVararginValue(varargin,'verbose',0);
[varargin, gammaLevel] = ExtractVararginValue(varargin,'Gamma Level',[]);
[varargin, autoGamma_bool] = ExtractVararginValue(varargin, 'Auto Gamma', true);
[varargin, rmPixelSize] = ExtractVararginValue(varargin, 'Remove Pixel Size', 7);

%% Remove gamma in if autogamma is selected
if strcmp(autoGamma_bool, 'yes') | autoGamma_bool == 1
	gammaLevel = [];
end

%% Short circuit if gamma value is supplied
if any(gammaLevel) 
	bestGamma = gammaLevel;
	grayimOut = imadjust(im, [0,1], [0,1], bestGamma);
	return
end

%% Determining best gamma value
gammaVec = [1:200]*0.05;
for g = 1:200
	adjusted_im = imadjust(im, [0, 1], [0, 1], 0 + gammaVec(g));
	binim = imbinarize(adjusted_im, 'adaptive');
	scrubim = bwareaopen(binim, rmPixelSize);
	numparts(g) = max(max(bwlabel(scrubim)));
end

[~, minIdx] = min(diff(numparts));

bestGamma = gammaVec(minIdx+1);
grayimOut = imadjust(im, [0,1], [0,1], bestGamma);

if verboseFlag == 1
	disp(['best gamma = ', num2str(bestGamma)]);
	figure;
	plot(gammaVec(2:end), diff(numparts), 'LineStyle','none','Marker','.','MarkerSize',20);
end