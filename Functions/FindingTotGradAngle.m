function [ IntGradSubtractedImage ] = FindingTotGradAngle(ReferenceImage)
% This function takes an input image (reference image) and calculates a
% linear intesnity background image.
%
% Inputs: ReferencBackgroundImage
% This is any intensity image.  Meant for the raw mean intensity image from
% a STXM image stack
%
% Outputs: IntGradSubtractedImage
% This image is the input reference image with the calculated linear
% intensity background subtracted from it.



%% determining maximum overall gradient angle
testangle = [0:1:360];
for q = 1:length(testangle)
    temprotatebackground = imrotate(ReferenceImage,testangle(q)); %rotate background image (with particles assigned as NaNs) by an angle
    temprotatebackground(temprotatebackground==0) = NaN; %take out the zeros added by rotating a square image, these mess up the average
    horizslice = nanmean(temprotatebackground,1); %take the average of each column, ignoring nan's
    horizslice(isnan(horizslice)==1) = []; %due to rotating a square image by an arbitrary angle, some columns will be all 0's, which are then changed to NaN's, making the mean NaN.  This removes those outer columns
    xpts = [1:length(horizslice)]; 
    horizslope(q) = xpts'\horizslice'; %linear regression to determine slope of the intensity row vector
end

%% calculating linear coefficients for background intensity gradient
[maxslope, maxidx] = max(horizslope);
background_gradient_angle = testangle(maxidx);

rotatebackground = imrotate(ReferenceImage,background_gradient_angle);
rotatebackground(rotatebackground==0) = NaN;
best_horizslice = nanmean(rotatebackground,1);
best_horizslice(isnan(best_horizslice)==1) = [];
best_xpts = [1:length(best_horizslice)];
best_xpts = [ones(1,length(best_xpts));best_xpts]; %pads the x data points with ones to calculate y intercept
best_horizcoeff = best_xpts'\best_horizslice'; %best_horizcoeff(1) is the y intercept, and best_horizcoeff(2) is the slope

%% creating linear intensity gradient image

% gradback = ones(size(nanbackgroundim));

gradhorizvec = [1:size(rotatebackground,2)];
gradhorizvec = best_horizcoeff(2).*(gradhorizvec-1) + best_horizcoeff(1);

%this takes the row vector of linearly increasing intensities based on the
%maximum gradient calculation, and repeats them to make an image the same
%number of rows (same height) as the ROTATED original input image
gradbackim = repmat(gradhorizvec,size(rotatebackground,1),1);

% rotating linear gradient back to space of input image
rotbackim = imrotate(gradbackim,360-background_gradient_angle);

% clipping edges so that linear gradient background is the same size as
% original input image
excess_y = round((size(rotbackim,1) - size(ReferenceImage,1))./2);
excess_x = round((size(rotbackim,2) - size(ReferenceImage,2))./2);

cliprotbackim = rotbackim(excess_y+1:excess_y+size(ReferenceImage,1),excess_x+1:excess_x+size(ReferenceImage,2));

IntGradSubtractedImage = ReferenceImage - cliprotbackim;


end




