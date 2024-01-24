function  [Snew]= CNOeleMaps(Snew)


%FIX THIS SECTION
% if abs(min(Snew.eVenergy - 278))-278 < 7 % 7 is an arbitrarily "close" value
%     if abs(min(Snew.eVenergy - 320))-320 < 7
%         errordlg('This is only the Carbon edge');
%     elseif abs(min(Snew.eVenergy - 352.5))-352.5 < 7
%         errordlg('This is the Carbon and Ca edge only');
%     elseif abs(min(Snew.eVenergy - 430))-430 < 7
%         errordlg('This includes the Carbon and Nitrogen edge only');
%     elseif abs(min(Snew.eVenergy - 550))-550 > 7
%         errordlg('This doesnt include the Oxygen postedge');
%     end
% else
%     errordlg('The Carbon pre-edge is missing');
% end



[preCenergy  ,idx278] = min(abs(Snew.eVenergy - 278  ));
[postCenergy ,idx320] = min(abs(Snew.eVenergy - 320  ));

if abs(min(Snew.eVenergy - 347)) < 5; %this looks for calcium energies but only if they exist
    [preCaenergy ,idx347] = min(abs(Snew.eVenergy - 347  ));
    [postCaenergy,idx353] = min(abs(Snew.eVenergy - 352.5));
end

[preNenergy  ,idx400] = min(abs(Snew.eVenergy - 400  ));
[postNenergy ,idx430] = min(abs(Snew.eVenergy - 430  ));
[preOenergy  ,idx525] = min(abs(Snew.eVenergy - 525  ));
[postOenergy ,idx550] = min(abs(Snew.eVenergy - 550  ));

%Carbon
carb = Snew.spectr(:,:,idx320) - Snew.spectr(:,:,idx278); %pre-post
carb(carb < 0) = 0; %removing negative values
carbIo = carb.*Snew.mask;
carbIostd = std(std(carbIo));
%carbLOD = 3.*carbIostd; %defining LOD just in case
carbLOQ = 10.*carbIostd;
carb = carb.*~Snew.mask; %removing Io region
carb = carb.*(carb > carbLOQ); %removing regions below LOQ

errcarb = Snew.errcarb;
errcarb = errcarb.*~Snew.mask;
errcarb = errcarb.*(carb > carbLOQ);
Snew.elemap.C = carb;
Snew.errmap.C = errcarb;

%Nitrogen
nitrogen = Snew.spectr(:,:,idx430) - Snew.spectr(:,:,idx400);
nitrogen(nitrogen < 0) = 0;
nitrogenIo = nitrogen.*Snew.mask;
nitrogenIostd = std(std(nitrogenIo));
%nitrogenLOD = 3.*nitrogenIostd;
nitrogenLOQ = 10.*nitrogenIostd;
nitrogen = nitrogen.*~Snew.mask;
nitrogen = nitrogen.*(nitrogen > nitrogenLOQ);

errnit = sqrt(Snew.errOD(:,:,idx430).^2 + Snew.errOD(:,:,idx400).^2);
errnit = errnit.*~Snew.mask;
errnit = errnit.*(nitrogen > nitrogenLOQ);
Snew.elemap.N = nitrogen;
Snew.errmap.N = errnit;

%Oxygen
oxygen = Snew.spectr(:,:,idx550) - Snew.spectr(:,:,idx525);
oxygen(oxygen < 0) = 0;
oxygenIo = oxygen.*Snew.mask;
oxygenIostd = std(std(oxygenIo));
%oxygenLOD = 3.*oxygenIostd;
oxygenLOQ = 10.*oxygenIostd;
oxygen = oxygen.*~Snew.mask;
oxygen = oxygen.*(oxygen > oxygenLOQ);

erroxy = sqrt(Snew.errOD(:,:,idx550).^2 + Snew.errOD(:,:,idx525).^2);
erroxy = erroxy.*~Snew.mask;
erroxy = erroxy.*(oxygen > oxygenLOQ);
Snew.elemap.O = oxygen;
Snew.errmap.O = erroxy;

% %colored
% rsize = size(Snew.Total.C,1);
% csize = size(Snew.Total.C,2);
% combined = zeros(rsize,csize);
% weight.C = zeros(rsize,csize);
% weight.N = zeros(rsize,csize);
% weight.O = zeros(rsize,csize);
% redc = zeros(rsize,csize);
% greenn = zeros(rsize,csize);
% blueo = zeros(rsize,csize);
% rgbmat = zeros(rsize,csize,3);
% 
% for i = 1:rsize
%     for j = 1:csize
%         combined(i,j) = Snew.Total.C(i,j) + Snew.Total.N(i,j) + Snew.Total.O(i,j);
%         weight.C(i,j) = Snew.Total.C(i,j)./combined(i,j);
%         weight.N(i,j) = Snew.Total.N(i,j)./combined(i,j);
%         weight.O(i,j) = Snew.Total.O(i,j)./combined(i,j);
%         redc(i,j) = weight.C(i,j).*255;
%         greenn(i,j) = weight.N(i,j).*255;
%         blueo(i,j) = weight.O(i,j).*255;
%     end
% end
% 
% rgbmat(:,:,1) = redc;
% rgbmat(:,:,2) = greenn;
% rgbmat(:,:,3) = blueo;
% 
% figure
% imagesc(uint8(rgbmat));


end

