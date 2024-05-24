function STXM_GUIv4

%initial gui stuff
%
%
%Non-matlab file dependencies (source):
%-----------------------------
%uipickfiles (found online)



%% Constructing UI
%================================================================
%================================================================

%% UiComp > Always Visible
f = figure(...
    'Visible','off',...
    'Units','normalized',...
    'Position',[360,200,0.8,0.8],...
    'KeyPressFcn',{@figkeypress_callback},...
    'CloseRequestFcn',{@figureclose_callback},...
    'Name','AnalyzingSTXM');

%---------------------------
hremove = uicontrol(...
    'Style','pushbutton',...
    'String','Remove Selected',...
    'Units','normalized',...
    'Enable','off',...
    'Position',[0.19,0.88,0.05,0.053],...
    'Callback',{@hremove_callback});

hreadytitle = uicontrol('Style','text','String','Data to Run',...
    'Units','normalized',...
    'Position',[0.12,0.88,0.07,0.02]);

hlistready = uicontrol(...
    'Style','listbox',...
    'Max',100,...
    'Min',0,...
    'Units','normalized',...
    'KeyPressFcn',{@hlistreadykey_callback},...
    'Callback',{@hlistready_callback},...
    'Position',[0.01,0.17,0.3,0.7]);

% Analysis Window Type
routineString = {...
	'Load & Run Data',...
	'Data Viewer'};

hroutinepopup = uicontrol(...
    'Style','popupmenu',...
    'String',routineString,...
    'Units','normalized',...
    'Position',[0.01,0.93,0.1,0.053],...
    'KeyPressFcn',{@hlistreadykey_callback},...
    'Callback',{@hroutinepopup_callback});

%% UiComp > Load & Run
%%%% 
%%%%

husesaved = uicontrol('Style','checkbox', 'String','Use Saved Analyses',...
    'Units','normalized','Value',1,'Tag','Load',...
    'Position',[0.12,0.97,0.15,0.02],...
    'Callback',{@husesaved_callback});

htextcheck = uicontrol('Style','text', 'String',[],...
	'Units','normalized','Tag','Load',...
	'Position',[0.20,0.965,0.2,0.02]);

hqcsaved = uicontrol('Style','checkbox',...
    'String','Use Saved QC Params',...
    'Units','normalized','Value',0,'Enable','off','Tag','Load',...
    'Position',[0.12,0.95,0.15,0.02],...
    'Callback',{@hqcsaved_callback});

hthresholding_dropdown = uicontrol('Style','popupmenu','Units','normalized',...
	'Position',[0.20, 0.95, 0.10, 0.02],'Tag','Load',...
	'String',{'adaptive','O'},...
	'Enable','off');

hload = uicontrol('Style','pushbutton','String', 'Load STXM Data',...
    'Units','normalized',...
    'Position',[0.01,0.88,0.05,0.053],...
    'Callback',{@hload_callback});

hload_recursive = uicontrol('Style','pushbutton', 'String','Load All Recursive',...
    'Units','normalized',...
    'Position',[0.06,0.88,0.05,0.053],...
    'Callback',{@hload_recursive_callback});

hanalyze = uicontrol('Style','pushbutton', 'String','Analyze All',...
    'Units','normalized', 'Enable','off','Tag','Load',...
    'Position',[0.24,0.88,0.07,0.053],...
    'Callback',{@hanalyze_callback});


% Helper Functions
hsort = uicontrol('Style','pushbutton','String','Run stxmsort',...
    'Units','normalized','Tag','Load',...
    'Position',[0.87, 0.93, 0.1, 0.053],...
    'Enable','off',...
    'Callback',{@hsort_callback});

hdatamerge = uicontrol('Style','pushbutton','String','Merge STXM Data',...
	'Units','normalized','Tag','Load',...
	'Position',[0.87, 0.83, 0.1, 0.053],...
    'Enable','off',...
	'Callback',{@hmerge_callback});


%% UIComp > L&R >> GUI Preferences
startingPanel = uipanel(f,'Units','normalized','Tag','Load','Title','GUI Preferences','Position',[0.31,0.5,0.4, 0.5]);

hassumedinorgpopup = uicontrol('Style','popupmenu', 'Units','normalized','Tag','Load','Parent',startingPanel,...
    'Position',[0.02, 0.74, 0.1, 0.05],...
    'Value', 2,...
	'String',{'NaCl','(NH4)2SO4','NH4NO3','NaNO3','KNO3','Na2SO4','KCl','Fe2O3','CaCO3','ZnO','Pb(NO3)2','Al2Si2O9H4'});

hassumedorgpopup = uicontrol('Style','popupmenu','Units','normalized','Parent',startingPanel,...
	'Position',[0.02,0.7,0.1,0.05],...
	'String',{'sucrose','adipic','glucose','oxalic'},...
    'Value',2,...
	'Tag','Load');

hloadtype = uicontrol('Style','popupmenu','Units','normalized','Tag','Load','Parent',startingPanel,...
	'Position',[0.02, 0.55, 0.15, 0.05],...
	'String',{'Load all (default)', 'Only Maps', 'Only Spectra', 'Only Files'});


hStartingDir_Label = uicontrol('Style','text','Tag','Load','Units','normalized','Parent',startingPanel,...
    'String','Starting Directory',...
    'Position',[0.005, 0.94, 0.5, 0.05]);

hStartingDir = uicontrol('Style','edit', 'Tag','Load', 'Units','normalized','Parent',startingPanel,...
    'String',pwd,...
    'Position',[0.005,0.89,0.5,0.05]);

hStartingDirBrowseButton = uicontrol('Style','pushbutton','Units','normalized','Parent',startingPanel,...
    'Tag','Load','String','Set Starting Dir','Position',[0.53, 0.89, 0.1, 0.05],...
    'Callback',{@hStartingDirBroseButton_callback});

hSave_Preferences = uicontrol('Style','pushbutton','Units','normalized','Parent',startingPanel,...
    'Tag','Load','String','Save Current UI Preferences',...
    'Position',[0.8, 0.01,0.2, 0.1],...
    'Callback',{@SaveGuiPreferences_callback}); 

% hACEENA_DirSwitch = uicontrol('Style','pushbutton','Units','normalized','Parent',startingPanel,...
%     'Tag','Load','String','Switch to ACEENA Directory',...
%     'Position',[0.003, 0.006,0.2, 0.1],...
%     'Callback',{@hACEENA_DirSwitch_callback});

hSP2Thresh_label = uicontrol('Style','text','Tag','Load','Units','normalized','Parent',startingPanel,...
    'String','Setting sp2 Threshold (0.35 default)','Position',[0.3, 0.75, 0.1, 0.05]);

hSP2Thresh_edit = uicontrol('style','edit','Units','normalized','Parent',startingPanel,...
    'Tag','Load','String','0.35',...
    'Position',[0.3, 0.7, 0.1, 0.05]);

hDataSummaryPrepostPlotSelection_label = uicontrol('Style','text','Tag','Load','Units','normalized','Parent',startingPanel,...
    'Position',[0.02, 0.4, 0.15, 0.05],...
    'String','PrePost Image to Display in Data Summary');

hDataSummaryPrepostPlotSelection = uicontrol('Style','popupmenu','Tag','Load','Units','normalized','Parent',startingPanel,...
    'Position',[0.02, 0.3, 0.15, 0.05],...
    'Value',1,...
    'String',{'C','S','K','Ca','N','O'});


%% UiComp > Data Viewer

%% UiComp > DV >> Particle Collections
haveragevariable = uicontrol(...
	'Style','pushbutton',...
	'String','Average Variable',...
	'Units','normalized',...
    'Tag','DataViewer',...
	'Position',[0.01,0.11,0.09,0.05],...
	'Callback',{@haveragevariable_callback});

hparticlecollage = uicontrol('Style','pushbutton','String','Particle Collage',...
    'Units','normalized','Tag','DataViewer','Enable','off',...
    'Position',[0.11, 0.11, 0.09, 0.05],...
    'Callback',{@hparticlecollage_callback});

hdatavectorexport = uicontrol('Style','pushbutton','String','Export Updated DV',...
    'Units','normalized','Tag','DataViewer','Enable','off',...
    'Position',[0.21, 0.11, 0.09, 0.05],...
    'Callback',{@hdatavectorexport_callback});

hloadparticlecollection = uicontrol('Style','pushbutton','String','Load Particle Collection',...
    'Units','normalized','Tag','DataViewer','Position',[0.01,0.05,0.09,0.05],...
    'Callback',{@hloadparticlecollection_callback});

hsaveparticlecollection = uicontrol('Style','pushbutton','String','Save Particle Collection',...
    'Units','normalized','Tag','DataViewer','Position',[0.11,0.05,0.09,0.05],'Enable','off',...
    'Callback',{@hsaveparticlecollection_callback});
    
hsaveASparticlecollection = uicontrol('Style','pushbutton','String','Save As Particle Collection',...
    'Units','normalized','Tag','DataViewer','Position',[0.21,0.05,0.09,0.05],'Enable','off',...
    'Callback',{@hsaveASparticlecollection_callback});

hcollectionpath = uicontrol('Style','text','String',' No Collection Loaded',...
    'Units','normalized','Tag','DataViewer','Position',[0.01, 0.02, 0.3, 0.01]);

%% UiComp > DV >> Button Groups for Raw Images
rawbg = uibuttongroup (...
    'Units','normalized',...
    'Visible','off',...
    'Position',[0.80,0.90,0.17,0.1],...
    'Title','Raw Images',...
    'SelectionChangedFcn',{@rawbg_callback});

%Creating buttons belonging to rawbg button group
hSulfurrad = uicontrol(...
    'Style','radiobutton',...
    'String','S',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.1,0.6,0.3,0.2]);

hCarbonrad = uicontrol(...
    'Style','radiobutton',...
    'String','C',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.1,0.2,0.3,0.2]);

hPotassiumrad = uicontrol(...
    'Style','radiobutton',...
    'String','K',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.35,0.6,0.3,0.2]);

hCalciumrad = uicontrol(...
    'Style','radiobutton',...
    'String','Ca',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.35,0.2,0.3,0.2]);

hNitrogenrad = uicontrol(...
    'Style','radiobutton',...
    'String','N',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.65,0.6,0.3,0.2]);

hOxygenrad = uicontrol(...
    'Style','radiobutton',...
    'String','O',...
    'Units','normalized',...
    'Parent',rawbg,...
    'Tag','DataViewer',...
    'Position',[0.65,0.2,0.3,0.2]);

%% UiComp > DV >> Elemental Panel
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
    'String','S',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.1,0.6,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hCarbonbox = uicontrol(...
    'Style','checkbox',...
    'String','C',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.1,0.2,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hPotassiumbox = uicontrol(...
    'Style','checkbox',...
    'String','K',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.35,0.6,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hCalciumbox = uicontrol(...
    'Style','checkbox',...
    'String','Ca',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.35,0.2,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hNitrogenbox = uicontrol(...
    'Style','checkbox',...
    'String','N',...
    'Units','normalized',...
    'Parent',helementpanel,...
    'Tag','DataViewer',...
    'Position',[0.65,0.6,0.3,0.2],...
    'Visible','on',...
    'Callback',{@hprepost_callback});

hOxygenbox = uicontrol(...
    'Style','checkbox',...
    'String','O',...
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

%% UiComp > DV >> Single/Multiple View Panel
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
    'Callback',{@hselect_callback});

hCMapSilhouetteCheck = uicontrol('Style','checkbox','Value',0,'Visible','off','Units','normalized','String','Silhouettes and Outlines',...
    'Tag','DataViewer',...
    'Position',[0.41,0.96,0.1,0.04],...
    'Callback',{@hselect_callback});

popupimagesPOS = [0 , 0.92, 0.1, 0.053];
popupimagesPOS(1,1) = radiomultiplePOS(1,1) + 0.05;

hpopupimages = uicontrol(...
    'Style','popupmenu',...
    'String',{'Data Summary', 'Prepost Images','Raw Images','Organic Vol. Fractions','ODStack Images','CarbonMaps Images','Alignment','Size Distribution', 'Spectra Viewer'},...
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

global currDataInfo
currDataInfo = {['# Particles: ', '1'],['Mean Size: ', 2],['Mean Vol. Frac.: ', 3],['# Energies: ', 4],'5'};
hdatainfo = uicontrol(...
	'Style','text',...
	'Visible','off',...
	'Tag','DataViewer',...
	'Units','normalized',...
	'Position',[0.355, 0.80, 0.07, 0.06],...
	'String',currDataInfo);


%% UiComp > DV >> DV Button Components
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

hSelectSpectra = uicontrol(...
    'Style','pushbutton',...
	'String','SelectSpectra',...
	'Units','normalized',...
	'Visible','off',...
	'Position',[0.79,0.88,0.1,0.053],...
	'Tag','SpectraViewer',...
	'Callback',{@hSelectSpectra_callback});

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

hsavecontext = uicontextmenu('Parent',f);

hmenuitems = uimenu(hsavecontext,...
    'Label','Save plot window',...
    'Callback',@context_callback);

%% StackLab Components
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

%% Quality Control Buttons
%%%% Adding Quality Control Buttons
%%%%
hcarbon_mixingstate = uicontrol(...
    'Style','pushbutton',...
    'String','IN/OC/EC Mixing State',...
    'Units','normalized',...
    'Visible','off',...
    'Position',[0.35,0.01,0.1,0.053],...
    'Tag','DataViewer',...
    'Enable','off',...
    'Callback',{@carbon_mixingstate_callback});

hmanualIo = uicontrol(...
    'Style','pushbutton',...
    'String','Manually Select Io',...
    'Units','normalized',...
    'Visible','off',...
    'Position',[0.46,0.01,0.1,0.053],...
    'Tag','DataViewer',...
    'enable','off',...
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
    'String','Gamma/Remove Pixels/Manual Io',...
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

%% Load Saved UI Preferences
LoadGuiPreferences();

%% bad globals
global imageselectionvalue;
imageselectionvalue = 1;
global analyzeruntest;
analyzeruntest = 0;
global filedirs;
global Dataset;
global DataVectors_GUI;
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



%% ================== Programming Callbacks =======================
%======================================================================

%% Load Files
    function hload_callback(~,~)
%         filedirs = uipickfiles; %calls up gui to pick multiple directories
		filedirs = pickFileDirs(filedirs);
        
		if isempty(filedirs)
			disp('Must pick some files');
		end
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
			
			% Different folder connectors for OS types
			if ispc()
				tempfiledir = strcat(filedirs{i},'\');
				fullfolders{i} = [foldername_up2,' \ ',foldername_up1,' \ ',foldername];
			elseif ismac()
				tempfiledir = strcat(filedirs{i},'/');
				fullfolders{i} = [foldername_up2,' / ',foldername_up1,' / ',foldername];
			end
			
			% Determining type of data set
			dirLabel = StackOrMap(tempfiledir);
			if strcmp(dirLabel,'map')
				dirtype{i} = 'map  ';
			elseif strcmp(dirLabel,'stack')
				dirtype{i} = 'stack';
            elseif strcmp(dirLabel, 'file')
                dirtype{i} = 'file';
			end
			
            displaydirs{i} = [dirtype{i},' ',fullfolders{i}];
			if isempty(displaydirs{i})
				displaydirs{i} = [displaydirs{i}, 'EMPTY'];
			end
		end
		
		loadstr = get(hloadtype, 'String');
		loadval = get(hloadtype, 'Value');
		loadtype = loadstr{loadval};
		
		if contains(loadtype, 'maps', 'IgnoreCase', true)
			removelist_boolvec = ~contains(dirtype, 'map');
		elseif contains(loadtype, 'spectra', 'IgnoreCase',true)
			removelist_boolvec = ~contains(dirtype, 'stack');
        elseif contains(loadtype, 'file', 'IgnoreCase',true)
            removelist_boolvec = ~contains(dirtype, 'file');
        else
            removelist_boolvec = [];
        end
        
		displaydirs(removelist_boolvec) = [];
        filedirs(removelist_boolvec) = [];
		
        set(hlistready,'String',displaydirs);
        set(hanalyze,'Enable','on');
        set(hremove,'Enable','on');
		set(haveragevariable,'Enable','on');
	end

%% Recursive Load
	function hload_recursive_callback(~,~)
        startingDir = get(hStartingDir,'String');
		startDir = uipickfiles('FilterSpec',startingDir,...
			'REFilter','\.removefilesfromlist$',...
			'Prompt','Select Starting Directory For Recursive Data Scraping');
		
		for sDirIdx = 1:length(startDir)
			dataDirs = recursive_load(startDir{sDirIdx});
			dataDirs_unpacked = UnpackCell(dataDirs);
			dataDirs_cleaned = dataDirs_unpacked(~cellfun(@isempty, dataDirs_unpacked));
			filedirs = cat(1, filedirs, dataDirs_cleaned);
			
		end
		
		numdirs = length(filedirs);
		folders = cell(1,numdirs); %preallocating folders cell array
		dirtype = cell(1,numdirs); %preallocating
		displaydirs = cell(1,numdirs);
		for i = 1:numdirs %looping through each selected directory
			[folderpath,foldername,~] = fileparts(filedirs{i}); %only picking the foldernames for brevity
			[folderpath_up1,foldername_up1,~] = fileparts(folderpath);
			[~,foldername_up2,~] = fileparts(folderpath_up1);
			
			folders{i} = foldername; %making list of directory names
			
			% Different folder connectors for OS types
			if ispc()
				tempfiledir = strcat(filedirs{i},'\');
				fullfolders{i} = [foldername_up2,' \ ',foldername_up1,' \ ',foldername];
			elseif ismac()
				tempfiledir = strcat(filedirs{i},'/');
				fullfolders{i} = [foldername_up2,' / ',foldername_up1,' / ',foldername];
			end
			
			% Determining type of data set
			dirLabel = StackOrMap(tempfiledir);
			if strcmp(dirLabel,'map')
				dirtype{i} = 'map  ';
			elseif strcmp(dirLabel,'stack')
				dirtype{i} = 'stack';
			end
			
			displaydirs{i} = [dirtype{i},' ',fullfolders{i}];
			if isempty(displaydirs{i})
				displaydirs{i} = [displaydirs{i}, 'EMPTY'];
			end
			
        end	
		
		loadstr = get(hloadtype, 'String');
		loadval = get(hloadtype, 'Value');
		loadtype = loadstr{loadval};
		if contains(loadtype, 'maps', 'IgnoreCase', true)
			removelist_boolvec = contains(dirtype, 'stack');
		elseif contains(loadtype, 'spectra', 'IgnoreCase',true)
			removelist_boolvec = contains(dirtype, 'map');
		else
			removelist_boolvec = [];
		end
		
		displaydirs(removelist_boolvec) = [];
		filedirs(removelist_boolvec) = [];
		
		set(hlistready,'String',displaydirs);
		set(hanalyze,'Enable','on');
		set(hremove,'Enable','on');
		set(haveragevariable,'Enable','on');
		
		function dirOut = recursive_load(dirIn)
			dirContents = dir(dirIn);
			dirContents = dirContents(3:end); %removing '.' and '..'
			
			if isempty(dirContents)
				dirOut = [];
				return
			end
			
			numDirs = sum([dirContents.isdir]);
			if numDirs == 0 % Base Case
				numHdr = count([dirContents.name], '.hdr');
				numXim = count([dirContents.name], '.xim');
				if numHdr == 1 % Only 1 hdr file
					if numXim > 1 %and many images
						
						for h = 1:length(dirContents)
							if contains(dirContents(h).name,'.hdr')
								hdrFile = fullfile(dirContents(h).folder, dirContents(h).name);
								[eVenergy] = ReadHdrMulti(hdrFile);
								break
							end
						end
						
						if length(eVenergy) == numXim
							dirOut = dirIn;
						else
							dirOut = [];
							return
						end
					else %and no images (error) or only one image (standalone hdr/xim pair)
						dirOut = [];
						return
					end
					
				elseif numHdr <= 10 && numHdr > 1 % Small/contained number of .hdr files.  10 would be an overly large map
					cnt = 0;
					for h = 1:length(dirContents)
						if contains(dirContents(h).name,'.hdr')
							cnt = cnt + 1;
							hdrFile = fullfile(dirContents(h).folder, dirContents(h).name);
							[~, ~, ~, ~, positionStruct] = ReadHdrMulti(hdrFile);
							currXYVals = [positionStruct.xcenter, positionStruct.ycenter];
							xyvals(cnt,:) = currXYVals;
							
							if cnt > 1
								xdiff = abs(xyvals(cnt,1) - xyvals(cnt-1, 1));
								ydiff = abs(xyvals(cnt,2) - xyvals(cnt-1, 2));
								
								if xdiff > 10 || ydiff > 10 % hdr files are too far away from each other to be of the same FOV
									dirOut = [];
									return
								end
							end
						else
							dirOut = dirIn;
						end
					end
				else % many more hdr files than in a map, this must be just a collection of images
					dirOut = [];
					return
				end
			elseif numDirs > 0 %If folders are present, it's not a data set
				nestDirs = dirContents([dirContents.isdir]);
				for d = 1:numDirs
					if contains(nestDirs(d).name,'BadFiles')
						dirOut{d} = [];
						continue
					end
					currNestDir = fullfile(nestDirs(d).folder, nestDirs(d).name);
					dirOut{d} = recursive_load(currNestDir);
				end
			end
		end
		
		
		
	end

%% Remove Files
%hremove button moves data from "ready list" to "load list" This is EXACTLY
%the same as hadd with the listbox 'String' and 'Values' switched
    function hremove_callback(~,~)
        % Getting chosen value
		readylistvalue = get(hlistready,'Value');
        readyliststring = get(hlistready,'String');
		
		% Removing chosen value
        readyliststring(readylistvalue) = [];
		filedirs(readylistvalue) = [];
        if ~isempty(Dataset)
            Datasetnames = fieldnames(Dataset);
            Dataset = rmfield(Dataset, Datasetnames{readylistvalue});
            Datasetnames(readylistvalue) = [];
        end
		
		% Setting new string and ensuring a non-existent value isn't selected
        newListValue = max(readylistvalue, 1);
        if newListValue > numel(filedirs)
            newListValue = newListValue - 1;
        end
        
        set(hlistready,'String',readyliststring,'Value',newListValue);
        
		% Turning off buttons if needed
		if isempty(readyliststring)
			set(hremove,'Enable','off');
			set(hanalyze,'Enable','off');
			set(haveragevariable,'Enable','off');
			return
		else
			hselect_callback()
		end
        
	end

%% Average Variables Button
    function haveragevariable_callback(~,~)
        
        % Preallocation
        [OVFvec, Sizevec, PartLabelVec, CompSizeVec, DiVec, DalphaVec, DgammaVec] = deal([]);
        [partDirList, croppedOVF, partMask, cSpecParts, rawParts] = deal(cell(0));
        [partEnergy, normPartSpec, normPartOrgSpec, normPartOVFSpec] = deal(cell(0));
        
        lfiledirs = length(filedirs);
        
        if any(exist('sillystring','file'))
			hwait = waitbar(0,sillystring);
		else
			hwait = waitbar(0,'plz w8');
        end
        
        for j = 1:length(filedirs)
            hwait.Name = ['Averaging ', num2str(j),' of ', num2str(lfiledirs)];
            waitbar(j/lfiledirs);
            drawnow
            
            currSnew = Dataset.(Datasetnames{j}).Snew;
            
            
            for k = 1:length(currSnew.Size)
                partDirList = [partDirList; Dataset.(Datasetnames{j}).Directory];
            end
            
            Sizevec = [Sizevec, currSnew.Size];
            
            % Cropping
            currSnew = CropParticles(currSnew);
            rawParts = [rawParts ; currSnew.CroppedParticles.rawParts];
            partMask = [partMask ; currSnew.CroppedParticles.partMask];
            
            
            
            if currSnew.elements.C == 1 & currSnew.Size > 0
                OVFvec = [OVFvec; currSnew.VolFrac];
                PartLabelVec = [PartLabelVec, currSnew.PartLabel];
                CompSizeVec = [CompSizeVec; currSnew.CompSize];
                
                %Cropped
                croppedOVF = [croppedOVF ; currSnew.CroppedParticles.OVFParts];
                cSpecParts = [cSpecParts ; currSnew.CroppedParticles.cSpecParts];
                
                % Mixing State
                currSnew = MixingState_CComp(currSnew);
                DiVec = [DiVec ; currSnew.Mixing.Di];
                DalphaVec = [DalphaVec; currSnew.Mixing.Dalpha];
                DgammaVec = [DgammaVec; currSnew.Mixing.Dgamma];
                
                % Spectra
                currSnew = SpectraProcessing(currSnew);
                partEnergy = [partEnergy; currSnew.partEnergy];
                normPartSpec = [normPartSpec; currSnew.normPartSpec];
                normPartOrgSpec = [normPartOrgSpec; currSnew.normOrgSpec];
                normPartOVFSpec = [normPartOVFSpec; currSnew.normOVFSpec];
                
            end
            
        end
        close(hwait);
        
        DataVectors_GUI.dirlist = filedirs;
        DataVectors_GUI.partDirList = partDirList;
        
        DataVectors_GUI.OVF = OVFvec;
        DataVectors_GUI.Size = Sizevec';
        DataVectors_GUI.PartLabel = PartLabelVec';
        DataVectors_GUI.CompSize = CompSizeVec;
        
        DataVectors_GUI.partMask = partMask;
        DataVectors_GUI.croppedOVF = croppedOVF;
        DataVectors_GUI.cSpecParts = cSpecParts;
        DataVectors_GUI.rawParts = rawParts;
        
        DataVectors_GUI.DiVec = DiVec;
        DataVectors_GUI.DalphaVec = DalphaVec;
        DataVectors_GUI.DgammaVec = DgammaVec;
        
        DataVectors_GUI.partEnergy = partEnergy;
        DataVectors_GUI.normPartSpec = normPartSpec;
        DataVectors_GUI.normPartOrgSpec = normPartOrgSpec;
        DataVectors_GUI.normPartOVFSpec = normPartOVFSpec;
        
        DataVectors_GUI.particleGroups.all.particleIdx = 1:length(partDirList);
        
        hdatavectorexport_callback();
        
%         DataVectors_GUI.Chi = (DataVectors_GUI.Dalpha - 1) ./ (DataVectors_GUI.Dgamma - 1);
        
%         assignin('base','DataVectors',DataVectors_GUI);
        hparticlecollage.Enable = 'on';
        hsaveparticlecollection.Enable = 'on';
        hsaveASparticlecollection.Enable = 'on';
    end

%% Particle Collage
    function hparticlecollage_callback(~,~)
        collageFig = figure('Name','Particle Collage','Units','normalized','Position',[0.05, 0.3, 0.3, 0.5],...
            'KeyPressFcn', {@removeLastSelected},'DeleteFcn',{@closeParticleCollage});
        collageBG = uibuttongroup(collageFig,'Units','normalized','Position',[0.00, 0.9, 1, 0.1],'SelectionChangedFcn',@collageModeChange);
        
        explorePOS_norm = [0, 0.6, 0.2, 0.34];
        selectPOS_norm = [0, 0.1, 0.2, 0.34];
        
        exploreRadio = uicontrol(collageBG,'Style','radiobutton','String','Explore Particle in Main GUI','Units','normalized','Position',explorePOS_norm,'Tag','explore');
        selectRadio = uicontrol(collageBG,'Style','radiobutton','String','Select Multiple Particles','Units','normalized','Position',selectPOS_norm,'Tag','select');
        selectLabelName = uicontrol(collageBG, 'Style','edit','String','Particle Group Name', 'Units','normalized','Position',[0.50, 0.19, 0.15, 0.25]);
        refreshParticleList = uicontrol(collageBG,'Style','pushbutton','String','Refresh List','Units','normalized','Position',[0.2, 0.54, 0.095, 0.4],'Callback',{@placeParticleGrouping});
        saveParticleGrouping = uicontrol(collageBG, 'Style','pushbutton','String','Save Particle Group -->','Units','normalized','Position',[0.49, 0.49, 0.16, 0.47],'Callback',{@saveParticleGrouping_callback},'Enable','off');
        displayAllParticles = uicontrol(collageBG,'Style','pushbutton','String','Display All Particles','Units','normalized','Position',[0.3, 0.51, 0.14, 0.44],'Callback',{@displayAllParticles_callback});
        particleGroupList = uicontrol('Style','listbox','Units','normalized','Position',[0.66, 0.1, 0.3, 0.9],'Parent',collageBG,'Callback',{@particleGroupList_callback});
        collageSampleSize = uicontrol('Style','edit','String','all','Units','normalized','Position',[0.96, 0.72, 0.04, 0.27], 'Parent',collageBG,'Callback',{@particleGroupList_callback});
        
        collagePanel = uipanel(collageFig,'Units','normalized','BorderType','none','Position',[0.00, 0.00, 1, 0.9]);
        collageAxes = axes(collagePanel);
        
        PlotCollage_GUI(DataVectors_GUI);
        
        collageImageHandle = findall(collageFig,'Type','image');
        hdatavectorexport.Enable = 'on';
        particleGroupList.UserData = 'all';
        collageFig.WindowButtonMotionFcn = @hoverPlot;
        
        %% >> Hover and plot spectrum
        function hoverPlot(source, event)
            figurePos = get(source,'Position');

            mousePos = get(gca,'CurrentPoint');
            mouseRow = round(mousePos(1,2));
            mouseCol = round(mousePos(1,1));

            collageImageHandle = findall(collageFig,'Type','image');
            
            labelCollage = collageImageHandle.UserData;
            
            if mouseRow >0 && mouseRow <= size(labelCollage,1) && ...
                    mouseCol >0 && mouseCol <= size(labelCollage,2)
                chosenPartIdx = labelCollage(mouseRow, mouseCol);
%                 chosenPartIdx
                if chosenPartIdx > 0
                    
                    if isempty(findobj('Tag','hover'))
                        hoverOverFig = figure('Tag','hover','Units','normalized','Position',[0.4, 0.4, 0.4, 0.4]);
                    else
                        return
                    end
                    
                    if strcmp(particleGroupList.UserData,'all')
                        %                         chosenPartDir = DataVectors_GUI.partDirList{chosenPartIdx};
                        plot(DataVectors_GUI.partEnergy{chosenPartIdx}, DataVectors_GUI.normPartOrgSpec{chosenPartIdx})
                    else
                        currGroup = particleGroupList.String{particleGroupList.Value};
                        %                         chosenPartDir = DataVectors_GUI.particleGroups.(currGroup).partDirList{chosenPartIdx};
                        plot(DataVectors_GUI.particleGroups.(currGroup).partEnergy{chosenPartIdx}, DataVectors_GUI.particleGroups.(currGroup).normPartOrgSpec{chosenPartIdx})
                    end
                    cspecfig('Labels',true);
                    xlabel('Energy (eV)');
                    ylabel('Intenisty');
                    xlim([278, 305]);
                    
                    figure(collageFig);
                    
                else
                    hoverFigWindow = findobj('Tag','hover');
                    close(hoverFigWindow);
                    
                end
            end
        end
        
        %% >> Plot Collage Image
        function imHandle = PlotCollage_GUI(DVin,varargin)
            [~, sampSize] = ExtractVararginValue(varargin, 'Sample Size', 'all');
            
            collageImage = ParticleCollage(DVin, 'Ordering', 'ordered', 'Sample Size', sampSize);
            
            imHandle = imagesc(uint8(collageImage));
            axis image
            hold(collageAxes,'on');

            imHandle.UserData = bwlabel(sum(collageImage, 3));
            imHandle.ButtonDownFcn = @ExploreSelectedParticle;
            collageImageHandle = findall(collageFig,'Type','image');
            
            if hasfield(DVin,'particleGroups')
                placeParticleGrouping();
            end
            
        end
        
        
        %% >> Changing Collage Mode
        function collageModeChange(source,event)
            selectedToggle = source.SelectedObject;
            delete(findall(collageImageHandle.Parent,'Tag','recentSelection'));
            
            switch selectedToggle.Tag
                case 'explore'
                    collageImageHandle.ButtonDownFcn = @ExploreSelectedParticle;
                    if ~isempty(findall(source.Parent,'Tag','recentSelection'))
                        delete(findall(source.Parent,'Tag','recentSelection'));
                    end
                case 'select'
                    collageImageHandle.ButtonDownFcn = @SelectMultipleParticles;
                    DataVectors_GUI.particleGroups.tempParticleGroup = []; %initialize temporary particle group
                    saveParticleGrouping.Enable = 'on';
            end
        end
        
        %% >> Explore Selected Particle
        function ExploreSelectedParticle(source, event)
            labelCollage = source.UserData;
            xyPOS = round(event.IntersectionPoint(1:2));
            partRow = xyPOS(2);
            partCol = xyPOS(1);
            chosenPartIdx = labelCollage(partRow,partCol);
            
            if chosenPartIdx > 0
                if strcmp(particleGroupList.UserData,'all')
                    chosenPartDir = DataVectors_GUI.partDirList{chosenPartIdx};
                else
                    currGroup = particleGroupList.String{particleGroupList.Value};
                    chosenPartDir = DataVectors_GUI.particleGroups.(currGroup).partDirList{chosenPartIdx};
                end
                
                chosenPartFOVidx = find(contains(DataVectors_GUI.dirlist, chosenPartDir));
                set(hlistready,'Value',chosenPartFOVidx);
                hselect_callback();
                figure(collageFig);
            end
            delete(findall(source.Parent,'Tag','recentSelection'));
            
            plot(event.IntersectionPoint(1),event.IntersectionPoint(2),'Color','k',...
                'MarkerSize',15,'Marker','*',...
                'tag','recentSelection','Parent',source.Parent);
            
            plot(event.IntersectionPoint(1),event.IntersectionPoint(2),'wx',...
                'MarkerSize',15,'tag','recentSelection','Parent',source.Parent);
            
        end
        
        %% >> Select Multiple Particles
        function SelectMultipleParticles(source, event)
            
            labelCollage = source.UserData;
            xyPOS = round(event.IntersectionPoint(1:2));
            partRow = xyPOS(2);
            partCol = xyPOS(1);
            chosenPartIdx = labelCollage(partRow,partCol);
            
            if chosenPartIdx > 0 & ~any(find(chosenPartIdx == DataVectors_GUI.particleGroups.tempParticleGroup))
                allSelections = findall(collageImageHandle.Parent,'Tag','recentSelection');    
                
                particleGroupName = erase(selectLabelName.String,' '); %making sure there are no spaces
                
                plot(event.IntersectionPoint(1),event.IntersectionPoint(2),'Color','k',...
                    'MarkerSize',15,'Marker','*',...
                    'tag','recentSelection','Parent',source.Parent);
                
                plot(event.IntersectionPoint(1),event.IntersectionPoint(2),'wx',...
                    'MarkerSize',15,'tag','recentSelection','Parent',source.Parent);
                
                DataVectors_GUI.particleGroups.tempParticleGroup = [DataVectors_GUI.particleGroups.tempParticleGroup, chosenPartIdx];
                
                figure(collageFig); %refocus to figure
            end
        end
        
        %% >> Backspace to delete most recent particle
        function removeLastSelected(source, event)
            
            switch event.Key
                case 'backspace'
                    allSelections = findall(collageImageHandle.Parent,'Tag','recentSelection');
                    if ~isempty(allSelections)
                        delete(allSelections(1:2)); %delete the first two selections since they both refer to one point.  The most recent object is first in the list
                        DataVectors_GUI.particleGroups.tempParticleGroup(end) = [];
                    end
            end
            
            
        end
        
        %% >> Save Particle Grouping
        function saveParticleGrouping_callback(source, event)
            particleGroupName = erase(selectLabelName.String,' '); %making sure there are no spaces
            
            saveAns = 'yes'; %initialize default
            if hasfield(DataVectors_GUI.particleGroups, particleGroupName)
                dialogueText = ['Replace Existing Group: ', particleGroupName, ' ?'];
                saveAns = inputdlg({dialogueText}, 'Confirm Replacement', [1,10],{'yes'});
            end
            
            if strcmpi(saveAns,'yes') & ~isempty(DataVectors_GUI.particleGroups.tempParticleGroup)
                DataVectors_GUI.particleGroups.(particleGroupName).particleIdx = sort(DataVectors_GUI.particleGroups.tempParticleGroup);
            end
            
            hdatavectorexport_callback();
            
            delete(findall(collageImageHandle.Parent,'Tag','recentSelection'));
            
            currGroupList = particleGroupList.String;
            particleGroupList.String = [currGroupList; {particleGroupName}];
            
        end
        
        %% >> Place Particle Group on list
        function placeParticleGrouping()
            
            if ~hasfield(DataVectors_GUI,'particleGroups')
                return;
            end
            
            foundCollageFig = findobj('Name','Particle Collage');
            imHandle = findall(foundCollageFig,'Type','image');
            delete(findall(imHandle.Parent,'Tag','recentSelection'));
            particleGroupList.Value = 1;
            particleGroupList.String = fieldnames(DataVectors_GUI.particleGroups);
            
            %particleGroupList_callback();
            
        end
        
%         %% >> Refresh Particle Group
%         function refreshParticleList_callback(~,~)
%             placeParticleGrouping()
%             
%         end
        
        %% >> Select Particle Group on List
        function particleGroupList_callback(source, event)
            groupNames = particleGroupList.String;
            groupVal = particleGroupList.Value;
            sampSize = round(str2double(collageSampleSize.String));
            if isnan(sampSize)
                sampSize = 'all';
            end
            
            delete(collageAxes);
            collageAxes = axes(collagePanel);
            PlotCollage_GUI(DataVectors_GUI.particleGroups.(groupNames{groupVal}),'Sample Size', sampSize);
            particleGroupList.UserData = 'group';
            
        end
        
        %% >> Display All Particles Again
        function displayAllParticles_callback(~,~)
            delete(collageAxes);
            collageAxes = axes(collagePanel);
            PlotCollage_GUI(DataVectors_GUI);
            particleGroupList.UserData = 'all';
            
        end
        
        %% >> close collageGUI fcn
        function closeParticleCollage(~,~)
            if hasfield(DataVectors_GUI.particleGroups, 'tempParticleGroup')
                DataVectors_GUI.particleGroups = rmfield(DataVectors_GUI.particleGroups,'tempParticleGroup');
            end
            
        end
        
        
    end

%% Export DataVectors to workspace
    function hdatavectorexport_callback(~,~)
        if hasfield(DataVectors_GUI.particleGroups, 'tempParticleGroup')
            DataVectors_GUI.particleGroups = rmfield(DataVectors_GUI.particleGroups,'tempParticleGroup');
        end
        DataVectors_GUI = SplitDVGroups(DataVectors_GUI);
        assignin('base','DataVectors', DataVectors_GUI);
        DataVectors_GUI.particleGroups.tempParticleGroup = [];
    end

%% Save As Particle Collection
    function hsaveASparticlecollection_callback(~,~)
        saveFilter = {'*.mat'};
        saveTitle = 'Save Particle Collection';
        saveDefault = 'TempParticleCollection';
        [newFileName, newFilePath] = uiputfile(saveFilter, saveTitle, saveDefault);
        
        if isequal(newFileName,0) || isequal(newFilePath,0)
            return;
        end
        
        % write file
        collectionSaveFile = fullfile(newFilePath, newFileName);
        SaveCollection(collectionSaveFile);
        hcollectionpath.String = collectionSaveFile;
        
        
    end

%% Save Particle Collection
    function hsaveparticlecollection_callback(~,~)
        currSaveFile = hcollectionpath.String;
        
        if isfile(currSaveFile) || isfolder(currSaveFile)
            SaveCollection(currSaveFile);
        else
            hsaveASparticlecollection_callback();
        end
    end
    
    function SaveCollection(saveFile)
        save(saveFile, 'DataVectors_GUI','Dataset', '-v7.3'); 
    end

%% Load Particle Collection
    function hloadparticlecollection_callback(~,~)
        collectionFile = uipickfiles('REFilter','\.mat');
        
        if ~iscell(collectionFile)
            return;
        end
        
        load(collectionFile{1},'DataVectors_GUI','Dataset');
        hcollectionpath.String = collectionFile{1};
        
        filedirs = DataVectors_GUI.dirlist;
        numdirs = length(filedirs);
        [displaydirs, dirtype] = deal(cell(1,numdirs));
        for i = 1:numdirs %looping through each selected directory
            [folderpath,foldername,~] = fileparts(filedirs{i}); %only picking the foldernames for brevity
            [folderpath_up1,foldername_up1,~] = fileparts(folderpath);
            [~,foldername_up2,~] = fileparts(folderpath_up1);
			
			% Different folder connectors for OS types
			if ispc()
				tempfiledir = strcat(filedirs{i},'\');
				fullfolders{i} = [foldername_up2,' \ ',foldername_up1,' \ ',foldername];
			elseif ismac()
				tempfiledir = strcat(filedirs{i},'/');
				fullfolders{i} = [foldername_up2,' / ',foldername_up1,' / ',foldername];
			end
			
			% Determining type of data set
			dirLabel = StackOrMap(tempfiledir);
			if strcmp(dirLabel,'map')
				dirtype{i} = 'map  ';
			elseif strcmp(dirLabel,'stack')
				dirtype{i} = 'stack';
            elseif strcmp(dirLabel, 'file')
                dirtype{i} = 'file';
			end
			
            displaydirs{i} = [dirtype{i},' ',fullfolders{i}];
			if isempty(displaydirs{i})
				displaydirs{i} = [displaydirs{i}, 'EMPTY'];
			end
        end
        
        set(hlistready,'String',displaydirs);
        set(hanalyze,'Enable','on');
        set(hremove,'Enable','on');
		set(haveragevariable,'Enable','on');
        hparticlecollage.Enable = 'on';
        hsaveparticlecollection.Enable = 'on';
        hsaveASparticlecollection.Enable = 'on';
        
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

%% stxmsort - hsort runs stxmsort on a single directory containing all stxm files
%pertaining to a single experiment
    function hsort_callback(~,~)
        stxmsort();
	end

%% hdatamerge runs the data merge routine, useful for when C and N data (for example) were taken as separate stacks/maps
	function hmerge_callback(~,~)
		MergingRawSTXMData();
	end

%% ------------------------------ hanalyze xxx ANALYSIS HERE xxx runs analysis scripts -------------------------------
	function hanalyze_callback(~,~)
		tic
		readydirs = get(hlistready,'String'); %get directory strings from leftmost (ready) list
		readylistval = get(hlistready,'Value');

		lreadydirs = length(readydirs);
		foldernames = cell(lreadydirs,1); %preallocation
		dirstorun = cell(lreadydirs,1); %preallocation
        
		filedirs = filedirs'; %this makes it nx1 which is not necessary but makes it easier to work with
		lfiledirs = length(filedirs);
		
		inorganiclist = get(hassumedinorgpopup,'String');
		inorganicval = get(hassumedinorgpopup,'Value');
		inorganic = inorganiclist{inorganicval};
		organiclist = get(hassumedorgpopup,'String');
		organicval = get(hassumedorgpopup,'Value');
		organic = organiclist{organicval};
		threshMethod_str = get(hthresholding_dropdown,'String');
		threshMethod_val = get(hthresholding_dropdown,'Value');
		threshMethod = threshMethod_str{threshMethod_val};
        SP2Thresh = str2num(get(hSP2Thresh_edit,'String'));
        
		
		loadobj = findobj('Tag','Load');
		set(loadobj(:),'Visible','off');
		
		set(hroutinepopup,'Value',2)
		set(hradiosingle,'Visible','on')
		set(hradiomultiple,'Visible','on')
		set(hpopupimages,'Visible','on');%,'Value',1)
		
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		
		if any(exist('sillystring','file'))
			hwait = waitbar(0,sillystring);
		else
			hwait = waitbar(0,'plz w8');
		end
		hwait.Name = ['Analyzing 1 of ', num2str(lfiledirs)];
		
		removelist = [];
		
		for j = 1:lfiledirs
			
			usesaveflag = get(husesaved,'Value');
			usesavedqcflag = get(hqcsaved,'Value');
            
            if isfolder(filedirs{j})
                currdir = dir(filedirs{j});
                
            elseif isfile(filedirs{j})
                [currFolder,currFile,currExt] = fileparts(filedirs{j});
                
                if contains(currExt,'.mat')
                    fovname{j} = [currFile(2:end), currExt]; %removing the 'F' in front of saved files
                    try 
                        loadedDataFolder = load(filedirs{j}, 'datafolder');
                        currdir = dir(loadedDataFolder.datafolder);
                    catch
                        currdir = dir(currFolder);
                    end
                    
                elseif contains(currExt,'.hdr') | contains(currExt,'.xim')
                    containingFolder = fullfile(fileparts(filedirs{j}),'..');
                    currdir = dir(containingFolder);
                end
            end
            
			for c = 1:length(currdir)
				hdridx = strfind(currdir(c).name,'.hdr');
				if ~isempty(hdridx)
					fovname{j} = currdir(c).name(1:hdridx-1);
                    currfov = ['FOV',fovname{j}];
					break
				end
			end
			
			%%% This should be a version check rather than checking for
			%%% "mapstest" which was relevant before but no longer
			try
                saveDataDir = [fullfile(currdir(1).folder, '..', ['F', fovname{j}])];
				mapstest = load(saveDataDir,'mapstest');
			catch
				disp(['no saved data for ' , fovname{j}]);
				usesaveflag = 0;
				usesavedqcflag = 0;
			end
			
			
            if usesaveflag == 1
                try
                    tempdataset = load(saveDataDir);
                    Dataset.(currfov).S = tempdataset.S;
                    Dataset.(currfov).Snew = tempdataset.Snew;
                    Dataset.(currfov).Mixing = tempdataset.Mixing;
                    Dataset.(currfov).Particles = tempdataset.Particles;
                    Dataset.(currfov).Directory = tempdataset.datafolder;
                    Dataset.(currfov).Snew.elements = tempdataset.Snew.elements;
                    Dataset.(currfov).Snew.RGBCompMap = tempdataset.Snew.RGBCompMap;
                    Dataset.(currfov).Snew.Maps = tempdataset.Snew.Maps;
                    Dataset.(currfov).Snew.LabelMat = tempdataset.Snew.LabelMat;
                    Dataset.(currfov).Snew.VolFrac = tempdataset.Snew.VolFrac;
                    Dataset.(currfov).Snew.Size = tempdataset.Snew.Size;
                    Dataset.(currfov).Snew.PartLabel = tempdataset.Snew.PartLabel;
                    Dataset.(currfov).Snew.CompSize = tempdataset.Snew.CompSize;
                    
                catch
                    usesaveflag = 0;
                    tempdataset = struct('Snew',[]);
                    
                end
                
                % Defaults
                Dataset.(currfov).binadjtest = 0;
                Dataset.(currfov).threshlevel = 2;
                Dataset.(currfov).savedbinmap = 0;
%                 Dataset.(currfov).inorganic = 'NaCl';
%                 Dataset.(currfov).organic = 'Sucrose';
                
                % Pulling numbers if already defined
                if hasfield(tempdataset, 'binadjtest',1)
                    Dataset.(currfov).binadjtest = tempdataset.binadjtest;
                end
                
                if hasfield(tempdataset, 'gamma',1)
                    Dataset.(currfov).threshlevel = tempdataset.Snew.gamma;
                end
                
                if hasfield(tempdataset, 'savedbinmap',1)
                    Dataset.(currfov).savedbinmap = tempdataset.savedbinmap;
                end
                
                if hasfield(tempdataset.Snew, 'OVFassumedinorg')
                    Dataset.(currfov).Snew.OVFassumedinorg = tempdataset.Snew.OVFassumedinorg;
                end
                
                if hasfield(tempdataset.Snew, 'OVFassumedorg')
                    Dataset.(currfov).Snew.OVFassumedorg = tempdataset.Snew.OVFassumedorg;
                end
            end
            
            
            if usesaveflag == 0 %dont use saved data
                
                threshlevel = 2; %supplying defaults
                binadjtest = 0;
                savedbinmap = 0;
                
                if usesavedqcflag == 1
                    try%%%%%%<<<<<<<<<<<<<<<<<<<<<< Need to enforce a standard of saving these three qc variables
                        threshlevel = load(saveDataDir,'threshlevel');
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
                        binadjtest = load(saveDataDir,'binadjtest');
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
                        savedbinmap = load(saveDataDir,'savedbinmap');
                        savedbinmapfieldnames = fieldnames(savedbinmap);
                        if isempty(savedbinmapfieldnames)
                            savedbinmap = 0;
                        else
                            savedbinmap = savedbinmap.(savedbinmapfieldnames{1});
                        end
                    catch
                        savedbinmap = 0;
                    end
                end
               
                disp(threshMethod);
                %-------------------------------%---------------------------------%--------------------------------------%--------------------------------------%%-------------------------------%---------------------------------%--------------------------------------%
                % [tempdataset] = MixingStatesforGUI(filedirs(j),'Gamma Level', threshlevel, 'Bin Adjust Flag', binadjtest, 'Bin Map', savedbinmap, 'inorganic',inorganic,'organic',organic, 'Thresh Method', threshMethod);                
                [currS, currSnew, currMixing, currParticles] = SingStackProcMixingStateOutputNOFIGS(filedirs{j},...
                    'inorganic',inorganic,...
                    'organic',organic,...
                    'Thresh Method',threshMethod,...
                    'Gamma Level', threshlevel,...
                    'sp2 Threshold', SP2Thresh,...
                    'Remove Pixel Size', 7,...
                    'Carbon SN Limit', 3,...
                    'SP2 SN Limit', 3,...
                    'Pre-edge SN Limit', 3,...
                    'PrePost SN Limit', 3,...
                    'Bin Map', savedbinmap,...
                    'Manual Binmap', binadjtest...
                    );
                tempdataset.(currfov).S = currS;
                tempdataset.(currfov).Snew = currSnew;
                tempdataset.(currfov).Mixing = currMixing;
                tempdataset.(currfov).Particles = currParticles;
                tempdataset.(currfov).Directory = filedirs{j};
                %-------------------------------%---------------------------------%--------------------------------------%--------------------------------------%%-------------------------------%---------------------------------%--------------------------------------%
                Dataset.(currfov) = tempdataset.(currfov);
                
            end
			
%             normPartSpec = cell(0);
%             nPart = max(max(Dataset.(currfov).Snew.LabelMat));
%             specmask = Dataset.(currfov).Snew.spectr .* Dataset.(currfov).Snew.binmap;
%             
%             if length(Dataset.(currfov).Snew.eVenergy) > 1 && Dataset.(currfov).Snew.elements.C == 1
%                 for p = 1:nPart
%                     
%                     % 		if length(normPartSpec) == 43
%                     % 			text = 1;
%                     % 		end
%                     
%                     currPartMask = zeros(size(Dataset.(currfov).Snew.binmap));
%                     currPartMask(Dataset.(currfov).Snew.LabelMat==p) = 1;
%                     specPartMask = specmask .* currPartMask;
%                     specPartMask(isinf(specPartMask)) = NaN;
%                     for k = 1:size(specPartMask,3)
%                         specPartMask(:,:,k) = medfilt2(specPartMask(:,:,k));
%                     end
%                     
%                     currPartSpec = squeeze(mean(mean(specPartMask,2,'omitnan'),1,'omitnan'));
%                     currPartSpec = currPartSpec - min(currPartSpec); %making sure values are only positive
%                     
%                     currEnergy = Dataset.(currfov).Snew.eVenergy;
%                     
%                     %Will be many copies of the same path, but will preserve particle identification for later
%                     inputds = [currEnergy, currPartSpec];
%                     [~, out2] = norm2poly_MF(6, inputds, 3, [260, 284, 300, 385]);
%                     % 		normPartSpec = [normPartSpec; STXMfit(currEnergy, currPartSpec)];
%                     normPartSpec = [normPartSpec; out2];
%                     
%                 end
%             end
%             Dataset.(currfov).Snew.ParticleSpec = normPartSpec;
            
			hwait.Name = ['Analyzing ', num2str(j+1),' of ', num2str(lfiledirs)];
			disp(j);
			waitbar(j/lfiledirs);
			
		end
		close(hwait);
		
		
		filedirs(removelist) = [];
		readydirs(removelist) = [];
		set(hlistready,'String',readydirs);
		
		
		if ~isempty(Dataset)
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
                currEleBox = get(heleboxlist{i},'String');
				if any(strcmp(currEleBox, currelements)) && currSnew.elements.(currEleBox)
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
		else
			disp('NO VALID DATA FOUND');
		end
		toc
	end

%% hselect dropdown menu
    function hselect_callback(~,~)
        routineval = get(hroutinepopup,'Value');
        routinestr = get(hroutinepopup,'String');
        
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
				currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
				try
					currDataInfo = {...
                        ['# Particles: ', num2str(currSnew.NumParticles)],...
                        ['Mean Size: ', num2str(mean(currSnew.Size,'omitnan'))],...
                        ['Mean Vol. Frac.: ', num2str(mean(currSnew.VolFrac,'omitnan'))],...
                        ['# Energies: ', num2str(length(currSnew.eVenergy))]};
					set(hdatainfo,'String',currDataInfo);
				catch
				end
                
                set(hplottitle,'String',Datasetnames{readyvalue});
                switch popupimagestr{popupimageval}
					case 'Data Summary'
						set(helementpanel,'Visible','on');
						DataSummary()
						
                    case 'Prepost Images'
                        set(helementpanel,'Visible','on');
                        set(rawbg,'Visible','off');
                        hprepost_callback();
                        
                    case 'Raw Images'
                        set(helementpanel,'Visible','off');
                        set(rawbg,'Visible','on');
                        currelements= fieldnames(currSnew.elements);
                        
                        %Making only buttons which have elemental data visible
                        flag = 0;
                        for i = 1:length(heleradlist)
                            currEleRad = get(heleradlist{i},'String');
                            if any(strcmp(currEleRad, currelements)) && currSnew.elements.(currEleRad)
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

                        radiomultipleval = get(hradiomultiple,'Value');
                        radiosingleval = get(hradiosingle,'Value');
                        
                        if radiomultipleval == 1
                            set(hpanelsingle,'Visible','off');
                            set(hpanelmultiple,'Visible','on');
                            oldmultiplot = findobj('Parent',hpanelmultiple);
                            delete(oldmultiplot);
                            
                            handle{1} = subplot(2,2,1);
                            Plot_RawIm(currSnew, 278);
                            set((handle{1}),'Parent',hpanelmultiple);
                            
                            handle{2} = subplot(2,2,2);
                            Plot_RawIm(currSnew, 320);
                            set((handle{2}),'Parent',hpanelmultiple);
                            
                            handle{3} = subplot(2,2,3);
                            set(handle{3},'Parent',hpanelmultiple);
                            Plot_OVF(currSnew);
                            
                            handle{4} =  subplot(2,2,4);
                            set(handle{4},'Parent',hpanelmultiple);
                            Plot_2DHistOVF(currSnew);
                            
                        elseif radiosingleval == 1
                            set(hpanelmultiple,'Visible','off')
                            set(hpanelsingle,'Visible','on')
                            delete(gca);
                            
                            axes('Units','normalized',...
                                'Position',[0.07,0.06,0.9,0.9],...
                                'Parent',hpanelsingle,'Tag','haxes',...
                                'HandleVisibility','on');
                            switch imageselectionvalue
                                case 1
                                    Plot_RawIm(currSnew, 278);
                                case 2
                                    Plot_RawIm(currSnew, 320);
                                case 3
                                    Plot_OVF(currSnew);
                                case 4
                                    Plot_2DHistOVF(currSnew);
                            end
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
                            set(handle1,'Parent',hpanelmultiple);
                            Plot_RawMean(currSnew);
                            
                            handle2 = subplot(2,2,2);
                            set(handle2,'Parent',hpanelmultiple);
                            Plot_LabelMat(currSnew);

                            handle3 = subplot(2,2,3);
                            set(handle3,'Parent',hpanelmultiple);
                            Plot_IZeroMask(currSnew);
                            
                            handle4 = subplot(2,2,4);
                            set(handle4,'Parent',hpanelmultiple);
                            Plot_Binmap(currSnew);

                            
                        elseif radiosingleval == 1
                            set(hpanelmultiple,'Visible','off')
                            set(hpanelsingle,'Visible','on')
                            delete(gca);
                            
                            axes('Units','normalized',...
                                'Position',[0.07,0.06,0.9,0.9],...
                                'Parent',hpanelsingle,'Tag','haxes',...
                                'HandleVisibility','on');
                            
                            switch imageselectionvalue
                                case 1
                                    Plot_RawMean(currSnew);
                                case 2
                                    Plot_LabelMat(currSnew);
                                case 3
                                    Plot_IZeroMask(currSnew);
                                case 4
                                    Plot_Binmap(currSnew);
                            end
                            
                        end
                        
                    case 'CarbonMaps Images'
                        set(helementpanel,'Visible','off');
                        set(rawbg,'Visible','off');
                        
                        if radiomultipleval == 1
                            handle1 = subplot(2,2,1);
                            set(handle1,'Parent',hpanelmultiple);
                            Plot_carb(currSnew);
                            
                            handle2 = subplot(2,2,2);
                            set(handle2,'Parent',hpanelmultiple);
                            Plot_prepost(currSnew);
                            
                            
                            handle3 = subplot(2,2,3);
                            set(handle3,'Parent',hpanelmultiple);
                            Plot_sp2(currSnew);
                            
                            handle4 = subplot(2,2,4);
                            set(handle4,'Parent',hpanelmultiple);
                            Plot_CMap(currSnew, handle4)

                        elseif radiosingleval == 1
                            set(hpanelmultiple,'Visible','off')
                            set(hpanelsingle,'Visible','on')
                            delete(gca);
                            
                            axes('Units','normalized',...
                                'Position',[0.07,0.06,0.9,0.9],...
                                'Parent',hpanelsingle,'Tag','haxes',...
                                'HandleVisibility','on');
                            
                            switch imageselectionvalue
                                case 1
                                    Plot_carb(currSnew);
                                case 2
                                    Plot_prepost(currSnew);
                                case 3
                                    Plot_sp2(currSnew);
                                case 4
                                    Plot_CMap(currSnew);
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
						histogram(currSnew.Size,[0:0.1:(max(currSnew.Size)+0.1)]);
                        
                    case 'Spectra Viewer'
                        set(hpanelmultiple,'Visible','off');
                        set(hpanelsingle,'Visible','on');
                        SpectraViewerCallback();
%                         readyvalue = get(hlistready,'Value');
%                         currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
%                         
%                         delete(gca);
%                         axes(...
%                             'Units','normalize',...
% 							'Position',[0.07,0.06,0.9,0.9],...
%                             'Parent',hpanelsingle,...
%                             'Tag','haxes',...
%                             'HandleVisibility','on');
%                         
%                         
%                         specidx = imageselectionvalue;
%                         plot(currSnew.eVenergy, currSnew.ParticleSpec{specidx});
                end
                
        end
    end

%% Controlling imageselectionvalue and selected FOV with keys/buttons
%hright and left adds/subtracts 1 to imageselectionvalue
    function hright_callback(~,~)
        %global imageselectionvalue
        if imageselectionvalue < 4
            imageselectionvalue = imageselectionvalue + 1;
        end
        hselect_callback();
    end

    function hleft_callback(~,~)
        %global imageselectionvalue
        if imageselectionvalue > 1
            imageselectionvalue = imageselectionvalue - 1;
        end
        hselect_callback();
    end

% keypressfcnfigure arrow key functions
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


%% hroutinepopupmenu switches routine callback
    function hroutinepopup_callback(source,~)
        str = get(source,'String');
        val = get(source,'Value');
        %change routine depending on selection
        radiosinglevalue = get(hradiosingle,'Value');
        radiomultiplevalue = get(hradiomultiple,'Value');
        switch str{val}
            case 'Load & Run Data'
                
                hnotloadstuff = findobj(...
                    'Tag','DataViewer',...
                    '-or','Tag','StackLab',...
                    '-or','Tag','QC');
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
        
        key = event.Key;
        
        if strcmp(popupstr{popupval}, 'Load & Run Data')
            switch key
                case 'delete'
                    hremove_callback()
            end
            
        elseif strcmp(popupstr{popupval},'Data Viewer')
            switch key
                case 'leftarrow'
                    hleft_callback();
                case 'rightarrow'
                    hright_callback();
                case 'g' | 't'
                    hmask_adjust_callback();
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
        switch popupstr{popupval}
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
        for i = 1:length(heleboxlist)
            currEleBox = get(heleboxlist{i},'String');
            if any(strcmp(currEleBox, currelements)) && currSnew.elements.(currEleBox)
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

%% Data Summary Plots
	function DataSummary()
        %%% Supressing repeated warnings
        id = 'MATLAB:ui:javacomponent:FunctionToBeRemoved';
        oldState = warning('query', id);
        restoreWarning = onCleanup(@() warning(oldState));
        warning('off', id)
        
		readyvalue = get(hlistready,'Value');
		currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
		currelements= fieldnames(currSnew.elements);
        
        eleToDisplay_List = get(hDataSummaryPrepostPlotSelection,'String');
        eleToDisplay_Val = get(hDataSummaryPrepostPlotSelection,'Value');
        eleToDisplay = eleToDisplay_List{eleToDisplay_Val};
		
		%Making only boxes which have elemental data visible
        nonzeroele = 0;
		for i = 1:length(heleboxlist)
            currEleBox = get(heleboxlist{i},'String');
			if any(strcmp(currEleBox, currelements)) && currSnew.elements.(currEleBox)
				set(heleboxlist{i},'Visible','on','Value',1);
				nonzeroele = currEleBox;
			else
				set(heleboxlist{i},'Visible','off', 'Value',0);
% 				if eleflagvec(i) == 1 %if a box is checked but there is no data, uncheck the box
% 					eleflagvec(i) = 0;
% 					set(heleboxlist{i},'Value',0);
% 				end
			end
		end
		
		%Making sure only 1 boxes can be checked at a time because I only want a
		%4x4 subplot, any more and you cant see much.
% 		if elenum == 1
% 			uncheckedboxes = findobj('Tag','DataViewer','-and','Value',0,'-and','Style','checkbox','-and','Parent',helementpanel);
% 			set(uncheckedboxes,'Enable','off');
% 		else
% 			allboxes = findobj('Tag','DataViewer','-and','Style','checkbox','-and','Parent',helementpanel);
% 			set(allboxes,'Enable','on');
% 		end
        Sval = get(hSulfurbox,'Value');
		Cval = get(hCarbonbox,'Value');
		Kval = get(hPotassiumbox,'Value');
		Caval = get(hCalciumbox,'Value');
		Nval = get(hNitrogenbox,'Value');
		Oval = get(hOxygenbox,'Value');
		eleflagvec = [Sval;Cval;Kval;Caval;Nval;Oval];
		totelefield = {'totS','TotC','totK','totCa','totN','totO'};
		
		elenum = Sval + Cval + Kval + Caval + Nval + Oval;
		checkedele = find(eleflagvec == 1);
		
		panelplots = findobj('Parent',hpanelmultiple);
		delete(panelplots);
		
%         set(hpanelmultiple,'Visible','on');
%         set(hpanelsingle,'Visible','off');
        
        if any(exist('tight_subplot','file'))
            subhandle = tight_subplot(2,3,[0.08, 0.05], [0.05, 0.05], [0.04,0.01]);
            set(subhandle, 'Parent',hpanelmultiple);
        else
            for subidx = 1:6
                subhandle(subidx) = subplot(2,3,subidx);
            end
        end
        
        % Axes 1
        axes(subhandle(1));
        if currSnew.elements.(eleToDisplay) == 1
            Plot_ElePrepost(currSnew,'Element',eleToDisplay);
        else
            Plot_ElePrepost(currSnew, 'Element',nonzeroele);
        end
%         imagesc([0,currSnew.Xvalue],[0,currSnew.Yvalue],currSnew.(totelefield{checkedele(1)}));
%         axis image
%         xlabel('X (\mum)');
%         ylabel('Y (\mum)');
%         colormap(subhandle(1),'parula');
%         title(totelefield{checkedele(1)});
%         colorbar;
        
        % Axes 2
        axes(subhandle(2));
        if currSnew.elements.C
            Plot_CMap(currSnew);
        end
        
        % Axes 3
        axes(subhandle(3));
        if currSnew.elements.C
            Plot_OVF(currSnew)
        end
        
        % Axes 4
        axes(subhandle(4));
        Plot_RawMean(currSnew);
        
        % Axes 5
        axes(subhandle(5));
        Plot_Binmap(currSnew);
        
        % Axes 6
        try
            axes(subhandle(6));
            Plot_2DHistOVF(currSnew);
        catch
            currSnew.Size
        end
		
        set(hpanelmultiple,'Visible','on');
        set(hpanelsingle,'Visible','off');
		
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

%% Control for SpectraViewer
    function SpectraViewerCallback()
        readyvalue = get(hlistready,'Value');
        specobjs = findobj('Tag','SpectraViewer');
        set(specobjs, 'Visible','on');
        currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
        
        delete(gca);
        axes(...
            'Units','normalize',...
            'Position',[0.07,0.06,0.9,0.9],...
            'Parent',hpanelsingle,...
            'Tag','haxes',...
            'HandleVisibility','on');
        
        image(uint8(currSnew.RGBCompMap));
        title('select particle to expand spectra');
        
        
    end

    function hSelectSpectra_callback(~,~)
        readyvalue = get(hlistready,'Value');
        roi = drawpoint();
        roipos = round(roi.Position);
        currSnew = Dataset.(Datasetnames{readyvalue}).Snew;
        currSnew = SpectraProcessing(currSnew);
        
        partnum = currSnew.LabelMat(roipos(2), roipos(1));
        
        if partnum == 0
            beep
            disp('Particle not included in binary mask');
            delete(roi);
            return
        end
        
        figure;
        plot(currSnew.eVenergy, currSnew.normOrgSpec{partnum});
        pfig;
        
    end

%% checking to make sure user wants to run raw data and destroy quality
%control measures
    function husesaved_callback(~,~)
        saveval = get(husesaved,'Value');
		
        if saveval == 0
            %rawdatacheck = inputdlg('Do you want to re-analyze raw data (yes/no)? Quality control measures may need to be re-done.','Re-run Raw Data?',1,{'yes'});
            set(htextcheck,'String','Re-analyzing raw data, quality control measures may need to be redone');
			set(hthresholding_dropdown,'Enable','on');
			set(hqcsaved,'Enable','on','Value',0);
			
		else
			set(htextcheck,'String',[]);
            set(hqcsaved,'Value',0,'Enable','off')
			set(hthresholding_dropdown,'Enable','off');
            
        end
        
        
    end

%% programming the "use saved QC data" checkbox
    function hqcsaved_callback(~,~)
        useqcval = get(hqcsaved,'Value');
        
    end


%% run and display EDXmap


%% run thresholding slider routine
    function hmask_adjust_callback(~,~)
        readyval = get(hlistready,'Value');
        Snew = Dataset.(Datasetnames{readyval}).Snew;
        S = Dataset.(Datasetnames{readyval}).S;
        specmean = mean(Snew.spectr,3);
        datafolder = Dataset.(Datasetnames{readyval}).Directory;
        
        if hasfield(Snew, 'gamma')
            beginningthreshlevel = Snew.gamma;
        else
            beginningthreshlevel = 2;
        end
        
        if hasfield(Snew, 'rmPixelSize')
            currSmallParticleVal = Snew.rmPixelSize;
        else
            currSmallParticleVal = 7;
        end
        
        if hasfield(Snew, 'strelSize')
            currStrelSize = Snew.strelSize;
        else
            currStrelSize = 30;
        end
        
        threshfig = figure(...
            'Units','normalized',...
            'Position',[0.1,0.2,0.7,0.6],...
            'KeyPressFcn',{@threshfig_callback});
        
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
            'Position',[0.05,0.18,0.9,0.04],...
            'Callback',{@hthreshslide_callback});
        
        hthreshtext = uicontrol(...
            'Style','text',...
            'Parent',threshfig,...
            'Units','normalized',...
            'String',['Gamma = ', num2str(beginningthreshlevel)],...
            'Position',[0.5,0.22,0.1,0.03]);
        
        hsavethresh = uicontrol(...
            'Style','pushbutton',...
            'Parent',threshfig,...
            'Units','normalized',...
            'String','Save Mask Threshold',...
            'Position',[0.1,0.22,0.1,0.07],...
            'Callback',{@hsavethresh_callback});
        
        hdefaultthresh = uicontrol(...
            'Style','pushbutton',...
            'Parent',threshfig,...
            'Units','normalized',...
            'String','Reset Thresh Value',...
            'Position',[0.3,0.22,0.1,0.07],...
            'Callback',{@hdefaultthresh_callback});
        
        hFineThreshControl = uicontrol('Style','checkbox','Parent',threshfig,...
            'Units','normalized','String','Fine Thresholding Control (x10)',...
            'Position',[0.7, 0.22, 0.1, 0.05],...
            'Callback',{@hFineThreshControl_callback});
        
        hSmallParticleRemoverSlide = uicontrol(...
            'Style','slider',...
            'Parent',threshfig,...
            'Units','normalized',...
            'Max',100,...
            'Value',currSmallParticleVal,...
            'Position',[0.05,0.1,0.9,0.04],...
            'Callback',{@hthreshslide_smallParticleRemover_callback});
        
        hSmallParticleText = uicontrol('Style','text', 'Parent',threshfig,'Units','normalized',...
            'Position',[0.5, 0.14, 0.1, 0.03],...
            'String',['Remove Small Particle Size = ', num2str(currSmallParticleVal)]);
        
        hStrelSlide = uicontrol('Style','Slider','Parent',threshfig,'Units','normalized','Max',100,'Value',currStrelSize,...
            'Position',[0.05, 0.01, 0.9, 0.04],...
            'Callback',{@hthreshslide_strelSlide_callback});
        
        hStrelSlideText = uicontrol('Style','text','Parent',threshfig','Units','normalized',...
            'Position',[0.5,0.065,0.1,0.03],...
            'String', ['Structuring Element Size = ', num2str(currStrelSize)]);
        
        %hSaveSmallParticle = uicontrol('Style','pushbutton','Parent',threshfig,'Units','normalized','String','Save Small Particle Value',...
        %    'Position',[0.1, 0.065, 0.1, 0.07],...
        %    'Callback',{@hSaveSmParticle_callback});
        
        
        plotimshowpair();
        
        function plotimshowpair()
            imshowpair(specmean,Snew.binmap,'Parent',figpairax,'method','montage');
        end
        
        function threshfig_callback(~,~)
            uicontrol(hthreshslide);
        end
        
        function hthreshslide_callback(~,~)
            currthreshval = get(hthreshslide,'Value');
            set(hthreshtext,'String',['Gamma = ', num2str(currthreshval)]);
            
            currSmallParticleVal = round(get(hSmallParticleRemoverSlide,'Value'),0);
            currStrelSize = round(get(hStrelSlide,'Value'),0);
            
            Snew = OdStack(S,...
                'Auto Gamma', 'no',...
                'Gamma Level', currthreshval,...
                'Remove Pixel Size', currSmallParticleVal,...
                'Strel Size', currStrelSize,...
                'Clear Binmap Border', false);
            
            plotimshowpair();
        end
        
        function hFineThreshControl_callback(~,~)
            fineControlCheck = get(hFineThreshControl,'Value');
            currthreshval = get(hthreshslide,'Value');
            
            if fineControlCheck
                set(hthreshslide,...
                    'Min', max(currthreshval - 1,0),...
                    'Max', currthreshval + 1);
            else
                set(hthreshslide,...
                    'Min', 0,...
                    'Max', 20);
            end
            
        end
        
        function hthreshslide_smallParticleRemover_callback(~,~)
            currSmallParticleVal = round(get(hSmallParticleRemoverSlide,'Value'),0);
            set(hSmallParticleText,'String',['Remove Small Particle Size = ', num2str(currSmallParticleVal)]);
            
            currthreshval = get(hthreshslide,'Value');
            currStrelSize = round(get(hStrelSlide,'Value'),0);
            
            Snew = OdStack(S,...
                'Auto Gamma', 'no',...
                'Gamma Level', currthreshval,...
                'Remove Pixel Size', currSmallParticleVal,...
                'Strel Size', currStrelSize,...
                'Clear Binmap Border', false);
            
            plotimshowpair();
        end
        
        function hthreshslide_strelSlide_callback(~,~)
            currStrelSize = round(get(hStrelSlide,'Value'),0);
            set(hStrelSlideText, 'String', ['Structuring Element Size = ', num2str(currStrelSize)]);
            
            currthreshval = get(hthreshslide, 'Value');
            currSmallParticleVal = round(get(hSmallParticleRemoverSlide,'Value'),0);
            
            Snew = OdStack(S,...
                'Auto Gamma', 'no',...
                'Gamma Level', currthreshval,...
                'Remove Pixel Size', currSmallParticleVal,...
                'Strel Size', currStrelSize,...
                'Clear Binmap Border', false);
            
            plotimshowpair();
        end
        
        function hdefaultthresh_callback(~,~)
            currthreshval = 2;
            set(hthreshslide,'Value',currthreshval);
            set(hthreshtext,'String',num2str(currthreshval));
            
            Snew = OdStack(S,...
                'Auto Gamma', 'no',...
                'Gamma Level', currthreshval,...
                'Clear Binmap Border', false);
            
            plotimshowpair();
        end
        
        function hsavethresh_callback(~,~)
            currthreshval = get(hthreshslide,'Value');
            Dataset.(Datasetnames{readyval}).threshlevel = currthreshval;
            S = Dataset.(Datasetnames{readyval}).S;
            currSmallParticleVal = round(get(hSmallParticleRemoverSlide,'Value'),0);
            currStrelSize = round(get(hStrelSlide,'Value'),0);
            
            manualIorecheck = inputdlg('maunally choose Io?','manual Io selection',1,{'no'});
            
            Snew = OdStack(S,...
                'Auto Gamma', 'no',...
                'Gamma Level', currthreshval,...
                'Remove Pixel Size', currSmallParticleVal,...
                'Strel Size', currStrelSize,...
                'Manual Io Check', manualIorecheck);

            Snew = energytest(Snew);
%             Snew = makinbinmap(Snew);
            
            
            if Snew.elements.C == 1
                Snew = CarbonMapsSuppFigs(Snew);

                Snew = DirLabelOrgVolFrac(Snew);
                
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
        datafolder = Dataset.(Datasetnames{readyval}).Directory;
        currthreshval = Snew.gamma;
        S = Dataset.(Datasetnames{readyval}).S;
        
        if hasfield(Snew, 'rmPixelSize')
            currSmallParticleVal = Snew.rmPixelSize;
        else
            currSmallParticleVal = 7;
        end
        
        Snew = OdStack(S,...
            'Auto Gamma', 'no',...
            'Gamma Level', currthreshval,...
            'Remove Pixel Size',currSmallParticleVal,...
            'Manual Binmap','yes',...
            'Clear Binmap Border', false);
        
        Snew = energytest(Snew);
        
        if Snew.elements.C == 1
            Snew = CarbonMapsSuppFigs(Snew);
            
            Snew = DirLabelOrgVolFrac(Snew);
            
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
        
        
        Dataset.(Datasetnames{readyval}).S = S;
        Dataset.(Datasetnames{readyval}).Snew = Snew;
        Dataset.(Datasetnames{readyval}).Mixing = Mixing;
        Dataset.(Datasetnames{readyval}).Particles = Particles;
        Dataset.(Datasetnames{readyval}).Directory = datafolder;
        hselect_callback();
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
        for kk = 1:length(prex_selected)
            text(prex_selected(kk),prey_selected(kk),numlabels{kk},...
                'VerticalAlignment','bottom',...
                'HorizontalAlignment','right',...
                'Color','r');
        end
        
        if exist('help_hdl','var') 
            close(help_hdl);
        end
        
        help_hdl2 = helpdlg('Choose pts with L-click, end with double-click, R-click, or enter.  Delete/backspace to go back');
        movegui(help_hdl2,'northwest')
        
        [postx_selected, posty_selected] = getpts(fpost);
        figure(fpost);
        
        if exist('help_hdl2','var')
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


%% Carbon Mixing State Button - -
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
			currthreshlevel = currSnew.gamma;
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
		
		
		[S_updated,Snew_updated,Mixing_updated,Particles_updated] = SingStackProcMixingStateOutputNOFIGS(datafolder,...
            'Gamma Level', currthreshlevel,...
            'Bin Adjust Flag',0,...
            'Bin Map', currSnew.binmap,...
            'inorganic', inorganic,...
            'organic',organic,...
            currS);
		%save(['../F',currS.particle],'Snew_updated','S_updated','Mixing_updated','Particles_updated','datafolder');
		hanalyze_callback();
	end

%% Control Multiple FOV Data Display ????????
	function hmultidistfxn_callback(~,~)
		
		
		
	end

%% Picking files but ensuring no duplicates
	function filedirs_in = pickFileDirs(filedirs_in)
		
		if nargin == 0
			filedirs_in = [];
		end
		
		% Making sure input filecell is a row vector
		if size(filedirs_in,1) > 1 && size(filedirs_in,2) == 1
			filedirs_in = filedirs_in';
		end
		startingDir = get(hStartingDir,'String');
        
		newfiledirs = uipickfiles('FilterSpec',startingDir,'REFilter','\.mat$|\.hdr','Append',filedirs_in);
		
        if ~iscell(newfiledirs) % If user presses cancel button
            return;
        end
		
        [~,~,fileExts] = fileparts(newfiledirs);
        matTest = contains(fileExts, '.mat');
        matIdxs = find(matTest);
        removeIdxs = [];
        for m = 1:sum(matTest)
            tempSnew = load(newfiledirs{matIdxs(m)},'Snew');
            tempMatLoad = load(newfiledirs{matIdxs(m)},'dirList');
            
            if ~isempty(fieldnames(tempSnew)) % the mat file is data
                %TODO
            elseif ~isempty(fieldnames(tempMatLoad)) % the mat file is a directory list          
                removeIdxs = [removeIdxs, m];
                for k = 1:length(tempMatLoad.dirList)
                    if isfolder(tempMatLoad.dirList{k})
                        newfiledirs = [newfiledirs, tempMatLoad.dirList{k}];
                    elseif isfile(tempMatLoad.dirList{k})
                        tempDataFolder = load(tempMatLoad.dirList{k},'datafolder');
                        newfiledirs = [newfiledirs, tempDataFolder.datafolder];
                    end
                end
%                 newfiledirs = [newfiledirs; tempMatLoad.dirList];
            end
            
        end
        newfiledirs(removeIdxs) = []; %directory lists are removed
        
		lnfdirs = length(newfiledirs);
		lofdirs = length(filedirs_in);
		remove_list = [];
		for n = 1:lnfdirs
			for o = 1:lofdirs
				if strcmp(newfiledirs{n},filedirs_in{o})
					remove_list = [remove_list, n];
				end
			end
		end
		newfiledirs(remove_list) = [];
		filedirs_in = [filedirs_in, newfiledirs];
		
    end

%% Plotting Functions --------------------------
%Cmap Plot      
    function Plot_CMap(Snew, varargin)
        CMapSilhouetteCheck = get(hCMapSilhouetteCheck,'Value');
        [varargin, axes_handle] = ExtractVararginValue(varargin, 'Axes Handle', gca);
        
        if Snew.elements.C ~= 1
            disp(['no C found for', Snew.particle]);
            return
        end
        
        MatSiz=size(Snew.LabelMat);
		Xvalue = Snew.Xvalue;
		Yvalue = Snew.Yvalue;
		XSiz=Xvalue/MatSiz(1);
		YSiz=Yvalue/MatSiz(2);
		xdat=(0:XSiz:Xvalue);
		ydat=(0:YSiz:Yvalue);
        
        if CMapSilhouetteCheck == 1
            Snew = CMapBackground(Snew);
            image(xdat, ydat, uint8(Snew.CMapSilhouette));
        else
            image(xdat, ydat, uint8(Snew.RGBCompMap));
        end
        title(sprintf('Red=sp2>%g%,Blue=pre/post>0.5,green=Organic',0.35));
		axis image
		xlabel('X (\mum)');
		ylabel('Y (\mum)');
         
    end
    
    function Plot_carb(Snew, varargin)
        if Snew.elements.C ~= 1
            return
            disp(['no C found for', Snew.particle]);
        end
        
        imagesc([0, Snew.Xvalue],[0,Snew.Yvalue],Snew.Maps(:,:,1));
        colormap gray
        colorbar
        axis image
        title('PostEdge-PreEdge');
        xlabel('X (\mum)');
        ylabel('Y (\mum)');
        
    end

    function Plot_prepost(Snew,varargin)
        if Snew.elements.C ~= 1
            return
        end
        
        imagesc([0,Snew.Xvalue],[0,Snew.Yvalue],Snew.Maps(:,:,2));
        colormap gray
        colorbar
        axis image
        set(gca,'Clim',[0,1.0])
        xlabel('X (\mum)');
        ylabel('Y (\mum)');
        title('PreEdge/PostEdge');
        
    end

    function Plot_ElePrepost(Snew, varargin)
        [varargin, elementSymbol] = ExtractVararginValue(varargin,'Element','C');
        eleFieldName = ['Tot', elementSymbol];
        try
            imagesc([0,Snew.Xvalue],[0,Snew.Yvalue],Snew.(eleFieldName));
        catch
            eleFieldName = ['tot', elementSymbol];
            imagesc([0,Snew.Xvalue],[0,Snew.Yvalue],Snew.(eleFieldName));
        end
        axis image
        xlabel('X (\mum)');
        ylabel('Y (\mum)');
        colormap('parula');
        title(eleFieldName);
        colorbar;
        
        xvec = linspace(0, Snew.Xvalue, size(Snew.ThickMap,2));
        yvec = linspace(0, Snew.Yvalue, size(Snew.ThickMap,1));
        CMapSilhouetteCheck = get(hCMapSilhouetteCheck,'Value');
        if CMapSilhouetteCheck == 1
            boundaries = bwboundaries(Snew.binmap,'noholes');
            hold on;
            for k = 1:length(boundaries)
                boundary = boundaries{k};
                plot(xvec(boundary(:,2)),yvec(boundary(:,1)),'Color','w','LineWidth',0.5);
            end
            hold off;
        end
    end
    
    function Plot_sp2(Snew, varargin)
        if Snew.elements.C ~= 1
            return
        end
        
        imagesc([0,Snew.Xvalue],[0,Snew.Yvalue],Snew.Maps(:,:,3));
        colormap gray
        set(gca,'Clim',[0,1.0])
        axis image
        xlabel('X (\mum)');
        ylabel('Y (\mum)');
        colorbar
        title('%sp^{2} Map')
    end

    function Plot_OVF(Snew, varargin)        
        if Snew.elements.C ~= 1
            return
        end
        imagesc([0,Snew.Xvalue],[0,Snew.Yvalue],Snew.ThickMap(:,:,end));
		axis image
		xlabel('X (\mum)');
		ylabel('Y (\mum)');
		colormap(gca,parula);
		title('Organic Vol Frac');
		colorbar;
        
        xvec = linspace(0, Snew.Xvalue, size(Snew.ThickMap,2));
        yvec = linspace(0, Snew.Yvalue, size(Snew.ThickMap,1));
        CMapSilhouetteCheck = get(hCMapSilhouetteCheck,'Value');
        if CMapSilhouetteCheck == 1
            boundaries = bwboundaries(Snew.binmap,'noholes');
            hold on;
            for k = 1:length(boundaries)
                boundary = boundaries{k};
                plot(xvec(boundary(:,2)),yvec(boundary(:,1)),'Color','w','LineWidth',0.5);
            end
            hold off;
        end
        
    end

    function Plot_2DHistOVF(Snew, varargin)
        if Snew.elements.C ~= 1
            return
        end
        
        edges{1} = linspace(0, max(Snew.Size), 20);
        edges{2} = linspace(0,1,20);
        [n, binctrs] = hist3([Snew.Size', Snew.VolFrac] ,'Edges',edges,'CDataMode','auto');
        xbindist = binctrs{1,1}(1,2)-binctrs{1,1}(1,1);
        ybindist = binctrs{1,2}(1,2)-binctrs{1,2}(1,1);
        xbinverts = binctrs{1,1}-xbindist;
        ybinverts = binctrs{1,2}-ybindist;
        
        imagesc(xbinverts, ybinverts, n');
        axis square
        xlabel('Particle Size (CED, \mum)');
        ylabel('Vol. Frac.');
        title('2D Histogram');
        set(gca,'YDir','normal');
        colormap(gca,plasma)
        colorbar        
        
    end

    function Plot_RawMean(Snew, varargin)
        xAxislabel = [0,Snew.Xvalue];
        yAxislabel = [0,Snew.Yvalue];
        for i = 1:length(Snew.eVenergy)
            stack(:,:,i) = Snew.Izero(i,2).*exp(-Snew.spectr(:,:,i)); %retreiving raw intensity information from OD info
        end
        imagebuffer=mean(stack,3);
        imagesc(xAxislabel,yAxislabel,imagebuffer);
        
        axis image
        colorbar
        title('Raw Intensity Stack Mean')
        colormap(gca,gray)
        xlabel(gca,'X Position (µm)')
        ylabel(gca,'Y Position (µm)')
        set(gca,'FontSize',11,'FontWeight','normal');
        
    end

    function Plot_LabelMat(Snew, varargin)
        ODLimitVal = get(hODlimitcheck,'Value');
        
        xAxislabel = [0,Snew.Xvalue];
        yAxislabel = [0,Snew.Yvalue];
        imagesc(xAxislabel, yAxislabel, Snew.LabelMat);
        colorbar
        if ODLimitVal == 1
            colormap(gca,graycmap);
            caxis([0,1.6]);
        else
            colormap(gca,gray);
        end
        
        axis image
        title('LabelMat');
        xlabel('X-Position (µm)')
        ylabel('Y-Position (µm)')
        set(gca,'FontSize',11,'FontWeight','normal');
        
    end

    function Plot_IZeroMask(Snew, varargin)
        xAxislabel = [0,Snew.Xvalue];
        yAxislabel = [0,Snew.Yvalue];
        imagesc(xAxislabel,yAxislabel,Snew.mask);
        colorbar
        colormap(gca,gray);
        axis image
        title('Izero Region Mask')
        xlabel('X-Position (µm)')
        ylabel('Y-Position (µm)')
        set(gca,'FontSize',11,'FontWeight','normal');

    end

    function Plot_Binmap(Snew, varargin)
        xAxislabel = [0,Snew.Xvalue];
        yAxislabel = [0,Snew.Yvalue];
        imagesc(xAxislabel,yAxislabel,Snew.binmap);
        colorbar
        colormap(gca,gray);
        axis image
        title('Visualization Binmap');
        xlabel('X-Position (µm)')
        ylabel('Y-Position (µm)')
        set(gca,'FontSize',11,'FontWeight','normal');
    end

    function Plot_RawIm(Snew, energy, varargin)
        ODLimitVal = get(hODlimitcheck, 'Value');
        
        [energyVal, energyIdx] = ClosestValue(Snew.eVenergy, energy, [energy-10, energy+10]);
        imagesc([0,Snew.Xvalue],[0,Snew.Yvalue],Snew.spectr(:,:,energyIdx))
        
        if ODLimitVal
            colormap(graycmap);
            caxis([0,1.6]);
        else
            colormap(gray);
        end
        plottitle=sprintf('%g eV',energyVal);
        title(plottitle);
        axis image
        xlabel('X (\mum)');
        ylabel('Y (\mum)');
        colorbar;
        
    end


%% Save and Load GUI Preferences
    function LoadGuiPreferences()
        guiPath_open = mfilename('fullpath');
        
        guiFolder_open = fileparts(guiPath_open);
        loadOptionsFilePath = fullfile(guiFolder_open, 'guiOptions.mat');
        
        if isfile(loadOptionsFilePath)
            load(loadOptionsFilePath,'guiOptions');
            set(hStartingDir,'String',guiOptions.startingDir);
            
            inorgList_open = get(hassumedinorgpopup,'String');
            orgList_open = get(hassumedorgpopup,'String');
            loadType_open = get(hloadtype,'String');
            loadTotEle_open = get(hDataSummaryPrepostPlotSelection,'String');
            
            try
                loadedInorgListVal = find(strcmp(inorgList_open, guiOptions.assumedInorg));
            catch
                guiOptions.assumedInorg = '(NH4)2SO4';
                loadedInorgListVal = find(strcmp(inorgList_open, guiOptions.assumedInorg));
            end
            
            try
                loadedOrgListVal = find(strcmp(orgList_open, guiOptions.assumedOrg));
            catch
                guiOptions.assumedOrg = 'adipic';
                loadedOrgListVal = find(strcmp(orgList_open, guiOptions.assumedOrg));
            end
            
            try
                loadedLoadType_open = find(strcmp(loadType_open, guiOptions.loadType));
            catch
                guiOptions.loadType = 'Load all (default)';
                loadedLoadType_open = find(strcmp(loadType_open, guiOptions.loadType));
            end
            
            try
                loadedTotEleDisplayVal = find(strcmp(loadTotEle_open, guiOptions.totEleDisplay));
            catch
                guiOptions.totEleDisplay = 'C';
                loadedTotEleDisplayVal = find(strcmp(loadTotEle_open, guiOptions.totEleDisplay));
            end
            
            set(hassumedinorgpopup,'Value',loadedInorgListVal);
            set(hassumedorgpopup,'Value',loadedOrgListVal);
            set(hloadtype,'Value',loadedLoadType_open);
            set(hDataSummaryPrepostPlotSelection,'Value',loadedTotEleDisplayVal); 
        end
        
    end

    function SaveGuiPreferences_callback(~,~)
        guiPath_close = mfilename('fullpath');
        
        guiFolder_close = fileparts(guiPath_close);
        
        startingDir = get(hStartingDir,'String');
        inorgList = get(hassumedinorgpopup,'String');
        inorgVal = get(hassumedinorgpopup,'Value');
        assumedInorg = inorgList{inorgVal};
        orgList = get(hassumedorgpopup,'String');
        orgVal = get(hassumedorgpopup,'Value');
        assumedOrg = orgList{orgVal};
        loadTypeList = get(hloadtype,'String');
        loadTypeVal = get(hloadtype,'Value');
        loadType = loadTypeList{loadTypeVal};
        
        dataSummaryTotEleDisplayList = get(hDataSummaryPrepostPlotSelection,'String');
        dataSummaryTotEleDisplayVal = get(hDataSummaryPrepostPlotSelection,'Value');
        totEleDisplay = dataSummaryTotEleDisplayList{dataSummaryTotEleDisplayVal};
        
        guiOptions.startingDir = startingDir;
        guiOptions.assumedOrg = assumedOrg;
        guiOptions.assumedInorg = assumedInorg;
        guiOptions.loadType = loadType;
        guiOptions.totEleDisplay = totEleDisplay;
        
        saveOptionsFilePath = fullfile(guiFolder_close, 'guioptions.mat');
        save(saveOptionsFilePath,'guiOptions','-v7.3')
    end

    function hStartingDirBroseButton_callback(~,~)
        selectedDir = uigetdir(pwd,'Select Starting Directory');
        hStartingDir.String = selectedDir;
    end

% ACE ENA Data
    function hACEENA_DirSwitch_callback(~,~)
        if isfolder('Z:\Google Drive\Projects\ACE-ENA\Data')
            set(hStartingDir, 'String', 'Z:\Google Drive\Projects\ACE-ENA\Data');
        else
            disp('<Z:\Google Drive\Projects\ACE-ENA\Data> does not exist');
        end
        
    end

    
%% run cleanup code when figure is closed
    function figureclose_callback(~,~)
        
        
        
        
        
        foundCollageFig = findobj('Name','Particle Collage');
        delete(foundCollageFig);
        clear('Dataset', 'DataVectors_GUI', 'filedirs', 'Datasetnames');
        clear global
        delete(f);
	end

end






















