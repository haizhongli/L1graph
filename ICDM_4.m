%script for ICDM15 paper
addpath('./MinMaxSelection');
addpath('./ZPclustering');

% K = 10;
% 
% % % knn
% % dt = squareform(pdist(data));
% % [~,nb] = mink(dt,K+1,2);
% % nb(:,1) =[];
% 
% % manifold ranking
% R = ManifoldRanking(data',0.5,0.1);
% [~,nb] = maxk(R,K,1);
% nb = nb';
% 
% % test L1 graph Spectral Clustering performance.
% % [W_l1,NZ_l1] = L1Graph(data',0.1);
% [W_l1,~] = L1GraphKNN(data',nb,K,0.1);
% % [W_l1] = L1GraphKNNGreedy(data',nb,1e-5);
%  
% %remove small coefficient
% W_l1(W_l1<0.0001) = 0;
% W = (W_l1 + W_l1')/2;
% 
% figure, gplot(W,data);
% hold on
% plot(data(:,1),data(:,2),'r+')
% hold off
% 
% idx = spectralClustering(W,NumC);
% res = bestMap(ClusterLabels,idx);
% ac_info = length(find(ClusterLabels == res))/length(ClusterLabels);
% nmi_info = MutualInfo(ClusterLabels,res);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create figures for testing parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

data = data4.data;  %% row represents sample.
nc = data4.NumC;  % number of cluster.
cl = data4.ClusterLabels;  % cluster labels.

N = size(data,1);

dt = squareform(pdist(data));

% test the self-tunring clustering
K = 10;

[~,W_st,~] = scale_dist(dt,K);

[st_nmi,st_ac] = checkClustering(W_st,nc,cl);

% test the L1-Graph
[W_l1,~] = L1Graph(data',0.1);
W_l1(W_l1<0.0001) = 0;
W = (W_l1 + W_l1')/2;
[l1_nmi,l1_ac] = checkClustering(W,nc,cl);

% test the LOP-L1 Graph
lopl1_score = zeros(5,2);
lopl1_greedy_score = zeros(5,2);
for t = 1:5
   s = floor(t*N*0.1);
   [~,nb] = mink(dt,s+1,2);
   nb(:,1) =[];
   [W_l1,~] = L1GraphKNN(data',nb,s,0.1);
   W_l1(W_l1<0.0001) = 0;
   W = (W_l1 + W_l1')/2;
   [lopl1_score(t,1),lopl1_score(t,2)] = checkClustering(W,nc,cl);
   
   [W_l1] = L1GraphKNNGreedy(data',nb,1e-5);
   W_l1(W_l1<0.0001) = 0;
   W = (W_l1 + W_l1')/2;
   [lopl1_greedy_score(t,1),lopl1_greedy_score(t,2)] = checkClustering(W,nc,cl);
end


% test the LOP-L1 diff Graph
lds_nmi = zeros(5,5);
lds_ac = zeros(5,5);
ldgs_nmi = zeros(5,5);
ldgs_ac = zeros(5,5);

alpha = [0.1,0.3,0.5,0.7,0.9];
for a = 1:5
    R = ManifoldRankingV1(W_st,alpha(a));
    for t = 1:5
       s = floor(t*N*0.1);
       [~,nb] = maxk(R,s,1);
       nb = nb';
       [W_l1,~] = L1GraphKNN(data',nb,s,0.1);
       W_l1(W_l1<0.0001) = 0;
       W = (W_l1 + W_l1')/2;
       [lds_nmi(a,t),lds_ac(a,t)] = checkClustering(W,nc,cl);

       [W_l1] = L1GraphKNNGreedy(data',nb,1e-5);
       W_l1(W_l1<0.0001) = 0;
       W = (W_l1 + W_l1')/2;
       [ldgs_nmi(a,t),ldgs_ac(a,t)] = checkClustering(W,nc,cl);
    end 
end

