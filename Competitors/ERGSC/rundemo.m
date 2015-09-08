clear all; %close all; %clc;
format long;
addpath('../data/Synthetic', '../data/Clustering', '../SelfTuning', '../SCDA', '../NJW', '../DMM', '../Basic', '../HKM');


% load ('Data6.mat');
% Data = cell2mat(XX(4));
% NumC=group_num(4);
% load ('result4.mat');
% ClusterLabels=ClusterLable';

%load ('1_skeleton_example.mat');
load ('iris.mat');

[nrow, ncol] = size(Data);

GorL=0;
pD=0.1;%0.1;
pC=1;
NIter=2;

EuDis = CompED(Data);


%[connect,dist] = Gabriel(Data,EuDis); 
beta=1.5;
[connect,dist] = BetaSkeleton(Data,beta, EuDis); %% get the beta skeleton graph. connect is a nxn binary mateix, if connect=1 means there is connection. dist is a nxn distance matrix. if there is no connection, dist=0; 

Neighbors = sum (connect,2); % nx1 vector: the number of neighbors

G1 =  Gaussian(EuDis, GorL,pD); 

[LocalScaleM index] = LocalScalingM(dist, Neighbors, 'mean'); % localscaleM (nx1) is the initial sigma

for t = 1 : NIter;
    LocalScaleMnew = zeros(nrow,1);
    DifLS=zeros(nrow, nrow);
    for i = 1 : nrow-1
        for j = i+1 : nrow
            DifLS(i,j) = abs(LocalScaleM(i)-LocalScaleM(j));
        end
    end
    DifLS = max (DifLS, DifLS');
    G2 =  Gaussian(DifLS, GorL,pC);
    G = G1.*G2;
    %G = G-diag(diag(G));
    W =  NormPositiveRW(G);
    for i = 1 : nrow
        TempSelf = W(i,i)/LocalScaleM(i);
        LocalScaleMnew(i) = (sum(   W(i, index(i,1:Neighbors(i)))' ./ LocalScaleM(index(i,1:Neighbors(i)))  ) +TempSelf)^(-1);
    end    
    LocalScaleM=LocalScaleMnew;
end


Aff = exp (   -((EuDis.^2)  ./ (LocalScaleMnew*LocalScaleMnew'))  );
%Aff = Aff - diag(diag(Aff));


Aff2=NormalizationFamily(Aff,-0.5); % normalize Affinity matrix 
[D2, V2]=NJW(Aff2,NumC); % NJW 
[newctrs, ctrssize, quality] =   WCSSKmeans(V2, NumC, 500, 500); 
ClusteringResult = findlabels(newctrs, V2);
eval_nmi(ClusterLabels, ClusteringResult)
