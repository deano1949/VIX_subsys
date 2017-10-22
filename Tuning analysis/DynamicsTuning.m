%% Description
% This script analyse the output of dynamics tuning output

load DynamicsTuningOutput.mat

%TuneSPX

TuneSPX=DynamicsTuningOutput.TuneSPX;

nm=fieldnames(TuneSPX);
sz=length(nm);

for i=1:sz
    win=TuneSPX.(nm{i});
    EWMAC(i,:)=win.EWMAC.meansharpe;
    IR(i,:)=win.InfoRatio.meansharpe;
    EBP=fieldnames(win.EWMAC.Optimal_Parameter);
    EWMACBstPara(i,:)=EBP;
    IRBstPara(i,:)=win.InfoRatio.Optimal_Parameter;
end

writetable(EWMAC,'DynamicsTuningOutputComp.xlsx','Sheet','EWMAC');
writetable(IR,'DynamicsTuningOutputComp.xlsx','Sheet','InfoRatio');

writetable(table(EWMACBstPara),'DynamicsTuningOutputComp.xlsx','Sheet','EWMAC','Range','A20');
writetable(IRBstPara,'DynamicsTuningOutputComp.xlsx','Sheet','InfoRatio','Range','A20');