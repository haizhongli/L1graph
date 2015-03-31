
%%this scripe is used to test the time efficiency of L1kNN graph and original L1-graph
%
% experiment design: 

addpath('./l1_ls_matlab/l1_ls_matlab/');

time_all = zeros(200,2);

T =100;

for i = 1:5:T
    data = rand(50,i*100+1);
    nA = NMRow(data);
    
    % l1 graph  
    t0 = cputime;
    W = L1GraphNoise(nA);
    t1 = cputime;
    time_all(i,1) = t1-t0;
   
    %l1-knn, with fixed neighbors equal to 100
    t0 = cputime;
    W = L1GraphKNNFastNoise(nA,100);
    t1 = cputime;
    time_all(i,2) = t1 - t0;
end
