function Subsys=Subsystem_VIX()
%% Following Rob's System to create a subsystem for VIX futures (mean-reversion + momentum)
% Trade the second front contract

%% Load data
% clear;
% Amyaddpath('Home');

load EquityData_RollT-1.mat
% fstgeneric=EquityData.VIX.Generic123Price.UX1_Index;
sndgeneric=EquityData.VIX.Generic123Price.UX2_Index;
sndgeneric_ret=EquityData.VIX.Generic12Return.G2ret;
FutRollFreq=1/12;


%% set up
stdev=smartstd(sndgeneric_ret)*sqrt(250);%annualised stdev

bidask_spread=0.003; %bid-ask spread (% term)

load Setting.mat
forstscalar=setting.FcstScalar_T;
vol_target=setting.target_vol; %target volatility 20%

%% Carry Trade
carrysignal=EquityData.VIX.Carry; %annualised carry
CarryTrade= Carry(sndgeneric,sndgeneric_ret,carrysignal,bidask_spread,vol_target,'','');
%% MACD
%EWMA_16_64
EWMA_ST=EWMAC(sndgeneric,sndgeneric_ret,8,32,bidask_spread,vol_target,'','');

%EWMA_32_128
EWMA_MT=EWMAC(sndgeneric,sndgeneric_ret,16,64,bidask_spread,vol_target,'','');

%EWMA_64_256
EWMA_LT=EWMAC(sndgeneric,sndgeneric_ret,32,128,bidask_spread,vol_target,'','');

%% Signal blending
blend_type='Boostrap';
if strcmp(blend_type,'Boostrap') 
    %% Boostrap
    alphas=[CarryTrade.performance.dailyreturn EWMA_ST.performance.dailyreturn ...
            EWMA_MT.performance.dailyreturn EWMA_LT.performance.dailyreturn];
     signal_sharp=[CarryTrade.performance.sharpe_aftercost ...
         EWMA_ST.performance.sharpe_aftercost ...
         EWMA_MT.performance.sharpe_aftercost ...
         EWMA_LT.performance.sharpe_aftercost]; %expected returns
     
     SignalStruct=CV_block(alphas,100,30,10);
     [correl,wgt,dm]=Boostrap(SignalStruct,signal_sharp,vol_target);
   
     Signal=[CarryTrade.signal EWMA_ST.signal EWMA_MT.signal EWMA_LT.signal];
     Signal=Signal*wgt*dm; %combined signal
     Signal(Signal>20)=20;Signal(Signal<-20)=-20;

    %% Navie blending
elseif strcmp(blend_type,'Naive') 
    Signal=0.5*CarryTrade.signal+(EWMA_ST.signal+EWMA_MT.signal+EWMA_LT.signal)/3; %revert the signal of momentum strategy signal;
    diversification_multipler=2;
    Signal=Signal*diversification_multipler;
    Signal(Signal>20)=20;Signal(Signal<-20)=-20;
end
 Blend.Stratsreturn=alphas;
 Blend.Name=blend_type;
 Blend.Weights=wgt;
 Blend.DiversifedMultiplier=dm;
     
%% Trade simulation
Subsys=TradeSimT3(sndgeneric,sndgeneric_ret,vol_target,'',Signal,bidask_spread);
Subsys.Signal=Signal;
Subsys.timestamp=EquityData.VIX.timestamp;
Subsys.stratsblending=Blend;