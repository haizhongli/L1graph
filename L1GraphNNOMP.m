function [W] = L1GraphNNOMP(Data,DictIdx)
% Calculate the L1 Graph by Nonnegative OMP (NNOMP)
%
% input:
%   Data    --  row: samples, column: features; Row normalized. 
%   DictIdx --  row index of dictionary.
% output:
%   W       --  sparse graph
% 
% requires:
%    NNOMP.m
%

%% get the dictionary
N = size(Data,1);
D = Data(DictIdx,:)';
Data(DictIdx,:) = [];
%k_target = floor(size(Data,2)/4);
k_target = 2;

non_dict_ids = 1:N;
non_dict_ids(DictIdx) = [];

%% calcualte sparse coding
num = size(Data,1);
G = zeros(num,length(DictIdx));
for i = 1:num
    x = Data(i,:)';
    %errFcn = @(a) norm(a-x)/norm(x);
    [xk] = NNOMP(x,D,k_target);
    G(i,:) = xk';
end

%% store to a sparse graph
[i,j,v] = find(G);
for k = 1:length(i)
    i(k) = non_dict_ids(i(k));
end
for k =1:length(j)
    j(k) = DictIdx(j(k));
end
W = sparse(i,j,v,N,N);
W = W + W'; %%make symmetry

end