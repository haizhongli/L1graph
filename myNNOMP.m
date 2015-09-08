function [x, curr_res] = myNNOMP(y, Phi, eps)
% Non-Negative Orthogonal Matching Pursuit
% from "On the Uniqueness of Nonnegative Sparse 
% Solutions to Underdetermined Systems of Equations"
% by Bruckstein et al.
%
% input:
%   y : data, (n,1) column vector;
%   Phi : sensing matrix, (m,n) dictionary
%   K : sparsity
% output:
%   
%   
% Phi * x = y;
% 
% Gunnar Atli Sigurdsson, 2013
% Shuchu Han, shhan@cs.stonybrook.edu, 05/26/2015.
%
if (nargin < 3)
    eps = 1e-3;
end

[~,n] = size(Phi);
x = zeros(n,1); %% final coefficient
S = zeros(n,1); % positions indexes of components of s
res = y; % first residual

visited_mark = zeros(n,1);

for t=1:n;
    curr_res = norm(res)^2;
    if curr_res < eps
        break;
    end
    e = curr_res - max(Phi'*res, zeros(n,1)).^2;
    e(logical(visited_mark)) = 1;
    [~,j]=min(e);  %% always find the first one.
    visited_mark(j) = 1;  
    S(t) = j;
    x_est = lsqnonneg(Phi(:,S(1:t)),y);
    res = y- Phi(:,S(1:t))*x_est;
    x(S(1:t)) = x_est;
end;

