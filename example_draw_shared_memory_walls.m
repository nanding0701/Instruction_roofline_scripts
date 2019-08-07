

clear all
clc

% filename="transposeNoBankConflicts.csv";
% time=10.126/1e6

filename="transposeCoalesced.csv"
time=17.214/1e6


Tsize=32;
cases=0
startcol=1
box on

inst_executed=csvread(filename,36,startcol,[36,startcol,36,startcol+cases]);
inst_executed_thread=csvread(filename,37,startcol,[37,startcol,37,startcol+cases]);

inst_integer=csvread(filename,0,startcol,[0,startcol,0,startcol+cases]);


fstlevelTranscations=(csvread(filename,10,startcol,[10,startcol,10,startcol+cases])+csvread(filename,11,startcol,[11,startcol,11,startcol+cases])+csvread(filename,16,startcol,[16,startcol,16,startcol+cases])+csvread(filename,17,startcol,[17,startcol,17,startcol+cases])+csvread(filename,22,startcol,[22,startcol,22,startcol+cases])+csvread(filename,23,startcol,[23,startcol,23,startcol+cases]))
scndlevelTranscations=(csvread(filename,29,startcol,[29,startcol,29,startcol+cases])+csvread(filename,30,startcol,[30,startcol,30,startcol+cases]))
dramlevelTranscations=(csvread(filename,31,startcol,[31,startcol,31,startcol+cases])+csvread(filename,32,startcol,[32,startcol,32,startcol+cases]))
 
inst_ldst=csvread(filename,20,startcol,[20,startcol,20,startcol+cases])+csvread(filename,21,startcol,[21,startcol,21,startcol+cases]);
shareTranscations=(csvread(filename,16,startcol,[16,startcol,16,startcol+cases])+csvread(filename,17,startcol,[17,startcol,17,startcol+cases]))

%inst_tot=(inst_integer+inst_ldst)/32;
inst_tot=(inst_executed_thread)./32

inst_tot_1=(inst_ldst)

%inst_tot_1=(inst_executed_thread-inst_ldst)./32
%nst_tot=inst_executed_thread/32
fstAI=(inst_tot)./fstlevelTranscations
scndAI=(inst_tot)./scndlevelTranscations
dramAI=(inst_tot)./dramlevelTranscations


fstAI_1=(inst_tot_1)./shareTranscations

loglog((fstAI_1),(inst_tot_1/1e9/time),'yo','MarkerSize',60,'MarkerFaceColor','y','linewidth',2)
hold on
irf_share();


p2=loglog((scndAI),(inst_tot./1e9/time),'gsquare','MarkerFaceColor','g','MarkerSize',10)
hold on
p3=loglog((dramAI),(inst_tot./1e9/time),'bsquare','MarkerFaceColor','b','MarkerSize',10)
hold on
p1=loglog((fstAI),(inst_tot./1e9/time),'rsquare','MarkerFaceColor','r','MarkerSize',10)
hold on
 
p4=loglog((fstAI_1),(inst_tot_1/1e9/time),'rsquare','MarkerSize',10,'linewidth',2)
hold on




y=(inst_executed)/1e9/time
a=xlim
new_xlim=[y/l1,a(2)]
plot(new_xlim,[y,y],'k--','linewidth',2)
hold on


legend([p1(1),p2(1),p3(1),p4(1)],'L1 (tot\_inst)','L2 (tot\_inst)','HBM (tot\_inst)','Shared (ldst\_inst)','Location','southeast','Orientation','vertical','FontName', 'Times New Roman','FontSize',16)

 
text(0.1,peakiop+50,'Thoeretical Peak: 489.6 warp GIPS','FontSize', 16,'FontName','Times New Roman');

xlabel('Instuction Intensity (Warp Instructions per Transaction)') 
ylabel({'Performance (warp GIPS)'}) 

% ht = text(minempirical/200,2,'HBM 25.9 GTransactions/sec','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',47);
% ht = text(minempirical/300,25,'L2 93.6 GTransactions/sec','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',47)
ht = text(0.02,30,'Shared 109.3 GTXN/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',20)
%   

 xlim([0.01,100])
 ylim([1,1500])
  
set(gca,'FontSize',16)
set(gca,'FontName','Times New Roman') 
set(gcf, 'Position',  [100, 100, 600, 250])
