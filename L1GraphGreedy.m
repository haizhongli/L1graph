function [W,NZ] = L1GraphGreedy(data,theta)
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
% 07/13/2016 version 3 using NNOMP
% 07/4/2016  version 2, using spams-matlab solver
% 08/14/2015 version 1
%
tic;
% data
[m,n] = size(data);

% normalize data into unit hypersphere.
data = NormalizeFea(data',1)';

% parameters for spams-matlab
param.eps = theta;

% parallel code for calculating sparse codes.
W = zeros(n-1,n);
NZ = zeros(m,n);
parfor i = 1:n    
  %%construct the A
  y = data(:,i);
  A = data;
  A(:,i) = [];
  %[x,~] = myNNOMP(y,A,theta);
  %[x,~] = OMP(A,y,theta);
  [x,~] = mexOMP(y,A,param);
  W(:,i) = x;
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

%% make the max value of each row equals to one
Wm = max(W,[],2);
Wmm = repmat(Wm,1,n);

W = W ./ Wmm;

% symmetry
W = (W+W')/2;

% remove extreme small value;
W(W<0.0001) = 0;
toc;
end
