function Sigma005_Master(runprocess)
%% Weekly Process
if strcmp(runprocess,'W')
%Download Data 

%1. C:\Spectrion\Data\PriceData\Future_Generic
gen_data_generic

%2. Generate Signals
Sigmaa005_subsys_creator

%3. Trade simulation
Sigmaa005_sys_trading_simulation

%4. Generate ScoreBoard
Sigmaa005_scoreboard


%% Yearly Process
elseif strcmp(runprocess,'Y')
%Generate optimal weights
Sigmaa005_subsys_port

end