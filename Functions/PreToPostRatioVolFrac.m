function [uorgpre,uorgpost,uinorgpre,uinorgpost]=PreToPostRatioVolFrac(inorg,org)
% All mass absorption coefficients are in units of cm^2/g

%% Inorganic Plot
%These values refer to carbon pre (278 eV) and post (320 eV) edge.
uc_pre=1932;
uc_post=39508;
un_pre=3729;
un_post=2527;
uo_pre=5972;
uo_post=4187;
uh_pre=454;
uh_post=288;
us_pre=47343;
us_post=36405;
una_pre=17682;
una_post=12447;
uk_pre=5689;
uk_post=47728;
ucl_pre=50183;
ucl_post=39398;
ufe_pre=16125;
ufe_post=12287;
uca_pre=6902;
uca_post=5437;
uzn_pre=24523;
uzn_post=19315;
upb_pre=10471;
upb_post=12670;
ual_pre=31584;
ual_post=22363;
usi_pre=37413;
usi_post=28313;
%%_______________________________________________________
%%_______________Calculate Organic Cross Sections________

uad_pre=(6*12*uc_pre+12*1*uh_pre+4*16*uo_pre)/...
    (6*12+12*1+4*16);%% adipic acid C6H12O4
uad_post=(6*12*uc_post+12*1*uh_post+4*16*uo_post)/...
    (6*12+12*1+4*16);

ugluc_pre=(6*12*uc_pre+12*1*uh_pre+6*16*uo_pre)/...
    (6*12+12*1+6*16);%% glucose C6H12O6
ugluc_post=(6*12*uc_post+12*1*uh_post+6*16*uo_post)/...
    (6*12+12*1+6*16);%% glucose C6H12O6

uoxal_pre=(2*12*uc_pre+2*1*uh_pre+4*16*uo_pre)/...
    (2*12+2*1+4*16);%% oxalic acid C2H2O4
uoxal_post=(2*12*uc_post+2*1*uh_post+4*16*uo_post)/...
    (2*12+2*1+4*16);%% oxalic acid C2H2O4

usuc_pre = (12.*12.*uc_pre + 22.*1.*uh_pre + 11.*16.*uo_pre) ./ (12.*12 + 22.*1 + 11.*16);
usuc_post = (12.*12.*uc_post + 22.*1.*uh_post + 11.*16.*uo_post) ./ (12.*12 + 22.*1 + 11.*16);

uPropane123TriCarboxylicAcid_pre = (12.*12.*uc_pre + 8.*1*uh_pre + 6.*16.*uo_pre) ./ (12.*12 + 8.*1 + 6.*16);
uPropane123TriCarboxylicAcid_post = (12.*12.*uc_post + 8.*1*uh_post + 6.*16.*uo_post) ./ (12.*12 + 8.*1 + 6.*16);

uPinonicAcid_pre = (10.*12.*uc_pre + 16.*1*uh_pre + 3.*16.*uo_pre) ./ (10.*12 + 16.*1 + 3.*16);
uPinonicAcid_post = (10.*12.*uc_post + 16.*1*uh_post + 3.*16.*uo_post) ./ (10.*12 + 16.*1 + 3.*16);

uPinene_pre = (10.*12.*uc_pre + 16.*1*uh_pre + 0.*16.*uo_pre) ./ (10.*12 + 16.*1 + 0.*16);
uPinene_post = (10.*12.*uc_post + 16.*1*uh_post + 0.*16.*uo_post) ./ (10.*12 + 16.*1 + 0.*16);

usoot_pre=uc_pre;
usoot_post=uc_post;

%%_____________________________________________________________
%%___________________Calculate Cross inorganic Sections________

inorgPre{1}=(2*14*un_pre+8*1*uh_pre+1*32*us_pre+4*16*uo_pre)...
    /(2*14+8*2+1*32+4*16); %% (NH4)2SO4
inorgPost{1}=(2*14*un_post+8*1*uh_post+1*32*us_post+4*16*uo_post)...
    /(2*14+8*2+1*32+4*16); %% (NH4)2SO4

inorgPre{2}=(2*14*un_pre+4*1*uh_pre+3*16*uo_pre)/...
    (2*14+4*1+3*16);%% NH4NO3
inorgPost{2}=(2*14*un_post+4*1*uh_post+3*16*uo_post)/...
    (2*14+4*1+3*16);%% NH4NO3

inorgPre{3}= (1*23*una_pre+1*14*un_pre+3*16*uo_pre)/...
    (1*23+1*14+3*16); %% NaNO3
inorgPost{3}=(1*23*una_post+1*14*un_post+3*16*uo_post)/...
    (1*23+1*14+3*16); 

inorgPre{4}= (1*39*uk_pre+1*14*un_pre+3*16*uo_pre)/...
    (1*23+1*14+3*16); %% KNO3
inorgPost{4}=(1*23*uk_post+1*14*un_post+3*16*uo_post)/...
    (1*23+1*14+3*16); 

inorgPre{5}= (2*23*una_pre+1*32*us_pre+4*16*uo_pre)/...
    (2*23+1*32+4*16); %% Na2SO4
inorgPost{5}=(1*23*una_post+1*32*us_post+4*16*uo_post)/...
    (1*23+1*32+4*16);

inorgPre{6}= (1*23*una_pre+1*35*ucl_pre)/(1*23+1*35); %% NaCl
inorgPost{6}=(1*23*una_post+1*35*ucl_post)/(1*23+1*35); 

inorgPre{7}= (1*39*uk_pre+1*35*ucl_pre)/(1*39+1*35); %% KCl
inorgPost{7}=(1*39*uk_post+1*35*ucl_post)/(1*39+1*35); 

inorgPre{8}= (2*56*ufe_pre+3*16*uo_pre)/(2*56+3*16); %% Fe203
inorgPost{8}=(2*56*ufe_post+3*16*uo_post)/(2*56+3*16);

inorgPre{9}=(1*40*uca_pre+1*12*uc_pre+3*16*uo_pre)/(1*40+1*12+3*16); %% CaCO3
inorgPost{9}=(1*40*uca_post+1*12*uc_post+3*16*uo_post)/(1*40+1*12+3*16);

inorgPre{10}=(1*65*uzn_pre+1*16*uo_pre)/(1*65+1*16); %% ZnO
inorgPost{10}=(1*65*uzn_post+1*16*uo_post)/(1*65+1*16); %% ZnO

inorgPre{11}=(1*207*upb_pre+2*14*un_pre+6*16*uo_pre)/(1*207+2*14+6*16); %% Pb(NO3)2
inorgPost{11}=(1*207*upb_post+2*14*un_post+6*16*uo_post)/(1*207+2*14+6*16); %% Pb(NO3)2

inorgPre{12}=(2*27*ual_pre+2*28*usi_pre+9*16*uo_pre+4*1*uh_pre)/(2*27+2*28+9*16+4*1); %% Al2Si2O9H4
inorgPost{12}=(2*27*ual_post+2*28*usi_post+9*16*uo_post+4*1*uh_post)/(2*27+2*28+9*16+4*1); %%Al2Si2O9H4

if strcmp(org,'adipic')==1
    uorgpre=uad_pre;
    uorgpost=uad_post;
elseif strcmp(org,'sucrose') == 1
    uorgpre = usuc_pre;
    uorgpost = usuc_post;
elseif strcmp(org,'tricarboxylic acid') == 1
	uorgpre = uPropane123TriCarboxylicAcid_pre;
	uorgpost = uPropane123TriCarboxylicAcid_post;
elseif strcmp(org,'pinonic acid') == 1
	uorgpre = uPinonicAcid_pre;
	uorgpost = uPinonicAcid_post;
elseif strcmp(org,'pinene') == 1
	uorgpre = uPinene_pre;
	uorgpost = uPinene_post;
end

if strcmp(inorg,'NaCl')==1
    uinorgpre=inorgPre{6};
    uinorgpost=inorgPost{6};
elseif strcmp(inorg,'(NH4)2SO4') == 1
    uinorgpre = inorgPre{1};
    uinorgpost = inorgPost{1};
elseif strcmp(inorg, 'CaCO3')
	uinorgpre = inorgPre{9};
	uinorgpost = inorgPost{9};
end

end
% speciesStr={'(NH_{4})_{2}SO_{4}','NH_{4}NO_{3}','NaNO_{3}','KNO_{3}',...
%     'Na_{2}SO_{4}','NaCl','KCl','Fe_{2}O_3','CaCO_{3}','ZnO','Pb(NO_{3})_{2}'...
%     'Al_{2}Si_{2}O_{5}(OH)_{4}'};
% 
% dens=[1.8,1.7,2.3,2.1,2.7,2.2,2.0,5.2,2.75,5.6,4.53,2.4];
% 
% colorstr={'r-','g-','b-','c-','m-','y-','k-','r-','g-','b-','c-','m-','y-','k-'}
% 
% figure,
% for i=1:7
%     thickrat=logspace(-2,2,100);
%     peakrat{i}=(inorgPre{i}*dens(i)+usoot_pre*2*thickrat)./...
%         (inorgPost{i}*dens(i)+usoot_post*2*thickrat);
%     semilogx(thickrat,peakrat{i},colorstr{i},'LineWidth',3),hold on,
% end
% hold off
% set(gca,'FontSize',18)
% xlabel('t_{soot}/t_{inorg}','FontSize',28)
% ylabel('h_{pre}/h_{post}','FontSize',28)
% legend(speciesStr,'FontSize',18)
% ylim([0,1.6])
% 
% figure,
% for i=1:7
%     thickrat=logspace(-2,2,100);
%     peakrat{i}=(inorgPre{i}*dens(i)+uad_pre*1.2*thickrat)./...
%         (inorgPost{i}*dens(i)+uad_post*1.2*thickrat);
%     semilogx(thickrat,peakrat{i},colorstr{i},'LineWidth',3),hold on,
% end
% hold off
% set(gca,'FontSize',18)
% xlabel('t_{adipic}/t_{inorg}','FontSize',28)
% ylabel('h_{pre}/h_{post}','FontSize',28)
% legend(speciesStr)
% legend(speciesStr,'FontSize',18)
% ylim([0,1.6])
% 
% figure,
% for i=1:7
%     thickrat=logspace(-2,2,100);
%     peakrat{i}=(inorgPre{i}*dens(i)+ugluc_pre*1.54*thickrat)./...
%         (inorgPost{i}*dens(i)+ugluc_post*1.54*thickrat);
%     semilogx(thickrat,peakrat{i},colorstr{i},'LineWidth',3),hold on,
% end
% hold off
% set(gca,'FontSize',18)
% xlabel('t_{glucose}/t_{inorg}','FontSize',28)
% ylabel('h_{pre}/h_{post}','FontSize',28)
% legend(speciesStr)
% legend(speciesStr,'FontSize',18)
% ylim([0,1.6])
% 
% figure,
% for i=1:7
%     thickrat=logspace(-2,2,100);
%     peakrat{i}=(inorgPre{i}*dens(i)+uoxal_pre*1.9*thickrat)./...
%         (inorgPost{i}*dens(i)+uoxal_post*1.9*thickrat);
%     semilogx(thickrat,peakrat{i},colorstr{i},'LineWidth',3),hold on,
% end
% hold off
% set(gca,'FontSize',18)
% xlabel('t_{oxalic acid}/t_{inorg}','FontSize',28)
% ylabel('h_{pre}/h_{post}','FontSize',28)
% legend(speciesStr)
% legend(speciesStr,'FontSize',18)
% ylim([0,1.6])
% 
% figure,
% for i=[8:12]
%     thickrat=logspace(-2,2,100);
%     peakrat{i}=(inorgPre{i}*dens(i)+uad_pre*1.2*thickrat)./...
%         (inorgPost{i}*dens(i)+uad_post*1.2*thickrat);
%     semilogx(thickrat,peakrat{i},colorstr{i},'LineWidth',3),hold on,
% end
% hold off
% set(gca,'FontSize',18)
% xlabel('t_{adipic}/t_{inorg}','FontSize',28)
% ylabel('h_{pre}/h_{post}','FontSize',28)
% cnt=1;
% for i=8:12
%     dstr{cnt}=speciesStr{i};
%     cnt=cnt+1;
% end
% legend(dstr)
% legend(dstr,'FontSize',18)
% ylim([0,1.6])
% 
% %% plot adipic/sea salt mixture fake spectrum 
% adipicmu=load('C:\RyanM_LBL\Milagro\MixingStatePaper\AnalChem\Figures\PreToPost\adipic_mu.txt');    
% naclmu=load('C:\RyanM_LBL\Milagro\MixingStatePaper\AnalChem\Figures\PreToPost\nacl_mu.txt');    
%     
% totalod=naclmu(:,2)*2.165*1e-5+adipicmu(:,2)*1.36*1e-5;    
% 
% figure1=figure,
% axes1 = axes('Parent',figure1,'FontSize',14);
% plot(naclmu(:,1),totalod,'k-','LineWidth',2),hold on,   
% plot([278,320],[totalod(naclmu(:,1)==278),totalod(naclmu(:,1)==320)],'kp','MarkerSize',15,'LineWidth',2)
% xlim([150,350]);
% ylim([0,1.5]);
% text(200,1.3,'Cl L-Edge','Color',[0,0,0],'FontSize',14)    
% text(285,1.20,'C K-Edge','Color',[0,0,0],'FontSize',14)    
% xlabel({'Energy (eV)'},'FontSize',16,'FontName','Arial');
% ylabel({'OD'},'FontSize',16,'FontName','Arial');
% annotation(figure1,'arrow',[0.5293 0.6151],[0.3505 0.5506]);
% annotation(figure1,'arrow',[0.6983 0.7776],[0.4141 0.5907]);
% annotation(figure1,'textbox',[0.4886 0.2905 0.08353 0.05618],...
%     'String',{'OD_{pre}'},...
%     'FontSize',14,...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'EdgeColor',[1 1 1]);
% annotation(figure1,'textbox',[0.6603 0.3547 0.08483 0.05457],...
%     'String',{'OD_{post}'},...
%     'FontSize',14,...
%     'FontName','Arial',...
%     'FitBoxToText','off',...
%     'EdgeColor',[1 1 1]);
%     
%     
%     
% 
% 
% 

