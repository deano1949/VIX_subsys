addpath('C:\Users\gly19\Dropbox\GU\1.Investment\4. Alphas (new)\17.Extract_Rollyield\0.Research\VIX\dat');
% load Sigmaa005_FamilySubsys.mat

dir='C:\Spectrion\Data\PriceData\Future_Generic\';
load(strcat(dir,'EquityData_RollT-1.mat'));
load(strcat(dir,'Bond10YData_RollT-1.mat'));
load(strcat(dir,'ComdtyData_RollT-1.mat'));
load(strcat(dir,'CurrencyData_RollT-1.mat'));
load('Sigmaa005_Setting.mat');

vol_target=setting.target_vol;
vol='';
blend_type='Boostrap';%'Boostrap' or 'Naive'

%% Equity
dat=EquityData.SPX;
x=dat.Generic123Price.(1);
xret=dat.Generic12Return.(1);
bidask_spread=setting.BidAskSpread.SPX;

carrysignal=dat.Carry; %annualised carry
forecastscalar='';

% Raw signal plot
cs_raw=carrysignal;
cs_250=smartMovingAvg(cs_raw,250);
cs_63=smartMovingAvg(cs_raw,63);

figure;
t=datenum(dat.timestamp,'dd/mm/yyyy');
plot(t,cs_raw);
hold on;
plot(t,cs_63);
plot(t,cs_250);
hold off;
datetick('x','yyyy')
legend('raw','MA63','MA250')

% Carry strategy
CarryTrade_63_250= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,3);
CarryTrade_250= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,1);
CarryTrade_No_smooth= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,'');

t=datenum(dat.timestamp,'dd/mm/yyyy');
figure;
plot(t,CarryTrade_63_250.signal);
hold on;
plot(t,CarryTrade_250.signal);
plot(t,CarryTrade_No_smooth.signal);
datetick('x','yyyy')
hold off
legend('63X250','250','No smoothing')
% PNL plot
figure;
plot(t,CarryTrade_63_250.performance.cumpnl);
hold on;
plot(t,CarryTrade_250.performance.cumpnl);
plot(t,CarryTrade_No_smooth.performance.cumpnl);
datetick('x','yyyy')
hold off
legend('63X250','250','No smoothing')

CarryTrade_63_250_Sharpe=CarryTrade_63_250.performance.sharpe_aftercost
CarryTrade_250_Sharpe=CarryTrade_250.performance.sharpe_aftercost
CarryTrade_NoSmooth_Sharpe=CarryTrade_No_smooth.performance.sharpe_aftercost

%% Bonds
dat=Bond10YData.USZC;
x=dat.Generic123Price.(1);
xret=dat.Generic12Return.(1);
bidask_spread=setting.BidAskSpread.USZC;

carrysignal=dat.Carry; %annualised carry
forecastscalar='';

% Raw signal plot
cs_raw=carrysignal;
cs_250=smartMovingAvg(cs_raw,250);
cs_125=smartMovingAvg(cs_raw,125);

cs_63=smartMovingAvg(cs_raw,63);
cs_mean=(cs_63+cs_250)/2;
figure;
t=datenum(dat.timestamp,'dd/mm/yyyy');
plot(t,cs_raw);
hold on;
plot(t,cs_63);
% plot(t,cs_125);
plot(t,cs_250);
plot(t,cs_mean);
hold off;
datetick('x','yyyy')
legend('raw','MA63','MA250','MA_mean')

% Carry strategy
CarryTrade_63_250= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,3);
CarryTrade_250= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,1);
CarryTrade_No_smooth= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,'');
figure;
t=datenum(dat.timestamp,'dd/mm/yyyy');
plot(t,CarryTrade_63_250.signal);
hold on;
plot(t,CarryTrade_250.signal);
plot(t,CarryTrade_No_smooth.signal);
datetick('x','yyyy')
hold off

% PNL plot
figure;
plot(t,CarryTrade_63_250.performance.cumpnl);
hold on;
plot(t,CarryTrade_250.performance.cumpnl);
plot(t,CarryTrade_No_smooth.performance.cumpnl);
datetick('x','yyyy')
hold off
legend('63X250','250','No smoothing')

CarryTrade_63_250_Sharpe=CarryTrade_63_250.performance.sharpe_aftercost
CarryTrade_250_Sharpe=CarryTrade_250.performance.sharpe_aftercost
CarryTrade_NoSmooth_Sharpe=CarryTrade_No_smooth.performance.sharpe_aftercost

%% WTI
dat=ComdtyData.Copper;
x=dat.Generic123Price.(1);
xret=dat.Generic12Return.(1);
bidask_spread=setting.BidAskSpread.Copper;

carrysignal=dat.Carry; %annualised carry
forecastscalar='';

% Raw signal plot
cs_raw=carrysignal;
cs_250=smartMovingAvg(cs_raw,250);
cs_125=smartMovingAvg(cs_raw,125);

cs_63=smartMovingAvg(cs_raw,63);
cs_mean=(cs_63+cs_250)/2;
figure;
t=datenum(dat.timestamp,'dd/mm/yyyy');
plot(t,cs_raw);
hold on;
plot(t,cs_63);
% plot(t,cs_125);
plot(t,cs_250);
plot(t,cs_mean);
hold off;
datetick('x','yyyy')
legend('raw','MA63','MA250','MAmean')

% Carry strategy
CarryTrade_63_250= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,3);
CarryTrade_250= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,1);
CarryTrade_No_smooth= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,'');

figure;
t=datenum(dat.timestamp,'dd/mm/yyyy');
plot(t,CarryTrade_63_250.signal);
hold on;
plot(t,CarryTrade_No_smooth.signal);
plot(t,CarryTrade_250.signal);

datetick('x','yyyy')
hold off
legend('63X250','No smoothing','250')

% PNL plot
figure;
plot(t,CarryTrade_63_250.performance.cumpnl);
hold on;
plot(t,CarryTrade_250.performance.cumpnl);
plot(t,CarryTrade_No_smooth.performance.cumpnl);
datetick('x','yyyy')
hold off
legend('63X250','250','No smoothing')

CarryTrade_63_250_Sharpe=CarryTrade_63_250.performance.sharpe_aftercost
CarryTrade_250_Sharpe=CarryTrade_250.performance.sharpe_aftercost
CarryTrade_NoSmooth_Sharpe=CarryTrade_No_smooth.performance.sharpe_aftercost


%% Final Decisions on Smoothing parameters
% High Level summary: 
% The analysis tested the smoothed carry signals and associated PNL and
% Sharpe ratio. The smoothing parameters, which were tested, are 63
% (quarterly), 250 (annually) and the average of the two. 
%
% Generally speaking, the signal of the average of 63 and 250 provides
% better PNL and S.R among the three. However, most of Equity futures have
% strong seasonality, 63D MA signal has still failed to smooth the signal
% enough, which leads to "jumpy" in the signal. It is not preferred. Hence,
% for equity futures, the parameter is 250D MA.
% Please see the below table for parameters.
%
%   Equity:
%   SPX         Mean(63,250)
%   CAC         250
%   DAX         250  
%   NKY         250
%   HIA         250  
%   UKX         250
%   Bonds:
%   USZC        Mean(63,250)
%   GERZC       250
%   UKZC        Mean(63,250) 
%   JPZC        Mean(63,250)
%   Commodity:
%   WTI         Mean(63,250)
%   Coffee      Mean(63,250)
%   Gold        Mean(63,250)
%   Copper      Mean(63,250)