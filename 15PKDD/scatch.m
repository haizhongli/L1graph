id = 107;
figure, gplot(W,Data,'-*');
figure,scatter(Data(:,1),Data(:,2),[],diff_matrix(id,:));
hold on;
plot(Data(id,1),Data(id,2),'r+');
hold off


W = L1GraphDiffKnn(Data,diff_matrix,10);
figure, gplot(W,Data,'-*');