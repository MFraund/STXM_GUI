function [evenergy,xvalue,yvalue,multiregion,positionstruct]=ReadHdrMulti(file)

% Read STXM .hdr file to extract energies and x and y pixel sizes
%[evenergy,xvalue,yvalue,multiregion,positionstruct]=ReadHdr(file)
% 081011 RCM
%
%Input
%======================================================
%file					= folder/folder/file pathame
%
%
%Output
%======================================================
%evenergy				= vector of energies used (in eV)
%multiregion flag		= 0 for single image, 1 for multi images
%positionstruct			= structure with positioning information
%positionstruct.xvalue	= range of window in x direction (xrange)
%positionstruct.yvalue	= range of window in y direction (yrange)
%positionstruct.xcenter = center of window in x
%positionstruct.ycenter = center of window in y
%positionstruct.xstep	= resolution of image in x in um
%positionstruct.ystep	= resolution of image in y in um
%positionstruct.xpts	= # of points taken in x
%positionstruct.ypts	= # of points taken in y
%
% updated by Matthew Fraund Nov. 2015
filestream = fopen(file, 'r');    %% Open file
cnt=1;
multiregion = 0; %default unless strfind finds the multi region flag
numregions = [];
regioncnt = 1;
while feof(filestream) == 0
    line=fgets(filestream);
    energypos=strfind(line,'StackAxis');
	centeridx = strfind(line,'CentreXPos');
	centeridx2 = strfind(line,'CentreYPos');
    pos3=strfind(line,'; XRange =');
	
	if isempty(numregions) == 1 
		multflag = strfind(line,'	Regions = (');
		if any(multflag)
			numregions = str2double(line(multflag+12));
			if any(numregions)
				positionstruct.xvalues = ones(1,numregions);%initializing variables depending on numregions
				positionstruct.yvalues = ones(1,numregions);
				positionstruct.xcenter = ones(1,numregions);
				positionstruct.ycenter = ones(1,numregions);
				positionstruct.xstep = ones(1,numregions);
				positionstruct.ystep = ones(1,numregions);
				positionstruct.xpts = ones(1,numregions);
				positionstruct.ypts = ones(1,numregions);
			end
		end
	end
	
	

	if numregions == 1
		if ~isempty(energypos)
			line=fgets(filestream);
			pos1=strfind(line,'(');
			pos2=strfind(line,')');
			energyvec=str2num(line(pos1+1:pos2-1)); %takes all points between () I think it needs to stay str2num because it takes a vector
			evenergy=energyvec(2:end)'; %removes the first number which is simply the number of points
		elseif ~isempty(pos3)
			pos4=strfind(line,'; YRange =');
			pos5=strfind(line,'; XStep =');
			pos6=strfind(line,'; YStep =');
			pos7 = strfind(line,'XPoints =');
			pos8 = strfind(line,'YPoints =');
            pos9 = strfind(line,'; SquareRegion');
			positionstruct.xvalues = str2double(line(pos3+10:pos4-1));
			positionstruct.yvalues=str2double(line(pos4+10:pos5-1));
			positionstruct.xstep=str2double(line(pos5+10:pos6-1));
			positionstruct.ystep=str2double(line(pos6+10:pos7-3));
			positionstruct.xcenter = str2double(line(centeridx+13:centeridx2-3));
			positionstruct.ycenter = str2double(line(centeridx2+13:pos3-3));
			positionstruct.xpts = str2double(line(pos7+10:pos8-3));
            positionstruct.ypts = str2double(line(pos8+10:pos9-1));
		end
	elseif numregions > 1
		multiregion = 1;
		if ~isempty(centeridx)
			positionstruct.xcenter(1,regioncnt) = str2double(line(centeridx+13:centeridx2-3));
			positionstruct.ycenter(1,regioncnt) = str2double(line(centeridx2+13:pos3-3));
			pos4=strfind(line,'; YRange =');
			pos5=strfind(line,'; XStep =');
			positionstruct.xvalues(1,regioncnt)=str2double(line(pos3+10:pos4-1));
			positionstruct.yvalues(1,regioncnt)=str2double(line(pos4+10:pos5-1));
			pos6=strfind(line,'; YStep =');
            pos7 = strfind(line,'XPoints =');
            pos8 = strfind(line,'YPoints =');
            pos9 = strfind(line,'; SquareRegion');
			positionstruct.xstep(1,regioncnt)=str2double(line(pos5+10:pos6-1));
			positionstruct.ystep(1,regioncnt)=str2double(line(pos6+10:pos7-3));
            positionstruct.xpts(1,regioncnt) = str2double(line(pos7+10:pos8-3));
            positionstruct.ypts(1,regioncnt) = str2double(line(pos8+10:pos9-1));
			regioncnt = regioncnt + 1;
		elseif ~isempty(energypos)
			line=fgets(filestream);
			pos1=strfind(line,'(');
			pos2=strfind(line,')');
			energyvec=str2num(line(pos1+1:pos2-1)); %takes all points between (), needs to be str2num
			evenergy=energyvec(2:end)'; %removes the first number which is simply the number of points
		end        
	end
    clear line pos3;
    cnt=cnt+1;
end
fclose(filestream);
positionstruct.regions = (regioncnt-1);
xvalue = max((positionstruct.xcenter + positionstruct.xvalues./2)) - min((positionstruct.xcenter - positionstruct.xvalues./2));
yvalue = max((positionstruct.ycenter + positionstruct.yvalues./2)) - min((positionstruct.ycenter - positionstruct.yvalues./2));


end
