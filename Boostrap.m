function [correl,weights]=Boostrap(cv_struct,signal_sharp,target_vol)
%%Description: To use boostrap to generate optimal weights and correlation 
%between signals or instruments
%Input: cv_struct: struct of data that generated from CV_block.m
%       signal_sharp:sharp ratio of signals or instruments
%       target_vol: target volatility
%Output: corr: correlation between inputs(signals or instruments)
%        weights: optimal weights of inputs (for trading use only)
fname=fieldnames(cv_struct);
sz=size(fname,1);

nfactor=size(cv_struct.(fname{1}),2);%number of inputs (signal or instrument)
sum_corr=zeros(nfactor);
x=NaN(nfactor,sz);
for i=1:sz
    name=fname{i};
    dat=cv_struct.(name);
    dat=riskadjusted_return(dat,target_vol); %risk adjusted returns
    %correlation
    sum_corr=sum_corr+corr(dat);%sum of correlation
    %optimal weights
    lamada=100*2;
    H=cov(dat)*lamada;%covariance of input
    Aeq=ones(1,nfactor);beq=1;%all weights add up to 1
    lb=zeros(1,nfactor); ub=ones(1,nfactor);%all weights must be between [0,1];
    x(:,i)=quadprog(H,-signal_sharp,[],[],Aeq,beq,lb,ub);
    i
end

correl=sum_corr/sz;%average correlation
weights=x;