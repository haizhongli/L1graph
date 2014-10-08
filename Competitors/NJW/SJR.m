function [D,V] =SJR (AffSim, gni) 
nrow=max(size(AffSim));
[V, D]=eig(full(AffSim));
V=real(V);
D=real(D);
D = sum(D,2);
GCombine=[D';V];
GCombine=sortrows(GCombine')';
%GCombine=fliplr(GCombine);
D=(GCombine(1,:));
V=(GCombine(2:end,:));
a=1;
nrow=max(size(D));
for i=1:nrow
    if D(i)>=0.00001
        a=i;break;
    end
end
%b=a+gni-1;
b=min(a+gni-1,nrow);
V=V(:,a:b);

return;