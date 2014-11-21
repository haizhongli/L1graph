function [hts] = HeatKernelSignature(data,t)
% calcualte the heat kernel Signature of a given dataset
%
% input:
%   data -- row: samples, columns: feature. Assume data are row normalized.
% output:
%   hts  -- heat kernel signature values of each sample.
% 
% requirements:
%   Density Preserving Sampling(DPS) code is requried.
%    http://www.mathworks.com/matlabcentral/fileexchange/
%    39390-density-preserving-sampling--dps--deterministic-crossvalidation
%
%

% normalize data
%data = NMRow(data); 
N = size(data,1); %%  row means number of samples

% calculate the cosine similarity graph
W = squareform(pdist(data,'cosine'));

% calculate the laplacian, use L-sym
D = diag(1 ./ sqrt(sum(W,2)));
L = eye(N) - D*W*D;

% eigen decomposition
[evecs,egs] = eig(L);

% calculate heat kernel signature.
lamda = real(diag(egs));
hts =  evecs.^2 * exp(-lamda*t);
end