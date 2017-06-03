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
name=vertcat(subsys1.name, subsys2.name);
mat=NaN(size(timenum,1),nargin);

[~,id]=ismember(t1(1),timenum);
mat(id:end,1)=ts1;
[~,id]=ismember(t2(1),timenum);
mat(id:end,2)=ts2;

if length(varargin)>1
    for i=1:length(varargin)
        subsysi=varargin{i};
        t=datenum(subsysi.timestamp,'dd/mm/yyyy');
        [~,id]=ismember(t(1),timenum);
        mat(id:end,2+i)=subsysi.performance.dailyreturn;
        name=vertcat(name,sybsysi.name);
    end
end

%% Remove NaN and zeros
for i=1:size(mat,2)
    valid=~or(mat(:,i)==0,isnan(mat(:,i)));
    [~,k]=ismember(1,valid);
    mat(1:k-1,i)=NaN;
end

output.name=name;
output.ts=mat;
output.timestamp=timestamp;

