%% PIPELINE
%% Add Path
addpath('l1_ls_matlab/l1_ls_matlab');

%%variables
data = Data;
true_labels = ClusterLabels;
num_cluster=NumC;
result = zeros(20,2);

% normalize data
nA = NMRow(data')';
D = squareform(pdist(nA));
[~,I] = sort(D,2);

%% kmeans 
idx_kmeans = kmeans(nA, num_cluster);
[result(1,1),result(1,2)] = evalNMIAC(true_labels,idx_kmeans);

% L1 graph  lamda == 1
W = L1Graph(nA');
WW = (W + W') /2;
idx_l1 = spectralClustering(WW,num_cluster);
[result(2,1),result(2,2)] = evalNMIAC(true_labels,idx_l1);

%% spectral clustering
m = size(nA,2);
n = size(nA,1);
sigma = [0.1,0.5,1.0];
T=[2,3,4];
for i = 1:length(sigma)
    %% for knn graph
    k = T(i)*m;
    tmp = zeros(n,n);
    for j = 1:n
        tmp(j,I(j,1:k)) = 1;
        tmp(I(j,1:k),j) = 1;
    end 

    WW = Gaussian(D,0,i);
    WWkNN = tmp.*WW;

    WW = NormalizationFamily(WW, -0.5);
    [egns,evecs] = NJW(WW,num_cluster);
    idx_njw  = kmeans(evecs,num_cluster);
    [result(2+i,1),result(2+i,2)]=evalNMIAC(true_labels,idx_njw);
    %% for knn graph
    k = T(i)*m;
    tmp = ones(n,n);
    for j = 1:n
        tmp(j,I(j,k+1:end)) = 0;
        tmp(I(j,k+1:end),j) = 0;
    end 

    WWkNN = NormalizationFamily(WWkNN, -0.5);
    [egns,evecs] = NJW(WWkNN,num_cluster);
    idx_knn  = kmeans(evecs,num_cluster);
    [result(2+length(sigma)+i,1),result(2+length(sigma)+i,2)]=evalNMIAC(true_labels,idx_knn);
end

% L1kNN graph,   k = 2,3,4
for j = 1:length(T)
    W = L1GraphKNN(nA', I, min(T(j)*m,n));
    WW = (W + W') /2;
    idx_l1knn = spectralClustering(WW,num_cluster);
    [result(2+2*length(sigma)+j,1),result(2+2*length(sigma)+j,2)]=evalNMIAC(true_labels,idx_l1knn);
end







