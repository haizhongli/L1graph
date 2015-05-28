function ICG_ExampleLargeScaleDiffusionProcess
% ICG_ExampleLargeScaleDiffusionProcess demonstrates how to apply 
%   a diffusion process for sparse matrix analysis, i.e. if we aim at 
%   handling  large scale data sets. Data is from the Dubrovnik data set.
%   see ICG_ExampleDiffusionProcess
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

    disp('*** Retrieval experiment on DUBROVNIK - Large scale (~380 sec)');    
    addpath('HelpFunctions');

    % load data
    % DUBROVNIK data set from 
    % "Location Recognition using Prioritized Feature Matching"
    % Yunpeng Li, Noah Snavely, Dan Huttenlocher
    % 3D point cloud is compressed with a min-k Cover algorithm
    desc_list = []; label_list = [];
    load('./Data/DUBROVNIK');
    
    % Get first 100000 elements of data set
    NR_ELEMS_TO_CONSIDER = 100000;
    sub_desc = desc_list(1:NR_ELEMS_TO_CONSIDER,:);
    sub_labels = label_list(1:NR_ELEMS_TO_CONSIDER);
    clear desc_list; clear label_list;
       
    % Apply the diffusion
    tic;
    [diffused_matrix aff_matrix] = ICG_ApplyDiffusionProcessOnHugeMatrices(sub_desc);
    time_required = toc;

    % Estimate new ranking quality
    bullseye_diffused = ICG_RelativeRetrievalBullsEyeScore(diffused_matrix,sub_labels, 1);
    bullseye_baseline = ICG_RelativeRetrievalBullsEyeScore(aff_matrix,sub_labels, 1);
    
    disp(['Retrieval quality changed from ' num2str(bullseye_baseline) ' to ' ...
        num2str(bullseye_diffused) ' after diffusion of the ' num2str(size(aff_matrix,1)) ...
        ' x ' num2str(size(aff_matrix,2)) ' matrix and took ' num2str(time_required) ...
        ' seconds.']);
    disp('*** Retrieval experiment on DUBROVNIK - Large scale');