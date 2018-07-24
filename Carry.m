function matt= Carry(x,xret,carrysignal,bidask_spread,vol_target,vol,forecastscalar,smoothoption)
%CARRY Summary:
%   x: trade contract price(Sep 17 contract)
%   xret: generic contract price
%   carrysignal: annualised carry signal
%   vol_target: annaulised volatility target (default at 20%)
%   vol: daily volatility of instrument (default at 25days simple moving
%   average
%   forecastscalar: forecast scalar
%   smoothoption: remove seasonality of Carry raw signal
%       (option 1): 250Days Moving average
%       (option 2): 63Days Moving average
%       (option 3): Average of 250D MA and 63D MA
%
%Output: singal: carry trade
%        annualised_turnover: turnover
%        Perf: performance matrix (ret,APR,SR,CumPNL,MaxDD)

%% Smoothing Carrysignal
if smoothoption==1
    net_expret=smartMovingAvg(carrysignal,250); %1 Year moving average
elseif smoothoption==2
    net_expret=smartMovingAvg(carrysignal,63); %1 Quarter moving average
elseif smoothoption==3
    cs1=smartMovingAvg(carrysignal,63);
    cs2=smartMovingAvg(carrysignal,250);
    net_expret=(cs1+cs2)/2;
elseif strcmp(smoothoption,'')
    net_expret=carrysignal; %net expected return (annualised carry)
end
%%
stdev_ret=smartMovingStd(xret,25)*sqrt(250);%annualised stdev/ 25 is recommended

raw_carry=net_expret./backshift(1,stdev_ret); %Vol can only be calculated using previous close price (not include current price)

if strcmp(forecastscalar,'')
    forecastscalar=10/mean(abs(raw_carry(~isnan(raw_carry))));
end

signal=raw_carry*forecastscalar;
signal(signal>20)=20; signal(signal<-20)=-20; %capped at [-20,20];

%% Generate performance
matt= TradeSimT3(x,xret,vol_target,vol,signal,bidask_spread);

%% Output
matt.signal=signal;
matt.forecastscalar=forecastscalar;

end

