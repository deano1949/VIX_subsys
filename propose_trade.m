function desired_pos = propose_trade(vol,contract_size,price,forecast,fx,cash_vol_target,weight,diversifer)
%PROPOSE_TRADE: calculate desired positions to buy/sell
%   Detailed explanation goes here

block_value=0.01*contract_size.*price;

dollar_vol=vol.*block_value.*fx*100; %volatility in $ dollar term

subsys_pos=cash_vol_target./dollar_vol.*forecast/10;

desired_pos=subsys_pos.*weight.*diversifer;
if isnan(desired_pos)
    desired_pos=0;
else
    desired_pos=round(desired_pos);
end

end

