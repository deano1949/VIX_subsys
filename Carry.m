function matt= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar)
%CARRY Summary:
%   x: trade contract price(Sep 17 contract)
%   xret: generic contract price
%   carrysignal: annualised carry signal
%   vol_target: annaulised volatility target (default at 20%)
%   vol: daily volatility of instrument (default at 25days simple moving
%   average
%   forecastscalar: forecast scalar
%Output: singal: carry trade
%        annualised_turnover: turnover
%        Perf: performance matrix (ret,APR,SR,CumPNL,MaxDD)

net_expret=carrysignal; %net expected return (annualised carry)

stdev_ret=smartMovingStd(xret,25)*sqrt(250);%annualised stdev/ 25 is recommended

raw_carry=net_expret./stdev_ret; %Vol adjusted raw carry

if strcmp(forecastscalar,'')
    forecastscalar=10/mean(abs(raw_carry(~isnan(raw_carry))));
end

signal=raw_carry*forecastscalar;
signal(signal>20)=20; signal(signal<-20)=-20; %capped at [-20,20];



%% Generate performance
matt= TradeSimT3(x,xret,vol_target,vol,signal,bidask_spread);

%% Output
matt.signal=signal;


end

