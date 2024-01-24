function Snew_out = CMapBackground(Snew_in,varargin)






[varargin, backgroundColorMap] = ExtractVararginValue(varargin,'Background Color', [255, 255, 255]*0.6);

sumRGBComp = sum(Snew_in.RGBCompMap,3);
binmap = Snew_in.binmap;
RGBComp1 = Snew_in.RGBCompMap(:,:,1);
RGBComp2 = Snew_in.RGBCompMap(:,:,2);
RGBComp3 = Snew_in.RGBCompMap(:,:,3);

back1 = binmap*backgroundColorMap(1);
back2 = binmap*backgroundColorMap(1);
back3 = binmap*backgroundColorMap(1);

back1(sumRGBComp>0) = RGBComp1(sumRGBComp>0);
back2(sumRGBComp>0) = RGBComp2(sumRGBComp>0);
back3(sumRGBComp>0) = RGBComp3(sumRGBComp>0);


CMapSilhouette = cat(3, back1, back2, back3);



Snew_out = Snew_in;
Snew_out.CMapSilhouette = CMapSilhouette;












end