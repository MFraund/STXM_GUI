function Particles = ParticlesInfo(Snew)

position = Snew.position;
xstep = position.xstep;
ystep = position.ystep;
xstepcm = xstep ./ 10000; %converting to cm
ystepcm = ystep ./ 10000;
pixelarea = ystepcm .* xstepcm;

Numparticles = max(max(Snew.LabelMat)); %total number of particles found

[row,column] = size(Snew.LabelMat); %row and column length of images, LabelMat chosen arbitrarily

Particles = struct('number', 1:Numparticles); %Defining structure
Particles.partmask = zeros(row,column,Numparticles); %preallocating matricies
Particles.Numparticles = Numparticles; %putting total number of particles into Particles struct
Particles.area = zeros(1,Numparticles);
Particles.AED = Particles.area;
Particles.NumComp = [];

%looping over number of particles and getting thickness of each component
%AND per particle
for i = 1:Numparticles
    z = zeros(row,column); %temporary matrix
    lindex = Snew.LabelMat == i; %picking out each particle to mess with separately
    z(lindex) = 1; %I DON'T THINK LINDEX IS CORRECT (THIS IS NOT NECESSARY I DON'T THINK)
    Particles.area(1,i) = sum(sum(z)).*pixelarea;
    Particles.partmask(:,:,i) = z;
end
Particles.AED = sqrt(4.*Particles.area./pi())*1000; %converting from cm to um
