%% This is the demo code for the paper: 
%% Xingwei Yang and Longin Jan Latecki. Affinity Learning on a Tensor Product Graph with Applications to Shape and Image Retrieval. 
%% IEEE Conf. on Computer Vision and Pattern Recognition (CVPR), Colorado Springs, June 2011
%% If your input is an affinity matrix, set:
intputAffinity=1;
%% otherwise set intputAffinity=0;

if intputAffinity==1
    %% The input can be any affinity matrix such that the sum of each row is <1.
    load VisualPartsAffinityMatrix.mat
    %% (This example uses the distances and affinities based on Viual Parts shape distance by 
    %% Latecki, et al. Shape Descriptors for Non-rigid Shapes with a Single Closed Contour. CVPR 2000)
    
    %% Iterative Algorithm for Diffusion on TPG, Formula 6 in the paper, number of iterations is set to 200
    K2 = 10;
    [newW]=IterativeDiffusionTPG(W,K2);
    
    %% Calculate the bull's eye score
    %% (you should get Score = 0.9140, the score of original distances is 0.7646)
    Score = ObtainBullsEyeScore(newW)
end


if intputAffinity==0
    %% The input is a matrix of pairwise distances and an affinity will be first created. It may take like 20 minutes!
    load VisualPartsMatrix.mat;
    
    %% We use the method describe in Section 5 of Yang, et al., Improving Shape Retrieval by Learning Graph Transduction. ECCV 2008,
    %% for obtaining affinity matrix
    [W,SimMatrix] = ObtainAffinityMatrix(Diff);
    
    %% The function to calculate the dominant neighbors
    K1 = 10;
    SimMatrix = SimMatrix/(max(SimMatrix(:)));
    Thresh = 0.0001;
    stop_th = 0.000000001;
    select_th = 0;
    
    P = DominantNeighbors(SimMatrix,Thresh, stop_th, select_th,K1);
    P2=P|P'+eye(length(W));
    W=W.*P2;
    
    %% Iterative Algorithm for Diffusion on TPG, Formula 6 in the paper
    K2 = 10;
    [newW]=IterativeDiffusionTPG(W,K2);
    
    %% Calculate the bull's eye score
    Score = ObtainBullsEyeScore(newW);
end
