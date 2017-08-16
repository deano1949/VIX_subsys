
%% Description: To simulate all subsystems in one go.
%(very computational heavy and time consuming, think before run!)

%% selection dialog
listF={'VIX','SPX','TSX','UKX','CAC','DAX','IBEX','MIB','AEX','OMX','SMI','NKY','HIA','AS51',...
    'Brent','Gasoil','WTI','UnlGasoline','HeatingOil','NatGas','Cotton','Coffee','Coca','Sugar',...
    'KanasaWheat','Corn','Wheat','LeanHogs','FeederCattle','LiveCattle','Gold','Silver','Aluminum',...
    'Nickel','Lead','Zinc','Copper',....
    'USZC','AUSZC','CAZC','GERZC','UKZC','JPZC'};
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
    blend_type='Boostrap';%'Boostrap' or 'Naive'

%% Generate Subsystem
%% Equity
    %VIX
    if ismember(1,selection)
        dat=EquityData.VIX;
        x=EquityData.VIX.Generic123Price.UX2_Index;
        xret=EquityData.VIX.Generic12Return.G2ret;
        x=ret2tick(xret,100);x=x(2:end);
        bidask_spread=0.001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{1}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
    %SPX
    if ismember(2,selection) 
        dat=EquityData.SPX;
        x=EquityData.SPX.Generic123Price.SP1_Index;
        xret=EquityData.SPX.Generic12Return.G1ret;
        x=ret2tick(xret,100);x=x(2:end);
        bidask_spread=0.0001;
        Subsystem_SPX=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{2}))=Subsystem_SPX;
        save FamilySubsys.mat FamilySubsys
    end
    
    %TSX
    if ismember(3,selection)
        dat=EquityData.TSX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.005;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{3}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end

    %UKX
    if ismember(4,selection)
        dat=EquityData.UKX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{4}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end

    %CAC
    if ismember(5,selection)
        dat=EquityData.CAC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{5}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
    %DAX
    if ismember(6,selection)
        dat=EquityData.DAX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.005;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{6}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
    %IBEX
    if ismember(7,selection)
        dat=EquityData.IBEX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{7}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
    %MIB
    if ismember(8,selection)
        dat=EquityData.FTSEMIB;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{8}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
    %AEX
    if ismember(9,selection)
        dat=EquityData.AEX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{9}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
    %OMX
    if ismember(10,selection)
        dat=EquityData.OMX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{10}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
    %SMI
    if ismember(11,selection)
        dat=EquityData.SMI;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{11}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
    %NKY
    if ismember(12,selection)
        dat=EquityData.NKY;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{12}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
    %HIA
    if ismember(13,selection)
        dat=EquityData.HIA;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{13}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end    
    
    %AS51
    if ismember(14,selection)
        dat=EquityData.AS51;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=0.0001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{14}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end

%% Commodity
    %WTI
    no=17;
    if ismember(no,selection)
        dat=ComdtyData.WTI;
        x=ComdtyData.WTI.Generic123Price.CL2_Comdty;
        xret=ComdtyData.WTI.Generic12Return.G2ret;
        x=ret2tick(xret,100);x=x(2:end);
        bidask_spread=0.001;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{no}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
%% Fixed Income 10Y Bonds
    %USZC
    no=38;
    if ismember(no,selection)
        dat=Bond10YData.USZC;
        %x=Bond10YData.USZC.Generic123Price.TY1_Comdty;
        xret=Bond10YData.USZC.Generic12Return.G1ret;
        x=ret2tick(xret,100);x=x(2:end);
        bidask_spread=0.0003;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_',listF{no}))=Subsystem;
        save FamilySubsys.mat FamilySubsys
    end
    
FamilySubsys.info.updated_date=datestr(now);
FamilySubsys.info.blended_method=blend_type;
FamilySubsys.info.vol_target=vol_target;
save FamilySubsys.mat FamilySubsys
end