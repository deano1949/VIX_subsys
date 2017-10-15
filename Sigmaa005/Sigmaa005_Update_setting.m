Amyaddpath('Home');

%List of strategies
StratName={'carry','EWMAC_ST','EWMAC_MT','EWMAC_LT'};
  
%Forecast Scalar--------------------------------
% dynamics, to be defined
% EWMAC_2_8=10.6;
% EWMAC_4_16=7.5;
% EWMAC_8_32=5.3;
% EWMAC_16_64=3.75;
% EWMAC_32_128=2.65;
% EWMAC_64_256=1.87;
% Carry=30;
% setting.FcstScalar_T=table(EWMAC_2_8,EWMAC_4_16,EWMAC_8_32,EWMAC_16_64,EWMAC_32_128,EWMAC_64_256,Carry);

%Tunrover (annualised)--------------------

%Target volatility
setting.target_vol=0.2; %target volatility

%Trading Timestamp 
load EquityData_RollT-1.mat
setting.timestamp=EquityData.SPX.timestamp;

%
save('Setting.mat','setting');