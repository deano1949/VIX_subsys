%% Description: To simulate all subsystems in one go.
%Model validation on the system with SPX and UKX only
%it validates mainly the trading simulations and signal generation parts of
%system.
clc;clear
%% Load data
addpath('C:\Users\gly19\Dropbox\GU\1.Investment\4. Alphas (new)\17.Extract_Rollyield\0.Research\VIX\dat');
load Gatekeeper_FamilySubsys.mat

dir='C:\Spectrion\Data\PriceData\Future_Generic\';
load(strcat(dir,'EquityData_RollT-1.mat'));
load(strcat(dir,'Bond10YData_RollT-1.mat'));
load(strcat(dir,'ComdtyData_RollT-1.mat'));
load(strcat(dir,'CurrencyData_RollT-1.mat'));
load('Gatekeeper_Setting.mat');

setting=gatekeeper_setting;
vol_target=setting.target_vol;
vol='';
blend_type='Naive';%'Boostrap' or 'Naive'

%% Generate Subsystem
%% Equity

    %SPX

        dat=EquityData.SPX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.SPX;
        Subsystem_SPX=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_SPX'))=Subsystem_SPX;
        save Gatekeeper_FamilySubsys.mat FamilySubsys
    
    %UKX

        dat=EquityData.UKX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.UKX;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_UKX'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys

    %DAX

        dat=EquityData.DAX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.DAX;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_DAX'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys
    
        %CAC

        dat=EquityData.CAC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.CAC;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_CAC'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys
        
    %NKY

        dat=EquityData.NKY;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.NKY;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_NKY'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys

    %HIA

        dat=EquityData.HIA;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.HIA;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_HIA'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys
%% Fixed Income (10 Years)
    %USZC

        dat=Bond10YData.USZC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.USZC;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_USZC'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys

    %UKZC

        dat=Bond10YData.UKZC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.UKZC;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_UKZC'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys

    %JPZC

        dat=Bond10YData.JPZC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.JPZC;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_JPZC'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys

    %GERZC

        dat=Bond10YData.GERZC;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.GERZC;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_GERZC'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys

%% Commodity
        
    %WTI

        dat=ComdtyData.WTI;
        x=dat.Generic123Price.(2);
        xret=dat.Generic12Return.(2);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.WTI;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_WTI'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys

    %GOLD

        dat=ComdtyData.Gold;
        x=dat.Generic123Price.(2);
        xret=dat.Generic12Return.(2);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.Gold;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_Gold'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys

    %Coffee

        dat=ComdtyData.Coffee;
        x=dat.Generic123Price.(2);
        xret=dat.Generic12Return.(2);
        x=ret2tick(xret,x(1));x=x(2:end);
        bidask_spread=setting.BidAskSpread.Coffee;
        Subsystem=Gatekeeper_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_Coffee'))=Subsystem;
        save Gatekeeper_FamilySubsys.mat FamilySubsys
        