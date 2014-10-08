%% Description
%% spectral clustering based on epsilon-ball L1 graph 

tic;
%% Add Path
addpath('./diff_code/');
addpath('l1_ls_matlab/l1_ls_matlab');

%% Setup Input
%% data --- row: samples,  column: features.
data = Data;
epsilon_nb = 1.0;
num_cluster=3;

%% Normalization
nA = NMRow(data);

%% Find the k-nears Neighbor for each data point.
dist = squareform(pdist(nA));
max_dist = max(max(dist));
dist = dist / max_dist;
[D,I] = sort(dist,2);
D(:,1) =[]; %% remove the node itself.
I(:,1) = []; 
W = L1GraphEBall(nA', D,I, epsilon_nb);

%%spectral clustering
WW = (W + W') /2;
idx = spectralClustering(WW,num_cluster);

%%evalulation NMI
eval_nmi(ClusterLabels,idx)
toc;
