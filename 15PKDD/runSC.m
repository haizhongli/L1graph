%% this script is about to run spectral clustering over the datasets
%

addpath('../');
addpath('../15PKDD');
addpath('../knnsearch');
addpath('../l1_ls_matlab/l1_ls_matlab');
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1');
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1/HelpFunctions');
addpath('./DIFFUSION_PACKAGE_CVPR_2013_V1_1/MinMaxSelection');

data_names = {%'path.mat', ...
              'BreastTissue.mat', ...
              'iris.mat', ...
              'wine.mat', ...
              'soybean1.mat', ...
              'glass.mat', ...
              'vehicle.mat', ...
              'Image.mat'};
aff_names = {'Wgau','Wknn','Wl1knn','Wdiff','Wdiffknn','Wl1diffknn'};

K = 10;


N = length(data_names);
ac_info = zeros(N,6);
nmi_info = zeros(N,6);

for i = 1:N
data_names(i)
load(char(data_names(1)));
G = build_graphs(Data,K,3);
    for j = 1:6
        aff_names(j)
        idx = spectralClustering(full(G.(char(aff_names(j)))),NumC);
        res = bestMap(ClusterLabels,idx);
        ac_info(i,j) = length(find(ClusterLabels == res))/length(ClusterLabels);
        nmi_info(i,j) = MutualInfo(ClusterLabels,res);
    end;
end
