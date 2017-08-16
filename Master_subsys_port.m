%% Output optimal weights in the portfolio of subsystems

clear;
Amyaddpath('Home');

load Setting.mat
vol_target=setting.target_vol;
load FamilySubsys.mat
%% Subsystems
VIXsubsys=FamilySubsys.Subsystem_VIX; 
SPXsubsys=FamilySubsys.Subsystem_SPX; 
WTIsubsys=FamilySubsys.Subsystem_WTI; 
USZCsubsys=FamilySubsys.Subsystem_USZC; 
%subsystems' return time series
MultiSubsysMat=collate(VIXsubsys,SPXsubsys,WTIsubsys,USZCsubsys); 

%generate weights of subsystems
sys=genSubsyswgt(MultiSubsysMat,vol_target);

save SYS_beta.mat sys