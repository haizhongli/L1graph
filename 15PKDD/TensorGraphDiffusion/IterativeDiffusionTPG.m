function [WW]=IterativeDiffusionTPG(W,K)

[m,n]=size(W);
W=W./repmat(sum(W,2),1,n);

%% Set all but KNN to zero, implies that the sum of each row < 1
[YW,IW] = sort(W,2,'descend');
newW1=zeros(m,n);
for k=1:m
    newW1(k,IW(k,1:K))=W(k,IW(k,1:K));
end

WW = W;

%% The iterative ormula 6 in the paper, number of iterations is set to 230
for k=1:200 
  
    WW=newW1*WW*newW1';
    WW = WW+ eye(length(WW));
  
end

%-------------------------