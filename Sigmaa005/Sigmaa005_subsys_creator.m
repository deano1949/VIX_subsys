%% Description: To simulate all subsystems in one go.
%Model validation on the system with SPX and UKX only
%it validates mainly the trading simulations and signal generation parts of
%system.

%% Load data
load Sigmaa005_FamilySubsys.mat

dir='C:\Spectrion\Data\PriceData\Future_Generic\';
load(strcat(dir,'EquityData_RollT-1.mat'));
load(strcat(dir,'Bond10YData_RollT-1.mat'));
load(strcat(dir,'ComdtyData_RollT-1.mat'));
load(strcat(dir,'CurrencyData_RollT-1.mat'));
load('Sigmaa005_Setting.mat');

vol_target=setting.target_vol;
vol='';
blend_type='Boostrap';%'Boostrap' or 'Naive'

%% Generate Subsystem
%% Equity

%     %SPX
% 
%         dat=EquityData.SPX;
%         x=EquityData.SPX.Generic123Price.SP1_Index;
%         xret=EquityData.SPX.Generic12Return.G1ret;
%         x=ret2tick(xret,100);x=x(2:end);
%         bidask_spread=setting.BidAskSpread.SPX;
%         Subsystem_SPX=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
%         FamilySubsys.(strcat('Subsystem_SPX'))=Subsystem_SPX;
%         save Sigmaa005_FamilySubsys.mat FamilySubsys
%     
%     %UKX
% 
%         dat=EquityData.UKX;
%         x=dat.Generic123Price.(1);
%         xret=dat.Generic12Return.(1);
%         bidask_spread=setting.BidAskSpread.UKX;
%         Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
%         FamilySubsys.(strcat('Subsystem_UKX'))=Subsystem;
%         save Sigmaa005_FamilySubsys.mat FamilySubsys

    %CAC

        dat=EquityData.CAC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.CAC;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_CAC'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys
        
    %NKY

        dat=EquityData.NKY;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.NKY;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_NKY'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys

    %HIA

        dat=EquityData.HIA;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.HIA;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_HIA'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys

    %USZC

        dat=Bond10YData.USZC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.USZC;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_USZC'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys

    %UKZC

        dat=Bond10YData.UKZC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.UKZC;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_UKZC'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys

    %JPZC

        dat=Bond10YData.JPZC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.JPZC;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_JPZC'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys

    %GERZC

        dat=Bond10YData.GERZC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.GERZC;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_GERZC'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys

    %WTI

        dat=ComdtyData.WTI;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.WTI;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_WTI'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys

    %GOLD

        dat=ComdtyData.Gold;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.Gold;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_Gold'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys

    %Coffee

        dat=ComdtyData.Coffee;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.Coffee;
        Subsystem=Sigmaa005_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_Coffee'))=Subsystem;
        save Sigmaa005_FamilySubsys.mat FamilySubsys
        