 function [G] = L1GraphCoSaMPHeat(data,dictIdx)
% build the L1 graph by using CoSaMP with random dictionary 
% construction.
%
% input:
%   data -- row: samples, column: observations;
%   dictIdx -- index of dictionarys,  1 <= dictIdx <= size(row,1).
% output:
%   G  -- a sparse graph of data.
%

%% get the dictionary
D = data(dictIdx,:)';
data(dictIdx,:) = [];
k_target = floor(size(data,2)/4);

%% CoSaMP parameters
opts            = [];
opts.maxiter    = 50;
opts.tol        = 1e-8;
opts.HSS        = true;
opts.two_solves = true; % this can help, but no longer always works "perfectly" on noiseless data
opts.printEvery = 10;


%% calcualte sparse coding
num = size(data,1);
G = zeros(num,length(dictIdx));
for i = 1:num
    x = data(i,:)';
    %errFcn = @(a) norm(a-x)/norm(x);
    [xk] = CoSaMP(D,x,k_target,[],opts);
    G(i,:) = xk';
end

end