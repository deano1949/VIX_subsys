function [correl,weights,dm]=Boostrap(cv_struct,signal_sharp,target_vol)
%%Description: To use boostrap to generate optimal weights and correlation 
%between signals or instruments
%Input: cv_struct: struct of data that generated from CV_block.m
%       signal_sharp:sharp ratio of signals or instruments
%       target_vol: target volatility
%Output: corr: correlation between inputs(signals or instruments)
%        weights: optimal weights of inputs (for trading use only)
%        dm: diversifed multiplier
fname=fieldnames(cv_struct);
sz=size(fname,1);

nfactor=size(cv_struct.(fname{1}),2);%number of inputs (signal or instrument)
sum_corr=zeros(nfactor);
x=NaN(nfactor,sz);
for i=1:sz
    name=fname{i};
    dat=cv_struct.(name);
    dat=riskadjusted_return(dat,target_vol); %risk adjusted returns
    dat(isnan(dat))=0;
    %correlation
    corrmtx=corrcoef(dat); corrmtx(isnan(corrmtx))=0; 
    corrmtx=corrmtx+eye(nfactor);corrmtx(corrmtx==2)=1; %remove NaN in correlation matrix
    sum_corr=sum_corr+corrmtx;%sum of correlation
    %optimal weights
    x(:,i)=optimiser(dat,'maxsr');% 'maxsr','minvar'
end

correl=sum_corr/sz;%average correlation
weights=mean(x,2);
% diversified multiplier
dm=1/sqrt(weights'*correl*weights);%diversifed multiplier
%capped dm in range of [1,2.5];
if dm<1
    dm=1;
elseif dm>2.5
    dm=2.5;
end
