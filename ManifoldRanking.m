function [R] = ManifoldRanking(Data,alpha,sigma)
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
%   Data -- data sample matrix, (m,n), row: variables, col: observations
%   sigma -- parameter for Gaussian kernel.
%
% Output:
%   S = symmetric normalised matrix
%   A = affinity matrix
%   Lu = unnormalised graph laplacian
%

[~,n] = size(Data);

%calculate the euclidean distance
W = squareform(pdist(Data'));
A = exp(-W.^2/(2*sigma^2));

% Laplacian
I = eye(n);
A(logical(I)) = 0;

D = sum(A,2);
D = spdiags(D,0,speye(size(A,1)));
%Lu = full(D) -  A;
S = full(D)^(-1/2) * A * full(D)^(-1/2); 

% Ranking
%r = zeros(n,1);
%r(1) = 1;
%R = (eye(n) - alpha*S)\eye(n);

R = inv(eye(n) - alpha*S);


R(logical(eye(n))) = 0;
end