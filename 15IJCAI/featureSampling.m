function [W] = featureSampling(data,k,type)
%% This function sampling the features of input data.
% it selects a subset of features from data. we assume that
% each feature is a column of data
%
%  input:
%   data:  input data matrix,   row: instance, column: features;
%   k: size of selected features.
%   type:  sampling methods:  'random', 'dps', 'kmedoid', 'kkmedoid' with kNN graph,
%  output:
%   W:  resulted data with unselected features are removed

addpath('/home/shuchu/data/Projects/14L1Graph/L1graph/15IJCAI/matlab_bgl/');
addpath('/home/shuchu/data/Projects/14L1Graph/L1graph/15IJCAI/kmedioids/');

if nargin ~= 3
 disp('Error, please check the inputs of function!');
end

if k >= size(data,2)
 disp('Error, number of selected features is larger than data feature size');
 W = data;
 return
end

% data info
[N,P] = size(data);
sid = zeros(1,k); %% varable for sample ids

% random sampling 
if strcmp(type,'random')
sid = randperm(P,k);
W = data(:,sid);
end

% dps
%
if strcmp(type,'dps')
levels = ceil(log2(P/k));
[R] = dps(data',levels);
sid = find(R==1);
W = data(:,sid);
end

%% kmedoid
if strcmp(type,'kmedoid')
D = squareform(pdist(data'));
[~,sid] = kmedioids(D,k);
W = data(:,sid);
end

%% kmedoid based on geodesic distance
if strcmp(type,'kkmedoid')
%% build unweighted kNN graph,
eu_dist = squareform(pdist(data'));
kk = 20;
parfor i=1:size(eu_dist,1)
    d = eu_dist(i,:);
    [~,idx] = sort(d);
    d(idx(1:kk+1)) = 1 ;
    d(idx(kk+2:end)) = 0;
    d(i) = 0; %% no self edge
    eu_dist(i,:) = d;
end

%% calculate shortest distance between any two pairs.

short_dist = all_shortest_paths(sparse(eu_dist),struct('algname','johnson'));

%% clustering using kmedoids
[inds,cidx] = kmedioids(short_dist,k);
W = data(:,cidx);
end

end
