
%% Description: To simulate all subsystems in one go.
%(very computational heavy and time consuming, think before run!)

%% selection dialog
listF={'SPX','VIX','WTI'};
[selection,ok]=listdlg('ListString',listF);
   
loc='';
if ok==1
%% Load data
load FamilySubsys.mat
    if strcmp(loc,'C')
        dir='O:\langyu\Reading\Systematic_Trading_RobCarver\Futures Generic\';
        load(strcat(dir,'EquityData.mat'));
        load(strcat(dir,'Bond10YData.mat'));
        load(strcat(dir,'ComdtyData.mat'));
        load('Setting.mat');
    else
        dir='C:\Spectrion\Data\AllData\Future_Generic\';
        load(strcat(dir,'EquityData.mat'));
        load(strcat(dir,'Bond10YData.mat'));
        load(strcat(dir,'ComdtyData.mat'));
        load('Setting.mat');
    end
    vol_target=setting.target_vol;
    vol='';
    blend_type='Naive';%'Boostrap' or 'Naive'

%% Generate Subsystem
    %SPX
    if ismember(1,selection) 
        dat=EquityData.SPX;
        x=EquityData.SPX.Generic123Price.SP1_Index;
        xret=EquityData.SPX.Generic12Return.G1ret;
        bidask_spread=0.0001;
        Subsystem_SPX=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{1}))=Subsystem_SPX;
        save FamilySubsys.mat FamilySubsys
    end
    %VIX
    if ismember(2,selection)
        dat=EquityData.VIX;
        x=EquityData.VIX.Generic123Price.UX2_Index;
        xret=EquityData.VIX.Generic12Return.G2ret;
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{2}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    %WTI
    if ismember(3,selection)
        dat=ComdtyData.WTI;
        x=ComdtyData.WTI.Generic123Price.CL2_Comdty;
        xret=ComdtyData.WTI.Generic12Return.G2ret;
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{3}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
end