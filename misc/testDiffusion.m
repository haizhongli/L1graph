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
debug_flag = 1;
solver_flag = 0; %% 1 --- NNOMP ;  0 --- NNLASSO

%% records
dict_sizes = zeros(n,1);


%% normalization, first feature, then observation (required by L1 graph)
data = NMRow(data')';
%data = NMRow(data);
%n = size(data,1); % number of observations;
%m = size(data,2); % number of features;

%% build the dimilarity matrix;
% adj_euclid = squareform(pdist(data));
% adj_sim = 1 ./ adj_euclid;
% adj_sim(~isfinite(adj_sim)) = 0; %% if two points are duplicated, there are zero similarity
adj_sim = myGaussianMedian(data);
D = diag ( 1 ./ sum(adj_sim,1));

%% random walk matrix 
P = adj_sim*D;

%% graph diffusion
% alpha = 1/(step+1);
% F = alpha*P^0;
% for j = 1:step
%   F = F + alpha*P^j;
% end

%% debug
if debug_flag
    H = zeros(50,1);
    
    d1 = data;
    dif_nbs = zeros(n,1);
    for i = 1:1:30
        alpha = 1/(i+1);
        F = alpha*P^0;
        for j = 1:i
            F = F + alpha*P^j;
        end
        
        %%draw diffusion
        H(i) = F(1,1);
        F(logical(eye(n))) = 0;
        figure, scatter(d1(:,1),d1(:,2),30,F(:,1));
        title(int2str(i));
        hold on; 
        plot(d1(1,1),d1(1,2),'gd');
        tmpF = F(:,1);
        tmpM = (sum(tmpF) - F(1,1)) / (n-1);
        nonzero_ids = find(F(:,1)>tmpM);
        setdiff(nonzero_ids,1);
        plot(d1(nonzero_ids,1),d1(nonzero_ids,2),'r+');
        %F(1,1)
        %figure, plot(sort(F(:,1),'descend'));
        
        %%draw number of diffusion neighbors
        %for j = 1:n
        %    dif_nbs(j) = length(find( F(:,j) > mean(F(:,j))) );
        %end
        %figure, hist(dif_nbs);
        
        pause
    end
end