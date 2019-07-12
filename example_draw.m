clear all
clc

% 
% filename="transposeNaive.csv"
% time=2.5478/1e3

filename="align_sequences_gpu_opt_3.csv"
time=[488.87] % opt 3
% filename="align_sequences_gpu_opt_1.csv"
% time=[1522.94] % opt 1
time=time/1e3

Tsize=32;
cases=0
startcol=1
box on
irf_ceilings();


inst_executed=csvread(filename,36,startcol,[36,startcol,36,startcol+cases]);
inst_executed_thread=csvread(filename,37,startcol,[37,startcol,37,startcol+cases]);
inst_integer=csvread(filename,0,startcol,[0,startcol,0,startcol+cases]);
inst_ldst=csvread(filename,1,startcol,[1,startcol,1,startcol+cases]);
fstlevelTranscations=(csvread(filename,10,startcol,[10,startcol,10,startcol+cases])+csvread(filename,11,startcol,[11,startcol,11,startcol+cases])+csvread(filename,16,startcol,[16,startcol,16,startcol+cases])+csvread(filename,17,startcol,[17,startcol,17,startcol+cases])+csvread(filename,22,startcol,[22,startcol,22,startcol+cases])+csvread(filename,23,startcol,[23,startcol,23,startcol+cases]))
scndlevelTranscations=(csvread(filename,29,startcol,[29,startcol,29,startcol+cases])+csvread(filename,30,startcol,[30,startcol,30,startcol+cases]))
dramlevelTranscations=(csvread(filename,31,startcol,[31,startcol,31,startcol+cases])+csvread(filename,32,startcol,[32,startcol,32,startcol+cases]))
 
fstlevelByte=fstlevelTranscations*Tsize
scndlevelByte=scndlevelTranscations*Tsize
dramlevelByte=dramlevelTranscations*Tsize

%inst_tot=(inst_integer+inst_ldst)/32;
inst_tot=inst_executed_thread/32
fstAI=(inst_tot)./fstlevelTranscations
scndAI=(inst_tot)./scndlevelTranscations
dramAI=(inst_tot)./dramlevelTranscations


p2=loglog((scndAI),(inst_tot./1e9/time),'g>','MarkerFaceColor','g','MarkerSize',10)
hold on
p3=loglog((dramAI),(inst_tot./1e9/time),'bo','MarkerFaceColor','b','MarkerSize',8)
hold on
p1=loglog((fstAI),(inst_tot./1e9/time),'rsquare','MarkerFaceColor','r','MarkerSize',10)
hold on
 
broadcast=inst_ldst/32
unifiedstrip=inst_ldst/4
gather=inst_ldst

a=ylim

y=inst_executed/1e9/time
a=xlim
new_xlim=[y/l1,a(2)]
plot(new_xlim,[y,y],'k--','linewidth',2)
hold on

a=ylim
new_ylim=[a(1),peakiop]

plot([4,4],new_ylim,'r-','linewidth',2)
hold on

new_ylim=[a(1),l1*0.5]
plot([0.5,0.5],new_ylim,'r-','linewidth',2)
hold on
 %plot([4/9,4/9],new_ylim,'r-','linewidth',2)
new_ylim=[a(1),l1*0.125]
plot([0.125,0.125],new_ylim,'r-','linewidth',2)
 hold on
 

legend([p1(1),p2(1),p3(1)],'L1','L2','HBM','Location','southeast','Orientation','horizontal','FontName', 'Times New Roman','FontSize',16)

ht=text(5,12,'Broadcast','FontSize', 16,'FontName','Times New Roman','Color','r');set(ht,'Rotation',90);
ht=text(0.8,12,'Unit Stride','FontSize', 16,'FontName','Times New Roman','Color','r');set(ht,'Rotation',90);

ht=text(0.2,12,'Gather','FontSize', 16,'FontName','Times New Roman','Color','r');set(ht,'Rotation',90);

text(0.1,peakiop+100,'Thoeretical Peak (warp-based): 489.6 GINSTs/s','FontSize', 16,'FontName','Times New Roman');
 
xlabel('Instuction Intensity (warp-based INSTs/Transaction)') 
ylabel({'Performance',' (warp-based GINSTs/sec)'}) 

%ht = text(minempirical/200,2,'HBM 25.8 GTransaction/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',30);
%ht = text(minempirical/300,25,'L2 93.6 GTransaction/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',30)
%ht = text(minempirical/300,90,'L1 437.5 GTransaction/s','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',30)
  
set(gca,'FontSize',16)
set(gca,'FontName','Times New Roman') 










