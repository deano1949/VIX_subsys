
%% Description: Trade simulation for THE SYSTEM

%% load data
addpath('C:\Users\gly19\Dropbox\GU\1.Investment\4. Alphas (new)\17.Extract_Rollyield\0.Research\VIX\dat\Sigmaa005')
dir='C:\Spectrion\Data\PriceData\Future_Generic\';
load(strcat(dir,'EquityData_RollT-1.mat'));
load(strcat(dir,'Bond10YData_RollT-1.mat'));
load(strcat(dir,'ComdtyData_RollT-1.mat'));
load(strcat(dir,'CurrencyData_RollT-1.mat'));
load('Sigmaa005_Setting.mat');
load Sigmaa005_SYS.mat
load Sigmaa005_FamilySubsys.mat
%% Setup
AUM=100000000;
vol_target=0.1;
listF={'SPX','UKX','CAC','NKY','HIA',...
    'USZC','UKZC','GERZC','JPZC',...
    'WTI','Gold','Coffee'};
listSubsysdat=struct;
listSubsysdat.(listF{1})=EquityData.SPX;
listSubsysdat.(listF{2})=EquityData.UKX;
listSubsysdat.(listF{3})=EquityData.CAC;
listSubsysdat.(listF{4})=EquityData.NKY;
listSubsysdat.(listF{5})=EquityData.HIA;
listSubsysdat.(listF{6})=Bond10YData.USZC;
listSubsysdat.(listF{7})=Bond10YData.UKZC;
listSubsysdat.(listF{8})=Bond10YData.GERZC;
listSubsysdat.(listF{9})=Bond10YData.JPZC;
listSubsysdat.(listF{10})=ComdtyData.WTI;
listSubsysdat.(listF{11})=ComdtyData.Gold;
listSubsysdat.(listF{12})=ComdtyData.Coffee;

contract_size=[50 1000 10 100 10 ...
    1000 1000 1000 100000 ...
    500 10 37500]; %dummy to be automate

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
curnyF={'USD','GBPUSD','EURUSD','JPYUSD','HKDUSD',...
    'USD','GBPUSD','EURUSD','JPYUSD',...
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
weight=sys.dailywgts;

%% diversification multiplier
diversifer=2;

%% bidask spread
BAspread=setting.BidAskSpread;
bidask_spread=[BAspread.SPX BAspread.UKX BAspread.CAC BAspread.NKY BAspread.HIA ...
    BAspread.USZC BAspread.UKZC BAspread.GERZC BAspread.JPZC ...
    BAspread.WTI BAspread.Gold BAspread.Coffee];

%% Volatility
volmat(volmat==0)=NaN;

%% Gearing ratio limit
gearlimit=4;
%% Trading simulation
matt= TradeSimT2(AUM,vol_target,contract_size,xmat,xretmat,signalmat,...
    volmat,fxmat,weight,diversifer,bidask_spread,gearlimit);

matt.timestamp=timestamp;

%% Output
matt.description='sigma005 constrainted version with gearing ratio limit capped at 2';
matt.timelog=datestr(now);

save 'sigma005_constrainted_output.mat' 'matt'