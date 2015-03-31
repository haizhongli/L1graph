% Construct L1 graph by using diffusion neighbors
% Input: a high demensional data matrix with cluster labels.
% Output:
%      -- spectral clustering performance of : NJW, NJW based on L1 graph.
%         measure with NMI and ACC
%
% data need to be recorded:
% 1, fixed sigma:  NMI&AC(NJW, L1Diff), Different Step (t=1,2,3,4,5) 
%
%
%
%

addpath('/Users/shuchu/Documents/Project/L1graph/l1_ls_matlab/l1_ls_matlab');
addpath('/Users/shuchu/Documents/Project/L1graph/15PAKDD/');

%% Input
data = Data;   %% row is observation
num_cluster = NumC;
true_labels = ClusterLabels;

n = size(data,1); % number of observations;
m = size(data,2); % number of features;

step = 1;    %% step of random walk;
minmum_dict_size = m + 1; %% threshold of dictionary
k_target = m;
%% misc
solver_flag = 0; %% 1 --- NNOMP ;  0 --- NNLASSO

%% records
dict_sizes = zeros(n,1);


%% normalization, first feature, then observation (required by L1 graph)
data = NMRow(data')';
%data = NMRow(data); %% row normalization is just for L1

%% build the dimilarity matrix;
%adj_euclid = squareform(pdist(data));
%adj_sim = 1 ./ adj_euclid;
%adj_sim(~isfinite(adj_sim)) = 0; %% if two points are duplicated, there are zero similarity
%adj_sim = myCosineSim(data);
adj_sim = myGaussianMedian(data);
D = diag ( 1 ./ sum(adj_sim,1));
data = NMRow(data);

%% random walk matrix 
P = adj_sim*D;

%% graph diffusion
alpha = 1/(step+1);
F = alpha*P^0;
for j = 1:step
  F = F + alpha*P^j;
end


%% --------- L1 Graph -----------
%% F now has the information of diffusion neighbors
%% for each node, use the diffusion neighbors as dictionary
W = zeros(n);  %% initialize the resulted graph

if ~solver_flag
    lambda = 0.1;
    rel_tol = 0.00001;
    quiet = true;
end


%% 
F(logical(eye(n))) = 0;

for i=1:n
   %% find dictionary index
   ids = find(F(:,i) > mean(F(:,i)));
   if ( length(ids) < minmum_dict_size)
       [~,idd] = sort(F(:,i),'descend');
       ids = idd(1:minmum_dict_size+10);
       %fprintf('dictioinary size is less than threshold: %d',length(ids));
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
   %i
end

%%%% very important step
%%%% we need to change the value of W that is small than 0.0001 to zero.
%%%% these noise will affect the performance of clustering
%figure, plot(sort(W(1,:)));
W(find(W<0.0001)) = 0;
%%%% don't apply this go gaussian, performance will be low.
%%%% adj_gaussian(find(adj_gaussian<0.0001)) = 0;  

WW = (W+W')/2;

%% spectral clustering
idx_l = spectralClustering(WW,num_cluster);
%[~,evecs] = NJW(WW,num_cluster);
%idx_l = kmeans(evecs,num_cluster);
[nmi_l,ac_l] = evalNMIAC(true_labels,idx_l)

% res = bestMap(true_labels,idx_l);
% %=============  evaluate AC: accuracy ==============
% AC = length(find(true_labels == res))/length(true_labels);
% %=============  evaluate MIhat: nomalized mutual information =================
% MIhat = MutualInfo(true_labels,res);
% 
% sprintf('L1 NMI is:%.4f\n',MIhat)
% sprintf('L1 ACC is: %.4f\n', AC)

%% save
save('W.mat','W');
save('F.mat','F');
save('dict.mat','dict_sizes');
%% draw dictionary size
df = figure, 
hist(dict_sizes);
savefig(df,'dictionary.fig');
pause
close(df);

