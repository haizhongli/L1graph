function [W] = L1GraphKNNGreedy(data,nb,theta)
% This function calculates the L1 graph of 'data' by selecting neigbors
% with kNN method and solve with Greedy algorithm
% y = Ax
%   x -- is what we are looking for, a higher dimension representation
%   y -- is each sample(or data point) of input data.
%   A -- is the transform matrix.
%   size:
%      x: (m+n-1) x 1
%      y: m x 1
%      A: m x n
%
% input:
%   data -- a data matrix: (m,n) , m -- features, n -- samples
%   nb   -- (n,K), the matrix describe the nearest neighbors INDEX of 
%             each data sample at each row. 
%   theta  -- the approximate threshold.
% output:
%   W -- weight Matrix of L1 graph.
% comment:
%   We need a L1 solver.
% 
%
% author: shhan@cs.stonybrook.edu
%Tue Jun  2 14:30:47 EDT 2015


tic;
[~,n] = size(data);
[~,K] = size(nb);

%% normalization data
data = NMCol(data);

%% data to be a sparse matrix
if not(issparse(data))
    data = sparse(data);
end

WW = zeros(K,n);

parfor i = 1:n
  %%construct the A
  dict_ids = nb(i,:);
  y = data(:,i);
  [x,~] = myNNOMP(y,data(:,dict_ids),theta);
  WW(:,i) = x;
end

%% build the adjacent matrix
W = zeros(n);
for i = 1:n
    W(nb(i,:),i) = WW(:,i);
end

toc;
end
