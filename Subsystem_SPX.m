function SPXsubsys=Subsystem_SPX()
%% Following Rob's System to create a subsystem for VIX futures (mean-reversion + momentum)
% Trade the second front contract

%% Load data
% clear;
% Amyaddpath('Home');

load EquityData_RollT-1.mat
fstgeneric=EquityData.SPX.Generic123Price.SP1_Index;
sndgeneric=EquityData.SPX.Generic123Price.SP2_Index;
sndgeneric_ret=EquityData.SPX.Generic12Return.G1ret;
FutRollFreq=1/4;

%% set up
stdev=smartstd(sndgeneric_ret)*sqrt(250);%annualised stdev

bidask_spread=0.003; %bid-ask spread (% term)
tcsr=2*bidask_spread/stdev; %cost in SR untis

load Setting.mat
forstscalar=setting.FcstScalar_T;
target_vol=setting.target_vol; %target volatility 20%


%% Carry Trade
carrysignal=EquityData.SPX.Carry; %annualised carry
CarryTrade= Carry(sndgeneric,sndgeneric_ret,carrysignal,FutRollFreq,bidask_spread,forstscalar.Carry);
CarryTrade.cost_SR_units=CarryTrade.annualised_turnover*tcsr;%Annualised cost in SR units
%% MACD
%EWMA_16_64
EWMA_ST=EWMAC(sndgeneric,sndgeneric_ret,16,64,bidask_spread,forstscalar.EWMAC_16_64);
EWMA_ST.cost_SR_units=EWMA_ST.annualised_turnover*tcsr;%Annualised cost in SR units

%EWMA_32_128
EWMA_MT=EWMAC(sndgeneric,sndgeneric_ret,32,128,bidask_spread,forstscalar.EWMAC_32_128);
EWMA_MT.cost_SR_units=EWMA_MT.annualised_turnover*tcsr;%Annualised cost in SR units

%EWMA_64_256
EWMA_LT=EWMAC(sndgeneric,sndgeneric_ret,64,256,bidask_spread,forstscalar.EWMAC_64_256);
EWMA_LT.cost_SR_units=EWMA_LT.annualised_turnover*tcsr;%Annualised cost in SR units

%% Signal blending
blend_type='Naive';
if strcmp(blend_type,'Boostrap') 
    %% Boostrap
    alphas=[CarryTrade.performance.dailyreturn EWMA_ST.performance.dailyreturn ...
            EWMA_MT.performance.dailyreturn EWMA_LT.performance.dailyreturn];
     signal_sharp=[CarryTrade.performance.sharpe_aftercost ...
         EWMA_ST.performance.sharpe_aftercost ...
         EWMA_MT.performance.sharpe_aftercost ...
         EWMA_LT.performance.sharpe_aftercost]; %expected returns
     
     SignalStruct=CV_block(alphas,100,30,20);
     [correl,wgt]=Boostrap(SignalStruct,signal_sharp,target_vol);
   
     Signal=[CarryTrade.signal EWMA_ST.signal EWMA_MT.signal EWMA_LT.signal];
     Signal=Signal*wgt; %combined signal
 %% Navie blending
elseif strcmp(blend_type,'Naive') 
    Signal=0.5*CarryTrade.signal+(EWMA_ST.signal+EWMA_MT.signal+EWMA_LT.signal)/3; %revert the signal of momentum strategy signal;
    diversification_multipler=1.3;
    Signal=Signal*diversification_multipler;
    Signal(Signal>20)=20;Signal(Signal<-20)=-20;
end
%% Trade simulation
EntryThreshold=0.000001;
ExitThreshold=0;
SPXsubsys=TradeSim(sndgeneric,sndgeneric_ret,Signal,EntryThreshold,ExitThreshold,bidask_spread);%positive signal means long
SPXsubsys.Signal=Signal;
SPXsubsys.timestamp=EquityData.SPX.timestamp;