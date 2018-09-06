%% Output optimal weights in the portfolio of subsystems

clear;
% Amyaddpath('Home');

load Sigmaa005_Setting.mat
vol_target=setting.target_vol;
load Sigmaa005_FamilySubsys.mat
%% Subsystems
SPXsubsys=FamilySubsys.Subsystem_SPX;
DAXsubsys=FamilySubsys.Subsystem_DAX;
% UKXsubsys=FamilySubsys.Subsystem_UKX;
CACsubsys=FamilySubsys.Subsystem_CAC;
NKYsubsys=FamilySubsys.Subsystem_NKY;
HIAsubsys=FamilySubsys.Subsystem_HIA;
USZCsubsys=FamilySubsys.Subsystem_USZC;
UKZCsubsys=FamilySubsys.Subsystem_UKZC;
GERZCsubsys=FamilySubsys.Subsystem_GERZC;
% JPZCsubsys=FamilySubsys.Subsystem_JPZC;
WTIsubsys=FamilySubsys.Subsystem_WTI;
Goldsubsys=FamilySubsys.Subsystem_Gold;
Coffeesubsys=FamilySubsys.Subsystem_Coffee;


%subsystems' return time series
MultiSubsysMat=collate(SPXsubsys,DAXsubsys,CACsubsys, NKYsubsys, HIAsubsys,...
    USZCsubsys, UKZCsubsys, GERZCsubsys,...
    WTIsubsys, Goldsubsys, Coffeesubsys); 
 
%generate weights of subsystems
sys=genSubsyswgt(MultiSubsysMat,vol_target);
sys.log=datestr(now);
sys.name='Simgaa005';

%% Convert weights to daily from weekly
weeklywgts=fints(sys.weektimestamp,sys.wgts);
dailywgts=todaily(weeklywgts);
dailywgts=fillts(dailywgts,'nearest'); %not perfect as it forward looks 2 days

dailydummy=fints(datenum(setting.timestamp,'dd/mm/yyyy'),NaN(size(setting.timestamp,1),size(dailywgts,2)));
Dailywgts=merge(dailywgts,dailydummy);
Dailywgts=fillts(Dailywgts,'nearest'); %not perfect as it forward looks 2 days
Dailywgts=Dailywgts(1:size(setting.timestamp,1));

sys.dailytimestamp=Dailywgts.dates;
sys.dailywgts=fts2mat(Dailywgts);
save Sigmaa005_SYS.mat sys

plot(Dailywgts);
legend(sys.instrument);