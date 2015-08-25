function [W,NZ] = L1GraphDiffKnn(data,rank_matrix,K,lambda)
% This function calculates the L1 graph of 'data' by selecting neigbors
% with diffusion method.
% y = Ax
%   x -- is what we are looking for, a higher dimension representation
%   y -- is each sample(or data point) of input data.
%   A -- is the transform matrix.
%   size:
%      x: (m+n-1) x 1
%      y: m x 1
%      A: m x (m+n-1)
%
% input:
%   data -- data matrix: (m,n) , m: features, n: samples
%   rank_matrix  -- manifold ranking matrix. (need to be sort);
%   K    -- k nearest neighbor.
% output:
%   W -- weight Matrix of L1 graph. Row is L1 result.
% comment:
%   We use NNOMP algorithm. (greedy algorithm).
% 
%
% author: shhan@cs.stonybrook.edu
% 08/21/2015

addpath('./MinMaxSelection');
addpath('./l1_ls_matlab');

tic;
%% size of data
[m,n] = size(data);

%% normalization data
data = NMCol(data);

%% data to be a sparse matrix
if not(issparse(data))
    data = sparse(data);
end

% parameter for L1 solver.
rel_tol = 0.00001;
quiet = true;

WW = zeros(K,n); 
[~,idx] = maxk(rank_matrix,K,1);
NZ = zeros(m,n);

parfor i = 1:n  
  %%construct diffusion dictionary A
  A = [data(:,idx(:,i)),speye(m)];
  y = data(:,i);
  %%[x,res] = myNNOMP(y,A,K);
  %%WW(i,:) = x;
  %%R(i) = res;
  [x,~] = l1_ls_nonneg(A,y,lambda,rel_tol,quiet);
  WW(:,i) = x(1:K);
  NZ(:,i) = x(K+1:end);
  
end

%% build the adjacent matrix
W = zeros(n);
for i = 1:n
    W(idx(:,i),i) = WW(:,i);
end

toc;
end
