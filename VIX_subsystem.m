%% Following Rob's System to create a subsystem for VIX futures (mean-reversion + momentum)
% Trade the second front contract

%% Load data
clear;
location='Coutts';

    if strcmp(location,'Home')
        addpath(genpath('C:\Users\Langyu\Desktop\Dropbox\GU\1.Investment\4. Alphas (new)'));
        addpath(genpath('C:\Users\gly19\Dropbox\GU\1.Investment\4. Alphas (new)\Common_codes'));
    elseif strcmp(location,'Coutts')
        addpath(genpath('O:\langyu\Reading\AlgorithmTrading_Chan_(2013)\Custom_Functions'));
        addpath('O:\langyu\Reading\AlgorithmTrading_Chan_(2013)');
    else
        error('Unrecognised location; Coutts or Home');
    end

load VIX_data.mat
fstgeneric=VIX_data.Q.first_generic_price;
sndgeneric=VIX_data.Q.second_generic_price;
sndgeneric_ret=VIX_data.Q.second_generic_ret;


%% set up
stdev=smartstd(sndgeneric_ret)*sqrt(250);%annualised stdev

bidask_spread=0.003; %bid-ask spread (% term)
tcsr=2*bidask_spread/stdev; %cost in SR untis

load Setting.mat
forstscalar=setting.FcstScalar_T;
%% Carry Trade 
CarryTrade= Carry(sndgeneric,sndgeneric_ret,fstgeneric,'Q',bidask_spread,forstscalar.Carry);
CarryTrade.cost_SR_units=CarryTrade.annualised_turnover*tcsr;%Annualised cost in SR units
%% MACD
%EWMA_16_64
EWMA_ST=EWMAC(sndgeneric,sndgeneric_ret,8,32,bidask_spread,forstscalar.EWMAC_16_64);
EWMA_ST.cost_SR_units=EWMA_ST.annualised_turnover*tcsr;%Annualised cost in SR units

%EWMA_32_128
EWMA_MT=EWMAC(sndgeneric,sndgeneric_ret,16,64,bidask_spread,forstscalar.EWMAC_32_128);
EWMA_MT.cost_SR_units=EWMA_MT.annualised_turnover*tcsr;%Annualised cost in SR units

%EWMA_64_256
EWMA_LT=EWMAC(sndgeneric,sndgeneric_ret,32,128,bidask_spread,forstscalar.EWMAC_64_256);
EWMA_LT.cost_SR_units=EWMA_LT.annualised_turnover*tcsr;%Annualised cost in SR units

%% Signal blending
blend_type='Boostrap';
if strcmp(blend_type,'Boostrap') 
    %% Boostrap
    Signal=[CarryTrade.performance.dailyreturn EWMA_ST.performance.dailyreturn ...
            EWMA_MT.performance.dailyreturn EWMA_LT.performance.dailyreturn];
     signal_sharp=[CarryTrade.performance.sharpe_aftercost ...
         EWMA_ST.performance.sharpe_aftercost ...
         EWMA_MT.performance.sharpe_aftercost ...
         EWMA_LT.performance.sharpe_aftercost]; %expected returns
     target_vol=0.2; %target volatility 20%
     
     SignalStruct=CV_block(Signal,200);
     [correl,weights]=Boostrap(SignalStruct,signal_sharp,target_vol);
     wgt=mean(weights,2);
     
     Signal=wgt(1)*CarryTrade.signal-(EWMA_ST.signal*wgt(2)+EWMA_MT.signal*wgt(3)+ ...
         EWMA_LT.signal*wgt(4));
 %% Navie blending
elseif strcmp(blend_type,'Naive') 
    Signal=0.5*CarryTrade.signal-(EWMA_ST.signal+EWMA_MT.signal+EWMA_LT.signal)/3; %revert the signal of momentum strategy signal;
    diversification_multipler=2;
    Signal=Signal*diversification_multipler;
    Signal(Signal>20)=20;Signal(Signal<-20)=-20;
end
%% Trade simulation
EntryThreshold=0.0001;
ExitThreshold=0;
VIXsubsys=TradeSim(sndgeneric,sndgeneric_ret,Signal,EntryThreshold,ExitThreshold,bidask_spread);
