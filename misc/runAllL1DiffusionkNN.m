%% Description
%% Spectral clustering based on kNN L1-graph with Diffusion Maps

tic;
%% Add Path
addpath('./diff_code/');
addpath('l1_ls_matlab/l1_ls_matlab');

%% Setup Input
%% data --- row: samples,  column: features.
data = Data;
epsilon_gaussian = 0.7;
num_nb = 30;
num_cluster=3;

%% Normalization
nA = NMRow(data);

%% Calculate the Similarity
D = squareform(pdist(nA));
D = exp(-D./epsilon_gaussian);

%% Diffusion maps
eps_val = 0.05;
neigen = 10;
flag_t=1; %flag_t=0 => Default: multi-scale geometry
if flag_t
    t=10;  % fixed time scale  
end
[X, eigenvals, psi, phi] = diffuse(D,eps_val,neigen);

figure, scatter3(X(:,1),X(:,2),X(:,3));

%% Find the k-nears Neighbor for each data point.
dist_manifold = squareform(pdist(X));
[~,I] = sort(dist_manifold,2);
W = L1GraphKNN(nA', I, num_nb);
WW = (W + W') /2;
idx = spectralClustering(WW,num_cluster);
eval_nmi(ClusterLabels,idx)
toc;
