Amyaddpath('Home');

%List of strategies
StratName={'EWMAC_2_8','EWMAC_4_16','EWMAC_8_32','EWMAC_16_64','EWMAC_32_128','EWMAC_64_256',...
      'carry'};

  
%Forecast Scalar--------------------------------
EWMAC_2_8=10.6;
EWMAC_4_16=7.5;
EWMAC_8_32=5.3;
EWMAC_16_64=3.75;
EWMAC_32_128=2.65;
EWMAC_64_256=1.87;
Carry=30;
setting.FcstScalar_T=table(EWMAC_2_8,EWMAC_4_16,EWMAC_8_32,EWMAC_16_64,EWMAC_32_128,EWMAC_64_256,Carry);

%Tunrover (annualised)--------------------
EWMAC_2_8=54;
EWMAC_4_16=28;
EWMAC_8_32=16;
EWMAC_16_64=11;
EWMAC_32_128=8.5;
EWMAC_64_256=7.5;
Carry=10;
setting.Turnover=table(EWMAC_2_8,EWMAC_4_16,EWMAC_8_32,EWMAC_16_64,EWMAC_32_128,EWMAC_64_256,Carry);

%Target volatility
setting.target_vol=0.2; %target volatility

%Trading Timestamp 
load EquityData_RollT-1.mat
setting.timestamp=EquityData.SPX.timestamp;

%% Bid_ask_spread_%
%Equity
BidAskSpread.VIX=0.03500;
BidAskSpread.SPX=0.00010;
BidAskSpread.CAC=0.00009;
BidAskSpread.DAX=0.00004;
BidAskSpread.NKY=0.00024;
BidAskSpread.HIA=0.00004;

%Commodity
BidAskSpread.WTI=0.00049;
BidAskSpread.Coffee=0.0004;
BidAskSpread.Gold=0.00008;
BidAskSpread.Copper=0.00064;

%FI
BidAskSpread.USZC=0.000040;
BidAskSpread.GERZC=0.000065;
BidAskSpread.UKZC=0.000085;
BidAskSpread.JPZC=0.00007;

setting.BidAskSpread=BidAskSpread;


save('Setting.mat','setting');