function matt = EMAS(x,xret,fast,slow,smooth,bidask_spread,vol_target,vol,forecastscalar)
%EMAS calculates the exponential weighted moving averages (EWMA) trading
%rule with smooth factor to smooth the signal line
%Input: x: time series of instrument
%       xret: returns of instrument
%       fast: time period of fast lag
%       slow: time period of slow lag
%       smooth: simple moving average of smooth period
%       bidask_spread: trading cost % term
%   vol_target: annaulised volatility target (default at 20%)
%   vol: daily volatility of instrument (default at 25days simple moving
%       forecastscalar: forecast scalar
%Output: singal: volatility adjusted EWMA crossover
%        annualised_turnover: turnover
%        Perf: performance matrix (APR,SR,CumPNL,MaxDD)
nants=x(isnan(x));
x_exnan=x(~isnan(x)); 
ewma_fast=tsmovavg(x_exnan,'e',fast,1);
ewma_slow=tsmovavg(x_exnan,'e',slow,1);
ewma_fast=[nants; ewma_fast];
ewma_slow=[nants; ewma_slow];

raw_ewma_crossover=ewma_fast-ewma_slow; %macd crossing
smooth_ewma_crossover=raw_ewma_crossover-smartMovingAvg(raw_ewma_crossover,smooth); %smoothed macd crossing


if strcmp(vol,'')
    vol=smartMovingStd(xret,25);
end

expectRet=smooth_ewma_crossover./x./vol; %unscaled signal;

if strcmp(forecastscalar,'')
    forecastscalar=10/mean(abs(expectRet(~isnan(expectRet))));
end

signal=expectRet*forecastscalar; %scaled signal
signal(signal>20)=20;signal(signal<-20)=-20;

%% Generate performance
matt= TradeSimT3(x,xret,vol_target,vol,signal,bidask_spread);

%% Output
matt.signal=signal;

end
