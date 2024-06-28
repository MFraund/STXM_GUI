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
%_______________________________________________________
%% _______________Calculate Organic Cross Sections________

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

switch org
    case 'adipic'
        uorgpre=uad_pre;
        uorgpost=uad_post;
    case 'sucrose'
        uorgpre = usuc_pre;
        uorgpost = usuc_post;
    case 'glucose'
        uorgpre = ugluc_pre;
        uorgpost = ugluc_post;
    case 'tricarboxylic'
        uorgpre = uPropane123TriCarboxylicAcid_pre;
        uorgpost = uPropane123TriCarboxylicAcid_post;
    case 'pinonic'
        uorgpre = uPinonicAcid_pre;
        uorgpost = uPinonicAcid_post;
    case 'pinene'
        uorgpre = uPinene_pre;
        uorgpost = uPinene_post;
    case 'oxalic'
        uorgpre = uoxal_pre;
        uorgpost = uoxal_post;
end

%%_____________________________________________________________
%% ___________________Calculate Cross inorganic Sections________

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

switch inorg
    case 'NaCl'
        uinorgpre=inorgPre{6};
        uinorgpost=inorgPost{6};
    case '(NH4)2SO4'
        uinorgpre = inorgPre{1};
        uinorgpost = inorgPost{1};
    case 'NH4NO3'
        uinorgpre = inorgPre{2};
        uinorgpost = inorgPost{2};
    case 'NaNO3'
        uinorgpre = inorgPre{3};
        uinorgpost = inorgPost{3};
    case 'KNO3'
        uinorgpre = inorgPre{4};
        uinorgpost = inorgPost{4};
    case 'Na2SO4'
        uinorgpre = inorgPre{5};
        uinorgpost = inorgPost{5};
    case 'KCl'
        uinorgpre = inorgPre{7};
        uinorgpost = inorgPost{7};
    case 'Fe2O3'
        uinorgpre = inorgPre{8};
        uinorgpost = inorgPost{8};
    case 'CaCO3'
        uinorgpre = inorgPre{9};
        uinorgpost = inorgPost{9};
    case 'ZnO'
        uinorgpre = inorgPre{10};
        uinorgpost = inorgPost{10};
    case 'Pb(NO3)2'
        uinorgpre = inorgPre{11};
        uinorgpost = inorgPost{11};
    case 'Al2Si2O9H4'
        uinorgpre = inorgPre{12};
        uinorgpost = inorgPost{12};
end

end

