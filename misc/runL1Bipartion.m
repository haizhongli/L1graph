

%load vehicle

%% set parameters
num_cluster = NumC;
dict_idx = did;



%% build and draw
G = W;%L1GraphNNOMPBiP(Data,dict_idx);
c_idx = Bipartition(G,num_cluster);

% color_list = jet(num_cluster);
% figure, 
% for i = 1:num_cluster
%     ids = find(c_idx == i);
%     plot(Data(ids,1),Data(ids,2),'s','MarkerFaceColor',color_list(i,:));
%     hold on;
% end


nmi_val = eval_nmi(ClusterLabels,c_idx);
fprintf('NMI is:%.4f\n',nmi_val);
[AA,~,~]=AccMeasure(ClusterLabels,c_idx);
fprintf('AC is: %.4f\n', AA/100);
