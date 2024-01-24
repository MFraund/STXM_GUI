function [a, mid, span]=unify(A,scale)
%UNIFY	transform [min(A), max(A)] to [-scale, +scale] columnwisely.
%		default range: [-1,1]
%
%	If the column vector is a constant one, copy the whole column.
%	(in avoid of NaN output)
%
%	Tsu-Chien Weng, 07/10/98
%	Copyleft (c) by the Penner-Hahn research group

[m,n]=size(A);
if m==1, n=1;A=A';end

for i=1:n
	mid(i)=(max(A(:,i))+min(A(:,i)))/2;
	span(i)=(max(A(:,i))-min(A(:,i)))/2;
	
	if(span == 0)
		a(:,i)=A(:,i);	% don't touch constant
	else
		a(:,i)=(A(:,i)-mid(i))/span(i);
	end
end

if m==1, A=A';end

if nargin == 2
	a=a*scale;
end
