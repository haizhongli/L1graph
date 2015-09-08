function [NMI,AC] = runKmeans(data,true_labels,num_cluster)
%% k-means clustering.
%% data --- row: samples,  column: features.

%% Normalization
nA = NMRow(data')';

idx = kmeans(nA,num_cluster);

res = bestMap(true_labels,idx);
%=============  evaluate AC: accuracy ==============
AC = length(find(true_labels == res))/length(true_labels);
%=============  evaluate MIhat: nomalized mutual information =================
MIhat = MutualInfo(true_labels,res);

sprintf('NMI is:%.4f\n',MIhat)
sprintf('ACC is: %.4f\n', AC)

end;