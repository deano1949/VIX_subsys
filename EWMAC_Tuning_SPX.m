%% This script is to select best EWMAC model fast and slow parameters.

%% Load data
clear;
loc='C';
if strcmp(loc,'C')
    datadir='O:\langyu\Reading\Systematic_Trading_RobCarver\Futures Generic\';
    load(strcat(datadir,'EquityData'));
else    
    Amyaddpath('Home');
end
fstgeneric=EquityData.SPX.Generic123Price.SP1_Index;
fstgeneric=fstgeneric(~isnan(fstgeneric));
fstgenericret=[0;tick2ret(fstgeneric)];

%% Boostrap
blocks=CV_block(fstgenericret,10,30,20);
listname=fieldnames(blocks);
sharpemtx=[];
slowlist=[];
fastlist=[];
para_name={};
for i=1:size(listname,1)
    name=listname{i};
    retts=blocks.(name);
    ts=ret2tick(retts)*fstgeneric(1);
    tsmtx=[];
    j=1;
    for fast=[2 4:4:64 72:8:128]
        slow=fast*4;
        mat=EWMAC(ts,[0;retts],fast,slow,0.0003,0.2,'','');
        tsmtx=horzcat(tsmtx,mat.performance.dailyreturn);
        sharpemtx(i,j)=mat.performance.sharpe_aftercost;
        j=j+1;
        
        %Get parameter names
        if i==1
           para_name=[para_name,strcat('X_',num2str(fast),'_',num2str(slow))];
           slowlist=horzcat(slowlist,slow);
           fastlist=horzcat(fastlist,fast);
        end
    end
    avgcorr(:,:,i)=corr(tsmtx);
end

%% Parameter selection
correllimit=0.8;

%1st pair
SPXAvgCorrel=mean(avgcorr,3);
SPXmeansharpe=mean(sharpemtx);
[id,pair1]=ismember(max(SPXmeansharpe),SPXmeansharpe);

%2nd pair
correlpair2=SPXAvgCorrel(:,pair1);
correlpair2=max(correlpair2(correlpair2<correllimit));
[~,pair2]=ismember(correlpair2,SPXAvgCorrel(:,pair1));

%3rd pair
correlpair3=SPXAvgCorrel(:,pair2); correlpair3=correlpair3(1:pair2);
correlpair3=max(correlpair3(correlpair3<correllimit));
[~,pair3]=ismember(correlpair3,SPXAvgCorrel(:,pair2));

if SPXmeansharpe(pair2)<0
    pair2=pair1; %ensure shapre ratio is above 0
end
if SPXmeansharpe(pair3)<0
    pair3=pair2; %ensure shapre ratio is above 0
end

%Optimal 
Optimal_Parameter=[fastlist(pair1) fastlist(pair2) fastlist(pair3);...
    slowlist(pair1) slowlist(pair2) slowlist(pair3)];

SPXAvgCorrel=array2table(SPXAvgCorrel,'VariableNames',para_name);
SPXmeansharpe=array2table(SPXmeansharpe,'VariableNames',para_name);
try
    Optimal_Parameter_name=[para_name(pair1) para_name(pair2) para_name(pair3)];
catch
    Optimal_Parameter_name=[para_name(pair1) strcat(para_name(pair2),'_') strcat(para_name(pair3),'__')];
end
Optimal_Parameter=array2table(Optimal_Parameter,'VariableNames',Optimal_Parameter_name,'RowNames',{'fast' 'slow'});
    

%% Result

% ST: 16:64
% MT: 32:128
% LT: 60:240