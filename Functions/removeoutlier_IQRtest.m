function [ ArrayNoOutliers ] = removeoutlier_IQRtest(ArrayWithOutliers,varargin)
%REMOVEOUTLIER_IQRTEST Removes large positive outliers from a set of
%positive nonzero data.
%
%[ArrayNoOutliers] = removeoutlier_IQRtest(ArrayWithOutliers, Name,Value)
%
%   outputs an array the same size and dimensionality as input array
%   iqrrange defaults to 1.5 if not specified
%   
%   Name/Value Pairs
%   Name              Default     Input
%   --------------------------------------------
%   IQRMultiplier     1.5         positive value usually near 1
%   OutlierMode       'high'      'high', 'both', 'lower'
%
%   Removes outliers from data using the inter quartile range test (3rd
%   quartile max + 1.5*IQR).
%
%	This is not suited for positive data where zero is a realistic value

%% Input Checking and Inital Calculations

[varargin, iqr_multiplier] = ExtractVararginValue(varargin,'IQRMultiplier',1.5);
[varargin, outliermode] = ExtractVararginValue(varargin,'OutlierMode','high');

ar = ArrayWithOutliers;
outlierflag = 1;
outlierflag_upper = 1;
outlierflag_lower = 1;


%% Checking Whether to Remove High+Low or only High Outliers
%No functionality for removing only low outliers
if strcmp(outliermode,'high') %Only Remove High Outliers
	%the assumption here is that if the minimum value is 0, the outliers
	%are large spikes
	
	upperq3 = prctile(ar(ar~=0),75);
	lowerq2 = prctile(ar(ar~=0),25);
	iqr = upperq3 - lowerq2;
	
	%this removes a lot of pixels that are huge and leaves the fine tuning for the loop.
	% Because this works with only positive, nonzero data, the iqr is only ever
	% going to shrink with the iterations below.  everything that is bigger
	% than upperq3+1.5*iqr is always going to be bigger.
	ar(ar>upperq3+iqr_multiplier.*iqr) = 0;
	
	while outlierflag == 1
		upperq3 = prctile(ar(ar~=0),75);
		iqr = upperq3 - prctile(ar(ar~=0),25);
		testoutlier_upper = max(max(ar));
		
		if testoutlier_upper > upperq3 + iqr.*iqr_multiplier
			ar(ar == testoutlier_upper) = 0;
		else
			outlierflag = 0;
		end
		
	end

elseif strcmp(outliermode,'both')
	while outlierflag == 1
		%% Initial Calculation
		upperq3 = prctile(ar,75);
		lowerq2 = prctile(ar,25);
		iqr = upperq3 - lowerq2;
		testoutlier_upper = max(max(ar));
		testoutlier_lower = min(min(ar));
		%% Testing Upper Outliers
		if testoutlier_upper > upperq3 + iqr.*iqr_multiplier
			ar(ar == testoutlier_upper) = NaN;
		else
			outlierflag_upper = 0;
		end
		%% Testing Lower Outliers
		if testoutlier_lower < lowerq2 - iqr.*iqr_multiplier
			ar(ar == testoutlier_lower) = NaN;
		else
			outlierflag_lower = 0;
		end
		
		if outlierflag_upper == 0 && outlierflag_lower == 0
			outlierflag = 0;
		end
	end
elseif strcmp(outliermode,'lower')
	disp('---------lower outlier function not coded for----------------');
end

ArrayNoOutliers = ar;
end

