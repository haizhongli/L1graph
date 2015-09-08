dt = squareform(pdist(data));

D_sort = sort(dt,2);
k=10, %30;
dist_knn = D_sort(:,1+k);  % distance to k-nn
median_val = median(dist_knn);
sigma = 2*median_val^2;
M = exp(-dt.^2 ./ sigma);
%M = M - eye(size(data,1));

R = ManifoldRankingV1(M,0.99);


