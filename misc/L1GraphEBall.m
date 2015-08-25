function [W] = L1GraphEBall(data,D,I,epsilon)
% This function calculates the L1 graph of 'data' by selecting neighbors 
% with epsilon-ball.
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
%   D -- matrix describes the SORTED distance of each node to other points;
%   I -- index respect to D;
%   epsilon    -- epsilon-ball neighbors.
% output:
%   W -- weight Matrix of L1 graph.
% comment:
%   We need a L1 solver.
% 
%
% author: shhan@cs.stonybrook.edu
% 09/13/2014
tic;
%% features
m = size(data,1);
%% samples
n = size(data,2);

%% check value epsilon
if epsilon <= 0.0 || epsilon > 1.0
    epsilon = 1.0;
end

%% data to be a sparse matrix
if not(issparse(data))
    data = sparse(data);
end

lambda = 0.01;
rel_tol = 0.01;
quiet = true;

W = zeros(n+m-1,n);

for i = 1:n
    i
  %%construct the A
  y = data(:,i);
  
  %% build A by selecting epsilon ball neighbors
  cid = find(D(i,:) <= epsilon);
  ids = I(i,cid);
  A = data(:,ids);
  
  A = [A,speye(m,m)];
  [x, status] = l1_ls_nonneg(A,y,lambda,rel_tol,quiet);
  W(ids,i) = x(1:length(ids));
  W(end-m+1:end,i) = x(length(ids)+1:end);
end

%%parse W to adjacent matrix
% remove the noise part
W(n+1:end,:) = [];

toc;
end
