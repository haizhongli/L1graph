% Construct L1 graph by using diffusion neighbors
% Input: a high demensional data matrix with cluster labels.
% Output:
%      -- spectral clustering performance of : NJW, NJW based on L1 graph.
%         measure with NMI and ACC
%
%

addpath('l1_ls_matlab/l1_ls_matlab');

%% Input
data = Data;   %% row is observation
num_cluster = NumC;
true_labels = ClusterLabels;

n = size(data,1); % number of observations;
m = size(data,2); % number of features;

step = 2;    %% step of random walk;
minmum_dict_size = m + 1; %% threshold of dictionary
k_target = m;
%% misc
debug_flag = 0;
solver_flag = 0; %% 1 --- NNOMP ;  0 --- NNLASSO

%% records
dict_sizes = zeros(n,1);


%% normalization, first feature, then observation (required by L1 graph)
data = NMRow(data')';
data = NMRow(data);
%n = size(data,1); % number of observations;
%m = size(data,2); % number of features;

%% build the dimilarity matrix;
adj_euclid = squareform(pdist(data));
adj_sim = 1 ./ adj_euclid;
adj_sim(~isfinite(adj_sim)) = 0; %% if two points are duplicated, there are zero similarity
D = diag ( 1 ./ sum(adj_sim,1));

%% random walk matrix 
P = adj_sim*D;

%% graph diffusion
alpha = 1/(step+1);
F = alpha*P^0;
for j = 1:step
  F = F + alpha*P^j;
end

%% debug
if debug_flag
    d1 = data;
    dif_nbs = zeros(n,1);
    for i = 1:1:10
        alpha = 1/(i+1);
        F = alpha*P^0;
        for j = 1:i
            F = F + alpha*P^j;
        end
        
        %%draw diffusion
        figure, scatter(d1(:,1),d1(:,2),30,F(:,1));
        hold on; 
        plot(d1(1,1),d1(1,2),'gd');
        nonzero_ids = find(F(:,1)>=0.0001);
        plot(d1(nonzero_ids,1),d1(nonzero_ids,2),'r+');
        F(1,1)
        figure, plot(sort(F(:,1),'descend'));
        
        %%draw number of diffusion neighbors
        for j = 1:n
            dif_nbs(j) = length(find(F(:,j) >=0.001));
        end
        figure, hist(dif_nbs);
        
        pause
    end
end


%% --------- L1 Graph -----------
%% F now has the information of diffusion neighbors
%% for each node, use the diffusion neighbors as dictionary
W = zeros(n);  %% initialize the resulted graph

if ~solver_flag
    lambda = 1.0;
    rel_tol = 0.00001;
    quiet = true;
end



for i=1:n
   %% find dictionary index
   ids = find(F(:,i) >= 0.0001);
   if ( length(ids) < minmum_dict_size)
       fprintf('dictioinary size is less than threshold: %d',length(ids));
   end
   
   ids = setdiff(ids,i);
   
   %% record dictionary size
   dict_sizes(i) = length(ids);
   
   x = data(i,:)';
   D = data(ids,:)';
   len_D = length(ids);
   %% add noise
   if 0
       D = [D eye(length(x))];
   end
   
   
   if solver_flag
   %% NNOMP solver
   [xk] = NNOMP(x,D,k_target);
   else
   %% NNLASSO solver
   [xk, ~] = l1_ls_nonneg(D,x,lambda,rel_tol,quiet);
   end
   
   W(i,ids) = xk';
   %W(i,ids) = xk(1:length(ids))';
   %error = sum(xk(length(ids)+1:end))
   
   %%debug
   i
end

%%%% very important step
%%%% we need to change the value of W that is small than 0.0001 to zero.
%%%% these noise will affect the performance of clustering
W(find(W<0.0001)) = 0;
%%%% don't apply this go gaussian, performance will be low.
%%%% adj_gaussian(find(adj_gaussian<0.0001)) = 0;  


%% spectral clustering
idx_l = spectralClustering(W,num_cluster);

res = bestMap(true_labels,idx_l);
%=============  evaluate AC: accuracy ==============
AC = length(find(true_labels == res))/length(true_labels);
%=============  evaluate MIhat: nomalized mutual information =================
MIhat = MutualInfo(true_labels,res);

sprintf('L1 NMI is:%.4f\n',MIhat)
sprintf('L1 ACC is: %.4f\n', AC)





