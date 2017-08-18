
%% Description: Trade simulation for THE SYSTEM
%This test file to test the "Master_sys_trading_simulation" script on VIX carry signal. It ensures the end-to-end trading simulation is 100% accurate

%% load data
load SYS_beta.mat
load FamilySubsys.mat
loc='C';
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


%% Setup
AUM=1000000;
vol_target=0.2;
listF={'VIX'};
listSubsysdat=struct;
listSubsysdat.(listF{1})=EquityData.VIX;
contract_size=[1000]; %dummy to be automate

timestamp=setting.timestamp;
timenum=datenum(timestamp,'dd/mm/yyyy');

xmat=NaN(size(timenum,1),size(listF,2));
xretmat=NaN(size(timenum,1),size(listF,2));
signalmat=NaN(size(timenum,1),size(listF,2));
volmat=NaN(size(timenum,1),size(listF,2));
%subsystem
namefld=fieldnames(FamilySubsys);
for i=1
    subsysdat=listSubsysdat.(listF{i});
    subsys=FamilySubsys.(namefld{2});
    xts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic123Price.(2)); %vlookup on timenum
    xmat(:,i)=xts(:,2);
    xretts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic12Return.(2)); %vlookup on timenum
    xretmat(:,i)=xretts(:,2);
    signalts=tsvlookup(timenum,datenum(subsys.timestamp,'dd/mm/yyyy'),subsys.StratSignal.Carry);
    signalmat(:,i)=signalts(:,2);
    volts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),smartMovingStd(subsysdat.Generic12Return.(2),25));
    volmat(:,i)=volts(:,2);
end

fx=ones(size(timenum,1),1); %to be automate
weight=ones(size(timenum,1),1); %instrument weights
diversifer=1;
bidask_spread=0.0003;%dummy to be automate
% bidask_spread=[0.000 0.000 0.000 0.000];%dummy to be automate

matt= TradeSimT2(AUM,vol_target,contract_size,xmat,xretmat,signalmat,...
    volmat,fx,weight,diversifer,bidask_spread);

matt.timestamp=timestamp;
timeseriesplot(matt.vol,timestamp)