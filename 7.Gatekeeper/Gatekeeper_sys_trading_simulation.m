
%% Description: Trade simulation for THE SYSTEM

%% load data
clc;clear;
dir='C:\Spectrion\Data\PriceData\Future_Generic\';
load(strcat(dir,'EquityData_RollT-1.mat'));
load(strcat(dir,'Bond10YData_RollT-1.mat'));
load(strcat(dir,'ComdtyData_RollT-1.mat'));
load(strcat(dir,'CurrencyData_RollT-1.mat'));
load Gatekeeper_Setting.mat 
load Gatekeeper_FamilySubsys.mat
%% Setup
AUM=500000;
Investment_ratio=1; % 1 means volatility target @0.2
gearlimit=15;% Gearing ratio limit (optimal @ 15)
model_version='version_Gatekeeper';

%% Mainbody
Interproduct_diversity_multiplier=2; %Fixed Value
% diversification multiplier (It is the diversification benefit from trading multiple instruments.)
%It is tuned result in order to match the final model volatility to be 20%;

vol_target=0.2*Investment_ratio;
listF={'SPX','DAX','CAC','NKY','HIA',...
    'USZC','UKZC','GERZC',...
    'WTI','Gold','Coffee'};
listSubsysdat=struct;
listSubsysdat.(listF{1})=EquityData.SPX;
listSubsysdat.(listF{2})=EquityData.DAX;
listSubsysdat.(listF{3})=EquityData.CAC;
listSubsysdat.(listF{4})=EquityData.NKY;
listSubsysdat.(listF{5})=EquityData.HIA;
listSubsysdat.(listF{6})=Bond10YData.USZC;
listSubsysdat.(listF{7})=Bond10YData.UKZC;
listSubsysdat.(listF{8})=Bond10YData.GERZC;
listSubsysdat.(listF{9})=ComdtyData.WTI;
listSubsysdat.(listF{10})=ComdtyData.Gold;
listSubsysdat.(listF{11})=ComdtyData.Coffee;

contract_size=[50 25 10 100 10 ...
    1000 1000 1000 ...
    500 10 37500]; 

timestamp=gatekeeper_setting.timestamp;
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
    xts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic123Price.(1)); %vlookup on timenum
    xmat(:,i)=xts(:,2);
    xretts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic12Return.(1)); %vlookup on timenum
    xretmat(:,i)=xretts(:,2);
    signalts=tsvlookup(timenum,datenum(subsys.timestamp,'dd/mm/yyyy'),subsys.Signal);
    signalmat(:,i)=signalts(:,2);
    volts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),smartMovingStd(subsysdat.Generic12Return.(1),25));
    volmat(:,i)=volts(:,2);
end


%% FX
curnyF={'USD','EURUSD','EURUSD','JPYUSD','HKDUSD',...
    'USD','GBPUSD','EURUSD',...
    'USD','USD','USD'};
curnydat.GBPUSD=CurrencyData.GBPUSD;
curnydat.EURUSD=CurrencyData.EURUSD;
curnydat.JPYUSD=CurrencyData.JPYUSD;

fxmat=NaN(size(timenum,1),size(curnyF,2));
for j=1:length(curnyF)
    ccy=curnyF{j};
    switch ccy
        case 'USD'
            fx=ones(size(timenum,1),1);
        case 'GBPUSD'
            fxsys=curnydat.GBPUSD;
            fx=tsvlookup(timenum,datenum(fxsys.timestamp,'dd/mm/yyyy'),fxsys.Generic123Price.(1));
            fx=fx(:,2);
        case 'EURUSD'
            fxsys=curnydat.EURUSD;
            fx=tsvlookup(timenum,datenum(fxsys.timestamp,'dd/mm/yyyy'),fxsys.Generic123Price.(1));
            fx=fx(:,2);
        case 'JPYUSD'
            fxsys=curnydat.JPYUSD;
            fx=tsvlookup(timenum,datenum(fxsys.timestamp,'dd/mm/yyyy'),fxsys.Generic123Price.(1));
            fx=fx(:,2);
        case 'HKDUSD'
            fx=0.1282.*ones(size(timenum,1),1);
             
    end
    fxmat(:,j)=fx;
end

%% Weights of portfolios
weightscheme=gatekeeper_setting.instrumentweighting;
weight=repmat([1/15 1/15 1/15 1/15 1/15 1/9 1/9 1/9 1/9 1/9 1/9],size(timestamp,1),1);
optwgt_lastday=size(weight,1); %Extend the last calculated optimal weighting to the lastest day
latestday=size(timenum,1);
if optwgt_lastday<latestday
    weight(optwgt_lastday+1:latestday,:)=repmat(weight(end,:),latestday-optwgt_lastday,1);
end
%% bidask spread
BAspread=gatekeeper_setting.BidAskSpread;
bidask_spread=[BAspread.SPX BAspread.DAX BAspread.CAC BAspread.NKY BAspread.HIA ...
    BAspread.USZC BAspread.UKZC BAspread.GERZC ...
    BAspread.WTI BAspread.Gold BAspread.Coffee];

%% Volatility
volmat(volmat==0)=NaN;

%% Trading simulation
gatekeeper= TradeSimT2(AUM,vol_target,contract_size,xmat,xretmat,signalmat,...
    volmat,fxmat,weight,Interproduct_diversity_multiplier,bidask_spread,gearlimit);

gatekeeper.timestamp=timestamp;
timeseriesplot(gatekeeper.vol,timestamp)

%% Output
gatekeeper.setting.gearing_limit=gearlimit;
gatekeeper.setting.investment_ratio=Investment_ratio;
gatekeeper.setting.AUM=AUM;

gatekeeper.description=model_version;
gatekeeper.timelog=datestr(now);

ftsdailypnl=fints(datenum(gatekeeper.timestamp,'dd/mm/yyyy'),gatekeeper.performance.cumpnl+1);
ftsmonthlypnl=tomonthly(ftsdailypnl);

gatekeeper.performance.monthlypnl=ftsmonthlypnl;
save(strcat('Gatekeeper_output_',model_version,'.mat'),'gatekeeper');

% writetable(table(datestr(ftsdailypnl.dates,'dd/mm/yyyy'),fts2mat(ftsdailypnl)),'Master version Performance.xlsx','Sheet','Daily','Range','A1');
% writetable(table(datestr(ftsmonthlypnl.dates,'dd/mm/yyyy'),fts2mat(ftsmonthlypnl)),'Master version Performance.xlsx','Sheet','Monthly','Range','B1');