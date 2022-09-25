%sorts a single data set (only 1 experiment/sample type can be included)
%sort your data into folders like this:
%
%amazon050615_stg7 (spaces or any valid folder characters are fine)
%all maps must be placed in their own folders within this directory as well
%
%the folder can be named any valid name but all contents must be similar.
%Feed this routine the containing directory
%
%Non-Matlab FILE DEPENDENCIES
%---------------------------------
%uipickfiles (from internet) : This is a fancier version of
%						uigetfiles/uigetdir
%sillystring (optional but recommended) : funny(subjective) lines for
%						waitbar to display
%ReadHdrMulti (necessary) : This is needed to extract useful positioning
%						information from the hdr files
%multihdrsplit (necessary) : This is used to split multi region images
%						(specifically the hdr's) into separate files,
%						one for each particle
function stxmsort()
foldernames = uipickfiles;
lfolders = length(foldernames);

if any(exist('sillystring','file'))
	hwait = waitbar(0,sillystring);
else
	hwait = waitbar(0,'plz w8');
end

for k = 1:length(foldernames)
	if iscell(foldernames) == 0 %if you canceled uipickfiles this doesn't
		break					%make you wait until the end
	end
	
	cd(foldernames{k})
	dirlist = dir;
	dirlist = dirlist(3:end); %starting at 3 removes '.' and '..'
	
	if exist('LocatingFiles','dir') == 0
		mkdir('LocatingFiles'); %only creates new folder if necessary
	end
	
	if exist('BadFiles','dir') == 0
		mkdir('BadFiles'); %only creates a new folder if necessary
	end
	
	alphastr = 'abcdefghijklmnopqrstuvwxyz'; %this allows me to append a letter instead of a number
	ldirs = length(dirlist);
	
	
	
	for i = 1:ldirs
		
		if any(exist(dirlist(i).name,'dir'))
			
			if ~isempty(strfind(dirlist(i).name,'Stack')) %this basically checks to see if stxmsort
				continue									%has already been run
			elseif ~isempty(strfind(dirlist(i).name,'stack'))
				continue
			elseif ~isempty(strfind(dirlist(i).name,'Map'))
				continue
			elseif ~isempty(strfind(dirlist(i).name,'Bad'))
				continue
			elseif ~isempty(strfind(dirlist(i).name,'Locating'))
				continue
			elseif ~isempty(strfind(dirlist(i).name,'NoHDR'))
				continue
			elseif ~isempty(strfind(dirlist(i).name,'Aborted'))
				continue
			end
			
			cd(dirlist(i).name)
			subdir = dir;
			subdir = subdir(3:end);
			cnt = 0;
			ximcnt = 0;
			for j = 1:length(subdir)
				idx = strfind(subdir(j).name,'.hdr');
				idx2 = strfind(subdir(j).name,'.xim');
                
				if any(idx) %this counts how many hdr files there are
					cnt = cnt + 1;
					[eVenergy,~,~,multiflag,position] = ReadHdrMulti(subdir(j).name);
				end %The xvalue and yvalue are not used or needed here
                
				if any(idx2) %this counts how many xim files there are
					ximcnt = ximcnt + 1;
				end
			end
			
			
			if cnt == 0 %If no .hdr file is found
				cd('..');
				newname = sprintf('%s','BadFiles/NoHDR',dirlist(i).name);
				movefile(dirlist(i).name,newname,'f');
				
			elseif ximcnt < 2 %Lots of stacks are aborted with only one image
				cd('..');
				newname = sprintf('%s','BadFiles/Aborted',dirlist(i).name);
				movefile(dirlist(i).name,newname,'f');
				
			elseif multiflag == 1 %If ReadHdrMulti recognizes a multi part image
				numxim = length(eVenergy)*position.regions;
				
				if ximcnt < numxim %This block checks to make sure enough files are present
					cd('..')
					newname = sprintf('%s','BadFiles/AbortedMulti',dirlist(i).name);
					movefile(dirlist(i).name,newname,'f');
					continue
				end
				
				FileList = ls;
				lsize = size(FileList,1);
				spectrcell = cell(length(eVenergy),length(position.xstep)); %initializing a cell which separates positions and energies
				for j = 1:lsize
					currentfile = strtrim(FileList(j,:)); %clips white space
					ximidx = strfind(currentfile,'.xim');
					hdridx = strfind(currentfile,'.hdr');
					if any(ximidx)
						enum = str2double(currentfile(ximidx-4:ximidx-2))+1; %picks the range of numbers (from file name) that correspond to energy
						pnum = str2double(currentfile(ximidx-1))+1; %picking the single number which corresponds to the sub-image (only goes up to 9)
						spectrcell{enum,pnum} = currentfile; %A given column contains all the data for a specific particle
					end
				end
				
				for j = 1:size(spectrcell,2) %this block appends a letter to each particle 
					newdir = sprintf('%s','partstack',dirlist(i).name,alphastr(j));%and saves it's xim files in a new folder
					mkdir('..',newdir);
					for q = 1:size(spectrcell,1)
						newfile = sprintf('%s','../',newdir,'/',spectrcell{q,j});
						movefile(spectrcell{q,j},newfile,'f');
					end
				end
				
				FileList = ls;
				lsize = size(FileList,1);
				for j = 1:lsize %This block splits the hdr into the same number of parts as regions
					currentfile = strtrim(FileList(j,:));
					hdridx = strfind(currentfile,'.hdr');
					if any(hdridx)
						hdrname = currentfile;
						multihdrsplit(currentfile);
                        recycle('on');
						delete(currentfile); %you could use delete but that is scary
						break
					end
					clear hdridx
				end
				
				FileList = ls;
				lsize = size(FileList,1);
				for j = 1:lsize %This block moves the separate hdr files (This could probably be
					currentfile = strtrim(FileList(j,:)); %incorporated into the previous block
					hdridx = strfind(currentfile,'.hdr');
					if any(hdridx) 
						hdrname = currentfile;
						alphaidx = strfind(alphastr,hdrname(end-4));
						newfile = sprintf('%s','../','partstack',dirlist(i).name,alphastr(alphaidx));
						movefile(currentfile,newfile,'f');
					end
					clear hdridx
				end
				cd('..');
                recycle('on');
				rmdir(dirlist(i).name,'s');
							
			elseif cnt == 1 % there is one hdr
                
                %If there aren't enough xim images compared to what the hdr says
				if ximcnt < length(eVenergy) % (length(subdir)-1)<length(eVenergy) --- used to be this but this messes up with stuff in folders
					cd('..')
					newname = sprintf('%s','BadFiles/AbortedStack',dirlist(i).name);
					movefile(dirlist(i).name,newname,'f');
					continue
				end
				cd('..');
				if length(eVenergy)>20 %calling above 20 a "full stack" is a bit arbitrary 
					newname = sprintf('%s','FullStack',dirlist(i).name); %but I feel it is big enough
					movefile(dirlist(i).name,newname,'f');
				else
					newname = sprintf('%s','ShortStack',dirlist(i).name);
					movefile(dirlist(i).name,newname,'f');
				end
				
			elseif cnt > 1 %only maps have more than 1 hdr
				cd('..');
				newname = sprintf('%s','Map',dirlist(i).name);
				movefile(dirlist(i).name,newname,'f');
			end
			
		else %Everything else not caught above gets shoved in here
			newname = sprintf('%s','LocatingFiles/',dirlist(i).name);
			movefile(dirlist(i).name,newname,'f');
		end
		clear multiflag %clearing these here are needed to not confuse the routine
		clear eVenergy
		clear position
		
	end
	waitbar(k/lfolders)
end
close(hwait);
% clear


end
