%% run spectral clustering based on F

%addpath('../l1_ls_matlab/l1_ls_matlab');
% %% Input
 data = Data;   %% row is observation
% num_cluster = NumC;
% true_labels = ClusterLabels;
% T  %% assume T is given

n = size(data,1); % number of observations;
m = size(data,2); % number of features;

minmum_dict_size = m + 1; %% threshold of dictionary
k_target = m;

%% misc
solver_flag = 0; %% 1 --- NNOMP ;  0 --- NNLASSO

%% records
dict_sizes = zeros(n,1);


%% normalization, first feature, then observation (required by L1 graph)
data = NMRow(data')';
data = NMRow(data);

%% --------- L1 Graph -----------
%% F now has the information of diffusion neighbors
%% for each node, use the diffusion neighbors as dictionary
W = zeros(n);  %% initialize the resulted graph
L = zeros(n,n,T);

if ~solver_flag
    lambda = 0.1;
    rel_tol = 0.00001;
    quiet = true;
end

files = {'G_cos_F.mat','G_fixed_F.mat'};

for fid = 1:length(files)
    nmi_all = zeros(T,1);
    ac_all = zeros(T,1);
    clear F;
    fname = files{fid};
    load(fname); %% load F
    
    for t = 1:T   
        for i=1:n
           %% find dictionary index
           ids = find(F(:,i,t) >= 0.0001);
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
        end %% end for i

        %%%% very important step
        %%%% we need to change the value of W that is small than 0.0001 to zero.
        %%%% these noise will affect the performance of clustering
        %figure, plot(sort(W(1,:)));
        W(find(W<0.0001)) = 0;
        %%%% don't apply this go gaussian, performance will be low.
        %%%% adj_gaussian(find(adj_gaussian<0.0001)) = 0;  

        L(:,:,t) = W;

        WW = (W+W')/2;

        %% spectral clustering
        idx_l = spectralClustering(WW,NumC);

        res = bestMap(ClusterLabels,idx_l);
        %=============  evaluate AC: accuracy ==============
        AC = length(find(ClusterLabels == res))/length(ClusterLabels);
        %=============  evaluate MIhat: nomalized mutual information =================
        MIhat = MutualInfo(ClusterLabels,res);

        nmi_all(t) = MIhat;
        ac_all(t) = AC;
        %sprintf('L1 NMI is:%.4f\n',MIhat)
        %sprintf('L1 ACC is: %.4f\n', AC)
    end %%end for t
    w_fname = sprintf('%s_L1.mat',fname(1:end-4));
    save(w_fname,'L');
    sfname1 = sprintf('%s_nmi.mat',fname(1:end-4));
    sfname2 = sprintf('%s_ac.mat',fname(1:end-4));
    save(sfname1,'nmi_all');
    save(sfname2,'ac_all');
end