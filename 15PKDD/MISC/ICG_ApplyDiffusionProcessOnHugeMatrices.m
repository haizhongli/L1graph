function [diffused_matrix aff_matrix] = ICG_ApplyDiffusionProcessOnHugeMatrices(sub_desc, NR_OF_KNN)
% diffused_matrix = ICG_ApplyDiffusionProcessOnHugeMatrices(sub_desc, sigma,NR_OF_KNN)
%   ICG_ApplyDiffusionProcessOnHugeMatrices is a diffusion variant, which 
%   works on sparse affinity matrices. We require an efficient nearest
%   neighbor algorithm, to build the sparse matrix
%   in this case we use the vl_feat Toolbox
%
%   The core idea is to constrain the diffusion consistently to a specific
%   number of nearest neighbors. In such a way, we can guarantee maximum
%   memory demands and potentially diffuse even huge matrices. Adapt
%   hard coded MAX_NR_OF_AFF_VALUES considering your memory profile
%   
%   Parameter
%   ---------
%   sub_desc ... N x D data points to diffuse
%   NR_OF_KNN ... the number of k-nearset neighbors to use
%
%   Return Value
%   ------------
%   diffused_matrix ... The N x N sparse, diffused matrix
%   aff_matrix ... The N x N sparse, undiffused affinity matrix
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

    diffused_matrix = [];aff_matrix = [];
    addpath('./MinMaxSelection');
    if ~exist('maxk','file')
        % We require the efficient Min/Max selection tool by Bruno Luong
         unzip('http://www.mathworks.com/matlabcentral/fileexchange/23576-minmax-selection?download=true');
         addpath('./MinMaxSelection');
         pause(1);
         minmax_install
    end
    
    if ~exist('vl_kdtreebuild','file')
        disp('***ERROR!!!!!!!');
        disp('***VL-Feat Toolbox has to be installed for identifying nearest neighbors***');
        disp('***Download at http://www.vlfeat.org/***');
        return;
    end
    
    if ~exist('NR_OF_KNN','var')
         NR_OF_KNN = 10;
    end
    
    % Build KD Tree
    kdtree = vl_kdtreebuild(sub_desc');
    
    % Get NR_OF_KNN nearest neighbors
    disp('Calculate all nearest neighbors - this takes some time');
    [indices dists] = vl_kdtreequery(kdtree,sub_desc',sub_desc','numneighbors',NR_OF_KNN, ...
       'MaxNumComparisons',NR_OF_KNN);
    
    % Build sparse affinity matrix
    indices = indices';
    dists = dists';
    aff_matrix = sparse(size(indices,1),size(indices,1),0);
    inds = repmat((1:size(indices,1)),[size(indices,2) 1])';
    
    % Normalize to affinity matrix
    sigmas_i = dists(:,NR_OF_KNN);
    aff_matrix(sub2ind(size(aff_matrix),inds(:),double(indices(:)))) = ...
        exp((-(dists(:).^2)) ./ (sigmas_i(inds(:)).*sigmas_i(indices(:))));
     
    % Build transition matrix 
    PNN_matrix = ICG_MatNormalizeRow(aff_matrix);
    
    %% Diffusion Process starts here
    curr_mat = PNN_matrix;
    transposed_PNN_matrix = PNN_matrix';
    
    % Maximum number of iterations
    NR_ITERATIONS = 15;
    
    % Save ranking to define the stopping criterion
    old_ranks = indices;
    
    % Approximately defines the memory demands - runs well on my 8 GB PC
    MAX_NR_OF_AFF_VALUES = 2000000;
    REL_OFFSET = floor(MAX_NR_OF_AFF_VALUES / (size(aff_matrix,1)*NR_OF_KNN));
    
    average_nr_of_changed_ranks = zeros(1,NR_ITERATIONS);
    similar = zeros(size(aff_matrix,1),1);
    for iter_nr = 1 : NR_ITERATIONS
        % Update step
        curr_mat = PNN_matrix * curr_mat * transposed_PNN_matrix;
            
        %  Check how much is changed in the ranking
        [vals, ranks] = maxk(curr_mat, size(indices,2)*REL_OFFSET, 2 );
        for s = 1 : size(ranks,1)
            similar(s) = length(intersect(ranks(s,1:size(indices,2)),old_ranks(s,size(indices,2))));
        end
        old_ranks = ranks;
        average_nr_of_changed_ranks(iter_nr) = mean(similar);
        
        % constrain diffusion to the nearest neighbors (due to memory limitations)
        inds = repmat((1:size(ranks,1)),[size(ranks,2) 1])';
        curr_mat = sparse(inds(:),ranks(:),vals(:),size(aff_matrix,1), ...
            size(aff_matrix,2),numel(vals));
        
        % Stopping criterion, checks change in rankings
        STOPPING_CRITERION = 0.3;
        if (iter_nr > 1) && (average_nr_of_changed_ranks(iter_nr) - average_nr_of_changed_ranks(iter_nr-1) < STOPPING_CRITERION)
            break;
        end
    end
    % Final step of full diffusion
    diffused_matrix = PNN_matrix * curr_mat * transposed_PNN_matrix;
    
    
     