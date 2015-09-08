function [W] = KNNGraph(data,K)

addpath('./MinMaxSelection');

dt = squareform(pdist(data));
[~,idx] = mink(dt,K,2);

n = size(data,1);
W = zeros(n);
for i = 1:n
    W(i,idx(i,:)) = 1;
end
end