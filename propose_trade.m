function desired_pos = propose_trade(vol,contract_size,price,forecast,fx,cash_vol_target,weight,diversifer)
%PROPOSE_TRADE: calculate desired positions to buy/sell
%   Detailed explanation goes here

block_value=0.01*contract_size.*price;

dollar_vol=vol.*block_value.*fx; %volatility in $ dollar term

subsys_pos=cash_vol_target./dollar_vol.*forecast/10;

desired_pos=subsys_pos.*weight.*diversifer;
end

