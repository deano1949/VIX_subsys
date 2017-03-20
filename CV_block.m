function mat=CV_block(ts,xunits)
%Description: simulate xunits numbers of simulations from a full time
%series matrix
%
%Input: ts:return time series matrix
%       xunits: generate xunits number of monte carlo simulations
%Output: mat: xunits of blocks matrix

%% Create partition
if xunits>250
    warning('maximum number of monte carlo simulaitons is capped at 400');
    xunits=250;
end
no_partition=20; %number of paritions
sz=size(ts,1);
%length of partition
l=floor(sz/no_partition);%length of each partition
l=l-floor(l/20); %smooth out the length of partition equally

parts=struct;
for i=1:19
    name=['n',num2str(i)];
    parts.(name)=ts((i-1)*l+1:i*l,:);
end
parts.n20=ts((i+1)*l+1:end,:);

%% monte carlo sim
block=NaN(20^2,2);
i=1;
for j=1:20
    for k=1:20
        block(i,:)=[j k];
        i=i+1;
    end
end
%% 
mat=struct;
rng shuffle
for i=1:xunits
    rn=randi(20^2,1,1);
    B=block(rn,:);%Block number
    partname1=['n',num2str(B(1))];
    partname2=['n',num2str(B(2))];
    name=['n',num2str(i)];
    mat.(name)=vertcat(parts.(partname1),parts.(partname2));
end
