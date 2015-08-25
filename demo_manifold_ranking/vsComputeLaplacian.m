function [S, A, Lu] = vsComputeLaplacian(X,sigma,neighbour,W)

% S = symmetric normalised matrix
% A = affinity matrix
% Lu = unnormalised graph laplacian

% Dependency: Zelnik-manor spectral clustering package

% Compute pairwise distance if not provided
if nargin < 4
    %W = dist2(X, X);
    W = squareform(pdist(X));
end


% If sigma is not specified, use locally scaled affinity matrix
if isempty(sigma)
    [~,A,~] = scale_dist(W,floor(neighbour/2));
else
    A = exp(-W.^2/(2*sigma^2));
end


I = eye(size(A,1));
A(I==1) = 0;

D = sum(A,2);
D = spdiags(D,0,speye(size(A,1)));
Lu = full(D) -  A;
S = full(D)^(-1/2) * A * full(D)^(-1/2); 


