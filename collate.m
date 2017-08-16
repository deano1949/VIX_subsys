function output = collate(subsys1,subsys2,varargin)
%COLLATE: collate time series to a time-table
% subsys1: subsystem 1
% subsys2: subsystem 2
% and so on

%% Load timestamp

load Setting.mat
timestamp=setting.timestamp;

timenum=datenum(timestamp,'dd/mm/yyyy');
t1=datenum(subsys1.timestamp,'dd/mm/yyyy');
t2=datenum(subsys2.timestamp,'dd/mm/yyyy');
ts1=subsys1.performance.dailyreturn;
ts2=subsys2.performance.dailyreturn;
name=vertcat({subsys1.name}, {subsys2.name});
mat=NaN(size(timenum,1),nargin);

lookupts=tsvlookup(timenum,t1,ts1); %vlookup on timenum
mat(:,1)=lookupts(:,2);
lookupts=tsvlookup(timenum,t2,ts2); 
mat(:,2)=lookupts(:,2);

if length(varargin)>=1
    for i=1:length(varargin)
        subsysi=varargin{i};
        t=datenum(subsysi.timestamp,'dd/mm/yyyy');
        lookupts=tsvlookup(timenum,t,subsysi.performance.dailyreturn);
        mat(:,2+i)=lookupts(:,2);
        name=vertcat(name,{subsysi.name});
    end
end

%% Remove NaN and zeros
for i=1:size(mat,2)
    valid=~or(mat(:,i)==0,isnan(mat(:,i)));
    [~,k]=ismember(1,valid);
    mat(1:k-1,i)=NaN;
end

%% Covert to weekly timeseries for correlation calculation
DailyTS=fints(datenum(timestamp,'dd/mm/yyyy'),mat);
WeekTS=toweekly(DailyTS);

output.name=name;
output.ts=mat;
output.timestamp=timestamp;
output.weekts=fts2mat(WeekTS);
output.weektimestamp=WeekTS.dates;
