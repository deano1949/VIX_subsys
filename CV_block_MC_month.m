function mat=CV_block_MC_month(ts,xunits,LenTS)
%% Dynamic generation of block bootstrapping
%Input:    ts: time seres
%          xunits: number of simulations
%          LenTS: length (in days) of output simulations
%Output:   mat: simulated time series
if size(ts,1)<LenTS
    LenTS=floor(ts/5);
end
%no=xunits/5;
mat=struct;

if size(ts,1)<LenTS
    chuncklen=3+randperm(floor(LenTS/3),floor(LenTS/3));
else
    chuncklen=3+randperm(floor(LenTS/3),floor(LenTS/3));
end

for i=1:length(chuncklen)
    submat=CV_block(ts,xunits/length(chuncklen),floor(size(ts,1)/chuncklen(i)),ceil(LenTS/chuncklen(i))+1,i);
    submatnm=fieldnames(submat);
    for j=1:length(submatnm)
        mat.(submatnm{j})=submat.(submatnm{j});
    end
    i
end

nm=fieldnames(mat);
for j=1:length(nm)
    randblock=mat.(nm{j});
    if size(randblock,1)>LenTS;
        mat.(nm{j})=randblock(1:LenTS,:);
    end
end
