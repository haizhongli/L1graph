function [W,NZ] = L1Graph(data,mode,lambda)
% This function calculates L1 graph from input data.
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
%   W -- weight Matrix of L1 graph. nxn, Each row is coefficients.
%   NZ -- noise. mxn
% comment:
%   Require "l1_ls" package from stanford.
%
%
% author: shhan@cs.stonybrook.edu
% 07/4/2016  version 2, using spams-matlab solver
% 08/14/2015 version 1
%
tic;
% data
[m,n] = size(data);

% normalize data into unit hypersphere.
data = NormalizeFea(data',1)';

%% data to be a sparse matrix
%if not(issparse(data))
%    data = sparse(data);
%end

% parameter for L1 solver.
param.mode=mode;
param.lambda = lambda;
if (mode == 2)
    param.lambda2 = 10*lambda;
end
param.numThreads=-1;

% parallel code for calculating sparse codes.
W = zeros(n-1,n);
NZ = zeros(m,n);
parfor i = 1:n    
  %%construct the A
  y = data(:,i);
  %A = [data,speye(m)];
  A = [data,eye(m)];
  A(:,i) = [];
 % [x,~] = l1_ls_nonneg(A,y,lambda,rel_tol,quiet);
  [x,~] = mexLasso(y,A,param);
  W(:,i) = x(1:n-1);
  NZ(:,i) = x(n:end);
end

% modify W from [n-1,n] to [n,n]
W=W';
% j > i part
U = triu(W);
% j < i part
L = tril(W,-1);

% extend the size
pad = zeros(n,1);
U = [pad U];
L = [L pad];
W = U + L;

% make all positive.
W = abs(W);

% remove extreme small value;
W(W<0.0001) = 0;

% symmetry
W = (W+W')/2;

toc;
end
