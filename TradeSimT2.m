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
NAV=NaN(size(x,1),1); NAV(1)=AUM; %Price index
pos_val=zeros(size(x,1),size(x,2)+1); %1st col is cash position value
pos_val(1,:)=[AUM zeros(1,size(x,2))]; %@ start of a day
to=zeros(size(x,1),1); %turnover
EcoExpo=zeros(size(x,1),size(x,2)); %economics exposure
GearRatio=zeros(size(x,1),1); %Gearing ratio
TotalEcoExpo=zeros(size(x,1),1); %Total economics exposure
TotalPctEE=zeros(size(x,1),1); %Total economics exposure percentage
PosWgts=zeros(size(x,1),size(x,2)); % position wegihts

for i=2:size(x,1)
    cash_vol_target=NAV(i-1)*vol_target/sqrt(252);
    stdev=vol(i-1,:);
    price=x(i-1,:); price(isnan(price))=0;
    forecast=signal(i-1,:);
    fxrate=fx(i-1,:);
    w=weight(i-1,:);
    desired_pos(i,:) = propose_trade(stdev,contract_size,price,forecast,fxrate,cash_vol_target,w,diversifer);
    tc=sum(abs((desired_pos(i,:)-desired_pos(i-1,:))).*contract_size.*price.*bidask_spread.*fxrate); %transaction cost
    to(i)=sum(abs((desired_pos(i,:)-desired_pos(i-1,:))).*contract_size.*price.*fxrate); %turnover
    EcoExpo(i,:)=desired_pos(i,:).*contract_size.*price.*fxrate; % $ economic exposure
    GearRatio(i)=sum(abs(EcoExpo(i,:)))./NAV(i-1); %Gearing ratio

    %% Constraint on Gearing ratio
    if abs(GearRatio(i))>4 % Cap gearing ratio at 4
        desired_pos(i,:)=ceil(desired_pos(i,:).*(4/abs(GearRatio(i))));
        EcoExpo(i,:)=desired_pos(i,:).*contract_size.*price.*fxrate; % $ economic exposure
        GearRatio(i)=sum(abs(EcoExpo(i,:)))./NAV(i-1); %Gearing ratio
    end
    
    %%
    TotalEcoExpo(i)=sum(EcoExpo(i,:)); %total economics exposure
    TotalPctEE(i)=TotalEcoExpo(i)/NAV(i-1);%total economics exposure percentage
    PosWgts(i,:)=EcoExpo(i,:)./NAV(i-1); % Percentage Position exposure
    pos_val(i,2:end)=desired_pos(i,:).*price.*contract_size.*xret(i,:).*fxrate; %active positions value (pnl for futures)
    pos_val(isnan(pos_val))=0; %remove nan
    if tc~=0
        pos_val(i,1)=NAV(i-1,1)-tc; %cash value
    else
        pos_val(i,1)=NAV(i-1,1);
    end
    NAV(i)=sum(pos_val(i,:),2);
end    






%% system index & position
matt.NAV=NAV;
matt.AUM=AUM;
matt.desireposition=desired_pos;
%% estimate turnover
matt.annualised_turnover=mean(to./NAV)*252;
matt.economicsexposure=EcoExpo;
matt.gearingratio=GearRatio;
matt.positionwegiths=PosWgts;
matt.totalecoexpo=TotalEcoExpo;
matt.totalpctecoexpo=TotalPctEE;
matt.poswgts=PosWgts;

%% PNL and Sharpe ratio
ret=[0; tick2ret(NAV)];
ret(isnan(ret))=0;
Perf.dailyreturn=ret;%
Perf.cumpnl=cumprod(1+ret)-1; %Accumulative PNL

[~,id]=ismember(0,NAV==AUM); %identify trading start point
Perf.apr=prod(1+ret(id:end)).^(252/length(ret(id:end)))-1; %annualised returns since inception
Perf.sharpe_aftercost=mean(ret(id:end))*sqrt(252)/std(ret(id:end)); %sharpe ratio since inception
Perf.maxdd=maxdrawdown(100*cumprod(1+ret(id:end))); %maxdrawdown since inception
Perf.annualisedvolatility=std(ret(id:end))*sqrt(252); %annualised volatility
matt.performance=Perf; %performance matrix

%% rolling daily volatility (25days simple moving average)
matt.vol=smartMovingStd(ret,25);

end

