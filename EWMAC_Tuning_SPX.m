%% This script is to select best EWMAC model fast and slow parameters.

%% Load data
clear;
Amyaddpath('Home');

load EquityData.mat
fstgeneric=EquityData.SPX.Generic123Price.ES1_Index;
fstgeneric=fstgeneric(~isnan(fstgeneric));
fstgenericret=[0;tick2ret(fstgeneric)];

%% Boostrap
blocks=CV_block(fstgenericret,100,30,20);
listname=fieldnames(blocks);
sharpemtx=[];
for i=1:size(listname,1)
    name=listname{i};
    retts=blocks.(name);
    ts=ret2tick(retts)*fstgeneric(1);
    tsmtx=[];
    j=1;
    for fast=[2 4:4:64]
        slow=fast*4;
        mat=EWMAC(ts,[0;retts],fast,slow,0.0003,1);
        tsmtx=horzcat(tsmtx,mat.performance.dailyreturn);
        sharpemtx(i,j)=mat.performance.sharpe_aftercost;
        j=j+1;
    end
    avgcorr(:,:,i)=corr(tsmtx);
end
SPXAvgCorrel=mean(avgcorr,3);
SPXmeansharpe=mean(sharpemtx);

%% Result
% ST: 16:64
% MT: 32:128
% LT: 60:240