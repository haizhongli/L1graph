%%this scripe is used to test the time efficiency of L1kNN graph and original L1-graph
%
% experiment design:
%   check the time of L1kNN with increasing K.


%generate data
data = rand(50,5001);
nA = NMRow(data);
time_all = zeros(20,1);

%L1-kNN
T = [2,5,10,20,30,40,50]
for i = 1:length(T)
    t0 = cputime;
    K = T(i) * size(data,1);
    W = L1GraphKNNFastNoise(nA,K);
    t1 = cputime;
    time_all(i) = t1 - t0;
end
