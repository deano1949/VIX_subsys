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

listF={'VIX','SPX','TSX','UKX','CAC','DAX','IBEX','FTSEMIB','AEX','OMX','SMI','NKY','HIA','AS51',...
    'Brent','Gasoil','WTI','UnlGasoline','HeatingOil','NatGas','Cotton','Coffee','Coca','Sugar',...
    'KanasaWheat','Corn','Wheat','LeanHogs','FeederCattle','LiveCattle','Gold','Silver','Aluminum',...
    'Nickel','Lead','Zinc','Copper',....
    'USZC','AUSZC','CAZC','GERZC','UKZC','JPZC'};

%% Instrument Correlation
timestamp=datenum(setting.timestamp,'dd/mm/yyyy');
tsmtx=nan(length(timestamp),length(listF));
for i=1:length(listF)
    if i<=14
        asset=EquityData.(listF{i});
    elseif i<=37
        asset=ComdtyData.(listF{i});
    else
        asset=Bond10YData.(listF{i});
    end
        t=datenum(asset.timestamp,'dd/mm/yyyy'); t1=t(1);
        [~,id]=ismember(t1,timestamp);
        tsmtx(id:end,i)=asset.Generic12Return.G1ret;
end
tsmtx2=fints(timestamp,tsmtx);
tsmtx2=toweekly(tsmtx2); %weekly data
tstamp=tsmtx2.dates;

tsmtx3=fts2mat(tsmtx2);
tsmtx3=tsmtx3(~isnan(sum(tsmtx3,2)),:);
%% Asset Correlation
% 10Y correlation
AssetCorrelation.Corr10Y=array2table(corr(tsmtx3),'VariableNames',listF);

% 5Y correlaiton
AssetCorrelation.Corr5Y=array2table(corr(tsmtx3(size(tsmtx3,1)-259:end,:)),'VariableNames',listF);

% 1Y correlation
AssetCorrelation.Corr1Y=array2table(corr(tsmtx3(size(tsmtx3,1)-51:end,:)),'VariableNames',listF);

% 3m correlation
AssetCorrelation.Corr3M=array2table(corr(tsmtx3(size(tsmtx3,1)-13:end,:)),'VariableNames',listF);

save AssetCorrelation.mat AssetCorrelation
