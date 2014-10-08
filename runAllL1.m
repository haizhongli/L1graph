%% Description
%% Spectral CLustering based on L1-graph.

tic;
%% Add Path
addpath('./diff_code/');
addpath('l1_ls_matlab/l1_ls_matlab');

%% Setup Input
%% data --- row: samples,  column: features.
data = Data;
num_cluster = 3;
true_labels = ClusterLabels;

%% Normalization
nA = NMRow(data')';

W = L1GraphNoise(nA');
WW = (W + W') /2;
idx = spectralClustering(WW,num_cluster);

res = bestMap(true_labels,idx);
%=============  evaluate AC: accuracy ==============
AC = length(find(true_labels == res))/length(true_labels);
%=============  evaluate MIhat: nomalized mutual information =================
MIhat = MutualInfo(true_labels,res);

sprintf('NMI is:%.4f\n',MIhat)
sprintf('ACC is: %.4f\n', AC)
toc;
