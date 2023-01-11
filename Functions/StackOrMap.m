function [dirLabel] = StackOrMap(dirPath)
%
% [out] = StackOrMap(dirpath)
% Determining if a directory is a stack, a map, or a single image

if iscell(dirPath) && length(dirPath) == 1
	dirPath = dirPath{1};
end

dirContents = dir(dirPath);

hdrcnt = 0;
ximcnt = 0;
for j = 1:length(dirContents) %looping through each file name and counting .hdr files
	if contains(dirContents(j).name,'.hdr')
		hdrcnt = hdrcnt + 1;
		
		if hdrcnt == 2
			dirLabel = 'map'; %if 2 or more .hdr files are in one dir, it must be a map, so return
			return
			
		end
	elseif contains(dirContents(j).name,'.xim')
		ximcnt = ximcnt + 1;
		if ximcnt <= 10
			dirLabel = 'map'; % less than 10 images, could still be a map
		end
	end
	
end

if ximcnt > 10 && hdrcnt == 1 %many images but only one header, this is a stack
	dirLabel = 'stack'; % If there's at least one hdr it must be at least a stack
end

if hdrcnt == 0
	disp('no hdr file');
	disp(dirPath);
end

end