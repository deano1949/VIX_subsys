%% This script is to select best EWMAC model fast and slow parameters.

% clear;
% loc='C';
% if strcmp(loc,'C')
%     datadir='O:\langyu\Reading\Systematic_Trading_RobCarver\Futures Generic\';
%     load(strcat(datadir,'EquityData'));
% else    
%     Amyaddpath('Home');
% end

function [Optimal_Parameter,AvgCorrel,meansharpe]=SharpeRatio_Tuning(fstgenericret)
%Input: fstgeneric: return time series
%
%Output: Optimal_Parameter: suggested optimal parameter
%        AvgCorrel: average correlation between parameter sets
%        AvgSharpe: sharpe of parameter sets
%% Load data
% fstgeneric=EquityData.SPX.Generic123Price.SP1_Index;
fstgenericret=fstgenericret(~isnan(fstgenericret));

%% Boostrap
blocks=CV_block(fstgenericret,10,30,20);
listname=fieldnames(blocks);
sharpemtx=[];
periodlist=[];
para_name={};
for i=1:size(listname,1)
    name=listname{i};
    retts=blocks.(name);
    ts=ret2tick(retts)*100;
    tsmtx=[];
    j=1;
    for period=5:5:250
        mat=SharpeRatio(ts,[0;retts],period,0.0003,0.2,'','');
        tsmtx=horzcat(tsmtx,mat.performance.dailyreturn);
        sharpemtx(i,j)=mat.performance.sharpe_aftercost;
        j=j+1;
        
        %Get parameter names
        if i==1
           para_name=[para_name,strcat('X_',num2str(period))];
           periodlist=horzcat(periodlist,period);
        end
    end
    tsmtx=tsmtx(251:end,:);
    avgcorr(:,:,i)=corr(tsmtx);
end

%% Parameter selection
correllimit=0.8;

%1st pair
AvgCorrel=mean(avgcorr,3);
meansharpe=mean(sharpemtx);
[id,pair1]=ismember(max(meansharpe),meansharpe);

%2nd pair
correlpair2=AvgCorrel(:,pair1);
correlpair2=max(correlpair2(correlpair2<correllimit));
[~,pair2]=ismember(correlpair2,AvgCorrel(:,pair1));

%3rd pair
correlpair3=AvgCorrel(:,pair2); correlpair3=correlpair3(1:pair2);
correlpair3=max(correlpair3(correlpair3<correllimit));
[~,pair3]=ismember(correlpair3,AvgCorrel(:,pair2));

if meansharpe(pair2)<0
    pair2=pair1; %ensure shapre ratio is above 0
end
if meansharpe(pair3)<0
    pair3=pair2; %ensure shapre ratio is above 0
end

%Optimal 
Optimal_Parameter=[fastlist(pair1) fastlist(pair2) fastlist(pair3);...
    slowlist(pair1) slowlist(pair2) slowlist(pair3)];

AvgCorrel=array2table(AvgCorrel,'VariableNames',para_name);
meansharpe=array2table(meansharpe,'VariableNames',para_name);
try
    Optimal_Parameter_name=[para_name(pair1) para_name(pair2) para_name(pair3)];
catch
    Optimal_Parameter_name=[para_name(pair1) strcat(para_name(pair2),'_') strcat(para_name(pair3),'__')];
end
Optimal_Parameter=array2table(Optimal_Parameter,'VariableNames',Optimal_Parameter_name,'RowNames',{'fast' 'slow'});
    

