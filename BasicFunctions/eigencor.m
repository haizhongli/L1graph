function [V D] = eigencor(A, order)

if any(isnan(A(:)))
    return; 
end
[V, D]=eig(full(A));
%V=real(V);
%D=real(D);
D = sum(D,2);%+0.05;
GCombine=[D';V];
GCombine=sortrows(GCombine')';
if strcmp(order,'descend') 
    GCombine=fliplr(GCombine);
end
D=(GCombine(1,:));
V=(GCombine(2:end,:));
