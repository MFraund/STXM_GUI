function [closestVal, closestIdx, valFound_bool] = ClosestValue(vector, value, bounds, varargin)
% function [closestVal, closestIdx] = ClosestValue(vector, value, bounds)
%
% Determines and outputs the value in "vector" that is the closest to the input "value"
%
% Inputs
% ======
% vector - 1-D vector
% value - number to find within vector
% bounds - scalar or 2-element vector.  
%          If scalar, bounds will be [value - bounds, value + bounds
% 'Error Message' - (optional) string to display if value is out of bounds given.
%
%
%
%% Test Examples
% TestVector = [1, 2, 3, 4, 5];
% ClosestValue(TestVector, 2.4)
% >> 2
%
% ClosestValue(TestVector, 2.51)
% >> 3
%
% ClosestValue(TestVector, 0)
% >> 1
%
% ClosestValue(TestVector, -1000)
% >> 1
%
% ClosestValue(TestVector, -1000, 10) %Value out of bounds
% >> NaN
% >> Out of Bounds
%
% ClosestValue(TestVector, -1000, 0, 'Error Message', 'Cool Message')
% >> Cool Message
% >> NaN
% 

%% Extracting inputs
[varargin,errMsg] = ExtractVararginValue(varargin,'Error Message','Out of Bounds');
[varargin, verbose_bool] = ExtractVararginValue(varargin, 'Display Errors', true);

%% Input Checking
% Dealing with absent boundary conditions
if nargin < 3
	bounds = inf;
end

if iscell(vector)
	if length(vector) > 1
		disp('Cell vector has more than one entry, attempting to use first cell Size = ');
		size(vector)
	end
	
	vector = vector{1};
	
end

% Accounting for single bound given and for more than 2 bounds given
if length(bounds) == 1
	lowerBound = value - bounds; 
	upperBound = value + bounds;
	
elseif length(bounds) == 2
	lowerBound = bounds(1);
	upperBound = bounds(2);
	
elseif length(bounds) > 2
	lowerBound = bounds(1);
	upperBound = bounds(2);
	disp('Bondary conditions should be 1 or 2 elements, using only the first 2 elements');
	disp('bounds input was:');
	bounds
	
end

% Ensuring bounds are in the right order
if lowerBound > upperBound
	disp('swapping boundary order to make the lower value the lower bound')
	tempbounds = [upperBound, lowerBound];
	lowerBound = tempbound(1);
	upperBound = tempbound(2);
	
end

%% Determining closest value
[~,closestIdx] = min(abs(vector - value));

closestVal = vector(closestIdx);

%% Throwing NaN if outside of boundary conditions
if closestVal < lowerBound | closestVal > upperBound
	closestVal = NaN;
	closestIdx = NaN;
    valFound_bool = false;
    
    if verbose_bool
        disp(errMsg);
    else
    end
else
    valFound_bool = true;
end







end