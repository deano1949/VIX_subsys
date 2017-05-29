function cost=costSR(bidask_spread, turnover, xret)
%% CostSR: to calculate annualised trading cost in sharp ratio term
% Input:    bidask_spread: bid ask spread in % term
%           turnover: annualised turnover (round trips)
%           xret: returns of instrument
% Output:   cost: cost per year in sharp ratio unit

stdev=smartstd(xret)*sqrt(252);
tcsr=2*bidask_spread/stdev; %cost per round trip in sharp ratio unit
cost=tcsr*turnover; %cost per year in sharp ratio unit
