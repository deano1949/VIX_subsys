% TradeSimT2 test exsample SPX
Amyaddpath('Home');
load EquityData_RollT-1.mat

AUM=100000;
vol_target=0.2;
xret=EquityData.SPX.Generic12Return.G1ret;
x=EquityData.SPX.Generic123Price.SP1_Index;
fx=ones(size(x,1),1);
vol=smartMovingStd(EquityData.SPX.Generic12Return.G1ret,25);
diversifer=1;
bidask_spread=0.0003;
contract_size=50;
weight=ones(size(x,1),1);

%Carry
carrysignal=EquityData.SPX.Carry;
CarrySignal= Carry(x,xret,carrysignal,0.25,bidask_spread,30);
csignal=CarrySignal.signal;
cmatt= TradeSimT2(AUM,vol_target,contract_size,x,xret,csignal,vol,fx,weight,diversifer,bidask_spread);

%MACD 
fast=64;slow=fast*4;
macd = EWMAC(x,xret,fast,slow,bidask_spread,1);
msignal=macd.signal;
mmatt= TradeSimT2(AUM,vol_target,contract_size,x,xret,msignal,vol,fx,weight,diversifer,bidask_spread);
