function sys=genSubsyswgt(MultiSubsysMat,vol_target)
% genSubsyswgt: generate optimal weights of subsystems
% Input:    MultiSubsysMat: multi subsystems time series generated from
% collate.m
%           vol_target: target volatility

blend_type='Boostrap';

sz=size(MultiSubsysMat.weekts,1);
Weekts=MultiSubsysMat.weekts;
wgtts=nan(size(MultiSubsysMat.weekts)); %wegiths time series
dmts=nan(size(MultiSubsysMat.weekts,1),1);
j=0;
for i=52*10:52:sz
    wts=Weekts(1:i,:);
    if strcmp(blend_type,'Boostrap') 
        %% Boostrap
        rettsStruct=CV_block(wts,100,20,8,1);
        [correl,wgt]=Boostrap(rettsStruct,'',vol_target);
        dm=diversify_multiplier(correl,wgt');
    else
        error('not ready');
    end
    if i==520
        wgtts(1:i,:)=repmat(wgt',i,1);
        dmts(1:i,1)=repmat(dm,i,1);
    else
        wgtts(j+1:i,:)=repmat(wgt',i-j,1);
        dmts(j+1:i,1)=repmat(dm,i-j,1);
    end
    j=i;
end
wgtts=backshift(52,wgtts); wgtts(1:520,:)=NaN;
dmts=backshift(52,wgtts); dmts(1:520,:)=NaN;
sys.instrument=MultiSubsysMat.name;
sys.corr=correl;
sys.wgts=wgtts;
sys.dmts=dmts;% diversified multipiler
sys.weektimestamp=MultiSubsysMat.weektimestamp;
