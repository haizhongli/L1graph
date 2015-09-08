addpath('./MinMaxSelection');
addpath('./ZPclustering');


[W_l1,~] = L1Graph(data',0.1);
W_l1(W_l1<0.0001) = 0;
W_l1_graph = (W_l1 + W_l1')/2;

% lop l1
K = 10;
% dt = squareform(pdist(data));
% [~,nb] = mink(dt,K+1,2);
% nb(:,1) =[];
% [W_lop,~] = L1GraphKNN(data',nb,K,0.1);
%[W_l1] = L1GraphKNNGreedy(data',nb,1e-5);

% sa-l1
N = size(data,1);
dt = squareform(pdist(data));
[dt_v,~] = mink(dt,K+1,2);
median_val = median(dt_v(:,K+1));
W_st = exp(-dt.^2/(2*median_val^2));
W_st(logical(eye(N))) = 0;
R = ManifoldRankingV1(W_st,0.1);
[~,nb] = maxk(R,K,1);
nb = nb';
[W_l1,~] = L1GraphKNN(data',nb,K,0.1);

%remove small coefficient
W_l1(W_l1<0.0001) = 0;
W_diff = (W_l1 + W_l1')/2;

%figure,wgPlot(W,data,'vertexMarker','o','edgeColorMap',jet);

% figure, wgPlot(W,data,'g');
% hold on
% plot(data(:,1),data(:,2),'o')
% hold off


%export_fig 'knn_graph' -pdf -transparent