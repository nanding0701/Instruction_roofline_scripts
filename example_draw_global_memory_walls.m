clear all
clc

% filename="transposeNaive.csv";
% time=48.812/1e6

filename="transposeCoalesced.csv"
time=17.214/1e6

% filename="transposeNoBankConflicts.csv";
% time=10.126/1e6


Tsize=32;
cases=0
startcol=1
box on


inst_executed=csvread(filename,36,startcol,[36,startcol,36,startcol+cases]);
inst_executed_thread=csvread(filename,37,startcol,[37,startcol,37,startcol+cases]);

inst_integer=csvread(filename,0,startcol,[0,startcol,0,startcol+cases]);

inst_ldst=csvread(filename,27,startcol,[27,startcol,27,startcol+cases])+csvread(filename,28,startcol,[28,startcol,28,startcol+cases]);

fstlevelTranscations=(csvread(filename,10,startcol,[10,startcol,10,startcol+cases])+csvread(filename,11,startcol,[11,startcol,11,startcol+cases])+csvread(filename,16,startcol,[16,startcol,16,startcol+cases])+csvread(filename,17,startcol,[17,startcol,17,startcol+cases])+csvread(filename,22,startcol,[22,startcol,22,startcol+cases])+csvread(filename,23,startcol,[23,startcol,23,startcol+cases]))
scndlevelTranscations=(csvread(filename,29,startcol,[29,startcol,29,startcol+cases])+csvread(filename,30,startcol,[30,startcol,30,startcol+cases]))
dramlevelTranscations=(csvread(filename,31,startcol,[31,startcol,31,startcol+cases])+csvread(filename,32,startcol,[32,startcol,32,startcol+cases]))
 
fstlevelByte=fstlevelTranscations*Tsize
scndlevelByte=scndlevelTranscations*Tsize
dramlevelByte=dramlevelTranscations*Tsize
globalTranscations=(csvread(filename,22,startcol,[22,startcol,22,startcol+cases])+csvread(filename,23,startcol,[23,startcol,23,startcol+cases]))

%inst_tot=(inst_integer+inst_ldst)/32;
inst_tot=(inst_executed_thread)./32

inst_tot_1=(inst_ldst)

%inst_tot_1=(inst_executed_thread-inst_ldst)./32
%nst_tot=inst_executed_thread/32
fstAI=(inst_tot)./fstlevelTranscations
scndAI=(inst_tot)./scndlevelTranscations
dramAI=(inst_tot)./dramlevelTranscations


fstAI_1=(inst_tot_1)./globalTranscations

loglog((fstAI_1),(inst_tot_1/1e9/time),'yo','MarkerSize',60,'MarkerFaceColor','y','linewidth',2)
hold on
irf_ceilings();

p2=loglog((scndAI),(inst_tot./1e9/time),'gsquare','MarkerFaceColor','g','MarkerSize',10)
hold on
p3=loglog((dramAI),(inst_tot./1e9/time),'bsquare','MarkerFaceColor','b','MarkerSize',10)
hold on
p1=loglog((fstAI),(inst_tot./1e9/time),'rsquare','MarkerFaceColor','r','MarkerSize',10)
hold on
 
p4=loglog((fstAI_1),(inst_tot_1/1e9/time),'msquare','MarkerSize',10,'linewidth',2)
hold on


% p6=loglog((scndAI),(inst_tot./1e9/time),'g>','MarkerFaceColor','g','MarkerSize',10)
% hold on
% p7=loglog((dramAI),(inst_tot./1e9/time),'b>','MarkerFaceColor','b','MarkerSize',10)
% hold on
% p5=loglog((fstAI),(inst_tot./1e9/time),'r>','MarkerFaceColor','r','MarkerSize',10)
% hold on
%  
% p8=loglog((fstAI_1),(inst_tot_1/1e9/time),'rsquare','MarkerSize',10,'linewidth',2)
% hold on
% broadcast=inst_ldst/32
% unifiedstrip=inst_ldst/8
% gather=inst_ldst
% 



y=(inst_executed)/1e9/time
a=xlim
new_xlim=[a(1),a(2)]
plot(new_xlim,[y,y],'k--','linewidth',2)
hold on

a=ylim
val=32/1/32
new_ylim=[a(1),l1*val]

plot([val,val],new_ylim,'m-','linewidth',2)
hold on
ht=text(val,12,'Stride-0','FontSize', 16,'FontName','Times New Roman','Color','m');set(ht,'Rotation',90);

val=32/4/32
new_ylim=[a(1),l1*val]
plot([val,val],new_ylim,'m-','linewidth',2)
hold on
ht=text(val,12,'Unit Stride (integer)','FontSize', 16,'FontName','Times New Roman','Color','m');set(ht,'Rotation',90);


val=32/32/32
new_ylim=[a(1),l1*val]
plot([val,val],new_ylim,'m-','linewidth',2)
hold on

ht=text(val,12,'Stride-128B','FontSize', 16,'FontName','Times New Roman','Color','m');set(ht,'Rotation',90);

legend([p1(1),p2(1),p3(1),p4(1)],'L1 (tot\_inst)','L2 (tot\_inst)','HBM (tot\_inst)','L1 (ldst\_inst)','Location','southeast','Orientation','vertical','FontName', 'Times New Roman','FontSize',16)

 
text(0.1,peakiop+50,'Thoeretical Peak: 489.6 warp GIPS','FontSize', 16,'FontName','Times New Roman');

xlabel('Instuction Intensity (Warp Instructions per Transaction)') 
ylabel({'Performance (warp GIPS)'}) 

% ht = text(minempirical/200,2,'HBM 25.9 GTransactions/sec','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',47);
% ht = text(minempirical/300,25,'L2 93.6 GTransactions/sec','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',47)
ht = text(0.02,12,'Global 437.5 GTXN/s','FontSize', 16,'FontName','Times New Roman','Color','r');set(ht,'Rotation',24)
%   

 xlim([0.01,30])
 ylim([1,1500])
  
set(gca,'FontSize',16)
set(gca,'FontName','Times New Roman') 
set(gcf, 'Position',  [100, 100, 600, 250])
