function [generic_fstcon,generic_sndcon,strat_ret_index,statstable] = ContanBackwardSwitch(trade_start_date,contractname,datestamp,tsdat,infotable,trade_type,trade_contract)
%% Description 
%ContanBackwardSwitch is the strategy based on contango and backwardation
%of VIX futures contract plus additional VIX threshold.
%contango is defined by front contract price is lower than 2nd front contract; vice versa
%Input:
%       trade_start_date: start date of trade (format: 'dd/mm/yyyy')
%       contractname: a string of contract name
%       datestamp: date with format string 'dd/mm/yyyy'
%       tsdat: matrix of contract price
%       infotable: a table of contract name (column 1) and expiry date('dd/mm/yyyy') (column 2)
%       trade_type:
%       'long_short', 'long_only','short_only','long_only_threshold','short_only_threshold'
%       trade_contract: decide which contract to trade; 'fst' or 'snd' (front or 2nd front contract)
%Output:
%       strat_ret_index: strategy pnl index(trading cost free)
%       generic_fstcon: generic front contract
%       generic_sndcon: generic second contract
%       statstable: show strategy statistics (see last section)

%%
full_strat_ret=[];
generic_fstcon=[];
generic_sndcon=[];
for i=1:size(contractname,1)-1
    conid=contractname(i);
    [~,con_pos]=ismember(conid,infotable(:,1)); %vlookup contract end date
%----    
    con_end_date=infotable(con_pos,2);
%     con_end_date=cell2mat(infotable(con_pos,2));%for mac use only
 %----   
    if i==1
        [~,con_start]=ismember(trade_start_date,datestamp); %start date of contract
    else
        con_start=con_end;%start date = end date of previous contract
    end
    [~,con_end]=ismember(con_end_date,datestamp);%end date of contract
    
    % extract trading contract time series
    fstcon=tsdat(con_start:con_end,i); %front contract price
    sndcon=tsdat(con_start:con_end,i+1); %2nd front contract price
    fc_ret=tick2ret(fstcon); %front contract daily return
    sc_ret=tick2ret(sndcon); %second contract daily return
    
    generic_fstcon=[generic_fstcon; fstcon(1:end-1)];
    generic_sndcon=[generic_sndcon; sndcon(1:end-1)];
    
    %trading rule: sell/buy  front contract when contango/backwardation
    % contango is defined by front contract price is lower than 2nd front
    % contract; vice versa
%     trade_type='short_only'; %'long_only';'short_only';
    switch trade_type
        case 'long_short'
               buysignal=fstcon>sndcon; 
               sellsignal=fstcon<=sndcon;
        case 'long_short_threshold'
               buysignal=fstcon>sndcon & fstcon>20; 
               sellsignal=fstcon<=sndcon & fstcon>20;               
        case 'long_only'
               buysignal=fstcon>sndcon; 
               sellsignal=zeros(size(fstcon,1),1);
        case 'long_only_threshold'
               buysignal=fstcon>sndcon & fstcon>20;%20 is mean of VIX 
               sellsignal=zeros(size(fstcon,1),1);
        case 'short_only'
               sellsignal=fstcon<=sndcon; 
               buysignal=zeros(size(fstcon,1),1);
        case 'short_only_threshold'
               sellsignal=fstcon<=sndcon & fstcon>20;%20 is mean of VIX 
               buysignal=zeros(size(fstcon,1),1);
               
    end
    
    tradesignal=buysignal-sellsignal;
    tradesignal=backshift(1,tradesignal);tradesignal=tradesignal(2:end); %shift signal forward 1 day
    
    if strcmp(trade_contract,'fst')
        strat_ret=fc_ret.*tradesignal;% trade front contract
    elseif strcmp(trade_contract,'snd')
        strat_ret=sc_ret.*tradesignal;% trade second front contract
    end
    
    full_strat_ret=[full_strat_ret; strat_ret];
end

strat_ret_index=ret2tick(full_strat_ret);

%% strategy's statistics (annualised)
maxdd=maxdrawdown(strat_ret_index);%max drawdown
Stratmean=(1+mean(full_strat_ret))^250-1; 
Stratstd=std(full_strat_ret)*sqrt(252);
StratSkew=skewness(full_strat_ret)/sqrt(252);
StratKurt=kurtosis(full_strat_ret)/252; %four moments of strategy
StratSR=sharpe(full_strat_ret,0)*sqrt(252); %sharpe ratio of strategy

statstable=mat2dataset([Stratmean Stratstd StratSkew StratKurt StratSR maxdd],'VarNames',{'mean','std','skewness','kurtosis','SharpeRatio','MaxDD'});
end

