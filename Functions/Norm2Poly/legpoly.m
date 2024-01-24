function P_n = legpoly(n)
% Legendre polynomial
% (n+1)*P_n+1(x) - (2n+1)*x*P_n(x) + n*P_n-1(x) = 0
%
% Tsu-Chien Weng, 07/16/98
% Copyleft (c), by the Penner-Hahn research group

% 2008-09-25: replace i with idx to avoid ambiguity

if n < 0, error('Not support negative integer!'); end
if (n-floor(n))~=0, error('Input argument should be an integer!');end
if n==0
	P_n=1;
elseif n==1
	P_n=[1 0];
else
	P_n2=1;
	P_n1=[1 0];
	for idx=2:n
		P_n=1/idx*((2*idx-1)*[P_n1 0]-(idx-1)*[0 0 P_n2]);
		P_n2=P_n1;
		P_n1=P_n;
	end
end
