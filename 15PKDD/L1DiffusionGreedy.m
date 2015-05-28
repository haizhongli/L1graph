function [diff_matrix,aff_matrix] = L1DiffusionGreedy(data)
% calcualte the diffusion use ICG code. 
% Dr. Michael Donoser
% http://vh.icg.tugraz.at/index.php?content=topics/diffusion.php
%
% input:
%     data --   'n x m' matrix; n: observation, m: variables
%

addpath('../export_fig');
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1');
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1/HelpFunctions');
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1/MinMaxSelection');

%% calculate distance matrix
dist_matrix = squareform(pdist(data));

%% diffusion
num_knn = 10;
[diff_matrix,aff_matrix] = ICG_ApplyDiffusionProcess(dist_matrix,nan,num_knn,0);

%% change the diffusion value at diagnoal to zero
diff_matrix(logical(eye(size(diff_matrix,1)))) = 0;

end
