l1=14*1e3/32; %B/s
l2=2.9968*1e3/32; %B/s
memBW=828/32;

peakiop=80*4*1*1.53;% ops
int_peakiop=80*4*1.38*0.5;
ldst_peakiop=80*4*1.38*0.25;


%ceilings L1
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
 
