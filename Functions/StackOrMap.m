function [dirLabel] = StackOrMap(dirPath)
%
% [out] = StackOrMap(dirpath)
% Determining if a directory is a stack, a map, or a single image

if iscell(dirPath) && length(dirPath) == 1
	dirPath = dirPath{1};
end

dirContents = dir(dirPath);

hdrcnt = 0;
for j = 1:length(dirContents) %looping through each file name and counting .hdr files
	if contains(dirContents(j).name,'.hdr')
		hdrcnt = hdrcnt + 1;
		dirLabel = 'stack'; % If there's at least one hdr it must be at least a stack
		
		if hdrcnt == 2
			dirLabel = 'map'; %if 2 or more .hdr files are in one dir, it's a map
			return
			
		end
	end
end

if hdrcnt == 0
	disp('no hdr file');
	disp(dirPath);
end

end