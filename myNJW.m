function [plabel] = myNJW(W,k)
%% implementation of  NJW clustering algorithm.
% W -- similarity matrix
% k -- number of clusters
%
% comments:
%   need Dr. Caideng's Eigenmap.m; NormalizeFea.m; litekmeans.m

if (k<=0)
    k = 1;
end

[Y, eigvalue] = Eigenmap(W,k,1);

S = Y(:,1:k); %% the k largest eigenvalues
S = NormalizeFea(S,1);
plabel = litekmeans(S,k, 'Replicates',10);
end
