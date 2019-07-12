l1=14*1e3/32; %B/s
l2=2.9968*1e3/32; %B/s
memBW=828/32;

peakiop=80*4*1*1.38;% ops
int_peakiop=80*4*1.38*0.5;
ldst_peakiop=80*4*1.38*0.25;


%ceilings L1
 c=1;
 flag=0;
 x=logspace(-2,4,200);
 for i=1:length(x);
     if l1*x(i) < peakiop
         ceiling2(c)=l1*x(i);
     else
         if flag==0
             minempirical=x(i-1);
             flag=1;
         end
         ceiling2(c)=peakiop;
     end
     c=c+1;
 end
 
 loglog(x,ceiling2,'k-','linewidth',2);
 hold on
 
 
 % ceilings HBM
 c=1;
 for i=1:length(x);
     if memBW*x(i) < peakiop;
         ceiling1(c)=memBW*x(i);
     else
         ceiling1(c)=peakiop;
     end
     c=c+1;
 end
 
 
 loglog(x,ceiling1,'k-','linewidth',2);
 hold on
 
 
 
 %ceilings L2
 memBW=l2;
 c=1;
 for i=1:length(x);
     if memBW*x(i) < peakiop
         ceiling4(c)=memBW*x(i);
     else
         ceiling4(c)=peakiop;
     end
     c=c+1;
 end
 
 loglog(x,ceiling4,'k-','linewidth',2);
 hold on
 grid on
 
 

  % xx=logspace(log10(minempirical/6),3);
 % for i=1:length(xx);
 %     ceiling5(i)=ldst_peakiop
 % end
 % 
 % loglog(xx,ceiling5,'b-','linewidth',2);
 % hold on
