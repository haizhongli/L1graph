function [W,NZ] = L1GraphNoise(data,lambda)
% This function calculates the L1 graph of 'data'.
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
%   data -- a data matrix: m x n , m -- features, n -- samples
% output:
%   W -- weight Matrix of L1 graph.
%   NZ -- noise
% comment:
%   We need a L1 solver.
% 
%
% author: shhan@cs.stonybrook.edu
% 07/21/2014

addpath('./l1_ls_matlab/l1_ls_matlab/');

%% normalize the data size. ||x||_2 = 1
data = NMRow(data')';   %% sample vector length normalization

%% features
m = size(data,1);
%% samples
n = size(data,2);

%% data to be a sparse matrix
if not(issparse(data))
    data = sparse(data);
end

%lambda = 1;
rel_tol = 0.0001;
quiet = true;

W = zeros(n+m-1,n);

parfor i = 1:n    
  %%construct the A
  dict_ids = 1:n-1;
  dict_ids(i:end) = i+1:n;
  y = data(:,i);
  A = [data(:,dict_ids),speye(m,m)];
  [x,~] = l1_ls_nonneg(A,y,lambda,rel_tol,quiet);
  
  W(:,i) = x;
end

%%parse W to adjacent matrix
% remove the noise part
NZ = W(n:end,:);
W(n:end,:) = [];
W(W<0.01) = 0; % remove noise coefficient.
W = W';

% j > i part
U = triu(W);
% j < i part
L = tril(W,-1);

% extend the size
pad = zeros(n,1);
U = [pad U];
L = [L pad];
W = U + L;

end
