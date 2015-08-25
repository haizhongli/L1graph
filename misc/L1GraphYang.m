function [W] = L1GraphYang(data)
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
% comment:
%   We need a L1 solver.
% 
%
% author: shhan@cs.stonybrook.edu
% 07/21/2014

%% features
m = size(data,1);
%% samples
n = size(data,2);

%% data to be a sparse matrix
if not(issparse(data))
    data = sparse(data);
end

lambda = 1;


W = zeros(n+m-1,n);

for i = 1:n
  if not(mod(i,10))
      i
  end;
  %%construct the A
  A = data;
  y = data(:,i);
  A(:,i) = [];
  A = [A,speye(m,m)];
  
  DL = A'*A;
  b = -A'*y;
  [x] = L1QP_FeatureSign_yang(lambda,DL,b);
  
  
  W(:,i) = x;
end

%%parse W to adjacent matrix
% remove the noise part
W(n:end,:) = [];
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
