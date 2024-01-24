
function S=FTAlignStack(stack)
%function S=FTAlignStack(stack)
%
%Automated STXM stack alignment script. Alignes the stack images to the mean of 3 stack images 
%from the 3rd quarter of the stack. Image shifts for alignment are calculated using 
%Manuel Guizar's dftregistration script*).
%Non-integer pixel shifts are performed in Fourier space. Image regions that enter or
%leave the stack during the stack recording process are truncated, the stacks 
%horizontal and vertical axis lengths are updated.
%R.C. Moffet, T.R. Henn February 2009
%
%*)
% Manuel Guizar-Sicairos, Samuel T. Thurman, and James R. Fienup, 
% "Efficient subpixel image registration algorithms," Opt. Lett. 33, 
% 156-158 (2008).
%
%Inputs
%------
%stack          unaligned raw data stack structure array (typically the output of the 
%               LoadStackRaw.m script).
%
%Outputs
%-------
%S              structure array containing the aligned stack raw images and the
%               updated axis lengths

S=stack;
stackcontainer=stack.spectr;

clear S.spectr

[ymax,xmax,emax]=size(stackcontainer);

xresolution=S.Xvalue/xmax;
yresolution=S.Yvalue/ymax;

center=ceil(emax/4*3);

spectr=zeros(ymax,xmax,emax);

shifts=zeros(emax,4);

%calculate image shifts for each energy, perform shift with FT method

for k=1:emax                      
    
    shifts(k,:)=dftregistration(fft2(mean(stackcontainer(:,:,(center-1):(center+1)),3)),fft2(stackcontainer(:,:,k)),10);
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

return