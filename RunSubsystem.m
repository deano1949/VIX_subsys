function Subsys=RunSubsystem(dat,x,xret,bidask_spread,vol_target,vol,blend_type)
%% Following Rob's System to create a subsystem for futures
% Trade the second front contract
%Input: dat: instrument data struct (for Carry trade to load raw carry data)
%       x: time series of instrument
%       xret: returns of instrument
%       bidask_spread: trading cost % term
%       bidask_spread: trading cost % term
%       vol_target: annaulised volatility target (default at 20%)
%       vol: daily volatility of instrument (default at 25days simple moving
%       blend_type: 'Boostrap' or 'Naive'

%% Load data
% clear;
% Amyaddpath('Home');

% load EquityData_RollT-1.mat
% % fstgeneric=EquityData.VIX.Generic123Price.UX1_Index;
% x=EquityData.VIX.Generic123Price.UX2_Index;
% xret=EquityData.VIX.Generic12Return.G2ret;
% FutRollFreq=1/12;


%% set up
% stdev=smartstd(xret)*sqrt(250);%annualised stdev

% bidask_spread=0.003; %bid-ask spread (% term)

% load Setting.mat
% forstscalar=setting.FcstScalar_T;
% vol_target=setting.target_vol; %target volatility 20%
if strcmp(vol,'')
    vol=smartMovingStd(xret,25);
end

forecastscalar='';
%% Strategies parameters load up
name=strcat('Tune',dat.name);
try
    dir='C:\Users\gly19\Dropbox\GU\1.Investment\4. Alphas (new)\17.Extract_Rollyield\0.Research\VIX\dat\';
    load(strcat(dir,'TuningOutput.mat'));
catch
    dir='O:\langyu\Reading\Systematic_Trading_RobCarver\VIX subsystem\';
    load(strcat(dir,'TuningOutput.mat'));
end
eval(['tunepara=TuningOutput.' name]);

%% Carry Trade
carrysignal=dat.Carry; %annualised carry
CarryTrade= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar);
%% MACD
try
    tpewma=table2array(tunepara.EWMAC.Optimal_Parameter); %Optimal parameter for EWMA
    EWMA_ST=EWMAC(x,xret,tpewma(1,1),tpewma(2,1),bidask_spread,vol_target,vol,forecastscalar);
    EWMA_MT=EWMAC(x,xret,tpewma(1,2),tpewma(2,2),bidask_spread,vol_target,vol,forecastscalar);
    EWMA_LT=EWMAC(x,xret,tpewma(1,3),tpewma(2,3),bidask_spread,vol_target,vol,forecastscalar);
catch
    EWMA_ST.performance.dailyreturn=zeros(size(x)); %set up empty shells in case EWMA is a non-profitable strategy
    EWMA_ST.performance.sharpe_aftercost=0;
    EWMA_ST.signal=zeros(size(x));
    EWMA_MT.performance.dailyreturn=zeros(size(x));
    EWMA_MT.performance.sharpe_aftercost=0;
    EWMA_MT.signal=zeros(size(x));    
    EWMA_LT.performance.dailyreturn=zeros(size(x));
    EWMA_LT.performance.sharpe_aftercost=0;
    EWMA_LT.signal=zeros(size(x));
end
%% Sharpe Ratio
try
    tpsr=table2array(tunepara.SharpeRatio.Optimal_Parameter); %optimal parameter for SharpeRatio
    SR_ST=SharpeRatio(x,xret,tpsr(1),bidask_spread,vol_target,vol,forecastscalar);
    SR_MT=SharpeRatio(x,xret,tpsr(2),bidask_spread,vol_target,vol,forecastscalar);
    SR_LT=SharpeRatio(x,xret,tpsr(3),bidask_spread,vol_target,vol,forecastscalar);
catch
    SR_ST.performance.dailyreturn=zeros(size(x)); %set up empty shells in case SR is a non-profitable strategy
    SR_ST.performance.sharpe_aftercost=0;
    SR_ST.signal=zeros(size(x));
    SR_MT.performance.dailyreturn=zeros(size(x));
    SR_MT.performance.sharpe_aftercost=0;
    SR_MT.signal=zeros(size(x));    
    SR_LT.performance.dailyreturn=zeros(size(x));
    SR_LT.performance.sharpe_aftercost=0;
    SR_LT.signal=zeros(size(x));
end   
%% Signal blending
% blend_type='Naive';
if strcmp(blend_type,'Boostrap') 
    %% Boostrap
    alphas=[CarryTrade.performance.dailyreturn EWMA_ST.performance.dailyreturn ...
            EWMA_MT.performance.dailyreturn EWMA_LT.performance.dailyreturn ...
            SR_ST.performance.dailyreturn SR_MT.performance.dailyreturn ...
            SR_LT.performance.dailyreturn];
        
     signal_sharp=[CarryTrade.performance.sharpe_aftercost ...
         EWMA_ST.performance.sharpe_aftercost ...
         EWMA_MT.performance.sharpe_aftercost ...
         EWMA_LT.performance.sharpe_aftercost ...
         SR_ST.performance.sharpe_aftercost ...
         SR_MT.performance.sharpe_aftercost ...
         SR_LT.performance.sharpe_aftercost]; %expected returns
     
     SignalStruct=CV_block(alphas,100,30,10);
     [correl,wgt,dm]=Boostrap(SignalStruct,signal_sharp,vol_target);
   
     Signal=[CarryTrade.signal EWMA_ST.signal EWMA_MT.signal EWMA_LT.signal ...
         SR_ST.signal SR_MT.signal SR_LT.signal];
     SignalTot=Signal*wgt*dm; %combined signal
     SignalTot(SignalTot>20)=20;SignalTot(SignalTot<-20)=-20;

    %% Navie blending
elseif strcmp(blend_type,'Naive') 
     wgt=[1/3 1/9 1/9 1/9 1/9 1/9 1/9];
     Signal=[CarryTrade.signal EWMA_ST.signal EWMA_MT.signal EWMA_LT.signal ...
         SR_ST.signal SR_MT.signal SR_LT.signal];
     dm=2;
     SignalTot=Signal*dm*wgt';
     SignalTot(SignalTot>20)=20;SignalTot(SignalTot<-20)=-20; %combined signal
     correl=NaN;
     alphas=NaN;
end
Blend.Name=blend_type;
Blend.Stratsreturn=alphas;
Blend.Weights=wgt;
Blend.Correl=correl;
Blend.DiversifedMultiplier=dm;

%For output
Signal=array2table(Signal,'VariableNames',{'Carry','EWMA_ST','EWMA_MT','EWMA_LT', ...
    'SR_ST','SR_MT','SR_LT'});
CurrentStatus=table;
CurrentStatus.timestamp=dat.timestamp(end,:);
CurrentStatus.Combined_signal=SignalTot(end);
CurrentStatus=horzcat(CurrentStatus,Signal(end,:));
%% Trade simulation
Subsys=TradeSimT3(x,xret,vol_target,'',SignalTot,bidask_spread);
Subsys.name=dat.name;
Subsys.Signal=SignalTot;
Subsys.StratSignal=Signal;
Subsys.timestamp=dat.timestamp;
Subsys.stratsblending=Blend;
Subsys.CurrentStatus=CurrentStatus;