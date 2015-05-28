function [x, curr_res] = myNNOMP(y, Phi, K)
% Non-Negative Orthogonal Matching Pursuit
% from "On the Uniqueness of Nonnegative Sparse 
% Solutions to Underdetermined Systems of Equations"
% by Bruckstein et al.
% y : data
% Phi : sensing matrix
% K : sparsity
% 
% Gunnar Atli Sigurdsson, 2013
% Shuchu Han, shhan@cs.stonybrook.edu, 05/26/2015.
%
EPSILON = 1e-5;
[N2,N] = size(Phi);
x = zeros(1,N);
S = []; % positions indexes of components of s
res = y; % first residual
PhiS = []; % Matrix of the columns used to represent y

%% We don't need this as our data is normalized.
%normPsquared = shiftdim(sum(Phi.^2,1));

visited_mark = zeros(1,N);

for t=1:K;
    curr_res = norm(res)^2;
    if curr_res < EPSILON
        break;
    end
    e = curr_res - max(Phi'*res, zeros(N,1)).^2;%./normPsquared;
    e(logical(visited_mark)) = 1;
    [~,j]=min(e);  %% always find the first one.
    visited_mark(j) = 1;  
    S = [S j];
    PhiS = [PhiS Phi(:,j)];
    x_est = lsqnonneg(PhiS,y);
    res = y- PhiS*x_est;
    x(S) = x_est;
end;

