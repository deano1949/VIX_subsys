function matt= TradeSim(x,xret,type,zscore,EntryThreshold,ExitThreshold,bidask_spread,varargin)
%TRADESIM Summary :  back-test the trading signal and PNL
%%INPUT:    x: instrument price
%           xret: instrument daily return
%           zscore: singal      
%           EntryThreshold: enter position threshold
%           ExitThreshold: exit position threshold
%           bidask_spread: trading spread
%           varargin : 'longonly' & 'shortonly'
%%OUTPUT    
%           annualised_turnover: turnover
%           Perf: performance matrix (ret,APR,SR,CumPNL,MaxDD)

%Example:--------------
% zscore=signal;
% EntryThreshold=10;
% ExitThreshold=1;
%-----------------
if nargin<8
    varargin={''};
end

if strcmp(type,'MoM')
    longsEntry=zscore > EntryThreshold; % a long position when signal is positive
    longsExit=zscore < ExitThreshold;

    shortsEntry=zscore < -EntryThreshold;
    shortsExit=zscore > -ExitThreshold;

    if strcmp(varargin{1},'longonly')
        shortsEntry=zscore < -99999;
        shortsExit=zscore > 99999;
    elseif strcmp(varargin{1},'shortonly')
        longsEntry=zscore > 99999;
        longsExit=zscore < -99999;
    end

elseif strcmp(type,'MR')
    longsEntry=zscore < -EntryThreshold; 
    longsExit=zscore > -ExitThreshold;

    shortsEntry=zscore > EntryThreshold;
    shortsExit=zscore < ExitThreshold;

    if strcmp(varargin{1},'longonly')
        shortsEntry=zscore > 99999;
        shortsExit=zscore < -99999;
    elseif strcmp(varargin{1},'shortonly')
        longsEntry=zscore < -99999;
        longsExit=zscore > 99999;
    end
end

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

%% rolling daily volatility (25days simple moving average)
matt.vol=smartMovingStd(ret,25);
end

