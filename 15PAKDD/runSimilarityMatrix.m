% Given a Data set, find the following three similarity matrix;
% 1. gaussian_fixed.mat  --- gaussian similarity matrix with fixed sigma;
% 2. (!!NO TUNE!!)guassian_tuned.mat  --- tuned best similarity matrix; report sigma;
% 3. cosine.mat          --- cosine similarity matrix;

data = Data;
true_labels = ClusterLabels;
num_cluster = NumC;


%% Add Path
addpath('../BasicFunctions');
addpath('../Competitors/NJW');
addpath('../');
%addpath('Competitors/SMCE');

%% Normalization
nA = NMRow(data')';

%% cosine similarity
G_cos = myCosineSim(nA);
save('cosine.mat','G_cos');
WW = NormalizationFamily(G_cos, -0.5);
[~,evecs] = NJW(WW,num_cluster);
idx_cos = kmeans(evecs,num_cluster);
[nmi_cos,ac_cos] = evalNMIAC(true_labels,idx_cos)


%% Gaussian Similarity with fixed sigma
G_fixed = myGaussianMedian(nA);
save('gaussian_fixed.mat','G_fixed');
WW = NormalizationFamily(G_fixed, -0.5);
[~,evecs] = NJW(WW,num_cluster);
idx_fixed = kmeans(evecs,num_cluster);
[nmi_fixed,ac_fixed] = evalNMIAC(true_labels,idx_fixed)


%% tune Gaussian similairty
% D = squareform(pdist(nA));
% max_nmi = 0;
% max_ac = 0;
% max_sigma = 0;
% G_tuned = zeros(size(nA,1),size(nA,1));
% for i = 0.1:0.2:1.6
%     W = Gaussian(D,0,i);
%     WW = NormalizationFamily(W, -0.5);
%     [~,evecs] = NJW(WW,num_cluster);
%     idx_njw  = kmeans(evecs,num_cluster);
% 
%     %idx_njw = kmeans(evecs,num_cluster); [newctrs,ctrssize,real_wcss] =
%     %WCSSKmeans(evecs,num_cluster,50,50); idx_njw =
%     %findlabels(newctrs,evecs);
% 
% 
%     [nmi_njw,ac_njw] = evalNMIAC(true_labels,idx_njw);
%     if nmi_njw > max_nmi
%         max_nmi = nmi_njw;
%         max_ac = ac_njw;
%         max_sigma=i;
%         G_tuned = W;
%     end
% end
% save('gaussian_tuned.mat','G_tuned');