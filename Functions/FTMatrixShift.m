%%% FTMatrixShift
% T R Henn
% SHifts matrix elements (non-integer shifts dx,dy are possible) 

function B=FTMatrixShift(A,dy,dx)

[Ny,Nx]=size(A);
rx = floor(Nx/2)+1; 
fx = ((1:Nx)-rx)/(Nx/2);
ry = floor(Ny/2)+1; 
fy = ((1:Ny)-ry)/(Ny/2);
px = ifftshift(exp(-1i*dx*pi*fx))';
py = ifftshift(exp(-1i*dy*pi*fy))'; 

[yphase,xphase]=meshgrid(py,px);

yphase=yphase.';
xphase=rot90(xphase);

B=abs(ifft2(fft2(A).*yphase.*xphase));

return