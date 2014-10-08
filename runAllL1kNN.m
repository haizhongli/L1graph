%% Description
%% spectral clustering based on kNN L1 graph 


tic;
%% Add Path
addpath('./diff_code/');
addpath('l1_ls_matlab/l1_ls_matlab');

%% Setup Input
%% data --- row: samples,  column: features.
data = data10;
epsilon_gaussian = 0.7;
num_nb = 200;
num_cluster=10;

%% Normalization
nA = NMRow(data);

%% Find the k-nears Neighbor for each data point.
dist = squareform(pdist(nA));
[~,I] = sort(dist,2);
W = L1GraphKNN(nA', I, num_nb);

%%spectral clustering
WW = (W + W') /2;
idx = spectralClustering(WW,num_cluster);

%%evalulation NMI
eval_nmi(ClusterLabels,idx)
toc;
