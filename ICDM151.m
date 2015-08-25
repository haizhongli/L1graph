addpath('./export_fig');

%[W_l1,NZ_l1] = L1Graph(data',0.1);


% lop l1
K = 10;
dt = squareform(pdist(data));
[~,nb] = mink(dt,K+1,2);
nb(:,1) =[];
[W_l1,~] = L1GraphKNN(data',nb,K,0.1);
%[W_l1] = L1GraphKNNGreedy(data',nb,1e-5);

% lop-l1-diff
% K = 10;
% R = ManifoldRanking(data',0.5,0.1);
% [~,nb] = maxk(R,K,1);
% nb = nb';
% %[W_l1,~] = L1GraphKNN(data',nb,K,0.1);
% [W_l1] = L1GraphKNNGreedy(data',nb,1e-5);

%remove small coefficient
W_l1(W_l1<0.0001) = 0;
W = (W_l1 + W_l1')/2;

figure,wgPlot(W,data,'vertexMarker','o','edgeColorMap',jet);

% figure, wgPlot(W,data,'g');
% hold on
% plot(data(:,1),data(:,2),'o')
% hold off


%export_fig 'knn_graph' -pdf -transparent