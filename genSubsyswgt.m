function sys=genSubsyswgt(MultiSubsysMat,vol_target)
% genSubsyswgt: generate optimal weights of subsystems
% Input:    MultiSubsysMat: multi subsystems time series generated from
% collate.m
%           vol_target: target volatility

blend_type='Boostrap';
if strcmp(blend_type,'Boostrap') 
    %% Boostrap
     rettsStruct=CV_block(MultiSubsysMat.weekts,100,30,20);
     [correl,wgt]=Boostrap(rettsStruct,'',vol_target);
else
    error('not ready');
end

sys.name=MultiSubsysMat.name;
sys.corr=correl;
sys.wgts=wgt;
sys.dm=diversify_multiplier(correl,wgt');% diversified multipiler

