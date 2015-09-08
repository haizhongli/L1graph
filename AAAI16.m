% ClusterLabels = ones(100,1);
% for i = 1:9
%     for j = 0:9
%     ClusterLabels(i*10 + j) = i+1;
%     end
% end
addpath('./MinMaxSelection');
addpath('./ZPclustering');
% **************************************
% *  Clustering
% **************************************
data = ScaleRow(Data')';  %% row represents sample.
nc = NumC;  % number of cluster.
cl = ClusterLabels;  % cluster labels.

% test the L1-Graph
[W_l1,~] = L1Graph(data',0.1);
W_l1(W_l1<0.0001) = 0;
W = (W_l1 + W_l1')/2;
[l1_nmi,l1_ac] = checkClustering(W,nc,cl);

%% data information
[N,M] = size(data);
dt = squareform(pdist(data));

K_size = floor([0.1*N,0.2*N,0.3*N]);

k = length(K_size);
diff_nmi = zeros(k,1);
diff_ac = zeros(k,1);
lop_nmi = zeros(k,1);
lop_ac = zeros(k,1);
sc_nmi = zeros(k,1);
sc_ac = zeros(k,1);


for i = 1:k;
    K = K_size(i);
% calcualte the Gaussian similarity
% median distance
[dt_v,~] = mink(dt,K+1,2);
median_val = median(dt_v(:,K+1));
W_st = exp(-dt.^2/(2*median_val^2));
W_st(logical(eye(N))) = 0;
% [~,W_st,~] = scale_dist(dt,K);

[sc_nmi(i),sc_ac(i)] = checkClustering(W_st,nc,cl);

% test the LOP-L1 Graph
[~,nb] = mink(dt,K+1,2);
nb(:,1) =[];
[W_l1,~] = L1GraphKNN(data',nb,K,0.1);
W_l1(W_l1<0.0001) = 0;
W = (W_l1 + W_l1')/2;
[lop_nmi(i),lop_ac(i)] = checkClustering(W,nc,cl);
 
% test the LOP-L1 diff Graph
R = ManifoldRankingV1(W_st,0.1);
[~,nb] = maxk(R,K,1);
nb = nb';
[W_l1,~] = L1GraphKNN(data',nb,K,0.1);
W_l1(W_l1<0.0001) = 0;
W = (W_l1 + W_l1')/2;
[diff_nmi(i),diff_ac(i)] = checkClustering(W,nc,cl);
end