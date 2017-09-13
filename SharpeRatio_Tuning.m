%% This script is to select best SharpeRatio model periods parameters.

function [Optimal_Parameter,AvgCorrel,meansharpe]=SharpeRatio_Tuning(fstgenericret,bid_ask_spread)
%Input: fstgeneric: return time series
%       bid_ask_spread: of instrument
%Output: Optimal_Parameter: suggested optimal parameter
%        AvgCorrel: average correlation between parameter sets
%        AvgSharpe: sharpe of parameter sets
%% Load data
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
        mat=SharpeRatio(ts,[0;retts],period,bid_ask_spread,0.2,'','');
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
[ix,id]=sort(meansharpe(meansharpe>0),'descend');

if ~isempty(id)
    %1st pair
    pair1=id(1);

    %2nd pair
    l=2;
    while l<=length(id)
        crosscorrel=AvgCorrel(pair1,id(l));
        if crosscorrel<correllimit
            pair2=id(l);
            l=l+1;
            break
        end

        if l== length(id)
        pair2=pair1;
        end
        l=l+1;
    end

    %3rd pair
    if pair2==pair1
        pair3=pair2;
    else
        while l<=length(id)
            crosscorrel=AvgCorrel(pair2,id(l));
            if crosscorrel<correllimit
                pair3=id(l);
                break
            end
            if l== length(id)
            pair3=pair1;
            end
            l=l+1;
        end
    end

    %Optimal
    Optimal_Parameter=[periodlist(pair1) periodlist(pair2) periodlist(pair3)];

    AvgCorrel=array2table(AvgCorrel,'VariableNames',para_name);
    meansharpe=array2table(meansharpe,'VariableNames',para_name);
    try
        Optimal_Parameter_name=[para_name(pair1) para_name(pair2) para_name(pair3)];
    catch
        Optimal_Parameter_name=[para_name(pair1) strcat(para_name(pair2),'_') strcat(para_name(pair3),'__')];
    end
    Optimal_Parameter=array2table(Optimal_Parameter,'VariableNames',Optimal_Parameter_name,'RowNames',{'period'});
else
    Optimal_Parameter={};
    AvgCorrel={};
    meansharpe={};
end

