function matt= TradeSimT2(AUM,vol_target,contract_size,x,xret,signal,vol,fx,weight,diversifer,bidask_spread)
%% TRADESIMT2 Summary :  AUM: asset under management (US$ term)
%                        vol_target: annualised volatility target (default 20%)
%                        contract_size: of futures/ # of shares in an unit of equity
%                        x: price of trading underlying
%                        xret: return of trading underlying
%                        signal: forecast singal
%                        vol: daily volatility of instrument
%                        fx: fx rate
%                        weight: weights between subsys
%                        diversifer: instrument diversification multiplier
%                        (1 for singal instrument/strategy)
%                        bidaskSprd: bid-ask spread
desired_pos(1,:)=zeros(1,size(x,2));
PI=NaN(size(x,1),1); PI(1)=AUM; %Price index
pos_val=zeros(size(x,1),size(x,2)+1); %1st col is cash position value
pos_val(1,:)=[AUM zeros(1,size(x,2))]; %@ start of a day

for i=2:size(x,1)
    cash_vol_target=PI(i-1)*vol_target/sqrt(252);
    stdev=vol(i-1,:);
    price=x(i-1,:);
    forecast=signal(i-1,:);
    fxrate=fx(i-1,:);
    w=weight(i-1,:);
    desired_pos(i,:) = propose_trade(stdev,contract_size,price,forecast,fxrate,cash_vol_target,w,diversifer);
    tc=sum(abs((desired_pos(i,:)-desired_pos(i-1,:))).*contract_size.*price.*bidask_spread); %transaction cost
    pos_val(i,2:end)=desired_pos(i,:).*price.*contract_size.*xret(i,:); %active positions value (pnl for futures)
    if tc~=0
        pos_val(i,1)=pos_val(i-1,1)-tc; %cash value
    else
        pos_val(i,1)=pos_val(i-1,1);
    end
    PI(i)=pos_val(i,1)+sum(pos_val(1:i,2:end));%-----------------------------------------
end    






%% estimate turnover
% tradeswitch=numUnits~=backshift(1,numUnits);tradeswitch(1)=0; %trade takes place
% matt.annualised_turnover=ceil(sum(tradeswitch)/size(numUnits,1)*252);%estimated number of trades per year

%% PNL and Sharpe ratio
ret=[0; tick2ret(PI)];
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

