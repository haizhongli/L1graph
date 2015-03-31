ClusterLabels = zeros(7291,1);
for i = 1:10
   ids = find(train_labels(i,:)==1);
   ClusterLabels(ids) = i; 
end