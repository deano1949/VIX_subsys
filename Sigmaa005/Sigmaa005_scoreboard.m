load Sigmaa005_FamilySubsys.mat

nm=fieldnames(FamilySubsys);

namelist=[];
currentsignal=table;
for i=1:length(nm)
    subsys=FamilySubsys.(nm{i});
%     namelist=vertcat(namelist,subsys.name);
    currentsignal=vertcat(currentsignal,subsys.CurrentStatus);
end

writetable(currentsignal,'Sigmaa005ScoreBoard.xlsx');