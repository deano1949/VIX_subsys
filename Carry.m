function matt= Carry(x,xret,carrysignal,distance,bidask_spread,forecastscalar)
%CARRY Summary:
%   x: trade contract price(Sep 17 contract)
%   xret: generic contract price
%   carrysignal: annualised carry signal
%   distance: frequency of rolling contracts (1/12 = monthly)
%Output: singal: carry trade
%        annualised_turnover: turnover
%        Perf: performance matrix (ret,APR,SR,CumPNL,MaxDD)

net_expret=carrysignal; %net expected return (annualised carry)

stdev_ret=smartMovingStd(xret,25)*sqrt(250);%annualised stdev/ 25 is recommended

raw_carry=net_expret./stdev_ret; %Vol adjusted raw carry

signal=raw_carry*forecastscalar;
signal(signal>20)=20; signal(signal<-20)=-20; %capped at [-20,20];

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
rolling_cost=2*bidask_spread/distance/252*ones(size(x,1),1);%cost of rolling contracts
ret=lag(numUnits, 1).*xret-lag(trading_cost,1)-rolling_cost; % daily P&L of the strategy
ret(isnan(ret))=0;
Perf.dailyreturn=ret;%
Perf.cumpnl=cumprod(1+ret)-1; %Accumulative PNL
Perf.apr=prod(1+ret).^(252/length(ret))-1; %annualised returns since inception
Perf.sharpe_aftercost=mean(ret)*sqrt(252)/std(ret); %sharpe ratio since inception
Perf.maxdd=maxdrawdown(100*cumprod(1+ret)); %maxdrawdown since inception

matt.performance=Perf; %performance matrix

end

