 function [mu_tot, mu_xtr, mu_ph, mu_coh, mu_nch, info] = McMaster(Z, E, unit)
%MUCAL:	To calculate cross-sections using McMaster data
%		in May, 1969 edition.
%
%	barn=mucal(Z,E) return total x-section for the element Z
%	in unit of [cm^2/g]
%	xsec=mucal(Z,E,'b') return values in unit of [barns/atom]
%
%	Z:	atomic number of the element (Z_max=94)
%	E:	photon energy range for calculation, in KeV. 
%												^^^
%	Tsu-Chien Weng, 07/01/98
%	Copyleft, The Penner-Hahn research group

% 10/24/00: correction on L-edge jumps by T.-C.
% 2005-03-11: clean up, re-make element.mat using make_element.m

% status=warning;
% warning off

% set default values of atom type and energy range
Z_max=94;

if nargin < 1, eval('help McMaster'), error('Missing arguments'), end
if isstr(Z), Z=zymbol(Z); end
if nargin < 2, eval('help McMaster'), error('2nd argument: energies in KeV'), end
if nargin < 3, unit='c'; end

if Z < 0
	disp('The atomic number should be positive.')
elseif Z > Z_max
	disp('Your atom is too heavy.')
elseif Z==84 | Z==85 | Z==87 | Z==88 | Z==89 | Z==91 | Z==93,
	% They are Po, At, Fr, Ra, Ac, Pa, Np.
	disp('McMaster did NOT have it.')
else
	E=E(:);
	% all elements
	load element
	% total cross-section in unit of [barns/atom]
	% 1. Photo-Absorption:
    element(6).K_edge = 0.2869;
    idx_K  = ( E >= element(Z).K_edge );
    idx_L1 = ( E >= element(Z).L_edge(1) & E < element(Z).K_edge );
    idx_L2 = ( E >= element(Z).L_edge(2) & E < element(Z).L_edge(1) );
    idx_L3 = ( E >= element(Z).L_edge(3) & E < element(Z).L_edge(2) );
    idx_M  = ( E >= element(Z).M_edge    & E < element(Z).L_edge(3) );
    mu_ph = exp([ ...
        polyval(element(Z).post_M(4:-1:1),log(E(idx_M))); ...
        polyval(element(Z).post_L(4:-1:1),log(E(idx_L3|idx_L2|idx_L1))); ...
        polyval(element(Z).post_K(4:-1:1),log(E(idx_K)))]); 
    mu_ph(idx_L2) = mu_ph(idx_L2)/element(Z).L_jump(1);
    mu_ph(idx_L3) = mu_ph(idx_L3)/element(Z).L_jump(1)/element(Z).L_jump(2);
	% 2. Coherent scattering:
 	mu_coh = exp(polyval(element(Z).xsec_coh(4:-1:1),log(E)));
 	% 3. In-coherent scattering:
 	mu_nch = exp(polyval(element(Z).xsec_nch(4:-1:1),log(E)));
	mu_xtr= mu_coh + mu_nch;
    
	mu_tot = mu_ph + mu_xtr;

	switch unit
	case {'b','B'}
		% atomic absorption coefficient, in [barns/atom]
		; 
	case {'c','C'}
		% mass absorption coefficient, in [cm^2/g]
        mu_ph  = mu_ph /element(Z).m2a;
        mu_coh = mu_coh/element(Z).m2a;
        mu_nch = mu_nch/element(Z).m2a;
        mu_xtr = mu_xtr/element(Z).m2a;
        mu_tot = mu_tot/element(Z).m2a;
	otherwise
		% Default unit is [cm^2/g]
        mu_ph  = mu_ph /element(Z).m2a;
        mu_coh = mu_coh/element(Z).m2a;
        mu_nch = mu_nch/element(Z).m2a;
        mu_xtr = mu_xtr/element(Z).m2a;
        mu_tot = mu_tot/element(Z).m2a;
		disp(' ')
		disp('Using mass absorption coefficient, [cm^2/g]')
    end
    info = element(Z);
end

% warning(status)

