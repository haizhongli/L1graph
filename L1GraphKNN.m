function [W] = L1GraphKNN(data,nb,K)
% This function calculates the L1 graph of 'data' by selecting neigbors
% with kNN method.
% y = Ax
%   x -- is what we are looking for, a higher dimension representation
%   y -- is each sample(or data point) of input data.
%   A -- is the transform matrix.
%      x: (m+n-1) x 1
%      y: m x 1
%      A: m x (m+n-1)
%
% input:
%   data -- a data matrix: n x m, m -- features, n -- samples
%   nb   -- the matrix describe the nearest neighbors of each data sample 
%            at each row.
%   K    -- k nearest neighbor.
% output:
%   W -- weight Matrix of L1 graph.
% comment:
%   We need a L1 solver.
% 
%
% author: shhan@cs.stonybrook.edu
%Tue Jun  2 14:54:15 EDT 2015
%
addpath('./l1_ls_matlab/l1_ls_matlab/');

tic;

[n,m] = size(data);

%% normalization data
data = NMRow(data);

%% data to be a sparse matrix
if not(issparse(data))
    data = sparse(data);
end

lambda = 0.5;
rel_tol = 0.00001;
quiet = true;

WW = zeros(n,K);

parfor i = 1:n
  %%construct the A
  dict_ids = nb(i,2:K+1);
  y = data(i,:)';
  A = data(dict_ids,:)';
  [x, ~] = l1_ls_nonneg(A,y,lambda,rel_tol,quiet);
  xx = x;
  xx(x < 0.00001) = 0; %% remove the noise
  WW(i,:) = xx;
end

%% build the adjacent matrix
W = zeros(n);
for i = 1:n
    W(i,nb(i,2:K+1)) = WW(i,:);
end

toc;
end
