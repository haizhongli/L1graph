function [R] = ManifoldRankingV1(A,alpha)
% Calculate the Ranking score of a manifold, following the paper of
% 2004 NIPS Ranking on Data Manifolds.
%
% The key difference is that, the original paper calculate the ranking
% score of q Query point. But we need to calculate the ranking of one 
% sample to all other samples. 
% We are using the closed Form solution for small size dataset. This means
% that we will have matrix inverse calculation.
%
% Input: 
%   A  -- affinity matrix
%   alpha -- ranking parameter
%
% Output:
%   R --  manifold score, column record one query
%

% Laplacian
n = size(A,1);
I = eye(n);
A(logical(I)) = 0;

D = sum(A,2);
D = spdiags(D,0,speye(size(A,1)));
%Lu = full(D) -  A;
S = full(D)^(-1/2) * A * full(D)^(-1/2); 
R = inv(eye(n) - alpha*S);
R(logical(eye(n))) = 0;
end