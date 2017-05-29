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
WTICar= Carry(x,xret,carrysignal,bidask_spread,vol_target,'','');
WTIMACD=EWMAC(x,xret,64,64*4,bidask_spread,vol_target,'','');



% signal=matt.signal;
% matt2= TradeSimT2(AUM,vol_target,contract_size,x,xret,signal,vol,fx,weight,diversifer,bidask_spread);
% matt3= TradeSimT3(x,xret,vol_target,vol,signal,bidask_spread);

%% test for RunSubsystem ---pass
VIXsubsys2=Subsystem_VIX();

load EquityData_RollT-1.mat
% fstgeneric=EquityData.VIX.Generic123Price.UX1_Index;
x=EquityData.VIX.Generic123Price.UX2_Index;
xret=EquityData.VIX.Generic12Return.G2ret;
bidask_spread=0.003;
vol_target=0.2;
data=EquityData.VIX;
VIXSubsys=RunSubsystem(data,x,xret,bidask_spread,vol_target,'');

x=EquityData.HIA.Generic123Price.HI2_Index;
xret=EquityData.HIA.Generic12Return.G2ret;
data=EquityData.HIA;
HSISubsysN=RunSubsystem(data,x,xret,bidask_spread,vol_target,'','Naive');

x=EquityData.SPX.Generic123Price.SP2_Index;
xret=EquityData.SPX.Generic12Return.G2ret;
data=EquityData.SPX;
SPXSubsys=RunSubsystem(data,x,xret,bidask_spread,vol_target,'','Boostrap');