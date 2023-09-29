function S = LoadStackRawMulti(filedir)
%function S = LoadStackRawMulti(filedir)
%
%Imports STXM raw data from input directoy filedir
%filedir needs to contain the STXM header file (.hdr) and the STXM data files (.xim)
%R.C. Moffet, T.R. Henn February 2009
%
%Modified by Matthew Fraund November 2015
%Updated by MWF 5/28/18 to work with maps or stacks
%
%Inputs
%------
%filedir        path to STXM raw data directory (folder)
%
%Outputs
%-------
%S              structure array containing imported STXM data
%S.spectr       STXM absorption images
%S.eVenergy     Photon energies used to record images
%S.Xvalue       length of horizontal STXM image axis in µm (window range)
%S.Yvalue       length of vertical STXM image axis in µm (window range)
%S.position     structure of positioning values
%   {xvalues,yvalues,xcenter,ycenter,xstep,ystep,xpts,ypts}
%   all values in um except x/ypts wich are in pixels
%

%% Checking supplied path
FileList = dir(filedir);
lsize = size(FileList,1); %length doesn't work here because the file name may be longer than the number of files
%% Finding Image and Header files
hdrcnt = 0;
ximcnt = 0;
for j = 1:lsize
    currentfile = FileList(j).name; %paring off spaces before and after file name
    hdrflag = strfind(currentfile,'.hdr'); %finding .hdr files
    ximflag = strfind(currentfile,'.xim'); %finding .xim files
    
    if ~isempty(hdrflag)
        hdrcnt = hdrcnt + 1;
        hdridx(hdrcnt) = j;
    elseif ~isempty(ximflag)
        ximcnt = ximcnt + 1;
        ximidx(ximcnt) = j;
    end
end


%% Folder or File
if isfile(filedir) %not a directory (it's a file)
    if hdrcnt > 0 | ximcnt > 0
        hdrname = [FileList.name(1:end-4),'.hdr'];
        ximname = [FileList.name(1:end-4),'_a.xim'];
        currpath_hdr = fullfile(FileList.folder, hdrname);
        currpath_xim = fullfile(FileList.folder, ximname);
        [S.eVenergy,S.Xvalue,S.Yvalue,multiregion,S.position]=ReadHdrMulti(currpath_hdr); %running modified ReadHdr
        S.spectr = flipud(load(currpath_xim));
    end
elseif isfolder(filedir) %its a directory 
    %% Loading Map (more than 1 header) or Stack (only 1 header)
    if hdrcnt > 1 %map, more than one header
        for q = 1:ximcnt
            currpath_hdr = fullfile(FileList(hdridx(q)).folder, FileList(hdridx(q)).name);
            currpath_xim = fullfile(FileList(ximidx(q)).folder, FileList(ximidx(q)).name);
            [S.eVenergy(q), S.Xvalue, S.Yvalue, multiregion, S.position] = ReadHdrMulti(currpath_hdr);
            S.spectr(:,:,q) = flipud(load(currpath_xim));
            S.eVenergy = S.eVenergy'; %so that it loads in the same column vector as with stacks
        end
        
    else %stack
        currpath_hdr = fullfile(FileList(hdridx).folder, FileList(hdridx).name);
        [S.eVenergy,S.Xvalue,S.Yvalue,multiregion,S.position]=ReadHdrMulti(currpath_hdr); %running modified ReadHdr
        for q = 1:ximcnt
            currpath_xim = fullfile(FileList(ximidx(q)).folder, FileList(ximidx(q)).name);
            S.spectr(:,:,q) = flipud(load(currpath_xim));
        end
        
    end
    
    %% Check for Multi region image (we don't really do these)
    if multiregion == 1 %display error message
        errormsg = sprintf('%s',filedir,' is a multistack dir, run stxmsort with multihdrsplit first');
        errordlg(errormsg);
    end
    
    %% truncate crashed stacks:
    if size(S.spectr,3)<length(S.eVenergy)
        S.eVenergy((size(S.spectr,3)+1):length(S.eVenergy))=[];
    end
    
    
end
end