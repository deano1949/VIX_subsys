%%Description
% The dynamics tuning performs tuning engine in a rolling window basis. It
% generates optimal parameter sets for year t using only data prior to year
% t. It avoids looking-forward bias but is very computational heavy. That's
% why I need to find out how serious the looking-forward bias is. If it is 
% not serious, then 'Master_tuning.mat' output should be reliable for end
% simulation.

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

load 'Tuning analysis/DynamicsTuningOutput.mat'
%% Equity %%%%%%%%%%%%%%%%%%%%%%%%%
eqbmkdat=EquityData.EWIndex.Generic12Return.G1ret; %bmk return

% %% SPX
% spxpricedat=EquityData.SPX.Generic123Price.SP1_Index; %price
% spxretdat=EquityData.SPX.Generic12Return.G1ret; %return
% spxactiveretdat=spxretdat-eqbmkdat; %active return
% bidaskspread=setting.BidAskSpread.SPX;
% sz=size(spxretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(spxretdat(1:endpt),bidaskspread);
%     [Tune.InfoRatio.Optimal_Parameter,~,Tune.InfoRatio.meansharpe]=InfoRatio_Tuning(spxretdat(300:endpt,1),spxactiveretdat(300:endpt,1),bidaskspread); %the first 300 days(back to 1989)SPX is average as it was only futures available
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneSPX.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneSPX=TuneSPX;
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');

%% NKY
% 
% nkypricedat=EquityData.NKY.Generic123Price.NK1_Index; %price
% nkyretdat=EquityData.NKY.Generic12Return.G1ret; %return
% nkyeqbmkdat=tsvlookup(datenum(EquityData.NKY.timestamp,'dd/mm/yyyy'),datenum(EquityData.EWIndex.timestamp,'dd/mm/yyyy'),eqbmkdat);
% nkyeqbmkdat=nkyeqbmkdat(:,2);
% nkyactiveretdat=nkyretdat-nkyeqbmkdat; %active return
% bidaskspread=setting.BidAskSpread.NKY;
% sz=size(nkyretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(nkyretdat(1:endpt),bidaskspread);
%     [Tune.InfoRatio.Optimal_Parameter,~,Tune.InfoRatio.meansharpe]=InfoRatio_Tuning(nkyretdat(300:endpt,1),nkyactiveretdat(300:endpt,1),bidaskspread); 
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneNKY.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneNKY=TuneNKY
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
% 
% %% UKX
% 
% ukxpricedat=EquityData.UKX.Generic123Price.Z_1_Index; %price
% ukxretdat=EquityData.UKX.Generic12Return.G1ret; %return
% ukxeqbmkdat=tsvlookup(datenum(EquityData.UKX.timestamp,'dd/mm/yyyy'),datenum(EquityData.EWIndex.timestamp,'dd/mm/yyyy'),eqbmkdat);
% ukxeqbmkdat=ukxeqbmkdat(:,2);
% ukxactiveretdat=ukxretdat-ukxeqbmkdat; %active return
% bidaskspread=setting.BidAskSpread.UKX;
% sz=size(ukxretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(ukxretdat(1:endpt),bidaskspread);
%     [Tune.InfoRatio.Optimal_Parameter,~,Tune.InfoRatio.meansharpe]=InfoRatio_Tuning(ukxretdat(300:endpt,1),ukxactiveretdat(300:endpt,1),bidaskspread); 
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneUKX.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneUKX=TuneUKX
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
% 
% %% CAC
% cacpricedat=EquityData.CAC.Generic123Price.CF1_Index; %price
% cacretdat=EquityData.CAC.Generic12Return.G1ret; %return
% caceqbmkdat=tsvlookup(datenum(EquityData.CAC.timestamp,'dd/mm/yyyy'),datenum(EquityData.EWIndex.timestamp,'dd/mm/yyyy'),eqbmkdat);
% caceqbmkdat=caceqbmkdat(:,2);
% cacactiveretdat=cacretdat-caceqbmkdat; %active return
% bidaskspread=setting.BidAskSpread.CAC;
% sz=size(cacretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(cacretdat(1:endpt),bidaskspread);
%     [Tune.InfoRatio.Optimal_Parameter,~,Tune.InfoRatio.meansharpe]=InfoRatio_Tuning(cacretdat(300:endpt,1),cacactiveretdat(300:endpt,1),bidaskspread); 
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneCAC.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneCAC=TuneCAC
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
% 
% %% HIA
% 
% hiapricedat=EquityData.HIA.Generic123Price.HI1_Index; %price
% hiaretdat=EquityData.HIA.Generic12Return.G1ret; %return
% hiaeqbmkdat=tsvlookup(datenum(EquityData.HIA.timestamp,'dd/mm/yyyy'),datenum(EquityData.EWIndex.timestamp,'dd/mm/yyyy'),eqbmkdat);
% hiaeqbmkdat=hiaeqbmkdat(:,2);
% hiaactiveretdat=hiaretdat-hiaeqbmkdat; %active return
% bidaskspread=setting.BidAskSpread.HIA;
% sz=size(hiaretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(hiaretdat(1:endpt),bidaskspread);
%     [Tune.InfoRatio.Optimal_Parameter,~,Tune.InfoRatio.meansharpe]=InfoRatio_Tuning(hiaretdat(300:endpt,1),hiaactiveretdat(300:endpt,1),bidaskspread); 
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneHIA.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneHIA=TuneHIA
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
% 
% %% Commodity %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% WTI
% 
% WTIpricedat=ComdtyData.WTI.Generic123Price.CL1_Comdty; %price
% WTIretdat=ComdtyData.WTI.Generic12Return.G1ret; %return
% bidaskspread=setting.BidAskSpread.WTI;
% sz=size(WTIretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(WTIretdat(1:endpt),bidaskspread);
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneWTI.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneWTI=TuneWTI
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
% 
% %% Gold
% 
% Goldpricedat=ComdtyData.Gold.Generic123Price.GC1_Comdty; %price
% Goldretdat=ComdtyData.Gold.Generic12Return.G1ret; %return
% bidaskspread=setting.BidAskSpread.Gold;
% sz=size(Goldretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(Goldretdat(1:endpt),bidaskspread);
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneGold.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneGold=TuneGold
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
% 
% %% Copper
% 
% Copperpricedat=ComdtyData.Copper.Generic123Price.LP1_Comdty; %price
% Copperretdat=ComdtyData.Copper.Generic12Return.G1ret; %return
% bidaskspread=setting.BidAskSpread.Copper;
% sz=size(Copperretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(Copperretdat(1:endpt),bidaskspread);
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneCopper.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneCopper=TuneCopper
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
% 
%% Coffee

Coffeepricedat=ComdtyData.Coffee.Generic123Price.KC1_Comdty; %price
Coffeeretdat=ComdtyData.Coffee.Generic12Return.G1ret; %return
bidaskspread=setting.BidAskSpread.Coffee;
sz=size(Coffeeretdat,1);

for endpt=2500:500:sz
    [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(Coffeeretdat(1:endpt),bidaskspread);
    nm=strcat('win',num2str(floor(endpt/250)));
    TuneCoffee.(nm)=Tune;
end
DynamicsTuningOutput.TuneCoffee=TuneCoffee
save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');

%% Fixed Income %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fibmkdat=Bond10YData.EWIndex.Generic12Return.G1ret; %bmk return

%% US 10Y bond
% 
% USZCpricedat=Bond10YData.USZC.Generic123Price.TY1_Comdty; %price
% USZCretdat=Bond10YData.USZC.Generic12Return.G1ret; %return
% uszcfibmkdat=tsvlookup(datenum(Bond10YData.USZC.timestamp,'dd/mm/yyyy'),datenum(Bond10YData.EWIndex.timestamp,'dd/mm/yyyy'),fibmkdat);
% uszcfibmkdat=uszcfibmkdat(:,2);
% USZCactiveretdat=USZCretdat-uszcfibmkdat; %active return
% bidaskspread=setting.BidAskSpread.USZC;
% sz=size(USZCretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(USZCretdat(1:endpt),bidaskspread);
%     [Tune.InfoRatio.Optimal_Parameter,~,Tune.InfoRatio.meansharpe]=InfoRatio_Tuning(USZCretdat(300:endpt,1),USZCactiveretdat(300:endpt,1),bidaskspread); 
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneUSZC.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneUSZC=TuneUSZC
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
% 
% %% UK 10Y bond
% 
% UKZCpricedat=Bond10YData.UKZC.Generic123Price.G_1_Comdty; %price
% UKZCretdat=Bond10YData.UKZC.Generic12Return.G1ret; %return
% ukzcfibmkdat=tsvlookup(datenum(Bond10YData.UKZC.timestamp,'dd/mm/yyyy'),datenum(Bond10YData.EWIndex.timestamp,'dd/mm/yyyy'),fibmkdat);
% ukzcfibmkdat=ukzcfibmkdat(:,2);
% UKZCactiveretdat=UKZCretdat-ukzcfibmkdat; %active return
% bidaskspread=setting.BidAskSpread.UKZC;
% sz=size(UKZCretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(UKZCretdat(1:endpt),bidaskspread);
%     [Tune.InfoRatio.Optimal_Parameter,~,Tune.InfoRatio.meansharpe]=InfoRatio_Tuning(UKZCretdat(300:endpt,1),UKZCactiveretdat(300:endpt,1),bidaskspread); 
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneUKZC.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneUKZC=TuneUKZC
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
% 
% %% Germany 10Y bond
% 
% GERZCpricedat=Bond10YData.GERZC.Generic123Price.RX1_Comdty; %price
% GERZCretdat=Bond10YData.GERZC.Generic12Return.G1ret; %return
% gerzcfibmkdat=tsvlookup(datenum(Bond10YData.GERZC.timestamp,'dd/mm/yyyy'),datenum(Bond10YData.EWIndex.timestamp,'dd/mm/yyyy'),fibmkdat);
% gerzcfibmkdat=gerzcfibmkdat(:,2);
% GERZCactiveretdat=GERZCretdat-gerzcfibmkdat; %active return
% bidaskspread=setting.BidAskSpread.GERZC;
% sz=size(GERZCretdat,1);
% 
% for endpt=2500:500:sz
%     [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(GERZCretdat(1:endpt),bidaskspread);
%     [Tune.InfoRatio.Optimal_Parameter,~,Tune.InfoRatio.meansharpe]=InfoRatio_Tuning(GERZCretdat(300:endpt,1),GERZCactiveretdat(300:endpt,1),bidaskspread); 
%     nm=strcat('win',num2str(floor(endpt/250)));
%     TuneGERZC.(nm)=Tune;
% end
% DynamicsTuningOutput.TuneGERZC=TuneGERZC
% save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
%% Japan 10Y bond
JPZCpricedat=Bond10YData.JPZC.Generic123Price.JB1_Comdty; %price
JPZCretdat=Bond10YData.JPZC.Generic12Return.G1ret; %return
jpzcfibmkdat=tsvlookup(datenum(Bond10YData.JPZC.timestamp,'dd/mm/yyyy'),datenum(Bond10YData.EWIndex.timestamp,'dd/mm/yyyy'),fibmkdat);
jpzcfibmkdat=jpzcfibmkdat(:,2);
JPZCactiveretdat=JPZCretdat-jpzcfibmkdat; %active return
bidaskspread=setting.BidAskSpread.JPZC;
sz=size(JPZCretdat,1);

for endpt=2500:500:sz
    [Tune.EWMAC.Optimal_Parameter,~,Tune.EWMAC.meansharpe]=EWMAC_Tuning(JPZCretdat(1:endpt),bidaskspread);
    [Tune.InfoRatio.Optimal_Parameter,~,Tune.InfoRatio.meansharpe]=InfoRatio_Tuning(JPZCretdat(300:endpt,1),JPZCactiveretdat(300:endpt,1),bidaskspread); 
    nm=strcat('win',num2str(floor(endpt/250)));
    TuneJPZC.(nm)=Tune;
end
DynamicsTuningOutput.TuneJPZC=TuneJPZC
save('Tuning analysis/DynamicsTuningOutput.mat','DynamicsTuningOutput');
