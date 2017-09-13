load 'C:\Spectrion\Data\AllData\Future_Generic\EquityData.mat'

load 'FamilySubsys.mat'

%SPX
x=EquityData.SPX.Generic123Price.ES1_Index;
xret=EquityData.SPX.Generic12Return.G1ret; xret(isnan(xret))=0;
bidask_spread=0;
vol_target=0.2;
vol='';
forecastscalar='';
t=500;
matt = SharpeRatio(x,xret,t,bidask_spread,vol_target,vol,forecastscalar);

plot(matt.performance.cumpnl);