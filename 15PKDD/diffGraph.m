function [h,R] = diffGraph(K, Data, aff_matrix, diff_matrix)
% 
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1/MinMaxSelection');

[n,m] = size(Data); % n: #samples

Wknn = zeros(n);
Wdiff = zeros(n);
% kNN and Diff graph
for i = 1:n
    [~,knn_loc] = maxk(aff_matrix(i,:),K);
    [~,diff_loc] = maxk(diff_matrix(i,:),K);
    Wknn(i,knn_loc) = 1;
    Wdiff(i,diff_loc) = 1;
end

WWknn = Wknn .* aff_matrix;
WWdiff = Wdiff .* diff_matrix;
[Wl1,R] = L1GraphDiffKnn(Data,diff_matrix,4*K);
%Wl1cs = L1GraphDiffKnnCS(Data,diff_matrix,K);
%% draw
figure, gplot(WWknn,Data,'-*'); 
title('KNN');
figure, gplot(WWdiff,Data,'-*');
title('Diffusion kNN');
figure, gplot(Wl1,Data,'-*');
title('Diffusion L1 greedy');

%figure, gplot(Wl1cs,Data,'-*');
%title('Diffusion L1 convex set');

h = 1;
end