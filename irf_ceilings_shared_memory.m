% clear all
% clc

l1=14*1e3/128; %B/s
l2=2.9968*1e3/32; %B/s
memBW=828/32;

peakiop=80*4*1*1.53;% ops
int_peakiop=80*4*1.38*0.5;
ldst_peakiop=80*4*1.38*0.25;


c=1;
 cc=1;
 flag=0;
 x=logspace(-4,6,600);
 for i=1:length(x);
     if l1*x(i) < peakiop
         ceiling2(c)=l1*x(i);
         ceiling21(cc)=l1*x(i);
         newx2(cc)=x(i)
         cc=cc+1
     else
         ceiling2(c)=peakiop;
     end
     c=c+1
 end
 
 
 loglog(x,ceiling2,'k-','linewidth',2);
 hold on
 loglog(newx2,ceiling21,'r-','linewidth',2);
 hold on
 
 
 % ceilings HBM
 c=1;
 cc=1
 for i=1:length(x);
     if memBW*x(i) < peakiop;
         ceiling1(c)=memBW*x(i);
         ceiling12(cc)=memBW*x(i);
         newx1(cc)=x(i)
         cc=cc+1
     else
         ceiling1(c)=peakiop;
     end
     c=c+1;
 end
 
 
 loglog(x,ceiling1,'k-','linewidth',2);
 hold on
 loglog(newx1,ceiling12,'b-','linewidth',2);
 hold on
 
 
 %ceilings L2
 memBW=l2;
 c=1;
 cc=1;
 for i=1:length(x);
     if memBW*x(i) < peakiop
         ceiling4(c)=memBW*x(i);
         ceiling42(cc)=memBW*x(i);
         newx4(cc)=x(i)
         cc=cc+1
     else
         ceiling4(c)=peakiop;
     end
     c=c+1;
 end
 
 loglog(x,ceiling4,'k-','linewidth',2);
 hold on
 loglog(newx4,ceiling42,'g-','linewidth',2);
 hold on
 
 grid on

a=ylim

val=1/32
new_ylim=[a(1),l1*val]
plot([val,val],new_ylim,'r-','linewidth',2)
hold on

val=32/32
new_ylim=[a(1),l1*val]
plot([val,val],new_ylim,'r-','linewidth',2)
hold on

%ht=text(5,12,'No bank conflict','FontSize', 16,'FontName','Times New Roman','Color','r');set(ht,'Rotation',90);
%ht=text(0.8,12,'32-way bank conflict','FontSize', 16,'FontName','Times New Roman','Color','r');set(ht,'Rotation',90);


% text(0.1,peakiop+50,'Thoeretical Peak: 489.6 warp GIPS','FontSize', 16,'FontName','Times New Roman');
% 
% grid on 
% 
%  
% xlabel('Instuction Intensity (Warp Instructions per Transaction)') 
% ylabel({'Performance';'(warp GIPS)'}) 
% 
% ht = text(minempirical/200,2,'HBM 25.9 GTransactions/sec','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',47);
% ht = text(minempirical/300,25,'L2 93.6 GTransactions/sec','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',47)
% ht = text(minempirical/300,90,'L1 437.5 GB/sec','FontSize', 16,'FontName','Times New Roman');set(ht,'Rotation',47)
%    
% set(gca,'FontSize',16)
% set(gca,'FontName','Times New Roman') 
  % xx=logspace(log10(minempirical/6),3);
 % for i=1:length(xx);
 %     ceiling5(i)=ldst_peakiop
 % end
 % 
 % loglog(xx,ceiling5,'b-','linewidth',2);
 % hold on
