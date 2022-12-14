function STXM_GUIv4

%initial gui stuff
%
%
%Non-matlab file dependencies (source):
%-----------------------------
%uipickfiles (found online)


%% create then hide the UI as it is being constructed
f = figure(...
    'Visible','off',...
    'Units','normalized',...
    'Position',[360,200,0.8,0.8],...
    'KeyPressFcn',{@figkeypress_callback},...
    'CloseRequestFcn',{@figureclose_callback},...
    'Name','AnalyzingSTXM');



%% constructing components
%================================================================
%================================================================

%%%%
%%%% Components Always Visible
%%%%

hremove = uicontrol(...
    'Style','pushbutton',...
    'String','Remove Selected',...
    'Units','normalized',...
    'Enable','off',...
    'Position',[0.11,0.01,0.09,0.05],...
    'Callback',{@hremove_callback});

hreadytitle = uicontrol(...
    'Style','text',...
    'String','Data to Run',...
    'Units','normalized',...
    'Position',[0.12,0.88,0.07,0.02]);

hlistready = uicontrol(...
    'Style','listbox',...
    'Max',100,...
    'Min',0,...
    'Units','normalized',...
    'KeyPressFcn',{@hlistreadykey_callback},...
    'Callback',{@hlistready_callback},...
    'Position',[0.01,0.07,0.3,0.8]);




hroutinepopup = uicontrol(...
    'Style','popupmenu',...
    'String',{'Load & Run Data','Data Viewer','StackLab','EDXmapview'},...
    'Units','normalized',...
    'Position',[0.01,0.93,0.1,0.053],...
    'KeyPressFcn',{@hlistreadykey_callback},...
    'Callback',{@hroutinepopup_callback});


%% Components in Load and Run screen
%%%% 
%%%%

husesaved = uicontrol(...
    'Style','checkbox',...
    'String','Use Saved Analyses',...
    'Units','normalized',...
    'Tag','Load',...
    'Value',1,...
    'Position',[0.12,0.97,0.15,0.02],...
    'Callback',{@husesaved_callback});

htextcheck = uicontrol(...
	'Style','text',...
	'String',[],...
	'Units','normalized',...
	'Tag','Load',...
	'Position',[0.20,0.965,0.2,0.02]);

hqcsaved = uicontrol(...
    'Style','checkbox',...
    'String','Use Saved QC Params',...
    'Units','normalized',...
    'Tag','Load',...
    'Value',0,...
    'Enable','off',...
    'Position',[0.12,0.95,0.15,0.02],...
    'Callback',{@hqcsaved_callback});

hload = uicontrol(...
    'Style','pushbutton',...
    'String','Load STXM Data',...
    'Units','normalized',...
    'Tag','Load',...
    'Position',[0.01,0.88,0.1,0.053],...
    'Callback',{@hload_callback});

hanalyze = uicontrol(...
    'Style','pushbutton',...
    'String','Analyze All',...
    'Units','normalized',...
    'Enable','off',...
    'Tag','Load',...
    'Position',[0.21,0.88,0.1,0.053],...
    'Callback',{@hanalyze_callback});

hsort = uicontrol(...
    'Style','pushbutton',...
    'String','Run stxmsort',...
    'Units','normalized',...
    'Tag','Load',...
    'Position',[0.87, 0.93, 0.1, 0.053],...
    'Callback',{@hsort_callback});

hdatamerge = uicontrol(...
	'Style','pushbutton',...
	'String','Merge STXM Data',...
	'Units','normalized',...
	'Tag','Load',...
	'Position',[0.87, 0.83, 0.1, 0.053],...
	'Callback',{@hmerge_callback});



hassumedinorgpopup = uicontrol(...
	'Style','popupmenu',...
    'Units','normalized',...
    'Position',[0.32,0.878,0.1,0.05],...
	'String',{'NaCl','(NH4)2SO4','NH4NO3','NaNO3','KNO3','Na2SO4','KCl','Fe2O3','CaCO3','ZnO','Pb(NO3)2','Al2Si2O9H4'},...
    'Tag','Load');

hassumedorgpopup = uicontrol(...
	'Style','popupmenu',...
	'Units','normalized',...
	'Position',[0.32,0.8,0.1,0.05],...
	'String',{'sucrose','adipic','glucose','oxalic'},...
	'Tag','Load');




%% Components seen in Data Viewer screen
%%%% 
%%%%

rawbg = uibuttongroup (...
    'Units','normalized',...
    'Visible','off',...
    'Position',[0.80,0.90,0.17,0.1],...
    'Title','Raw Images',...
    'SelectionChangedFcn',{@rawbg_callback});

%Creating buttons belonging to rawbg button group
hSulfurrad = uicontrol(...
    'Style','radiobutton',...
    'String','Sulfur',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.1,0.6,0.3,0.2]);

hCarbonrad = uicontrol(...
    'Style','radiobutton',...
    'String','Carbon',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.1,0.2,0.3,0.2]);

hPotassiumrad = uicontrol(...
    'Style','radiobutton',...
    'String','Potassium',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.35,0.6,0.3,0.2]);

hCalciumrad = uicontrol(...
    'Style','radiobutton',...
    'String','Calcium',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.35,0.2,0.3,0.2]);

hNitrogenrad = uicontrol(...
    'Style','radiobutton',...
    'String','Nitrogen',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.65,0.6,0.3,0.2]);

hOxygenrad = uicontrol(...
    'Style','radiobutton',...
    'String','Oxygen',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.65,0.2,0.3,0.2]);

heleradlist = cell(6,1);
heleradlist{1} = hSulfurrad;
heleradlist{2} = hCarbonrad;
heleradlist{3} = hPotassiumrad;
heleradlist{4} = hCalciumrad;
heleradlist{5} = hNitrogenrad;
heleradlist{6} = hOxygenrad;


%this one is for the checkboxes used in prepost image display
helementpanel = uipanel(...
    'Units','normalized',...
    'Title','Pre-post Images',...
    'Visible','off',...
    'Tag','DataViewer',...
    'Position',[0.80,0.90,0.17,0.1]);

hSulfurbox = uicontrol(...
    'Style','checkbox',...
    'String','Sulfur',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.1,0.6,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hCarbonbox = uicontrol(...
    'Style','checkbox',...
    'String','Carbon',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.1,0.2,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hPotassiumbox = uicontrol(...
    'Style','checkbox',...
    'String','Potassium',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.35,0.6,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hCalciumbox = uicontrol(...
    'Style','checkbox',...
    'String','Calcium',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.35,0.2,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hNitrogenbox = uicontrol(...
    'Style','checkbox',...
    'String','Nitrogen',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.65,0.6,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hOxygenbox = uicontrol(...
    'Style','checkbox',...
    'String','Oxygen',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.65,0.2,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

heleboxlist = cell(6,1);
heleboxlist{1} = hSulfurbox;
heleboxlist{2} = hCarbonbox;
heleboxlist{3} = hPotassiumbox;
heleboxlist{4} = hCalciumbox;
heleboxlist{5} = hNitrogenbox;
heleboxlist{6} = hOxygenbox;

radiosinglePOS = [0.53,0.94,0.1,0.04];

hradiosingle = uicontrol(...
    'Style','radiobutton',...
    'String','Single Image',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','DataViewer',...
    'Position',radiosinglePOS,...
    'KeyPressFcn',{@hradio_callback},...
    'Callback',{@hradiosingle_callback});

radiomultiplePOS = radiosinglePOS;
radiomultiplePOS(1,1) = radiosinglePOS(1,1) + 0.06;
radiomultiplePOS(1,3) = radiosinglePOS(1,3) - 0.03;

hradiomultiple = uicontrol(...
    'Style','radiobutton',...
    'String','2x2 Image',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','DataViewer',...
    'Value',1,...
    'Position',radiomultiplePOS,...
    'KeyPressFcn',{@hradio_callback},...
    'Callback',{@hradiomultiple_callback});

ODlimitcheckPOS = radiosinglePOS;
ODlimitcheckPOS(1,1) = radiosinglePOS(1,1) - 0.065;
ODlimitcheckPOS(1,3) = radiosinglePOS(1,3) - 0.04;

hODlimitcheck = uicontrol(...
    'Style','checkbox',...
    'String','OD Limit Visual',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','DataViewer',...
    'Value',0,...
    'Position',ODlimitcheckPOS,...
    'Callback',{@hODlimit_callback});

popupimagesPOS = [0 , 0.92, 0.1, 0.053];
popupimagesPOS(1,1) = radiomultiplePOS(1,1) + 0.05;

hpopupimages = uicontrol(...
    'Style','popupmenu',...
    'String',{'Prepost Images','Raw Images','Organic Vol. Fractions','ODStack Images','CarbonMaps Images','Alignment','Size Distribution'},...
    'Units','normalized',...
    'Visible','off',...
    'Tag','DataViewer',...
    'Position',popupimagesPOS,...
    'KeyPressFcn',{@hlistreadykey_callback},...
    'Callback',{@hselect_callback});

hmultidistfxn = uicontrol(...
    'Style','popupmenu',...
    'String',{'Size Distribution', 'OVF Distribution'},...
    'Units','normalized',...
    'Visible','off',...
    'Tag','MultiFOV',...
    'Position',popupimagesPOS,...
    'KeyPressFcn',{@hlistreadykey_callback},...
    'Callback',{@hmultidistfxn_callback});

imagePOS = [0.35,0.07,0.62,0.8];

hpanelmultiple = uipanel(f,...
    'Position',imagePOS,...
    'Visible','off');

hpanelsingle = uipanel(f,...
    'Position',imagePOS,...
    'Visible','off',...
    'HandleVisibility','on');


hstacklabbutton = uicontrol(...
    'Style','pushbutton',...
    'String','Run StackLab on Selected',...
    'Units','normalized',...
    'Visible','off',...
    'Position',[0.35,0.88,0.1,0.053],...
    'Tag','DataViewer',...
    'Callback',{@hstacklabbutton_callback});

hsphericitybutton = uicontrol(...
    'Style','pushbutton',...
    'String','Run Particle Sphericity',...
    'Units','normalized',...
    'Visible','off',...
    'Position',[0.46,0.88,0.1,0.053],...
    'Tag','DataViewer',...
    'Callback',{@hsphericitybutton_callback});

hdataexport = uicontrol(...
    'Style','pushbutton',...
    'String','Export Current File to Workspace',...
    'Units','normalized',...
    'Visible','off',...
    'Position',[0.57,0.88,0.1,0.053],...
    'Tag','DataViewer',...
    'Callback',{@hdataexport_callback});

hBeersTest = uicontrol(...
	'Style','pushbutton',...
	'String','Beers Law Test',...
	'Units','normalized',...
	'Visible','off',...
	'Position',[0.68,0.88,0.1,0.053],...
	'Tag','DataViewer',...
	'Callback',{@hBeersTest_callback});


titlepos = [0.54,0.84,0.25,0.02];


hleft = uicontrol(...
    'Style','pushbutton',...
    'String','<',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','DataViewer',...
    'Position',[0.33,0.45,0.02,0.1],...
    'Callback',{@hleft_callback});

hright = uicontrol(...
    'Style','pushbutton',...
    'String','>',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','DataViewer',...
    'Position',[0.97,0.45,0.02,0.1],...
    'Callback',{@hright_callback});

hplottitle = uicontrol(...
    'Style','text',...
    'String','TITLE',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','DataViewer',...
    'Position',titlepos);

hsavecontext = uicontextmenu(...
    'Parent',f);

hmenuitems = uimenu(hsavecontext,...
    'Label','Save plot window',...
    'Callback',@context_callback);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%STACKLAB Components
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hpanelstacklab = uipanel(f,...
    'Position',imagePOS,...
    'Visible','off',...
    'Tag','StackLab',...
    'HandleVisibility','on');

hstacklabtitle = uicontrol(...
    'Style','text',...
    'String','TITLE',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','Stacklab',...
    'Position',titlepos);

hROI = uicontrol(...
    'Style','pushbutton',...
    'String','New ROI',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','Stacklab',...
    'Position',[0.35,0.01,0.07,0.05]);

hReset = uicontrol(...
    'Style','pushbutton',...
    'String','Reset',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','Stacklab',...
    'Position',[0.425,0.01,0.07,0.05]);

hEnergyA = uicontrol(...
    'Style','pushbutton',...
    'String','Energy A',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','Stacklab',...
    'Position',[0.5,0.01,0.07,0.05]);

hEnergyB = uicontrol(...
    'Style','pushbutton',...
    'String','Energy B',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','Stacklab',...
    'Position',[0.575,0.01,0.07,0.05]);

hSubtract = uicontrol(...
    'Style','pushbutton',...
    'String','Energy A - B',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','Stacklab',...
    'Position',[0.65,0.01,0.07,0.05]);

hsavespectxt = uicontrol(...
    'Style','pushbutton',...
    'String','Save Spec .txt',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','Stacklab',...
    'Position',[0.725,0.01,0.07,0.05]);

hsavespecfig = uicontrol(...
    'Style','pushbutton',...
    'String','Save Spec .fig',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','Stacklab',...
    'Position',[0.8,0.01,0.07,0.05]);

hsavestackfig = uicontrol(...
    'Style','pushbutton',...
    'String','Save Stack .fig',...
    'Units','normalized',...
    'Visible','off',...
    'Tag','Stacklab',...
    'Position',[0.875,0.01,0.07,0.05]);

%%
%%%% Adding Quality Control Buttons
%%%%
hcarbon_mixingstate = uicontrol(...
    'Style','pushbutton',...
    'String','IN/OC/EC Mixing State',...
    'Units','normalized',...
    'Visible','off',...
    'Position',[0.35,0.01,0.1,0.053],...
    'Tag','DataViewer',...
    'Enable','on',...
    'Callback',{@carbon_mixingstate_callback});

hmanualIo = uicontrol(...
    'Style','pushbutton',...
    'String','Manually Select Io',...
    'Units','normalized',...
    'Visible','off',...
    'Position',[0.46,0.01,0.1,0.053],...
    'Tag','DataViewer',...
    'Callback',{@hmanualIo_callback});

hfixAlign = uicontrol(...
    'Style','pushbutton',...
    'String','Manually Align Images',...
    'Visible','off',...
    'Units','normalized',...
    'Position',[0.57,0.01,0.1,0.053],...
    'Tag','DataViewer',...
    'Enable','on',...
    'Callback',{@hfixAlign_callback});

hremoveenergy = uicontrol(...
    'Style','pushbutton',...
    'String','Remove Energy',...
    'Visible','off',...
    'Units','normalized',...
    'Position',[0.68,0.01,0.1,0.053],...
    'Tag','DataViewer',...
    'Enable','on',...
    'Callback',{@hremoveenergy_callback});

hmask_adjust = uicontrol(...
    'Style','pushbutton',...
    'String','Adj. Part. Thresh.',...
    'Visible','off',...
    'Units','normalized',...
    'Position',[0.79, 0.01, 0.1, 0.053],...
    'Tag','DataViewer',...
    'Callback',{@hmask_adjust_callback});

hbinmap_adjust = uicontrol(...
    'Style','pushbutton',...
    'String','Adjust Included Particles',...
    'Visible','off',...
    'Units','normalized',...
    'Position',[0.90, 0.01, 0.1, 0.053],...
    'Tag','DataViewer',...
    'Callback',{@hbinmap_adjust_callback});


%% bad globals
global imageselectionvalue;
imageselectionvalue = 1;
global analyzeruntest;
analyzeruntest = 0;
global filedirs;
global Dataset;
global Datasetnames;
set(hpanelsingle,'Units','pixels')
pixelPOS = get(hpanelsingle,'Position');
set(hpanelsingle,'Units','normalized')

%% making gui visible
set(f,'Visible','on');
set(f,'uicontextmenu',hsavecontext);

%placing gui to the top center of the screen
movegui(f,'north');

%making a colormap that will highlight the highest color in red (useful for
%when OD goes over the linear range
graycmap = colormap('gray');
graycmap = [graycmap; 0.9,0.3,0.3];

%////////////////////////////////////////////////////////////////////
%end of initial component/GUI construction



%% Programming Callbacks
%======================================================================

%hload callback
    function hload_callback(~,~)
        filedirs = uipickfiles; %calls up gui to pick multiple directories
        %global numdirs
        numdirs = length(filedirs);
        folders = cell(1,numdirs); %preallocating folders cell array
        dirtype = cell(1,numdirs); %preallocating
        displaydirs = cell(1,numdirs);
        for i = 1:numdirs %looping through each selected directory
            [folderpath,foldername,~] = fileparts(filedirs{i}); %only picking the foldernames for brevity
            [folderpath_up1,foldername_up1,~] = fileparts(folderpath);
            [~,foldername_up2,~] = fileparts(folderpath_up1);
            
            folders{i} = foldername; %making list of directory names
			
			if ispc()
				tempfiledir = strcat(filedirs{i},'\');
				fullfolders{i} = [foldername_up2,' \ ',foldername_up1,' \ ',foldername];
			elseif ismac()
				tempfiledir = strcat(filedirs{i},'/');
				fullfolders{i} = [foldername_up2,' / ',foldername_up1,' / ',foldername];
			end

            cd(tempfiledir); %moving to each directory
            tempfilenames = ls; %listing out file names
            cnt = 0;
            for j = 1:size(tempfilenames,1) %looping through each file name and counting .hdr files
                if any(strfind(tempfilenames(j,:),'.hdr'))==1
                    cnt = cnt + 1;
                    if cnt == 2
                        dirtype{i} = 'map  '; %if 2 or more .hdr files are in one dir, it's a map
                        break
                    end
                end
            end
            if cnt == 1
                dirtype{i} = 'stack'; %if only 1 .hdr file is present, it is a stack
            end
            displaydirs{i} = [dirtype{i},' ',fullfolders{i}];
        end
        set(hlistready,'String',displaydirs);
        set(hanalyze,'Enable','on');
        set(hremove,'Enable','on');
    end


%% hremove callback
%hremove button moves data from "ready list" to "load list" This is EXACTLY
%the same as hadd with the listbox 'String' and 'Values' switched
    function hremove_callback(~,~)
        readylistvalue = get(hlistready,'Value');
        readyliststring = get(hlistready,'String');
        readyliststring(readylistvalue) = [];
        set(hlistready,'String',readyliststring,'Value',1);
        
        if isempty(readyliststring)
            set(hremove,'Enable','off');
            set(hanalyze,'Enable','off');
        end
        
    end

%% hradiomultiple callback
    function hradiomultiple_callback(~,~)
        set(hradiomultiple,'Value',1)
        set(hradiosingle,'Value',0)
        set(hright,'Visible','off')
        set(hleft,'Visible','off')
        hselect_callback()
        
    end

%% hradiosingle callback
    function hradiosingle_callback(~,~)
        set(hradiosingle,'Value',1)
        set(hradiomultiple,'Value',0)
        set(hright,'Visible','on')
        set(hleft,'Visible','on')
        hselect_callback()
        
    end

%% hsort runs stxmsort on a single directory containing all stxm files
%pertaining to a single experiment
    function hsort_callback(~,~)
        stxmsort();
	end

%% hdatamerge runs the data merge routine, useful for when C and N data (for example) were taken as separate stacks/maps
	function hmerge_callback(~,~)
		MergingRawSTXMData();
	end

%% hanalyze runs analysis scripts
    function hanalyze_callback(~,~)
        tic
        readydirs = get(hlistready,'String'); %get directory strings from leftmost (ready) list
        readylistval = get(hlistready,'Value');
        usesaveflag = get(husesaved,'Value');
        usesavedqcflag = get(hqcsaved,'Value');
        %         dirstorun = get(hlistready,'String');
        lreadydirs = length(readydirs);
        foldernames = cell(lreadydirs,1); %preallocation
        dirstorun = cell(lreadydirs,1); %preallocation
        %global filedirs
        filedirs = filedirs'; %this makes it nx1 which is not necessary but makes it easier to work with
        lfiledirs = length(filedirs);
		
		inorganiclist = get(hassumedinorgpopup,'String');
		inorganicval = get(hassumedinorgpopup,'Value');
		inorganic = inorganiclist{inorganicval};
		organiclist = get(hassumedorgpopup,'String');
		organicval = get(hassumedorgpopup,'Value');
		organic = organiclist{organicval};
        
        for i = 1:lreadydirs
			if ispc()
				separationidx = strfind(readydirs{i},' \ ');
			elseif ismac()
				separationidx = strfind(readydirs{i},' / ');
			end
            for q = length(separationidx):-1:1 %backwards loop
                readydirs{i}(separationidx(q)+2) = [];
                readydirs{i}(separationidx(q)) = [];                
            end
            foldernames{i} = readydirs{i}(7:end); %this removes either the 'map' or 'stack' which was prepended to the folder name and the added spaces
            for j = 1:lfiledirs
                if any(strfind(filedirs{j},foldernames{i}))
                    dirstorun{i} = filedirs{j}; %this loop finds each foldername somewhere in the full path name and builds a new cell of full paths in the appropriate (previously selected) order
                end
            end
        end
        %slashcell = cell(length(dirstorun),1); %building a cell array
        %[slashcell{1:end}] = deal('\'); %this adds '\' to each cell
        %dirstorunslash = cellfun(@strcat,dirstorun,slashcell,'UniformOutput',0); %this concatenates the full path with an added slash so that the cd command works
        
        loadobj = findobj('Tag','Load');
        set(loadobj(:),'Visible','off');
        
%         set(hload,'Visible','off')
%         set(hanalyze,'Visible','off')
        set(hroutinepopup,'Value',2)
        set(hradiosingle,'Visible','on')
        set(hradiomultiple,'Visible','on')
        set(hpopupimages,'Visible','on');%,'Value',1)
        
%         set(hsort,'Visible','off')
        
        
        
        if usesaveflag == 1
			
						
            if any(exist('sillystring','file'))
                hwait = waitbar(0,sillystring);
            else
                hwait = waitbar(0,'plz w8');
            end

            
            
			for j = 1:length(dirstorun)
                cd(dirstorun{j});
                currdir = dir;
                for c = 1:length(currdir)
                    hdridx = strfind(currdir(c).name,'.hdr');
                    if ~isempty(hdridx)
                        fovname{j} = currdir(c).name(1:hdridx-1);
                        break
                    end
                end
                
                cd('..');
                
                try 
                    mapstest = load(['F',fovname{j}],'mapstest');
                catch
                    mapstest = struct([]);
                end
                
                if isempty(fieldnames(mapstest))   %Either old CarbonMaps was ran or nothing was
                    %[Dataset] = MixingStatesforGUI(dirstorun(j));
                    usesaveflag = 0;
                    continue
                else                                %Updated CarbonMaps has been run on Jth sample
					
					try
						tempdataset = load(['F',fovname{j}]);
						[~,tempfov] = fileparts(dirstorun{j});
						currfov = ['FOV',tempfov];
						Dataset.(currfov).S = tempdataset.S;
						Dataset.(currfov).Snew = tempdataset.Snew;
						Dataset.(currfov).Mixing = tempdataset.Mixing;
						Dataset.(currfov).Particles = tempdataset.Particles;
						Dataset.(currfov).Directory = tempdataset.datafolder;
					catch
						displaydirs = get(hlistready,'String');
						currdisplaydir = displaydirs{j};
						currdisplaydir = [currdisplaydir, 'ERROR'];
						displaydirs{j} = currdisplaydir;
						set(hlistready,'String',displaydirs);
						continue
					end
                    
                    try 
                        Dataset.(currfov).binadjtest = tempdataset.binadjtest; 
                    catch
                        Dataset.(currfov).binadjtest = 0;
                    end
                    
                    try
                        Dataset.(currfov).threshlevel = tempdataset.threshlevel;
                    catch
						Dataset.(currfov).threshlevel = 2;
					end
					
					try
						Dataset.(currfov).savedbinmap = tempdataset.savedbinmap;
					catch
						Dataset.(currfov).savedbinmap = 0;
					end
					
					try
						Dataset.(currfov).inorganic = tempdataset.inorganic;
					catch
						Dataset.(currfov).inorganic = 'NaCl';
					end
					
					try
						Dataset.(currfov).organic = tempdataset.organic;
					catch
						Dataset.(currfov).organic = 'Sucrose';
					end
					
					
				end
				waitbar(j/length(dirstorun));
				
			end
            close(hwait);
            %load stuff
            %check for mapstest
            %use or rerun
%             load()

        elseif usesavedqcflag == 1
            if any(exist('sillystring','file'))
                hwait = waitbar(0,sillystring);
            else
                hwait = waitbar(0,'plz w8');
            end
            
            for j = 1:length(dirstorun)
                cd(dirstorun{j});
                currdir = dir;
                for c = 1:length(currdir)
                    hdridx = strfind(currdir(c).name,'.hdr');
                    if ~isempty(hdridx)
                        fovname{j} = currdir(c).name(1:hdridx-1);
                        break
                    end
                end
                
                cd('..');
                
                try 
                    mapstest = load(['F',fovname{j}],'mapstest');
                catch
                    mapstest = struct([]);
                end
                
                try 
                    threshlevel = load(['F',fovname{j}],'threshlevel');
                    threshfieldnames = fieldnames(threshlevel);
                    if isempty(threshfieldnames)
                        threshlevel = 2;
                    else
                        threshlevel = threshlevel.(threshfieldnames{1});
                    end
                catch
                    threshlevel = 2;
                end
                
                try
                    binadjtest = load(['F',fovname{j}],'binadjtest');
                    binfieldnames = fieldnames(binadjtest);
                    if isempty(binfieldnames)
                        binadjtest = 0;
                    else
                        binadjtest = binadjtest.(binfieldnames{1});
                    end
                catch
                    binadjtest = 0;
                end
                
                try
                    savedbinmap = load(['F',fovname{j}],'savedbinmap');
                    savedbinmapfieldnames = fieldnames(savedbinmap);
                    if isempty(savedbinmapfieldnames)
                        savedbinmap = 0;
                    else
                        savedbinmap = savedbinmap.(savedbinmapfieldnames{1});
                    end
                catch
                    savedbinmap = 0;
                end
                
                
                if isempty(fieldnames(mapstest))   %Either old CarbonMaps was ran or nothing was
                    %[Dataset] = MixingStatesforGUI(dirstorun(j));
                    usesavedqcflag = 0;
                    break
                else                                %Updated CarbonMaps has been run on Jth sample
                    [Dataset] = MixingStatesforGUI(dirstorun(j), threshlevel, binadjtest, savedbinmap);
                    %tempdataset = load(['F',fovname{j}]);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %[~,tempfov] = fileparts(dirstorun{j});
                    %currfov = ['FOV',tempfov];
                    %Dataset.(currfov).S = tempdataset.S;
                    %Dataset.(currfov).Snew = tempdataset.Snew;
                    %Dataset.(currfov).Mixing = tempdataset.Mixing;
                    %Dataset.(currfov).Particles = tempdataset.Particles;
                    %Dataset.(currfov).Directory = tempdataset.datafolder;
                       
                end
                    waitbar(j/length(dirstorun));

            end
            close(hwait);
		end
        
		if usesaveflag == 0 && usesavedqcflag == 0
			[Dataset] = MixingStatesforGUI(dirstorun,2,0,0,inorganic,organic);
		end
        
        Datasetnames = fieldnames(Dataset);
        
       
        set(hplottitle,'String',(Datasetnames{1}))
        set(hpanelmultiple,'Visible','on');

        set(hstacklabtitle,'String',(Datasetnames{1}));
        set(hlistready,'Max',1,'Value',readylistval(1));
        
        dataviewerobj = findobj('Tag','DataViewer');
        set(dataviewerobj,'Visible','on');
        set(hleft,'Visible','off');
        set(hright,'Visible','off');
        
        
        currSnew = Dataset.(Datasetnames{1}).Snew;
        currelements= fieldnames(currSnew.elements);
        cnt = 0;
        for i = 1:length(heleboxlist)
            if currSnew.elements.(currelements{i}) == 1
                set(heleboxlist{i},'Value',1);
                cnt = cnt + 1;
            end
            
            if cnt == 4
                break
            end
        end
        
        hselect_callback();
        set(husesaved,'Value',1);
        analyzeruntest = 1;
        toc
    end

%% hselect dropdown menu
    function hselect_callback(~,~)
        routineval = get(hroutinepopup,'Value');
        routinestr = get(hroutinepopup,'String');
        ODlimitval = get(hODlimitcheck,'Value');
        
        
        %%%%
        %%%% Determining what to do depending on current routine
        %%%%
        switch routinestr{routineval}
            
            %%%%
            %%%% This routine looks at the data processed normally
            %%%%
            case 'Data Viewer'
                
                popupimagestr = get(hpopupimages,'String');
                popupimageval = get(hpopupimages,'Value');
                readyvalue = get(hlistready,'Value');
                
                radiosingleval = get(hradiosingle,'Value');
                radiomultipleval = get(hradiomultiple,'Value');
                
                energy= Dataset.(Datasetnames{readyvalue}).Snew.eVenergy;
                Xvalue = Dataset.(Datasetnames{readyvalue}).Snew.Xvalue;
                Yvalue = Dataset.(Datasetnames{readyvalue}).Snew.Yvalue;
                xAxislabel = [0,Dataset.(Datasetnames{readyvalue}).Snew.Xvalue];
                yAxislabel = [0,Dataset.(Datasetnames{readyvalue}).Snew.Yvalue];
                Izero = Dataset.(Datasetnames{readyvalue}).Snew.Izero;
                Sspectr = Dataset.(Datasetnames{readyvalue}).Snew.spectr;
                
                for i = 1:length(energy)
                    stack(:,:,i) = Izero(i,2).*exp(-Sspectr(:,:,i)); %retreiving raw intensity information from OD info
                end
                
                Mask = Dataset.(Datasetnames{readyvalue}).Snew.mask;
                binmap = ~Dataset.(Datasetnames{readyvalue}).Snew.binmap;
                imagebuffer=mean(stack,3);
                RgbMat = Dataset.(Datasetnames{readyvalue}).Snew.RGBCompMap;
                carb = Dataset.(Datasetnames{readyvalue}).Snew.Maps(:,:,1);
                prepost = Dataset.(Datasetnames{readyvalue}).Snew.Maps(:,:,2);
                sp2 = Dataset.(Datasetnames{readyvalue}).Snew.Maps(:,:,3);
                LabelMat = Dataset.(Datasetnames{readyvalue}).Snew.LabelMat;
                spThresh = 0.35;
                MatSiz=size(LabelMat);
                XSiz=Xvalue/MatSiz(1);
                YSiz=Yvalue/MatSiz(2);
                xdat=(0:XSiz:Xvalue);
                ydat=(0:YSiz:Yvalue);
                set(hplottitle,'String',Datasetnames{readyvalue});
                
                switch popupimagestr{popupimageval}
                    case 'Prepost Images'
                        set(helementpanel,'Visible','on');
                        set(rawbg,'Visible','off');
                        
                        hprepost_callback();
                        
                        
                    case 'Raw Images'
                        set(helementpanel,'Visible','off');
                        set(rawbg,'Visible','on');
                        
                        
                        readyvalue = get(hlistready,'Value');
                        currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
                        currelements= fieldnames(currSnew.elements);
                        
                        %Making only buttons which have elemental data visible
                        flag = 0;
                        for i = 1:length(heleradlist)
                            if currSnew.elements.(currelements{i}) == 1
                                set(heleradlist{i},'Visible','on');
                                flag = flag + 1;
                                if flag == 1
                                    firstnonzeroele = i;
                                end
                            else
                                set(heleradlist{i},'Visible','off');
                            end
                        end
                        
                        %this bit sets carbon as the default value unless
                        %it isn't present, then it just finds the first
                        %element present and makes that default
                        if currSnew.elements.C == 1
                            set(hCarbonrad,'Value',1);
                        else
                            set(heleradlist{firstnonzeroele},'Value',1);
                        end
                        
                        rawbg_callback();
                        
                    case 'Organic Vol. Fractions'
                        set(helementpanel,'Visible','off');
                        set(rawbg,'Visible','off');
                        readyvalue = get(hlistready,'Value');
                        currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
                        radiomultipleval = get(hradiomultiple,'Value');
                        radiosingleval = get(hradiosingle,'Value');
                        
                        energy = currSnew.eVenergy;
                        Xvalue = Dataset.(Datasetnames{readyvalue}).Snew.Xvalue;
                        Yvalue = Dataset.(Datasetnames{readyvalue}).Snew.Yvalue;
                        Sspectr = Dataset.(Datasetnames{readyvalue}).Snew.spectr;
                        
                        
                        
                        [~,rawidx(1)] = min(abs(energy - 278));
                        [~,rawidx(2)] = min(abs(energy - 320));
                        
                        
                        if radiomultipleval == 1
                            set(hpanelsingle,'Visible','off');
                            set(hpanelmultiple,'Visible','on');
                            oldmultiplot = findobj('Parent',hpanelmultiple);
                            delete(oldmultiplot);
                            
                            
                            for i = 1:2
                                handle{i} = subplot(2,2,i);
                                imagesc([0,Xvalue],[0,Yvalue],Sspectr(:,:,rawidx(i)))
                                %             set(gca,'Clim',[0,1.5]),
                                axis image
                                xlabel('X (\mum)');
                                ylabel('Y (\mum)');
                                if ODlimitval == 1
                                    colormap(handle{i},graycmap);
                                    caxis([0,1.6]);
                                else
                                    colormap(handle{i},gray);
                                end
                                plottitle=sprintf('%geV',energy(rawidx(i)));
                                title(plottitle);
                                set((handle{i}),'Parent',hpanelmultiple);
                                cbar{i} = colorbar;
                            end
                            
                            handle{3} = subplot(2,2,3);
                            imagesc([0,Xvalue],[0,Yvalue],currSnew.ThickMap(:,:,end));
                            axis image
                            xlabel('X (\mum)');
                            ylabel('Y (\mum)');
                            colormap(handle{3},parula)
                            title('Organic Vol Frac');
                            set(handle{3},'Parent',hpanelmultiple);
                            cbar{3} = colorbar;
                            
                            handle{4} =  subplot(2,2,4);
                            volfracdist = max(currSnew.VolFrac) - min(currSnew.VolFrac);
                            %nhistbins = round(volfracdist./0.05);
                            histogram(currSnew.VolFrac,[0:0.05:1]);
                            xlabel('Org Vol Frac');
                            ylabel('Particle #');
                            set(handle{4},'Parent',hpanelmultiple,'XLim',[0,1]);
                            
                        elseif radiosingleval == 1
                        end
                        
                        
                    case 'ODStack Images'
                        set(helementpanel,'Visible','off');
                        set(rawbg,'Visible','off');
                        
                        if radiomultipleval == 1
                            set(hpanelsingle,'Visible','off')
                            set(hpanelmultiple,'Visible','on')
                            oldmultiplot = findobj('Parent',hpanelmultiple);
                            delete(oldmultiplot);
                            
                            handle1 = subplot(2,2,1);
                            imagesc(xAxislabel,yAxislabel,imagebuffer);
                            set(handle1,'Parent',hpanelmultiple);
                            axis image
                            colorbar
                            title('Raw Intensity Stack Mean')
                            colormap gray
                            xlabel('X-Position (?m)','FontSize',11,'FontWeight','normal')
                            ylabel('Y-Position (?m)','FontSize',11,'FontWeight','normal')
                            
                            handle2 = subplot(2,2,2);
                            imagesc(xAxislabel,yAxislabel,mean(Sspectr,3));
                            set(handle2,'Parent',hpanelmultiple);
                            axis image
                            colorbar
                            if ODlimitval == 1
                                colormap(handle2,graycmap);
                                caxis(handle2,[0,1.6]);
                            else
                                colormap(gray);
                            end
                            title('Optical Density Stack Mean')
                            xlabel('X-Position (?m)','FontSize',11,'FontWeight','normal')
                            ylabel('Y-Position (?m)','FontSize',11,'FontWeight','normal')
                            
                            
                            handle3 = subplot(2,2,3);
                            imagesc(xAxislabel,yAxislabel,Mask);
                            set(handle3,'Parent',hpanelmultiple);
                            colorbar
                            axis image
                            title('Izero Region Mask')
                            xlabel('X-Position (?m)','FontSize',11,'FontWeight','normal')
                            ylabel('Y-Position (?m)','FontSize',11,'FontWeight','normal')
                            
                            handle4 = subplot(2,2,4);
                            imagesc(xAxislabel,yAxislabel,binmap);
                            set(handle4,'Parent',hpanelmultiple);
                            colorbar
                            axis image
                            title('Visualization Binmap');
                            xlabel('X-Position (?m)','FontSize',11,'FontWeight','normal')
                            ylabel('Y-Position (?m)','FontSize',11,'FontWeight','normal')

                            
                        elseif radiosingleval == 1
                            set(hpanelmultiple,'Visible','off')
                            set(hpanelsingle,'Visible','on')
                            delete(gca);
                            
                            axes(...
                                'Units','normalized',...
                                'Position',[0.07,0.06,0.9,0.9],...
                                'Parent',hpanelsingle,...
                                'Tag','haxes',...
                                'HandleVisibility','on');
                            
                            switch imageselectionvalue
                                case 1
                                    imagesc(xAxislabel,yAxislabel,imagebuffer);
                                    axis image
                                    colorbar
                                    title('Raw Intensity Stack Mean')
                                    colormap gray
                                    xlabel('X-Position (?m)','FontSize',11,'FontWeight','normal')
                                    ylabel('Y-Position (?m)','FontSize',11,'FontWeight','normal')
                                case 2
                                    imagesc(xAxislabel,yAxislabel,mean(Sspectr,3));
                                    axis image
                                    colorbar
                                    if ODlimitval == 1
                                        colormap(graycmap);
                                        caxis([0,1.6]);
                                    else
                                        colormap(gray);
                                    end
                                    title('Optical Density Stack Mean')
                                    xlabel('X-Position (?m)','FontSize',11,'FontWeight','normal')
                                    ylabel('Y-Position (?m)','FontSize',11,'FontWeight','normal')
                                case 3
                                    imagesc(xAxislabel,yAxislabel,Mask);
                                    colorbar
                                    axis image
                                    title('Izero Region Mask')
                                    xlabel('X-Position (?m)','FontSize',11,'FontWeight','normal')
                                    ylabel('Y-Position (?m)','FontSize',11,'FontWeight','normal')
                                case 4
                                    plot(Izero(:,1),Izero(:,2));
                                    title('Izero')
                                    xlabel('Photon energy (eV)','FontSize',11,'FontWeight','normal')
                                    ylabel('Raw Counts','FontSize',11,'FontWeight','normal')
                            end
                            
                        end
                        
                    case 'CarbonMaps Images'
                        set(helementpanel,'Visible','off');
                        set(rawbg,'Visible','off');
                        
                        if radiomultipleval == 1
                            
                            handle1 = subplot(2,2,1);
                            imagesc([0, Xvalue],[0,Yvalue],carb);
                            set(handle1,'Parent',hpanelmultiple);
                            colormap gray
                            colorbar
                            axis image
                            title('PostEdge-PreEdge');
                            xlabel('X (\mum)');
                            ylabel('Y (\mum)');
                            
                            handle2 = subplot(2,2,2);
                            imagesc([0,Xvalue],[0,Yvalue],prepost);
                            set(handle2,'Parent',hpanelmultiple);
                            colormap gray
                            colorbar
                            axis image
                            set(gca,'Clim',[0,1.0])
                            xlabel('X (\mum)');
                            ylabel('Y (\mum)');
                            title('PreEdge/PostEdge');
                            
                            handle3 = subplot(2,2,3);
                            imagesc([0,Xvalue],[0,Yvalue],sp2);
                            set(handle3,'Parent',hpanelmultiple);
                            colormap gray
                            set(gca,'Clim',[0,1.0])
                            axis image
                            xlabel('X (\mum)');
                            ylabel('Y (\mum)');
                            colorbar
                            title('%sp^{2} Map')
                            
                            handle4 = subplot(2,2,4);
                            image(xdat,ydat,uint8(RgbMat));
                            title(sprintf('Red=sp2>%g%,Blue=pre/post>0.5,green=Organic',spThresh));
                            set(handle4,'Parent',hpanelmultiple);
                            axis image
                            xlabel('X (\mum)');
                            ylabel('Y (\mum)');
                            
                        elseif radiosingleval == 1
                            set(hpanelmultiple,'Visible','off')
                            set(hpanelsingle,'Visible','on')
                            delete(gca);
                            
                            
                            axes(...
                                'Units','normalized',...
                                'Position',[0.07,0.06,0.9,0.9],...
                                'Parent',hpanelsingle,...
                                'Tag','haxes',...
                                'HandleVisibility','on');
                            
                            switch imageselectionvalue
                                case 1
                                    imagesc([0, Xvalue],[0,Yvalue],carb);
                                    colormap gray
                                    colorbar
                                    axis image
                                    title('PostEdge-PreEdge');
                                    xlabel('X (\mum)');
                                    ylabel('Y (\mum)');
                                    
                                case 2
                                    imagesc([0,Xvalue],[0,Yvalue],prepost);
                                    colormap gray
                                    colorbar
                                    axis image
                                    set(gca,'Clim',[0,1.0])
                                    xlabel('X (\mum)');
                                    ylabel('Y (\mum)');
                                    title('PreEdge/PostEdge');
                                case 3
                                    imagesc([0,Xvalue],[0,Yvalue],sp2);
                                    colormap gray
                                    set(gca,'Clim',[0,1.0])
                                    axis image
                                    xlabel('X (\mum)');
                                    ylabel('Y (\mum)');
                                    colorbar
                                    title('%sp^{2} Map')
                                case 4
                                    image(xdat,ydat,uint8(RgbMat));
                                    title(sprintf('Red=sp2>%g%,Blue=pre/post>0.5,green=Organic',spThresh));
                                    axis image
                                    xlabel('X (\mum)');
                                    ylabel('Y (\mum)');
                            end
                        end
                        
                    case 'Alignment'
                        set(hradiosingle,'Value',1);
                        set(hradiomultiple,'Value',0);
                        set(hpanelmultiple,'Visible','off')
                        set(hpanelsingle,'Visible','on')
                        readyvalue = get(hlistready,'Value');
                        currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
                        energy = currSnew.eVenergy;
                        [~,preidx] = min(abs(energy - 278));
                        [~,postidx] = min(abs(energy - 320));
                        delete(gca);
                        axes(...
                            'Units','normalized',...
                            'Position',[0.07,0.06,0.9,0.9],...
                            'Parent',hpanelsingle,...
                            'Tag','haxes',...
                            'HandleVisibility','on');
                        imshowpair(currSnew.spectr(:,:,preidx),currSnew.spectr(:,:,postidx)); %this will display a false color imshowpair
						
					case 'Size Distribution'
						set(hpanelmultiple,'Visible','off');
						set(hpanelsingle,'Visible','on');
						readyvalue = get(hlistready,'Value');
						currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
						
						delete(gca);
						axes(...
							'Units','normalize',...
							'Position',[0.07,0.06,0.9,0.9],...
                            'Parent',hpanelsingle,...
                            'Tag','haxes',...
                            'HandleVisibility','on');
						histogram(Snew.Size,[0:0.1:(max(Snew.Size)+0.1)]);
                        
                end
                
            case 'EDXmapview'  %%%%%Unfinished%%%%
                currentdirpath = Dataset.(Datasetnames{readyval}).Directory;
                cd(currentdirpath);
                [~,currfolder,~] = fileparts(currentdirpath);
                EDXdatafile = sprintf('%s',currfolder,'.mat');
                load(EDXdatafile);
                
                
        end
    end

%% hright adds 1 to imageselectionvalue
    function hright_callback(~,~)
        %global imageselectionvalue
        if imageselectionvalue < 4
            imageselectionvalue = imageselectionvalue + 1;
        end
        hselect_callback();
    end

%% hleft subtracts 1 to imageselectionvalue
    function hleft_callback(~,~)
        %global imageselectionvalue
        if imageselectionvalue > 1
            imageselectionvalue = imageselectionvalue - 1;
        end
        hselect_callback();
    end

%% hroutinepopupmenu switches routine callback
    function hroutinepopup_callback(source,~)
        str = get(source,'String');
        val = get(source,'Value');
        %change routine depending on selection
        radiosinglevalue = get(hradiosingle,'Value');
        radiomultiplevalue = get(hradiomultiple,'Value');
        switch str{val}
            case 'Load & Run Data'
                
                hnotloadstuff = findobj('Tag','DataViewer','-or','Tag','StackLab','-or','Tag','QC');
                set(hnotloadstuff,'Visible','off');
                
                hloadstuff = findobj('Tag','Load');
                set(hloadstuff,'Visible','on');
                

                set(hpanelsingle,'Visible','off')
                set(hpanelmultiple,'Visible','off')
                set(hlistready,'Visible','on','Max',100) %moving listready to right side AND allowing multiple selctions for use with "remove" button
                set(hreadytitle,'Visible','on')
               
            case 'Data Viewer'
                
                hnotDataViewer= findobj('Tag','Load','-or','Tag','StackLab','-or','Tag','QC');
                set(hnotDataViewer,'Visible','off');
                
                hDataViewer = findobj('Tag','DataViewer');
                set(hDataViewer,'Visible','on');

                if radiosinglevalue == 1
                    set(hpanelsingle,'Visible','on')
                    set(hright,'Visible','on')
                    set(hleft,'Visible','on')
                elseif radiomultiplevalue == 1
                    set(hpanelmultiple,'Visible','on')
                    set(hright,'Visible','off')
                    set(hleft,'Visible','off')
                end
                set(hpopupimages,'Value',1)
%                 set(hradiosingle,'Visible','on')
%                 set(hradiomultiple,'Visible','on')
                set(hlistready,'Max',1) %moving listready to left side AND limiting one selection for dataviewer
                
                
            case 'StackLab'
                %runstacklab
                hnotStackLab= findobj('Tag','Load','-or','Tag','DataViewer','-or','Tag','QC');
                set(hnotStackLab,'Visible','off');
                
                hStackLab = findobj('Tag','StackLab');
                set(hStackLab,'Visible','on');

                
                set(hpanelsingle,'Visible','off')
                set(hpanelmultiple,'Visible','off')

                
                
            case 'EDXmapview'
                %run EDXmap viewer
                
                set(hpanelmultiple,'Visible','on')
                set(hplottitle,'Visible','on')
                set(hright,'Visible','off')
                set(hleft,'Visible','off')
                set(hpopupimages,'Visible','off')
                set(hradiosingle,'Visible','off')
                set(hradiomultiple,'Visible','off')
                set(hload,'Visible','off')
                set(hanalyze,'Visible','off')
                set(hsort,'Visible','off')
                set(hROI,'Visible','off');
                set(hReset,'Visible','off');
                set(hEnergyA,'Visible','off');
                set(hEnergyB,'Visible','off');
                set(hSubtract,'Visible','off');
                set(hsavespectxt,'Visible','off');
                set(hsavespecfig,'Visible','off');
                set(hsavestackfig,'Visible','off');
                set(hpanelstacklab,'Visible','off');
                set(hstacklabtitle,'Visible','off');
				
			case 'Multiple FOVs'
				set(hpopupimages,'Visible','off');
				set(hmultidistfxn,'Visible','on');
				set(hpanelmultiple,'Visible','off');
				set(hpanelsingle,'Visible','on');
 				set(hlistready,'Value',100)
                
        end
    end

%% keypressfcnfigure arrow key functions
    function figkeypress_callback(source,~)
        KEY = get(source,'CurrentKey');
        radiosingleval = get(hradiosingle,'Value');
        listreadyval = get(hlistready,'Value');
        listreadystr = get(hlistready,'String');
        listreadynum = length(listreadystr);
        
        popupval = get(hroutinepopup,'Value');
        popupstr = get(hroutinepopup,'String');
        
        if strcmp(popupstr{popupval},'Data Viewer')
            
            if strcmp(KEY,'downarrow')
                if listreadyval < listreadynum
                    listreadyval = listreadyval + 1;
                    set(hlistready,'Value',listreadyval);
                    hselect_callback()
                end
            elseif strcmp(KEY,'uparrow')
                if listreadyval > 1
                    listreadyval = listreadyval - 1;
                    set(hlistready,'Value',listreadyval);
                    hselect_callback()
                end
            end
            
            
            if radiosingleval == 1
                if strcmp(KEY,'leftarrow')
                    hleft_callback();
                elseif strcmp(KEY,'rightarrow')
                    hright_callback();
                end
            end
        end
    end

%% listready callback
    function hlistready_callback(~,~)
        popupval = get(hroutinepopup,'Value');
        popupstr = get(hroutinepopup,'String');
        
        if strcmp(popupstr{popupval},'Data Viewer') || strcmp(popupstr{popupval},'EDXmapview')
            hselect_callback()
            %         get(hlistready,'Value');
            %             key = event.Key;
            %             if strcmp(key,'leftarrow')% == 30
            %                 hleft_callback();
            %             elseif strcmp(key,'rightarrow') %== 31
            %                 hright_callback();
            %             end
        end
        
        
        
        
        
    end

%% listreadykey callback
    function hlistreadykey_callback(~,event)
        popupval = get(hroutinepopup,'Value');
        popupstr = get(hroutinepopup,'String');
        
        if strcmp(popupstr{popupval},'Data Viewer')
            key = event.Key;
            if strcmp(key,'leftarrow')% == 30
                hleft_callback();
            elseif strcmp(key,'rightarrow') %== 31
                hright_callback();
            end
        end
    end

%% radiobutton callback
    function hradio_callback(~,event)
        popupval = get(hroutinepopup,'Value');
        popupstr = get(hroutinepopup,'String');
        listreadyval = get(hlistready,'Value');
        listreadystr = get(hlistready,'String');
        listreadynum = length(listreadystr);
        radiosingleval = get(hradiosingle,'Value');
        
        
        
        if strcmp(popupstr{popupval},'Data Viewer')
            key = event.Key;
            
            if strcmp(key,'downarrow')
                if listreadyval < listreadynum
                    listreadyval = listreadyval + 1;
                    set(hlistready,'Value',listreadyval);
                    hselect_callback()
                end
            elseif strcmp(key,'uparrow')
                if listreadyval > 1
                    listreadyval = listreadyval - 1;
                    set(hlistready,'Value',listreadyval);
                    hselect_callback()
                end
            end
            
            if radiosingleval == 1
                if strcmp(key,'leftarrow')% == 30
                    hleft_callback();
                elseif strcmp(key,'rightarrow') %== 31
                    hright_callback();
                end
            end
        end
    end

%% contextmenu callback
    function context_callback(source,~)
        popupval = get(hroutinepopup,'Value');
        popupstr = get(hroutinepopup,'String');
        switch popupstr{popupval};
            case 'Data Viewer'
                labelstr = get(source,'Label');
                %         set(hsavecontext,'Visible','on');
                readyval = get(hlistready,'Value');
                currentdirpath = Dataset.(Datasetnames{readyval}).Directory;
                currentdirname = Datasetnames{readyval};
                cd(currentdirpath);
                files = ls;
                cnt = 1;
                for i = 1:size(files,1)
                    [~,~,fileext] = fileparts(strtrim(files(i,:)));
                    if strcmp(fileext,'.png') == 1
                        cnt = cnt + 1;
                    end
                end
                cntstr = num2str(cnt);
                picturename = sprintf('%s',currentdirname,'_',cntstr,'.png');
                set(f,'Units','pixels')
                switch labelstr
                    case 'Save plot window'
                        set(hpanelsingle,'Units','pixels');
                        picwindow = get(hpanelsingle,'Position');
                        set(hpanelsingle,'Units','normalized');
                        picframe = getframe(f,picwindow);
                        im = frame2im(picframe);
                        imwrite(im,picturename,'png')
                end
                set(f,'Units','normalized')
                
            case 'StackLab'
        end
        
    end

%% run stacklab button
    function hstacklabbutton_callback(~,~)
        readyvalue = get(hlistready,'Value');
        currSnew = Dataset.(Datasetnames{readyvalue}).Snew ;
        STACKLab(currSnew)
    end


%% run total sphericity
    function hsphericitybutton_callback(~,~)
        readyvalue = get(hlistready,'Value');
        currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
        Snew = TotalSphericity(currSnew);
        
        SphericityMap = zeros(size(Snew.LabelMat));
        
        for k = 1:max(max(Snew.LabelMat))
            SphericityMap(Snew.LabelMat == k) = Snew.ParticleSphericity(k);
        end
        
        asoptest = zeros(size(Snew.LabelMat));
        asoptest(SphericityMap >= 0.8) = 1;
        smallsphericityidx = SphericityMap > 0 & SphericityMap < 0.8;
        asoptest(smallsphericityidx) = 0.1;
        
        sphericityfig = figure;
        set(sphericityfig,'Units','normalized','Position',[0.15,0.15,0.6,0.5]);
        axh = tight_subplot(1,2,[0.01,0.02],[0.01,0.05],[0.01,0.01]);
        
        axes(axh(1));
        imagesc(SphericityMap,[0,1]);
        % colorbar;
        title('Particle Sphericity');
        
        axes(axh(2));
        % subplot(1,2,2)
        imagesc(asoptest,[0,1]);
        colorbar;
        title('Yellow means > 0.8 sphericity');
        
        for j = 1:2
            set(axh(j),'XTick',[],'YTick',[]);
        end
        
    end


%% export current data to workspace
    function hdataexport_callback(~,~)
        readyvalue = get(hlistready,'Value');
        currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
        currS = Dataset.(Datasetnames{readyvalue}).S;
        assignin('base','Snew',currSnew);
        assignin('base','S',currS);
		
		try
			CMixing = Dataset.(Datasetnames{readyvalue}).CMixing;
			CParticles = Dataset.(Datasetnames{readyvalue}).CParticles;
			assignin('base','Mixing',CMixing);
			assignin('base','Particles',CParticles);
		catch
		
		end
        
	end


%% Run Beers Law Test on Selected
	function hBeersTest_callback(~,~)
		readyvalue = get(hlistready,'Value');
		TestingBeersLaw(Dataset.(Datasetnames{readyvalue}).Snew);
		
		
		
	end

%% prepost maps
    function hprepost_callback(~,~)
       
        
        Sval = get(hSulfurbox,'Value');
        Cval = get(hCarbonbox,'Value');
        Kval = get(hPotassiumbox,'Value');
        Caval = get(hCalciumbox,'Value');
        Nval = get(hNitrogenbox,'Value');
        Oval = get(hOxygenbox,'Value');
        
        radiosingleval = get(hradiosingle,'Value');
        radiomultipleval = get(hradiomultiple,'Value');
        
        
        readyvalue = get(hlistready,'Value');
        currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
        currelements= fieldnames(currSnew.elements);
        
        eleflagvec = [Sval;Cval;Kval;Caval;Nval;Oval];
        totelefield = {'totS','TotC','totK','totCa','totN','totO'};
        
        elenum = Sval + Cval + Kval + Caval + Nval + Oval;
        
        %Making only boxes which have elemental data visible
        for i = 1:length(heleboxlist);
            if currSnew.elements.(currelements{i}) == 1;
                set(heleboxlist{i},'Visible','on');
            else
                set(heleboxlist{i},'Visible','off');
                if eleflagvec(i) == 1 %if a box is checked but there is no data, uncheck the box
                    eleflagvec(i) = 0;
                    set(heleboxlist{i},'Value',0);
                end
            end
        end
        
        %Making sure only 4 boxes can be checked at a time because I only want a
        %4x4 subplot, any more and you cant see much.
        if elenum == 4
            uncheckedboxes = findobj('Tag','DataViewer','-and','Value',0,'-and','Style','checkbox','-and','Parent',helementpanel);
            set(uncheckedboxes,'Enable','off');
        else
            allboxes = findobj('Tag','DataViewer','-and','Style','checkbox','-and','Parent',helementpanel);
            set(allboxes,'Enable','on');
        end
        
        checkedele = find(eleflagvec == 1);
        
        panelplots = findobj('Parent',hpanelmultiple);
        delete(panelplots);
        if radiomultipleval == 1
            set(hpanelmultiple,'Visible','on');
            set(hpanelsingle,'Visible','off');
            
            for j = 1:sum(eleflagvec)
                
                subhandle{j} = subplot(2,2,j);
                imagesc([0,currSnew.Xvalue],[0,currSnew.Yvalue],currSnew.(totelefield{checkedele(j)}));
                axis image
                xlabel('X (\mum)');
                ylabel('Y (\mum)');
                colormap('parula');
                set((subhandle{j}),'Parent',hpanelmultiple);
                title(totelefield{checkedele(j)});
                cbar{i} = colorbar;
                
            end
            
        elseif radiosingleval == 1
            set(hpanelmultiple,'Visible','off');
            set(hpanelsingle,'Visible','on');
            
            
            axes(...
                'Units','normalized',...
                'Position',[0.07,0.06,0.9,0.9],...
                'Parent',hpanelsingle,...
                'Tag','haxes',...
                'HandleVisibility','on');
            
            switch imageselectionvalue
                case 1
                    imagesc([0,currSnew.Xvalue],[0,currSnew.Yvalue],currSnew.(totelefield{checkedele(1)}));
                    axis image
                    colormap('gray');
                    title(totelefield{checkedele(1)});
                    xlabel('X (\mum)');
                    ylabel('Y (\mum)');
                    
                    
                case 2
                    imagesc([0,currSnew.Xvalue],[0,currSnew.Yvalue],currSnew.(totelefield{checkedele(2)}));
                    axis image
                    colormap('gray');
                    title(totelefield{checkedele(2)});
                    xlabel('X (\mum)');
                    ylabel('Y (\mum)');
                    
                case 3
                    imagesc([0,currSnew.Xvalue],[0,currSnew.Yvalue],currSnew.(totelefield{checkedele(3)}));
                    axis image
                    colormap('gray');
                    title(totelefield{checkedele(3)});
                    xlabel('X (\mum)');
                    ylabel('Y (\mum)');
                    
                case 4
                    imagesc([0,currSnew.Xvalue],[0,currSnew.Yvalue],currSnew.(totelefield{checkedele(4)}));
                    axis image
                    colormap('gray');
                    title(totelefield{checkedele(4)});
                    xlabel('X (\mum)');
                    ylabel('Y (\mum)');
                    
            end 
        end        
    end

%% Visualizing limit on OD linearity
    function hODlimit_callback(~,~)
        hselect_callback();
    end

%% Control raw images radio button group
    function rawbg_callback(~,event)
        
        try 
            currrad = event.NewValue.String;
        catch
            currrad = 'Carbon';
        end
        
        readyvalue = get(hlistready,'Value');
        radiosingleval = get(hradiosingle,'Value');
        radiomultipleval = get(hradiomultiple,'Value');
        ODlimitval = get(hODlimitcheck,'Value');
        
        
        energy= Dataset.(Datasetnames{readyvalue}).Snew.eVenergy;
        Xvalue = Dataset.(Datasetnames{readyvalue}).Snew.Xvalue;
        Yvalue = Dataset.(Datasetnames{readyvalue}).Snew.Yvalue;
        Sspectr = Dataset.(Datasetnames{readyvalue}).Snew.spectr;
        
        switch currrad
            case 'Sulfur'
                [~,rawidx(1)] = min(abs(energy - 160));
                [~,rawidx(2)] = min(abs(energy - 160));
                [~,rawidx(3)] = min(abs(energy - 190));
                [~,rawidx(4)] = min(abs(energy - 190));
                
            case 'Carbon'
                [~,rawidx(1)] = min(abs(energy - 278));
                [~,rawidx(2)] = min(abs(energy - 285.4));
                [~,rawidx(3)] = min(abs(energy - 288.6));
                [~,rawidx(4)] = min(abs(energy - 320));
            case 'Potassium'
                [~,rawidx(1)] = min(abs(energy - 294.5));
                [~,rawidx(2)] = min(abs(energy - 294.5));
                [~,rawidx(3)] = min(abs(energy - 303.5));
                [~,rawidx(4)] = min(abs(energy - 303.5));
                
            case 'Calcium'
                [~,rawidx(1)] = min(abs(energy - 347));
                [~,rawidx(2)] = min(abs(energy - 347));
                [~,rawidx(3)] = min(abs(energy - 352));
                [~,rawidx(4)] = min(abs(energy - 352));
                
            case 'Nitrogen'
                [~,rawidx(1)] = min(abs(energy - 400));
                [~,rawidx(2)] = min(abs(energy - 400));
                [~,rawidx(3)] = min(abs(energy - 430));
                [~,rawidx(4)] = min(abs(energy - 430));
                
            case 'Oxygen'
                [~,rawidx(1)] = min(abs(energy - 525));
                [~,rawidx(2)] = min(abs(energy - 525));
                [~,rawidx(3)] = min(abs(energy - 550));
                [~,rawidx(4)] = min(abs(energy - 550));
                
        end
        
        if radiomultipleval == 1
            
            set(hpanelsingle,'Visible','off')
            set(hpanelmultiple,'Visible','on')
            delete(gca);
            
            handle = cell(4,1);
            cbar = cell(4,1);
            
            for i=1:4
                handle{i} = subplot(2,2,i);
                imagesc([0,Xvalue],[0,Yvalue],Sspectr(:,:,rawidx(i)))
                %             set(gca,'Clim',[0,1.5]),
                axis image
                xlabel('X (\mum)');
                ylabel('Y (\mum)');
                if ODlimitval == 1
                    colormap(graycmap);
                    caxis([0,1.6]);
                else
                    colormap(gray);
                end
                plottitle=sprintf('%geV',energy(rawidx(i)));
                title(plottitle);
                set((handle{i}),'Parent',hpanelmultiple)
                cbar{i} = colorbar;
            end
            
        elseif radiosingleval == 1
            set(hpanelmultiple,'Visible','off')
            set(hpanelsingle,'Visible','on')
            delete(gca);
            hpanaxes = axes(...
                'Units','normalized',...
                'Position',[0.07,0.06,0.9,0.9],...
                'Parent',hpanelsingle,...
                'Tag','haxes',...
                'HandleVisibility','on');
            
            testhandle = imagesc(...,
                [0, Xvalue],...
                [0,Yvalue],...
                Sspectr(:,:,rawidx(imageselectionvalue)));
            
            set(testhandle,'Parent',hpanaxes);
            axis image
            xlabel('X (\mum)');
            ylabel('Y (\mum)');
            if ODlimitval == 1
                colormap(graycmap);
                caxis([0,1.6]);
            else
                colormap(gray);
            end
            plottitle=sprintf('%geV',energy(rawidx(imageselectionvalue)));
            title(plottitle);
            colorbar;
        end
        
        
    end


%% checking to make sure user wants to run raw data and destroy quality
%control measures
    function husesaved_callback(~,~)
        saveval = get(husesaved,'Value');
		
        if saveval == 0
            %rawdatacheck = inputdlg('Do you want to re-analyze raw data (yes/no)? Quality control measures may need to be re-done.','Re-run Raw Data?',1,{'yes'});
            set(htextcheck,'String','Re-analyzing raw data, quality control measures may need to be redone');
			set(hqcsaved,'Enable','on','Value',0);
			
		else
			set(htextcheck,'String',[]);
            set(hqcsaved,'Value',0,'Enable','off')
            
        end
        
        
    end

%% programming the "use saved QC data" checkbox
    function hqcsaved_callback(~,~)
        useqcval = get(hqcsaved,'Value');
        
    end


%% Programming Manual Io button
    function hmanualIo_callback(~,~)
        readyval = get(hlistready,'Value');
        S = Dataset.(Datasetnames{readyval}).S;
        datafolder = Dataset.(Datasetnames{readyval}).Directory;       
        currthreshval = Dataset.(Datasetnames{readyval}).threshlevel;
        Snew = OdStack(S,'O',0,'yes',currthreshval); %Allows manual selection of Io region
        Snew = energytest(Snew);
%         Snew = makinbinmap(Snew);
        
        
        if Snew.elements.C == 1
            
            if Dataset.(Datasetnames{readyval}).binadjtest == 1;
                Snew = CarbonMapsSuppFigs(Snew,0.35,1,1,'given',Snew.binmap);
            else
                Snew=CarbonMapsSuppFigs(Snew,0.35);
            end
            Snew = DirLabelOrgVolFrac(Snew);
            
            try
                cd(datafolder);
            catch
                katyidx = strfind(datafolder,'C:\Users\Katy-Ann');
                uopidx = strfind(datafolder,'D:\Users\Emily');
                
                if ~isempty(katyidx)
                    datafolder(1:17) = [];
                    datafolder = ['D:\Users\Emily',datafolder];
                    
                elseif ~isempty(uopidx)
                    datafolder(1:14) = [];
                    datafolder = ['C:\Users\Katy-Ann',datafolder];
                else
                    disp('previously saved directory doesnt exist on this computer');
                end
            end
            
            tempdir = dir;
            cnt = 1;
            for q = 1:length(tempdir)
                hdridx = strfind(tempdir(q).name,'.hdr');
                ximidx = strfind(tempdir(q).name,'.xim');
                if ~isempty(ximidx) || ~isempty(hdridx)
                    filenames{cnt} = tempdir(q).name;
                    cnt = cnt + 1;
                end
            end
            
            [Mixing, Particles] = MixingState(Snew,datafolder,filenames);
        end
        
        if Snew.elements.S == 1
            Snew = SulfurMaps(Snew);
        end
        
        if Snew.elements.K == 1
            Snew = PotassiumMaps(Snew);
        end
        
        if Snew.elements.Ca == 1
            Snew = CalciumMaps(Snew);
        end
        
        if Snew.elements.N == 1
            Snew = NitrogenMaps(Snew);
        end
        
        if Snew.elements.O == 1
            Snew = OxygenMaps(Snew);
        end
        
        if Snew.elements.C == 1 && Snew.elements.N == 1 && Snew.elements.O == 1
            Snew = CNOeleMaps(Snew);
        end

        
        mapstest = 1;

        save(['../F',S.particle],'Snew','S','Mixing','Particles','datafolder','mapstest');
        
        hanalyze_callback();
    end

%% run and display EDXmap


%% run thresholding slider routine;
    function hmask_adjust_callback(~,~)
        readyval = get(hlistready,'Value');
        Snew = Dataset.(Datasetnames{readyval}).Snew;
        S = Dataset.(Datasetnames{readyval}).S;
        specmean = mean(Snew.spectr,3);
        datafolder = Dataset.(Datasetnames{readyval}).Directory;
		try
			beginningthreshlevel = Dataset.(Datasetnames{readyval}).threshlevel;
		catch
			beginningthreshlevel = 2;
		end
        
        threshfig = figure(...
            'Units','normalized',...
            'Position',[0.1,0.2,0.7,0.5]);
        
        figpairax = axes(...
            'Units','normalized',...
            'Parent',threshfig,...
            'Position',[0.05,0.3,0.9,0.7]);
        
        hthreshslide = uicontrol(...
            'Style','slider',...
            'Parent',threshfig,...
            'Units','normalized',...
            'Max',20,...
            'Value',beginningthreshlevel,...
            'Position',[0.05,0.05,0.9,0.06],...
            'Callback',{@hthreshslide_callback});
        
        hthreshtext = uicontrol(...
            'Style','text',...
            'Parent',threshfig,...
            'Units','normalized',...
            'String',num2str(beginningthreshlevel),...
            'Position',[0.5,0.15,0.1,0.03]);
        
        hsavethresh = uicontrol(...
            'Style','pushbutton',...
            'Parent',threshfig,...
            'Units','normalized',...
            'String','Save Mask Threshold',...
            'Position',[0.1,0.15,0.1,0.08],...
            'Callback',{@hsavethresh_callback});
        
        hdefaultthresh = uicontrol(...
            'Style','pushbutton',...
            'Parent',threshfig,...
            'Units','normalized',...
            'String','Reset Thresh Value',...
            'Position',[0.3,0.15,0.1,0.08],...
            'Callback',{@hdefaultthresh_callback});
        
        plotimshowpair();
        
        function plotimshowpair()
            imshowpair(specmean,~Snew.mask,'Parent',figpairax,'method','montage');
            
        end
        
        function hthreshslide_callback(~,~)
            currthreshval = get(hthreshslide,'Value');
            set(hthreshtext,'String',num2str(currthreshval));
            Snew = OdStack(S,'O',0,'no',currthreshval);
            
            plotimshowpair();
        end
        
        function hdefaultthresh_callback(~,~)
            currthreshval = 2;
            set(hthreshslide,'Value',currthreshval);
            set(hthreshtext,'String',num2str(currthreshval));
            Snew = OdStack(S,'O',0,'no',currthreshval);
            
            plotimshowpair();
        end
        
        function hsavethresh_callback(~,~)
            currthreshval = get(hthreshslide,'Value');
            Dataset.(Datasetnames{readyval}).threshlevel = currthreshval;
            S = Dataset.(Datasetnames{readyval}).S;
            
            manualIorecheck = inputdlg('maunally choose Io?','manual Io selection',1,{'no'});
            
            if strcmp(manualIorecheck,'no') == 1;
                Snew = OdStack(S,'O',0,'no',currthreshval);
            else
                Snew = OdStack(S,'O',0,'yes',currthreshval); %Allows manual selection of Io region
            end
            
            
            Snew = energytest(Snew);
            Snew = makinbinmap(Snew);
            
            
            if Snew.elements.C == 1
%                 if Dataset.(Datasetnames{readyval}).binadjtest == 1;
                    Snew=CarbonMapsSuppFigs(Snew,0.35,1,1,'yes');

%                 else
%                     Snew=CarbonMapsSuppFigs(Snew,0.35,1,1,'no');
%                 end
                Snew = DirLabelOrgVolFrac(Snew);
                
				try
					cd(datafolder);
				catch
					C_Users_Dir = dir('C:\Users');
					for c = 1:length(C_Users_Dir)
						katyidx = strfind(C_Users_Dir(c).name,'Katy-Ann');
						uopidx = strfind(C_Users_Dir(c).name,'Emily');
						matthewidx = strfind(C_Users_Dir(c).name,'Matthew Fraund');
						muleidx = strfind(C_Users_Dir(c).name,'Mulecenter78');
						
						if ~isempty(katyidx)
							currcomp = 'C:\Users\Katy-Ann';
							break
						elseif ~isempty(uopidx)
							currcomp = 'D:\Users\Emily';
							break
						elseif ~isempty(matthewidx)
							currcomp = 'D:';
							break
						elseif ~isempty(muleidx)
							currcomp = 'E:';
							break
						end
					end
					
					katyidx = strfind(datafolder,'C:\Users\Katy-Ann');
					uopidx = strfind(datafolder,'D:\Users\Emily');
					%matthewidx = strfind(datafolder,'
					
					if ~isempty(katyidx)
						datafolder(1:17) = [];
						
					elseif ~isempty(uopidx)
						datafolder(1:14) = [];
						
					else
						datafolder(1:2) = [];
					end
					datafolder = [currcomp,datafolder];
				end
				
				
				
				try
					cd(datafolder);
				catch
					disp([datafolder,' not found on this computer, reanalyze the raw data for this folder']);
				end
                
                tempdir = dir;
                cnt = 1;
                for q = 1:length(tempdir)
                    hdridx = strfind(tempdir(q).name,'.hdr');
                    ximidx = strfind(tempdir(q).name,'.xim');
                    if ~isempty(ximidx) || ~isempty(hdridx)
                        filenames{cnt} = tempdir(q).name;
                        cnt = cnt + 1;
                    end
                end
                
                [Mixing, Particles] = MixingState(Snew,datafolder,filenames);
            end
            
            if Snew.elements.S == 1
                Snew = SulfurMaps(Snew);
            end
            
            if Snew.elements.K == 1
                Snew = PotassiumMaps(Snew);
            end
            
            if Snew.elements.Ca == 1
                Snew = CalciumMaps(Snew);
            end
            
            if Snew.elements.N == 1
                Snew = NitrogenMaps(Snew);
            end
            
            if Snew.elements.O == 1
                Snew = OxygenMaps(Snew);
            end
            
            if Snew.elements.C == 1 && Snew.elements.N == 1 && Snew.elements.O == 1
                Snew = CNOeleMaps(Snew);
            end

            
            mapstest = 1;
            threshlevel = currthreshval;
            savedbinmap = Snew.binmap;
            binadjtest = 1;
            
            save(['../F',S.particle],'Snew','S','Mixing','Particles','datafolder','mapstest','threshlevel','savedbinmap','binadjtest','-v7.3');
            
            close(threshfig);
            
			Dataset.(Datasetnames{readyval}).S = S;
			Dataset.(Datasetnames{readyval}).Snew = Snew;
			Dataset.(Datasetnames{readyval}).Mixing = Mixing;
			Dataset.(Datasetnames{readyval}).Particles = Particles;
			Dataset.(Datasetnames{readyval}).Directory = datafolder;
			hselect_callback();
            %hanalyze_callback();
        end
        
    end

%% pick and choose which particles are included in analysis
    function hbinmap_adjust_callback(~,~)
        readyval = get(hlistready,'Value');
        Snew = Dataset.(Datasetnames{readyval}).Snew;
        S = Dataset.(Datasetnames{readyval}).S;
        datafolder = Dataset.(Datasetnames{readyval}).Directory;

        if Snew.elements.C == 1
            Snew=CarbonMapsSuppFigs(Snew,0.35,1,1,'yes');
            Snew = DirLabelOrgVolFrac(Snew);
            
            try
                cd(datafolder);
            catch
                katyidx = strfind(datafolder,'C:\Users\Katy-Ann');
                uopidx = strfind(datafolder,'D:\Users\Emily');
                
                if ~isempty(katyidx)
                    datafolder(1:17) = [];
                    datafolder = ['D:\Users\Emily',datafolder];
                    
                elseif ~isempty(uopidx)
                    datafolder(1:14) = [];
                    datafolder = ['C:\Users\Katy-Ann',datafolder];
                else
                    disp('previously saved directory doesnt exist on this computer');
                end
            end
            
            
            tempdir = dir;
            cnt = 1;
            for q = 1:length(tempdir)
                hdridx = strfind(tempdir(q).name,'.hdr');
                ximidx = strfind(tempdir(q).name,'.xim');
                if ~isempty(ximidx) || ~isempty(hdridx)
                    filenames{cnt} = tempdir(q).name;
                    cnt = cnt + 1;
                end
            end
            
            [Mixing, Particles] = MixingState(Snew,datafolder,filenames);
        end
        
        if Snew.elements.S == 1
            Snew = SulfurMaps(Snew);
        end
        
        if Snew.elements.K == 1
            Snew = PotassiumMaps(Snew);
        end
        
        if Snew.elements.Ca == 1
            Snew = CalciumMaps(Snew);
        end
        
        if Snew.elements.N == 1
            Snew = NitrogenMaps(Snew);
        end
        
        if Snew.elements.O == 1
            Snew = OxygenMaps(Snew);
        end
        
        if Snew.elements.C == 1 && Snew.elements.N == 1 && Snew.elements.O == 1
            Snew = CNOeleMaps(Snew);
        end

        
        mapstest = 1;
        binadjtest = 1;
        savedbinmap = Snew.binmap;
        save(['../F',S.particle],'Snew','S','Mixing','Particles','datafolder','mapstest','binadjtest','savedbinmap');
        
        Dataset.(Datasetnames{readyval}).binadjtest = 1;
        
        hanalyze_callback();
    end

    function hfixAlign_callback(~,~)
        %this will align the pre and post carbon energies AFTER alignstack is run.
        %That way spectra don't need to have all 100+ images aligned
        readyval = get(hlistready,'Value');
        Snew = Dataset.(Datasetnames{readyval}).Snew;
        energy = Snew.eVenergy;
        S = Dataset.(Datasetnames{readyval}).S;
        datafolder = Dataset.(Datasetnames{readyval}).Directory;
        
        
        [~,rawidx(1)] = min(abs(energy - 278));
        [~,rawidx(2)] = min(abs(energy - 285.4));
        [~,rawidx(3)] = min(abs(energy - 288.6));
        [~,rawidx(4)] = min(abs(energy - 320));
        
        
        fpre= figure;
        set(fpre,'Units','Normalized','Position',[0.01,0.05,0.48,0.87]);
        imagesc(Snew.spectr(:,:,rawidx(1)));
        
        
        fpost = figure;
        set(fpost,'Units','Normalized','Position',[0.50,0.05,0.48,0.87]);
        imagesc(Snew.spectr(:,:,rawidx(4)));      
        
        help_hdl = helpdlg('Choose pts with L-click, end with double-click, R-click, or enter.  Delete/backspace to go back');
        movegui(help_hdl,'northeast')
        
        [prex_selected, prey_selected] = getpts(fpre);
        figure(fpre);
        hold on
        plot(prex_selected,prey_selected,'r+');
        
        %making number list so that selected points are numbered in order
        numlabels = cellstr(num2str((1:length(prex_selected))'));
        for kk = 1:length(prex_selected);
            text(prex_selected(kk),prey_selected(kk),numlabels{kk},...
                'VerticalAlignment','bottom',...
                'HorizontalAlignment','right',...
                'Color','r');
        end
        
        if exist('help_hdl','var') ;
            close(help_hdl);
        end
        
        help_hdl2 = helpdlg('Choose pts with L-click, end with double-click, R-click, or enter.  Delete/backspace to go back');
        movegui(help_hdl2,'northwest')
        
        [postx_selected, posty_selected] = getpts(fpost);
        figure(fpost);
        
        if exist('help_hdl2','var') ;
            close(help_hdl2);
        end
        movingPoints = cat(2,postx_selected,posty_selected);
        fixedPoints = cat(2,prex_selected,prey_selected);
        
        % %     cpselect(STXMresize,SEMclip); %moving, fixed  This is so useful but it doesn't seem to want to work inside a function
        tform = fitgeotrans(movingPoints,fixedPoints,'projective');
        tforminv = invert(tform);
        
        preoutputview = imref2d(size(Snew.spectr(:,:,rawidx(1))));
        
        postxform = imwarp(Snew.spectr(:,:,rawidx(4)),tform,'OutputView',preoutputview);
        
        pairf2 = figure;
        imshowpair(Snew.spectr(:,:,rawidx(1)),postxform);
        movegui(pairf2,'northeast');
        
        close(fpre);
        close(fpost);
        
        Dataset.(Datasetnames{readyval}).Snew.postxform = postxform;
        
	end



	function hadjustCspec_callback(~,~)
		readyval = get(hlistready,'Value');
		Snew = Dataset.(Datasetnames{readyval}).Snew;
		datafolder = Dataset.(Datasetnames{readyval}).Directory;
		
		cspecfig = figure(...
			'Units','normalized',...
			'Position',[0.1,0.2,0.7,0.5]);
		
		cspecax = axes(...
			'Units','normalized',...
			'Parent','cspecfig',...
			'Position',[0.05,0.3,0.9,0.7]);
		
		sp2threshtext = uicontrol(...
			'Style','text',...
			'Parent',cspecfig,...
			'Units','normalized',...
			'String','Set SP2 Threshold Value (0.35)',...
			'Position',[0.2,0.15,0.1,0.08],...
			'Callback',{@sp2threshtext_callback});
		
		sp2noiselimittext = uicontrol(...
			'Style','text',...
			'Parent',cspecfig,...
			'Units','normalized',...
			'String','Set S/N multiplier (3)',...
			'Position',[0.4,0.15,0.1,0.08],...
			'Callback',{@sp2noiselimittext_callback});
		
		orgnoiselimittext = uicontrol(...
			'Style','text',...
			'Parent',cspecfig,...
			'Units','normalized',...
			'String','Set S/N multiplier (3)',...
			'Position',[0.6,0.15,0.1,0.08],...
			'Callback',{@orgnoiselimittext_callback});
		
		
		
		
		imagesc(uint8(Snew.RGBCompMap));
		
		
	end


%% 
	function carbon_mixingstate_callback(~,~)
		readyval = get(hlistready,'Value');
		currSnew = Dataset.(Datasetnames{readyval}).Snew;
		
		[CMixing,CParticles] = MixingState(currSnew);
		
		Dataset.(Datasetnames{readyval}).CMixing = CMixing;
		Dataset.(Datasetnames{readyval}).CParticles = CParticles;
		
		figure;
		imagesc([0,currSnew.Xvalue],[0,currSnew.Yvalue],CMixing.Dimap);
		axis image
		xlabel('X (\mum)');
		ylabel('Y (\mum)');
		colorbar;
		title(['Particle Diversity (\chi = ',num2str(CMixing.MixStateChi,2),')']);
		
	end

%%
	function hremoveenergy_callback(~,~)
		readyval = get(hlistready,'value');
		currSnew = Dataset.(Datasetnames{readyval}).Snew;
        datafolder = Dataset.(Datasetnames{readyval}).Directory;
		
		currS = LoadStackRawMulti(datafolder);
		
		try
			currthreshlevel = Dataset.(Datasetnames{readyval}).threshlevel;
		catch
			currthreshlevel = 2;
		end
		
		organic = currSnew.OVFassumedorg;
		inorganic = currSnew.OVFassumedinorg;
		
		cd(datafolder);
		
		badE = inputdlg('Remove Which Energies? Separate numbers by commas','Removing Energy',1);
		badE = str2num(badE{1});
		badE = sort(badE);
		[~,badEidx] = intersect(currS.eVenergy,badE);
		%badEidx = find(currS.eVenergy == badE);
		
		
		
		currS.eVenergy(badEidx) = [];
		currS.spectr(:,:,badEidx) = [];
		
		
		[S_updated,Snew_updated,Mixing_updated,Particles_updated] = SingStackProcMixingStateOutputNOFIGS(datafolder,currthreshlevel,0,currSnew.binmap,inorganic,organic,currS);
		%save(['../F',currS.particle],'Snew_updated','S_updated','Mixing_updated','Particles_updated','datafolder');
		hanalyze_callback();
	end

%% Control Multiple FOV Data Display
	function hmultidistfxn_callback(~,~)
		
		
		
	end

%% run cleanup code when figure is closed
    function figureclose_callback(~,~)
        clear('Dataset');
        clear global
        delete(f);      
	end

end