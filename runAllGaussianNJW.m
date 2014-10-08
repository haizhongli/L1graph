function [max_nmi,max_ac,max_sigma,nmi_km,ac_km] = runAllGaussianNJW(data,true_labels,num_cluster)
% clustering using:
% Gaussian Similarity and NJW

%% Add Path
%addpath('./diff_code/');
%addpath('l1_ls_matlab/l1_ls_matlab');
addpath('BasicFunctions');
%addpath('Competitors/NJW');
%addpath('Competitors/SMCE');

%% Setup Input
%% data --- row: samples,  column: features.
%data = Data;
%num_cluster = 4;
%true_labels = ClusterLabels;

%% Normalization
nA = NMRow(data')';

%% ====== k-means ======
idx_kmeans = kmeans(nA, num_cluster);
[nmi_km,ac_km] = evalNMIAc(true_labels,idx_kmeans);


%% ====== NJW ======
%% calcualte Gaussian similairty
D = squareform(pdist(nA));
max_nmi = 0;
max_ac = 0;
max_sigma = 0;
for i = 0.2:0.2:1.6
	i
    WW = Gaussian(D,0,i);
    WW = NormalizationFamily(WW, -0.5);
    [egns,evecs] = NJW(WW,num_cluster);
    idx_njw  = kmeans(evecs,num_cluster);

    %idx_njw = kmeans(evecs,num_cluster);
    %[newctrs,ctrssize,real_wcss] = WCSSKmeans(evecs,num_cluster,50,50);
    %idx_njw = findlabels(newctrs,evecs);


    [nmi_njw,ac_njw] = evalNMIAc(true_labels,idx_njw);
    if nmi_njw > max_nmi
        max_nmi = nmi_njw;
        max_ac = ac_njw;
        max_sigma=i;
    end
end

%% ====== SMCE ======
% [Yc,Yj,clusters,missrate] = smce(Y,lambda,KMax,dim,n,gtruth,verbose);
%
% Y = DxN matrix of N data points in the D-dimensional space
% % lambda = regularization paramter for the Lasso-type optimization program
% % KMax = maximum neighborhood size to select the sparse neighbors from
% % dim = dimension of the low-dimensional embedding
% % n = number of clusters/manifolds
% % gtruth = ground-truth vector of memberships of points to the n manifolds, 
% % if not available or have just one manifold enter gtruth = []
% % verbose = if true, will report the SMCE optimization information
% % ------------------------- SMCE Outputs  ---------------------------------
% % Yc = has n cells where each cell contains the dim-dimensional embedding
% % of the data in each cluster
% % Yj = joint embedding of all data points in the (n+1)-dimensional space
% % clusters = vector of memberships of data points to n clusters
% % missrate = clustering error when n > 1 and gtruth is given
% set the parameters of the SMCE algorithm
if 0
    lambda = 1; KMax = size(nA,1); dim = num_cluster;

    % if n > 1 and know the clustering ground-truth enter below, otherwise 
    % enter empty
    gtruth = [];

    % verbose = true if want to see the sparse optimization information
    verbose = false ;

    % run SMCE on the data
    [Yc,Yj,idx_smce,missrate] = smce(nA',lambda,KMax,dim,num_cluster,gtruth,verbose);

    [nmi_smce,ac_smce] = evalNMIAc(true_labels,idx_smce);
end

