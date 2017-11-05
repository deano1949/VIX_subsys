%% Description: To simulate all subsystems in one go.
%Model validation on the system with SPX and UKX only
%it validates mainly the trading simulations and signal generation parts of
%system.

%% Load data
load ModelVal_FamilySubsys.mat

dir='C:\Spectrion\Data\PriceData\Future_Generic\';
load(strcat(dir,'EquityData_RollT-1.mat'));
load(strcat(dir,'Bond10YData_RollT-1.mat'));
load(strcat(dir,'ComdtyData_RollT-1.mat'));
load(strcat(dir,'CurrencyData_RollT-1.mat'));
load('ModelVal_Setting.mat');

vol_target=setting.target_vol;
vol='';
blend_type='Boostrap';%'Boostrap' or 'Naive'

%% Generate Subsystem
%% Equity

    %SPX

        dat=EquityData.SPX;
        x=EquityData.SPX.Generic123Price.SP1_Index;
        xret=EquityData.SPX.Generic12Return.G1ret;
        x=ret2tick(xret,100);x=x(2:end);
        bidask_spread=setting.BidAskSpread.SPX;
        Subsystem_SPX=ModelVal_RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_SPX'))=Subsystem_SPX;
        save ModelVal_FamilySubsys.mat FamilySubsys
    
    %UKX

        dat=EquityData.UKX;
        x=dat.Generic123Price.(1);
        xret=dat.Generic12Return.(1);
        bidask_spread=setting.BidAskSpread.UKX;
        Subsystem=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type);
        FamilySubsys.(strcat('Subsystem_UKX'))=Subsystem;
        save ModelVal_FamilySubsys.mat FamilySubsys
