%% Load data
clear;
loc='Home';
if strcmp(loc,'C')
    datadir='O:\langyu\Reading\Systematic_Trading_RobCarver\Futures Generic\';
    load(strcat(datadir,'EquityData'));
else    
    Amyaddpath('Home');
    dir='C:\Spectrion\Data\AllData\Future_Generic\';
    load(strcat(dir,'EquityData.mat'));
    load(strcat(dir,'Bond10YData.mat'));
    load(strcat(dir,'ComdtyData.mat'));
    load('Setting.mat');

end

TuningOutput=struct;
%% Equity %%%%%%%%%%%%%%%%%%%%%%%%%
%% VIX

vixpricedat=EquityData.VIX.Generic123Price.UX1_Index; %price
vixretdat=EquityData.VIX.Generic12Return.G1ret; %return

[TuneVIX.SharpeRatio.Optimal_Parameter,TuneVIX.SharpeRatio.AvgCorrel,TuneVIX.SharpeRatio.meansharpe]=SharpeRatio_Tuning(vixretdat);
[TuneVIX.EWMAC.Optimal_Parameter,TuneVIX.EWMAC.AvgCorrel,TuneVIX.EWMAC.meansharpe]=EWMAC_Tuning(vixretdat);

save('TuningOutput.mat','TuneVIX','-append');

%% SPX

spxpricedat=EquityData.SPX.Generic123Price.SP1_Index; %price
spxretdat=EquityData.SPX.Generic12Return.G1ret; %return

[TuneSPX.SharpeRatio.Optimal_Parameter,TuneSPX.SharpeRatio.AvgCorrel,TuneSPX.SharpeRatio.meansharpe]=SharpeRatio_Tuning(spxretdat);
[TuneSPX.EWMAC.Optimal_Parameter,TuneSPX.EWMAC.AvgCorrel,TuneSPX.EWMAC.meansharpe]=EWMAC_Tuning(spxretdat);

save('TuningOutput.mat','TuneSPX','-append');
%% NKY

nkypricedat=EquityData.NKY.Generic123Price.NK1_Index; %price
WTIretdat=EquityData.NKY.Generic12Return.G1ret; %return

[TuneNKY.SharpeRatio.Optimal_Parameter,TuneNKY.SharpeRatio.AvgCorrel,TuneNKY.SharpeRatio.meansharpe]=SharpeRatio_Tuning(WTIretdat);
[TuneNKY.EWMAC.Optimal_Parameter,TuneNKY.EWMAC.AvgCorrel,TuneNKY.EWMAC.meansharpe]=EWMAC_Tuning(WTIretdat);

save('TuningOutput.mat','TuneNKY','-append');

%% UKX

ukxpricedat=EquityData.UKX.Generic123Price.Z_1_Index; %price
ukxretdat=EquityData.UKX.Generic12Return.G1ret; %return

[TuneUKX.SharpeRatio.Optimal_Parameter,TuneUKX.SharpeRatio.AvgCorrel,TuneUKX.SharpeRatio.meansharpe]=SharpeRatio_Tuning(ukxretdat);
[TuneUKX.EWMAC.Optimal_Parameter,TuneUKX.EWMAC.AvgCorrel,TuneUKX.EWMAC.meansharpe]=EWMAC_Tuning(ukxretdat);

save('TuningOutput.mat','TuneUKX','-append');

%% HIA

hiapricedat=EquityData.HIA.Generic123Price.HI1_Index; %price
hiaretdat=EquityData.HIA.Generic12Return.G1ret; %return

[TuneHIA.SharpeRatio.Optimal_Parameter,TuneHIA.SharpeRatio.AvgCorrel,TuneHIA.SharpeRatio.meansharpe]=SharpeRatio_Tuning(hiaretdat);
[TuneHIA.EWMAC.Optimal_Parameter,TuneHIA.EWMAC.AvgCorrel,TuneHIA.EWMAC.meansharpe]=EWMAC_Tuning(hiaretdat);

save('TuningOutput.mat','TuneHIA','-append');


%% Commodity %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WTI

WTIpricedat=ComdtyData.WTI.Generic123Price.CL2_Comdty; %price
WTIretdat=ComdtyData.WTI.Generic12Return.G2ret; %return

[TuneWTI.SharpeRatio.Optimal_Parameter,TuneWTI.SharpeRatio.AvgCorrel,TuneWTI.SharpeRatio.meansharpe]=SharpeRatio_Tuning(WTIretdat);
[TuneWTI.EWMAC.Optimal_Parameter,TuneWTI.EWMAC.AvgCorrel,TuneWTI.EWMAC.meansharpe]=EWMAC_Tuning(WTIretdat);

save('TuningOutput.mat','TuneWTI','-append');


%% Fixed Income %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% US 10Y bond

USZCpricedat=Bond10YData.USZC.Generic123Price.TY1_Comdty; %price
USZCretdat=Bond10YData.USZC.Generic12Return.G1ret; %return

[TuneUSZC.SharpeRatio.Optimal_Parameter,TuneUSZC.SharpeRatio.AvgCorrel,TuneUSZC.SharpeRatio.meansharpe]=SharpeRatio_Tuning(USZCretdat);
[TuneUSZC.EWMAC.Optimal_Parameter,TuneUSZC.EWMAC.AvgCorrel,TuneUSZC.EWMAC.meansharpe]=EWMAC_Tuning(USZCretdat);

save('TuningOutput.mat','TuneUSZC','-append');