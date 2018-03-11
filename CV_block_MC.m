function mat=CV_block_MC(ts,xunits,LenTS)
%% Dynamic generation of block bootstrapping
%Input:    ts: time seres
%          xunits: number of simulations
%          LenTS: length (in days) of output simulations
%Output:   mat: simulated time series
if size(ts,1)<LenTS
    LenTS=floor(ts/5);
end
no=xunits/20;
mat=struct;
randgen=[];
for i=1:no
    if size(ts,1)<LenTS
        chuncklen=randi([4,floor(LenTS/10)]);
    else
        chuncklen=randi([4,floor(LenTS/10)]); %uniformly selected width of a chunck
    end

    submat=CV_block(ts,20,floor(size(ts,1)/chuncklen),ceil(LenTS/chuncklen),i);
    submatnm=fieldnames(submat);
    for j=1:length(submatnm)
        mat.(submatnm{j})=submat.(submatnm{j});
    end
    randgen=[randgen; ceil(LenTS/chuncklen)];
end
i