function [G] = build_graphs(data,K);
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
addpath('../l1_ls_matlab/l1_ls_matlab')
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1/MinMaxSelection');


%% assuming we have data variable named as "Data"
[n,m] = size(data);

%% calculate the distance matrix
dist_matrix = squareform(pdist(data));

%% diffusion and Gaussian similarity matrix
[Wdiff,Wgau] = ICG_ApplyDiffusionProcess(dist_matrix,nan,10,0);
%% change the diffusion value at diagnoal to zero
Wdiff(logical(eye(size(Wdiff,1)))) = 0;

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
[Wl1diffknn,~] = L1GraphDiffKnn(data,Wdiff,2*m);

%% L1 graph kNN
Wl1knn = L1GraphKNNFast(data',2*m);

%% start saving
G.Wgau = Wgau;
G.Wknn = sparse(Wknn);
G.Wl1knn = sparse(Wl1knn);
G.Wdiff = Wdiff;
G.Wdiffknn = Wdiffknn;
G.Wl1diffknn = sparse(Wl1diffknn);

save('G.mat','G');

end

