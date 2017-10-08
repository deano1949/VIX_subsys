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
for i=1:no
    if size(ts,1)<LenTS
        chuncklen=randi([7,floor(LenTS/3)]);
    else
        chuncklen=randi([7,250]); %uniformly selected width of a chunck
    end

    submat=CV_block(ts,20,ceil(size(ts,1)/chuncklen),ceil(LenTS/chuncklen),i);
    submatnm=fieldnames(submat);
    for j=1:length(submatnm)
        mat.(submatnm{j})=submat.(submatnm{j});
    end
end