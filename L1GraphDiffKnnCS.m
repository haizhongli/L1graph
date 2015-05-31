function [W] = L1GraphDiffKnnCS(data,diff_matrix,K)
% This function calculates the L1 graph of 'data' by convex set method
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
%   data -- a data matrix: n xm , m: features, n: samples
%   diff_matrix  -- diffusion matrix, the diagnoal is set to zero!!!
%   K    -- k nearest neighbor.
% output:
%   W -- weight Matrix of L1 graph. Row is L1 result.
% comment:
%   We use NNOMP algorithm. (greedy algorithm).
% 
%
% author: shhan@cs.stonybrook.edu
% 05/26/2015

addpath('./15PKDD');
addpath('./l1_ls_matlab/l1_ls_matlab/');

tic;
%% size of data
[n,m] = size(data);

%% normalization data
data = NMRow(data);

%% data to be a sparse matrix
if not(issparse(data))
    data = sparse(data);
end

lambda = 0.1;
rel_tol = 0.00001;
quiet = true;

WW = zeros(n,K); %% col is the index
[~,idx] = maxk(diff_matrix,K,2);

parfor i = 1:n  
  %%construct diffusion dictionary A
  %[~,loc] = maxk(diff_matrix,K);
  A = data(idx(i,:),:)';
  y = data(i,:)';
  %x = myNNOMP(y,A,K);
  
  [x, ~] = l1_ls_nonneg(A,y,lambda,rel_tol,quiet);
  xx = x;
  xx(x < 0.01) = 0; %% remove the noise
  WW(i,:) = xx';
end

%% build the adjacent matrix
W = zeros(n);
for i = 1:n
     W(i,idx(i,:)) = WW(i,:);
end

toc;
end
