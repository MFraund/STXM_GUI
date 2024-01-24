function out=zymbol(in)
%ZYMBOL     Convert between atomic number and atomic symbol
%
%   Examples:   zymbol('Mn') gives 25.
%               zymbol(82)   gives 'Pb'.
%
% Tsu-Chien Weng, 2002-10-03
% Copyleft(c), the Penner-Hahn research group

row1='H He';
row2='LiBeB C N O F Ne';
row3='NaMgAlSiP S ClAr';
row4='K CaScTiV CrMnFeCoNiCuZnGaGeAsSeBrKr';
row5='RbSrY ZrNbMoTcRuRhPdAgCdInSnSbTeI Xe';
row6='CsBaLaCePrNdPmSmEuGdTbDyHoErTmYbLuHfTaW ReOsIrPtAuHgTlPbBiPoAtRn';
row7='FrRaAcThPaU NpPuAmCmBkCfEsFmMdNoLrRfDbSgBhHsMt';

periodicTable=[row1 row2 row3 row4 row5 row6 row7];
lastZ=length(periodicTable)/2;

if ischar(in)
    if length(in)==1, in=[in ' ']; end
    in=lower(in);
    in(1)=upper(in(1));
    atomicNumber=(findstr(in,periodicTable)-1)/2+1;
    out=atomicNumber;
elseif isnumeric(in)
    if in > lastZ, error('Check the atomic number.  It is too large.'), end
    atomicSymbol=periodicTable([2*in(:)-1 2*in(:)]);
    out=deblank(atomicSymbol);
else
    eval('help zymbol')
    error('Unrecognized argument format.')
end
