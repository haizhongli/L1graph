function [idx] = Bipartition(G,numCluster)
% Spectral clustering of bipartite graph
% 
D1 = sum(G,2);
D2 = sum(G,1);
D1 = diag(1 ./ sqrt(D1));
D2 = diag(1 ./ sqrt(D2));

%%handle nan
D1nan = isinf(D1);
D1(logical(D1nan)) = 0;
D2nan = isinf(D2);
D2(logical(D2nan)) = 0;

A = D1*G*D2;
[U,~,V] = svd(A,0);

%% only use one vector
Z = [D1*U(:,2);D2*V(:,2)];

%% use many
Z = []

[idx,~] = kmeans(Z,numCluster);
end