function mat=CV_block(ts,xunits,no_partition,no_combined,chunckno)
%Description: simulate xunits numbers of simulations from a full time
%series matrix
%
%Input: ts:return time series matrix
%       xunits: generate xunits number of monte carlo simulations
%(Optional) no_partition: number of partition of ts; (must be >20) (default =20)
%           no_combined: number of partition to combine for output time
%           series (default =2)
%Output: mat: xunits of blocks matrix

%% Remove NaN
ts=ts(~isnan(sum(ts,2)),:);

%% Create partition
if xunits>1000
    warning('maximum number of monte carlo simulaitons is capped at 1000');
    xunits=1000;
end

if nargin==2
    no_partition=20; %number of paritions
    no_combined=2;
elseif no_partition<2
    error('no_partition must be > 2');
elseif no_combined>no_partition
    error('no_combined must be < no_partition');
end
sz=size(ts,1);
%length of partition
l=floor(sz/no_partition);%length of each partition
l=l-floor(l/no_partition); %smooth out the length of partition equally

parts=struct;
for i=1:no_partition-1
    name=['n',num2str(i)];
    parts.(name)=ts((i-1)*l+1:i*l,:);
end
name=['n',num2str(no_partition)];
parts.(name)=ts((i+1)*l+1:end,:);

%% monte carlo sim
if nargin==2
    block=NaN(no_partition^2,2);
    i=1;
    for j=1:no_partition
        for k=1:no_partition
            block(i,:)=[j k];
            i=i+1;
        end
    end
else
    block=randi(no_partition,xunits,no_combined);
end
%% 
mat=struct;
rng shuffle
for i=1:xunits
    if nargin==2
        rn=randi(no_partition^2,1,1);
        B=block(rn,:);%Block number
        partname1=['n',num2str(B(1))];
        partname2=['n',num2str(B(2))];
        name=['n',num2str(i)];
        mat.(name)=vertcat(parts.(partname1),parts.(partname2));
    else
        gents=[];
        for j=1:no_combined
            partname=['n',num2str(block(i,j))];
            gents=vertcat(gents,parts.(partname));
        end
        name=['n',num2str(chunckno),'0',num2str(i)];
        mat.(name)=gents;

     end
end
