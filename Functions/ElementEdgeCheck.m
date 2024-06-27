function Sout = ElementEdgeCheck(filedir)


tempStruct = LoadStackRawMulti(filedir);

tempStruct = energytest(tempStruct);

Sout = tempStruct;






end