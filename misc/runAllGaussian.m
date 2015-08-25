%% Description
%% spectral clustering using Gaussian Similarity

tic;
%% Add Path
addpath('./diff_code/');
addpath('l1_ls_matlab/l1_ls_matlab');

%% Setup Input
%% data --- row: samples,  column: features.
data = Data;
num_cluster = 19;

%% Normalization
nA = NMRow(data);

%% calcualte Gaussian similairty
D = squareform(pdist(nA));
WW = simGaussian(D,0.7);

%% clustering
idx = spectralClustering(WW,4);

%% evalulationg
nmi = eval_nmi(ClusterLabels,idx);
sprintf('NMI is:%.4f\n',nmi)
[AA,RR,MM]=AccMeasure(ClusterLabels,idx);
sprintf('ACC is: %.4f\n', AA)

toc;
