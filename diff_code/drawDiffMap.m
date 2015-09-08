function [X,eigenvals] = drawDiffMap(data)
% draw the diffucion map
%
%
D=squareform(pdist(data)); % pairwise distances, n-by-n matrix

%--------------------------------------------------------------------
% CHECK THE DISTRIBUTION OF NEAREST NEIGHBORS
%--------------------------------------------------------------------
test_flag=1;
if test_flag % Estimate distribution of k-nearest neighbor
    D_sort = sort(D,2);
    k=30, %30;
    dist_knn = D_sort(:,1+k);  % distance to k-nn
    median_val = median(dist_knn), eps_val = median_val^2/2,
    sigmaK = sqrt(2)*median_val;
    figure, hist(dist_knn); colormap cool;
    title('Distribution of distance to k-NN');
end

% Call function "diffuse.m"
neigen = 3;
[X, eigenvals, ~, ~] = diffuse(D,eps_val,neigen);

figure, % Diffusion map
scatter3(X(:,1),X(:,2),X(:,3),10,'b'); 
title('Embedding with first 3 diffusion coordinates');
xlabel('X_1'); ylabel('X_2'); zlabel('X_3');


end