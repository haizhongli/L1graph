function [W,R] = L1GraphDiffKnn(data,diff_matrix,K)
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
addpath('./15PKDD/DIFFUSION_PACKAGE_CVPR_2013_V1_1/MinMaxSelection');

tic;
%% size of data
[n,m] = size(data);

%% normalization data
data = NMRow(data);

%% data to be a sparse matrix
if not(issparse(data))
    data = sparse(data);
end

WW = zeros(n,K); %% row is the index
[~,idx] = maxk(diff_matrix,K,2);
R = zeros(n,1);

parfor i = 1:n  
  %%construct diffusion dictionary A
  %[~,loc] = maxk(diff_matrix,K);
  A = data(idx(i,:),:)';
  y = data(i,:)';
  [x,res] = myNNOMP(y,A,K);
  WW(i,:) = x;
  R(i) = res;
  
end

%% build the adjacent matrix
W = zeros(n);
for i = 1:n
    W(i,idx(i,:)) = WW(i,:);
end

toc;
end
