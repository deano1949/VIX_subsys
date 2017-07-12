function matt = SharpeRatio(x,xret,t,bidask_spread,vol_target,vol,forecastscalar)
%EWMAC calculates the sharpe ratio of trading rule
%Input: x: time series of instrument
%       xret: returns of instrument
%       t: time windows for sharpe ratio calculation
%       bidask_spread: trading cost % term
%   vol_target: annaulised volatility target (default at 20%)
%   vol: daily volatility of instrument (default at 25days simple moving
%       forecastscalar: forecast scalar
%Output: singal: volatility adjusted EWMA crossover
%        annualised_turnover: turnover
%        Perf: performance matrix (APR,SR,CumPNL,MaxDD)

% nants=x(isnan(x));
% x_exnan=x(~isnan(x)); 
rollSR=smartMovingAvg(xret,t)./smartMovingStd(xret,t)*sqrt(250);

%raw_ewma_crossover=ewma_fast-ewma_slow; %macd crossing


if strcmp(vol,'')
    vol=smartMovingStd(xret,25);
end

expectRet=-rollSR; %mean-reversion unscaled signal;

if strcmp(forecastscalar,'')
    forecastscalar=10/mean(abs(expectRet(~isnan(expectRet))));
end

signal=expectRet*forecastscalar; %scaled signal
signal(signal>20)=20;signal(signal<-20)=-20;

%% Generate performance
matt= TradeSimT3(x,xret,vol_target,vol,signal,bidask_spread); %mean-reversion

%% Output
matt.signal=signal;

end

