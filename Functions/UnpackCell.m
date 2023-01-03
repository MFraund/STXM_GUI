function cellOut = UnpackCell(cellIn)
%
% cellOut = UnpackCell(cellIn)
%
% Recursive function to unpack nested cells into a single, long cell

bigCell = cell(0);
[cellOut] = unpackCell_recursive(cellIn, bigCell);

	function [bigCell] = unpackCell_recursive(cellIn_recursive, bigCell)
		ncells = length(cellIn_recursive);
		for c = 1:ncells 
			if ~iscell(cellIn_recursive{c}) %this is only an element of the larger cell, not a cell itself
				bigCell = cat(1, bigCell, cellIn_recursive{c}); %base case	
			else
				bigCell = unpackCell_recursive(cellIn_recursive{c}, bigCell);			
			end
		end
	end

end