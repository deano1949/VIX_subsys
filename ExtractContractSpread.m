function [spread_ret_index,statstable,generic_price,generic_return]=ExtractContractSpread(trade_start_date,contractname,datestamp,tsdat,infotable)
%% Description 
%ExtractContractSpread is to calculate the spread between front contract 
%and second front contract; it builds the strategy that sell front contract and buy 2nd front contract.
%Input:
%       trade_start_date: start date of trade (format: 'dd/mm/yyyy')
%       contractname: a string of contract name
%       datestamp: date with format string 'dd/mm/yyyy'
%       tsdat: matrix of contract price
%       infotable: a table of contract name (column 1) and expiry date('dd/mm/yyyy') (column 2)
%Output:
%       spread_ret_index: strategy pnl index(trading cost free)
%% 
fullspread_ret=[];
signal=[];
full1st_ret=[];
full2nd_ret=[];
full1stcon=[];
full2ndcon=[];
con_end_date=trade_start_date;

for i=1:size(contractname,1)
    if ~strcmp(con_end_date,datestamp(end))
        conid=contractname(i);
        sndconid=contractname(i+1);
        [~,fstcon_pos]=ismember(conid,infotable(:,1)); %vlookup first contract end date
        [~,sndcon_pos]=ismember(sndconid,infotable(:,1)); %vlookup first contract end date

        con_end_date=infotable(fstcon_pos,2);
        if i==1
            [~,con_start]=ismember(trade_start_date,datestamp); %start date of contract
        else
            con_start=con_end;%start date = end date of previous contract
        end

        if datenum(con_end_date,'dd/mm/yyyy')>datenum(datestamp(end),'dd/mm/yyyy')
            con_end_date=datestamp(end);
        end
        [~,con_end]=ismember(con_end_date,datestamp);%end date of contract

        % extract trading contract time series
        fstcon=tsdat(con_start:con_end,fstcon_pos); %front contract price
        sndcon=tsdat(con_start:con_end,sndcon_pos); %2nd front contract price
        fc_ret=tick2ret(fstcon); %front contract daily return
        sc_ret=tick2ret(sndcon); %second contract daily return

        %trading rule: sell front contract buy 2nd front contract
        spread_ret=-fc_ret+sc_ret;
        fullspread_ret=[fullspread_ret;spread_ret];

        %Generate signal sndcon-fstcon
        signal=[signal; sndcon-fstcon];

        %first front contract & second front contract price & return

        full1st_ret=[full1st_ret; fc_ret];
        full2nd_ret=[full2nd_ret; sc_ret];

        full1stcon=[full1stcon; fstcon(2:end)];
        full2ndcon=[full2ndcon; sndcon(2:end)];
    end
end
generic_price=table(datetime(datestamp(2:end)),full1stcon,full2ndcon,'VariableNames',{'Date','first_generic_price','second_generic_price'});
generic_return=table(datetime(datestamp(2:end)),full1st_ret,full2nd_ret,'VariableNames',{'Date','first_generic_ret','second_generic_ret'});

spread_ret_index=ret2tick(fullspread_ret);
%% strategy's statistics (annualised)
maxdd=maxdrawdown(spread_ret_index);%max drawdown
Stratmean=(1+mean(fullspread_ret))^250-1; 
Stratstd=std(fullspread_ret)*sqrt(252);
StratSkew=skewness(fullspread_ret)/sqrt(252);
StratKurt=kurtosis(fullspread_ret)/252; %four moments of strategy
StratSR=sharpe(fullspread_ret,0)*sqrt(252); %sharpe ratio of strategy

statstable=mat2dataset([Stratmean Stratstd StratSkew StratKurt StratSR maxdd],'VarNames',{'mean','std','skewness','kurtosis','SharpeRatio','MaxDD'});

spread_ret_index=table(datetime(datestamp),spread_ret_index);
spread_ret_index=spread_ret_index(2:end,:);
