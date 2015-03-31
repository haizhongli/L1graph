function [IDX,egs,evecs] = spectralClustering(W,k)
% Spectral Clustering algorithm. 
%
% input: 
%   W -- similarity matrix
%   k -- number of clsuters
% ouput:
%   h -- numbers

D = sum(W,2);
D = diag(D);
D = D^(-1/2);
L =  D*W*D;
[evecs,egs] = eigs(sparse(L),k,'LR');
%[egss,ids] = sort(diag(egs),'descend');
[egss,ids] = sort(diag(egs),'descend');
%figure, plot(egss(1:k),'-*');
evecs = evecs(:,ids(1:end));
evecs = NMRow(evecs); %abandoned the first eigenvalue/vectors
IDX = kmeans(evecs,k);
%[ctrs,~,~] = WCSSKmeans(evecs,k,50,50);
%IDX = findlabels(ctrs,evecs);
end
