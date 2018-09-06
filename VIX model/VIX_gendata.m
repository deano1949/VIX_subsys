%% Description
%Generate VIX data

clear;
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
colcutoff_pt=142;
infocutoff_pt=142;
infotable=[contractinfo(3:infocutoff_pt,1) contractinfo(3:infocutoff_pt,6)];
tsdat=cell2mat(pricedata(3:rowcutoff_pt,2:colcutoff_pt));
datestamp=pricedata(3:rowcutoff_pt,1); %keep date format in excel as 'dd/mm/yyyy'

Futlist='Q';

if strcmp(Futlist,'M')
%Monthly end futures--------------------------------------------------------
    contractname=transpose(pricedata(1,2:colcutoff_pt));
%Quarter end Futures only----------------------------------
elseif strcmp(Futlist,'Q')
    idx=[1:12 15:3:138];
    contractname=infotable(idx',1);
%     current_contract='
end
trade_start_date='29/03/2004';
%---Extract contract spread----
[spread_ret_index,spread_statstable,generic_price,generic_return]=ExtractContractSpread(trade_start_date,contractname,datestamp,tsdat,infotable);
fstgeneric=generic_price.first_generic_price; %Frist generic contract price
sndgeneric=generic_price.second_generic_price; %Second generic contract price
fstgeneric_ret=generic_return.first_generic_ret; %Frist generic contract return
sndgeneric_ret=generic_return.second_generic_ret; %Second generic contract return

VIX_data.trade_frequent='Q';
VIX_data.Q=table(datetime(datestamp(2:end)),fstgeneric,sndgeneric,fstgeneric_ret,sndgeneric_ret,'VariableNames',...
    {'Date','first_generic_price','second_generic_price','first_generic_ret','second_generic_ret'});

save VIX_data.mat VIX_data