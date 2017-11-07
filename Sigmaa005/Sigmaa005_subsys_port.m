%% Output optimal weights in the portfolio of subsystems

clear;
% Amyaddpath('Home');

load Sigmaa005_Setting.mat
vol_target=setting.target_vol;
load Sigmaa005_FamilySubsys.mat
%% Subsystems
SPXsubsys=FamilySubsys.Subsystem_SPX;
UKXsubsys=FamilySubsys.Subsystem_UKX;
xxxxxx
%subsystems' return time series
MultiSubsysMat=collate(SPXsubsys,UKXsubsys); 

%generate weights of subsystems
sys=genSubsyswgt(MultiSubsysMat,vol_target);
sys.log=datestr(now);
sys.name='Simgaa005';

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
save Sigmaa005_SYS.mat sys
