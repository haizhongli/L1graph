function [ M ] = myGaussianMedian(data)
% Gaussian Similarity 
% we set parameter sigma as the median of following values:
%   || x_i - sum(x_i)/n||^2, i = 1,2,...n.
%
% input:
%   data   --- row: instances; column: features;
% output:
%   M   --- guassian similarity matrix
%
% author: shhan@cs.stonybrook.edu
% date: 12/04/2014

%% find "sigma" by check the median

% calculate the arthemetic mean
arth_mean = sum(data,1)/size(data,1);
dist = data - repmat(arth_mean,size(data,1),1);
sigma = median(sum(dist.^2,2))

eu_dist = squareform(pdist(data));
M = exp(-eu_dist.^2 ./ sigma);
M = M - eye(size(data,1));
end