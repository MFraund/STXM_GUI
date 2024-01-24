function varargout = STACKLab(varargin)
% function STACKLAB(S) explores the stack standard struct S 
%
%
% STACKLAB M-file for STACKLab.fig

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @STACKLab_OpeningFcn, ...
                   'gui_OutputFcn',  @STACKLab_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before STACKLab is made visible.
function STACKLab_OpeningFcn(hObject, eventdata, handles, varargin)

% Define color table
handles.colorTable={'b','r','k','g','m','c'};

% Read input arguments
handles.S=varargin{1};

% read axis limits
handles.xAxislabel=[0,handles.S.Xvalue];
handles.yAxislabel=[0,handles.S.Yvalue];

% variable for gamma adjustment in StackViewer

handles.Gamma=1;

% Read usefull information about the stack
handles.eVlength=size(handles.S.spectr,3);
eVinit=floor(handles.eVlength/10)+1;
handles.eVmin=min(handles.S.eVenergy);
handles.eVmax=max(handles.S.eVenergy);

% Set eVSlider value to middle of stack, set Max and Min
set(handles.eVSlider,'Min',1);
set(handles.eVSlider,'Max',handles.eVlength);
set(handles.eVSlider,'Value',eVinit);
handles.sliderValue = eVinit;

% initialize StackViewer and SpecViewer
handles=initViewers(handles,eVinit,0);

% Choose default command line output for STACKLab
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = STACKLab_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function eVSlider_Callback(hObject, eventdata, handles) 

handles.sliderValue = ceil(get(handles.eVSlider,'Value')); % read slider Value

drawStackViewer(handles)

drawSpecViewer(hObject,handles,handles.sliderValue);

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function eVSlider_CreateFcn(hObject, eventdata, handles)

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in buttonNewROI.
function buttonNewROI_Callback(hObject, eventdata, handles)

axes(handles.StackViewer)
try 
    colorcounter=length(handles.specArray)+1;
catch
    colorcounter=1;
end

% Draw ROI, create binary ROI Mask
h=imfreehand;

if mod(colorcounter,6)~=0 % mod(colorcounter,6) is used to loop over the 6 colortable elements
    colorindex=mod(colorcounter,6);
else
    colorindex=1;
end
setColor(h,handles.colorTable{colorindex});  
Mask=createMask(h);

% Calculate average spectrum 
return_spec=averagespec(handles.S,Mask,handles.eVlength);
handles.specArray{length(handles.specArray)+1}=return_spec;
drawSpecViewer(hObject,handles,handles.sliderValue)

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in buttonReset.
function buttonReset_Callback(hObject, eventdata, handles)

handles.energyA=[];
handles.energyB=[];
handles.Gamma=1;
set(handles.gammaTextField,'String','1.00')

handles.sliderValue = ceil(get(handles.eVSlider,'Value')); % read slider Value
handles=initViewers(handles, handles.sliderValue,1);
set(handles.textEnergyB,'String',sprintf('Energy B ='))
set(handles.textEnergyA,'String',sprintf('Energy A ='))

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in buttonEnergyB.
function buttonEnergyB_Callback(hObject, eventdata, handles)

handles.energyB= ceil(get(handles.eVSlider,'Value')); % read slider Value
set(handles.textEnergyB,'String',sprintf('Energy B = %6.2f eV',handles.S.eVenergy(handles.energyB)))

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in buttonEnergyA.
function buttonEnergyA_Callback(hObject, eventdata, handles)

handles.energyA= ceil(get(handles.eVSlider,'Value')); % read slider Value
set(handles.textEnergyA,'String',sprintf('Energy A= %6.2f eV',handles.S.eVenergy(handles.energyA)))

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in buttonSubtract.
function buttonSubtract_Callback(hObject, eventdata, handles)

%uses TRY to prevent crash if energyA or energyB are not defined
try
    
    bufferA=handles.S.spectr(:,:,handles.energyA);
    bufferB=handles.S.spectr(:,:,handles.energyB);
    
    axes(handles.StackViewer)
    imagesc(handles.xAxislabel,handles.yAxislabel,(bufferA-bufferB))
    colormap(gray)
    xlabel('X-Position (µm)','FontSize',11,'FontWeight','normal')
    ylabel('Y-Position (µm)','FontSize',11,'FontWeight','normal')
    title(sprintf('Energy A - Energy B'),'FontSize',14,'FontWeight','bold')
    axis image
    colorbar
    
catch  % catches case energyA or EnergyB not defined
   
   % redraw StackViewer 
   drawStackViewer(handles)
    
end

% Update handles structure
guidata(hObject, handles);


% --- Function calculates binary mask for inital SpecViewer
function returnMask=initMask(V)

imagebuffer=mean(V,3); % Mean of total Stack is used to Produce initial mask
imagebuffer(imagebuffer<0)=0; % Filter negative values
imagebuffer=medfilt2(imagebuffer);
GrayImage=mat2gray(imagebuffer); % Turn into a greyscale with vals [0 1]
Thresh=graythresh(GrayImage); % Otsu thresholding
tempMask=im2bw(GrayImage,Thresh); % Give binary image

% labelMat=bwlabel(tempMask); %% Label connected regions in binary image
returnMask=bwlabel(tempMask); %% Label connected regions in binary image

% returnMask=zeros(size(tempMask)); % Mask used to note valid Fe rich areas who's pixels will be used in histogram
% numofparticles=max(max(labelMat));
% totnumofpixels=size(returnMask,1)*size(returnMask,2);

% Filtering of connected regions that are smaller than 0.5% of total image Area  
% for cnt=1:numofparticles
%             
%         [ytrue,xtrue]=find(labelMat==cnt);
%         linearind=sub2ind(size(returnMask),ytrue,xtrue);
%         
%         if length(linearind)>=0.005* totnumofpixels   %Areas bigger or equal to 1% of total image size are used for histogram 
%             
%             returnMask(linearind)=1;
%             
%         end
%         
% end

return


% --- Function to return average spectrum over region defined by binary Mask
function return_spec=averagespec(S,Mask,eVlength)

V=S.spectr;
return_spec=zeros(eVlength,2);
return_spec(:,1)=S.eVenergy;

% loop over energy range of stack, calculate average vor each energy -> return_spec
for cnt=1:eVlength
    
    buffer=V(:,:,cnt);
    return_spec(cnt,2)=mean(mean(buffer(Mask~=0)));
    clear buffer
   
end

return


% --- Function used to calculate plot limits for SpecViewer
function [SpecViewerMin,SpecViewerMax]=SpecViewerLimits(inputArray)

% init return values
SpecViewerMin=99;
SpecViewerMax=0;

for cnt=1:length(inputArray)
    
    if min(inputArray{cnt}(:,2)) < SpecViewerMin
        
        SpecViewerMin=min(inputArray{cnt}(:,2));
        
    end
    
    if max(inputArray{cnt}(:,2)) > SpecViewerMax
        
        SpecViewerMax=max(inputArray{cnt}(:,2));
        
    end
    
end

SpecViewerMax=1.05*SpecViewerMax;
SpecViewerMin=SpecViewerMin-0.05*SpecViewerMax;
return



% --- Function used to initialize StackViewer and SpecViewer after program start / reset
% RESET = 0 / 1, for RESET = 1: specArray is cleared, no average stack spec is displayed  
function handles=initViewers(handles,energyposition,RESET)

% draw StackViewer
drawStackViewer(handles)

% Calculate initial Mask for average stack spectrum
Mask=initMask(handles.S.spectr);
% Get initial spectrum of stack for initial SpecViewer
spec=averagespec(handles.S,Mask,handles.eVlength);
handles.specArray{1}=spec;

% Get SpecViewer plot limits
[SpecViewerMin,SpecViewerMax]=SpecViewerLimits(handles.specArray);

% Show initial SpecViewer
axes(handles.SpecViewer)

if RESET==1
    handles.specArray=[];
end

if RESET~=1
    t=plot(spec(:,1),spec(:,2));
    set(t,'HitTest','off')
    set(gca,'buttondownfcn',@mouseEvent);
    hold on
end


t=stem(spec(energyposition,1),spec(energyposition,2)+5,'r');
set(t,'HitTest','off')
xlim([handles.eVmin,handles.eVmax])
ylim([SpecViewerMin,SpecViewerMax])
xlabel('Photon energy (eV)','FontSize',11,'FontWeight','normal')
ylabel('Absorbance (OD)','FontSize',11,'FontWeight','normal')
hold off
set(gca,'buttondownfcn',@mouseEvent);

return


% --- Function used to redraw StackViewer
function drawStackViewer(handles)

% Display Stack view
axes(handles.StackViewer)

%Calculations for gamma adjustment
gammabuffer=handles.S.spectr(:,:,handles.sliderValue);

if handles.Gamma~=1
    gammabuffer=mat2gray(gammabuffer);
    gammabuffer=imadjust(gammabuffer,[],[],handles.Gamma);  %gamma corrected images are mapped between 0 and 1
end
    
imagesc(handles.xAxislabel,handles.yAxislabel,gammabuffer)
colormap(gray)
xlabel('X-Position (µm)','FontSize',11,'FontWeight','normal')
ylabel('y-Position (µm)','FontSize',11,'FontWeight','normal')
title(sprintf('E=%6.2f eV',handles.S.eVenergy(handles.sliderValue)),'FontSize',14,'FontWeight','bold')
axis image
colorbar


% --- Function used to draw updated SpecViewer
function drawSpecViewer(hObject,handles,energyposition)

axes(handles.SpecViewer)

%try has to be used to test if specArray exists
try
    % Get SpecViewer plot limits
    [SpecViewerMin,SpecViewerMax]=SpecViewerLimits(handles.specArray);
    
    % update SpecViewer by looping ofer all specArray elements (if specArray exists)
    for cnt=1:length(handles.specArray)
        
        if mod(cnt,6)~=0 % mod(colorcounter,6) is used to loop over the 6 colortable elements
            colorindex=mod(cnt,6);
        else
            colorindex=1;
        end
        
        t=plot(handles.specArray{cnt}(:,1),handles.specArray{cnt}(:,2),handles.colorTable{colorindex}); 
        set(t,'HitTest','off')
        hold on
        
    end
    
    t=stem(handles.specArray{1}(energyposition,1),handles.specArray{1}(energyposition,2)+5,'r');
    set(t,'HitTest','off')
    xlim([handles.eVmin,handles.eVmax])
    ylim([SpecViewerMin,SpecViewerMax])
    xlabel('Photon energy (eV)','FontSize',11,'FontWeight','normal')
    ylabel('Absorbance (OD)','FontSize',11,'FontWeight','normal')
    hold off
    set(gca,'buttondownfcn',@mouseEvent);
    
catch 
    
    % Calculate initial Mask for average stack spectrum
    Mask=initMask(handles.S.spectr);
    
    % Get initial spectrum of stack for initial SpecViewer
    spec=averagespec(handles.S,Mask,handles.eVlength);
    handles.specArray{1}=spec;  %handles.specArray is created temporarily (and cleared subsequently) for calculation of the plot limits etc.
    [SpecViewerMin,SpecViewerMax]=SpecViewerLimits(handles.specArray);
    
    t=stem(handles.specArray{1}(energyposition,1),handles.specArray{1}(energyposition,2)+5,'r');
    set(t,'HitTest','off')
    xlim([handles.eVmin,handles.eVmax])
    ylim([SpecViewerMin,SpecViewerMax])
    xlabel('Photon energy (eV)','FontSize',11,'FontWeight','normal')
    ylabel('Absorbance (OD)','FontSize',11,'FontWeight','normal')
    hold off
    clear handles.specArray
    set(gca,'buttondownfcn',@mouseEvent)
    
end

return


% --- StackViewer Gamma adjustment function  ( I'= I^(gamma), min and max are mapped to 0 and 1)
function gammaTextField_Callback(hObject, eventdata, handles)

handles.Gamma=str2double(get(hObject,'String'));

%update stackViewer
drawStackViewer(handles)

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function gammaTextField_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- executed on mouse click callback (when SpecViewer is clicked) - used to update eenrgy position
function mouseEvent(hObject, eventdata, handles)

%get gui data
handles=guidata(hObject);

%read mouse position
positionMat=get(gca,'Currentpoint');

%find index of next energy value in S.eVenergy
[tempval,eVpos]=min(abs(handles.S.eVenergy-positionMat(1,1)));

%redraw GUI with new energy position 
drawSpecViewer(hObject,handles,eVpos);
set(handles.eVSlider,'Value',eVpos);
handles.sliderValue = ceil(get(handles.eVSlider,'Value'));
drawStackViewer(handles);

% Update handles structure
guidata(hObject, handles);
return


% --- Executes on button press in saveSpec. Saves specs in handles.specArray as ASCII .txt files in current dir 
function saveSpec_Callback(hObject, eventdata, handles)

% get information from "Save as" dialogue
[filename, pathname] = uiputfile({'*.txt','ASCII (*.txt)'},'Save spectra as','STACKLab');

% catch case where user aborts save dialogue
if isequal(pathname,0) || isequal(filename,0)
    return
end

for cnt=1:length(handles.specArray)
    
    container=handles.specArray{cnt};
    save(fullfile(pathname,[filename(1:end-4),sprintf('_%s',num2str(cnt)),filename(end-3:end)]), 'container','-ASCII')
    clear container
    
end

% --- Function used to save SpecViewer and StackViewer content to .fig files
function saveToFig(viewerObj,ViewerName)

% get information from "Save as" dialogue
[filename, pathname] = uiputfile({'*.png','Figure (*.png)'},'Save axes object as',ViewerName);
 
% catch case where user aborts save dialogue
if isequal(pathname,0) || isequal(filename,0)
    return
end

% temporary figure tempFig is used to generate "stand-alone" figure that can be saved
tempFig=figure;

% get the units and position of the axes object
axes_units = get(viewerObj,'Units');
axes_pos = get(viewerObj,'Position');

% copy viewerObj to the temporary figure
viewerObj2 = copyobj(viewerObj,tempFig);

% correct alignment of the viewerObject2
set(viewerObj2,'Units',axes_units);
set(viewerObj2,'Position',[15 5 axes_pos(3) axes_pos(4)]);

set(viewerObj2,'ButtonDownFcn','');

% adjust the tempFigure content:
set(tempFig,'Units',axes_units);
set(tempFig,'Position',[15 5 axes_pos(3)+30 axes_pos(4)+10]);

% re-adjust colormap and re-create colorbar
if isequal(ViewerName,'StackViewer')
    colormap gray
    colorbar
end

%save  Viewer content to File & close the temporary figure
saveas(tempFig,[pathname filename]) 
close(tempFig)


% --- Executes on button press in StackViewerToFig.
function StackViewerToFig_Callback(hObject, eventdata, handles)
saveToFig(handles.StackViewer,'StackViewer')


% --- Executes on button press in SpecViewerToFig.
function SpecViewerToFig_Callback(hObject, eventdata, handles)
saveToFig(handles.SpecViewer,'SpecViewer')
