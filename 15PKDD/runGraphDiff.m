data = D;
N = 20;
for i = 1:N
   
    F = GraphDiff(data,i);
   
   H = sum(F,2);
   
  if mod(i,10) == 0
      
   sum(H)
   
   %continue;
   
   figure,

   colormap(jet(300));
   subplot(2,2,1);
      hold on;
   scatter(D(:,1),D(:,2),30,H);
   hold off;
  
   subplot(2,2,2);
   hold on;
   scatter(D(:,1),D(:,2),30,F(:,1));
   plot(D(1,1),D(1,2),'r+');
   hold off;
   
   subplot(2,2,3);
   hold on;
   scatter(D(:,1),D(:,2),30,F(:,end));
   plot(D(end,1),D(end,2),'g+');
   hold off;

   
   subplot(2,2,4);
   hold on;
   scatter(D(:,1),D(:,2),30,F(:,51));
   plot(D(51,1),D(51,2),'b+');
 
   hold off;
   
   pause
  end
end