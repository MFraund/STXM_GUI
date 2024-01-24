function [x, Xabs]=norm2poly_MF(Z,energy_spec,n_th,range)
%NORM_POLY2	normalizes the raw data by extracting background function,
%			which is a polynomial with order N.
%
% [e, u] = norm_poly2(Z,fname, n, range)
%	e: energy
%	u: absorbance[cm^2/g]
%	Z=atomic number or symbol
%	fname='file_name'
%	n: order of polynomial
%	range=[pre_edge1, pre_edge2, post_edge1, post_edge2]
%
% Tsu-Chien Weng, 07/10/98
% Copyleft (c), by the Penner-Hahn research group

% 2008-12-15: a quick check on energy unit eV or keV

if nargin < 1, error('1st argument: atomic number or symbol.'),end
if nargin < 2, error('2nd argument: file name.'),end
if nargin < 3, n_th=2;end
if nargin < 4, range=[];end

if isstr(Z), Z=find_Z(Z);end

% eval(['load ' fname])
% fname=strtok(fname,'.');
% eval(['raw=' fname ';'])
% eval(['load ' fname '.TBL'])
% eval(['raw=' fname ';'])
% x=raw(:,1);		y=raw(:,2);
% if x(end)<100; x=x*1000; end    % convert eV to keV

x = energy_spec(:,1);
% x(x == 0) = eps; %Making sure no zeros exist
y = energy_spec(:,2);
% y(y==0) = eps;

load element
K_edge=element(Z).K_edge*1000;

if isempty(range)
	pre_edge1=x(1);
	pre_edge2=K_edge-18.4;		% K_edge -20eV
	post_edge1=K_edge+80;		% K_edge +80eV
	post_edge2=x(end);
elseif length(range) == 2,
    pre_edge1=x(1);
	pre_edge2=K_edge-range(1);
	post_edge1=K_edge+range(2);
    post_edge2=x(end);
elseif length(range) == 4,
	pre_edge1=range(1);
	pre_edge2=range(2);
	post_edge1=range(3);
	post_edge2=range(4);
	if ~(pre_edge1<pre_edge2 & pre_edge2<post_edge1 & post_edge1<post_edge2)
		error('The defined edge range should be asscend')
	end
else
    error('Check the energy range')
end
idx_pre=x>=pre_edge1 & x<=pre_edge2;
idx_post=x>=post_edge1 & x<=post_edge2;
pre1=length(x(x<=pre_edge1));
if pre1 == 0
    pre1 = 1;
end
pre2=length(x(x<=pre_edge2));
post1=length(x(x<=post_edge1));
post2=length(x(x<=post_edge2));

% Cross-section raw data
x_1=x(pre1:pre2);	
x_2=x(post1:post2); 
x_12=[x_1;x_2];

y_1=y(pre1:pre2);	
y_2=y(post1:post2); 
y_12=[y_1;y_2];


% McMaster data
% input energies should be in the unit of 'KeV'
mu=McMaster(Z,x_12/1000);               % ^^^^^


res = [mu(1:length(x_1)); polyval(polyfit(x_1, mu(1:length(x_1)), 1), x_2)];


mu=mu-res;

% transform to [-1,1]
[Nx_12,mid_x,span_x]=unify(x_12);	%Ne=(e-(max(e)+min(e))/2)/((max(e)-min(e))/2);
[Ny_12,mid_y,span_y]=unify(y_12);	%Ny=(y-(max(y)+min(y))/2)/((max(y)-min(y))/2);
[Nmu,mid_mu,span_mu]=unify(mu);		%Nmu=(mu-(max(mu)+min(mu))/2)/((max(mu)-min(mu))/2);

% Legendre polynomial
A=[Nmu, ones(length(x_12),1), Nx_12];		% default: 1st-order
for j=2:n_th
	A=[A, polyval(legpoly(j), Nx_12)];
end
B=Ny_12(:);

% Single-Value Decomposition
C=A\B;				% Euclidean norm with zero elements
%C=pinv(A)*B;		% Pseudo-inverse has minimum norm solution
%[U,S,V]=svd(A);	% Single-Value Decomposition


Nx=(x-mid_x)/span_x;
Ny=(y-mid_y)/span_y;
T=[ones(length(x),1), Nx];
for j=2:n_th
	T=[T, polyval(legpoly(j), Nx)];
end
bg=T*C(2:end);
Xabs=(Ny-bg)*span_mu/C(1)+mid_mu;
bg=bg*span_mu/C(1)+mid_mu;
plottingflag = 0;
if plottingflag ==1
    figAbs=figure('NumberTitle','off','Name','X-ray Absorbance');
%plot(x,Xabs,'.');
%plot(x,Xabs,raw(:,1),raw(:,3),'r.')

    plot(x,Xabs,x,mu,'c')
% plot(x,Xabs,raw(:,1),raw(:,3),'r.',x,mu,'c')
%plot(x,Xabs,x,mu,'c')
    xlabel('Energy, [eV]')
    ylabel('X-ray Absorption Coefficient, [cm^2/g]')
end

mu=McMaster(Z,x/1000);
res=[mu(mu<mu(end)); polyval(polyfit(x(mu<mu(end)),mu(mu<mu(end)),1),x(mu>=mu(end)))];
mu=mu-res;
% title(fname)
% title(strrep(fname,'_','-'))

normval = McMaster(Z, 0.2869);
Xabs = Xabs./normval;
% Xabs(isinf(Xabs)) = 0;

output=[x, Xabs, mu];
% eval(['save ' fname '.nrm  output -ascii'])
