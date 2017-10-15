%% Load data
clear;
loc='';
    if strcmp(loc,'C')
        dir='O:\langyu\Reading\Systematic_Trading_RobCarver\Futures Generic\';
        load(strcat(dir,'EquityData_RollT-1.mat'));
        load(strcat(dir,'Bond10YData_RollT-1.mat'));
        load(strcat(dir,'ComdtyData_RollT-1.mat'));
        load(strcat(dir,'CurrencyData_RollT-1.mat'));
        load('Setting.mat');
    else
        dir='C:\Spectrion\Data\AllData\Future_Generic\';
        load(strcat(dir,'EquityData_RollT-1.mat'));
        load(strcat(dir,'Bond10YData_RollT-1.mat'));
        load(strcat(dir,'ComdtyData_RollT-1.mat'));
        load(strcat(dir,'CurrencyData_RollT-1.mat'));
        load('Setting.mat');
    end
load Setting.mat

load TuningOutput.mat
%% Equity %%%%%%%%%%%%%%%%%%%%%%%%%
eqbmkdat=EquityData.EWIndex.Generic12Return.G1ret; %bmk return

%% VIX

% vixpricedat=EquityData.VIX.Generic123Price.UX1_Index; %price
% vixretdat=EquityData.VIX.Generic12Return.G1ret; %return
% bid_ask_spread=setting.BidAskSpread.VIX/10;
% [TuneVIX.SharpeRatio.Optimal_Parameter,TuneVIX.SharpeRatio.AvgCorrel,TuneVIX.SharpeRatio.meansharpe]=SharpeRatio_Tuning(vixretdat,bid_ask_spread);
% [TuneVIX.EWMAC.Optimal_Parameter,TuneVIX.EWMAC.AvgCorrel,TuneVIX.EWMAC.meansharpe]=EWMAC_Tuning(vixretdat,bid_ask_spread);
% TuningOutput.TuneVIX=TuneVIX;
% save('TuningOutput.mat','TuningOutput');

%% SPX
spxpricedat=EquityData.SPX.Generic123Price.SP1_Index; %price
spxretdat=EquityData.SPX.Generic12Return.G1ret; %return
spxactiveretdat=spxretdat-eqbmkdat; %active return
bidaskspread=setting.BidAskSpread.SPX;
% [TuneSPX.SharpeRatio.Optimal_Parameter,TuneSPX.SharpeRatio.AvgCorrel,TuneSPX.SharpeRatio.meansharpe]=SharpeRatio_Tuning(spxretdat,bidaskspread);
[TuneSPX.EWMAC.Optimal_Parameter,TuneSPX.EWMAC.AvgCorrel,TuneSPX.EWMAC.meansharpe]=EWMAC_Tuning(spxretdat,bidaskspread);
% [TuneSPX.EMAS.Optimal_Parameter,TuneSPX.EMAS.AvgCorrel,TuneSPX.EMAS.meansharpe]=EMAS_Tuning(spxretdat,bidaskspread);
[TuneSPX.InfoRatio.Optimal_Parameter,TuneSPX.InfoRatio.AvgCorrel,TuneSPX.InfoRatio.meansharpe]=InfoRatio_Tuning(spxretdat(300:end,1),spxactiveretdat(300:end,1),bidaskspread); %the first 300 days(back to 1989)SPX is average as it was only futures available
TuningOutput.TuneSPX=TuneSPX;
save('TuningOutput.mat','TuningOutput');

%% NKY

nkypricedat=EquityData.NKY.Generic123Price.NK1_Index; %price
nkyretdat=EquityData.NKY.Generic12Return.G1ret; %return
nkyeqbmkdat=tsvlookup(datenum(EquityData.NKY.timestamp,'dd/mm/yyyy'),datenum(EquityData.EWIndex.timestamp,'dd/mm/yyyy'),eqbmkdat);
nkyeqbmkdat=nkyeqbmkdat(:,2);
nkyactiveretdat=nkyretdat-nkyeqbmkdat; %active return
bidaskspread=setting.BidAskSpread.NKY;
[TuneNKY.SharpeRatio.Optimal_Parameter,TuneNKY.SharpeRatio.AvgCorrel,TuneNKY.SharpeRatio.meansharpe]=SharpeRatio_Tuning(nkyretdat,bidaskspread);
[TuneNKY.EWMAC.Optimal_Parameter,TuneNKY.EWMAC.AvgCorrel,TuneNKY.EWMAC.meansharpe]=EWMAC_Tuning(nkyretdat,bidaskspread);
[TuneNKY.InfoRatio.Optimal_Parameter,TuneNKY.InfoRatio.AvgCorrel,TuneNKY.InfoRatio.meansharpe]=InfoRatio_Tuning(nkyretdat(300:end,1),nkyactiveretdat(300:end,1),bidaskspread); 
TuningOutput.TuneNKY=TuneNKY;
save('TuningOutput.mat','TuningOutput');

%% UKX

ukxpricedat=EquityData.UKX.Generic123Price.Z_1_Index; %price
ukxretdat=EquityData.UKX.Generic12Return.G1ret; %return
ukxeqbmkdat=tsvlookup(datenum(EquityData.UKX.timestamp,'dd/mm/yyyy'),datenum(EquityData.EWIndex.timestamp,'dd/mm/yyyy'),eqbmkdat);
ukxeqbmkdat=ukxeqbmkdat(:,2);
ukxactiveretdat=ukxretdat-ukxeqbmkdat; %active return
bidaskspread=setting.BidAskSpread.UKX;
[TuneUKX.SharpeRatio.Optimal_Parameter,TuneUKX.SharpeRatio.AvgCorrel,TuneUKX.SharpeRatio.meansharpe]=SharpeRatio_Tuning(ukxretdat,bidaskspread);
[TuneUKX.EWMAC.Optimal_Parameter,TuneUKX.EWMAC.AvgCorrel,TuneUKX.EWMAC.meansharpe]=EWMAC_Tuning(ukxretdat,bidaskspread);
[TuneUKX.InfoRatio.Optimal_Parameter,TuneUKX.InfoRatio.AvgCorrel,TuneUKX.InfoRatio.meansharpe]=InfoRatio_Tuning(ukxretdat(300:end,1),ukxactiveretdat(300:end,1),bidaskspread); 
TuningOutput.TuneUKX=TuneUKX;
save('TuningOutput.mat','TuningOutput');

%% DAX
daxpricedat=EquityData.DAX.Generic123Price.GX1_Index; %price
daxretdat=EquityData.DAX.Generic12Return.G1ret; %return
daxeqbmkdat=tsvlookup(datenum(EquityData.DAX.timestamp,'dd/mm/yyyy'),datenum(EquityData.EWIndex.timestamp,'dd/mm/yyyy'),eqbmkdat);
daxeqbmkdat=daxeqbmkdat(:,2);
daxactiveretdat=daxretdat-daxeqbmkdat; %active return
bidaskspread=setting.BidAskSpread.DAX;
[TuneDAX.SharpeRatio.Optimal_Parameter,TuneDAX.SharpeRatio.AvgCorrel,TuneDAX.SharpeRatio.meansharpe]=SharpeRatio_Tuning(daxretdat,bidaskspread);
[TuneDAX.EWMAC.Optimal_Parameter,TuneDAX.EWMAC.AvgCorrel,TuneDAX.EWMAC.meansharpe]=EWMAC_Tuning(daxretdat,bidaskspread);
[TuneDAX.InfoRatio.Optimal_Parameter,TuneDAX.InfoRatio.AvgCorrel,TuneDAX.InfoRatio.meansharpe]=InfoRatio_Tuning(daxretdat(300:end,1),daxactiveretdat(300:end,1),bidaskspread); 

TuningOutput.TuneDAX=TuneDAX;
save('TuningOutput.mat','TuningOutput');

%% HIA

hiapricedat=EquityData.HIA.Generic123Price.HI1_Index; %price
hiaretdat=EquityData.HIA.Generic12Return.G1ret; %return
hiaeqbmkdat=tsvlookup(datenum(EquityData.HIA.timestamp,'dd/mm/yyyy'),datenum(EquityData.EWIndex.timestamp,'dd/mm/yyyy'),eqbmkdat);
hiaeqbmkdat=hiaeqbmkdat(:,2);
hiaactiveretdat=hiaretdat-hiaeqbmkdat; %active return
bidaskspread=setting.BidAskSpread.HIA;
[TuneHIA.SharpeRatio.Optimal_Parameter,TuneHIA.SharpeRatio.AvgCorrel,TuneHIA.SharpeRatio.meansharpe]=SharpeRatio_Tuning(hiaretdat,bidaskspread);
[TuneHIA.EWMAC.Optimal_Parameter,TuneHIA.EWMAC.AvgCorrel,TuneHIA.EWMAC.meansharpe]=EWMAC_Tuning(hiaretdat,bidaskspread);
[TuneHIA.InfoRatio.Optimal_Parameter,TuneHIA.InfoRatio.AvgCorrel,TuneHIA.InfoRatio.meansharpe]=InfoRatio_Tuning(hiaretdat(300:end,1),hiaactiveretdat(300:end,1),bidaskspread); 

TuningOutput.TuneHIA=TuneHIA;
save('TuningOutput.mat','TuningOutput');

%% Commodity %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% WTI

% WTIpricedat=ComdtyData.WTI.Generic123Price.CL2_Comdty; %price
% WTIretdat=ComdtyData.WTI.Generic12Return.G2ret; %return
% bidaskspread=setting.BidAskSpread.WTI;
% [TuneWTI.SharpeRatio.Optimal_Parameter,TuneWTI.SharpeRatio.AvgCorrel,TuneWTI.SharpeRatio.meansharpe]=SharpeRatio_Tuning(WTIretdat,bidaskspread);
% [TuneWTI.EWMAC.Optimal_Parameter,TuneWTI.EWMAC.AvgCorrel,TuneWTI.EWMAC.meansharpe]=EWMAC_Tuning(WTIretdat,bidaskspread);
% 
% TuningOutput.TuneWTI=TuneWTI;
% save('TuningOutput.mat','TuningOutput');


%% Fixed Income %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fibmkdat=Bond10YData.EWIndex.Generic12Return.G1ret; %bmk return

%% US 10Y bond

USZCpricedat=Bond10YData.USZC.Generic123Price.TY1_Comdty; %price
USZCretdat=Bond10YData.USZC.Generic12Return.G1ret; %return
uszcfibmkdat=tsvlookup(datenum(Bond10YData.USZC.timestamp,'dd/mm/yyyy'),datenum(Bond10YData.EWIndex.timestamp,'dd/mm/yyyy'),fibmkdat);
uszcfibmkdat=uszcfibmkdat(:,2);
USZCactiveretdat=USZCretdat-uszcfibmkdat; %active return

bidaskspread=setting.BidAskSpread.USZC;
[TuneUSZC.SharpeRatio.Optimal_Parameter,TuneUSZC.SharpeRatio.AvgCorrel,TuneUSZC.SharpeRatio.meansharpe]=SharpeRatio_Tuning(USZCretdat,bidaskspread);
[TuneUSZC.EWMAC.Optimal_Parameter,TuneUSZC.EWMAC.AvgCorrel,TuneUSZC.EWMAC.meansharpe]=EWMAC_Tuning(USZCretdat,bidaskspread);
[TuneUSZC.InfoRatio.Optimal_Parameter,TuneUSZC.InfoRatio.AvgCorrel,TuneUSZC.InfoRatio.meansharpe]=InfoRatio_Tuning(USZCretdat(300:end,1),USZCactiveretdat(300:end,1),bidaskspread); 

TuningOutput.TuneUSZC=TuneUSZC;
save('TuningOutput.mat','TuningOutput');

%% UK 10Y bond

UKZCpricedat=Bond10YData.UKZC.Generic123Price.G_1_Comdty; %price
UKZCretdat=Bond10YData.UKZC.Generic12Return.G1ret; %return
ukzcfibmkdat=tsvlookup(datenum(Bond10YData.UKZC.timestamp,'dd/mm/yyyy'),datenum(Bond10YData.EWIndex.timestamp,'dd/mm/yyyy'),fibmkdat);
ukzcfibmkdat=ukzcfibmkdat(:,2);
UKZCactiveretdat=UKZCretdat-ukzcfibmkdat; %active return

bidaskspread=setting.BidAskSpread.UKZC;
[TuneUKZC.SharpeRatio.Optimal_Parameter,TuneUKZC.SharpeRatio.AvgCorrel,TuneUKZC.SharpeRatio.meansharpe]=SharpeRatio_Tuning(UKZCretdat,bidaskspread);
[TuneUKZC.EWMAC.Optimal_Parameter,TuneUKZC.EWMAC.AvgCorrel,TuneUKZC.EWMAC.meansharpe]=EWMAC_Tuning(UKZCretdat,bidaskspread);
[TuneUKZC.InfoRatio.Optimal_Parameter,TuneUKZC.InfoRatio.AvgCorrel,TuneUKZC.InfoRatio.meansharpe]=InfoRatio_Tuning(UKZCretdat(300:end,1),UKZCactiveretdat(300:end,1),bidaskspread); 

TuningOutput.TuneUKZC=TuneUKZC;
save('TuningOutput.mat','TuningOutput');

%% Germany 10Y bond

GERZCpricedat=Bond10YData.GERZC.Generic123Price.RX1_Comdty; %price
GERZCretdat=Bond10YData.GERZC.Generic12Return.G1ret; %return
gerzcfibmkdat=tsvlookup(datenum(Bond10YData.GERZC.timestamp,'dd/mm/yyyy'),datenum(Bond10YData.EWIndex.timestamp,'dd/mm/yyyy'),fibmkdat);
gerzcfibmkdat=gerzcfibmkdat(:,2);
GERZCactiveretdat=GERZCretdat-gerzcfibmkdat; %active return
bidaskspread=setting.BidAskSpread.GERZC;
[TuneGERZC.SharpeRatio.Optimal_Parameter,TuneGERZC.SharpeRatio.AvgCorrel,TuneGERZC.SharpeRatio.meansharpe]=SharpeRatio_Tuning(GERZCretdat,bidaskspread);
[TuneGERZC.EWMAC.Optimal_Parameter,TuneGERZC.EWMAC.AvgCorrel,TuneGERZC.EWMAC.meansharpe]=EWMAC_Tuning(GERZCretdat,bidaskspread);
[TuneGERZC.InfoRatio.Optimal_Parameter,TuneGERZC.InfoRatio.AvgCorrel,TuneGERZC.InfoRatio.meansharpe]=InfoRatio_Tuning(GERZCretdat(300:end,1),GERZCactiveretdat(300:end,1),bidaskspread); 

TuningOutput.TuneGERZC=TuneGERZC;
save('TuningOutput.mat','TuningOutput');
%% Japan 10Y bond
JPZCpricedat=Bond10YData.JPZC.Generic123Price.JB1_Comdty; %price
JPZCretdat=Bond10YData.JPZC.Generic12Return.G1ret; %return
jpzcfibmkdat=tsvlookup(datenum(Bond10YData.JPZC.timestamp,'dd/mm/yyyy'),datenum(Bond10YData.EWIndex.timestamp,'dd/mm/yyyy'),fibmkdat);
jpzcfibmkdat=jpzcfibmkdat(:,2);
JPZCactiveretdat=JPZCretdat-jpzcfibmkdat; %active return

bidaskspread=setting.BidAskSpread.JPZC;
[TuneJPZC.SharpeRatio.Optimal_Parameter,TuneJPZC.SharpeRatio.AvgCorrel,TuneJPZC.SharpeRatio.meansharpe]=SharpeRatio_Tuning(JPZCretdat,bidaskspread);
[TuneJPZC.EWMAC.Optimal_Parameter,TuneJPZC.EWMAC.AvgCorrel,TuneJPZC.EWMAC.meansharpe]=EWMAC_Tuning(JPZCretdat,bidaskspread);
[TuneJPZC.InfoRatio.Optimal_Parameter,TuneJPZC.InfoRatio.AvgCorrel,TuneJPZC.InfoRatio.meansharpe]=InfoRatio_Tuning(JPZCretdat(300:end,1),JPZCactiveretdat(300:end,1),bidaskspread); 

TuningOutput.TuneJPZC=TuneJPZC;
save('TuningOutput.mat','TuningOutput');

%% FX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% GBPUSD
% 
% GBPUSDpricedat=CurrencyData.GBPUSD.Generic123Price.GBPUSD_Curncy; %price
% GBPUSDretdat=CurrencyData.GBPUSD.Generic12Return.G1ret; %return
% bidaskspread=0.000001;
% [TuneGBPUSD.SharpeRatio.Optimal_Parameter,TuneGBPUSD.SharpeRatio.AvgCorrel,TuneGBPUSD.SharpeRatio.meansharpe]=SharpeRatio_Tuning(GBPUSDretdat,bidaskspread);
% [TuneGBPUSD.EWMAC.Optimal_Parameter,TuneGBPUSD.EWMAC.AvgCorrel,TuneGBPUSD.EWMAC.meansharpe]=EWMAC_Tuning(GBPUSDretdat,bidaskspread);
% 
% TuningOutput.TuneGBPUSD=TuneGBPUSD;
% save('TuningOutput.mat','TuningOutput');
% 
% %% EURUSD
% 
% EURUSDpricedat=CurrencyData.EURUSD.Generic123Price.EURUSD_Curncy; %price
% EURUSDretdat=CurrencyData.EURUSD.Generic12Return.G1ret; %return
% bidaskspread=0.000001;
% [TuneEURUSD.SharpeRatio.Optimal_Parameter,TuneEURUSD.SharpeRatio.AvgCorrel,TuneEURUSD.SharpeRatio.meansharpe]=SharpeRatio_Tuning(EURUSDretdat,bidaskspread);
% [TuneEURUSD.EWMAC.Optimal_Parameter,TuneEURUSD.EWMAC.AvgCorrel,TuneEURUSD.EWMAC.meansharpe]=EWMAC_Tuning(EURUSDretdat,bidaskspread);
% 
% TuningOutput.TuneEURUSD=TuneEURUSD;
% save('TuningOutput.mat','TuningOutput');
% 
% %% JPYUSD
% 
% JPYUSDpricedat=CurrencyData.JPYUSD.Generic123Price.JPYUSD_Curncy; %price
% JPYUSDretdat=CurrencyData.JPYUSD.Generic12Return.G1ret; %return
% bidaskspread=0.000001;
% [TuneJPYUSD.SharpeRatio.Optimal_Parameter,TuneJPYUSD.SharpeRatio.AvgCorrel,TuneJPYUSD.SharpeRatio.meansharpe]=SharpeRatio_Tuning(JPYUSDretdat,bidaskspread);
% [TuneJPYUSD.EWMAC.Optimal_Parameter,TuneJPYUSD.EWMAC.AvgCorrel,TuneJPYUSD.EWMAC.meansharpe]=EWMAC_Tuning(JPYUSDretdat,bidaskspread);
% 
% TuningOutput.TuneJPYUSD=TuneJPYUSD;
% save('TuningOutput.mat','TuningOutput');