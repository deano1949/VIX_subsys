%% Extracting VIX futures contract spread

%% Load data
clc;clear;
location='Home';

    if strcmp(location,'Home')
        addpath(genpath('C:\Users\Langyu\Desktop\Dropbox\GU\1.Investment\4. Alphas (new)'));
        addpath(genpath('C:\Users\gly19\Dropbox\GU\1.Investment\4. Alphas (new)\Common_codes'));
    elseif strcmp(location,'Coutts')
        addpath(genpath('O:\langyu\Reading\AlgorithmTrading_Chan_(2013)\Custom_Functions'));
        addpath('O:\langyu\Reading\AlgorithmTrading_Chan_(2013)');
    else
        error('Unrecognised location; Coutts or Home');
    end
file='VIX_Carry.xlsx';
[~,~,pricedata]=xlsread(file,'VIX Data (clean)');
[~,~,contractinfo]=xlsread(file,'Contract List');
rowcutoff_pt=3381;
colcutoff_pt=136;
infocutoff_pt=142;
infotable=[contractinfo(3:infocutoff_pt,1) contractinfo(3:infocutoff_pt,6)];
tsdat=cell2mat(pricedata(3:rowcutoff_pt,2:colcutoff_pt));
datestamp=pricedata(3:rowcutoff_pt,1); %keep date format in excel as 'dd/mm/yyyy'

Futlist='Q';
if strcmp(Futlist,'Full')
    %Full Futures list--------------------------------------------------------
    contractname=transpose(pricedata(1,2:colcutoff_pt));
    %---
    % datestamp=cell2mat(pricedata(3:rowcutoff_pt,1)); %for mac use only
      %---
%Quarter end Futures only----------------------------------
elseif strcmp(Futlist,'Q')
    idx=[1:12 15:3:138];
    contractname=infotable(idx',1);
end
%% set up
%---
trade_start_date='29/03/2004';
% trade_start_date=38075; %for mac use only
  %---
trad_cost=0.005*2; %trading cost
%% Extract contract spread
[spread_ret_index,spread_statstable,generic_price,generic_return]=ExtractContractSpread(trade_start_date,contractname,datestamp,tsdat,infotable);

%% VIX contango and backwardation switch strategy
trade_type='short_only';% 'long_short', 'long_only','short_only','long_only_threshold','short_only_threshold','long_short_threshold'
trade_contract='fst'; %'fst','snd'
[generic_fstcon,generic_sndcon,strat_ret_index,statstable] = ContanBackwardSwitch(trade_start_date,contractname,datestamp,tsdat,infotable,trade_type,trade_contract);


%% Thoughts
% Use EMA to make threshold dynamic
% Extract rolling yield from VIX front contract and SPY ETF?
% Extract rolling yield from Quarterly rolled contract?
