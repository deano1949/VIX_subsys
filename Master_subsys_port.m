%% Output optimal weights in the portfolio of subsystems

clear;
Amyaddpath('Home');

load Setting.mat
target_vol=setting.target_vol;
%% Subsystems
VIXsubsys=Subsystem_VIX(); 
SPXsubsys=Subsystem_SPX(); 
WTIsubsys=Subsystem_WTI(); 

%subsystems' return time series
Retts=collate(VIXsubsys.timestamp,VIXsubsys.performance.dailyreturn,...
    SPXsubsys.timestamp,SPXsubsys.performance.dailyreturn,...
    WTIsubsys.timestamp,WTIsubsys.performance.dailyreturn);

blend_type='Boostrap';
if strcmp(blend_type,'Boostrap') 
    %% Boostrap
     rettsStruct=CV_block(Retts.ts,100,30,20);
     [correl,wgt]=Boostrap(rettsStruct,'',target_vol);
else
    error('not ready');
end

SYS.name={'VIX','SPX','WTI'};
SYS.corr=correl;
SYS.wgts=wgt;
SYS.dm=diversify_multiplier(correl,wgt');% diversified multipiler

save SYS_beta.mat SYS