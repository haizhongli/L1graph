function ADLabels=Cluster2OutlierLabel(ClusterLabels)

nrow=max(size(ClusterLabels));
CLArray=unique(ClusterLabels);
NumC=max(size(CLArray));

ADLabels=zeros(nrow,1);

for i = 1:NumC
    ind=find(ClusterLabels(:)==CLArray(i));
    numCLi=max(size(ind));
    if numCLi<=nrow*(0.05)
        ADLabels(ind)=1;
    end
end