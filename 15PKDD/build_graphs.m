function [G] = build_graphs(data,K,KL)
%% this function build following graphs
%% 1. Gaussian similarty graph: aff_matrix
%% 2. kNN graph: unweighted,directed graph.
%% 3. L1 Graph KNN
%% 4. Diffusion Graph
%% 5. Diffusion KNN
%% 6. L1 Graph Diffusion KNN

% input:
%     data -- nxm matrix, n: sample, m: feature.
%
addpath('../');
addpath('../knnsearch');
addpath('../l1_ls_matlab/l1_ls_matlab');
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1');
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1/MinMaxSelection');
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1/HelpFunctions');


%% assuming we have data variable named as "Data"
[n,m] = size(data);
KL = KL*m;
%% calculate the distance matrix
dist_matrix = squareform(pdist(data));

%% diffusion and Gaussian similarity matrix
[Wdiff,Wgau] = ICG_ApplyDiffusionProcess(dist_matrix,nan,10,0);
%% change the diffusion value at diagnoal to zero
Wdiff(logical(eye(size(Wdiff,1)))) = 0;
Wgau(logical(eye(size(Wdiff,1)))) = 0;

%% KNN 
WWknn = zeros(n);
WWdiff = zeros(n);
% kNN and Diff graph
for i = 1:n
    [~,knn_loc] = maxk(Wgau(i,:),K);
    [~,diff_loc] = maxk(Wdiff(i,:),K);
    WWknn(i,knn_loc) = 1;
    WWdiff(i,diff_loc) = 1;
end

Wknn = WWknn ;%.* Wgau;
Wdiffknn = WWdiff .* Wdiff;
%[Wl1diffknn] = L1GraphDiffKnnCS(data,Wdiff,KL);
[Wl1diffknn,~] = L1GraphDiffKnn(data,Wdiff,KL);

%% L1 graph kNN
nb  = knnsearch(data,data,KL+1);
Wl1knn = L1GraphKNN(data',nb,KL);

%% build affinity graph
Wknn = (Wknn + Wknn')/2;
Wl1knn = (Wl1knn + Wl1knn')/2;
Wdiff = (Wdiff + Wdiff')/2;
Wdiffknn = (Wdiffknn + Wdiffknn')/2;
Wl1diffknn = (Wl1diffknn + Wl1diffknn')/2;

%% start saving
G.Wgau = sparse(Wgau);
G.Wknn = sparse(Wknn);
G.Wl1knn = sparse(Wl1knn);
G.Wdiff = Wdiff;
G.Wdiffknn = Wdiffknn;
G.Wl1diffknn = sparse(Wl1diffknn);

%save('G.mat','G');

end

