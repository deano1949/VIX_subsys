%% Description: Trade simulation for THE SYSTEM

%% load data
load SYS_beta_EQFI8AC.mat
load FamilySubsys.mat
loc='C';
    if strcmp(loc,'C')
        dir='O:\langyu\Reading\Systematic_Trading_RobCarver\Futures Generic\';
        load(strcat(dir,'EquityData_RollT-1.mat'));
        load(strcat(dir,'Bond10YData_RollT-1.mat'));
        load(strcat(dir,'ComdtyData_RollT-1.mat'));
        load(strcat(dir,'CurrencyData_RollT-1.mat'));
        load('Setting.mat');
    else
        dir='C:\Spectrion\Data\AllData\Future_Generic\';
        load(strcat(dir,'EquityData_RollT-1.mat'));
        load(strcat(dir,'Bond10YData_RollT-1.mat'));
        load(strcat(dir,'ComdtyData_RollT-1.mat'));
        load(strcat(dir,'CurrencyData_RollT-1.mat'));
        load('Setting.mat');
    end

%% Setup
AUM=1000000;
vol_target=0.2;
listF={'SPX','DAX','NKY','UKX','USZC','GERZC','JPZC','UKZC'};
listSubsysdat=struct;
listSubsysdat.(listF{1})=EquityData.SPX;
listSubsysdat.(listF{2})=EquityData.DAX;
listSubsysdat.(listF{3})=EquityData.NKY;
listSubsysdat.(listF{4})=EquityData.UKX;
listSubsysdat.(listF{5})=Bond10YData.USZC;
listSubsysdat.(listF{6})=Bond10YData.GERZC;
listSubsysdat.(listF{7})=Bond10YData.JPZC;
listSubsysdat.(listF{8})=Bond10YData.UKZC;

contract_size=[50 5 100 10 1000 1000 1000 1000]; %dummy to be automate

timestamp=setting.timestamp;
timenum=datenum(timestamp,'dd/mm/yyyy');

xmat=NaN(size(timenum,1),size(listF,2));
xretmat=NaN(size(timenum,1),size(listF,2));
signalmat=NaN(size(timenum,1),size(listF,2));
volmat=NaN(size(timenum,1),size(listF,2));
perfmat=NaN(size(timenum,1),size(listF,2));

%subsystem
namefld=fieldnames(FamilySubsys);
for i=1:length(listF)
    subsysdat=listSubsysdat.(listF{i});
    subsysname=strcat('Subsystem_',listF{i});
    subsys=FamilySubsys.(subsysname);
    xts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic123Price.(2)); %vlookup on timenum
    xmat(:,i)=xts(:,2);
    xretts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),subsysdat.Generic12Return.(2)); %vlookup on timenum
    xretmat(:,i)=xretts(:,2);
    signalts=tsvlookup(timenum,datenum(subsys.timestamp,'dd/mm/yyyy'),subsys.Signal);
    signalmat(:,i)=signalts(:,2);
    volts=tsvlookup(timenum,datenum(subsysdat.timestamp,'dd/mm/yyyy'),smartMovingStd(subsysdat.Generic12Return.(2),25));
    volmat(:,i)=volts(:,2);
    perfts=tsvlookup(timenum,datenum(subsys.timestamp,'dd/mm/yyyy'),subsys.performance.dailyreturn);
    perfmat(:,i)=perfts(:,2);
end
% sys.wgts=[0.25 0.3 0.2 0.25];
fx=repmat([1 1 1 1 1 1 1 1],size(timenum,1),1);
weight=sys.dailywgts; %instrument weights
% weight=sys.wgts;
diversifer=1;
bidask_spread=[setting.BidAskSpread.SPX setting.BidAskSpread.DAX setting.BidAskSpread.NKY setting.BidAskSpread.UKX ...
    setting.BidAskSpread.USZC setting.BidAskSpread.GERZC setting.BidAskSpread.JPZC setting.BidAskSpread.UKZC];


matt= TradeSimT2(AUM,vol_target,contract_size,xmat,xretmat,signalmat,...
    volmat,fx,weight,diversifer,bidask_spread);

matt.timestamp=timestamp;
timeseriesplot(matt.vol,timestamp)

%% Quick PNL
for l=1:size(sys.dailywgts,2)
    wgts=tsvlookup(timenum,sys.dailytimestamp,sys.dailywgts(:,l));
    WGT(:,l)=wgts(:,2);
end
ret=sum(perfmat.*WGT,2);
ret(isnan(ret))=0;

FinalSySPerf.timestamp=datestr(wgts(:,1));
FinalSySPerf.dailyreturn=ret;%
FinalSySPerf.cumpnl=cumprod(1+ret)-1; %Accumulative PNL
FinalSySPerf.apr=prod(1+ret).^(252/length(ret))-1; %annualised returns since inception
FinalSySPerf.sharpe_aftercost=mean(ret)*sqrt(252)/std(ret); %sharpe ratio since inception
try
    FinalSySPerf.maxdd=maxdrawdown(100*cumprod(1+ret)); %maxdrawdown since inception
catch
    FinalSySPerf.maxdd=NaN;
end

ret_2017=ret(7828:end); ytd_2017=prod(1+ret_2017)-1; sharpe_2017=mean(ret_2017)*sqrt(252)/std(ret_2017); mdd_2017=maxdrawdown(100*cumprod(1+ret_2017));
ret_2016=ret(7567:7827); ytd_2016=prod(1+ret_2016)-1; sharpe_2016=mean(ret_2016)*sqrt(252)/std(ret_2016); mdd_2016=maxdrawdown(100*cumprod(1+ret_2016));
ret_2015=ret(7306:7566);ytd_2015=prod(1+ret_2015)-1; sharpe_2015=mean(ret_2015)*sqrt(252)/std(ret_2015); mdd_2015=maxdrawdown(100*cumprod(1+ret_2015));
ret_2014=ret(7045:7305);ytd_2014=prod(1+ret_2014)-1; sharpe_2014=mean(ret_2014)*sqrt(252)/std(ret_2014); mdd_2014=maxdrawdown(100*cumprod(1+ret_2014));
ret_2013=ret(6784:7044);ytd_2013=prod(1+ret_2013)-1; sharpe_2013=mean(ret_2013)*sqrt(252)/std(ret_2013); mdd_2013=maxdrawdown(100*cumprod(1+ret_2013));
ret_2012=ret(6523:6783);ytd_2012=prod(1+ret_2012)-1; sharpe_2012=mean(ret_2012)*sqrt(252)/std(ret_2012); mdd_2012=maxdrawdown(100*cumprod(1+ret_2012));
ret_2011=ret(6263:6522);ytd_2011=prod(1+ret_2011)-1; sharpe_2011=mean(ret_2011)*sqrt(252)/std(ret_2011); mdd_2011=maxdrawdown(100*cumprod(1+ret_2011));
ret_2010=ret(6002:6262);ytd_2010=prod(1+ret_2010)-1; sharpe_2010=mean(ret_2010)*sqrt(252)/std(ret_2010); mdd_2010=maxdrawdown(100*cumprod(1+ret_2010));
ret_2009=ret(5742:6001);ytd_2009=prod(1+ret_2009)-1; sharpe_2009=mean(ret_2009)*sqrt(252)/std(ret_2009); mdd_2009=maxdrawdown(100*cumprod(1+ret_2009));
ret_2008=ret(5479:5741);ytd_2008=prod(1+ret_2008)-1; sharpe_2008=mean(ret_2008)*sqrt(252)/std(ret_2008); mdd_2008=maxdrawdown(100*cumprod(1+ret_2008));
ret_2007=ret(5218:5478);ytd_2007=prod(1+ret_2007)-1; sharpe_2007=mean(ret_2007)*sqrt(252)/std(ret_2007); mdd_2007=maxdrawdown(100*cumprod(1+ret_2007));
ret_2006=ret(4958:5217);ytd_2006=prod(1+ret_2006)-1; sharpe_2006=mean(ret_2006)*sqrt(252)/std(ret_2006); mdd_2006=maxdrawdown(100*cumprod(1+ret_2006));
ret_2005=ret(4698:4957);ytd_2005=prod(1+ret_2005)-1; sharpe_2005=mean(ret_2005)*sqrt(252)/std(ret_2005); mdd_2005=maxdrawdown(100*cumprod(1+ret_2005));
ret_2004=ret(4436:4697);ytd_2004=prod(1+ret_2004)-1; sharpe_2004=mean(ret_2004)*sqrt(252)/std(ret_2004); mdd_2004=maxdrawdown(100*cumprod(1+ret_2004));
ret_2003=ret(4175:4435);ytd_2003=prod(1+ret_2003)-1; sharpe_2003=mean(ret_2003)*sqrt(252)/std(ret_2003); mdd_2003=maxdrawdown(100*cumprod(1+ret_2003));
ret_2002=ret(3914:4174);ytd_2002=prod(1+ret_2002)-1; sharpe_2002=mean(ret_2002)*sqrt(252)/std(ret_2002); mdd_2002=maxdrawdown(100*cumprod(1+ret_2002));
ret_2001=ret(3653:3913);ytd_2001=prod(1+ret_2001)-1; sharpe_2001=mean(ret_2001)*sqrt(252)/std(ret_2001); mdd_2001=maxdrawdown(100*cumprod(1+ret_2001));
ret_2000=ret(3393:3652);ytd_2000=prod(1+ret_2000)-1; sharpe_2000=mean(ret_2000)*sqrt(252)/std(ret_2000); mdd_2000=maxdrawdown(100*cumprod(1+ret_2000));
ret_1999=ret(3132:3392);ytd_1999=prod(1+ret_1999)-1; sharpe_1999=mean(ret_1999)*sqrt(252)/std(ret_1999); mdd_1999=maxdrawdown(100*cumprod(1+ret_1999));
ret_1998=ret(2871:3131);ytd_1998=prod(1+ret_1998)-1; sharpe_1998=mean(ret_1998)*sqrt(252)/std(ret_1998); mdd_1998=maxdrawdown(100*cumprod(1+ret_1998));
ret_1997=ret(2610:2870);ytd_1997=prod(1+ret_1997)-1; sharpe_1997=mean(ret_1997)*sqrt(252)/std(ret_1997); mdd_1997=maxdrawdown(100*cumprod(1+ret_1997));

ret_yearly=nan(261,21);
yearnum=1997;
for p=1:21
    eval(['ret_year=ret_',mat2str(yearnum),';']);
    ret_yearly(1:length(ret_year),p)=ret_year;
    yearnum=yearnum+1;
end
FinalSySPerf.ret_yearly=ret_yearly;
FinalSySPerf.EWport.ret_yearly=ret_yearly;

output_table=[ytd_2017 sharpe_2017 mdd_2017;
    ytd_2016 sharpe_2016 mdd_2016;
    ytd_2015 sharpe_2015 mdd_2015;
    ytd_2014 sharpe_2014 mdd_2014;
    ytd_2013 sharpe_2013 mdd_2013;
    ytd_2012 sharpe_2012 mdd_2012;
    ytd_2011 sharpe_2011 mdd_2011;
    ytd_2010 sharpe_2010 mdd_2010;
    ytd_2009 sharpe_2009 mdd_2009;
    ytd_2008 sharpe_2008 mdd_2008;
    ytd_2007 sharpe_2007 mdd_2007;
    ytd_2006 sharpe_2006 mdd_2006;
    ytd_2005 sharpe_2005 mdd_2005;
    ytd_2004 sharpe_2004 mdd_2004;
    ytd_2003 sharpe_2003 mdd_2003;
    ytd_2002 sharpe_2002 mdd_2002;
    ytd_2001 sharpe_2001 mdd_2001;
    ytd_2000 sharpe_2000 mdd_2000;
    ytd_1999 sharpe_1999 mdd_1999;
    ytd_1998 sharpe_1998 mdd_1998;
    ytd_1997 sharpe_1997 mdd_1997;];

FinalSySPerf.yearlystats=output_table;
FinalSySPerf.EWport.yearlystats=output_table;

save EQFI8AC_FinalSySPerf.mat FinalSySPerf