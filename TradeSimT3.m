function matt= TradeSimT3(x,xret,vol_target,vol,signal,bidask_spread)
%% TRADESIMT3 Summary :  strategy return is simply the multiplicaiton of signal_t and xret_t-1
%                        x: price of trading underlying
%                        xret: return of trading underlying
%                        vol_target: annualised volatility target (default 20%)
%                        vol: daily volatility of instrument
%                        signal: forecast singal
%                        bidaskSprd: bid-ask spread
%

%% PNL and Sharpe ratio
vol_target=vol_target/sqrt(252); %convert to daily volatility target
pos=vol_target.*backshift(1,signal)./(backshift(1,vol)*10);%position: no of contracts/shares
ret=pos.*xret; %signal @ 10 means normal buy signal, we assume buy 1 contract; hence why divded by 10
ret(isnan(ret))=0;

%% estimate turnover
turnover=abs(pos-backshift(1,pos));turnover(isnan(turnover))=0; %turnover = signal differenial
matt.annualised_turnover=ceil(sum(turnover)/size(pos,1)*252);%estimated turnover per year
tc=turnover.*bidask_spread; %transaction costs
ret=ret-tc;

Perf.dailyreturn=ret;%
Perf.cumpnl=cumprod(1+ret)-1; %Accumulative PNL
Perf.apr=prod(1+ret).^(252/length(ret))-1; %annualised returns since inception
Perf.sharpe_aftercost=mean(ret)*sqrt(252)/std(ret); %sharpe ratio since inception
Perf.maxdd=maxdrawdown(100*cumprod(1+ret)); %maxdrawdown since inception

matt.performance=Perf; %performance matrix

%% rolling daily volatility (25days simple moving average)
matt.vol=smartMovingStd(ret,25);
end
