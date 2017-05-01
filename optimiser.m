function x = optimiser(dat,opttype,signal_sharp)
%OPTIMISER collates various optimisation methods

nfactor=size(dat,2);
if strcmp(opttype,'minvar') && nargir==3
    lamada=100*2;
    H=cov(dat)*lamada;%covariance of input
    Aeq=ones(1,nfactor);beq=1;%all weights add up to 1
    lb=zeros(1,nfactor); ub=ones(1,nfactor);%all weights must be between [0,1];
    x=quadprog(H,-signal_sharp,[],[],Aeq,beq,lb,ub);
elseif strcmp(opttype,'maxsr') && nargin==2
    try
        x=MaxSharpeR(dat);%maximise sharpe ratio
    catch
        x=ones(1,size(dat,2))*1/size(dat,2);
    end
else
    error('No defined optimisation type');
end




end

