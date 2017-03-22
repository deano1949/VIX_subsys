function matt = EWMAC(x,xret,fast,slow,bidask_spread,forecastscalar)
%EWMAC calculates the exponential weighted moving averages (EWMA) trading
%rule
%Input: x: time series of instrument
%       xret: returns of instrument
%       fast: time period of fast lag
%       slow: time period of slow lag
%       bidask_spread: trading cost % term
%       forecastscalar: forecast scalar
%Output: singal: volatility adjusted EWMA crossover
%        annualised_turnover: turnover
%        Perf: performance matrix (APR,SR,CumPNL,MaxDD)

ewma_fast=tsmovavg(x,'e',fast,1);

ewma_slow=tsmovavg(x,'e',slow,1);

raw_ewma_crossover=ewma_fast-ewma_slow; %macd crossing

expectRet=raw_ewma_crossover./x; %return of macd crossing;

stdev=[NaN;smartMovingStd(tick2ret(x),25)]; %Volatility/ 25 is recommended

signal=expectRet./stdev*forecastscalar; %unscaled signal
signal(signal>20)=20;signal(signal<-20)=-20;

matt.signal=signal;

%% estimate PNL & sharpe ratio
zscore=signal;
EntryThreshold=0.001;
ExitThreshold=0.001;
longsEntry=zscore > EntryThreshold; % a long position when signal is positive
longsExit=zscore < ExitThreshold;

shortsEntry=zscore < -EntryThreshold;
shortsExit=zscore > -ExitThreshold;

numUnitsLong=NaN(length(x), 1);
numUnitsShort=NaN(length(x), 1);

numUnitsLong(1)=0;
numUnitsLong(longsEntry)=1; 
numUnitsLong(longsExit)=0;
numUnitsLong=fillMissingData(numUnitsLong); % backfill data with previous day's value

numUnitsShort(1)=0;
numUnitsShort(shortsEntry)=-1; 
numUnitsShort(shortsExit)=0;
numUnitsShort=fillMissingData(numUnitsShort);

numUnits=numUnitsLong+numUnitsShort;

%% estimate turnover
tradeswitch=numUnits~=backshift(1,numUnits);tradeswitch(1)=0; %trade takes place
matt.annualised_turnover=ceil(sum(tradeswitch)/size(numUnits,1)*252);%estimated number of trades per year

%% PNL and Sharpe ratio
trading_cost=tradeswitch*bidask_spread; %trading costs
ret=lag(numUnits, 1).*xret-lag(trading_cost,1); % daily P&L of the strategy
ret(isnan(ret))=0;
Perf.dailyreturn=ret;%
Perf.cumpnl=cumprod(1+ret)-1; %Accumulative PNL
Perf.apr=prod(1+ret).^(252/length(ret))-1; %annualised returns since inception
Perf.sharpe_aftercost=mean(ret)*sqrt(252)/std(ret); %sharpe ratio since inception
Perf.maxdd=maxdrawdown(100*cumprod(1+ret)); %maxdrawdown since inception

matt.performance=Perf; %performance matrix
end

