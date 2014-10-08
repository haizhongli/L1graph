%% Description
%% spectral clustering based on kNN L1 graph 


warning('off');
%% Add Path
addpath('./diff_code/');
addpath('l1_ls_matlab/l1_ls_matlab');

%% Setup Input
%% data --- row: samples,  column: features.
data = Data;
%epsilon_gaussian = 0.7;
%num_nb = 20;
num_cluster=10;
true_labels = ClusterLabels;

%% Normalization
nA = NMRow(data);

%% Find the k-nears Neighbor for each data point.
dist = squareform(pdist(nA));
[~,I] = sort(dist,2);

%% test different num_nb
m = size(data,2);
n = size(data,1);
num_tests = floor(n/m);
nmi_all = zeros(num_tests,1);
ac_all = zeros(num_tests,1);
time_all = zeros(num_tests,1);
for i = 1:num_tests
    i
    num_nb = i*m;
    
    if i == num_tests
        num_nb = n-1;
    end
    
    tic;
    W = L1GraphKNN(nA', I, num_nb);
     time_all(i) = toc;
    %%spectral clustering
    WW = (W + W') /2;
    idx = spectralClustering(WW,num_cluster);

    %%evalulation NMI

    nmi_all(i) = eval_nmi(true_labels,idx);
    %sprintf('NMI is:%.4f\n',nmi)
    [AA,RR,MM]=AccMeasure(true_labels,idx);
    %%sprintf('ACC is: %.4f\n', AA)
    ac_all(i) = AA/100;

end

