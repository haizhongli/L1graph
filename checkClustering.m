function [nmi,ac] = checkClustering(W,NumC,ClusterLabels)
idx = myNJW(W,NumC);
res = bestMap(ClusterLabels,idx);
ac = length(find(ClusterLabels == res))/length(ClusterLabels);
nmi = MutualInfo(ClusterLabels,res);
end
