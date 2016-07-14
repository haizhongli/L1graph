function ICG_ExampleDiffusionProcess
% ICG_ExampleDiffusionProcess demonstrates how to apply a diffusion process
%   on an affinity matrix (two data sets:MPEG-7 and DUBROVNIK)
%   See also ICG_ApplyDiffusionProcessOnHugeMatrices
%
%   For more details see:
%   "Diffusion Processes for Retrieval Revisited"
%   Michael Donoser and Horst Bischof
%   Proceedings of Conference on Computer Vision 
%   and Pattern Recognition (CVPR), 2013
%
%   ****************************************************************
%	Copyright by Michael Donoser 
%	Institute for Computer Graphics and Vision
%	Graz University of Technology
%   Please email to michael.donoser@tugraz.at 
%   if you find bugs, or have suggestions or questions!
%   Licensed under the Lesser GPL [see License/lgpl.txt]
%   ****************************************************************

    addpath('HelpFunctions');

    %% load first data set
    % MPEG-7 shape silhouettes
    % Affinites provided by "Articulation-invariant representation of 
    % non-planar shapes" from Gopolan et al., ECCV 2010 
    Diff = [];labels = [];
    load('./Data/MPEG7');
    disp('*** Retrieval experiment on MPEG-7 dataset (~1 sec) ***');
    
    % Estimate current ranking quality
    bullseye_baseline = ICG_RetrievalBullsEyeScore(Diff,labels, 40);
    
    % Apply the diffusion - takes 1 second on my desktop PC
    tic;
    [diffused_matrix aff_matrix] = ICG_ApplyDiffusionProcess(Diff);
    time_required = toc;
    
    % Estimate new ranking quality
    bullseye_diffused = ICG_RetrievalBullsEyeScore(diffused_matrix,labels, 40);
    
    
    disp(['Retrieval quality changed from ' num2str(bullseye_baseline) ' to ' ...
        num2str(bullseye_diffused) ' after diffusion of the ' num2str(size(Diff,1)) ...
        ' x ' num2str(size(Diff,2)) ' matrix and took ' num2str(time_required) ...
        ' seconds.']);
    disp('*** Retrieval experiment on MPEG-7 dataset finished ***');
    
    %% Visualize some results of the diffusion
    query_ids = [99 474 748 1115];
    disp('*** Visualize specific retrieval results ***');
    ICG_VisualizeRetrievalImprovements(query_ids,aff_matrix,diffused_matrix,labels);
    disp('*** Visualization finished ***');
    
    %% load second data set
    % DUBROVNIK data set from 
    % "Location Recognition using Prioritized Feature Matching"
    % Yunpeng Li, Noah Snavely, Dan Huttenlocher
    % 3D point cloud is compressed with a min-k Cover algorithm
    desc_list = []; label_list = [];
    load('./Data/DUBROVNIK');
    disp('*** Retrieval experiment on DUBROVNIK dataset (~15 sec)');
    
    % Get first K elements of data set and calculate Euclidean distance
    % IMPORTANT: THIS FUNCTION BUILDS A DENSE (!) AFFINITY MATRIX
    % THUS THE NUMBER OF ELEMENTS SHOULD NOT BE TOO LARGE
    % FOR REAL LARGE SCALE DATA ANALYSIS USE ICG_ApplyDiffusionProcessOnHugeMatrices
    % WHICH IS BASED ON NEAREST NEIGHBOR SEARCH AND DOES NOT REQUIRE A DENSE
    % AFFINITY MATRIX!
    NR_ELEMS_TO_CONSIDER = 15000;
    sub_desc = desc_list(1:NR_ELEMS_TO_CONSIDER,:);
    sub_labels = label_list(1:NR_ELEMS_TO_CONSIDER);
    clear desc_list; clear label_list;
    
    % Build dense affinity matrix
    diff_matrix = pdist2(sub_desc,sub_desc);
    
    % Estimate current ranking quality
    bullseye_baseline = ICG_RelativeRetrievalBullsEyeScore(diff_matrix,sub_labels, 1);
    
    % Apply the diffusion - takes 12.5 seconds on my PC
    tic;
    diffused_matrix = ICG_ApplyDiffusionProcess(diff_matrix);
    time_required = toc;
    
    % Estimate new ranking quality
    bullseye_diffused = ICG_RelativeRetrievalBullsEyeScore(diffused_matrix,sub_labels, 1);
    
    
    disp(['Retrieval quality changed from ' num2str(bullseye_baseline) ' to ' ...
        num2str(bullseye_diffused) ' after diffusion of the ' num2str(size(diff_matrix,1)) ...
        ' x ' num2str(size(diff_matrix,2)) ' matrix and took ' num2str(time_required) ...
        ' seconds.']);
    disp('*** Retrieval experiment on DUBROVNIK dataset finished');