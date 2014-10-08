function plotV(V, d, ClusterLabels, ind, methods)
figure,
if d>=3
    scatter3(V(ind,1),V(ind,2),V(ind,3),132,ClusterLabels(ind),'filled');
elseif d==2
    scatter(V(ind,1),V(ind,2),132,ClusterLabels(ind),'filled');
end

title(methods);