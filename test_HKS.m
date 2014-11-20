figure,
for t = 1:10
   hts = HeatKernelSignature(Data,t);
   plot(sort(hts,'descend'),'-*');
   hold on;
end