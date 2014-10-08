function CNN=GetCNN(EuDis)

[sA,index] = sort(EuDis,2,'ascend'); 
epsilon=GetEpsilon(sA);
nrow=size(EuDis,1);
CNN=zeros(nrow,nrow);

for i=1:nrow-1
    for j = i+1 : nrow 
        %RangeI=index(i,(find(sA(i,2:end)<epsilon)+1));
        %RangeJ=index(j,(find(sA(j,2:end)<epsilon)+1));
        RangeI=index(i,(find(sA(i,1:end)<=epsilon)));
        RangeJ=index(j,(find(sA(j,1:end)<=epsilon)));
        CNN(i,j)=length(unique(intersect(RangeI,RangeJ)));
    end
end

CNN=max(CNN,CNN');
