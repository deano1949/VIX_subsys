load Sigmaa005_FamilySubsys.mat

nm=fieldnames(FamilySubsys);

namelist=cell(0);
currentsignal=table;
for i=1:length(nm)
    subsys=FamilySubsys.(nm{i});
    namelist=vertcat(namelist,subsys.name);
    currentsignal=vertcat(currentsignal,subsys.CurrentStatus);
end
writetable(table(namelist),'Sigmaa005ScoreBoard.xlsx','Sheet','Output','Range','A1');
writetable(currentsignal,'Sigmaa005ScoreBoard.xlsx','Sheet','Output','Range','B1');
