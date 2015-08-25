function [G] = build_graphs_v1(data,d)
% generate following graph from input "data" 
% 1. Gaussian similarity graph
% 2, L1 Graph,
% 3, LopL1Greedy Graph
% 4, LopL1Opt Graph
% 5, DiffL1Greedy Graph
% 6, DiffL1Opt Graph
%
% input:
%   data -- matrix, n x m, n: observation, m: variables.
%   d    -- dictionary size.
% output:
%   different affinity graph
% 
% shhan@cs.stonybrook.edu
% Tue Jun  2 11:45:54 EDT 2015

[n,m] = size(data);

% calculate the Euclidean distance
dist_matrix = squareform(pdist(data));

% calculate the Gaussian similarity matrix,using MinMaxSelection  package
% Self-turning spectral clustering, use first 10 nearest neighbors
kth = 10;
%vals = maxk(dist_matrix,kth,2);
% sort in ascend order, for used by L1GraphKNN
[vals,locs] = sort(dist_matrix,2);
sigmas_i = vals(:,end-kth+1);
W = sigmas_i*sigmas_i';
aff_matrix = exp(-dist_matrix.^2./W);

% calcualte L1 Graph, lamda equals to 0.5
%G.Wl1 = L1GraphNoise(data',0.5);

% LopL1Greedy 
G.WLopL1Greedy = L1GraphKNNGreedy(data,locs,d);

% LopL1Opt
G.WLopL1Opt = L1GraphKNN(data,locs,d);


% calculate diffusion
wht = sum(aff_matrix,2).^-1;
wht(isinf(wht)) = 0;
D = spdiags(wht,0,n,n);
P = D*aff_matrix;

%% diffusion
diff_steps = 4;
P = P^diff_steps;

% DiffL1Greedy
[G.WDiffL1Greedy,~] = L1GraphDiffKnn(data,P,d)

% DiffL1Opt
G.WdiffL1Opt = L1GraphDiffKnnCS(data,P,d);

end
