
%% Description: Trade simulation for THE SYSTEM

%% load data
load SYS_beta_EQFI8AC.mat
load FamilySubsys.mat
loc='';
    if strcmp(loc,'C')
        dir='O:\langyu\Reading\Systematic_Trading_RobCarver\Futures Generic\';
        load(strcat(dir,'EquityData_RollT-1.mat'));
        load(strcat(dir,'Bond10YData_RollT-1.mat'));
        load(strcat(dir,'ComdtyData_RollT-1.mat'));
        load(strcat(dir,'CurrencyData_RollT-1.mat'));
        load('Setting.mat');
    else
        dir='C:\Spectrion\Data\AllData\Future_Generic\';
        load(strcat(dir,'EquityData_RollT-1.mat'));
        load(strcat(dir,'Bond10YData_RollT-1.mat'));
        load(strcat(dir,'ComdtyData_RollT-1.mat'));
        load(strcat(dir,'CurrencyData_RollT-1.mat'));
        load('Setting.mat');
    end

%% Setup
AUM=1000000;
vol_target=0.2;
listF={'SPX','DAX','NKY','UKX','USZC','GERZC','JPZC','UKZC'};
listSubsysdat=struct;
listSubsysdat.(listF{1})=EquityData.SPX;
listSubsysdat.(listF{2})=EquityData.DAX;
listSubsysdat.(listF{3})=EquityData.NKY;
listSubsysdat.(listF{4})=EquityData.UKX;
listSubsysdat.(listF{5})=Bond10YData.USZC;
listSubsysdat.(listF{6})=Bond10YData.GERZC;
listSubsysdat.(listF{7})=Bond10YData.JPZC;
listSubsysdat.(listF{8})=Bond10YData.UKZC;

contract_size=[50 5 100 10 1000 1000 1000 1000]; %dummy to be automate

timestamp=setting.timestamp;
timenum=datenum(timestamp,'dd/mm/yyyy');

xmat=NaN(size(timenum,1),size(listF,2));
xretmat=NaN(size(timenum,1),size(listF,2));
signalmat=NaN(size(timenum,1),size(listF,2));
volmat=NaN(size(timenum,1),size(listF,2));
perfmat=NaN(size(timenum,1),size(listF,2));

%subsystem
namefld=fieldnames(FamilySubsys);
for i=1:length(listF)
    subsysdat=listSubsysdat.(listF{i});
    subsysname=strcat('Subsystem_',listF{i});
    subsys=FamilySubsys.(subsysname);
    xts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic123Price.(2)); %vlookup on timenum
    xmat(:,i)=xts(:,2);
    xretts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic12Return.(2)); %vlookup on timenum
    xretmat(:,i)=xretts(:,2);
    signalts=tsvlookup(timenum,datenum(subsys.timestamp,'dd/mm/yyyy'),subsys.Signal);
    signalmat(:,i)=signalts(:,2);
    volts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),smartMovingStd(subsysdat.Generic12Return.(2),25));
    volmat(:,i)=volts(:,2);
    perfts=tsvlookup(timenum,datenum(subsys.timestamp,'dd/mm/yyyy'),subsys.performance.dailyreturn);
    perfmat(:,i)=perfts(:,2);
end
% sys.wgts=[0.25 0.3 0.2 0.25];
fx=repmat([1 1 1 1 1 1 1 1],size(timenum,1),1);
weight=sys.dailywgts; %instrument weights
% weight=sys.wgts;
diversifer=1;
bidask_spread=[setting.BidAskSpread.SPX setting.BidAskSpread.DAX setting.BidAskSpread.NKY setting.BidAskSpread.UKX ...
    setting.BidAskSpread.USZC setting.BidAskSpread.GERZC setting.BidAskSpread.JPZC setting.BidAskSpread.UKZC];


matt= TradeSimT2(AUM,vol_target,contract_size,xmat,xretmat,signalmat,...
    volmat,fx,weight,diversifer,bidask_spread);

matt.timestamp=timestamp;
timeseriesplot(matt.vol,timestamp)

%% Quick PNL
for l=1:size(sys.dailywgts,2)
    wgts=tsvlookup(timenum,sys.dailytimestamp,sys.dailywgts(:,l));
    WGT(:,l)=wgts(:,2);
end
daily_Total_PNL=sum(perfmat.*WGT,2);
daily_Total_PNL(isnan(daily_Total_PNL))=0;

FinalSySPerf.timestamp=datestr(wgts(:,1));
FinalSySPerf.dailyreturn=daily_Total_PNL;%
FinalSySPerf.cumpnl=cumprod(1+daily_Total_PNL)-1; %Accumulative PNL
FinalSySPerf.apr=prod(1+daily_Total_PNL).^(252/length(daily_Total_PNL))-1; %annualised returns since inception
FinalSySPerf.sharpe_aftercost=mean(daily_Total_PNL)*sqrt(252)/std(daily_Total_PNL); %sharpe ratio since inception
try
    FinalSySPerf.maxdd=maxdrawdown(100*cumprod(1+daily_Total_PNL)); %maxdrawdown since inception
catch
    FinalSySPerf.maxdd=NaN;
end
