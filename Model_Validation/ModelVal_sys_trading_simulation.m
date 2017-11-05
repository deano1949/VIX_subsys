
%% Description: Trade simulation for THE SYSTEM

%% load data

dir='C:\Spectrion\Data\PriceData\Future_Generic\';
load(strcat(dir,'EquityData_RollT-1.mat'));
load(strcat(dir,'Bond10YData_RollT-1.mat'));
load(strcat(dir,'ComdtyData_RollT-1.mat'));
load(strcat(dir,'CurrencyData_RollT-1.mat'));
load('ModelVal_Setting.mat');
load ModelVal_SYS.mat
load ModelVal_FamilySubsys.mat
%% Setup
AUM=500000;
vol_target=0.2;
listF={'SPX','UKX'};
listSubsysdat=struct;
listSubsysdat.(listF{1})=EquityData.SPX;
listSubsysdat.(listF{2})=EquityData.UKX;


contract_size=[50 1000]; %dummy to be automate

timestamp=setting.timestamp;
timenum=datenum(timestamp,'dd/mm/yyyy');


%% subsystem
xmat=NaN(size(timenum,1),size(listF,2));
xretmat=NaN(size(timenum,1),size(listF,2));
signalmat=NaN(size(timenum,1),size(listF,2));
volmat=NaN(size(timenum,1),size(listF,2));
namefld=fieldnames(FamilySubsys);
for i=1:length(listF)
    subsysdat=listSubsysdat.(listF{i});
    subsys=FamilySubsys.(namefld{i});
    xts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic123Price.(2)); %vlookup on timenum
    xmat(:,i)=xts(:,2);
    xretts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic12Return.(2)); %vlookup on timenum
    xretmat(:,i)=xretts(:,2);
    signalts=tsvlookup(timenum,datenum(subsys.timestamp,'dd/mm/yyyy'),subsys.Signal);
    signalmat(:,i)=signalts(:,2);
    volts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),smartMovingStd(subsysdat.Generic12Return.(2),25));
    volmat(:,i)=volts(:,2);
end


%% FX
curnyF={'USD','GBPUSD'};
curnydat.(curnyF{2})=CurrencyData.GBPUSD;
fxmat=NaN(size(timenum,1),size(curnyF,2));
for j=1:length(curnyF)
    ccy=curnyF{i};
    switch ccy
        case 'USD'
            fx=repmat([1 1 1 1],size(timenum,1),1);
        case 'GBPUSD'
            fx=1./tsvlookup(timenum,datenum(curnydat.timestamp,'dd/mm/yyyy'),curnydat.Generic123Price.(1));
    end
    fxmat(:,j)=fx;
end
%................................2017/11/04 23:33s
%% Weights of portfolios
sys.wgts=[0.25 0.3];
    
weight=repmat(sys.wgts,size(timenum,1),1); %instrument weights
% weight=sys.wgts;

%% diversification multiplier
diversifer=1;

%% bidask spread
bidask_spread=[0.0001 0.0003];%dummy to be automate
% bidask_spread=[0.000 0.000 0.000 0.000];%dummy to be automate

%% Volatility
volmat(volmat==0)=NaN;

%% Trading simulation
matt= TradeSimT2(AUM,vol_target,contract_size,xmat,xretmat,signalmat,...
    volmat,fx,weight,diversifer,bidask_spread);

matt.timestamp=timestamp;
timeseriesplot(matt.vol,timestamp)

%% Output
