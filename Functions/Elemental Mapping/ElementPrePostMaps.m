function Snew_out = ElementPrePostMaps(Snew_in, varargin)
% Snew_out = ElementMaps(Snew_in, varargin)
%
% Name-Value pairs (default)
% ----------------
% 'binmap' - 2d matrix -  (Snew_in.binmap)
%   Accepts user supplied binary map
% 'Element' - str - ('C')
%   Element to be used in calculation
% 'Pre Edge' - double - ([])
%   User defined pre-edge value to use.  Defaults to values listed below
% 'Post Edge' - double - ([])
%   User defined post-edge value to use. Defaults to values listed below
% Simple post-edge - pre-edge difference maps for various elements.
% 
% This function both:
% 1. tests for the existence of the specified element and adds the fields
%       Snew.elements.(element) = 1 or 0
%       Snew.elements.(element)_bool = true or false
% 2. calculates the the post-pre edge map and adds the field
%       Snew.tot(element)
%
%
%

%% Input Checking
Snew_out = Snew_in;
[varargin, binmap] = ExtractVararginValue(varargin, 'binmap', Snew_in.binmap);
[varargin, element] = ExtractVararginValue(varargin, 'Element', 'C');
[varargin, preE_in] = ExtractVararginValue(varargin, 'Pre Edge', []);
[varargin, postE_in] = ExtractVararginValue(varargin, 'Post Edge', []);

%% Defining element edges
energy = Snew_in.eVenergy;

switch element
    case 'Ca'
        preE = 347;
        postE = 352.5;
        
        preRange = 3;
        postRange = 2;
    case 'C'
        preE = 278;
        postE = 320;
        
        preRange = 10;
        postRange = 15;
    case 'N'
        preE = 400;
        postE = 430;
        
        preRange = 10;
        postRange = 15;
    case 'K'
        % This is an L edge, not quite as simple as a prepost map to get
        % good quantiative info from.
        preE = 296;
        postE = 297;
        
        preRange = 0.5;
        postRange = 0.5;
    case 'O'
        preE = 525;
        postE = 550;
        
        preRange = 10;
        postRange = 10;
    case 'S'
        % post edge location changes drastically with oxidation state, 190
        % post edge might only work with Sulfate
        preE = 160;
        postE = 190;
        
        preRange = 10;
        postRange = 10;
end


%% Overwriting with user defined pre and post energies
if ~isempty(preE_in)
    preE = preE_in;
end

if ~isempty(postE_in)
    postE = postE_in;
end

%% Calculating energy indicies
[~, preidx, elePreFound_bool] = ClosestValue(energy, preE, [preE-preRange, preE+preRange],'Display Errors',false);
[~, postidx, elePostFound_bool] = ClosestValue(energy, postE, [postE-postRange, postE+postRange],'Display Errors',false);

%% Calculating prepost maps
ele_bool_label = [element, '_bool'];
if elePreFound_bool && elePostFound_bool
    Snew_in.elements.(element) = 1;
    Snew_in.elements.(ele_bool_label) = true;
    
    totEle = Snew_in.spectr(:,:,postidx) - Snew_in.spectr(:,:,preidx);
    totEle(totEle<0) = 0;
    totEle = totEle .* binmap;
    
    prepostFieldName = ['tot', element];
    
    Snew_in.(prepostFieldName) = totEle;

else
    Snew_in.elements.(element) = 0;
    Snew_in.elements.(ele_bool_label) = false;
end

Snew_out = Snew_in;



end