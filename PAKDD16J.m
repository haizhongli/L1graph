%script for ICDM Workshop 15 paper
addpath('./MinMaxSelection');
addpath('./ZPclustering');

%% INPUT , assume 'data' is feature-scaled.
%data = ;
data = ScaleRow(fea')';

maxK = 3;
[N,M] = size(data);

nmi_info = zeros(4,maxK);
ac_info = zeros(4,maxK);
time_info = zeros(4,maxK);
sparse_info = zeros(4,maxK); %% density

%% L1 graph
tic;
[W,~] = L1GraphGreedy(data',0.1);

[nmi_info(1,1),ac_info(1,1)] = checkClustering(W,numc,gnd);
time_info(1,1) = toc;
sparse_info(1,1) = mySparsity(W);

%% differet K,  for LOP-L1, LOP-L1-Diff
for K = 1:maxK
tic;
dt = squareform(pdist(data));
[dt_v,~] = mink(dt,K*M+1,2);
median_val = median(dt_v(:,K+1));
A = exp(-dt.^2/(2*median_val^2));
A(logical(eye(N))) = 0;
time_info(2,K) = toc;

%%% Gaussian
[nmi_info(2,K),ac_info(2,K)] = checkClustering(A,numc,gnd);
sparse_info(2,K) = mySparsity(A);

%% LOP-L1-Eu-Greedy
tic;
[~,nb] = mink(dt,K*M+1,2);
nb(:,1) =[];
[W] =  L1GraphKNNGreedy(data',nb,1e-5);
time_info(3,K) = toc + time_info(2,K);

[nmi_info(3,K),ac_info(3,K)] = checkClustering(W,numc,gnd);
sparse_info(3,K) = mySparsity(W);

%% LOP-L1-Diff-Greedy
tic;
D = 1 ./ sum(A,2);
D = repmat(D,1,N);
P = A.*D;
diff_A = P^(K*M); %% diffuse K*M steps.
diff_A(logical(eye(N))) = 0; %% set diag to 0.

[~,nb] = maxk(diff_A,K*M,2);
[W] = L1GraphKNNGreedy(data',nb,1e-5);
time_info(4,K) = toc + time_info(2,K);

[nmi_info(4,K),ac_info(4,K)] = checkClustering(W,numc,gnd);
sparse_info(4,K) = mySparsity(W);
end;

