%% Description
% This script analyse the output of dynamics tuning output

% load DynamicsTuningOutput.mat

%% TuneSPX

TuneAC=DynamicsTuningOutput.TuneJPZC;

nm=fieldnames(TuneAC);
sz=length(nm);

for i=1:sz
    win=TuneAC.(nm{i});
    EWMAC(i,:)=win.EWMAC.meansharpe;
    IR(i,:)=win.InfoRatio.meansharpe;
    EBP=fieldnames(win.EWMAC.Optimal_Parameter);
    EWMACBstPara(i,:)=EBP;
    IRBstPara(i,:)=win.InfoRatio.Optimal_Parameter;
end

writetable(EWMAC,'DynamicsTuningOutputComp.xlsx','Sheet','EWMAC','Range','A480');
writetable(IR,'DynamicsTuningOutputComp.xlsx','Sheet','InfoRatio','Range','A480');

writetable(table(EWMACBstPara),'DynamicsTuningOutputComp.xlsx','Sheet','EWMAC','Range','A500');
writetable(IRBstPara,'DynamicsTuningOutputComp.xlsx','Sheet','InfoRatio','Range','A500');