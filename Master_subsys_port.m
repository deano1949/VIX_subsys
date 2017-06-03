%% Output optimal weights in the portfolio of subsystems

clear;
Amyaddpath('Home');

load Setting.mat
vol_target=setting.target_vol;
%% Subsystems
VIXsubsys=Subsystem_VIX(); 
SPXsubsys=Subsystem_SPX(); 
WTIsubsys=Subsystem_WTI(); 

%subsystems' return time series
MultiSubsysMat=collate(VIXsubsys,SPXsubsys,WTIsubsys);

%generate weights of subsystems
sys=genSubsyswgt(MultiSubsysMat,vol_target);

save SYS_beta.mat sys