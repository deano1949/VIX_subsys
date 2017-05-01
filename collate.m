function output = collate(t1,ts1,t2,ts2,varargin)
%COLLATE: collate time series to a time-table
% t1: timestamp of time series 1
% ts1: time series 1
% and so on

%% Load timestamp

load Setting.mat
timestamp=setting.timestamp;

timenum=datenum(timestamp,'dd/mm/yyyy');
t1=datenum(t1,'dd/mm/yyyy');
t2=datenum(t2,'dd/mm/yyyy');
mat=NaN(size(timenum,1),nargin/2);

[~,id]=ismember(t1(1),timenum);
mat(id:end,1)=ts1;
[~,id]=ismember(t2(1),timenum);
mat(id:end,2)=ts2;

if length(varargin)>1
    for i=1:length(varargin)/2
        t=datenum(varargin{2*i-1},'dd/mm/yyyy');
        [~,id]=ismember(t(1),timenum);
        mat(id:end,2+i)=varargin{2*i};
    end
end

%% Remove NaN and zeros
for i=1:size(mat,2)
    valid=~or(mat(:,i)==0,isnan(mat(:,i)));
    [~,k]=ismember(1,valid);
    mat(1:k-1,i)=NaN;
end

output.ts=mat;
output.timestamp=timestamp;
