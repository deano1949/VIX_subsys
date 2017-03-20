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

%Tunrover (annualised)--------------------
EWMAC_2_8=54;
EWMAC_4_16=28;
EWMAC_8_32=16;
EWMAC_16_64=11;
EWMAC_32_128=8.5;
EWMAC_64_256=7.5;
Carry=10;
setting.Turnover=table(EWMAC_2_8,EWMAC_4_16,EWMAC_8_32,EWMAC_16_64,EWMAC_32_128,EWMAC_64_256,Carry);




save('Setting.mat','setting');