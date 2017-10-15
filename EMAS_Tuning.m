%% This script is to select best EWMAC model fast and slow parameters.

function [Optimal_Parameter,AvgCorrel,midsharpe]=EMAS_Tuning(fstgenericret,bid_ask_spread)
%Input: ts: return time series
%       bid_ask_spread: of instrument
%Output: Optimal_Parameter: suggested optimal parameter
%        AvgCorrel: average correlation between parameter sets
%        AvgSharpe: sharpe of parameter sets
%% Load data
fstgenericret=fstgenericret(~isnan(fstgenericret));

%% Boostrap
blocks=CV_block_MC(fstgenericret,500,1250);
listname=fieldnames(blocks);
sharpemtx=[];
slowlist=[];
fastlist=[];
smoothlist=[];
para_name={};
for i=1:size(listname,1)
    name=listname{i};
    retts=blocks.(name);
    ts=ret2tick(retts,100);
    tsmtx=[];
    j=1;
    for fast=[2 4:4:64]
        for multiple=[4 6 8]
            slow=fast*multiple;
            for smooth=10:20:70
                mat=EMAS(ts,[0;retts],fast,slow,smooth,bid_ask_spread,0.2,'','');
                tsmtx=horzcat(tsmtx,mat.performance.dailyreturn);
                sharpemtx(i,j)=mat.performance.sharpe_aftercost;
                j=j+1;

                %Get parameter names
                if i==1
                   para_name=[para_name,strcat('X_',num2str(fast),'_',num2str(slow),'_',num2str(smooth))];
                   slowlist=horzcat(slowlist,slow);
                   fastlist=horzcat(fastlist,fast);
                   smoothlist=horzcat(smoothlist,smooth);
                end
            end
        end
    end
    avgcorr(:,:,i)=corr(tsmtx);
end

%% Parameter selection
correllimit=0.8;

%1st pair
AvgCorrel=mean(avgcorr,3);
midsharpe=nanmedian(sharpemtx);
% [ix,id]=sort(midsharpe(midsharpe>0),'descend');
[ix,id]=sort(midsharpe,'descend');

if ~isempty(id)
    %1st pair
    pair1=id(1);

    %2nd pair
    if length(id)==1
        pair2=pair1;
        pair3=pair1;
    else
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
        if length(id)==3
            pair3=pair2;
        else
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
        end
    end
    %Optimal
    Optimal_Parameter=[fastlist(pair1) fastlist(pair2) fastlist(pair3);...
        slowlist(pair1) slowlist(pair2) slowlist(pair3);...
        smoothlist(pair1) smoothlist(pair2) smoothlist(pair3)];

    AvgCorrel=array2table(AvgCorrel,'VariableNames',para_name);
    midsharpe=array2table(midsharpe,'VariableNames',para_name);
    if pair1==pair2 || pair2==pair3 || pair1==pair3
        Optimal_Parameter_name=[para_name(pair1) strcat(para_name(pair2),'_') strcat(para_name(pair3),'__')];
    else
        Optimal_Parameter_name=[para_name(pair1) para_name(pair2) para_name(pair3)];
    end
    Optimal_Parameter=array2table(Optimal_Parameter,'VariableNames',Optimal_Parameter_name,'RowNames',{'fast' 'slow' 'smooth'});
else
    Optimal_Parameter={};
    AvgCorrel={};
    midsharpe={};
end

