%% Output optimal weights in the portfolio of subsystems

clear;
% Amyaddpath('Home');

load Setting.mat
vol_target=setting.target_vol;
load FamilySubsys.mat
%% Subsystems
SPXsubsys=FamilySubsys.Subsystem_SPX;
DAXsubsys=FamilySubsys.Subsystem_DAX; 
NKYsubsys=FamilySubsys.Subsystem_NKY;
UKXsubsys=FamilySubsys.Subsystem_UKX;
USZCsubsys=FamilySubsys.Subsystem_USZC;
GERZCsubsys=FamilySubsys.Subsystem_GERZC;
JPZCsubsys=FamilySubsys.Subsystem_JPZC;
UKZCsubsys=FamilySubsys.Subsystem_UKZC;
%subsystems' return time series
MultiSubsysMat=collate(SPXsubsys,DAXsubsys,NKYsubsys,UKXsubsys,...
    USZCsubsys,GERZCsubsys,JPZCsubsys,UKZCsubsys); 

%generate weights of subsystems
sys=genSubsyswgt(MultiSubsysMat,vol_target);
sys.log=datestr(now);
sys.name='Equity-FixedIncome 8 asset classes systems';

%% Convert weights to daily from weekly
weeklywgts=fints(sys.weektimestamp,sys.wgts);
dailywgts=todaily(weeklywgts);
dailywgts=fillts(dailywgts,'nearest'); %not perfect as it forward looks 2 days

dailydummy=fints(datenum(setting.timestamp,'dd/mm/yyyy'),NaN(size(setting.timestamp,1),1));
Dailywgts=merge(dailywgts,dailydummy);
Dailywgts=fillts(Dailywgts,'nearest'); %not perfect as it forward looks 2 days
Dailywgts=Dailywgts(1:size(setting.timestamp,1));

sys.dailytimestamp=Dailywgts.dates;
sys.dailywgts=fts2mat(Dailywgts);
save SYS_beta_EQFI8AC.mat sys
