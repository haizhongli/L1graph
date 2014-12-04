function [M] = myCosineSim(data)
% cosine similarity of data
%
% input: 
%   data -- row: instances, column: features;
% output:
%   M -- similarity matrix;
%

dist = squareform(pdist(data,'cosine'));
M = 1 - dist;
M = M - eye(size(data,1));
end