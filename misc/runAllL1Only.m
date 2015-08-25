%% PIPELINE
%% Add Path
addpath('l1_ls_matlab/l1_ls_matlab');

%%variables
data = Data;
true_labels = ClusterLabels;
num_cluster=NumC;
result = zeros(20,2);

% normalize data
data= NMRow(data')';
nA = NMRow(data);
m = size(nA,2);
n = size(nA,1);

% L1 graph  lamda == 1
W = L1Graph(nA');
WW = (W + W') /2;
idx_l1 = spectralClustering(WW,num_cluster);
[result(1,1),result(1,2)] = evalNMIAC(true_labels,idx_l1);

% L1kNN graph,   k = 2,3,4
T = [2,3,4];
for j = 1:length(T)
    W = L1GraphKNNFast(nA', min(T(j)*m,n));
    WW = (W + W') /2;
    idx_l1knn = spectralClustering(WW,num_cluster);
    [result(2+j,1),result(2+j,2)]=evalNMIAC(true_labels,idx_l1knn);
end







