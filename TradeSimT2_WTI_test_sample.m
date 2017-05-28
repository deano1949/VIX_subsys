% TradeSimT2 test exsample SPX
Amyaddpath('Home');
load ComdtyData_RollT-1.mat

AUM=100000;
vol_target=0.2;
xret=ComdtyData.WTI.Generic12Return.G2ret;
x=ComdtyData.WTI.Generic123Price.CL2_Comdty;
fx=ones(size(x,1),1);
vol=smartMovingStd(ComdtyData.WTI.Generic12Return.G1ret,25);
diversifer=1;
bidask_spread=0.0003;
contract_size=50;
weight=ones(size(x,1),1);

carrysignal=ComdtyData.WTI.Carry;
matt= Carry(x,xret,carrysignal,1/12,bidask_spread,1/mean(abs(carrysignal)));
signal=matt.signal;
matt2= TradeSimT2(AUM,vol_target,contract_size,x,xret,signal,vol,fx,weight,diversifer,bidask_spread);
matt3= TradeSimT3(x,xret,vol_target,vol,signal,bidask_spread);