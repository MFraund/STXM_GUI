function [isEmpty] = isemptyr(X)
%
% isemptyr.m--Recursive version of Matlab's isempty().
%
% isemptyr(X) returns 1 if X is an empty array OR if X is non-empty, but
% contains only elements that are themselves recursively empty. 
%
% For example, if X = {'' ''}, then isemptyr(X) returns 1 because the only
% elements X contains are empty strings. In contrast, Matlab's isempty(X)
% returns 0 because X contains two elements, even though those elements are
% themselves empty.
%
% Similarly for structures. If X = struct('width',[],'height',[]), then
% isempty(X) returns 0 because X has fields, while isemptyr(X) returns 1
% because the only fields in X are empty.
%
% Syntax: isEmpty = isemptyr(X)
%
% e.g.,   X = {'' ''}; isempty(X), isemptyr(X)
% e.g.,   X = struct(); isempty(X), isemptyr(X)
% e.g.,   X = struct('width',[],'height',[],'info',struct('name','','ID',[])); isempty(X), isemptyr(X)

% Developed in Matlab 7.12.0.635 (R2011a) on GLNX86
% for the VENUS project (http://venus.uvic.ca/).
% Kevin Bartlett (kpb@uvic.ca), 2011-09-01 15:18
%-------------------------------------------------------------------------

% isEmpty starts out true. It stops being true the moment a non-empty
% element is found.
isEmpty = true;

% Look for non-empty elements of X if X has any elements to check.
if ~isempty(X)
    
    if isstruct(X)
        % This is a structure that is supposedly non-empty, but all of its
        % fields may be empty. Call isemptyr() recursively on each of its
        % fields to find out if this is the case.
        fieldNames = fieldnames(X);
        
        if ~isempty(fieldNames)                    
            % Recursively call isemptyr() on the fields of X.
            for iField = 1:length(fieldNames)
                thisFieldName = fieldNames{iField};                
                isEmpty = isemptyr(X.(thisFieldName));
                
                if ~isEmpty
                    % Non-empty element found. Return immediately.
                    return;
                end % if                
                
            end % for
        end % if
        
    elseif iscell(X)
        % This is a cell array that is supposedly non-empty, but all of its
        % cells may be empty. Call isemptyr() recursively on each of its
        % cells to find out if this is the case.
        for iEl = 1:length(X)
            isEmpty = isemptyr(X{iEl});
            if ~isEmpty
                % Non-empty element found. Return immediately.
                return;
            end % if
        end % for
    else
        % A structure or cell can be non-empty according to Matlab's
        % isempty() function. This is not a structure or cell, however, so
        % the fact that ~isempty(X) is true means that X really ISN'T
        % empty. Return isEmpty as false immediately.
        isEmpty = false;
        return;
    end % if isstruct
    
end % if

