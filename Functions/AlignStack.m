% [S] = AlignStack(stack)
%
% Fourier transform method of aligning 2d images
%
% Inputs
% ======================
% Stack output (S) from LoadMultiHdr or similar
%
% Outputs
% ======================
% Same stack structure with any subtle shifts between stacks now corrected for
%
% Originally written by Tobias Henn 081010
% slightly modified by Matthew Fraund

function S=AlignStack(stack)

% 081010 Tobias Henn

S=stack;
stackcontainer=stack.spectr;

clear S.spectr

[ymax,xmax,emax]=size(stackcontainer);

xresolution=S.Xvalue/xmax;
yresolution=S.Yvalue/ymax;

center=ceil(emax/4*3);

spectr=zeros(ymax,xmax,emax);

shifts=zeros(emax,4);

%calculate image shifts for each energy,perform shift with FT method
%windowsize_y = round(ymax .* 0.15);
%windowsize_x = round(xmax .* 0.15);
%window_stackcontainer = stackcontainer(windowsize_y:end-windowsize_y, windowsize_x:end-windowsize_x,:);

for k=1:emax                      
    
    shifts(k,:)=dftregistration(fft2(stackcontainer(:,:,center)),fft2(stackcontainer(:,:,k)),50);
	%shifts_w(k,:)=dftregistration(fft2(window_stackcontainer(:,:,center)),fft2(window_stackcontainer(:,:,k)),50);
    spectr(:,:,k)=FTMatrixShift(stackcontainer(:,:,k),-shifts(k,3),-shifts(k,4));
    
end

%Reduce image size

shiftymax=ceil(max(shifts(:,3)));
shiftxmax=ceil(max(shifts(:,4)));
shiftymin=ceil(abs(min(shifts(:,3))));
shiftxmin=ceil(abs(min(shifts(:,4))));

shiftmatrix=zeros(ymax-shiftymin-shiftymax,xmax-shiftxmax-shiftxmin,emax);

shiftmatrix(:,:,:)=spectr((1+shiftymax):(ymax-shiftymin),(1+shiftxmax):(xmax-shiftxmin),:);

S.spectr=abs(shiftmatrix);

S.Xvalue=size(S.spectr,2)*xresolution;
S.Yvalue=size(S.spectr,1)*yresolution;

if isempty(S.spectr)
    errmsg = sprintf('%s',S.particle,' produces an error with AlignStack, \n unaligned structure returned instead\n');
    if any(exist('cprintf','file'))
        cprintf('UnterminatedStrings',errmsg);
    else
        disp(errmsg);
    end
    S = stack;
end

return